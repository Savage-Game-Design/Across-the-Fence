from pathlib import Path
from vgm.pbo import PBO

username = "Spoffy"

output_paths = {
    "default": {
        PBO.MISSION: Path(rf"C:\Users\{username}\Documents\Arma 3\mpmissions\vgm.cam_lao_nam"),
        PBO.CLIENT: None,
        PBO.SERVER: None,
    }
}
