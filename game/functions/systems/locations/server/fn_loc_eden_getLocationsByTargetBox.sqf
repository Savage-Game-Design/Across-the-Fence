/*
    File: fn_loc_eden_getLocationsByTargetBox.sqf
    Author:
    Date: 2024-07-03
    Last Update: 2024-07-27
    Public: No

    Description:
        Retrieves all the marked site locations for all target boxes, indexed by target box name/id.

    Parameter(s):
        N/A

    Returns:
        Mapping from target box name, to array of location hashmaps [HashMap]

    Example(s):
        [] call vgm_s_fnc_loc_eden_getLocationsByTargetBox;
 */

#define EDEN_ENTITIES_LAYERS 6
#define EDEN_ENTITIES_COMMENTS 7

// Use this to check if a given ID is a comment. 3DEN doesn't seem to have a "type" command.
private _allCommentIds = (all3DENEntities # EDEN_ENTITIES_COMMENTS) createHashMapFromArray [];
// Final index to be returned.
private _targetBoxIndexes = createHashMap;

private _targetBoxLayers = [] call vgm_s_fnc_loc_eden_getTargetBoxLayers;

// Add all target box layers to the index.
{
    private _layerEntity = _x;
    private _layerName = _x get3DENAttribute "Name" select 0;

    private _targetBoxName = trim (_layerName);
    private _targetBoxIndex = _targetBoxIndexes getOrDefault [_targetBoxName, [], true];
    private _entitiesInLayer = get3DENLayerEntities _layerEntity;

    // Find any location comments in the target box layer and index them.
    {
        private _commentEntity = _x;
        private _commentName = _x get3DENAttribute "Name" select 0;
        if (toLower (_commentName select [0, 3]) != "loc") then {
            continue;
        };

        private _tagsString = (_commentName splitString ":" select 1);
        private _tags = (_tagsString splitString ",") apply { toLower trim _x };

        _targetBoxIndex pushBack createHashMapFromArray [
            ["edenId", _commentEntity],
            ["pos", (_commentEntity get3DENAttribute "Position" select 0)],
            ["tags", _tags]
        ];
    } forEach (_entitiesInLayer select {_x isEqualType 0} select {_x in _allCommentIds});
} forEach _targetBoxLayers;

_targetBoxIndexes
