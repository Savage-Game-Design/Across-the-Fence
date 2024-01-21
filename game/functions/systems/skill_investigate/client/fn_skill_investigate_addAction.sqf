/*
    File: fn_skill_investigate_addAction.sqf
    Author: Savage Game Design
    Date: 2024-01-21
    Last Update: 2024-01-21
    Public: No

    Description:
        Adds "Stop, Listen" action to the player.

    Parameter(s):
        _player - Player unit [OBJECT]

    Returns:
        Action ID [NUMBER]

    Example(s):
        player call vgm_c_fnc_skill_investigate_addAction
 */

params ["_player"];

[
    _player,
    localize "STR_VGM_SKILL_INVESTIGATE_ACTION",
    "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\listen_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\listen_ca.paa",
    "true",
    "speed _this < 1",
    {
        params ["_target"];
        _target playActionNow "Stop";
        [true] call vgm_c_fnc_skill_investigate_setDesaturation;
        [true] call vgm_c_fnc_skill_investigate_setListenMode;
    },
    {
        // this uses outer scope variables to prevent the ticker from having one "bar" in it.
        private _frame = 3;
        [_target,_actionID,_title,_iconProgress,bis_fnc_holdAction_texturesIn,_frame,"",_orig_iconProgress] call vn_fnc_holdAction_showIcon;
    },
    {},
    {
        params ["_target"];
        if (speed _target >= 1) then {
            hint localize "STR_VGM_SKILL_INVESTIGATE_NOTIFICATION_STATIONARY";
            playSoundUI ["\a3\ui_f_curator\Data\Sound\CfgSound\error02.wss", 0.1];
        };

        [false] call vgm_c_fnc_skill_investigate_setDesaturation;
        [false] call vgm_c_fnc_skill_investigate_setListenMode;
    },
    [],
    1e38,
    -50,
    false,
    false,
    true
] call VN_fnc_holdActionAdd;
