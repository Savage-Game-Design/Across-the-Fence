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
no_static = "--no-static" in optionals
overwrite_all = "--overwrite" in optionals

output_dir.mkdir(parents=True, exist_ok=True)

static_param = []
static_suffix = ""
if not no_static:
    static_param = [
        "-filter_complex",
        "[0:a]highpass=f=800,lowpass=f=2500,volume=5.0[voice];"
        "anoisesrc=color=white:amplitude=0.05[noise];"
        "[voice][noise]amix=inputs=2:duration=first",
    ]
    static_suffix = "_with_static"

overwrite_param = ["-y"] if overwrite_all else []

output_file = output_file if output_file else output_dir / f"{input_file.stem}_compressed{static_suffix}{input_file.suffix}"

subprocess.run(
    ["ffmpeg", "-i", str(input_file), *static_param, *overwrite_param, "-c:a", "libvorbis", "-b:a", "8k", "-ar", "8000", "-ac", "1", output_file],
    check=True,
)
