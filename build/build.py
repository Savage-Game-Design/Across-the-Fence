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
def build(overwrite):
	try:
		vgm.build.build_anarchy_as_mission(game_root, config.paradigm_path, config.output_paths["default"], overwrite=overwrite)
	except OutputFolderExistsError as e:
		print(f"Output folder '{e.path}' already exists. If you wish to overwrite it, use --overwrite")

@click.command
def print_file_tree():
	file_trees = vgm.file_mapping.map_pbo_file_trees(game_root, config.paradigm_path)
	sgd.file_tree.print_file_tree(file_trees[PBO.MISSION], explain=True)

cli.add_command(build)
cli.add_command(print_file_tree)

if __name__ == "__main__":
	cli()