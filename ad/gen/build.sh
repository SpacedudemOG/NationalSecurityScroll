set -e
SRC=../assets/vid
W=1628; H=1080
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

# --- trim source segments ---
ffmpeg -y -v error -ss 0    -t 5.60 -i $SRC/dive_1.mp4 -vf "scale=$W:$H" -an gen/seg1.mp4
ffmpeg -y -v error -ss 2.0  -t 2.70 -i $SRC/dive_2.mp4 -vf "scale=$W:$H" -an gen/seg2a.mp4
ffmpeg -y -v error -ss 2.0  -t 2.70 -i $SRC/dive_3.mp4 -vf "scale=$W:$H" -an gen/seg2b.mp4
ffmpeg -y -v error -ss 3.0  -t 3.00 -i $SRC/dive_4.mp4 -vf "scale=$W:$H" -an gen/seg3a.mp4
ffmpeg -y -v error -ss 0    -t 1.66 -i $SRC/conn_4.mp4 -vf "scale=$W:$H" -an gen/seg3b.mp4
ffmpeg -y -v error -ss 2.0  -t 8.00 -i $SRC/dive_6.mp4 -vf "scale=$W:$H" -an gen/seg4.mp4

# --- CTA card as a 4s video with a fade-in ---
ffmpeg -y -v error -loop 1 -t 4 -i gen/cta_card.png -vf "scale=$W:$H,fade=t=in:st=0:d=0.6" -an gen/seg5.mp4

# --- concat all video segments ---
printf "file 'seg1.mp4'\nfile 'seg2a.mp4'\nfile 'seg2b.mp4'\nfile 'seg3a.mp4'\nfile 'seg3b.mp4'\nfile 'seg4.mp4'\nfile 'seg5.mp4'\n" > gen/concat.txt
ffmpeg -y -v error -f concat -safe 0 -i gen/concat.txt -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p gen/video_raw.mp4

DUR=$(ffprobe -v error -show_entries format=duration -of default=nk=1:nw=1 gen/video_raw.mp4)
echo "raw video duration: $DUR"

# --- captions (drawtext, timed to our line estimates; escape colons/apostrophes for ffmpeg) ---
ffmpeg -y -v error -i gen/video_raw.mp4 -vf "
drawtext=fontfile=$FONT:text='While the city sleeps\, someone has to stay awake.':fontsize=44:fontcolor=white:borderw=3:bordercolor=black@0.7:x=(w-text_w)/2:y=h-160:enable='between(t\,0.6\,4.61)',
drawtext=fontfile=$FONT:text='...watches every door\, every window\, every ember.':fontsize=44:fontcolor=white:borderw=3:bordercolor=black@0.7:x=(w-text_w)/2:y=h-160:enable='between(t\,4.61\,9.98)',
drawtext=fontfile=$FONT:text='Monitored 24/7 — real people\, real response.':fontsize=44:fontcolor=white:borderw=3:bordercolor=black@0.7:x=(w-text_w)/2:y=h-160:enable='between(t\,9.98\,14.64)',
drawtext=fontfile=$FONT:text='Because your peace of mind is a matter for National Security.':fontsize=42:fontcolor=#E3C700:borderw=3:bordercolor=black@0.7:x=(w-text_w)/2:y=h-160:enable='between(t\,14.64\,22.90)'
" -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -an gen/video_captioned.mp4

echo BUILD_VIDEO_DONE
