from test_commands import *
from asc_fnc import *
from anarchy_main.client import *
from anarchy_main.inventory import *

# Format:
# "tag" : filename.function

cmdList = {
		'server': {
				"user_add": asc_s_lst_client.client_await_add,
				"user_rem": asc_s_lst_client.client_active_rem
			},
		'arma_server': {
				# "functionTag in Arma": "Function to execute"
				# NOTE: Make sure, that the Tag is compatible with the Arma 3 Variable logic
				"s_example_return": "ASC_fnc_example",
				"s_test":           "ASC_fnc_example",
				"s_abc":            "ASC_fnc_example"
			},
		'client': {
				# ""Tag" send from Arma" : Function in the backend
				# NOTE: Make sure, that you imported the related plugin/method/folder/however it's called (and added the files to the "__init.py__" )
				"itemAdd":          test_itemAdd.test_itemAdd,
				"itemMove":         inv_handler.item_move,
				"inv_get_grid":     inv_gridData_get.inv_get_grid,
				"inv_get_items":    inv_gridData_get.inv_get_items
			},
		'arma_client': {
				# "functionTag in Arma": "Function to execute"
				# NOTE: Make sure, that the Tag is compatible with the Arma 3 Variable logic
				"INIT_CLIENTDATA":      "ASC_fnc_clientData_init",
				"ret_inv_get_grid":     "DEV_an_fnc_hintGrid",
				"ret_inv_get_items":    "DEV_an_fnc_hintItemData"
			}
		}
