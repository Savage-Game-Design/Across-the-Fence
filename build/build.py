import click
import config
from pathlib import Path
import sgd.file_tree
import vgm.build
from vgm.build import OutputFolderExistsError
import vgm.file_mapping

source_root = Path(__file__).parent.parent

@click.group
def cli():
    pass

@click.command
@click.option('--overwrite', default=False, is_flag=True)
@click.option('--clean', default=False, is_flag=True)
@click.option('--mod', default=False, is_flag=True,
              help="Builds VGM to run as a client / server mod pair")
def build(overwrite, mod, clean):
    try:
        vgm.build.build(source_root, config.paradigm_path, config.output_paths["default"], overwrite=overwrite, as_mod=mod, clean=clean)
    except OutputFolderExistsError as e:
        print(f"Output folder '{e.path}' already exists. If you wish to overwrite it, use --overwrite")

@click.command
@click.option('--mod', default=False, is_flag=True, help="Show the file tree as if building to a mod")
def print_file_tree(mod):
    gamemode = vgm.file_mapping.generate_file_trees(source_root, config.paradigm_path, as_mod=mod)
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

cli.add_command(build)
cli.add_command(print_file_tree)

if __name__ == "__main__":
    cli()
