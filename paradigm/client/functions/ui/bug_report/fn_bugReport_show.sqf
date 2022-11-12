/**
    File: fn_bugReport_show.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Opens the bug report form, once user click submit, calls the callback with user's text, passed metadata and additional data:
            productVersion - refer to BI wiki for content (at the time of the opening of the dialog)
            language
            screen
            steamId
            profileName
            systemTimeUTC
            systemTime
            diag_tickTime
            serverTime
            getPos
            unitAimPosition
            eyePos
            weaponDirection
            getCameraViewDirection
            diag_fps
            isStreamFriendlyUIEnabled
            cheatsEnabled
            __A3_DEBUG__ - (BOOL) https://community.bistudio.com/wiki/PreProcessor_Commands#A3_DEBUG
            __DATE_STR_ISO8601__ - (STRING) Time when the player joined the mission (or rather, time when the script was last compiled)
            #REVISION - (STRING) VN Revision, "0.00.000000" if not able to find
            #supportInfo - (INT) `count supportInfo ""`
            #sentTimeUTC - (STRING) When the user clicked the submit button

        The idea between _metadata and _super is that _metadata is controlled by the function caller and can change from report to report, while _super does not (the value can, but the field will always be the same)
    
    Parameter(s):
		  _callback - Metadata with the params [_metadata (HashMap), _super (HashMap - See above), _text] [CODE, defaults to { systemChat format ["[DEBUG] Bug report sent => %1", [_metadata, _super, _text]]; }]
		  _text - Prefiled text [STRING, defaults to "" (empty string)]
		  _metadata - Metadata [HASH, defaults to (empty hashMap)]
    
    Returns: nothing
    
    Example(s):
		call para_c_fnc_bugReport_show;
*/

// call compile preprocessFileLineNumbers "paradigm\Client\functions\ui\bug_report\fn_bugReport_show.sqf"
// #include "\a3\ui_f\hpp\definedikcodes.inc"
// #include "..\..\..\configs\ui\ui_def_base.inc"
// #define para_RscDisplayBuildingMenu_headerHeight (UIH(1))
// #define para_RscDisplayBuildingMenu_gutterHeight (UIH(0.1))
// #define para_RscDisplayBuildingMenu_gutterWidth (UIW(0.1))
// #define para_RscDisplayBuildingMenu_backgroundHeight (UIH(25) - para_RscDisplayBuildingMenu_headerHeight - para_RscDisplayBuildingMenu_gutterHeight)
// #define para_RscDisplayBuildingMenu_paddingHeight (UIH(0.5))
// #define para_RscDisplayBuildingMenu_paddingWidth (UIW(0.5))

params [
    ["_callback", { systemChat format ["[DEBUG] Bug report sent => %1", [_metadata, _super, _text]]; }, [{}]],
    ["_text", "", [""]],
    ["_metadata", createHashMap, [createHashMap]]
];
[displayNull, _callback, _text, _metadata] call para_c_fnc_bugReport_init;
