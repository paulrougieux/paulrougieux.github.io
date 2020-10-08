# Taking notes
alias bookmark="vim ~/rp/bookmarkdown/bookmark.md"
alias overflow="vim ~/rp/bookmarkdown/overflow.md"
alias matrix="vim ~/rp/bookmarkdown/matrix.md"
alias reading_jrc="vim ~/rp/bioeconomy_papers/notes/readings_jrc.md"

# Music
alias youtubevorbis="youtube-dl --extract-audio --audio-format vorbis"
alias youtubemp3="youtube-dl --extract-audio --audio-format mp3"
# Based on https://askubuntu.com/questions/564567/how-to-download-playlist-to-mp3-format-with-youtube-dl/668028#668028
# Add the txt file name at the end a file containing a list of urls
alias youtubebatchfile="youtube-dl --extract-audio --audio-format vorbis --sleep-interval 30 -i --batch-file" 
# A playlist url generally ends with an index number in the form "index=1"
alias youtubeplaylist="youtube-dl --extract-audio --audio-format vorbis --sleep-interval 30 -i --yes-playlist"

# Tools
alias ll='ls -lah'
alias tmuxw='cd ~/rp && tmux new-session -s work "tmux source-file ~/.tmux/work"'
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
export PYTHONPATH="$HOME/repos/cbmcfs3_runner/":$PYTHONPATH
# Create tag files for an R project
rtags() {
    Rscript -e "rtags(ofile = 'et'); nvimcom::etags2ctags('et', 'tags'); unlink('et')"  
    echo $'\n\nTags in ' $PWD && cat tags
}
# Create tag files for the most commonly used R projects
rtagsall() {
    cd ~/rp/eutradeflows/R  && rtags
    cd ~/rp/tradeflows/R  && rtags
}
# Enable bracketed paste in vim
# https://vi.stackexchange.com/questions/25311/how-to-activate-bracketed-paste-mode-in-gnome-terminal-for-vim?noredirect=1#comment44475_25311
# It's actually better to enable this in the gnome shell in fact https://superuser.com/a/870547/419414
# export TERM=xterm-256color
alias vpn=expressvpn


