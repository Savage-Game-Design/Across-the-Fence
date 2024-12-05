from dataclasses import dataclass
from pathlib import Path
from typing import Union

import sgd.file_tree
from sgd.file_generators import concatenate_files, from_text, replace
from sgd.file_utils import Omit
from .artifacts import Mod, Mission, Gamemode

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

def get_missions(source_root: Path) -> list[Mission]:
    maps = [entry.name for entry in (source_root / "game" / "maps").iterdir()]
    return [
        Mission(name="vgm", map=map_name)
        for map_name in maps
    ]

@dataclass
class GenerateFileTreeParams:
    as_mod = False

_default_file_tree_params = GenerateFileTreeParams()

@dataclass
class GenerateFileTreeResult:
    mission: Mission | None
    client_mod: Mod | None
    server_mod: Mod | None

def generate_file_trees(source_root: Path, paradigm_path: Path, params: GenerateFileTreeParams = _default_file_tree_params) -> Gamemode:
    as_mod = params.as_mod
    game_root = source_root / "game"
    mod_root = source_root / "mod"

    missions = get_missions(source_root)
    mission = missions[0]

    client_mod = Mod()
    server_mod = Mod()

    gamemode = Gamemode(
        missions=[mission],
        client_mod=client_mod,
        server_mod=server_mod
    )

    # Copy mod-specific files - primarily config.cpp
    copy(client_mod.files, mod_root / "client", "")
    copy(server_mod.files, mod_root / "server", "")

    mission_tree = mission.files
    client_tree = client_mod.files / "addons" / "client"
    server_tree = server_mod.files / "addons" / "server"

    # Maps all files from "mission" folder to the mission PBO - they should always be included.
    copy(mission_tree, game_root / "mission", "")


    # Maps all functions to their appropriate PBO, depending on the build target.
    for function_folder in function_folders(game_root):
        if as_mod:
            copy(mission_tree, function_folder, Path("functions") / function_folder.name, OMIT_SERVER)
            copy(server_tree, function_folder, Path("functions") / function_folder.name, OMIT_CLIENT | OMIT_GLOBAL)
        else:
            copy(mission_tree, function_folder, Path("functions") / function_folder.name)

    # Prepare CfgFunctions for the mission PBO
    remove(mission_tree, "built_functions.hpp")
    if as_mod:
        copy(mission_tree, game_root / "functions" / "functions_client.hpp", "configs/built_functions.hpp",)
    else:
        generate_file(mission_tree, "configs/built_functions.hpp", concatenate_files([
            game_root / "functions" / "functions_client.hpp",
            game_root / "functions" / "functions_server.hpp"
        ]))

    # Prepare CfgFunctions for the server PBO
    server_functions_file_name = "built_functions.hpp"
    if as_mod:
        copy(server_tree, game_root / "functions" / "functions_server.hpp", server_functions_file_name)
    else:
        generate_file(server_tree, server_functions_file_name, from_text(""))

    # Maps the map-specific config and mission.sqm to the mission PBO
    copy(mission_tree, game_root / "maps" / "cam_lao_nam", "")

    # Maps any mission-specific config to the mission PBO
    copy(mission_tree, game_root / "configs" / "mission", "configs")
    remove(mission_tree, "configs/built_config.hpp")
    copy(
        mission_tree,
        game_root / "configs" / "config_mission.hpp",
        Path("configs/built_config.hpp")
    )

    # Maps any client config to the client PBO
    copy(client_tree, game_root / "configs" / "client", "")
    copy(client_tree, game_root / "configs" / "config_client.hpp", "built_config.hpp")

    # Maps any server config to the server PBO
    copy(server_tree, game_root / "configs" / "server", "")
    copy(server_tree, game_root / "configs" / "config_server.hpp", "built_config.hpp")

    # Include the common includes into the mission
    def copy_common_includes(pbo: sgd.file_tree.Folder):
        copy(
            pbo,
            game_root / "common_includes.hpp",
            "common_includes.hpp"
        )

    remove(mission_tree, "common_includes.hpp")
    copy_common_includes(mission_tree)
    copy_common_includes(client_tree)
    copy_common_includes(server_tree)

    # Copy paradigm
    copy(
        mission_tree,
        paradigm_path,
        "paradigm"
    )

    return gamemode

