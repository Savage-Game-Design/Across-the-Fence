import random
from . import inv_handler, id_handler

# standard Values for Items
itemData = {
        "item":    (0, [2, 2]),
        "tool":    (1, [5, 5]),
        "wpn_pri": (2, [4, 8]),
        "wpn_sec": (3, [4, 4]),
        "wpn_lau": (4, [4, 10]),
    }

############

# ToDo: add precise definitions, used in all Classes
def check_size(size):
    # if given, check if X/Y are not < 1
    if size[0] < 1:
        size[0] = 1
    if size[1] < 1:
        size[1] = 1
    return size


def check_canFlip(size):
    if size[0] == size[1]:  # if a square -> No need to be flippable, so "0"
        return 0
    else:
        return 1

def inv_data_get(sData, invID):
    # check if it's a temporary/Session Crates first
    try:
        # [ is tempCrate, invData ]
        return [True, sData.database.sessionCrates[invID]]
    # Not a loot-crate? Okay, check if it is a persistent crate
    except KeyError:
        try:
            return [False, sData.database.crates[invID]]
        # Last try: Check if it is a player... (Really? Adding something to a player? Okay... your choice.)
        except KeyError:
            try:
                return [False, sData.database.players[invID]]
            except KeyError:
                print('ERROR: INV_HANDLER: inv_data_get: No Inventory data found')
                return [False, {}]
    except Exception as e:
        print(f'ERROR: INV_HANDLER: inv_data_get: UNKNOWN ERROR:\n{e}')
        return [False, {}]


def item_create(**kwargs):
    item = {
        "id":          id_handler.create_id(),   # Item ID - Will ALWAYS be generated!

        "parentData": "",  # Base Item Data, the A3 UI can refer to (stored ItemData)
        # ----------------------------------------------------------- #
        "slot":        0,           # Baseclass in Arma
        # Used in Arma to determine the slot, in which the Item can put it in!
        # Description:
        # ToDo: Add Description and slot-ID defines somewhere and link it here
        # ----------------------------------------------------------- #
        "class_name": "",           # Arma Cfg-name
        "rarity":      0,           # Rarity
        "hp_cur":      100,         # Current HP
        "hp_max":      100,         # Max HP
        "curInv":      "-1",        # ID of Inventory, that the Item is in
        "addInvSpace": 0,           # does Item add Inventory space?
        "actions": {
            # [stringtable, functionName, fncType (called (0) or spawned (1)), additional params]
            "a1": ["", "", 0, []],
            },

        # ----------------------------------------------------------- #
        "size":        [4, 4],      # Size in Inventory
        # Format: [ Size Rows, Size Columns ]
        # Example: [2, 4] == 2 Rows/Y/height, 4 Cols/X/width
        # Visualization:
        # [1,1,1,1,0]
        # [1,1,1,1,0]
        # ----------------------------------------------------------- #

        # ----------------------------------------------------------- #
        "invPos":      [0, 0],      # TopLeft Position of the Item in the InventoryGrid
        # Format: [ Row Pos, Col Pos]
        # Example: [0,1] == First Row, 2nd "Column"/Index (since we start from 0)
        # Visualization:
        # [0,>>1<<,0,0,0]
        # ----------------------------------------------------------- #

        # ----------------------------------------------------------- #
        "isFlipped":   0,           # 0/1 - Check if Item was flipped
        # Argument is needed to check if the Item was flipped, while placing/moving it into the new Inventory
        # (cleaning up an InvGrid).
        # State: 0 == No changes during moving. Item will stay (example) at: [2 (row), 4 (col)]
        # Visualization:
        # [1,1,1,1,0]
        # [1,1,1,1,0]
        #
        # State: 1 == The size will automatically switch Col and Row entries: [2 (row), 4 (col)] -->> [4 (row),2 (col)]
        # Visualization:
        # [1,1,0,0,0]
        # [1,1,0,0,0]
        # [1,1,0,0,0]
        # [1,1,0,0,0]
        # ----------------------------------------------------------- #
        "attachments": {
            "scope": "",            # TODO: determine what makes more sense: ItemID or full itemData?
            "magazine": "",         # TODO: determine what makes more sense: ItemID or full itemData?
            "muzzle": "",           # TODO: determine what makes more sense: ItemID or full itemData?
            "barrel": "",           # TODO: determine what makes more sense: ItemID or full itemData?
            "support": "",          # TODO: determine what makes more sense: ItemID or full itemData?
            },
        }

    item.update(kwargs)
    # print(item)
    return item


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
    oldInv = inv_handler.inv_getData(client, invID_old)
    oldInv_invGrid = oldInv["inv_grid"]
    # print(f"::::: OLD INV:\n{oldInv}")
    # print(f"::::: OLD INV GRID:\n{oldInv_invGrid}")

    # and the item data
    item = oldInv["itemData"][itemID]
    # print(f"::::: item:\n{item}")

    # also get the new inventory + grid
    newInv = inv_handler.inv_getData(client, invID_new)
    newInv_invGrid = newInv["inv_grid"]
    # print(f"::::: NEW INV:\n{newInv}")
    # print(f"::::: NEW INV GRID:\n{newInv_invGrid}")

    # check if enough space in new Inventory
    # ToDo: Check if it is just moving within the same Inventory and if it is blocked by itself :thonk:
    slots_used_new = inv_handler.inv_usedSlots_get(slotsStart=invPos, invGrid=newInv_invGrid, isFlipped=isFlipped, sizeItem=item["size"], isAdd=True)
    print(f"::::: slots_used: {slots_used_new}")
    if len(slots_used_new) == 0:
        # ToDo: Send both Inventories back to the player, to update his UI (later)
        print("INVENTORY: Item can NOT be added")
        return
    else:
        # get pos in old invGrid and check if everything is correct there
        isFlipped_cur = item["isFlipped"]
        slots_used_old = inv_handler.inv_usedSlots_get(slotsStart=item["invPos"], invGrid=oldInv_invGrid, isFlipped=isFlipped_cur, sizeItem=item["size"], isAdd=False)
        if len(slots_used_old) == 0:
            # ToDo: Send both Inventories back to the player, to update his UI (later)
            print("INVENTORY: Something was wrong with the old Item State - no blocked tiles found")
            return

        # and remove it from the old Inventory Grid
        inv_handler.inv_usedSlots_set(slots_used=slots_used_old, invGrid=oldInv_invGrid, isAdd=False)
        # also delete from "itemData" dict
        del oldInv["itemData"][itemID]

        # update Item
        item["invPos"] = invPos
        item["curInv"] = invID_new
        item["isFlipped"] = isFlipped

        # set the used slots in the new Inventory Grid
        inv_handler.inv_usedSlots_set(slots_used=slots_used_new, invGrid=newInv_invGrid, isAdd=True)

        # and add it to the new Inventory itemData
        newInv["itemData"][item["id"]] = item
        # print(newInv["itemData"])

    # ToDo: TEMP! Saving will be done by an extra Thread from the Server!
    client.sData.database.db_save()

