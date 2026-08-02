/*
    File: fn_sharedHub_nametags.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Adds 3D nametags above players in the hub showing level, name, and specialization.
        Called from fn_sharedHub_enableHub.sqf — returns the Draw3D event handler ID.

    Parameter(s):
        N/A

    Returns:
        Draw3D event handler ID [NUMBER]

    Example(s):
        vgm_sharedHub_nametagsDraw3D = [] call vgm_c_fnc_sharedHub_nametags;
 */

// Cache: compute local player's nametag string and broadcast it publicly
private _fnc_computeNametag = {
    private _levelingData = player getVariable ["vgm_g_levelingData", createHashMap];
    private _level = _levelingData getOrDefault ["level", 0];
    private _prestige = _levelingData getOrDefault ["prestige", 0];
    private _displayLevel = _prestige * 30 + _level;
    private _name = name player;

    // Determine specialization from known skill paths
    private _skillsData = player getVariable ["vgm_g_skillsData", createHashMap];
    private _skillPaths = _skillsData getOrDefault ["skillPaths", []];

    private _spec = "Recruit";
    call {
        // Check training skills in priority order
        if (["medic", "training_medic"] in _skillPaths) exitWith {_spec = "Medic"};
        if (["rto", "training_rto"] in _skillPaths) exitWith {_spec = "RTO"};
        if (["teamLeader", "training_team_leader"] in _skillPaths) exitWith {_spec = "Leader"};
        if (["pointman", "training_pointman"] in _skillPaths) exitWith {_spec = "Scout"};
        if (["tail", "training_tail"] in _skillPaths) exitWith {_spec = "Tail"};

        // Weapon spec fallback: check if any skill in a tree is known
        private _treeCount = createHashMap;
        {
            if (count _x > 0) then {
                private _tree = _x select 0;
                _treeCount set [_tree, (_treeCount getOrDefault [_tree, 0]) + 1];
            };
        } forEach _skillPaths;

        // Find the tree with most skills invested
        private _bestTree = "";
        private _bestCount = 0;
        {
            if (_y > _bestCount) then {
                _bestTree = _x;
                _bestCount = _y;
            };
        } forEach _treeCount;

        if (_bestTree == "medic") exitWith {_spec = "Medic"};
        if (_bestTree == "rto") exitWith {_spec = "RTO"};
        if (_bestTree == "teamLeader") exitWith {_spec = "Leader"};
        if (_bestTree == "pointman") exitWith {_spec = "Scout"};
        if (_bestTree == "tail") exitWith {_spec = "Tail"};
        if (_bestTree == "combat") exitWith {_spec = "Rifleman"};
    };

    private _tag = format ["%1 - %2 - %3", _displayLevel, _name, _spec];
    player setVariable ["vgm_g_nametag", _tag, true];
};

// Initial broadcast
call _fnc_computeNametag;

// Refresh nametag cache every 10 seconds in a spawned loop
vgm_sharedHub_nametagRefresh = _fnc_computeNametag spawn {
    scriptName "vgm_sharedHub_nametagRefresh";
    while {true} do {
        sleep 10;
        call _this;
    };
};

// Draw3D handler for rendering nametags above other players
private _ehId = addMissionEventHandler ["Draw3D", {
    {
        if (_x == player) then {continue};

        private _dist = player distance _x;
        if (_dist > 30) then {continue};

        private _tag = _x getVariable ["vgm_g_nametag", ""];
        if (_tag == "") then {continue};

        // Fade: full opacity at <10m, fading to 0 at 30m
        private _alpha = linearConversion [10, 30, _dist, 1, 0, true];

        private _drawPos = _x modelToWorldVisual [0, 0, 2.2];
        drawIcon3D [
            "",
            [1, 0.9, 0.5, _alpha],
            _drawPos,
            0,
            0,
            0,
            _tag,
            2,
            0.04,
            "tt2020base_vn",
            "center",
            true
        ];
    } forEach allPlayers;
}];

_ehId
