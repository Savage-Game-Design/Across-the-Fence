/*
    File: fn_amblife_wireTap_addActions.sqf
    Author: AtlasActual
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Client-side postInit. Subscribes to mission deploy event and scans for
        nearby wire tap junction boxes. Adds two hold actions per wire tap:
        - "Tap the Wire" (45s) — Ma Bell skill required, 150 XP + intel reveal
        - "Cut the Wire" (5s) — available to all, 50 XP + halved alertness gain

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        Called automatically via postInit
 */

#define TAP_DURATION 45
#define CUT_DURATION 5
#define SCAN_RADIUS 100
#define SCAN_INTERVAL 5

vgm_c_amblife_wireTap_active = false;

// On mission deploy: start scanning for wire tap objects
vgm_c_amblife_wireTap_deployEh = ["vgm_mission_deploy_local", {
	vgm_c_amblife_wireTap_active = true;

	[] spawn {
		while {vgm_c_amblife_wireTap_active && {alive player}} do {
			sleep SCAN_INTERVAL;

			private _targets = (player nearObjects ["vn_o_ammobox_03", SCAN_RADIUS]) select {
				_x getVariable ["vgm_wireTap_active", false]
			};

			{
				if (_x getVariable ["vgm_wireTap_hasAction", false]) then { continue };
				_x setVariable ["vgm_wireTap_hasAction", true];

				private _obj = _x;

				// --- "Tap the Wire" hold action (Ma Bell skill required, 45s) ---
				[
					_obj,
					"Tap the Wire",
					"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
					"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
					"_this distance _target < 4 && {_this getUnitTrait 'vgm_skill_maBell'} && {_target getVariable ['vgm_wireTap_active', false]}",
					"_caller distance _target < 4 && {_target getVariable ['vgm_wireTap_active', false]}",
					{},
					{
						params ["_target", "_caller", "_actionId", "_arguments", "_progress", "_maxProgress"];
						private _pct = _progress / _maxProgress;
						if (_pct > 0.2 && {_pct < 0.25}) then {
							["Splicing into the comm wire..."] call BIS_fnc_showSubtitle;
						};
						if (_pct > 0.5 && {_pct < 0.55}) then {
							["Connecting handset to the line..."] call BIS_fnc_showSubtitle;
						};
						if (_pct > 0.8 && {_pct < 0.85}) then {
							["Intercepting traffic..."] call BIS_fnc_showSubtitle;
						};
					},
					{
						params ["_target", "_caller"];
						hint "Wire tapped. Intel received.";
						_target setVariable ["vgm_wireTap_active", false, true];
						[_target, _caller] remoteExecCall ["vgm_s_fnc_amblife_wireTap_tapWire", 2];
					},
					{},
					[],
					TAP_DURATION,
					0,
					true,
					false
				] call BIS_fnc_holdActionAdd;

				// --- "Cut the Wire" hold action (all players, 5s) ---
				[
					_obj,
					"Cut the Wire",
					"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
					"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
					"_this distance _target < 4 && {_target getVariable ['vgm_wireTap_active', false]}",
					"_caller distance _target < 4 && {_target getVariable ['vgm_wireTap_active', false]}",
					{},
					{},
					{
						params ["_target", "_caller"];
						hint "Wire cut. Enemy comms disrupted.";
						_target setVariable ["vgm_wireTap_active", false, true];
						[_target, _caller] remoteExecCall ["vgm_s_fnc_amblife_wireTap_cutWire", 2];
					},
					{},
					[],
					CUT_DURATION,
					0,
					true,
					false
				] call BIS_fnc_holdActionAdd;
			} forEach _targets;
		};
	};
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
vgm_c_amblife_wireTap_endEh = ["vgm_mission_ended", {
	vgm_c_amblife_wireTap_active = false;
}] call para_g_fnc_event_subscribe;
