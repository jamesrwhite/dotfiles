function mkcd
    mkdir -p $argv && cd $argv
end

function b64d
    echo -n $argv | base64 --decode
end

function b64
    echo -n $argv | base64
end

function ql
    qlmanage -p $argv
end

function dotenv
    if test (count $argv) -eq 0
        echo "Error: dotenv requires a path argument" >&2
        return 1
    end
    for line in (cat $argv | grep -v '^#')
        set item (string split -m 1 '=' $line)
        set -gx $item[1] $item[2]
    end
end

function cld
    set -l path $argv[1]
    if test -z "$path"
        set path (pwd)
    end
    open "claude://code/new?folder=$path"
end

function lsport --description 'List processes listening on a local port'
    if test (count $argv) -eq 0
        echo "Usage: lsport <port> [port ...]" >&2
        return 1
    end

    for port in $argv
        lsof -i tcp:$port -sTCP:LISTEN
    end
end

function kport --description 'Kill all processes listening on a local port'
    if test (count $argv) -eq 0
        echo "Usage: kport <port> [port ...]" >&2
        return 1
    end

    for port in $argv
        set -l pids (lsof -ti tcp:$port -sTCP:LISTEN)
        if test -z "$pids"
            echo "No process listening on port $port" >&2
            continue
        end
        # Kill the whole process group, not just the listening PID - a
        # supervisor (e.g. `wrangler dev`) will otherwise just respawn it.
        set -l pgids (ps -o pgid= -p $pids | string trim | sort -u)
        for pid in $pids
            echo "Killing PID $pid (port $port)"
        end
        for pgid in $pgids
            kill -9 -$pgid
        end
    end
end

