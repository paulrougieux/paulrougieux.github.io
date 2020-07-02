# Create windows and panes
rename-window utils 
split-window -v 
split-window -v 
neww
neww
cd rp/paulrougieux.github.io/
rename-window blog
neww
rename-window music 
neww
rename-window server 
neww
rename-window todo
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

