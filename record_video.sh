#!/bin/bash

SAVE_DIR="$HOME/videos"
SEGMENT_MS=120000          # 2 minutes
MAX_AGE_MINUTES=240        # 4 hours

mkdir -p "$SAVE_DIR"

# Date/time for this recording session
SESSION_DATE=$(date +"%Y-%m-%d_%H-%M-%S")

echo "Starting continuous segmented recording ($SESSION_DATE)..."

rpicam-vid \
  -t 0 \
  --segment $SEGMENT_MS \
  --codec h264 \
  --inline \
  --width 1920 \
  --height 1080 \
  --framerate 30 \
  --bitrate 8000000 \
  --awb auto \
  --exposure normal \
  -o "$SAVE_DIR/video_${SESSION_DATE}_%04d.h264" &

RPICAM_PID=$!

# Cleanup loop
while kill -0 $RPICAM_PID 2>/dev/null; do
    find "$SAVE_DIR" -type f -name "*.h264" -mmin +$MAX_AGE_MINUTES -delete
    sleep 60
done
