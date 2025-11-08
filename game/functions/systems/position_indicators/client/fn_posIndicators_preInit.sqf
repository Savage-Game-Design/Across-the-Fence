/*
    File: fn_posIndicators_preInit.sqf
    Author: Savage Game Design
    Date: 2025-11-06
    Last Update: 2025-11-08
    Public: No

    Description:
        Pre-init for the position indicators system
 */

vgm_c_posIndicators_counter = 0;
vgm_c_posIndicators_indicators = createHashMap;

vgm_c_posIndicators_draw3dEh = addMissionEventHandler ["Draw3D", {
    private _indicators = values vgm_c_posIndicators_indicators;

    if (_indicators isEqualTo []) exitWith {};


    private _cameraPos = positionCameraToWorld [0, 0, 0];
    private _checks = lineIntersectsSurfaces [_indicators apply {
        [
            AGLtoASL _cameraPos,
            ATLtoASL (_x get "position"),
            focusOn,
            curatorCamera,
            true,
            1,
            "FIRE"
        ]
    }];

    {
        if ((_x get "expires") < serverTime) exitWith {
            vgm_c_posIndicators_indicators deleteAt (_x get "id");
        };

        private _isVisible = _checks # _forEachIndex isEqualTo [];
        if (_x getOrDefault ["alwaysVisible", false] || _isVisible) then {
            private _pos = _x get "position";
            private _sizeFactor = linearConversion [50, 250, _cameraPos distance _pos, 1, 0.3];
            private _size = (_x get "size") * _sizeFactor;
            private _fontSize = 0.03 * _sizeFactor;
            private _color = +(_x get "color");

            if (_x getOrDefault ["fadeWhenNotVisible", false] && !_isVisible) then {
                _color set [3, _x get "fadeAlpha"];
            };

            drawIcon3D [
                _x get "texture",
                _color,
                _pos,
                _size,
                _size,
                0,
                _x get "text",
                2,
                _fontSize,
                "tt2020base_vn_bold",
                "center"
            ];
        };
    } forEach _indicators;
}];
