import click
import config
from pathlib import Path
import sgd.file_tree
import vgm.build
from vgm.build import OutputFolderExistsError
import vgm.file_mapping
from vgm.pbo import PBO

game_root = Path(__file__).parent.parent / "game"

@click.group
def cli():
    pass

@click.command
@click.option('--overwrite', default=False, is_flag=True)
@click.option('--mod', default=False, is_flag=True,
              help="Builds VGM to run as a client / server mod pair")
def build(overwrite, mod):
    try:
        vgm.build.build(game_root, config.paradigm_path, config.output_paths["default"], overwrite=overwrite, as_mod=mod)
    except OutputFolderExistsError as e:
        print(f"Output folder '{e.path}' already exists. If you wish to overwrite it, use --overwrite")

@click.command
@click.option('--mod', default=False, is_flag=True, help="Show the file tree as if building to a mod")
def print_file_tree(mod):
    file_trees = vgm.file_mapping.map_pbo_file_trees(game_root, config.paradigm_path, as_mod=mod)
    print("=================")
    print("MISSION FILE TREE")
    print("=================")
    sgd.file_tree.print_file_tree(file_trees[PBO.MISSION], explain=True)
    print("================")
    print("CLIENT FILE TREE")
    print("================")
    sgd.file_tree.print_file_tree(file_trees[PBO.CLIENT], explain=True)
    print("================")
    print("SERVER FILE TREE")
    print("================")
    sgd.file_tree.print_file_tree(file_trees[PBO.SERVER], explain=True)

cli.add_command(build)
cli.add_command(print_file_tree)

if __name__ == "__main__":
    cli()
