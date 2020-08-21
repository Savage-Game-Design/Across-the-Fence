from . import id_handler
from asc_fnc.asc_db.database import asc_db
from asc_fnc import asc_g_msg

DEVMODE = True
# inventory = []
def invGrid_create(grid_x, grid_y):
    ret = []
    for x in range(grid_y):
        _line = [0] * grid_x
        ret.append(_line)
    return ret


def crate_data_get(sData, clientID: str = None, pos: list = None, persistent=False, invGridSize: list = None):

    # ToDo: TEMP! IDs will be created by the loot mechanic later
    # crateID = id_handler.create_id()
    crateID = f"{pos[0]}{pos[1]}{pos[2]}".replace('.', '')

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

    except KeyError:
        print(f"DEBUG: INV_HANDLER: crate_data_get: Creating new Crate")
        crate_add(sData=sData, clientID=clientID, pos=pos, crateID=crateID, persistent=persistent, invGridSize=invGridSize)
    except Exception:
        print(f"ERROR: INV_HANDLER: crate_data_get: HUGE WOBBLE WOBBLE! Data:\ncrateID: {crateID}\nclientID: {clientID}\npos: {pos}\npersistent: {persistent}\ninvGridSize {invGridSize}\n---------")

# called by Server only!
def crate_add(sData, clientID: str = None, pos: list = None, crateID: str = "", persistent=False, model: str = "IG_supplyCrate_F", invGridSize: list = None):
    """
    :param sData:       ServerData (auto-passed)
    :param clientID:    A3 playerUID
    :param pos:         list - [[x,y,z],dir]
    :param crateID:
    :param persistent:  Save to Database or not
    :param model:       A3 typeOf Class
    :param invGridSize: list - Inventory grid
    :return:
    """

    if None in [clientID, pos]:
        print(f"ERROR: INV_HANDLER: create_add: clientID or Pos not transmitted: {clientID}")
        return
    if invGridSize is None:
        invGridSize = [4, 8]

    if persistent:
        # only persistent Crates store the model
        model = model
    else:
        model = "TEMP"

    grid_y, grid_x = invGridSize

    # Todo: Determine if created crate was from a loot request
    # ToDo: If loot request: Fill crate with Items
    # ToDo: If loot request: adjust invGridSize, according to used space
    # ToDo: write fill-mechanic (hmpf... how many todos has this one...)

    inv_data = {
        "model": model,
        "pos": pos,
        "inv_grid": invGrid_create(grid_x, grid_y),
        "inv_gridSize": invGridSize,    # [y, x] / [rows, columns]
        "itemData": {}
        }

    print(f"CRATE ADD:\n"
          f"crateID     : {crateID}\n"
          f"Model       : {model}\n"
          f"Pos         : {pos}\n"
          f"InvGridSize : {invGridSize}\n"
          f"inv_data    : {inv_data}")

    if persistent:
        sData.database.crates[crateID] = inv_data
        asc_db.db_save(sData.database)
    else:
        sData.database.sessionCrates[crateID] = inv_data

    # send Inventory data back to the requesting client
    conClient = sData.user_active[clientID]["con"]
    # asc_g_msg.sendMsg("ret_inv_crateData", retdata, conClient)
    asc_g_msg.sendMsg("ret_inv_crateData", inv_data, conClient)

# called by Server only!
def crate_rem(sData, createID, pos):
    crate = sData.database.crates[createID]
    # kind of security check
    if crate["pos"] == pos:
        del crate


def item_move(client=None, args=()):
    if client is None:
        print('ERROR: INV_HANDLER: ITEM_MOVE: "CLIENT" NOT PASSED')
        return

    print(f"ARGS: {args}")
    try:
        # invID = either "getPlayerUID" for players OR "randomID" for Crates
        itemID, invID_old, invID_new, isFlipped, invPos = args
        # print(f"cData: {client.cData}")
    except Exception as e:
        print(f'ERROR: INV_HANDLER: ITEM_MOVE: Could NOT get Data from args:\n{e}\n')
        return

    print(f"itemID: {itemID}")
    print(f"invID_old: {invID_old}")
    print(f"invID_new: {invID_new}")
    print(f"isFlipped: {isFlipped}")
    print(f"invPos: {invPos}")
    print(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")

    # get old Inventory + grid
    oldInv = inv_getData(client, invID_old)
    oldInv_invGrid = oldInv["inv_grid"]
    # print(f"::::: OLD INV:\n{oldInv}")
    # print(f"::::: OLD INV GRID:\n{oldInv_invGrid}")

    # and the item data
    item = oldInv["itemData"][itemID]
    # print(f"::::: item:\n{item}")

    # also get the new inventory + grid
    newInv = inv_getData(client, invID_new)
    newInv_invGrid = newInv["inv_grid"]
    # print(f"::::: NEW INV:\n{newInv}")
    # print(f"::::: NEW INV GRID:\n{newInv_invGrid}")

    # check if enough space in new Inventory
    # ToDo: Check if it is just moving within the same Inventory and if it is blocked by itself :thonk:
    slots_used_new = inv_usedSlots_get(slotsStart=invPos, invGrid=newInv_invGrid, isFlipped=isFlipped, sizeItem=item["size"], isAdd=True)
    print(f"::::: slots_used: {slots_used_new}")
    if len(slots_used_new) == 0:
        # ToDo: Send both Inventories back to the player, to update his UI (later)
        print("INVENTORY: Item can NOT be added")
        return
    else:
        # get pos in old invGrid and check if everything is correct there
        isFlipped_cur = item["isFlipped"]
        slots_used_old = inv_usedSlots_get(slotsStart=item["invPos"], invGrid=oldInv_invGrid, isFlipped=isFlipped_cur, sizeItem=item["size"], isAdd=False)
        if len(slots_used_old) == 0:
            # ToDo: Send both Inventories back to the player, to update his UI (later)
            print("INVENTORY: Something was wrong with the old Item State - no blocked tiles found")
            return

        # and remove it from the old Inventory Grid
        inv_usedSlots_set(slots_used=slots_used_old, invGrid=oldInv_invGrid, isAdd=False)
        # also delete from "itemData" dict
        del oldInv["itemData"][itemID]

        # update Item
        item["invPos"] = invPos
        item["curInv"] = invID_new
        item["isFlipped"] = isFlipped

        # set the used slots in the new Inventory Grid
        inv_usedSlots_set(slots_used=slots_used_new, invGrid=newInv_invGrid, isAdd=True)

        # and add it to the new Inventory itemData
        newInv["itemData"][item["id"]] = item
        # print(newInv["itemData"])

    # ToDo: TEMP! Saving will be done by an extra Thread from the Server!
    client.sData.database.db_save()


def inv_getData(client, invID):
    try:
        # check if player Inventory
        if invID == client.puid:
            return client.cData
        else:
            # Check if temporary/Session Crates
            try:
                return client.sData.database.sessionCrates[invID]
            # Last try: Check the persistent Inventories
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
