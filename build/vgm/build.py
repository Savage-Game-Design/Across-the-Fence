from pathlib import Path
from typing import Dict

from sgd.file_tree import Folder

from .artifacts import BuildArtifact, Mission, Mod
from .file_mapping import generate_file_trees

class OutputFolderExistsError(Exception):
    def __init__(self, path):
        super().__init__(f"Output folder already exists: {path}")
        self.path = path

def write_file_tree(file_tree: Folder, target_path: Path, overwrite=False):
    if target_path.exists() and not overwrite:
        raise OutputFolderExistsError(target_path)
    file_tree.create_tree_at(target_path)

def create_mission_in(mission: Mission, target_path: Path, overwrite=False):
    mission_path = target_path / mission.folder_name

    print(f"Creating mission files at '{mission_path}'")
    write_file_tree(mission.files, mission_path, overwrite)

def create_mod(mod: Mod, target_path: Path,  overwrite=False):
    print(f"Creating files for mod {target_path.name} at '{target_path}")
    write_file_tree(mod.files, target_path, overwrite)


def build(source_path, paradigm_path, output_paths=Dict[BuildArtifact,Path], overwrite=False, as_mod=False):
    gamemode = generate_file_trees(source_path, paradigm_path, as_mod=as_mod)

    if gamemode.client_mod:
        create_mod(gamemode.client_mod, output_paths[BuildArtifact.CLIENT_MOD], overwrite)

    if gamemode.server_mod:
        create_mod(gamemode.server_mod, output_paths[BuildArtifact.SERVER_MOD], overwrite)

    for mission in gamemode.missions:
        create_mission_in(mission, output_paths[BuildArtifact.MISSION], overwrite)
        # Only supports one mission right now in the config
        break
