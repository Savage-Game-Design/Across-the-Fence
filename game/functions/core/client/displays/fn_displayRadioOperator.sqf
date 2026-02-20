/*
    File: fn_displayRadioOperator.sqf
    Author: Savage Game Design, based on Ethan Johnson's original
    Date: 2026-01-25
    Last Update: 2026-02-20
    Public: Yes

    Description:
        Radio operator menu display function

    Parameter(s):
        _mode - Mode to call for the menu [STRING, defaults to ""]
        _params - Mode to call for the menu [ARRAY, defaults to []]

    Returns:
        Function reached the end [BOOL]

    Example(s):
        ["init"] call SELF
*/

#define SELF vgm_c_fnc_displayRadioOperator
#define DISPLAY (uiNamespace getVariable ["VGM_DisplayRadioOperator",displayNull])

#define TITLE    (DISPLAY displayctrl 350)

#define COMMAND_LIST    (DISPLAY displayctrl 102)
#define ASSET_LIST    (DISPLAY displayctrl 103)
#define DESCRIPTION    (DISPLAY displayctrl 203)
#define USES_REMAINING_TEXT    (DISPLAY displayctrl 104)
#define BUTTON   (DISPLAY displayctrl 105)
#define MAP    (DISPLAY displayctrl 7001)

#define ASSET_INDEX    (lbCurSel ASSET_LIST)
#define COMMAND_VALUE    (COMMAND_LIST lbValue (lbCurSel COMMAND_LIST))

#define DIAL_ANGLES [90, 110, 67.5, 125]
#define CHOICE_AIRCRAFT         0
#define CHOICE_RESUPPLY         1
#define CHOICE_ARTILLERY        2
#define CHOICE_TRANSPORT        3

#define MAX_AIRCRAFT_IN_USE 1e32

params
[
    ["_mode","",[""]],
    ["_params",[],[[]]]
];

if (isNil "vgm_c_displayRadioOperator_dialValue") then {
    vgm_c_displayRadioOperator_dialValue = CHOICE_AIRCRAFT;
};

private _availableAircraft = ["rto_availableAircraft", createHashMap] call para_g_fnc_netmap_getOrDefault getOrDefault [getPlayerID player, createHashMap];

