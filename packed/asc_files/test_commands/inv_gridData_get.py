from asc_fnc import asc_g_msg
from anarchy_main import inventory


def inv_get_grid(client=None, args=()):
    print('FUNCTION CALLED BY REMOTE: "inv_get_grid"')
    gridID = args[0]

    data = inventory.inv_handler.inv_getData(client, gridID)["inv_grid"]
    print(f"gridID: {gridID}\ndata: {data}")

    con = client.con_client
    asc_g_msg.sendMsg("ret_inv_get_grid", data, con)


def inv_get_items(client=None, args=()):
    print('FUNCTION CALLED BY REMOTE: "inv_get_items"')
    gridID = args[0]

    data = inventory.inv_handler.inv_getData(client, gridID)["itemData"]
    print(f"gridID: {gridID}\ndata: {data}")

    con = client.con_client
    asc_g_msg.sendMsg("ret_inv_get_items", data, con)