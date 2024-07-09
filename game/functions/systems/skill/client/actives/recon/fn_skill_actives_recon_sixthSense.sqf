/*
    File: fn_skill_actives_recon_sixthSense.sqf
    Author: Savage Game Design
    Date: 2023-09-29
    Last Update: 2024-07-09
    Public: No

    Description:
        Adds logic for Recon Tier 3 6th Sense skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_recon_sixthSense
 */

#define FONT_SIZE 0.042
#define CTRL_MAP (findDisplay 12 displayCtrl 51)
#define RADIUS 150
#define COLOR_OPACITY(DIST) (linearConversion [30, RADIUS, DIST, 0.9, 0.8, true])
#define ICON_SIZE(DIST) (linearConversion [20, RADIUS, DIST, 4, 2, true])

params ["", "_skill"];

["Recon/6th Sense skill activated"] call vgm_g_fnc_logInfo;

["skill_active_sixthSense", {
    ["Recon/6th Sense skill exhausted"] call vgm_g_fnc_logInfo;

    removeMissionEventHandler ["Draw3D", vgm_c_skill_actives_recon_sixthSense_draw3DEh];
    CTRL_MAP ctrlRemoveEventHandler ["Draw", vgm_c_skill_actives_recon_sixthSenseDrawEh];
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;


private _enemySides = playerSide call vgm_g_fnc_enemySides;
private _enemies = flatten (_enemySides apply {units _x}) inAreaArray [player, RADIUS, RADIUS];
// cache object draw data
{
    private _icon = getText (configOf _x >> "icon");
    private _iconPath = getText (configFile >> "CfgVehicleIcons" >> _icon);

    _x setVariable ["vgm_c_objectIcon", _iconPath];
    _x setVariable ["vgm_c_objectName", getText (configOf _x >> "displayName")];
    _x setVariable ["vgm_c_objectColor", side _x call BIS_fnc_sideColor];
} forEach _enemies;

vgm_c_skill_actives_recon_sixthSense_list = _enemies;

vgm_c_skill_actives_recon_sixthSense_draw3DEh = addMissionEventHandler ["Draw3D", {
    {
        if (!alive _x) then {continue};

        private _distance = _x distance player;
        private _color = _x getVariable "vgm_c_objectColor";
        _color set [3, COLOR_OPACITY(_distance)];
        private _iconSize = ICON_SIZE(_distance);

        drawIcon3D [
            "a3\ui_f\data\IGUI\Cfg\WeaponCursors\cursorAimOn_gs.paa",
            _color,
            unitAimPositionVisual _x,
            _iconSize, _iconSize, 0, // icon w, h, angle
            "",
            2, // shadow
            FONT_SIZE,
            "PuristaMedium",
            "center",
            true // draw side arrows
        ];
    } forEach vgm_c_skill_actives_recon_sixthSense_list;
}];

vgm_c_skill_actives_recon_sixthSenseDrawEh = CTRL_MAP ctrlAddEventHandler ["Draw", {
    params ["_ctrlMap"];

    {
        _ctrlMap drawIcon [
            _x getVariable "vgm_c_objectIcon",
            _x getVariable "vgm_c_objectColor",
            getPosASLVisual _x,
            24,
            24,
            getDirVisual _x,
            _x getVariable "vgm_c_objectName",
            1, // shadow
            FONT_SIZE
        ];
    } forEach vgm_c_skill_actives_recon_sixthSense_list;
}];
