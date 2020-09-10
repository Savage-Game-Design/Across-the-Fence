import json
import os


def load_files(sData):
	# ####### load all the Items
	path = os.path.dirname(__file__)
	print(f'#### Loading itemData...')
	# get all files in the directory
	json_files = [pos_json for pos_json in os.listdir(path) if pos_json.endswith('.json')]
	for filename in json_files:
		# load the .json file
		with open(f"{path}\{filename}", "r") as file:
			# add every Base_ItemData to the sData.itemData
			data = json.load(file)
			for x in data:
				# print(f"DEBUG: ItemData: {data[x]}")
				sData.itemDataSubTypes[x] = data[x]
	print(f'#### Loading itemData... done')
