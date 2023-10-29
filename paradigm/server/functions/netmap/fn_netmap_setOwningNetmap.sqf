/*
    File: fn_netmap_setOwningNetmap.sqf
    Author: Savage Game Design
    Date: 2023-09-14
    Last Update: 2023-09-14
    Public: Yes

    Description:
        Sets the netmap to be owned by another netmap.
        When the owning netmap is terminated, terminates all owned netmaps.

    Parameter(s):
        _netmapToOwn - Netmap to own [Netmap]
        _owningNetmap - Netmap that will own the other [Netmap]

    Returns:
        Nothing

    Example(s):
        [_bigNetmap, "things", _otherNetmap] call para_s_fnc_netmap_set;
        [_otherNetmap, _bigNetmap] call para_s_fnc_netmap_setOwningNetmap;
 */

params ["_netmapToOwn", "_owningNetmap"];

private _netmaptoOwnId = _netmapToOwn get "_netmap" get "id";
private _oldOwnerId = _netmapToOwn get "_netmap" getOrDefault ["owner", ""];

if (_oldOwnerId isNotEqualTo "") then {
    private _oldOwner = localNamespace getVariable "para_netmaps" get _oldOwnerId;
    private _oldOwnerOwnedNetmaps = _oldOwner get "_netmap" get "ownedNetmaps";

    _oldOwnerOwnedNetmaps deleteAt (_oldOwnerOwnedNetmaps find _netmaptoOwnId);
};

if (!isNil "_owningNetmap") then {
    private _owningNetmapId = _owningNetmap get "_netmap" get "id";
    _netmapToOwn get "_netmap" set ["owner", _owningNetmapId];
    _owningNetmap get "_netmap" get "ownedNetmaps" pushBackUnique _netmaptoOwnId;
};

