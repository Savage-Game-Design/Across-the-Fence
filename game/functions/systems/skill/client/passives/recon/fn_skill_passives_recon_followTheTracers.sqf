/*
    File: fn_skill_passives_recon_followTheTracers.sqf
    Author: Savage Game Design
    Date: 2023-09-24
    Last Update: 2024-07-09
    Public: No

    Description:
        Adds logic for Recon Tier 3 Follow the Tracers skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_recon_followTheTracers
 */

#define FONT_SIZE 0.045
#define COLOR_OPACITY(DIST) (linearConversion [30, 300, DIST, 0.9, 0.9, true])
#define ICON_SIZE(DIST) (linearConversion [30, 300, DIST, 2, 1.2, true])

params ["_known"];

if (!_known) exitWith {
    player setVariable ["vgm_g_skill_passives_recon_followTheTracers", false, true];

    removeMissionEventHandler ["Draw3D", vgm_c_skill_passives_recon_followTheTracersDrawEh];
    [vgm_c_skill_passives_recon_followTheTracersSuppressStartEh] call para_g_fnc_event_unsubscribe;
    [vgm_c_skill_passives_recon_followTheTracersSuppressEndEh] call para_g_fnc_event_unsubscribe;
};

vgm_c_skill_passives_recon_followTheTracers_items = createHashMap;
player setVariable ["vgm_g_skill_passives_recon_followTheTracers", true, true];

vgm_c_skill_passives_recon_followTheTracersDrawEh = addMissionEventHandler ["Draw3d", {
    // private _text = localize "STR_A3_ENEMY_"; // yes, with an underscore at the end...
    {
        private _distance = _y distance player;
        private _iconSize = ICON_SIZE(_distance);
        drawIcon3D [
            "a3\ui_f\data\IGUI\Cfg\WeaponCursors\gl_gs.paa",
            [1,0,0,COLOR_OPACITY(_distance)],
            unitAimPositionVisual _y,
            _iconSize, _iconSize, 90,
            "",
            2, // shadow
            FONT_SIZE,
            "PuristaMedium"
        ];
    } forEach vgm_c_skill_passives_recon_followTheTracers_items;
}];

vgm_c_skill_passives_recon_followTheTracersSuppressStartEh = ["vgm_unit_suppressStart", {
    params ["_unit"];
    vgm_c_skill_passives_recon_followTheTracers_items set [netId _unit, _unit];
}] call para_g_fnc_event_subscribeServer;

vgm_c_skill_passives_recon_followTheTracersSuppressEndEh = ["vgm_unit_suppressEnd", {
    params ["_unit"];
    vgm_c_skill_passives_recon_followTheTracers_items deleteAt netId _unit;
}] call para_g_fnc_event_subscribeServer;
