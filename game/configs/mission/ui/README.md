# ACROSS THE FENCE - UI SYSTEM
This document serves as an explanation of the user interface (UI) system used by Across the Fence. It will cover the following topics:

1. [Macros](#macros)
2. [Configs](#configs)
    1. [Controls](#controls)
    2. [Displays](#displays)
3. [Scripts](#scripts)

## Macros
- Location: [game\configs\mission\ui\inc][dir_inc]
- Purpose: Simplifying repetitive usage of commands in configs and scripts.
- Content:

| File | Explanation |
|------|-------------|
| [coordinates.inc][f_coords] | Contains macros for positioning controls |
| [idcs.inc][f_idcs] | Macros for identifiying controls and displays |
| [macros.inc][f_macros] | Miscellaneous macros, also includes `coordinates.inc` and `idcs.inc`

Further explanation of specific macros can be found in the files in which they are defined.

## Configs
- Location: [game\configs\mission\ui][dir_this]
- Purpose: Defining the visual style of the UI
- Content:

| File | Explanation |
|------|-------------|
| [controls.hpp][f_controls] | Classes which can be inherited from in different UIs |
| [ui_main.hpp][f_uimain] | Entry point for the config (description.ext or config.cpp) |
| VGM_Display*.hpp | The actual config for a UI |

### Controls
Classes which are used across multiple files should be put into [controls.hpp][f_controls]. Controls which are only used in the same file should inherit from another if possible. The base class should be named as follows: `VGM_ctrlExample`. `VGM` indicates the control is part of the game mode, `ctrl` indicates usage of the pixel grid system and `Example` follows the standard naming conventions.

If possible controls should inherit from Eden controls to avoid a bloated config. The `size` and `sizeEx` attributes as well as colors have to be adjusted accordingly.

### Displays
The classname of a display should have the following format: `VGM_DisplayExample`, where `VGM` indicates that the display is part of this gamemode, `Display` indicates that the pixel grid system is used and `Example` can be replaced by any string that satisfies the usual naming conventions for configs.

The display's config should be placed in a file which has the same name as the display inside [this][dir_this] folder, e.g. `VGM_DisplayExample.hpp`. This file should then be included in [ui_main.hpp][f_uimain], e.g.
```cpp
#include "VGM_DisplayExample.hpp"
```


## Scripts
- Location: [game\functions\core\client\displays][dir_fnc]
- Purpose: Add functionality to the UIs
- Content:

| File | Explanation |
|------|-------------|
| [macros.inc][f_fncmacros] | Includes the macros from [game\configs\mission\ui\inc][dir_inc]
| fn_display*.sqf | The function which will be called by the UI

The function that should be called by the UI should have the same name as the name in the classname, e.g. `VGM_DisplayExample` calls `vgm_c_fnc_displayExample`. To achieve this a file called `fn_displayExample.sqf` needs to be created in [game\functions\core\client\displays][dir_fnc] and a new entry must be added to the [functions config][f_fnccfg] under the displays category.

Inside of the UI script you can include the [macros][f_macros] by writing
```sqf
#include "macros.inc"
```
which will indirectly include the macro file from the config folder.


[dir_this]: .
[f_controls]: controls.hpp
[f_uimain]: ui_main.hpp
[dir_inc]: inc
[f_macros]: inc/macros.inc
[f_coords]: inc/coordinates.inc
[f_idcs]: inc/idcs.inc
[dir_fnc]: /game/functions/core/client/displays
[f_fnccfg]: /game/functions/functions_client.hpp
[f_fncmacros]: /game/functions/core/client/displays/macros.inc
