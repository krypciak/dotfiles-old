export SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export MAIN_DIR="$SCRIPTS_DIR/.."

RED='\e[91m'
GREEN='\e[32m'
BLUE='\e[34m'
YELLOW='\e[33m'
CYAN='\e[36m'
GREEN_BG='\e[30;42m'

NC='\e[0m'


TEMP_DIR="$MAIN_DIR/temp"
VIDEOS_DIR="$MAIN_DIR/downloaded/videos"

source "$SCRIPTS_DIR/subs.sh"

mkdir -p "$TEMP_DIR"
mkdir -p "$VIDEOS_DIR"


YT_DLP_ARGS='--sponsorblock-remove all --embed-thumbnail --add-metadata --embed-metadata --embed-chapters --embed-subs --sub-langs all,-live_chat --audio-quality 0 -R infinite --retry-sleep 15 -S quality,ext:mp4,filesize --no-post-overwrites --ignore-errors --newline --no-warnings --no-playlist --convert-thumbnails png'

TITLE='%(channel)s - %(title)s.%(ext)s'


export ANI_CLI_QUALITY="best"
export ANI_CLI_CACHE_DUR="$TEMP_DIR"
export ANI_CLI_HIST_DIR="$MAIN_DIR"

# 30 GiB
FREE_SPACE=$(echo "1048576 * 30" | bc)


function _log_invidious() {
    text="${CYAN}Instance: ${YELLOW}${instance}"  
    if [ "$filename" != '' ]; then
        text="$text ${CYAN}Filename: '${BLUE}${filename}${CYAN}'"
    fi

    text="$text $1 ${NC}"
    text=$(echo "$text" | ts)
    echo -e "$text"
}


function wait_for_finish() {
    while true; do
        pgrep "ffmpeg" > /dev/null || pgrep "yt-dlp" > /dev/null || pgrep "ani-cli" > /dev/null || break
        sleep 60
    done
}

function check_space() {
        # If there is less than $FREE_SPACE space left
        while [[ "$(df $VIDEOS_DIR --output=avail | tail +2)" -le "$FREE_SPACE" ]]; do
            # If no files left to delete, exit
            if [[ "$(ls $VIDEOS_DIR | wc -l)" -eq 0 ]]; then
                _log_invidious "${RED}Less than ${BLUE}$FREE_SPACE${RED} KiB on ${BLUE}$VIDEOS_DIR${RED}, exiting"
                sh "$SCRIPTS_DIR/kill.sh"
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
            wait_for_finish

            metadata="$(yt-dlp "$url" -o "$TITLE" $YT_DLP_ARGS --print filename,upload_date)"

            export filename="$(echo "$metadata" | sed '1q;d')"

            export date="$(echo "$metadata" | sed '2q;d')"
            date_ago="$(date -d @$(echo $(date +%s) - 86400*2 | bc) -u +%Y%m%d)"

            if [ -f "$VIDEOS_DIR/$filename" ] ; then 
                _log_invidious "${GREEN_BG}File exists, skipping"
            elif [ "$date" -lt "$date_ago" ]; then
                _log_invidious "${GREEN_BG}Video is too old, skipping"
            else
                _log_invidious "${CYAN}Downloading URL: ${YELLOW}${url}${CYAN}"
                yt-dlp $YT_DLP_ARGS --download-archive "$MAIN_DIR/downloaded.txt" -o "$TITLE" -P "$VIDEOS_DIR" -P "temp:$TEMP_DIR" "$url"

                touch -d "$date" "$VIDEOS_DIR/$filename"
                
                _log_invidious "${GREEN_BG}Download done"
                check_space
            fi
        fi
    done
}

function listen_anime() {
    export ANI_CLI_DOWNLOAD_DIR="$MAIN_DIR/downloaded/anime/$1"
    mkdir -p "$ANI_CLI_DOWNLOAD_DIR"
    while true; do
        wait_for_finish
        ani-cli -d -r 1-100 "$1"
        # 6 hours
        sleep 21600
    done
}

i=0
for feed in ${CHANNEL_FEEDS[@]}; do
    listen_rss "${INSTANCES[$i]}" "/feed/channel/" "$feed" $i &
    i=$((i+1))
    if [[ ${#INSTANCES[@]} -eq $i ]]; then
        i=0
    fi
    sleep 10
done
exit

for feed in ${ODYSEE_FEEDS[@]}; do
    listen_rss "https://odysee.com" "/$/rss/" "$feed" $i &
    sleep 10
done

for ((i = 0; i < ${#ANIME[@]}; i++)); do
    anime="${ANIME[$i]}"
    listen_anime "$anime"
    sleep 10
done

