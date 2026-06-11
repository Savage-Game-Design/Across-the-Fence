#!/bin/xonsh

from pathlib import Path

gamemode_root = Path(__file__).resolve().parent.parent

passthrough_args = $ARGS[1:]

for file_path in pg`*.ogg`:
  xpython apply_radio_postprocessing.py @(file_path) @(gamemode_root / "game" / "mission" / "assets" / "radio_operator" / "sounds" / file_path.name.lower()) --overwrite @(passthrough_args)
