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
