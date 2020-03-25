alias ll='ls -lah'
alias tmuxw='tmux new-session -s work "tmux source-file ~/.tmux/work"'
alias youtubevorbis="youtube-dl --extract-audio --audio-format vorbis"
alias youtubemp3="youtube-dl --extract-audio --audio-format mp3"
# disk usage sorted
alias dus='du -hd1|sort -hr'
# Disable Ctrl-S ctrl-Q in terminals
stty -ixon
# Paths for git run
export PATH=~/.npm-global/bin:$PATH
# Paths for python modules
export FOREST_PULLER_CACHE="$HOME/rp/puller_cache/"
export PYTHONPATH="$HOME/repos/bioeconomy_notes/src/":$PYTHONPATH
export PYTHONPATH="$HOME/repos/forest_puller/":$PYTHONPATH

