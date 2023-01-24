export DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

RED='\e[91m'
GREEN='\e[32m'
BLUE='\e[34m'
YELLOW='\e[33m'
CYAN='\e[36m'
GREEN_BG='\e[30;42m'

NC='\e[0m'


TEMP_DIR="$DIR/temp"
VIDEOS_DIR="$DIR/videos"

source $DIR/subs.sh

mkdir -p $TEMP_DIR
mkdir -p $VIDEOS_DIR


YT_DLP_ARGS='--sponsorblock-remove all --embed-thumbnail --add-metadata --embed-metadata --embed-chapters --embed-subs --sub-langs all,-live_chat --audio-quality 0 -R infinite --retry-sleep 900 -S quality,ext:mp4,filesize --no-post-overwrites --ignore-errors --newline --quiet --no-warnings'

TITLE='%(channel)s - %(title)s.%(ext)s'

# 30 GiB
FREE_SPACE=$(echo "1048576 * 30" | bc)


function _log() {
    text="${CYAN}Instance: ${YELLOW}${instance}"  
    if [ "$filename" != '' ]; then
        text="$text ${CYAN}Filename: '${BLUE}${filename}${CYAN}'"
    fi

    text="$text $1 ${NC}"
    text=$(echo "$text" | ts)
    echo -e "$text"
}

function check_space() {
        # If there is less than $FREE_SPACE space left
        while [[ "$(df $VIDEOS_DIR --output=avail | tail +2)" -le "$FREE_SPACE" ]]; do
            # If no files left to delete, exit
            if [[ "$(ls $VIDEOS_DIR | wc -l)" -eq 0 ]]; then
                _log "${RED}Less than ${BLUE}$FREE_SPACE${RED} KiB on ${BLUE}$VIDEOS_DIR${RED}, exiting"
                exit 1
            fi
            # Remove the last video
            last_file="$(LC_CTYPE=C ls -t $VIDEOS_DIR | tail -1)"
            rm -f "$last_file"
        done
}


function listen_rss() {
    export instance="$1"
    export feed_suffix="$2"
    export channel_id="$3"
    export rss_feed="${instance}${feed_suffix}${channel_id}"
    export index="$4"

    rsstail -z -l -N -n 1 -i 300 -P -u "$rss_feed" | while read url; do
        check_space

        if [[ "$url" == http* ]]; then 
            _log "${CYAN}Recived RSS URL: ${YELLOW}${url}"

            export filename=$(yt-dlp "$url" -o "$TITLE" $YT_DLP_ARGS --print filename)
            if [ -f "$VIDEOS_DIR/$filename" ] ; then 
                _log "${GREEN_BG}File exists, skipping"
            else
                _log "${CYAN}Downloading URL: ${YELLOW}${url}${CYAN}"
                yt-dlp $YT_DLP_ARGS --download-archive downloaded.txt -o "$TITLE" -P "$VIDEOS_DIR" -P "temp:$TEMP_DIR" "$url"
                _log "${GREEN_BG}Download done"
                check_space
            fi
        fi
    done
}

i=0
for feed in ${CHANNEL_FEEDS[@]}; do
    listen_rss "${INSTANCES[$i]}" "/feed/channel/" "$feed" $i &
    sleep 60
    i=$((i+1))
    if [[ ${#INSTANCES[@]} -eq $i ]]; then
        i=0
    fi
done

for feed in ${ODYSEE_FEEDS[@]}; do
    listen_rss "https://odysee.com" "/$/rss/" "$feed" $i &
    sleep 60
done

