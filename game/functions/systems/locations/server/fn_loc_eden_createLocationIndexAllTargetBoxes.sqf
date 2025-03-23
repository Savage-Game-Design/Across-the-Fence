/*
    File: fn_loc_eden_createLocationIndexAllTargetBoxes.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-08-21
    Public: Yes

    Description:
        Creates an index of all marked locations in 3DEN, and writes it to the mission.sqm as Logic entities.

        See vgm_s_fnc_loc_eden_indexAllTargetBoxLocations for more information on the indexing process.

    Parameter(s):
        None

    Returns:
        Newly created index [HashMap]

    Example(s):
        [] call vgm_s_fnc_loc_eden_createLocationIndexAllTargetBoxes;
 */

private _siteLocationsByTargetBox = [] call vgm_s_fnc_loc_eden_indexAllTargetBoxLocations;
private _targetBoxLayers = [] call vgm_s_fnc_loc_eden_getTargetBoxLayers;

{
    private _currentLayer = _x;
    private _targetBoxName = trim (_currentLayer get3DENAttribute "Name" select 0);
    private _targetBoxIndex = createHashMap;

    // Transform the fully detailed target box index into a simple site type -> positions mapping.
    {
        private _positions = _y apply {_x get "pos"};
        _targetBoxIndex set [_x, _positions];
    } forEach (_siteLocationsByTargetBox get _targetBoxName);

    private _entitiesInLayer = get3DENLayerEntities _x;

    private _marker = _entitiesInLayer select { _x isEqualType "" && { "tbox" in _x } } select 0;
    private _logicIndex = _entitiesInLayer findIf { _x isEqualType objNull && { typeOf _x == "Logic"} };
    private _logic = objNull;

    if (_logicIndex > -1) then {
        _logic = _entitiesInLayer select _logicIndex;
        _logic set3DENAttribute ["position", _marker get3DENAttribute "position" select 0];
    } else {
        _logic = create3DENEntity ["Logic", "Logic", _marker get3DENAttribute "position" select 0];
        _logic set3DENLayer _currentLayer;
    };

    private _initCode = format [
        "
        private _index = createHashMapFromArray %1;
        if (isServer && !is3DEN) then {
            ['%2', _index] call vgm_s_fnc_loc_setTargetBoxIndex;
        };
        _index
        ",
        str _targetBoxIndex,
        _targetBoxName
    ];

    _logic set3DENAttribute ["Init", _initCode];
} forEach _targetBoxLayers;
