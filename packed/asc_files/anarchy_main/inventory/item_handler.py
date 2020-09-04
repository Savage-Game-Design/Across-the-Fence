import random
from . import inv_handler, id_handler

############

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


def item_create(parent: str = ""):
    """

    :param parent:  STR - Name of parent/base from itemData
    :return:        ToDo
    """

    item = {
        "id":           id_handler.create_id(),        # Item ID - Will ALWAYS be generated!
        "parent":       parent,           # Base Item Data, the A3 UI can refer to (stored ItemData)
        "rarity":       0,           # Rarity
        "hp_cur":       100,         # Current HP
        "hp_max":       100,         # Max HP
        "curInv":       "-1",        # ID of Inventory, that the Item is in
        "invPos":       [0, 0],      # TopLeft Position of the Item in the InventoryGrid
        "isFlipped":    0,           # 0/1 - Check if Item was flipped
        "attachments":  {
            "scope": "",            # TODO: determine what makes more sense: ItemID or full itemData?
            "magazine": "",         # TODO: determine what makes more sense: ItemID or full itemData?
            "muzzle": "",           # TODO: determine what makes more sense: ItemID or full itemData?
            "barrel": "",           # TODO: determine what makes more sense: ItemID or full itemData?
            "support": "",          # TODO: determine what makes more sense: ItemID or full itemData?
            },
        }

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
    slots_used_new = inv_handler.inv_slots_used_get(slotsStart=invPos, invGrid=newInv_invGrid, isFlipped=isFlipped, sizeItem=item["size"], isAdd=True)
    print(f"::::: slots_used: {slots_used_new}")
    if len(slots_used_new) == 0:
        # ToDo: Send both Inventories back to the player, to update his UI (later)
        print("INVENTORY: Item can NOT be added")
        return
    else:
        # get pos in old invGrid and check if everything is correct there
        isFlipped_cur = item["isFlipped"]
        slots_used_old = inv_handler.inv_slots_used_get(slotsStart=item["invPos"], invGrid=oldInv_invGrid, isFlipped=isFlipped_cur, sizeItem=item["size"], isAdd=False)
        if len(slots_used_old) == 0:
            # ToDo: Send both Inventories back to the player, to update his UI (later)
            print("INVENTORY: Something was wrong with the old Item State - no blocked tiles found")
            return

        # and remove it from the old Inventory Grid
        inv_handler.inv_slots_used_set(slots_used=slots_used_old, invGrid=oldInv_invGrid, isAdd=False)
        # also delete from "itemData" dict
        del oldInv["itemData"][itemID]

        # update Item
        item["invPos"] = invPos
        item["curInv"] = invID_new
        item["isFlipped"] = isFlipped

        # set the used slots in the new Inventory Grid
        inv_handler.inv_slots_used_set(slots_used=slots_used_new, invGrid=newInv_invGrid, isAdd=True)

        # and add it to the new Inventory itemData
        newInv["itemData"][item["id"]] = item
        # print(newInv["itemData"])

    # ToDo: TEMP! Saving will be done by an extra Thread from the Server!
    client.sData.database.db_save()

