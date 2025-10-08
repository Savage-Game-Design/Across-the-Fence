
from pathlib import Path
import re
import shutil
import subprocess
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


def parse_annotations(source_root, ci_annotations: Path, strip_path: Path):
    with open(ci_annotations, 'r') as f:
        content = f.readlines()

    # TODO don't hardcode
    # file_path = file_path.replace("/addons/main/mission.cam_lao_nam", "game")
    # if file_path.startswith("game/paradigm"):
    #     file_path = file_path.removeprefix("game/")
    hemttout = source_root / ".hemttout"
    hemttout.mkdir()
    shutil.copy(ci_annotations, source_root / ".hemttout" / "ci_annotations.txt")

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

    parse_annotations(
        source_root,
        work_path / ".hemttout" / "ci_annotations.txt",
        addons_mission_path
    )



