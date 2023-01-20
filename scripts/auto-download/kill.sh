#!/bin/sh
pkill yt-dlp
pkill rsstail
pkill ffmpeg
/bin/ps aux | grep start_rss | grep -v grep | awk '{print $2}' | xargs kill
pkill rsstail
pkill yt-dlp
pkill ffmpeg
