/*
    File: fn_tutorial_postInit.sqf
    Author:
    Date: 2024-11-16
    Last Update: 2024-11-17
    Public: No

    Description:
        PostInit for the tutorial system

*/

private _categories = configProperties [missionConfigFile >> "CfgHints", "isClass _x", true];

{
    private _categoryConfig = _x;
    private _triggerableTutorials = configProperties [_categoryConfig, "isClass _x && (isClass (_x >> 'Triggers'))", true];
    {
        // Set up triggers for 'markerEntered' events.
        // Can't be done in preInit, as we need `markerPos`, which is only ready in postInit (seemingly).
        private _hintConfig = _x;
        private _triggerConfig = _hintConfig >> "Triggers";
        private _marker = getText (_triggerConfig >> "markerEntered");
        if (_marker != "" && markerPos _marker isNotEqualTo [0, 0, 0]) then {
            _marker setMarkerAlphaLocal 0;
            private _trigger = createTrigger ["EmptyDetector", markerPos _marker, false];
            _trigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
            private _markerSize = markerSize _marker;
            _trigger setTriggerArea [_markerSize # 0, _markerSize # 1, markerDir _marker, markerShape _marker isEqualTo "RECTANGLE"];
            _trigger setTriggerStatements [
                "player in thisList",
                format ["['%1', '%2'] call vgm_c_fnc_tutorial_trigger;", configName _categoryConfig, configName _hintConfig],
                ""
            ];
        };

        // Create a global subscription for an event.
        // This might need tweaking if events on other clients start triggering local tutorials.
        private _event = getText (_triggerConfig >> "eventFired");
        if (_event != "") then {
            [
                _event,
                [
                    [configName _categoryConfig, configName _hintConfig], {
                        params ["_args", "_savedArgs"];
                        _savedArgs call vgm_c_fnc_tutorial_trigger;
                    }
                ]
            ] call para_g_fnc_event_subscribe;
        };
    } forEach _triggerableTutorials;
} forEach _categories;

// Watch for objects with vgm_c_tutorial set.
addMissionEventHandler ["EachFrame", {
    private _target = cursorObject;
    private _tutorial = cursorObject getVariable "vgm_c_tutorial";
    if (isNil "_tutorial" || { _target distance2D player > 4 }) exitWith {};
    [_tutorial # 0, _tutorial # 1] call vgm_c_fnc_tutorial_trigger;
}];
