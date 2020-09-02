import json
import os


def load_files(sData):
	# ####### load the Loottables
	path = os.path.dirname(__file__)
	print(f'#### Loading loot-tables...')
	# get all files in the directory
	json_files = [pos_json for pos_json in os.listdir(path) if pos_json.endswith('.json')]
	for filename in json_files:
		# load the .json file
		with open(f"{path}\{filename}", "r") as file:
			# add the .json data to the sData dict
			sData.lootData["tables"][os.path.splitext(filename)[0]] = json.load(file)
	print(f'#### Loading loot-tables... done')
