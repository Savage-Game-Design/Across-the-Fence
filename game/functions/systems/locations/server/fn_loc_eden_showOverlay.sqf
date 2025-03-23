/*
    File: fn_loc_eden_showOverlay.sqf
    Author: Savage Game Design
    Date: 2024-07-04
    Last Update: 2024-11-28
    Public: Yes

    Description:
        Shows an overlay of locations in 3DEN, with valid location types for that loc.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_loc_eden_showOverlay
 */

if (!isNil "vgm_s_loc_eden_overlayDrawHandler") exitWith {};

vgm_s_loc_eden_overlay = createHashMap;
vgm_s_loc_eden_overlayTargetBoxes = [];
// This can be refactored to be run once then be event driven, after 2.18 releases with "OnEntityAttributeChanged".
vgm_s_loc_eden_overlayUpdater = [] spawn {
    // Get a list of location types sorted by name.
    private _locationTypesById = [] call vgm_s_fnc_loc_getLocationTypes;
    private _locationTypes = values _locationTypesById;
    private _sortedLocationTypeIds = _locationTypes apply {[_x get "name", _x get "id"]};
    _sortedLocationTypeIds sort false;
    private _sortedLocationTypes = _sortedLocationTypeIds apply {_locationTypesById get (_x # 1)};


    while {!isNil "vgm_s_loc_eden_overlay"} do {
        private _targetBoxLocs = [] call vgm_s_fnc_loc_eden_getLocationsByTargetBox;

        {
            private _targetBox = _x;
            private _locs = _y;
            {
                private _tags = _x get "tags";
                private _validLocationTypes = _sortedLocationTypes select {[_x get "requirements", _tags] call vgm_s_fnc_loc_areRequirementsMet} apply {_x get "name"};
                vgm_s_loc_eden_overlay set [_x get "edenId", _validLocationTypes];
            } forEach _locs;
        } forEach _targetBoxLocs;

        vgm_s_loc_eden_overlayTargetBoxMarkers = [] call vgm_s_fnc_loc_eden_getTargetBoxMarkers;

        uiSleep 5;
    };
};

vgm_s_loc_eden_overlayDrawHandler = addMissionEventHandler ["Draw3D", {
	private _maxDistance = 3500;
	{
		private _id = _x;
		private _locationNames = _y;

        // Catches entities being deleted before overlay can update.
        if (get3DENEntity _id isEqualTo -1) then {
            continue
        };

		private _pos = ASLToATL (_id get3DENAttribute "Position" select 0);
		private _textPos = _pos vectorAdd [0, 0, 100];
		private _distance = getPosATL get3DENCamera distance _pos;
		private _opacity = (1 - (_distance / _maxDistance)) max 0 min 1;

		{
			drawIcon3D ["", [1,1,1,_opacity], _textPos, 1, 1, 45, _x, 1, 0.03, "TahomaB", "center", false, 0, -0.03 + -0.015 * _forEachIndex];
		} forEach _locationNames;

		if (_locationNames isEqualTo []) then {
			drawIcon3D ["", [1,1,0.3,_opacity], _textPos, 0, 0, 45, "None", 2, 0.05, "TahomaB", "center", false, 0, -0.03];
		};

        drawLine3D [_textPos, _pos, [1,1,1,_opacity]];

	} forEach vgm_s_loc_eden_overlay;

    {
        // Catches markers being deleted before overlay can update.
        if (get3DENEntityID _x isEqualTo -1) then {
            continue
        };
        private _pos = _x get3DENAttribute "Position" select 0;
        private _size = _x get3DENAttribute "size2" select 0;
        private _maxSize = _size # 0 max _size # 1;
		private _distance = getPosATL get3DENCamera distance _pos;
		private _opacity = (1 - ((_distance - _maxSize) / _maxDistance)) max 0 min 1;

        private _lines = [
            // Bottom left to top left
            [_pos vectorAdd [-(_size # 0), -(_size # 1)], _pos vectorAdd [-(_size # 0), _size # 1], 100],
            // Bottom left to bottom right
            [_pos vectorAdd [-(_size # 0), -(_size # 1)], _pos vectorAdd [_size # 0, -(_size # 1)], 100],
            // Top right to top left
            [_pos vectorAdd [_size # 0, _size # 1], _pos vectorAdd [-(_size # 0), _size # 1], 100],
            // Top right to bottom right
            [_pos vectorAdd [_size # 0, _size # 1], _pos vectorAdd [_size # 0, -(_size # 1)], 100]
        ];

        {
            drawLine3D [_x # 0, _x # 1, [1, 1, 1, _opacity]];
        } forEach _lines;
    } forEach vgm_s_loc_eden_overlayTargetBoxMarkers;
}];
