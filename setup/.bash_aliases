alias ll='ls -lah'
alias tmuxw='tmux new-session -s work "tmux source-file ~/.tmux/work"'
alias youtubevorbis="youtube-dl --extract-audio --audio-format vorbis"
alias youtubemp3="youtube-dl --extract-audio --audio-format mp3"

export PATH=~/.npm-global/bin:$PATH

# Functions to start AWS machines
startandupdatecbm1() {
    ~/repos/bioeconomy_notes/src/aws/update_aws_hostname.py --start i-06b30b8f978a7c698 cbm1 --profile jrc
    echo "Tunnel to Jupyter notebooks with the alias tunnelcbm1"
}
alias tunnelcbm1="ssh -L 8888:localhost:8888 cbm1 -N"

startandupdatebiomass() {
    ~/repos/bioeconomy_notes/src/aws/update_aws_hostname.py --start i-06324fbb055296958 biomass --profile jrc
    echo "Tunnel to Jupyter notebooks with the alias tunnelbiomass"
    echo "Copying ~/.ssh/config to biomass, so the cbm1 address is updated"
    scp ~/.ssh/config biomass:/home/paul/.ssh/config
}

# Tunnel to aws machines
alias tunnelbiomass="ssh -L 4000:localhost:4000 biomass -N"
alias tunnelbiomasstocbm1="ssh -L 8888:localhost:8890 biomass ssh -L 8890:localhost:8888 -N cbm1"


