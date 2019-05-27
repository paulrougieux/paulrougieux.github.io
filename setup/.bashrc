# See also .bash_aliases

# Enable git autocompletion
source /usr/share/bash-completion/completions/git

# PROXY Environment Variables

export http_proxy="http://...:8012"
export https_proxy="http://...:8012"
export no_proxy="local_ip,localhost,127.0.0.1"

resize >/dev/null
cd ~

# Time zone
export TZ='Europe/Rome'

# Lyx QT issue https://dticket.jrc.it/ticket.php?track=WML-7ML-MNT9&Refresh=12674 
alias lyx='QT_X11_NO_MITSHM=1 lyx'
alias spyder='QT_X11_NO_MITSHM=1 spyder'
alias ipython2='QT_X11_NO_MITSHM=1 ipython2'


# Enable git autocompletion
source /usr/share/bash-completion/completions/git

# Functions
startandupdateaws() {
    ~/repos/cbmcfs3_notes/src/aws/update_aws_hostname.py --start i-__id__ cbm1 --profile jrc
    echo "Tunnel to Jupyter notebook, enter this command"
    echo "ssh -L 8888:localhost:8888 cbm1 -N "
    echo "Or the alias tunnelcbm1"
}
alias tunnelcbm1="ssh -L 8888:localhost:8888 cbm1 -N"



export PYTHONPATH="$HOME/R/cbm3_python":$PYTHONPATH


