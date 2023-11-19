#include "\A3\Ui_f\hpp\defineResinclDesign.inc"
/*
    File: fn_equipment_arsenalInit.sqf
    Author: Savage Game Design
    Date: 2023-11-19
    Last Update: 2023-11-19
    Public: No

    Description:
        Init gamemode functionalities in BI Arsenal.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [parameter] call vgm_c_fnc_equipment_arsenalInit
 */

[true, "arsenalPreOpen", {
    // Add our special Medical items to "Misc" tab
    {BIS_fnc_arsenal_data select 24 pushBackUnique _x} forEach ["vn_helper_item_firstaidkit", "vn_helper_item_medikit"];
}] call BIS_fnc_addScriptedEventHandler;


[true, "arsenalOpened", {
    params ["_display"];

    private _ctrlButtonOk = _display displayCtrl IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONOK;
    private _ctrlLbTemplates = _display displayCtrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;


    private _fnc_validateLoadout = {
        params ["_ctrl"];
        private _display = ctrlParent _ctrl;
        if (_display getVariable ["saveMode", false]) exitWith {};

        _display spawn {
            private _loadout = getUnitLoadout player;
            private _filteredLoadout = [+_loadout] call vgm_c_fnc_equipment_filterLoadout;
            if (_filteredLoadout isNotEqualTo _loadout) then {
                ["showMessage", [_this, localize "STR_A3_RscDisplayArsenal_message_unavailable"]] call BIS_fnc_arsenal;
                player setUnitLoadout _filteredLoadout;

                ["ListSelectCurrent", _this] call BIS_fnc_arsenal;
            };
        };
    };

    _ctrlButtonOk ctrlAddEventHandler ["ButtonClick", _fnc_validateLoadout];
    _ctrlLbTemplates ctrlAddEventHandler ["LbDblClick", _fnc_validateLoadout];
}] call BIS_fnc_addScriptedEventHandler;

[true, "arsenalClosed", {
    private _loadout = getUnitLoadout player;
    private _filteredLoadout = [+_loadout] call vgm_c_fnc_equipment_filterLoadout;
    if (_filteredLoadout isNotEqualTo _loadout) then {
        localize "STR_A3_RscDisplayArsenal_message_unavailable" spawn BIS_fnc_guiMessage;
        player setUnitLoadout _filteredLoadout;
    };
}] call BIS_fnc_addScriptedEventHandler;

// Prevent arsenal "Open" from adding the action to the player
player setvariable ["BIS_fnc_arsenal_action", -1];
