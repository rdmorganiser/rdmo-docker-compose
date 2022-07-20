alias ..="cd .."
alias env="env | sort"
alias p="python"
alias pm="python ${RDMO_APP}/manage.py"
alias pms="python ${RDMO_APP}/manage.py collectstatic"
alias psa="ps faux"
alias tailf="tail -F"
alias tlp="netstat -tulpen"
alias tlps="sudo netstat -tulpen"

export LS_COLORS=${LS_COLORS}:"di=1;34":"*.txt=1;36":"*.md=0;93"
alias l="ls --color=auto -CF"
alias ll="ls --color=auto -alF"
alias la="ls --color=auto -AlF"

source ${HOME}/sh/ve.sh