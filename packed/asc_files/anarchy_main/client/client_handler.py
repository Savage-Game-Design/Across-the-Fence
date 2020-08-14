from asc_fnc import *
from anarchy_main.inventory import *

# from asc_fnc import timestamp_get

def client_add(**kwargs):
	# Default Values for new Clients
	cData = {
		'puid': "1234567890",
		'skills': {
				'skill_a': 0,
				'skill_b': 0,
				'skill_c': 0,
				'skill_d': 0
			},
		'health':   [
				["hitface", "hitneck", "hithead", "hitpelvis", "hitabdomen", "hitdiaphragm", "hitchest", "hitbody", "hitarms", "hithands", "hitlegs", "incapacitated"],
				["face_hub", "neck", "head", "pelvis", "spine1", "spine2", "spine3", "body", "arms", "hands", "legs", "body"],
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			],
		'stats':    {
				"hunger": 0,
				"thirst": 0
			},
		'pos':      [
				[0, 0, 0],
				0,
			],
		'inv_grid': inv_handler.invGrid_create(8, 4),
		'itemData': {},
		'gear':     {
			'helmet': {},
			'goggles': {},
			'backpack': {},
			'vest': {},
			'uniform': {},
			'pouch': {},
			'tool': {},
			'weapon_main': {},
			'weapon_main_b': {},
			'weapon_hand': {},
			'weapon_secondary': {},
			'weapon_launcher': {}
			},
		'ammo': {
				"ammoType_a": 0,
				"ammoType_b": 0,
				"ammoType_c": 0,
				"ammoType_d": 0
			}
		}

	cData.update(kwargs)
	# print(item)
	return cData


def client_init(self):
	self.cData = self.sData.database.player_data_get(self.puid)
	if len(self.cData) == 0:
		print(f"ASC: CLIENT HANDLER: PUID NOT FOUND. CREATING NEW ENTRY FOR PUID: {self.puid}")
		self.cData = client_add(puid=self.puid)
		self.sData.database.player_data_set(self.puid, self.cData)
	# DEV
	# for i in range(1000):
	# 	if i % 100 == 99:
	# 		print(i)
	# 	sData.database.player_data_set(i, cData)
	print("SENDING INIT_CLIENTDATA...")
	asc_g_msg.sendMsg("INIT_CLIENTDATA", self.cData, self.con_client)
	print("SENDING INIT_CLIENTDATA... DONE")
