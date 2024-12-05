import click
import config
from pathlib import Path
import sgd.file_tree
from vgm.artifacts import BuildArtifact, Version
import vgm.build
from vgm.build import OutputFolderExistsError, calculate_mission_output_paths, PackType, BuildParams
import vgm.field_manual
import vgm.file_mapping
import vgm.arma

source_root = Path(__file__).parent.parent

output_paths = config.output_paths["default"]
servermod_path = Path(output_paths[BuildArtifact.SERVER_MOD])

mission_paths = calculate_mission_output_paths(source_root, output_paths[BuildArtifact.MISSION])

def default_build_params(output_paths=output_paths, overwrite: bool = False, clean: bool = False, as_mod=False, version=None) -> BuildParams:
    params = BuildParams(
        output_paths=output_paths,
        overwrite=overwrite,
        clean=clean
    )

    params.mapping_params.as_mod = as_mod
    if version:
        params.mapping_params.version = Version.parse(version)

    return params

def launch_arma(connect: str = "", editor_mission_path: Path = None):
    vgm.arma.launch(
        arma_exe_path=Path(config.arma_exe_path),
        mods=config.arma_arg_mods,
        args=config.arma_args,
        connect=connect,
        editor_mission_path=editor_mission_path
    )

def launch_arma_server(mod: bool = False):
    vgm.arma.launch_server(
        arma_server_exe=Path(config.arma_exe_path),
        mission_path=Path(mission_paths[0]),
        config=Path(config.arma_server_config_path),
        servermod_path=(Path(servermod_path) if mod else None),
        mods=config.arma_arg_mods
    )

def perform_build(params: BuildParams = default_build_params()):
    vgm.field_manual.update_field_manual(source_root)
    try:
        vgm.build.build(source_root, config.paradigm_path, params)
    except OutputFolderExistsError as e:
        print(f"Output folder '{e.path}' already exists. If you wish to overwrite it, use --overwrite")
        raise

option_overwrite = click.option('--overwrite', default=False, is_flag=True)
option_clean = click.option('--clean', default=False, is_flag=True)
option_mod = click.option('--mod', default=False, is_flag=True, help="Builds VGM to run as a client / server mod pair")
option_version = click.option('--version', default=None,
                              help="Version in the format: 'v1.2.3@hash something', where each part (1.2.3, hash, something) is optional")


@click.command("client")
@click.option('--connect', default=None)
@click.option('--editor', is_flag=True)
def command_launch_arma_client(connect, editor):
    editor_mission_path = mission_paths[0] if editor else None
    launch_arma(connect, editor_mission_path=editor_mission_path)


@click.command("server")
@click.option('--mod', default=False, is_flag=True)
def command_launch_arma_server(mod):
    launch_arma_server(mod)


@click.command
@option_overwrite
@option_clean
@option_mod
@option_version
@click.option('--dev', default=False, is_flag=True)
@click.option('--pack', default=False, is_flag=True,
              help="Packs mission and mods (if --mod is specified) using Armake2 and HEMTT")
def build(overwrite, clean, mod, dev, pack, version):
    perform_build(default_build_params(overwrite=overwrite, clean=clean, as_mod=mod, version=version))

    pack_type = PackType.Dev if dev else PackType.Build

    if pack:
        # Only pack the mods if --mod is specified
        pack_paths = {
            artifact: value
            for (artifact, value) in config.output_paths["default"].items()
            if not artifact in [BuildArtifact.CLIENT_MOD, BuildArtifact.SERVER_MOD] or mod
        }
        vgm.build.pack(source_root, pack_paths, pack_type=pack_type)

@click.command("dev")
@option_overwrite
@option_clean
@option_mod
@option_version
@click.option('--no-server', default=False, is_flag=True,
              help="Doesn't start an arma server")
@click.option('--no-client', default=False, is_flag=True,
              help="Doesn't start an arma client")
def command_launch_dev(overwrite, clean, mod, version, no_server, no_client):
    perform_build(default_build_params(overwrite=overwrite, clean=clean, as_mod=mod, version=version))

    if not no_server:
        launch_arma_server(mod)

    if not no_client:
        launch_arma(connect="127.0.0.1")

@click.command
@click.option('--confirm', default=False, is_flag=True)
@option_mod
@option_version
def release(confirm, mod, version):
    if not confirm:
        confirm = input("WARNING: This will run --clean and remove all output directories. Proceed? Y/N").lower() == "y"

    if not confirm:
        print("Aborting.")
        return

    release_output_paths = config.output_paths["release"]

    perform_build(default_build_params(overwrite=True, as_mod=mod, clean=True, version=version, output_paths=release_output_paths))
    vgm.build.pack(source_root, output_paths=release_output_paths, pack_type=PackType.Release)

@click.command
def update_field_manual_entries():
    vgm.field_manual.update_field_manual(source_root)

@click.command
@click.option('--mod', default=False, is_flag=True, help="Show the file tree as if building to a mod")
def print_file_tree(mod):
    gamemode = vgm.file_mapping.generate_file_trees(source_root, config.paradigm_path, vgm.file_mapping.GenerateFileTreeParams(as_mod=mod))
    for mission in gamemode.missions:
        print("=================")
        print("MISSION FILE TREE")
        print("=================")
        sgd.file_tree.print_file_tree(mission.files, explain=True)
        # Only support 1 mission right now
        break

    print("================")
    print("CLIENT FILE TREE")
    print("================")
    sgd.file_tree.print_file_tree(gamemode.client_mod.files, explain=True)
    print("================")
    print("SERVER FILE TREE")
    print("================")
    sgd.file_tree.print_file_tree(gamemode.server_mod.files, explain=True)


@click.group
def cli():
    pass

@click.group
def launch():
    pass

cli.add_command(build)
cli.add_command(release)
cli.add_command(print_file_tree)
launch.add_command(command_launch_arma_client)
launch.add_command(command_launch_arma_server)
launch.add_command(command_launch_dev)
cli.add_command(launch)

if __name__ == "__main__":
    cli()