if (_mode isEqualTo "draw") exitwith
{
    if (time - (missionNamespace getVariable ["VGM_DisplayRadioOperator_lastGuiRefresh", 0]) > 1) then {
        private _lastStatusArray = missionNamespace getVariable ["VGM_DisplayRadioOperator_statusArray", []];
        private _statusArray = [_availableAircraft] call para_g_fnc_netmap_values apply {[_x] call vgm_g_fnc_rto_getAircraftStatus select 0};
        if (_lastStatusArray isNotEqualTo _statusArray) then {
            ["refreshAll"] call SELF;
            VGM_DisplayRadioOperator_statusArray = _statusArray;
        } else {
            ["refreshTitle"] call SELF;
            ["refreshAircraftListText"] call SELF;
        };
        VGM_DisplayRadioOperator_lastGuiRefresh = time;
    };

    if (isNil "VGM_DisplayRadioOperator_selecting_start" || isNil "VGM_DisplayRadioOperator_selecting_end") exitWith { true };

    { deleteMarkerLocal _x; } foreach vgm_c_displayRadioOperator_markers;
    vgm_c_displayRadioOperator_markers = [];

    if (isNil "vgm_c_displayRadioOperator_aircraftId") exitWith { true };

    private _aircraft = _availableAircraft get vgm_c_displayRadioOperator_aircraftId;

    if (isNil "_aircraft") exitWith { true };

    private _aircraftType = vgm_g_rto_aircraftTypes get (_aircraft get "typeId");

    VGM_DisplayRadioOperator_selecting_start params ["_x","_y"];

    private _hitAreaMarkerSize = abs (_aircraftType getOrDefault ["hitAreaMarkerSize", 50]);
    private _hitAreaMarkerShape = _aircraftType getOrDefault ["hitAreaMarkerShape", "OVAL"];

    private _dir = VGM_DisplayRadioOperator_selecting_end getDir VGM_DisplayRadioOperator_selecting_start;
    if (VGM_DisplayRadioOperator_selecting_end distance2D VGM_DisplayRadioOperator_selecting_start < 1) then {_dir = -180};

    private _name = format["vgm_rto_marker_direction_%1_vehicle", 0];
    private _directionMarker = createMarkerLocal [_name, VGM_DisplayRadioOperator_selecting_start getPos [_hitAreaMarkerSize + 50, _dir]];
    private _markerType = ["loc_plane", "loc_heli"] select (_aircraftType get "vehicleType" == "HELICOPTER");
    _directionMarker setMarkerTypeLocal _markerType;
    _directionMarker setMarkerDirLocal (_dir - 180);
    _directionMarker setMarkerColorLocal "ColorWhite";
    vgm_c_displayRadioOperator_markers pushBack _directionMarker;

    private _markerZone = createMarkerLocal ["vgm_rto_marker_zone", [_x, _y, 0]];
    _markerZone setMarkerShapeLocal "ELLIPSE";
    _markerZone setMarkerBrush "DIAGGRID";
    _markerZone setMarkerColorLocal "ColorRed";
    _markerZone setMarkerDirLocal (_dir - 180);
    if (_hitAreaMarkerShape == "CIRCLE") then
    {
        _markerZone setMarkerSizeLocal [_hitAreaMarkerSize,_hitAreaMarkerSize];
    }
    else
    {
        _markerZone setMarkerSizeLocal [_hitAreaMarkerSize*0.5,_hitAreaMarkerSize];
    };
    vgm_c_displayRadioOperator_markers pushBack _markerZone;

    private _markerBackground = createMarkerLocal ["vgm_rto_marker_background", [_x, _y, 0]];
    _markerBackground setMarkerTypeLocal "n_unknown";
    _markerBackground setMarkerColorLocal "ColorRed";
    vgm_c_displayRadioOperator_markers pushBack _markerBackground;

    private _markerIcon = createMarkerLocal ["vgm_rto_marker_icon_vehicle",[_x, _y, 0]];
    _markerIcon setMarkerTypeLocal "loc_mine";
    _markerIcon setMarkerColorLocal "ColorWhite";
    vgm_c_displayRadioOperator_markers pushBack _markerIcon;


    true
};

private _fnc_formatDuration = {
    [ceil (_this / 10) * 10] call vgm_g_fnc_formatDuration
};

private _fnc_formatAircraftListEntry = {
    params ["_aircraftId"];

    // Both keys should always be valid - doesn't need a default check
    private _aircraft = _availableAircraft get _aircraftId;
    private _aircraftType = vgm_g_rto_aircraftTypes get (_aircraft get "typeId");

    [_aircraft] call vgm_g_fnc_rto_getAircraftStatus params ["_aircraftStatus", "_timeRemainingInStatus"];
    private _statusSymbol = "";
    private _statusText = "";

    call {
        if (_aircraftStatus isEqualTo "REFUELING") exitWith {
            _statusSymbol = "R";
            _statusText = format [localize "STR_VGM_RTO_AIR_LIST_STATUS_REFUELING", [_timeRemainingInStatus] call vgm_g_fnc_formatDuration];
        };
        if (_aircraftStatus isEqualTo "STANDBY") exitWith {
            _statusSymbol = "S";
            _statusText = format [localize "STR_VGM_RTO_AIR_LIST_STATUS_STANDBY", [_timeRemainingInStatus] call vgm_g_fnc_formatDuration];
        };
        if (_aircraftStatus isEqualTo "ENROUTE") exitWith {
            _statusSymbol = "E";
            _statusText = format [localize "STR_VGM_RTO_AIR_LIST_STATUS_ENROUTE", [_timeRemainingInStatus] call vgm_g_fnc_formatDuration];
        };
        if (_aircraftStatus isEqualTo "ONSTATION") exitWith {
            _statusSymbol = "O";
            _statusText = format [localize "STR_VGM_RTO_AIR_LIST_STATUS_ONSTATION", [_timeRemainingInStatus] call vgm_g_fnc_formatDuration];
        };

        _statusSymbol = "D";
        _statusText = format [localize "STR_VGM_RTO_AIR_LIST_STATUS_DEPARTED", [_timeRemainingInStatus] call vgm_g_fnc_formatDuration];
    };

    private _entry = format [localize "STR_VGM_RTO_NAME_WITH_STATUS", _aircraftType get "displayName", _statusSymbol];
    private _tooltip = format ["%1 | %2", _statusText, _aircraftType get "vehicleType"];

    [_entry, _tooltip]
};

