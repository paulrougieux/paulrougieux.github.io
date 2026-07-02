# Window layout for a remote server session, adapted from
# ~/rp/paulrougieux.github.io/setup/work.tmux.
# "music" -> "silence" and "server" -> "here", since neither a music player
# nor a window named "server" makes sense once you're already on the server.
#
# Deploy to the server (user paul) with rsync, so it lives at ~/work.tmux:
#   rsync -av ~/rp/paulrougieux.github.io/setup/server/work.tmux paul@flower:~/work.tmux
# Run it inside a tmux session on the server with:
#   tmux source-file ~/work.tmux

# Create windows and panes
rename-window utils
split-window -v
split-window -v
neww
neww
rename-window blog
neww
rename-window silence
neww
rename-window here
neww
rename-window todo
neww
rename-window llm
select-window -t :1

# Tools used on desktop
# rename-window lyxjabR
# split-window -v 'QT_X11_NO_MITSHM=1 lyx ~/rp/bioeconomy_papers/notes/readings_jrc.lyx'
# split-window -v 'jabref ~/rp/bioeconomy_papers/bibliography/jrc_ispra.bib'
# split-window -v 'rstudio ~/R/statisticallearning/statisticallearning.Rproj'
# split-window -v 'riot-web'
# split-window -v 'QT_X11_NO_MITSHM=1 spyder3'
# neww
# select-window -t :1

# Reload tmux config
bind r source-file ~/.tmux.conf
