/*
    File: fn_sites_hints_initObject.sqf
    Author: Savage Game Design
    Date: 2024-10-27
    Last Update: 2025-01-10
    Public: No

    Description:
        Initialize hint object.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [allSitesObjects # 0, [[0, 0, 0]]] call vgm_c_fnc_sites_hints_initObject
 */

params ["_object", "_args"];
_args params ["_sitePos"];

vgm_sites_hints_objectsList pushBack _object;

_object setVariable ["vgm_sites_hints_sitePos", _sitePos];

private _fnc_modifierDefault = {_this setVectorUp surfaceNormal getPosATL _this};
_object call (vgm_sites_hints_placementModifiers getOrDefault [typeOf _object, _fnc_modifierDefault]);

// Derive glint color from classname
private _type = toLower typeOf _object;
private _color = switch (true) do {
	case (_type find "blood" >= 0):                                              {[1, 0.3, 0.3, 0.5]};
	case (_type find "canister" >= 0 || {_type find "item_" >= 0}
	      || {_type find "ammobox" >= 0} || {_type find "helmet" >= 0}):         {[0.8, 0.9, 1.0, 0.6]};
	default                                                                      {[1, 0.85, 0.5, 0.45]};
};
_object setVariable ["vgm_sites_hints_glintColor", _color];