def item_add_to_inv(sData, invData=None, isLootcrate: int = 0, item=None):
    try:
        if None in [item, invData]:
            print(f"ERROR: item_add_list: item NOT found.\ninvID: {invData}\nitem: {item}------")
            return

        invGrid = invData["inv_grid"]
        invGridSize = invData["inv_gridSize"]
        inv_itemData = invData["itemData"]

        #########################################################
        # check if the Size is correct (e.g.: values > 0)
        item_parent_data = item_get_parentData(sData=sData, itemName=item["parent"])
        if len(item_parent_data) == 0:
            print(f"ERROR: item_handler: item_add_to_inv: item_parent_data NOT FOUND - item['parent']: {item['parent']}")
            return invData

        x_size = check_size(item_parent_data["size"])

        # get the invGrid start vars
        grid_rows, grid_cols = invGridSize
        # keep count of how many rows will be added in the end (IF isLootcrate == 1)
        grid_rows_final = len(invGrid)

        # find free slots for the Item (if (AND ONLY IF) it is a temp Inventory -> Add more rows, if needed!)
        while True:
            slot_usage = inv_handler.inv_slots_free_get(invGrid=invGrid, item_size=x_size)
            if len(slot_usage) == 0:
                print(f"DEBUG: item_handler: item_add_to_inv: No free slots found.")
                if isLootcrate > 0:
                    print(f"DEBUG: item_handler: item_add_to_inv: It's a lootcrate -> Adding new row. Count: {grid_rows_final}\n-------------")
                    # add a new row to the tempInventory
                    newRow = [0] * grid_cols
                    invGrid.append(newRow)
                    grid_rows_final = len(invGrid)
                    # grid_cols = len(invGrid[0])

                    if grid_rows_final > 75:
                        # seems like, that something went pretty wrong there
                        grid_rows_final = grid_rows
                        break
                else:
                    break
            else:
                print(f"DEBUG: item_handler: item_add_to_inv: slot_usage: {slot_usage}")
                break

        # check if there were slots found
        if len(slot_usage) > 0:
            # update the Inventory Grid, its gridSize ...
            inv_handler.inv_slots_used_set(slots_used=slot_usage, invGrid=invGrid, isAdd=True)
            invData["inv_grid"] = invGrid
            invData["inv_gridSize"] = [grid_rows_final, grid_cols]
            invData["itemData"] = inv_itemData

            # ... and add the item to its itemData
            inv_itemData[item["id"]] = item

            # also update the items InventoryPosition. Set the first entry (top left corner) as inventoryPos
            item["invPos"] = slot_usage[0]
        else:
            print(f"ERROR: item_add_list: No free slots found for x_ItemData:\n{item}\n RowCount: {grid_rows}\n-------------")
        #########################################################

        # return the updated invData!
        print(f"invData:\n{invData}")
        return [invData, item]

        # client.cData["itemData"][newItem["id"]] = newItem
        # print(client.cData["itemData"])
        # # ToDo: TEMP! Saving will be done by an extra Thread from the Server! e.g. every 10 "pushes" OR every 10s -> save data to file
        # client.sData.database.db_save()
    except Exception as e:
        print(f"-------------\nERROR: item_add_list: EXCEPTION:\n{e}\n-------------")


def loot_item_generate(sData, x_dict, itemInfo=None):
    if itemInfo is None:
        itemInfo = []

    # select random item
    selected_type = random.choices(list(x_dict.keys()), weights=list(x_dict.values()), k=1)[0]
    # print(f"DEBUG: loot_item_generate: selected_type: {selected_type}")
    itemInfo.append(selected_type)
    # check if selected_type exists other wise return class
    if selected_type in sData.lootData["tables"]:
        # print(f"DEBUG: initial_seed LG: {initial_seed}")
        return loot_item_generate(sData, sData.lootData["tables"][selected_type], itemInfo)
    else:
        # return itemInfo
        print(f"DEBUG: loot_item_generate: selected_type: {selected_type}")
        return selected_type


def loot_item_list_create(sData, crate_id, loot_type, loot_count):
    """
    :param sData:       OBJ - Main serverData
    :param crate_id:    STR - ID of given Crate
    :param loot_type:   STR - Which loot-table should be loaded
    :param loot_count:  INT - Amount of Items to be created
    :return:            Array with itemNames. Example: ["item1", "item2"]
    """
    initial_seed = f"{sData.lootData['globalseed']} - {crate_id} - {loot_type}"
    print(f"DEBUG: loot_item_list_create: initial_seed: {initial_seed}")
    # list of item names
    loot_list = []
    # check if loot_type exists
    if loot_type in sData.lootData["tables"]:
        for x in range(loot_count):
            loot_list.append(loot_item_generate(sData, sData.lootData["tables"][loot_type]))

    # return the loot_list array with the their item-names
    return loot_list
    # ############################# NOTE:
    # print(loot_item_list_create("98372491", "type_military", 3))


def item_get_parentData(sData, itemName: str = None):
    if itemName is None:
        print(f"ERROR: item_get_parentData: NO itemName given!")
        return {}
    # get the parent-itemData
    try:
        return sData.itemData[itemName]
    except KeyError:
        print(f"ERROR: item_get_parentData: KeyError: itemName: {itemName}")
