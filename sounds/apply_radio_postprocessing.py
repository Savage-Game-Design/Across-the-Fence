#!/usr/bin/env python3

import subprocess
import sys
from pathlib import Path

current_folder = Path(__file__).parent
output_dir = current_folder / "compressed"

args = sys.argv[1:]
optionals = [arg for arg in args if arg.startswith("--")]
positionals = [arg for arg in args if not arg.startswith("--")]
input_file = Path(positionals[0])
output_file = Path(positionals[1]) if len(positionals) >= 2 else None
no_filter = "--no-filter" in optionals
overwrite_all = "--overwrite" in optionals
squelch = not ("--no-squelch" in optionals)
plane = not ("--no-plane" in optionals)

suffix = "_with_filter"

output_file = output_file if output_file else output_dir / f"{input_file.stem}_compressed{suffix}{input_file.suffix}"

print(f"Input: {input_file}")
print(f"Output: {output_file}")
print(f"With filter: {not no_filter}")
print(f"With squelch: {squelch}")
print(f"With overwrite: {overwrite_all}")

output_dir.mkdir(parents=True, exist_ok=True)

def include_if(cond, value):
    return [value] if cond else []

filter_parts = [
    f"[0:a]volume=1[{ "original_voice" if plane else "input" }];",

    *include_if(plane, "[1:a]volume=0.2[original_plane];"),
    *include_if(plane, "[original_voice][original_plane]amix=inputs=2:duration=first[input];"),

    # Grab the original audio ([0:a]) and standardize it to 48kHz Mono.
    # This is required so FFmpeg can perfectly glue it to the synthesized squelch later.
    "[input]aformat=sample_rates=48000:channel_layouts=mono,",

    # Apply the aggressive military AGC compressor to flatten the volume.
    "acompressor=threshold=-25dB:ratio=20:attack=1:release=50:makeup=15,",

    # Slice off the low frequencies (removes bass).
    "highpass=f=1000,",

    # Slice off the high frequencies (removes clarity).
    "lowpass=f=2000,",

    # Overdrive the volume to cause digital clipping.
    # We label this processed voice stream as [voice].
    f"volume=4.0[{ "voice" if squelch else "full_transmission" }];",

    # Generate exactly 0.15 seconds of loud (80% volume) white noise at 48kHz.
    # This is the mic click. We label this short burst as [squelch].
    *include_if(squelch, "anoisesrc=color=white:r=48000:amplitude=0.8:d=0.15[squelch];"),

    # Take the [voice] stream and glue the [squelch] burst seamlessly to the very end of it.
    # We label this newly combined track as [full_transmission].
    *include_if(squelch, "[voice][squelch]concat=n=2:v=0:a=1[full_transmission];"),

    # Generate a continuous stream of quieter white noise (15% volume) to act as the background static.
    # We label this as [bgnoise].
    "anoisesrc=color=white:amplitude=0.15[bgnoise];",

    # Mix the [full_transmission] (which is the voice + the click) with the [bgnoise].
    # Cut everything off the millisecond the transmission finishes.
    "[full_transmission][bgnoise]amix=inputs=2:duration=first"
]

filter_param = [] if no_filter else ["-filter_complex", "".join(filter_parts)]

overwrite_param = ["-y"] if overwrite_all else []

print(filter_param)

subprocess.run(
    ["ffmpeg", "-i", str(input_file), "-i", current_folder / "OV10.mp3",  *filter_param, *overwrite_param, "-c:a", "libvorbis", "-b:a", "8k", "-ar", "8000", "-ac", "1", output_file],
    check=True,
)
