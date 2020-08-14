# from anarchy_main import inventory
from . import id_handler


itemData = {
        "item":    (0, [2, 2]),
        "tool":    (1, [5, 5]),
        "wpn_pri": (2, [4, 8]),
        "wpn_sec": (3, [4, 4]),
        "wpn_lau": (4, [4, 10]),
    }

############

# ToDo: add precise definitions, used in all Classes
# class ItemBaseFnc:
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


def item_create(**kwargs):
    item = {
        "id":          id_handler.create_id(),   # Item ID - Will ALWAYS be generated!

        # ----------------------------------------------------------- #
        "type":        0,               # Baseclass in Arma
        # translates in Arma to a Config Baseclass, like: CfgVehicles/CfgMagazines/etc.
        # At the same time, it's an indicator, in which the Item can put it in!
        # ----------------------------------------------------------- #

        "class_name":  "",              # Arma Cfg-name
        "rarity":      0,               # Rarity
        "hp_cur":      100,             # Current HP
        "hp_max":      100,             # Max HP

        # ----------------------------------------------------------- #
        "size":        [4, 4],          # Size in Inventory
        # Format: [ Size Rows, Size Columns ]
        # Example: [2, 4] == 2 Rows/Y/height, 4 Cols/X/width
        # Visualization:
        # [1,1,1,1,0]
        # [1,1,1,1,0]
        # ----------------------------------------------------------- #

        # ----------------------------------------------------------- #
        # ToDo: if newly spawned: Calculate possible position in Inventory (self.curInv)
        "invPos":      [0, 0],  # TopLeft Position of the Item in the InventoryGrid
        # Format: [ Row Pos, Col Pos]
        # Example: [0,1] == First Row, 2nd "Column"/Index (since we start from 0)
        # Visualization:
        # [0,>>1<<,0,0,0]
        # ----------------------------------------------------------- #

        # ----------------------------------------------------------- #
        "isFlipped":   0,               # 0/1 - Check if Item was flipped
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
            "scope": "",                # ID of used Item
            "magazine": "",             # ID of used Item
            "muzzle": "",               # ID of used Item
            "barrel": "",               # ID of used Item
            "support": "",              # ID of used Item
            },
        "curInv": "-1",                 # ID of Inventory, that the Item is in
        "addInvSpace": 0,               # does Item add Inventory space?
        }

    item.update(kwargs)
    # print(item)
    return item