def item_add_list(sData, invID: str = "", itemList: list = None):
    """
    Add new Item(s) to an existing Inventory

    :param sData:
    :param invID:       Inventory ID (either crates (persistent/temporary) or playerUID)
    :param itemList:    [
                            [
                                "class_name",
                                type,
                                rarity,
                                hp_cur,
                                hp_max,
                                size,
                                addInvSpace     # adds Inventory space - e.g: Uniform, Backpack, Pouch
                            ]
                        ]
    :return:
    """
    if itemList is None:
        print(f"DEBUG: item_add_list: itemList NOT found.\ninvID: {invID}\nitemList: {itemList}\n-------------")
        return

    # get Data from the database
    isTempInv, invData = inv_data_get(sData=sData, invID=invID)
    # if len(invData.keys) == 0:
    #     print(f"DEBUG: item_add_list: invData NOT found.\ninvID: {invID}\nitemList: {itemList}\n-------------")
    #     return

    invGrid = invData["inv_grid"]
    inv_itemData = invData["itemData"]

    for x_ItemData in itemList:
        # check if the Size is correct (e.g.: non-0-values)
        x_size = check_size(x_ItemData[5])

        # set the invGrid vars
        grid_rows = len(invGrid)
        grid_cols = len(invGrid[0])

        # find free slots for the Item (if (AND ONLY IF) it is a temp Inventory -> Add more rows, if needed!)
        while True:
            slot_usage = item_getFreeSlots(grid_rows=grid_rows, grid_cols=grid_cols, item_size=x_size, invGrid=invGrid)
            if len(slot_usage) == 0:
                if isTempInv:
                    # add a new row to the tempInventory
                    newRow = [0] * grid_cols
                    invGrid.append(newRow)
                    grid_rows = len(invGrid)
                    grid_cols = len(invGrid[0])
                    if grid_rows > 75:  # seems like, that something went pretty wrong there
                        break
                    print(f"DEBUG: item_add_list: No free slots found. Adding new row. Count: {grid_rows}\n-------------")
                else:
                    break
            else:
                break

        # ToDo: Calculate the rarity, depending on the player Skill
        if len(slot_usage) != 0:
            newItem = item_create(
                    class_name=x_ItemData[0],
                    type=x_ItemData[1],
                    rarity=x_ItemData[2],
                    hp_cur=x_ItemData[3],
                    hp_max=x_ItemData[4],
                    size=x_size,
                    isFlipped=0,
                    invPos=slot_usage,
                    curInv=invID,
                    addInvSpace=x_ItemData[6],
                    )
            print(newItem)

            # update the Inventory Grid and the itemData for it
            inv_handler.inv_usedSlots_set(slots_used=slot_usage, invGrid=invGrid, isAdd=True)
            invData["inv_grid"] = invGrid
            inv_itemData[newItem["id"]] = newItem
        else:
            print(f"ERROR: item_add_list: No free slots found for x_ItemData:\n{x_ItemData}\n RowCount: {grid_rows}\n-------------")

    # client.cData["itemData"][newItem["id"]] = newItem
    # print(client.cData["itemData"])
    # # ToDo: TEMP! Saving will be done by an extra Thread from the Server! e.g. every 10 "pushes" OR every 10s -> save data to file
    # client.sData.database.db_save()


