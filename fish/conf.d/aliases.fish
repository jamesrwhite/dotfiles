alias make gmake
alias l 'lsd --icon never'
alias ls 'lsd --icon never'
alias ll 'lsd -alF --icon never'
alias cat 'bat --paging=never'
alias flushdns 'sudo killall -HUP mDNSResponder'
alias json 'jq -C .'

abbr --add m make
abbr --add page 'less -R'
abbr --add mk minikube
abbr --add tf terraform
abbr --add copy pbcopy
abbr --add dsusage ncdu
abbr --add dc docker-compose
abbr --add d docker

abbr --add ping 'prettyping --nolegend'
abbr --add c code

# git
abbr --add g git
abbr --add gs 'git status'
abbr --add ga 'git add'
abbr --add gc 'git commit -m'
abbr --add grb 'git rebase'
abbr --add gd 'git diff'
abbr --add gu 'git pull --rebase --autostash'
abbr --add gp 'git push'

# k8s
abbr --add k kubectl
abbr --add kn kubens
abbr --add kc kubectx
abbr --add unset 'set --erase'
abbr --add kd 'kubectl describe'
abbr --add kg 'kubectl get'
abbr --add pods 'kubectl get pods --sort-by=.metadata.creationTimestamp'
abbr --add nodes 'kubectl get nodes --label-columns=topology.kubernetes.io/zone,type,lifecycle,karpenter.sh/capacity-type,karpenter.sh/provisioner-name,eks.amazonaws.com/nodegroup,kubernetes.io/arch,node.kubernetes.io/instance-type --sort-by={.metadata.creationTimestamp}'

# useful shortcuts
abbr --add ip ipinfo
abbr --add c2ip ipinfo cidr2ip
abbr --add dns doge @1.1.1.1
abbr --add p pnpm
abbr --add pw pnpm wrangler
