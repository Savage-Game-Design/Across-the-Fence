/*
    File: sites_getTemplate.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-06-27
    Public: Yes

    Description:
        Fetches a minimal template for site.

    Parameter(s):


    Returns:
        A site template, able to be modified [HashMap]

    Example(s):
        private _myNewSite = [] call vgm_s_fnc_sites_getTemplate;
 */

createHashMapFromArray [
    // Localizable name for the site, that may be displayed to players
    ["name", "STR_VGM_SITES_PLACEHOLDER"],
    // Called to spawn the site.
    ["spawnFunction", {
        params ["_pos2D"];

        // Format: [ [ All Objects Created ] ]
        [[]]
    }],
    ["fortifications", [
        /*
        createHashMapFromArray [
            // ID of the fortification to spawn
            ["typeId", "vgm_mg_nest"],
            // Max radius where it can be spawned.
            ["radius", 200],
            // How often should this occur, relative to the other fortifications.
            ["weight", 2],
        ]
        */
    ]]
]

