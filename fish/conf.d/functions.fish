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

