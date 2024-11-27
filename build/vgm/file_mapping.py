from collections import defaultdict
from pathlib import Path
from typing import Dict, Union

import sgd.file_tree
from sgd.file_generators import concatenate_files, from_text
from sgd.file_utils import Omit
from .pbo import PBO

"""
When built as a mission, the following applies:

Mission locations:
-- Mission root folder is the basis
-- All functions folders into mission root
-- Combine functions_client and functions_server into built_functions.hpp
-- Contents of maps folder goes to mission root
-- configs/mission folder goes to mission root
-- built_config.hpp includes config_mission.hpp

Client locations:
-- configs/client folder goes to client PBO root
-- configs/config_client.hpp becomes config.hpp for client PBO

Server locations:
-- configs/server folder goes to server PBO root
-- configs/config_server.hpp becomes config.hpp for server PBO


When built as a mod, the above is still almost correct, except:
-- Any files in `functions` go to the server PBO, unless they have `client` or `global` in the path
-- functions_server.hpp goes to the server PBO, and isn't added to the mission's `built_functions.hpp`

"""

PBOFileTrees = Dict[PBO, sgd.file_tree.Folder]

OMIT_ALWAYS = Omit(dirs={'.git'}, files={'.gitignore'})

# These will omit any directory with the matching (normalized) name
OMIT_CLIENT = Omit(dirs={'client'})
OMIT_GLOBAL = Omit(dirs={'global'})
OMIT_SERVER = Omit(dirs={'server'})

# Custom copy which includes OMIT_ALWAYS
def copy(file_tree: sgd.file_tree.Folder, source: Union[Path, str], dest: Union[Path, str], omit: Omit = Omit()):
    return sgd.file_tree.copy(file_tree, source, dest, OMIT_ALWAYS | omit)

generate_file = sgd.file_tree.generate_file
remove = sgd.file_tree.remove

def function_folders(source_root: Path):
    return (folder_path for folder_path in (source_root / "functions").iterdir() if folder_path.is_dir())

def map_pbo_file_trees(source_root: Path, paradigm_path: Path, as_mod=False) -> PBOFileTrees:
    # Maps the VGM source folder into virtual file trees for each output PBO
    pbo_file_trees = defaultdict(lambda: sgd.file_tree.FileTreeRoot())

    mission_pbo = pbo_file_trees[PBO.MISSION]
    client_pbo = pbo_file_trees[PBO.CLIENT]
    server_pbo = pbo_file_trees[PBO.SERVER]

    # Maps all files from "mission" folder to the mission PBO
    copy(mission_pbo, source_root / "mission", "")

    # Maps all functions to their appropriate PBO, depending on the build target.
    for function_folder in function_folders(source_root):
        if as_mod:
            copy(mission_pbo, function_folder, Path("functions") / function_folder.name, OMIT_SERVER)
            copy(server_pbo, function_folder, Path("functions") / function_folder.name, OMIT_CLIENT | OMIT_GLOBAL)
        else:
            copy(mission_pbo, function_folder, Path("functions") / function_folder.name)

    # Prepare CfgFunctions for the mission PBO
    remove(mission_pbo, "built_functions.hpp")
    if as_mod:
        copy(mission_pbo, "configs/built_functions.hpp", source_root / "functions" / "functions_client.hpp")
    else:
        generate_file(mission_pbo, "configs/built_functions.hpp", concatenate_files([
            source_root / "functions" / "functions_client.hpp",
            source_root / "functions" / "functions_server.hpp"
        ]))

    # Prepare CfgFunctions for the server PBO
    if as_mod:
        copy(server_pbo, source_root / "functions" / "functions_server.hpp", "CfgFunctions.hpp")
    else:
        generate_file(server_pbo, "CfgFunctions.hpp", from_text(""))

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

    # Maps any client config to the client PBO
    copy(client_pbo, source_root / "configs" / "client", "")
    copy(client_pbo, source_root / "configs" / "config_client.hpp", "config.hpp")

    # Maps any server config to the server PBO
    copy(server_pbo, source_root / "configs" / "server", "")
    copy(server_pbo, source_root / "configs" / "config_server.hpp", "config.hpp")

    # Include the common includes into the mission
    def copy_common_includes(pbo: sgd.file_tree.Folder):
        copy(
            pbo,
            source_root / "common_includes.hpp",
            "common_includes.hpp"
        )

    remove(mission_pbo, "common_includes.hpp")
    copy_common_includes(mission_pbo)
    copy_common_includes(client_pbo)
    copy_common_includes(server_pbo)

    # Copy paradigm
    copy(
        mission_pbo,
        paradigm_path,
        "paradigm"
    )

    return pbo_file_trees

