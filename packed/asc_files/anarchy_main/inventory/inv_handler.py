from . import id_handler
from asc_fnc.asc_db.database import asc_db
from asc_fnc import asc_g_msg

from . import item_handler

DEVMODE = True
# inventory = []
def invGrid_create(grid_x, grid_y):
    ret = []
    for x in range(grid_y):
        _line = [0] * grid_x
        ret.append(_line)
    return ret


# try to get the Crate data. If not found -> Create a new one. We simply assume the Data, coming from the Game-server, is correct/valid.
def crate_data_get(sData, clientID: str = None, pos: list = None, crateID: str = None, lootType: str = None, isLootcrate: int = 0, persistent=False, invGridSize: list = None):
    print(f"clientID: {clientID}\n"
          f"pos: {pos}\n"
          f"crateID: {crateID}\n"
          f"lootType: {lootType}\n"
          f"isLootcrate: {isLootcrate}\n"
          f"persistent: {persistent}\n"
          f"invGridSize: {invGridSize}\n")
    try:
        if persistent:
            retdata = sData.database.crates[crateID]
        else:
            retdata = sData.database.sessionCrates[crateID]

        # ToDo: Add an "in use"-check
        # send Inventory data back to the requesting client
        conClient = sData.user_active[clientID]["con"]
        print(f"DEBUG: INV_HANDLER: crate_data_get: Crate found, sending Data to Client.")
        asc_g_msg.sendMsg("ret_inv_crateData", retdata, conClient)
        return

    # No "Error", the crate was just not in the List. So let's create a new crate entry
    except KeyError:
        print(f"DEBUG: INV_HANDLER: crate_data_get: Creating new Crate")
        crate_add(sData=sData, clientID=clientID, pos=pos, crateID=crateID, lootType=lootType, isLootcrate=isLootcrate, persistent=persistent, invGridSize=invGridSize)
    except Exception:
        print(f"ERROR: INV_HANDLER: crate_data_get: HUGE WOBBLE WOBBLE! Data:\nclientID: {clientID}\npos: {pos}\ncrateID: {crateID}\nlootType: {lootType}\npersistent {persistent}\ninvGridSize {invGridSize}\n---------")

# called by Server only!
def crate_add(sData, clientID: str = None, pos: list = None, crateID: str = "", lootType: str = None, isLootcrate: int = 0, persistent=False, model: str = "IG_supplyCrate_F", invGridSize: list = None):
    """
    :param sData:       ServerData (auto-passed)
    :param clientID:    A3 playerUID
    :param pos:         list - [[x,y,z],dir]
    :param crateID:
    :param lootType:    String - type of loot, passed by the gameserver
    :param isLootcrate: is the crate a newly created Loot-crate or not
    :param persistent:  Save to Database or not
    The following arguments are ONLY for creating persistent crates:
    :param model:       A3 typeOf Class
    :param invGridSize: list - Inventory grid
    :return:
    """

    if None in [clientID, pos]:
        print(f"ERROR: INV_HANDLER: create_add: clientID or Pos not transmitted: clientID: {clientID} | pos: {pos}")
        return
    if invGridSize is None:
        invGridSize = [4, 8]

    if persistent:
        # only persistent Crates store the model
        model = model
    else:
        model = "TEMP"

    grid_y, grid_x = invGridSize

    inv_data = {
        "model": model,
        "pos": pos,
        "type": lootType,
        "inv_grid": invGrid_create(grid_x, grid_y),
        "inv_gridSize": invGridSize,    # [y, x] / [rows, columns]
        "itemData": {}
        }

    print(f"CRATE ADD:\n"
          f"crateID     : {crateID}\n"
          f"Model       : {model}\n"
          f"Pos         : {pos}\n"
          f"type        : {lootType}\n"
          f"InvGridSize : {invGridSize}\n"
          f"inv_data    : {inv_data}\n")

    # fill the lootcrate, if needed
    if isLootcrate == 1:
        skill_scavenging = sData.database.players[clientID]["skills"]["scavenging"]
        print(f"DEBUG: INV_HANDLER: crate_add: isLootcrate: {isLootcrate}")
        print(f"DEBUG: INV_HANDLER: crate_add: skill_scavenging: {skill_scavenging}")
        print(item_handler.return_loot_list(sData=sData, skill_scavenging=skill_scavenging, crate_id=crateID, loot_count=5, loot_type="type_military"))
        pass

    if persistent:
        sData.database.crates[crateID] = inv_data
        asc_db.db_save(sData.database)
    else:
        sData.database.sessionCrates[crateID] = inv_data

    try:
        # send Inventory data back to the requesting client
        conClient = sData.user_active[clientID]["con"]
        asc_g_msg.sendMsg("ret_inv_crateData", inv_data, conClient)
    except KeyError:
        print(f"ERROR: INV_HANDLER: create_add: clientID NOT FOUND in user_active: {clientID}")

