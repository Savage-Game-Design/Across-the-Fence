import shutil

from enum import Enum, auto
from pathlib import Path
from typing import Dict

from sgd.file_tree import Folder

from . import hemtt
from .artifacts import BuildArtifact, Mission, Mod
from .file_mapping import generate_file_trees, get_missions

class OutputFolderExistsError(Exception):
    def __init__(self, path):
        super().__init__(f"Output folder already exists: {path}")
        self.path = path

def remove_dir(path: Path):
    print(f"Removing directory '{path}'")
    shutil.rmtree(path, ignore_errors=True)

def write_file_tree(file_tree: Folder, target_path: Path, overwrite=False):
    if target_path.exists() and not overwrite:
        raise OutputFolderExistsError(target_path)
    file_tree.create_tree_at(target_path)

def calculate_mission_output_path(mission: Mission, containing_folder_path: Path) -> list[Path]:
    return containing_folder_path / mission.folder_name

def calculate_mission_output_paths(source_path: Path, containing_folder_path: Path) -> list[Path]:
    missions = get_missions(source_path)
    return [calculate_mission_output_path(mission, containing_folder_path) for mission in missions]

def create_mission_in(mission: Mission, target_path: Path, overwrite=False, clean=False):
    mission_path = calculate_mission_output_path(mission, target_path)

    if overwrite and clean:
        remove_dir(mission_path)

    print(f"Creating mission files at '{mission_path}'")
    write_file_tree(mission.files, mission_path, overwrite)

def create_mod(mod: Mod, target_path: Path,  overwrite=False, clean=False):
    if overwrite and clean:
        remove_dir(target_path)

    print(f"Creating files for mod {target_path.name} at '{target_path}")
    write_file_tree(mod.files, target_path, overwrite)


def build(source_path, paradigm_path, output_paths=Dict[BuildArtifact,Path], overwrite=False, as_mod=False, clean=False):
    if as_mod:
        print(f"Building gamemode as mods (intended for release)")
    else:
        print(f"Building gamemode as mission (intended for development)")

    gamemode = generate_file_trees(source_path, paradigm_path, as_mod=as_mod)

    if gamemode.client_mod:
        create_mod(gamemode.client_mod, output_paths[BuildArtifact.CLIENT_MOD], overwrite, clean)

    if gamemode.server_mod:
        create_mod(gamemode.server_mod, output_paths[BuildArtifact.SERVER_MOD], overwrite, clean)

    for mission in gamemode.missions:
        create_mission_in(mission, output_paths[BuildArtifact.MISSION], overwrite, clean)
        # Only supports one mission right now in the config
        break

class PackType(Enum):
    Dev = auto()
    Build = auto()
    Release = auto()

pack_funcs = {
    PackType.Dev: hemtt.dev,
    PackType.Build: hemtt.build,
    PackType.Release: hemtt.release
}

def pack(source_path: Path, output_paths=Dict[BuildArtifact,Path], pack_type=PackType) -> bool:
    hemtt_build_command = pack_funcs[pack_type]

    is_success = True

    for (artifact, path) in output_paths.items():
        if artifact == BuildArtifact.CLIENT_MOD or artifact == BuildArtifact.SERVER_MOD and path.exists():
            result = hemtt_build_command(path)
            if result.returncode > 0:
                is_success = False

    missions_output_path = output_paths.get(BuildArtifact.MISSION, None)
    if missions_output_path:
        for mission_path in calculate_mission_output_paths(source_path, missions_output_path):
            # TODO - Build with armake2
            pass

    return is_success


