
from pathlib import Path
import re
import shutil
import subprocess
import vgm.hemtt

def replace_import_with_class(directory: Path):

    print(f"Replacing \"import \\w;\" with \"class \\w;\" in {directory}")

    # Process hpp files to replace 'import' with 'class'
    for hpp_file in Path(directory).rglob("*.hpp"):
        with open(hpp_file, 'r') as f:
            content = f.read()
        modified_content = re.sub(r'^import (\w+);', r'class \1;', content, flags=re.MULTILINE)
        modified_content = re.sub(r'^import (\w+) from \w+;', r'class \1;', modified_content, flags=re.MULTILINE)
        with open(hpp_file, 'w') as f:
            f.write(modified_content)

def replace_exec_with_eval(directory: Path):

    print(f"Replacing \"__EXEC\" with \"__EVAL\" in {directory}")

    # Process hpp files to replace 'exec' with 'eval'
    for hpp_file in Path(directory).rglob("*.inc"):
        with open(hpp_file, 'r') as f:
            content = f.read()
        modified_content = re.sub(r'^__EXEC', r'#define _fake__EXEC ', content, flags=re.MULTILINE)
        modified_content = re.sub(r' __EXEC\(.*\)', r' /* */', modified_content, flags=re.MULTILINE)
        with open(hpp_file, 'w') as f:
            f.write(modified_content)


def parse_annotations(source_root: Path, ci_annotations: Path):
    with open(ci_annotations, 'r') as f:
        content = f.readlines()

    hemttout = source_root / ".hemttout"
    hemttout.mkdir(exist_ok=True)

    annotations_file = hemttout / "ci_annotations.txt"
    annotations_file.unlink(missing_ok=True)

    # Adjust paths in annotations so they are relative to the project root
    with open(annotations_file, 'w') as f:
        for line in content:
            line = line.replace("/addons/main/mission.cam_lao_nam", "game")
            line = line.replace("game/paradigm", "paradigm")
            f.write(line)


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
    shutil.copy(source_root / "mod" / "lint" / "addon.toml", addons_path)

    hemtt_source = source_root / "mod" / "lint" / ".hemtt"
    hemtt_destination = work_path / ".hemtt"
    shutil.copytree(hemtt_source, hemtt_destination)

    include_source = source_root / "mod" / "lint" / "include"
    include_destination = work_path / "include"
    shutil.copytree(include_source, include_destination)

    replace_import_with_class(addons_mission_path)
    replace_exec_with_eval(addons_mission_path)

    vgm.hemtt.check(work_path)

    parse_annotations(
        source_root,
        work_path / ".hemttout" / "ci_annotations.txt",
    )



