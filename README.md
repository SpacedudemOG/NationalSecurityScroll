# National Security & Fire — scroll-world landing page

A scroll-scrubbed "fly through the world" landing page for [National Security & Fire](https://natsec.us)
(burglar, fire sprinkler, fire alarm & video — Galveston, TX). As you scroll, one continuous
camera flight dives into six miniature neon-night scenes — neighborhood → smart home →
fire watch → 24/7 command center → rapid response → peace of mind — with no cuts.

Scroll drives time: the page scrubs pre-rendered video clips (AI-generated with
[Higgsfield](https://higgsfield.ai), kling3_0) whose seams are frame-locked — each connector
starts on the previous clip's actual last frame and ends on the next clip's actual first frame.

## Run it

Any static file server works:

```bash
python3 -m http.server 8080 --bind 127.0.0.1
# open http://127.0.0.1:8080
```

The engine (`scrub-engine.js`) loads each clip as a Blob, so it scrubs smoothly even on
hosts without HTTP range support.

## Layout

- `index.html` — page config: sections, copy, brand theme (navy `#16273A`, alarm red `#F05040`, signal gold `#E3C700`), pacing (`scroll`/`linger`)
- `scrub-engine.js` — self-contained vanilla-JS scrub engine (blob seek, lazy prefetch, seam crossfade, route rail, reduced-motion fallback, mobile hardening)
- `assets/scene_*.png|webp` — the six generated scene stills (posters / reduced-motion fallbacks)
- `assets/vid/dive_*.mp4`, `conn_*.mp4` — the clip chain; `-m.mp4` are the 720p mobile (beta) encodes
- `prompts/` — the exact Higgsfield prompts (shared style preamble = world cohesion)

## Regenerating clips

Requires the Higgsfield CLI (authenticated) + ffmpeg. On a Basic plan use `kling3_0`
(`--mode std --sound off`; seedance_2_0 is Pro-gated) and batch at most 4 concurrent jobs.
Encode: `-c:v libx264 -crf 20 -g 8 -sc_threshold 0 -movflags +faststart` (desktop),
`scale=-2:720 -crf 23 -g 4` (mobile).
