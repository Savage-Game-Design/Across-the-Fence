import os
from pathlib import Path
from vgm.artifacts import BuildArtifact

config_dir = Path(__file__).parent
repo_root = config_dir.parent

username = os.getlogin()
arma_profile = r"dev_vgm"

paradigm_path = config_dir.parent /  "paradigm"
mission_output_path = rf"C:\Users\{username}\Documents\Arma 3 - Other Profiles\{arma_profile}\mpmissions\vgm.cam_lao_nam"

output_paths = {
    "default": {
        BuildArtifact.MISSION: Path(mission_output_path),
        BuildArtifact.CLIENT_MOD: repo_root / "output" / "mods" / "@vgm_client",
        BuildArtifact.SERVER_MOD: repo_root / "output" / "mods" / "@vgm_server",
    }
}

arma_exe_path = r"C:\Program Files (x86)\Steam\steamapps\common\Arma 3\arma3_x64.exe"
arma_arg_mods = [
    r"!Workshop\@VN (Testing Build)",
    r"!Workshop\@Advanced Developer Tools",
]
arma_args = [
    f"-name={arma_profile}",
    "-noSplash",
    "-noPause",
    "-window",
    "-showScriptErrors",
    "-debug",
    rf"{mission_output_path}\mission.sqm", # open mission in editor
]

arma_server_config_path = config_dir / "arma_server.hpp"
