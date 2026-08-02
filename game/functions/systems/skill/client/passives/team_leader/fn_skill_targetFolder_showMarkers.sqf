/*
    File: fn_skill_targetFolder_showMarkers.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Client-side Target Folder marker display. Receives intel data from
        the server and creates local map markers based on intel type:
        - "trail": Blue dot markers at trail sign positions near sites
        - "area": Yellow circle markers at approximate site areas
        - "site": Orange objective markers at precise site locations

    Parameter(s):
        _intelData - Array of [type, position] pairs [ARRAY]

    Returns:
        Nothing

    Example(s):
        [[["trail", [1000,2000]], ["area", [3000,4000]]]] call vgm_c_fnc_skill_targetFolder_showMarkers
 */

params ["_intelData"];

// Clean up old markers
{deleteMarkerLocal _x} forEach (missionNamespace getVariable ["vgm_c_skill_targetFolder_markers", []]);
vgm_c_skill_targetFolder_markers = [];

{
    _x params ["_type", "_pos"];

    private _markerName = format ["vgm_tf_%1_%2", _type, _forEachIndex];
    private _marker = createMarkerLocal [_markerName, _pos];

    switch (_type) do {
        case "trail": {
            _marker setMarkerTypeLocal "hd_dot";
            _marker setMarkerColorLocal "ColorBlue";
            _marker setMarkerTextLocal localize "STR_VGM_SKILLS_SKILL_TARGET_FOLDER_TRAIL";
        };
        case "area": {
            _marker setMarkerShapeLocal "ELLIPSE";
            _marker setMarkerSizeLocal [150, 150];
            _marker setMarkerColorLocal "ColorYellow";
            _marker setMarkerAlphaLocal 0.3;
            _marker setMarkerTextLocal localize "STR_VGM_SKILLS_SKILL_TARGET_FOLDER_AREA";
        };
        case "site": {
            _marker setMarkerTypeLocal "hd_objective";
            _marker setMarkerColorLocal "ColorOrange";
            _marker setMarkerTextLocal localize "STR_VGM_SKILLS_SKILL_TARGET_FOLDER_SITE";
        };
    };

    vgm_c_skill_targetFolder_markers pushBack _markerName;
} forEach _intelData;
