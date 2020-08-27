# @Author: Aaron Clark
# @Date:   2020-07-25
# @Project: Anarchy
# @Filename: loot_gen.py
# @Last modified by:   Aaron Clark
# @Last modified time: 2020-08-27
# @License: TBA

# USAGE:
# call once on python server start to make/read globalseed and load loot tables into global dicts:
# loot_gen.loot_init()
#
# to return loot list:
# loot_gen.return_loot_list("crateID/Seed", loot_count, "type_generic")

import random, json, os, configparser, string

def get_random_string(length):
	letters = string.ascii_letters
	result_str = ''.join(random.choices(letters, k = length))
	return (result_str)

def loot_init():
	dir_path = os.path.dirname(os.path.realpath(__file__))
	# load globalseed from config or create new one
	config = configparser.ConfigParser()
	config.read(dir_path + "\\" + 'loot_config.ini')
	if 'loot' in config.sections():
		globals()["globalseed"] = config['loot']['seed']
	else:
		config['loot'] = {}
		config['loot']['seed'] = get_random_string(8)
		with open(dir_path + "\\" + 'loot_config.ini', 'w') as configfile:
			config.write(configfile)
		globals()["globalseed"] = config['loot']['seed']

	# load data from json loot tables to global dicts
	json_files = [pos_json for pos_json in os.listdir(dir_path) if pos_json.endswith('.json')]
	for filename in json_files:
		with open(dir_path + "\\" + filename, "r") as read_file:
			globals()[os.path.splitext(filename)[0]] = json.load(read_file)

def loot_generate(x_dict,initial_seed):
	# init seed
	random.seed(initial_seed)
	# select random item
	selected_type = random.choices(list(x_dict.keys()), weights = list(x_dict.values()), k = 1)[0]
	# check if selected_type exists other wise return class
	if selected_type in globals().keys():
		initial_seed += selected_type;
		return loot_generate(globals()[selected_type], initial_seed)
	else:
		return selected_type

def return_loot_list(crate_id, loot_count, loot_type):
	initial_seed = globalseed + crate_id + loot_type
	loot_list = []
	# check if loot_type exists
	if loot_type in globals().keys():
		for x in range(loot_count):
			loot_list.append(loot_generate(globals()[loot_type], initial_seed + str(x)))
	return loot_list

# TESTING ONLY BELOW
# loot_init()
# print(return_loot_list("98372491", 5, "type_military"))
