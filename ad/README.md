# NatSec 30-second ad (voiceover + music)

`natsec_ad.mp4` — a short advertisement cut from the scroll-world's existing scenes,
with AI voiceover (Higgsfield `seed_audio`) and a ducked ambient music bed
(Higgsfield `sonilo_music`), captions burned in, closing on a brand CTA card.

Rebuild: edit `gen/script.txt` / `gen/build.sh`, regenerate `audio/voice.mp3` and
`audio/music.m4a` via the Higgsfield CLI, then `bash gen/build.sh` followed by the
mix + mux ffmpeg commands documented in the parent repo's session notes.
