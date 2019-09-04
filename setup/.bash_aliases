alias ff="find -name"
alias ll='ls -lah'
alias youtubevorbis="youtube-dl --extract-audio --audio-format vorbis"
alias youtubemp3="youtube-dl --extract-audio --audio-format mp3"

refactor() {
    echo "Replacing $1 by $2"
    git grep -lz $1| xargs -0 perl -i'' -pE "s/$1/$2/g"
}

