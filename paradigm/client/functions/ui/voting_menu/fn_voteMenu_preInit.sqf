#include "\a3\ui_f\hpp\defineDIKCodes.inc"

/*
    File: fn_voteMenu_preInit.sqf
    Author: Savage Game Design
    Date: 2025-11-08
    Last Update: 2025-11-08
    Public: No

    Description:
        Preinit for the voting menu
 */

[
    createHashMapFromArray [
        ["name", "para_VoteOption1"],
        ["displayName", "STR_PARA_VOTEMENU_OPTION_1"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["dikCode", DIK_F1]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;
["para_VoteOption1", para_c_fnc_vote_1] call para_c_fnc_keyhandler_addGeneralActionHandler;

[
    createHashMapFromArray [
        ["name", "para_VoteOption2"],
        ["displayName", "STR_PARA_VOTEMENU_OPTION_2"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["dikCode", DIK_F2]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;
["para_VoteOption2", para_c_fnc_vote_2] call para_c_fnc_keyhandler_addGeneralActionHandler;

[
    createHashMapFromArray [
        ["name", "para_VoteOption3"],
        ["displayName", "STR_PARA_VOTEMENU_OPTION_3"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["dikCode", DIK_F3]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;
["para_VoteOption3", para_c_fnc_openVoteMenu] call para_c_fnc_keyhandler_addGeneralActionHandler;
