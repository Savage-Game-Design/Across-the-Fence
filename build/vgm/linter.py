
from pathlib import Path
import re
import shutil
import vgm.hemtt

def replace_import_with_class(directory: Path):

    print(f"Replacing \"import \w;\" with \"class \w;\" in {directory}")

    # Process hpp files to replace 'import' with 'class'
    for hpp_file in Path(directory).rglob("*.hpp"):
        with open(hpp_file, 'r') as f:
            content = f.read()
        modified_content = re.sub(r'^import (\w+;)', r'class \1', content, flags=re.MULTILINE)
        with open(hpp_file, 'w') as f:
            f.write(modified_content)


def run(source_root: Path, work_path: Path):

    addons_path = Path(work_path) / "addons" / "main"
    addons_mission_path = addons_path / "mission.cam_lao_nam"
    addons_mission_path.mkdir(parents=True)

    print(f"Moving: {work_path} to {addons_mission_path}")

    for item in Path(work_path).iterdir():
        if item.name == "addons":
            continue
        target = addons_mission_path / item.name
        item.rename(target)

    print("Adding hemtt config files")
    shutil.copy(source_root / "mod" / "lint" / "config.cpp", addons_path)
    shutil.copy(source_root / "mod" / "lint" / "$PBOPREFIX$", addons_path)

    hemtt_source = source_root / "mod" / "lint" / ".hemtt"
    hemtt_destination = work_path / ".hemtt"

    shutil.copytree(hemtt_source, hemtt_destination)

    replace_import_with_class(addons_mission_path)

    vgm.hemtt.check(work_path)


