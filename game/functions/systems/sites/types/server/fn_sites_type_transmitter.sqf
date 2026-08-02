#include "../../sites.inc"

/*
    File: fn_sites_types_transmitter.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-10-30
    Public: Yes

    Description:
        Creates a new "Transmitter" site type

        Registered in cfg_site_types.hpp

    Parameter(s):
        N/A

    Returns:
        New site type, see vgm_s_fnc_sites_getTemplate for example [HashMap]

    Example(s):
        # See cfg_site_types.hpp
        # Alternatively:
        [
            []  call vgm_s_fnc_sites_type_transmitter;
        ] call vgm_s_fnc_site_addSiteType;
 */

private _site = [] call vgm_s_fnc_sites_getTemplate;

_site set ["size", SITE_FOOTPRINT_SMALL];
_site set ["locRequirements", []];
_site set ["nearbyTerrainTypesToHide", []];
_site set ["spawnFunction", {
    params ["_pos2D"];

    private _spawnPos = _pos2D + [0];

    private _part1 = createVehicle ["Land_vn_ttowersmall_2_f", _spawnPos, [], 0, "CAN_COLLIDE"];
    private _part2 = createVehicle ["Land_vn_ttowersmall_2_f", _spawnPos, [], 0, "CAN_COLLIDE"];

    _part2 attachTo  [_part1, [0, 0, 10]];
    _part2 setVariable ["vgm_s_sites_transmitter_sibling", _part1];
    _part1 setVariable ["vgm_s_sites_transmitter_sibling", _part2];

    // 35% chance this transmitter is a radio jammer
    private _isJammer = random 1 < 0.35;
    if (_isJammer) then {
        _part1 setVariable ["vgm_radioJammer_isJamming", true, true];

        private _jammerEntry = createHashMapFromArray [
            ["pos", _pos2D + [0]],
            ["object", _part1],
            ["radius", 600]
        ];

        vgm_s_radioJammer_sites pushBack _jammerEntry;
        publicVariable "vgm_s_radioJammer_sites";

        format ["Transmitter at %1 is a radio jammer (600m radius)", _pos2D] call vgm_g_fnc_logInfo;
    };

    private _fnc_onKilled = {
        params ["_unit"];

        _unit getVariable "vgm_s_sites_transmitter_sibling" setDamage 1;

        // If this was a jammer, remove it from the global array
        if (_unit getVariable ["vgm_radioJammer_isJamming", false]) then {
            private _newJammers = vgm_s_radioJammer_sites select {
                (_x get "object") != _unit
            };
            vgm_s_radioJammer_sites = _newJammers;
            publicVariable "vgm_s_radioJammer_sites";

            format ["Radio jammer at %1 destroyed - jamming removed", getPos _unit] call vgm_g_fnc_logInfo;
        };
    };


    _part1 addEventHandler ["Killed", _fnc_onKilled];
    _part2 addEventHandler ["Killed", _fnc_onKilled];

    createHashMapFromArray [
        ["objects", [_part1, _part2]]
    ]
}];

_site
