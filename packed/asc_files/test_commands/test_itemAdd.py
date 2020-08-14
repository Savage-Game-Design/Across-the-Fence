from asc_fnc import asc_g_msg
from anarchy_main.inventory import *

def test_itemAdd(client=None, args=()):
    if client is None:
        print('ERROR: test_itemAdd: "CLIENT" NOT PASSED')
        return
    try:
        # invID = either "getPlayerUID" for players OR "randomID" for Crates
        itemID, invID, isFlipped, invPos = args
        print(f"ARGS: {args}")
        print(f"itemID: {itemID}")
        print(f"invID: {invID}")
        print(f"isFlipped: {isFlipped}")
        print(f"invPos: {invPos}")
        # print(f"cData: {client.cData}")

        newItem = item_handler.item_create(
                class_name="item_Test_0",
                rarity=1,
                hp_cur=55,
                hp_max=100,
                size=[3, 3],
                invPos=invPos,
                curInv=invID,
                addInvSpace=0,
                )

        print(newItem)
        client.cData["itemData"][newItem["id"]] = newItem
        print(client.cData["itemData"])
        # ToDo: TEMP! Saving will be done by an extra Thread from the Server!
        client.sData.database.db_save()

    except IndexError:
        print(f"ERROR: test_itemAdd: args wrong! args = {args}")
