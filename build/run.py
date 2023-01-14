import click
import subprocess
import config
import os
from pathlib import Path

@click.command("client")
@click.option('--connect', default=None)
def arma_launch(connect):
    args = [
        "-mod=" + ";".join(config.arma_arg_mods),
        f"-connect={connect}" if connect else "",
    ] + config.arma_args

    # start arma
    subprocess.Popen([config.arma_exe_path] + args)

@click.command("server")
def arma_server_launch():
    mission_name = Path(config.mission_output_path).name
    mpmissions_dir = Path(config.arma_exe_path).parent / "mpmissions" / "vgm"
    mission_output_dir = mpmissions_dir / mission_name

    try_create_arma_server_mission_dir(mpmissions_dir, mission_output_dir)
    try_update_arma_server_config(mission_name)

    args = [
        "-mod=" + ";".join(config.arma_arg_mods),
        "-server",
        f"-config={config.arma_server_config_path.with_suffix('.tmp')}",
    ] + config.arma_args

    # start arma server
    subprocess.Popen([config.arma_exe_path] + args)

def try_create_arma_server_mission_dir(mpmissions_dir, mission_output_dir):
    try:
        # ensure subfolder in mpmissions exists
        if not os.path.exists(mpmissions_dir):
            os.mkdir(mpmissions_dir)
        # symlink mission output folder into mpmissions subfolder
        if not os.path.exists(mission_output_dir):
            Path(mission_output_dir).symlink_to(config.mission_output_path)
    except OSError:
        print(f"Failed to create symlink from '{mpmissions_dir / mission_output_dir}' to '{config.mission_output_path}'")
        raise

def try_update_arma_server_config(mission_name):
    with open(config.arma_server_config_path, "r") as f:
        server_config = f.read()
        server_config = server_config.replace("MISSION_NAME", mission_name)

    with open(config.arma_server_config_path.with_suffix('.tmp'), "w") as f:
        f.write(server_config)

@click.group
def cli():
    pass

cli.add_command(arma_launch)
cli.add_command(arma_server_launch)

if __name__ == "__main__":
    cli()