# called by Server only!
def crate_rem(sData, createID, pos):
    crate = sData.database.crates[createID]
    # kind of security check
    if crate["pos"] == pos:
        del crate


def inv_getData(client, invID):

    try:
        # check if player Inventory (mostly used)
        if invID == client.puid:
            return client.cData
        else:
            # Check if temporary/Session Crates (used while looting, so 2nd place)
            try:
                return client.sData.database.sessionCrates[invID]
            # Last try: Check the persistent Inventories (most likely the less used from the 3 options)
            except KeyError:
                try:
                    return client.sData.database.crates[invID]
                except KeyError:
                    print('ERROR: INV_HANDLER: ITEM_MOVE: inv_getData NOT FOUND')
                    return
    except KeyError:
        print('ERROR: INV_HANDLER: ITEM_MOVE: inv_getData NOT FOUND')
        return
    except Exception as e:
        print(f'ERROR: INV_HANDLER: ITEM_MOVE: inv_getData - UNKNOWN ERROR:\n{e}')
        return


# usedSlots = slots occupied by the given Item Size INSIDE the invGrid!
def inv_usedSlots_get(slotsStart=None, sizeItem=None, invGrid=None, isFlipped=0, isAdd=True):
    if None in [slotsStart, sizeItem, invGrid]:
        return []

    unblocked = 0
    if not isAdd:
        unblocked = 1

    xin, yin = slotsStart
    # print(slots)
    if isFlipped == 0:
        xit, yit = sizeItem
    else:
        yit, xit = sizeItem
    # print(size)
    slots_used = []
    try:
        for xpos in range(xit):
            for ypos in range(yit):
                try:
                    slotNum = invGrid[xin+xpos][yin+ypos]
                    if slotNum != unblocked:
                        print("slots occupied")
                        return []
                    else:
                        slots_used.append([xin+xpos, yin+ypos])
                except IndexError:
                    print("Parts of the Item are outside the Inventory ")
                    return []
    except Exception as e:
        print(f'ERROR: INV_HANDLER: ITEM_MOVE: inv_usedSlots_get - ERROR:\n{e}')
        return []

    return slots_used


def inv_usedSlots_set(slots_used=None, invGrid=None, isAdd=True):
    if None in [slots_used, invGrid]:
        print(f'ERROR: INV_HANDLER: ITEM_MOVE: inv_usedSlots_set - ERROR: slots_used: {slots_used} - invGrid: {invGrid}')
        return False

    usageType = 1
    if not isAdd:
        usageType = 0

    if len(slots_used) > 0:
        print("free slots found")
        for index in range(len(slots_used)):
            x, y = slots_used[index]
            invGrid[x][y] = usageType
    return True


def inv_grid_get(client=None, args=()):
    print('FUNCTION CALLED BY REMOTE: "inv_get_grid"')
    gridID = args[0]

    data = inv_getData(client, gridID)["inv_grid"]
    print(f"gridID: {gridID}\ndata: {data}")

    con = client.con_client
    asc_g_msg.sendMsg("ret_inv_get_grid", data, con)


def inv_items_get(client=None, args=()):
    print('FUNCTION CALLED BY REMOTE: "inv_get_items"')
    gridID = args[0]

    data = inv_getData(client, gridID)["itemData"]
    print(f"gridID: {gridID}\ndata: {data}")

    con = client.con_client
    asc_g_msg.sendMsg("ret_inv_get_items", data, con)

