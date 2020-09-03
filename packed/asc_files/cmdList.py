from test_commands import *
from asc_fnc import *
from anarchy_main.client import *
from anarchy_main.inventory import *

# Format:
# "tag" : filename.function

cmdList = {
		'server': {
				# Add users to the await list (player has connected and waits for the Backend connection)
				"user_add": asc_s_lst_client.client_await_add,
				# Player disconnected
				"user_rem": asc_s_lst_client.client_active_rem,

				# Try to get data from crates/Inventories.
				"crate_data_get": inv_handler.crate_data_get,
				# remove crates from the database
				"crate_rem": inv_handler.crate_rem,
				"TESTINGER": item_handler.item_add_list
			},
		'arma_server': {
				# "functionTag in Arma": "Function to execute"
				# NOTE: Make sure, that the Tag is compatible with the Arma 3 Variable logic
				"s_example_return": "ASC_fnc_example",
				"s_test":           "ASC_fnc_example",
				"s_abc":            "ASC_fnc_example",
				# DEV
				"crate_add":   "AN_S_fnc_crate_add"
			},
		'client': {
				# ""Tag" send from Arma" : Function in the backend
				# NOTE: Make sure, that you imported the related plugin/method/folder/however it's called (and added the files to the "__init.py__" )
				"itemMove":         item_handler.item_move,
				"inv_get_grid":     inv_handler.inv_grid_get,
				"inv_get_items":    inv_handler.inv_items_get
			},
		'arma_client': {
				# "functionTag in Arma": "Function to execute"
				# NOTE: Make sure, that the Tag is compatible with the Arma 3 Variable logic
				"INIT_CLIENTDATA":      "AN_c_fnc_clientData_init",
				"INIT_ITEMDATA":        "AN_c_fnc_items_setData",
				"ret_inv_get_grid":     "DEV_an_fnc_hintGrid",
				"ret_inv_get_items":    "DEV_an_fnc_hintItemData",
				"ret_inv_crateData":    "AN_c_fnc_loot_inv_get"
			}
		}
