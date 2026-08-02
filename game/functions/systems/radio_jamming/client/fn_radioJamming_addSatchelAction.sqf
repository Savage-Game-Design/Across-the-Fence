/*
    File: fn_radioJamming_addSatchelAction.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Client-side postInit that scans for transmitter tower objects and adds
        a "Plant Satchel Charge" hold action. Works on ALL antenna sites, not
        just jammers. Requires a satchel charge magazine in inventory.

        On completion: removes the charge, sends detonation request to server.
        Server handles the 10s fuse, explosion, and antenna destruction.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
*/

#define SCAN_RADIUS 200
#define SCAN_INTERVAL 5
#define PLANT_DURATION 15

vgm_c_radioJamming_satchelActive = false;

// On mission deploy: start scanning for antenna towers
["vgm_mission_deploy_local", {
    vgm_c_radioJamming_satchelActive = true;

    [] spawn {
        while {vgm_c_radioJamming_satchelActive && {alive player}} do {
            sleep SCAN_INTERVAL;

            private _targets = player nearObjects ["Land_vn_ttowersmall_2_f", SCAN_RADIUS];
            {
                if (!alive _x) then { continue };
                if (_x getVariable ["vgm_satchel_hasAction", false]) then { continue };

                _x setVariable ["vgm_satchel_hasAction", true];

                [
                    _x,
                    "Plant Satchel Charge",
                    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
                    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
                    // Condition show: player has satchel and is close
                    "(_this distance _target < 5) && {('vn_mine_satchel_remote_02_mag' in magazines _this) || {'SatchelCharge_Remote_Mag' in magazines _this}}",
                    // Condition progress: still close
                    "_caller distance _target < 5",
                    // On start
                    {},
                    // On tick
                    {},
                    // On complete
                    {
                        params ["_target", "_caller"];

                        // Remove satchel charge from inventory
                        if ("vn_mine_satchel_remote_02_mag" in magazines _caller) then {
                            _caller removeMagazine "vn_mine_satchel_remote_02_mag";
                        } else {
                            _caller removeMagazine "SatchelCharge_Remote_Mag";
                        };

                        // Send detonation request to server
                        [_target, _caller] remoteExecCall ["vgm_s_fnc_radioJamming_detonateSatchel", 2];
                    },
                    // On interrupted
                    {},
                    [],
                    PLANT_DURATION,
                    0,
                    true,
                    false
                ] call BIS_fnc_holdActionAdd;
            } forEach _targets;
        };
    };
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
["vgm_mission_ended", {
    vgm_c_radioJamming_satchelActive = false;
}] call para_g_fnc_event_subscribe;
