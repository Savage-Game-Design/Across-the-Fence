from collections import defaultdict
from enum import Enum
from typing import Dict
from sgd.file_generators import concatenate_files
from sgd.file_sources import *
from sgd.file_tree import *

from .pbo import PBO

"""
Mission locations:
-- Mission root folder is the basis
-- Alls functions folders into mission root
-- Combine functions_client and functions_server into built_functions.hpp
-- Contents of maps folder goes to mission root
-- configs/mission folder goes to mission root
-- built_config.hpp includes config_mission.hpp

TODO: PBO Client locations
TODO: PBO Server locations
"""

PBOFileTrees = Dict[PBO, Folder]

def function_folders(source_root: Path):
	return (folder_path for folder_path in (source_root / "functions").iterdir() if folder_path.is_dir())

def map_pbo_file_trees(source_root: Path, paradigm_path: Path) -> PBOFileTrees:
	# Maps the VGM source folder into virtual file trees for each output PBO
	pbo_file_trees = defaultdict(lambda: FileTreeRoot())

	mission_pbo = pbo_file_trees[PBO.MISSION]
	client_pbo = pbo_file_trees[PBO.CLIENT]
	server_pbo = pbo_file_trees[PBO.SERVER]

	# Maps all files from "mission" folder to the mission PBO
	copy(mission_pbo, source_root / "mission", "")

	# Maps all functions to their appropriate PBO, depending on the build target.
	for function_folder in function_folders(source_root):
		copy(mission_pbo, function_folder, Path("functions") / function_folder.name)

	remove(mission_pbo, "built_functions.hpp")
	generate_file(mission_pbo, "configs/built_functions.hpp", concatenate_files([
		source_root / "functions" / "functions_client.hpp",
		source_root / "functions" / "functions_server.hpp"
	]))
	

	# Maps the map-specific config and mission.sqm to the mission PBO
	copy(mission_pbo, source_root / "maps" / "cam_lao_nam", "")

	# Maps any mission-specific config to the mission PBO
	copy(mission_pbo, source_root / "configs" / "mission", "configs")
	remove(mission_pbo, "configs/built_config.hpp")
	copy(
		mission_pbo,
		source_root / "configs" / "config_mission.hpp",
		Path("configs/built_config.hpp")
	)

	# Include the common includes into the mission
	remove(mission_pbo, "common_includes.hpp")
	copy(
		mission_pbo,
		source_root / "common_includes.hpp",
		"common_includes.hpp"
	)

	# Copy paradigm
	copy(
		mission_pbo,
		paradigm_path,
		"paradigm"
	)

	return pbo_file_trees

