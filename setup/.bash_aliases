# Taking notes
alias bookmark="vim -c 'syn off' ~/rp/bookmarkdown/bookmark.md"
alias overflow="vim ~/rp/bookmarkdown/work/overflow.md"
alias matrix="cd ~/rp/bookmarkdown/work && vim matrix.Rmd"
alias open="xdg-open"
alias openallpdf="find -iname '*.pdf' -print0 | xargs -0 -n 1 xdg-open"
alias reading_jrc="cd ~/rp/bioeconomy_papers/notes/ && vim -c 'syn off' readings_jrc.md"
alias blog="cd ~/rp/paulrougieux.github.io && vim ."
alias blogr="cd ~/rp/paulrougieux.github.io && vim R.Rmd"
alias blogp="cd ~/rp/paulrougieux.github.io && vim python.Rmd"

# Music
alias youtubevorbis="youtube-dl --extract-audio --audio-format vorbis"
alias youtubemp3="youtube-dl --extract-audio --audio-format mp3"
# Based on https://askubuntu.com/questions/564567/how-to-download-playlist-to-mp3-format-with-youtube-dl/668028#668028
# Add the txt file name at the end a file containing a list of urls
alias youtubebatchfile="youtube-dl --extract-audio --audio-format vorbis --sleep-interval 30 -i --batch-file" 
# A playlist url generally ends with an index number in the form "index=1"
alias youtubeplaylist="youtube-dl --extract-audio --audio-format vorbis --sleep-interval 30 -i --yes-playlist"

# Pictures
alias mogri1000="mkdir -p small && mogrify -resize 1000 -path ./small/ *.JPG"
alias mogri2000="mkdir -p small && mogrify -resize 2000 -path ./small/ *.JPG"

# Tools
alias ll='ls -lah'
alias tmuxw='cd ~/rp && tmux new-session -s work "tmux source-file ~/.tmux/work"'
# disk usage sorted
alias dus='du -hd1|sort -hr'
# Disable Ctrl-S ctrl-Q in terminals
stty -ixon
# Paths for git run
export PATH=~/.npm-global/bin:$PATH

# Python
# Activate the default environment
alias penv="source ~/rp/penv/bin/activate"
alias p="source ~/rp/penv/bin/activate&&ipython"
alias jlab="source ~/rp/penv/bin/activate &&jupyter lab"

# Paths for python data
export BIOTRADE_DATA="$HOME/repos/forobs/biotrade_data/"
export BIOTRADE_DATABASE_URL="postgresql://rdb@localhost:5433/biotrade"
export COBWOOD_DATA="$HOME/repos/cobwood_data/"
export EU_CBM_AIDB="$HOME/repos/eu_cbm/eu_cbm_aidb/"
export EU_CBM_DATA="$HOME/repos/eu_cbm/eu_cbm_data/"
export FOREST_PULLER_CACHE="$HOME/rp/puller_cache/"
export OBS3DF_METHODS="$HOME/repos/forobs/obs3df_methods"

# Paths for python modules in development
export PYTHONPATH="$HOME/repos/autopaths/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/bioeconomy_notes/src/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/cbmcfs3_runner/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/cobwood/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/forobs/deforestfoot/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/env_impact_imports/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/eu_cbm/cbm_defaults/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/eu_cbm/eu_cbm_hat/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/eu_cbm/libcbm_py/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/forest_puller/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/forobs/biotrade/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/plumbing/":$PYTHONPATH

# Create tag files for an R project, from within an R project's R folder
rtags() {
    echo "This function should be called from within an R project's R folder."
    Rscript -e "rtags(ofile = 'et'); nvimcom::etags2ctags('et', 'tags'); unlink('et')"  
    echo $'\n\nTags in ' $PWD && cat tags
}
# Create tag files for the most commonly used R projects
rtagsall() {
    cd ~/rp/eutradeflows/R  && rtags
    cd ~/rp/FAOSTATpackage/FAOSTAT/R/ && rtags
    cd ~/rp/tradeflows/R  && rtags
}
# Enable bracketed paste in vim
# https://vi.stackexchange.com/questions/25311/how-to-activate-bracketed-paste-mode-in-gnome-terminal-for-vim?noredirect=1#comment44475_25311
# It's actually better to enable this in the gnome shell in fact https://superuser.com/a/870547/419414
# export TERM=xterm-256color
alias vpn=expressvpn
alias treep='tree -P "*.py"  -I "__pycache__"'


# add local bin to the path
export PATH=$PATH:~/.local/bin

# Enable git autocompletion
source /usr/share/bash-completion/completions/git

resize >/dev/null

# Time zone
export TZ='Europe/Rome'

# Lyx QT issue https://dticket.jrc.it/ticket.php?track=WML-7ML-MNT9&Refresh=12674 
alias lyx='QT_X11_NO_MITSHM=1 lyx'
alias spyder='QT_X11_NO_MITSHM=1 spyder'


# Enable git autocompletion
source /usr/share/bash-completion/completions/git

