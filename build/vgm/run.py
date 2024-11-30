import subprocess
import sgd.file_utils
from pathlib import Path

def flag(should_use: bool, flag: str) -> str:
    return flag if should_use else ""

def hemtt_dev_path(mod_path: Path) -> Path:
    return mod_path / ".hemttout" / "dev"

def hemtt_launch(path: Path, args=[], arma_args=[]):
    command = [
        "hemtt",
        "launch",
        *args,
        "--",
        *arma_args,
    ]

    print(f"Launching HEMTT: {command}")

    subprocess.run(command, cwd=path)

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

def launch_arma(arma_exe_path, mods=[], args=[], connect=False):
    command_args = [
        *(build_mod_list(mods)),
        f"-connect={connect}" if connect else "",
        *args,
    ]

    command = [arma_exe_path] + command_args

    print(f"Launching Arma: {command}")

    # start arma
    subprocess.Popen(command)

def launch_arma_server(mission_path: Path, arma_server_exe: Path, config: Path, servermod_path=None, mods=[]):
    try_symlink_arma_server_mission_dir(mission_path, arma_server_exe)

    server_config_path = setup_temporary_arma_server_config(config, mission_path.name)

    if servermod_path:
        hemtt_launch(
            servermod_path,
            arma_args=[
                f"-config={server_config_path}"
            ]
        )
        return

    launch_arma(
        mods=mods,
        args=[
            "-server",
            f"-config={server_config_path}"
        ]
    )

