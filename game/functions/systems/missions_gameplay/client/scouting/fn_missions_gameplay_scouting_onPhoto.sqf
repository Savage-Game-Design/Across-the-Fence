/*
    File: fn_mission_gameplay_scouting_onPhoto.sqf
    Author: Savage Game Design
    Date: 2024-09-30
    Last Update: 2025-01-17
    Public: No

    Description:
        Handle player snapping a photo of a site.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_missions_gameplay_scouting_onPhoto
 */

#define GET_DISPLAY_MAP (findDisplay 12)

#ifdef __A3_DEBUG__
if (is3DENPreview) then {
    vgm_scouting_debug_photoLines = [];
};
#endif

// check if position is in photo frame
private _fnc_isInFrame = {
    private _screenPos = worldToScreen ASLToAGL _this;
    if (_screenPos isEqualTo []) exitWith {false};
    _screenPos params ["_sX", "_sY"];
    (_sX >= -0.4 && _sX <= 1.4) && (_sY >= -0.13 && _sY <= 1.13) // return
};

// returns "foreground" site objects,
// objects that are somewhat clearly visible in the photo
private _fnc_getForegroundObjects = {
    params ["_posASL"];

    private _siteObjects = _extern_sites get (_posASL select [0, 2]);
    private _spottableObjects = _siteObjects select {_x getVariable ["vgm_missions_gameplay_scouting_spottable", false]};

    private _objects = [];
    {
        private _object = _x;
        private _bb = 0 boundingBoxReal _object;
        {
            private _posBeg = eyePos _extern_player;
            private _posEnd = _object modelToWorldWorld _x;
            if !(_posEnd call _fnc_isInFrame) then {continue};

            private _vis = [_extern_player, "VIEW", _object] checkVisibility [_posBeg, _posEnd];
            if (_vis < 0.2) then {continue};

            #ifdef __A3_DEBUG__
            vgm_scouting_debug_photoLines pushBack [ASLtoAGL _posBeg, ASLtoAGL _posEnd, format ["%2%1%3", endl, _vis, typeOf _object]];
            #endif

            _objects pushBack _object;
            break; // one point per object is enough
        } forEach ([[0,0,0.4]] + (_bb select [0, 2]));
    } forEach _spottableObjects;

    _objects // return
};

private _mission = call vgm_c_fnc_missions_getCurrentMission;
private _extern_sites = (_mission get "system_sites" get "sites");
private _extern_player = focusOn;

// gather sites that are on a screen
private _sitesPositions = (_extern_sites call para_g_fnc_netmap_keys) apply {_x + [getTerrainHeightASL _x + 1.5]};
private _visiblePositions = _sitesPositions select {_x call _fnc_isInFrame};

private _zoom = (getResolution#6) / getObjectFOV _extern_player;

private _photoData = createHashMap;
{
    private _perceivedDistance = (_x distance2d _extern_player) / _zoom;
    if (_perceivedDistance > 100) then {continue};

    private _foregroundObjects = [_x] call _fnc_getForegroundObjects;
    // TODO in separate PR, check for "background" objects (objects which intersect one of the "foreground" ones)
    // and count them too, also add photo quality scoring
    if (count _foregroundObjects < 1) then {continue};

    _photoData set [_x select [0, 2], _foregroundObjects];
} forEach _visiblePositions;

#ifdef __A3_DEBUG__
if (is3DENPreview) then {
    removeMissionEventHandler ["Draw3D", missionNamespace getVariable ["vgm_scouting_debug_drawEh", -1]];
    private _debugEh = addMissionEventHandler ["Draw3D", {
        {
            _x params ["_beg", "_end", "_text"];
            drawLine3D [_beg, _end, [1,1,1,1]];
            drawIcon3D ["", [1,1,1,1], _end, 1, 1, 0, _text];
        } forEach vgm_scouting_debug_photoLines;
    }];
    vgm_scouting_debug_drawEh = _debugEh;
    vgm_scouting_debug_photoData = _photoData;
};
#endif

if (_photoData isEqualTo createHashMap) exitWith {
    if (is3DENPreview) then {hint "Empty photo"};
};

// TODO this will get reworked once we will add photo quality/bonus XP
// right now this is enough and any site object is good for us.
// (server stores site reference on it's spottable objects)

// get first object of first site in a photo (there can be multiple)
private _cursorTarget = _photoData get (keys _photoData#0) select 0;

GET_DISPLAY_MAP setVariable ["vgm_site_photoObject", _cursorTarget];
["refreshUI", GET_DISPLAY_MAP] call vgm_c_fnc_displayNotepad;

[_cursorTarget] spawn {
    sleep 0.3;
    openMap [true, false];
    waitUntil {!visibleMap};

    if (!isNil {GET_DISPLAY_MAP getVariable "vgm_site_photoObject"}) then {
        playSoundUI ["hint"];
    };
    GET_DISPLAY_MAP setVariable ["vgm_site_photoObject", nil];
    ["refreshUI", GET_DISPLAY_MAP] call vgm_c_fnc_displayNotepad;
};
