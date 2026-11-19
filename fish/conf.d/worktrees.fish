# Git worktree helpers. Worktrees are created as siblings of the main checkout,
# named <repo>-<branch> (e.g. ~/Code/platform/platform-scp-EE-684).

# Emit "<branch>\t<path>" for each worktree, main checkout first.
function __wt_entries
    set -l wt_path
    set -l wt_branch
    git worktree list --porcelain 2>/dev/null | while read -l line
        switch $line
            case 'worktree *'
                set wt_path (string replace 'worktree ' '' -- $line)
            case 'branch *'
                set wt_branch (string replace 'branch refs/heads/' '' -- $line)
            case detached
                set wt_branch '(detached)'
            case bare
                set wt_path ''
            case ''
                test -n "$wt_path"; and printf '%s\t%s\n' $wt_branch $wt_path
                set wt_path ''
                set wt_branch ''
        end
    end
end

# Resolve a branch or directory name to a worktree path, or fzf-pick one.
function __wt_resolve
    set -l entries (__wt_entries)
    if test (count $argv) -eq 0
        printf '%s\n' $entries | fzf --delimiter \t --with-nth 1,2 --height 40% --reverse \
            --preview 'git -C {2} log --oneline --color=always -n 20' | cut -f2
        return
    end
    for e in $entries
        set -l parts (string split \t -- $e)
        if test "$parts[1]" = $argv[1]; or test (path basename $parts[2]) = $argv[1]
            echo $parts[2]
            return
        end
    end
    return 1
end

function wtl -d "List git worktrees"
    git worktree list $argv
end

function wt -d "Switch to a git worktree, creating it if needed: wt [branch] [base]"
    git rev-parse --git-dir >/dev/null 2>&1; or begin
        echo "wt: not in a git repository" >&2
        return 1
    end

    set -l target (__wt_resolve $argv[1])
    if test -z "$target"
        test (count $argv) -eq 0; and return 0 # fzf cancelled

        set -l name $argv[1]
        set -l main (__wt_entries | head -n1 | cut -f2)
        set target (path dirname $main)/(path basename $main)-(string replace -a / - -- $name)

        if git show-ref --quiet --verify refs/heads/$name; or git show-ref --quiet --verify refs/remotes/origin/$name
            git worktree add $target $name; or return
        else
            git worktree add -b $name $target $argv[2..]; or return
        end
    end
    cd $target
end

function wtrm -d "Remove a git worktree (fzf picker if no name given): wtrm [-f] [name]"
    argparse f/force -- $argv; or return
    set -l target (__wt_resolve $argv)
    test -n "$target"; or begin
        test (count $argv) -gt 0; and echo "wtrm: no worktree matching '$argv[1]'" >&2
        return 1
    end

    set -l main (__wt_entries | head -n1 | cut -f2)
    if test "$target" = "$main"
        echo "wtrm: refusing to remove the main worktree" >&2
        return 1
    end

    # Step out of the worktree before removing it
    if test "$PWD" = "$target"; or string match -q -- "$target/*" $PWD
        cd $main
    end
    git worktree remove $_flag_force $target
end

function __wt_complete
    __wt_entries | string replace -r '\t.*' '\tworktree'
    git for-each-ref --format='%(refname:short)' refs/heads 2>/dev/null
end

complete -c wt -f -n '__fish_is_first_arg' -a '(__wt_complete)'
complete -c wtrm -f -a '(__wt_entries | tail -n +2 | string replace -r "\t.*" "\tworktree")'
complete -c wtrm -s f -l force -d 'Remove even if dirty'

# Route `git wt|wtl|wtrm` (and `g wt` via the abbr) to the functions above.
# These can't be real git aliases: git runs aliases in a subshell, so they
# can't change the current shell's directory.
function git
    switch "$argv[1]"
        case wt wtl wtrm
            $argv[1] $argv[2..]
        case '*'
            command git $argv
    end
end

complete -c git -f -n __fish_use_subcommand -a wt -d 'Switch to/create worktree'
complete -c git -f -n __fish_use_subcommand -a wtl -d 'List worktrees'
complete -c git -f -n __fish_use_subcommand -a wtrm -d 'Remove worktree'
complete -c git -f -n '__fish_seen_subcommand_from wt' -a '(__wt_complete)'
complete -c git -f -n '__fish_seen_subcommand_from wtrm' -a '(__wt_entries | tail -n +2 | string replace -r "\t.*" "\tworktree")'
