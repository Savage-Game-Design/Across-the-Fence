#include "\a3\ui_f\hpp\defineDIKCodes.inc"

/*
    File: fn_tutorial_preInit.sqf
    Author:
    Date: 2024-11-16
    Last Update: 2024-11-17
    Public: No

    Description:
        PreInit for the tutorial system

*/

if (!hasInterface) exitWith {};
[] call para_c_fnc_ui_hints_setup;

[
    createHashMapFromArray [
        ["name", "TutorialAcknowledgeHint"],
        ["displayName", "STR_VGM_TUTORIAL_UI_ACKNOWLEDGE_HINT"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["dikCode", DIK_8]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;
["TutorialAcknowledgeHint", para_c_fnc_ui_hints_acknowledgeHintKeypress] call para_c_fnc_keyhandler_addGeneralActionHandler;

// Ideally store this on the server.
vgm_c_tutorial_seenTutorials = missionProfileNamespace getVariable ["vgm_tutorial_seenTutorials", createHashMap];
