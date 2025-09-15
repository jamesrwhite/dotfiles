alias json 'jq -C .'
alias page 'less -R'
alias mk minikube
alias tf terraform
alias flushdns "sudo killall -HUP mDNSResponder"
alias copy pbcopy
alias dsusage ncdu
alias dc docker-compose
alias d docker
alias md macdown
alias cat bat
alias ping "prettyping --nolegend"
alias c code
alias m gmake
alias make gmake
alias l "lsd --icon never"
alias ls "lsd --icon never"
alias ll "lsd -alF --icon never"

# git
alias g git
alias gs "git status"
alias ga "git add"
alias gc "git commit -m"
alias grb "git rebase"
alias gd "git diff"
alias gu "git pull --rebase --autostash"
alias gp "git push"

# k8s
abbr --add k kubectl
abbr --add kn kubens
abbr --add kc kubectx
abbr --add unset 'set --erase'
abbr --add kd 'kubectl describe'
abbr --add kg 'kubectl get'
abbr --add pods 'kubectl get pods --sort-by=.metadata.creationTimestamp'
abbr --add nodes 'kubectl get nodes --label-columns=topology.kubernetes.io/zone,type,lifecycle,karpenter.sh/capacity-type,karpenter.sh/provisioner-name,eks.amazonaws.com/nodegroup,kubernetes.io/arch,node.kubernetes.io/instance-type --sort-by={.metadata.creationTimestamp}'
abbr --add ip ipinfo
abbr --add c2ip ipinfo cidr2ip
