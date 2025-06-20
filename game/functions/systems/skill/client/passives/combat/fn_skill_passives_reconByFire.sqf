/*
    File: fn_skill_passives_reconByFire.sqf
    Author: Savage Game Design
    Date: 2023-09-24
    Last Update: 2025-06-18
    Public: No

    Description:
        Adds logic for "recon by fire" skill

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_reconByFire
 */

#define FONT_SIZE 0.045
#define COLOR_OPACITY(DIST) (linearConversion [30, 300, DIST, 0.4, 0.2, true])
#define ICON_SIZE(DIST) (linearConversion [30, 300, DIST, 2, 1.2, true])

params ["_known"];

if (!_known) exitWith {
    player setVariable ["vgm_g_skill_passives_reconByFire", false, true];

    removeMissionEventHandler ["Draw3D", vgm_c_skill_passives_reconByFireDrawEh];
    [vgm_c_skill_passives_reconByFireSuppressStartEh] call para_g_fnc_event_unsubscribe;
    [vgm_c_skill_passives_reconByFireSuppressEndEh] call para_g_fnc_event_unsubscribe;
};

vgm_c_skill_passives_reconByFire_items = createHashMap;
player setVariable ["vgm_g_skill_passives_reconByFire", true, true];

vgm_c_skill_passives_reconByFireDrawEh = addMissionEventHandler ["Draw3d", {
    // private _text = localize "STR_A3_ENEMY_"; // yes, with an underscore at the end...
    {
        private _isVisible = ([player, "FIRE", _y] checkVisibility [eyePos player, aimPos _y]) > 0;
        if (!_isVisible) then { continue };
        private _distance = _y distance player;
        private _iconSize = ICON_SIZE(_distance);
        drawIcon3D [
            "a3\ui_f\data\Map\Markers\HandDrawn\dot_CA.paa",
            [0.88,0.8,0.39,COLOR_OPACITY(_distance)],
            unitAimPositionVisual _y,
            _iconSize, _iconSize, 90,
            "",
            2, // shadow
            FONT_SIZE,
            "PuristaMedium"
        ];
    } forEach vgm_c_skill_passives_reconByFire_items;
}];

vgm_c_skill_passives_reconByFireSuppressStartEh = ["vgm_unit_suppressStart", {
    params ["_unit"];
    vgm_c_skill_passives_reconByFire_items set [netId _unit, _unit];
}] call para_g_fnc_event_subscribeServer;

vgm_c_skill_passives_reconByFireSuppressEndEh = ["vgm_unit_suppressEnd", {
    params ["_unit"];
    vgm_c_skill_passives_reconByFire_items deleteAt netId _unit;
}] call para_g_fnc_event_subscribeServer;
