#include "macros.inc"

private _uiVariable = "VGM_RscSquad";

params ["_mode", "_this"];
switch _mode do {
    case "onLoad": {
        params ["_display"];
        uiNamespace setVariable [_uiVariable, _display];
        private _ctrlName = _display displayCtrl VGM_IDC_RSCSQUAD_MEMBER_NAME;
        _ctrlName ctrlSetText name player;
    };

    case "addSquadMember": {
        // Adds a new member to the squad UI bar
        params ["_name"];
        private _display = uiNamespace getVariable _uiVariable;
        if (isNil "_display") exitWith {
            diag_log "ERROR: vgm_c_fnc_displaySquad.addSquadMember was called while no display was registered!";
        };

        if (isNull _display) exitWith {
            diag_log "ERROR: vgm_c_fnc_displaySquad.addSquadMember was called while no display was open, but the variable was set in uiNamespace!";
        };

        private _ctrlBar = _display displayCtrl VGM_IDC_RSCSQUAD_BAR;
        private _countMembers = count (allControls _ctrlBar select {ctrlParentControlsGroup _x == _ctrlBar});

        private _ctrlMember = _display ctrlCreate [missionConfigFile >> "RscTitles" >> "VGM_RscSquad" >> "controls" >> "Bar" >> "Controls" >> "SquadMember", -1, _ctrlBar];
        _ctrlMember ctrlSetPositionX (_countMembers * ((ctrlPosition _ctrlMember select 2) + 0.5 * GUI_GRID_W));
        _ctrlMember ctrlCommit 0;

        private _ctrlName = _ctrlMember controlsGroupCtrl VGM_IDC_RSCSQUAD_MEMBER_NAME;
        _ctrlName ctrlSetText _name;
    };
};

