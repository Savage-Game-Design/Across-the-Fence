from pathlib import Path
from typing import Dict

from .pbo import PBO
from .file_mapping import map_pbo_file_trees

class OutputFolderExistsError(Exception):
    def __init__(self, path):
        super().__init__(f"Output folder already exists: {path}")
        self.path = path


def build(source_path, paradigm_path, output_paths_by_pbo=Dict[PBO,Path], overwrite=False, as_mod=False):
    file_trees = map_pbo_file_trees(source_path, paradigm_path, as_mod=as_mod)
    for pbo in PBO:
        target_path = output_paths_by_pbo.get(pbo, None)
        file_tree = file_trees.get(pbo, None)
        if target_path and file_tree:
            if target_path.exists() and not overwrite:
                raise OutputFolderExistsError(target_path)
            print(f"Building {pbo} at '{target_path}'")
            file_tree.create_tree_at(target_path)
