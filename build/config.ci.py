import os
from collections import defaultdict
from pathlib import Path
from vgm.artifacts import BuildArtifact

config_dir = Path(__file__).parent
repo_root = config_dir.parent

paradigm_path = repo_root /  "paradigm"

def env_output_paths() -> dict[BuildArtifact, Path]:
    mission_path = os.environ.get("MISSION_OUTPUT_PATH", repo_root / "output" / "missions")
    mod_path = os.environ.get("MOD_OUTPUT_PATH", repo_root / "output" / "mods")

    return {
        BuildArtifact.MISSION: Path(mission_path),
        BuildArtifact.CLIENT_MOD: Path(mod_path / "@vgm_client"),
        BuildArtifact.SERVER_MOD: Path(mod_path / "@vgm_server")
    }

output_paths = defaultdict(env_output_paths)
