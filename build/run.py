import click
import config
import vgm.run
from pathlib import Path
from vgm.artifacts import BuildArtifact
from vgm.build import calculate_mission_output_paths

repo_root = Path(__file__).parent.parent

output_paths = config.output_paths["default"]
servermod_path = Path(output_paths[BuildArtifact.SERVER_MOD])

@click.command("client")
@click.option('--connect', default=None)
def arma_launch(connect):
    vgm.run.launch_arma(
        arma_exe_path=Path(config.arma_exe_path),
        mods=config.arma_arg_mods,
        args=config.arma_args,
        connect=connect,
    )


@click.command("server")
@click.option('--mod', default=False, is_flag=True)
def arma_server_launch(mod):
    mission_paths = calculate_mission_output_paths(repo_root, output_paths[BuildArtifact.MISSION])

    vgm.run.launch_arma_server(
        arma_server_exe=Path(config.arma_exe_path),
        mission_path=Path(mission_paths[0]),
        config=Path(config.arma_server_config_path),
        servermod_path=(Path(servermod_path) if mod else None),
        mods=config.arma_arg_mods
    )


@click.group
def cli():
    pass

cli.add_command(arma_launch)
cli.add_command(arma_server_launch)

if __name__ == "__main__":
    cli()
