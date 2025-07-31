import subprocess
import sgd.file_utils
from pathlib import Path
from sys import platform

from . import hemtt


class UnixPathException(Exception):
    r"""
    Exception when a variable uses a unix `/` delimited path instead of
    windows `\` delimited.
    """
    def __init__(self, path: Path):
        self.path = path

    def __str__(self):
        return rf"Possible unix `/` path detected where an explicit windows `\` path required: path={self.path}"


def validate_windows_path(path: Path):
    r"""
    Require a windows `\` delimited path in windows terminal environments.

    GCC python defaults to `/` paths, while MSC python defaults to `\` paths.
    Arma requires `\` delimited paths for CLI options like server config etc.
    i.e. `DRIVE:\DIR\DIR\DIR\FILENAME.EXT`

    Throws an error for an invalid path.
    """
    if "/" in str(path) and platform in ["win32", "cygwin"]:
        raise UnixPathException(path)
    else:
        return path


def find_mpmissions(search_start: Path) -> Path | None:
    def is_mpmissions(path: Path) -> bool:
        return path.is_dir() and path.name.lower() == "mpmissions"

    return sgd.file_utils.search_all_parents(search_start, is_mpmissions)

def try_symlink_arma_server_mission_dir(current_mission_path: Path, arma_install_path: Path):
    mpmissions_path = find_mpmissions(arma_install_path)
    if not mpmissions_path:
        print(f"Unable to create mission symlink, '{arma_install_path}' is not a valid Arma installation or mpmissions path")
        return

    sgd.file_utils.create_symlink(mpmissions_path / current_mission_path.name, current_mission_path, is_directory=True)

def setup_temporary_arma_server_config(config_template_path: Path, mission_name: str):
    with open(config_template_path, "r") as f:
        server_config = f.read()
        server_config = server_config.replace("MISSION_NAME", mission_name)

    tmp_server_config_path = config_template_path.with_suffix('.tmp')
    with open(tmp_server_config_path, "w") as f:
        f.write(server_config)

    return tmp_server_config_path

def build_mod_list(mods: list) -> list[str]:
    return [
        f"-mod=\"{mod}\""
        for mod in mods
    ]

def launch(arma_exe_path, mods=[], args=[], connect=False, editor_mission_path: Path=None):
    command_args = [
        *(build_mod_list(mods)),
        f"-connect={connect}" if connect else "",
        *args,
        editor_mission_path or "",
    ]

    command = [arma_exe_path] + command_args

    print(f"Launching Arma: {list(map(str, command))}")

    # start arma
    subprocess.Popen(command)

def launch_server(mission_path: Path, arma_server_exe: Path, config: Path, servermod_path=None, mods=[], profile="vgm_server"):
    try_symlink_arma_server_mission_dir(mission_path, arma_server_exe)

    server_config_path = validate_windows_path(
        setup_temporary_arma_server_config(config, mission_path.name)
    )

    if servermod_path:
        hemtt.launch(
            servermod_path,
            arma_args=[
                f"-name={profile}",
                f"-config={server_config_path}"
            ]
        )
        return

    launch(
        arma_exe_path=arma_server_exe,
        mods=mods,
        args=[
            "-server",
            f"-name={profile}",
            f"-config={server_config_path}"
        ]
    )

