
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


# https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands
def print_annotation(annotation: dict, strip_path: Path):

    match annotation['level']:
        case 'notice':
            level = 'notice'
        case 'warning':
            level = 'warning'
        case 'error':
            level = 'error'
        case _:
            level = 'error'

    file_path: str = annotation['path']
    # TODO don't hardcode
    file_path = file_path.replace("/addons/main/mission.cam_lao_nam", "game")
    if file_path.startswith("game/paradigm"):
        file_path = file_path.removeprefix("game/")

    print(f'echo "::{level} file={file_path},line={annotation["start_line"]},endLine={annotation["end_line"]},col={annotation["start_column"]},endColumn={annotation["end_column"]},title={annotation["title"]}::{annotation["message"]}"')

def parse_annotations(ci_annotations: Path, strip_path: Path):
    with open(ci_annotations, 'r') as f:
        content = f.readlines()

    # parse CI annotation lines
    # 15||15||9||18||warning||redefining macro||redefining macro||/addons/main/mission.cam_lao_nam/paradigm/client/configs/ui/ui_def_base.inc
    # https://github.com/arma-actions/hemtt/blob/f3c3f2d81c9439070b832c9dbbba7b53b743b0a4/src/post.ts#L45
    for line in content:
        parts = line.strip().split('||')
        annotation = {
            'start_line': int(parts[0]),
            'end_line': int(parts[1]),
            'start_column': int(parts[2]),
            'end_column': int(parts[3]),
            'level': parts[4],
            'title': parts[5],
            'message': parts[6],
            'path': parts[7]
        }

        print_annotation(annotation, strip_path)

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

    parse_annotations(work_path / ".hemttout" / "ci_annotations.txt", addons_mission_path)



