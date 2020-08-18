from asc_fnc import timestamp
import json


class asc_db:
	def __init__(self, dbPath, dbName):
		self.name = dbName
		self.dbPath = dbPath
		self.dbName = dbName
		self.lastUpdate = timestamp.timestamp_get()
		self.players = {}
		self.guilds = {}
		self.zones = {}
		# persistent storage
		self.crates = {}
		self.bases = {}
		# Temporary storage like Loot crates will be stored in here. Entries will NOT be saved to the Database!
		self.sessionCrates = {}

		print("\n########################################################\n#### ASC: LOADING DATABASE\n")
		try:
			with open(f"{self.dbPath}{self.dbName}", "r", encoding="ascii") as f:
				self._db_load(json.load(f))
			print("\n########################################################\n#### ASC: DATABASE found")
		except FileNotFoundError:
			try:
				print("\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n#### ASC: DATABASE HAS NOT been found - Creating new file\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n")
				# No file found, load the default Values
				_dbData = {"main": {"name": self.dbName, "lastUpdate": timestamp.timestamp_get()}, "players": {}, "guilds": {}, "zones": {}, "crates": {}, "bases": {}}
				self._db_load(_dbData)
				self.db_save()
			except FileNotFoundError:
				print("\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n#### ASC: DATABASE HAS NOT been found - PATH NOT FOUND!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n")
				self.name = None
				return
		except Exception as e:
			print(f"ASC DB: CLASS INIT: Exception:\n{e}")

	########################################################
	# "local" functions:
	# Don't meant to be called from outside!
	def _db_load(self, data):
		print("DATABASE: Players in DB: ", len(data["players"]))
		self.players = data["players"]
		self.crates = data["crates"]

	def _db_updTime_(self):
		self.lastUpdate = timestamp.timestamp_get()

	########################################################
	# global functions:
	def db_get_name(self):
		return self.name

	def db_get_lastUpd(self):
		return self.lastUpdate

	def db_save(self):
		# print("preparing data to save")
		self._db_updTime_()
		with open(f"{self.dbPath}{self.dbName}", 'w+') as f:
			_dbData = {
				'main': {
						"name":       self.dbName,
						"lastUpdate": self.lastUpdate
					},
				'players': self.players,
				'guilds': self.guilds,
				'zones': self.zones,
				'crates': self.crates,
				'bases': self.bases
				}
			print("preparing data to save... done")
			# human easily readable format
			json.dump(_dbData, f, indent=4)
			# 1liner (less file size)
			# json.dump(_dbData, f)
			print("saving done")

	def player_data_get(self, puid):
		print("player_data_get: puid:", puid)
		# print(self.players)
		try:
			pData = self.players[puid]
			self._db_updTime_()
			# Todo: Save after getting data+time updated? :thonk: Currently disabled
			# self.db_save()
		except KeyError:
			pData = {}
		return pData

	def player_data_set(self, puid, data):
		try:
			self.players[puid] = data
			self.db_save()
		except KeyError:
			# print(f"ASC_DB: PlayerUID [{puid}] not found!")
			pass
