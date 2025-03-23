/*
    File: fn_mission_gameplay_scouting_onPhoto.sqf
    Author: Savage Game Design
    Date: 2024-09-30
    Last Update: 2025-02-14
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

#define VIS_THRESHOLD 0.7
#define GET_DISPLAY_MAP (findDisplay 12)

#ifdef __A3_DEBUG__

#define DEBUG_FOREGROUND
#define DEBUG_BACKGROUND

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

private _fnc_getSpottableObjects = {
    params ["_site"];

    private _siteObjects = _site get "objects";
    _siteObjects select {_x getVariable ["vgm_missions_gameplay_scouting_spottable", false]} // return;
};

// returns "foreground" site objects,
// objects that are somewhat clearly visible in the photo
private _fnc_getForegroundObjects = {
    params ["_spottableObjects"];

    private _posBeg = eyePos _extern_player;
    private _objects = [];
    {
        #ifdef __A3_DEBUG__
            private _lineColor = [[1,0,0,1], [0,1,0,1], [0,0,1,1]] select (_forEachIndex%3);
        #endif

        private _object = _x;
        private _visibleObjectPoints = [];
        _object setVariable ["vgm_scouting_visiblePoints", _visibleObjectPoints];
        {
            private _posEnd = _object modelToWorldWorld _x;
            if !(_posEnd call _fnc_isInFrame) then {continue};

            private _vis = [_extern_player, "VIEW", _object] checkVisibility [_posBeg, _posEnd];
            if (_vis < VIS_THRESHOLD) then {continue};

            if (count _visibleObjectPoints == 0) then {
                _objects pushBack _object
            };
            _visibleObjectPoints pushBack _posEnd;

            #ifdef DEBUG_FOREGROUND
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

private _fnc_getBackgroundObjects = {
    params ["_spottableObjects", "_foregroundObjects", "_siteObjects"];

    private _unspottedObjects = _spottableObjects - _foregroundObjects;

    private _posEnd = eyePos _extern_player;
    private _objects = [];
    {
        #ifdef __A3_DEBUG__
            private _lineColor = [[1,0,0,1], [0,1,0,1], [0,0,1,1]] select (_forEachIndex%3);
        #endif

        private _object = _x;

        {
            private _posBeg = _object modelToWorldWorld _x;
            if !(_posBeg call _fnc_isInFrame) then {continue};

            private _intersects = lineIntersectsSurfaces [_posBeg, _posEnd, _object, _extern_player, false, 5];
            // this should not happen, if nothing occludes the object it should be in foreground objects,
            // failsafe.
            if (_intersects isEqualTo []) then {
                _objects pushBack _object;
                break;
            };

            (_intersects#0) params ["_intersectPosASL", "", "", "_intersectObject"];

            // object is occluded by something that's not a part of the site
            if (isNull _intersectObject || !(_intersectObject in _siteObjects)) then {
                #ifdef DEBUG_BACKGROUND
                    private _lineText = format ["bg invalid: %1 - %2", getModelInfo _object#0, str _intersectObject];
                    vgm_scouting_debug_photoLines pushBack [ASLToAGL _intersectPosASL, ASLtoAGL _posBeg, _lineText, _lineColor];
                #endif

                continue;
            };

            #ifdef DEBUG_BACKGROUND
                private _lineText = format ["bg: %1", getModelInfo _object#0, getModelInfo _intersectObject#0];
                vgm_scouting_debug_photoLines pushBack [ASLtoAGL _intersectPosASL, ASLtoAGL _posBeg, _lineText, _lineColor];
            #endif

            _objects pushBack _object;
            break;

        } forEach (_object call _fnc_getObjectPoints select [0, 2]);
    } forEach _unspottedObjects;

    _objects // return
};

private _mission = call vgm_c_fnc_missions_getCurrentMission;
private _sites = (_mission get "targetZone") call vgm_c_fnc_missions_zones_getSites;
private _extern_player = focusOn;

// gather sites that are on a screen
private _visibleSites = _sites select {
    private _pos = +(_x get "pos");
    _pos set [2, getTerrainHeightASL _pos + 1.5];
    _pos call _fnc_isInFrame // return
};

private _zoom = (getResolution#6) / getObjectFOV _extern_player;

private _photoData = createHashMap;
{
    private _perceivedDistance = ((_x get "pos") distance2d _extern_player) / _zoom;
    if (_perceivedDistance > 100) then {continue};

    private _site = _x;
    private _spottableObjects = _site call _fnc_getSpottableObjects;

    private _foregroundObjects = [_spottableObjects] call _fnc_getForegroundObjects;
    // TODO in separate PR, check for "background" objects (objects which intersect one of the "foreground" ones)
    // and count them too, also add photo quality scoring
    if (count _foregroundObjects < 1) then {continue};

    private _backgroundObjects = [_spottableObjects, _foregroundObjects, _x get "objects"] call _fnc_getBackgroundObjects;

    _photoData set [_x get "id", [_foregroundObjects, _backgroundObjects, _spottableObjects]];
} forEach _visibleSites;

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

        ["Photo taken"] call vgm_g_fnc_logDebug;
        [_photoData] call vgm_g_fnc_logDebug;
    };
#endif

if (_photoData isEqualTo createHashMap) exitWith {};

// discard photo if it does not contain at least one site with at least one object with two clearly visible points
if (
    values _photoData findIf {
        _x params ["_foregroundObjects"];
        _foregroundObjects findIf {count (_x getVariable "vgm_scouting_visiblePoints") >= 2} > -1
    } == -1
) exitwith {};

GET_DISPLAY_MAP setVariable ["vgm_site_photoData", _photoData];
["refreshUI", GET_DISPLAY_MAP] call vgm_c_fnc_displayNotepad;

[] spawn {
    sleep 0.3;
    openMap [true, false];
    waitUntil {!visibleMap};

    if (!isNil {GET_DISPLAY_MAP getVariable "vgm_site_photoData"}) then {
        playSoundUI ["hint"];
    };
    GET_DISPLAY_MAP setVariable ["vgm_site_photoData", nil];
    ["refreshUI", GET_DISPLAY_MAP] call vgm_c_fnc_displayNotepad;
};
