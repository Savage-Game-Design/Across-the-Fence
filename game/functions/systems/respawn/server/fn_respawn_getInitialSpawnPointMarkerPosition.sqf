private _markerPositionASL = AGLToASL (getMarkerPos "initial_spawn_point");
if (_markerPositionASL isEqualTo [0, 0, 0]) exitWith {
    getPosASL player; // TODO: remove before merge -- this is only for testing!!!
};
_markerPositionASL;