switch _mode do
{
    case "init":
    {
        _params params ["_display"];

        if (isNull (findDisplay 46)) exitWith {};

        createDialog "VGM_DisplayRadioOperator";
    };
    case "radio:type":
    {
        private _ctrl = uinamespace getVariable ["VGM_DisplayRadioOperator_modeDial",controlNull];
    };
    case "refreshTitle":
    {
        private _aircraftInUse = [getPlayerID player] call vgm_g_fnc_rto_getAircraftInUse;
        if (_aircraftInUse isEqualTo []) exitWith {
            TITLE ctrlSetText localize "STR_VGM_RTO_NO_AIRCRAFT_ON_STATION";
        };

        TITLE ctrlSetText format [localize "STR_VGM_RTO_X_AIRCRAFT_ON_STATION", count _aircraftInuse];
    };
    case "updateModeDial":
    {
        private _ctrl = uinamespace getVariable ["VGM_DisplayRadioOperator_modeDial",controlNull];
        _ctrl ctrlSetAngle [DIAL_ANGLES # vgm_c_displayRadioOperator_dialValue, 0.5, 0.5];
    };
    case "updateButton":
    {
        if (
            lbCurSel ASSET_LIST < 0
            || lbCurSel COMMAND_LIST < 0
            || isNil "vgm_c_displayRadioOperator_command"
            || { vgm_c_displayRadioOperator_command getOrDefault ["disabled", false] }
        ) exitWith {
            BUTTON ctrlEnable false;
            BUTTON ctrlSetTooltip localize "";
        };

        BUTTON ctrlEnable true;
    };
    case "gui:button":
    {
        if (
            lbCurSel ASSET_LIST < 0
            || lbCurSel COMMAND_LIST < 0
            || isNil "vgm_c_displayRadioOperator_command"
        ) exitWith {
            ["updateButton"] call SELF;
        };

        private _action = vgm_c_displayRadioOperator_command get "action";
        (_action # 0) call (_action # 1);
    };
    case "onLoad":
    {
        _params params ["_display"];

        uiNamespace setVariable ["VGM_DisplayRadioOperator",_display];

        if (isNil "vgm_c_displayRadioOperator_saved") then
        {
            // Type, callsign, amount
            vgm_c_displayRadioOperator_saved = [-1, -1];
        };
        vgm_c_displayRadioOperator_allowSaving = false;
        vgm_c_displayRadioOperator_markers = [];

        ['gui:clear'] call SELF;
        ['gui:setup'] call SELF;
        ["vgm_rto_displayOpened", [_display]] call para_g_fnc_event_triggerLocal;
    };
    case "onUnload":
    {
        if (vgm_c_displayRadioOperator_allowSaving) then
        {
            vgm_c_displayRadioOperator_saved =
            [
                ASSET_INDEX,
                COMMAND_VALUE
            ];
        };
        { deleteMarkerLocal _x; } foreach vgm_c_displayRadioOperator_markers;
        uiNamespace setVariable ["VGM_DisplayRadioOperator",displayNull];
    };
    case "refreshAircraftList":
    {
        lbClear ASSET_LIST;
        ASSET_LIST lbSetCurSel -1;

        private _aircraftIds = [_availableAircraft] call para_g_fnc_netmap_keys;
        _aircraftIds sort true;

        vgm_c_displayRadioOperator_aircraftIds = _aircraftIds;

        {
            private _aircraftId = _x;

            [_aircraftId] call _fnc_formatAircraftListEntry params ["_entry", "_tooltip"];

            private _index = ASSET_LIST lbAdd _entry;
            ASSET_LIST lbSetTooltip [_index, _tooltip];
            ASSET_LIST lbSetValue [_index, _forEachIndex];
        } foreach vgm_c_displayRadioOperator_aircraftIds;

        ASSET_LIST ctrlEnable true;
    };
    case "refreshAircraftListText":
    {
        for "_i" from 0 to (lbSize ASSET_LIST - 1) do {
            private _aircraftIndex = ASSET_LIST lbValue _i;
            private _aircraftId = vgm_c_displayRadioOperator_aircraftIds select _aircraftIndex;

            [_aircraftId] call _fnc_formatAircraftListEntry params ["_entry", "_tooltip"];

            ASSET_LIST lbSetText [_i, _entry];
            ASSET_LIST lbSetTooltip [_i, _tooltip];
        };
    };
    case "assetSelected":
    {
        _params params ["_ctrl", "_lbIndex"];

        private _index = _ctrl lbValue _lbIndex;

        if (_lbIndex < 0 || _index < 0 || isNil "vgm_c_displayRadioOperator_aircraftIds") then {
            vgm_c_displayRadioOperator_aircraftId = nil;
        } else {
            vgm_c_displayRadioOperator_aircraftId = vgm_c_displayRadioOperator_aircraftIds # _index;
        };

        ["refreshCommandList"] call SELF;
        true
    };
    case "refreshCommandList":
    {
        lbClear COMMAND_LIST;
        COMMAND_LIST lbSetCurSel -1;

        if (isNil "vgm_c_displayRadioOperator_aircraftId") exitWith {};
        private _aircraft = _availableAircraft get vgm_c_displayRadioOperator_aircraftId;
        if (isNil "_aircraft") exitWith {};

        [_aircraft] call vgm_g_fnc_rto_getAircraftStatus params ["_aircraftStatus", "_timeRemainingInStatus"];
        private _aircraftType = vgm_g_rto_aircraftTypes get (_aircraft get "typeId");

        private _fnc_strikeCommands = {
            private _strikes = _aircraft get "strikes";
            private _strikeIds = keys _strikes;
            _strikeIds sort true;
            private _strikeTypes = _aircraftType get "strikes";
            private _enRoute = _aircraftStatus == "ENROUTE";
            private _onAttackRun = [_aircraft] call vgm_g_fnc_rto_isAircraftOnAttackRun;

            _strikeIds apply {
                private _strikesRemaining = _strikes get _x;
                private _disabled = _strikesRemaining <= 0 || _enRoute || _onAttackRun;
                private _tooltip = ["", localize "STR_VGM_RTO_ENROUTE"] select _enRoute;
                _tooltip = [_tooltip, localize "STR_VGM_RTO_ON_ATTACK_RUN"] select _onAttackRun;

                createHashMapFromArray [
                    ["text", _strikeTypes get _x get "displayName"],
                    ["tooltip", _tooltip],
                    ["disabled", _disabled],
                    ["extraInfo", format [localize "STR_VGM_RTO_REMAINING", _strikesRemaining]],
                    ["action", [[vgm_c_displayRadioOperator_aircraftId, _x, _disabled], {
                        params ["_aircraftId", "_strikeId", "_disabled"];
                        if (_disabled || isNil "VGM_DisplayRadioOperator_selecting_start" || isNil "VGM_DisplayRadioOperator_selecting_end") exitWith {};
                        [getPlayerID player, _aircraftId, _strikeId, VGM_DisplayRadioOperator_selecting_start, VGM_DisplayRadioOperator_selecting_end] remoteExecCall ["vgm_s_fnc_rto_requestStrike", 2];
                        DISPLAY closeDisplay 0;
                    }]]
                ]
            }
        };

        vgm_c_displayRadioOperator_commands = [];

        if (_aircraftStatus == "STANDBY") then {
            private _canCall = count ([getPlayerID player] call vgm_g_fnc_rto_getAircraftInUse) < MAX_AIRCRAFT_IN_USE;
            private _tooltip = [localize "STR_VGM_RTO_TOO_MANY_AIRCRAFT_IN_USE", ""] select _canCall;
            private _arrivesIn = format [localize "STR_VGM_RTO_ARRIVES_IN", ceil ((_aircraftType get "arrivalTimeSecs") / 60) toFixed 0];

            vgm_c_displayRadioOperator_commands pushBack createHashMapFromArray [
                ["text", localize "STR_VGM_RTO_CALL"],
                ["tooltip", _tooltip],
                ["extraInfo", _arrivesIn],
                ["disabled", !_canCall],
                ["action", [[vgm_c_displayRadioOperator_aircraftId], {
                    params ["_aircraftId"];
                    [getPlayerID player, _aircraftId] remoteExecCall ["vgm_s_fnc_rto_requestAircraft", 2];
                }]]
            ];
        };

        if (_aircraftStatus in ["ENROUTE", "ONSTATION"]) then {
            vgm_c_displayRadioOperator_commands append ([] call _fnc_strikeCommands);
            vgm_c_displayRadioOperator_commands pushBack createHashMapFromArray [
                ["text", localize "STR_VGM_RTO_DISMISS"],
                // TODO - Tooltip showing if dismissing will cause a cooldown.
                ["action", [[vgm_c_displayRadioOperator_aircraftId], {
                    params ["_aircraftId"];
                    [getPlayerID player, _aircraftId] remoteExecCall ["vgm_s_fnc_rto_dismissAircraft", 2];
                }]]
            ];
        };

        {
            private _command = _x;
            private _index = COMMAND_LIST lbAdd (_command get "text");
            COMMAND_LIST lbSetTooltip [_index, _command getOrDefault ["tooltip", ""]];
            if (_command getOrDefault ["disabled", false]) then {
                COMMAND_LIST lbSetColor [_index, [0.5, 0.5, 0.5, 1]];
            };
            COMMAND_LIST lbSetValue [_index, _forEachIndex];
        } foreach vgm_c_displayRadioOperator_commands;

        COMMAND_LIST ctrlEnable true;
    };
    case "commandSelected":
    {
        _params params ["_ctrl", "_lbIndex"];

        private _commandIndex = _ctrl lbValue _lbIndex;

        if (_lbIndex < 0 || _commandIndex < 0 || isNil "vgm_c_displayRadioOperator_commands") then {
            vgm_c_displayRadioOperator_command = nil;
        } else {
            vgm_c_displayRadioOperator_command = vgm_c_displayRadioOperator_commands # _commandIndex;
        };

        ["refreshUsesRemaining"] call SELF;
        ["updateButton"] call SELF;
        true
    };
    case "refreshUsesRemaining":
    {
        if (isNil "vgm_c_displayRadioOperator_command") exitWith {
            USES_REMAINING_TEXT ctrlSetStructuredText parseText "";
        };

        USES_REMAINING_TEXT ctrlSetStructuredText parseText (vgm_c_displayRadioOperator_command getOrDefault ["extraInfo", ""]);
    };
    case "mouseButtonDown":
    {
        _params params ["_ctrl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
        if (_button isEqualTo 0) then
        {
            private _position = (MAP ctrlMapScreenToWorld [_xPos, _yPos]);
            VGM_DisplayRadioOperator_selecting = true;
            VGM_DisplayRadioOperator_selecting_start = _position;
            VGM_DisplayRadioOperator_selecting_end = _position;
        };
    };
    case "mouseButtonUp":
    {
        _params params ["_ctrl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
        if (VGM_DisplayRadioOperator_selecting) then
        {
            private _position = (MAP ctrlMapScreenToWorld [_xPos, _yPos]);
            VGM_DisplayRadioOperator_selecting = false;
            VGM_DisplayRadioOperator_selecting_end = _position;
        };
    };
    case "mouseMoving":
    {
        _params params ["_ctrl", "_xPos", "_yPos", "_mouseOver"];
        if (VGM_DisplayRadioOperator_selecting) then
        {
            private _position = (MAP ctrlMapScreenToWorld [_xPos, _yPos]);
            VGM_DisplayRadioOperator_selecting_end = _position;
        };
    };
    case "gui:setup":
    {
        // Disable options that we don't want players changing yet.
        {
            _x ctrlEnable false;
        } foreach [COMMAND_LIST, ASSET_LIST, BUTTON];

        ASSET_LIST ctrlAddEventHandler ["LBSelChanged",{ ["assetSelected", [_this # 0,_this # 1]] call SELF }];
        COMMAND_LIST ctrlAddEventHandler ["LBSelChanged",{ ["commandSelected", [_this # 0, _this#1]] call SELF }];
        MAP ctrlAddEventHandler ["MouseButtonDown",{ ["mouseButtonDown",_this] call SELF }];
        MAP ctrlAddEventHandler ["MouseButtonUp",{ ["mouseButtonUp",_this] call SELF }];
        MAP ctrlAddEventHandler ["MouseExit",{ ["mouseButtonUp",_this] call SELF }];
        MAP ctrlAddEventHandler ["MouseMoving",{ ["mouseMoving",_this] call SELF }];
        MAP ctrlAddEventHandler ["Draw",{ ["draw",_this] call SELF }];
        BUTTON ctrlAddEventHandler ["ButtonClick",{ ["gui:button",_this] call SELF; false }];

        ["refreshAircraftList"] call SELF;

        {
            private _index = (vgm_c_displayRadioOperator_saved#_foreachindex);
            if (_index > -1) then
            {
                _x lbSetCurSel _index;
            };
        } foreach [ASSET_LIST, COMMAND_LIST];

        vgm_c_displayRadioOperator_allowSaving = true;

        ["refreshTitle"] call SELF;
        ["updateModeDial"] call SELF;
        ["updateButton"] call SELF;
    };
    case "refreshAll":
    {
        ["refreshTitle"] call SELF;
        ["updateModeDial"] call SELF;
        ["updateButton"] call SELF;
        ["refreshAircraftList"] call SELF;
    };
    case "gui:clear":
    {
        // Disable options that we don't want players changing yet.
        {
            _x ctrlEnable false;
        } foreach [COMMAND_LIST, ASSET_LIST, BUTTON];

        COMMAND_LIST ctrlRemoveAllEventHandlers "LBSelChanged";
        ASSET_LIST ctrlRemoveAllEventHandlers "LBSelChanged";
        MAP ctrlRemoveAllEventHandlers "MouseButtonDown";
        MAP ctrlRemoveAllEventHandlers "MouseButtonUp";
        MAP ctrlRemoveAllEventHandlers "MouseExit";
        MAP ctrlRemoveAllEventHandlers "MouseMoving";
        BUTTON ctrlRemoveAllEventHandlers "ButtonClick";

        lbClear COMMAND_LIST;
        lbClear ASSET_LIST;

        DESCRIPTION ctrlSetText "";

        vgm_c_displayRadioOperator_allowSaving = true;
    };
};
true
