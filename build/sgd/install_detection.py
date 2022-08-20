import os
from pathlib import Path
import vdf
import winreg

from .logger import logger

# Retrieve steam install path from the registry, if possible.
def get_steam_path_from_registry():
    # Try 64 bit registry lookup
    try:
        hkey = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Wow6432Node\Valve\Steam")
        return Path(winreg.QueryValueEx(hkey, "InstallPath")[0])
    except:
        pass

    # Try 32 bit registry lookup
    try:
        hkey = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Valve\Steam")
        return Path(winreg.QueryValueEx(hkey, "InstallPath")[0])
    except:
        return None

def find_steam_library_paths():
    steam_path = get_steam_path_from_registry()

    # Attempt a dumb lookup if we can't pull it from the registry. Bit of a hail mary.
    if not steam_path:
        steam_path = Path(os.environ["ProgramFiles(x86)"]) / "Steam"

    if not steam_path.exists():
        return (False, f"Unable to find Steam using registry or {steam_path}")

    library_file_path = steam_path / "steamapps" / "libraryfolders.vdf"
    if not library_file_path.exists():
        return (False, f"Unable to locate Steam libraries ({library_file_path} does not exist)")

    steam_library_paths = [steam_path]
    try:
        with open(library_file_path, "r") as library_file:
            lib_info = vdf.load(library_file)
            for (key, value) in lib_info["LibraryFolders"].items():
                #Check if the key is an integer - that means it's a library path
                try:
                    int(key)
                    steam_library_paths.append(Path(value))
                except ValueError:
                    #Don't need to do anything. This just means the key/value pair isn't one we want.
                    pass
    except Exception as e:
        return (False, f"An error occurred while loading Steam library info. {e}")

    return (True, steam_library_paths)

def is_arma_server_dir(path):
    return (path / "arma3server.exe").exists() and not is_arma_client_dir(path)

def is_arma_client_dir(path):
    return (path / "arma3.exe").exists()

def is_arma_tools_dir(path):
    return (path / "Arma3Tools.exe").exists()

def find_arma_install_dirs():
    arma_paths = {
        "games": [],
        "servers": [],
        "tools": []
    }

    (success, result) = find_steam_library_paths()
    if not success:
        logger.error(f"An error occurred locating Arma 3 - {result}")
        return arma_paths

    steam_library_paths = result
    game_folder_root_paths = list(filter(lambda p: p.exists(), [path / "steamapps" / "common" for path in steam_library_paths]))
    for root_path in game_folder_root_paths:
        for game_dir in root_path.iterdir():
            #Quick filter - saves the overhead of checking every directory for an exe - makes a noticable difference
            if not game_dir.name.casefold().find("arma 3") == 0:
                continue
            if is_arma_client_dir(game_dir):
                arma_paths["games"].append(game_dir)
                continue
            if is_arma_server_dir(game_dir):
                arma_paths["servers"].append(game_dir)
                continue
            if is_arma_tools_dir(game_dir):
                arma_paths["tools"].append(game_dir)
                continue

    return arma_paths