def item_getFreeSlots(grid_rows, grid_cols, item_size, invGrid):
    # ToDo: make a check if Item can be flipped and try to find space again (later)
    grid_rows_maxCheck = grid_rows - item_size[0]   # no need to check the x-axis further, if the height would be outside of bounds
    grid_cols_maxCheck = grid_cols - item_size[1]  # no need to check the y-axis further, if the width would be outside of bounds
    slots = []
    for x in range(0, grid_rows):
        if x > grid_rows_maxCheck:
            # max reached, return empty Array (triggers addRow (tempInventory) OR shows Error Message
            return []
        for y in range(0, grid_cols):
            if y > grid_cols_maxCheck:
                break
            slots = inv_handler.inv_usedSlots_get(slotsStart=[x, y], sizeItem=item_size, invGrid=invGrid, isFlipped=0, isAdd=True)
            # if slots were found, exit the search/loop
            if len(slots) != 0:
                return slots
        # if slots were found, exit the search/loop
        if len(slots) != 0:
            return slots
    # Normally, this one should never trigger... but who knows /shrug
    return []


def loot_generate(sData, x_dict, itemInfo=None):
    if itemInfo is None:
        itemInfo = []

    # select random item
    selected_type = random.choices(list(x_dict.keys()), weights=list(x_dict.values()), k=1)[0]
    # print(f"DEBUG: loot_generate: selected_type: {selected_type}")
    itemInfo.append(selected_type)
    # check if selected_type exists other wise return class
    if selected_type in sData.lootData["tables"]:
        # print(f"DEBUG: initial_seed LG: {initial_seed}")
        return loot_generate(sData, sData.lootData["tables"][selected_type], itemInfo)
    else:
        # return itemInfo
        print(f"DEBUG: loot_generate: selected_type: {selected_type}")
        return selected_type


def return_loot_list(sData, skill_scavenging, crate_id, loot_type, loot_count):
    initial_seed = f"{sData.lootData['globalseed']} - {crate_id} - {loot_type}"
    print(f"DEBUG: return_loot_list: initial_seed: {initial_seed}")
    # list of item names
    loot_list = []
    # check if loot_type exists
    if loot_type in sData.lootData["tables"]:
        for x in range(loot_count):
            loot_list.append(loot_generate(sData, sData.lootData["tables"][loot_type]))

    # get the base Data for each Item
    itemList = []
    for item in loot_list:
        try:
            # ToDo: Create Items and add to crate with the given crate_ID
            print(sData.itemData[item])
        except KeyError:
            print(f"DEBUG: return_loot_list: KeyError: item: {item}")

    return loot_list

    # ############################# NOTE:
    # print(return_loot_list("98372491", "type_military", 3))
