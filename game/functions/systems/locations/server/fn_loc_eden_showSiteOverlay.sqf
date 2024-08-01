/*
    File: fn_loc_eden_showSiteOverlay.sqf
    Author: Savage Game Design
    Date: 2024-07-04
    Last Update: 2024-07-27
    Public: Yes

    Description:
        Shows an overlay over site locations in 3DEN, with valid sites for that loc.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_loc_eden_showSiteOverlay
 */

if (!isNil "vgm_s_loc_eden_siteOverlayDrawHandler") exitWith {};

[] call vgm_s_fnc_sites_loadSiteTypesFromConfig;

vgm_s_loc_eden_siteOverlay = createHashMap;
vgm_s_loc_eden_siteOverlayTargetBoxes = [];
// This can be refactored to be run once then be event driven, after 2.18 releases with "OnEntityAttributeChanged".
vgm_s_loc_eden_siteOverlayUpdater = [] spawn {
    while {!isNil "vgm_s_loc_eden_siteOverlay"} do {
        private _targetBoxLocs = [] call vgm_s_fnc_loc_eden_getLocationsByTargetBox;
        private _siteTypes = values ([] call vgm_s_fnc_sites_getAllSiteTypes);

        {
            private _targetBox = _x;
            private _locs = _y;
            {
                private _tags = _x get "tags";
                private _validSites = _siteTypes select {[_x, _tags] call vgm_s_fnc_loc_areSiteRequirementsMet} apply {_x get "id"};
                vgm_s_loc_eden_siteOverlay set [_x get "edenId", _validSites];
            } forEach _locs;
        } forEach _targetBoxLocs;

        vgm_s_loc_eden_siteOverlayTargetBoxMarkers = [] call vgm_s_fnc_loc_eden_getTargetBoxMarkers;

        uiSleep 5;
    };
};

vgm_s_loc_eden_siteOverlayDrawHandler = addMissionEventHandler ["Draw3D", {
	private _maxDistance = 3500;
	{
		private _id = _x;
		private _siteNames = _y;

		private _pos = ASLToATL (_id get3DENAttribute "Position" select 0);
		private _textPos = _pos vectorAdd [0, 0, 100];
		private _distance = getPosATL get3DENCamera distance _pos;
		private _opacity = (1 - (_distance / _maxDistance)) max 0 min 1;

		{
			drawIcon3D ["", [1,1,1,_opacity], _textPos, 1, 1, 45, _x, 1, 0.03, "TahomaB", "center", false, 0, -0.03 + -0.015 * _forEachIndex];
		} forEach _siteNames;

		if (_siteNames isEqualTo []) then {
			drawIcon3D ["", [1,1,0.3,_opacity], _textPos, 0, 0, 45, "None", 2, 0.05, "TahomaB", "center", false, 0, -0.03];
		};

        drawLine3D [_textPos, _pos, [1,1,1,_opacity]];

	} forEach vgm_s_loc_eden_siteOverlay;

    {
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
    } forEach vgm_s_loc_eden_siteOverlayTargetBoxMarkers;
}];
