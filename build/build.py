import click
import config
from pathlib import Path
import sgd.file_tree
import vgm.build
from vgm.build import OutputFolderExistsError
import vgm.file_mapping
import vgm.field_manual
from vgm.pbo import PBO

root = Path(__file__).parent.parent
game_root = root / "game"
field_manual_root = root / "field_manual"

@click.group
def cli():
    pass

@click.command
@click.option('--overwrite', default=False, is_flag=True)
def build(overwrite):
    try:
        vgm.build.build_anarchy_as_mission(game_root, config.paradigm_path, config.output_paths["default"], overwrite=overwrite)
    except OutputFolderExistsError as e:
        print(f"Output folder '{e.path}' already exists. If you wish to overwrite it, use --overwrite")

@click.command
def update_field_manual_entries():
    print(vgm.field_manual.parse_field_manual_entries(field_manual_root))

@click.command
def print_file_tree():
    file_trees = vgm.file_mapping.map_pbo_file_trees(game_root, config.paradigm_path)
    sgd.file_tree.print_file_tree(file_trees[PBO.MISSION], explain=True)

cli.add_command(build)
cli.add_command(update_field_manual_entries)
cli.add_command(print_file_tree)

if __name__ == "__main__":
    cli()
