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

private _fnc_getObjectPoints = {
    params ["_object"];

    vgm_scouting_objectPointsCache getOrDefaultCall [typeOf _object, {
        // [[xmin, ymin, zmin], [xmax, ymax, zmax]]
        private _bb = 0 boundingBoxReal _object;
        _bb params ["_bbA", "_bbB"];

        private _points = [];
        {
            _points pushBack _x;
        } forEach [
            // object center and object center raised to top of BB
            [0, 0, 0],
            [0, 0, _bbB select 2],
            // zmax, higher objects are more likely to be seen
            [_bbA select 0, _bbA select 1, _bbB select 2],
            [_bbA select 0, _bbB select 1, _bbB select 2],
            [_bbB select 0, _bbA select 1, _bbB select 2],
            [_bbB select 0, _bbB select 1, _bbB select 2],
            // zmin, lower elements are less likely to be seen
            [_bbA select 0, _bbA select 1, _bbA select 2],
            [_bbA select 0, _bbB select 1, _bbA select 2],
            [_bbB select 0, _bbA select 1, _bbA select 2],
            [_bbB select 0, _bbB select 1, _bbA select 2]
        ];

        _points // return
    }, true] // return
};

// returns "foreground" site objects,
// objects that are somewhat clearly visible in the photo
private _fnc_getForegroundObjects = {
    params ["_posASL"];

    private _siteObjects = _extern_sites get (_posASL select [0, 2]);
    private _spottableObjects = _siteObjects select {_x getVariable ["vgm_missions_gameplay_scouting_spottable", false]};

    private _objects = [];
    {
        #ifdef __A3_DEBUG__
            private _lineColor = [[1,0,0,1], [0,1,0,1], [0,0,1,1]] select (_forEachIndex%3);
        #endif

        private _object = _x;
        private _visibleObjectPoints = [];
        _object setVariable ["vgm_scouting_visiblePoints", _visibleObjectPoints];
        {
            private _posBeg = eyePos _extern_player;
            private _posEnd = _object modelToWorldWorld _x;
            if !(_posEnd call _fnc_isInFrame) then {continue};

            private _vis = [_extern_player, "VIEW", _object] checkVisibility [_posBeg, _posEnd];
            if (_vis < 0.3) then {continue};

            if (count _visibleObjectPoints == 0) then {
                _objects pushBack _object
            };
            _visibleObjectPoints pushBack _posEnd;

            #ifdef __A3_DEBUG__
                private _lineText = [format ["%1: %2 : %3", _vis, count _visibleObjectPoints, getModelInfo _object#0], format ["%1: %2", _vis, _forEachIndex]] select (count _visibleObjectPoints>1);
                vgm_scouting_debug_photoLines pushBack [ASLtoAGL _posBeg, ASLtoAGL _posEnd, _lineText, _lineColor];
            #endif

            // we do not care about more than 2 points per object,
            // abort to save performance
            if (count _visibleObjectPoints >= 2) then {break};

        } forEach (_object call _fnc_getObjectPoints);
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
                _x params ["_beg", "_end", "_text", "_lineColor"];
                drawLine3D [_beg, _end, _lineColor, 5];
                drawIcon3D ["", [1,1,1,1], _end, 1, 1, 0, _text];
            } forEach vgm_scouting_debug_photoLines;
        }];
        vgm_scouting_debug_drawEh = _debugEh;
        vgm_scouting_debug_photoData = _photoData;
    };
    #endif

if (_photoData isEqualTo createHashMap) exitWith {};

// TODO this will get reworked once we will add photo quality/bonus XP
// right now this is enough and any site object is good for us.
// (server stores site reference on its spottable objects)

// get objects of any site in a photo (there can be multiple)
private _siteObjects = values _photoData # 0;

// require at least one object with two visible points
if (_siteObjects findIf {count (_x getVariable "vgm_scouting_visiblePoints") >= 2} == -1) exitWith {};

private _cursorTarget = _siteObjects # 0;

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
