/*
    File: fn_loc_eden_getTargetBoxLayers.sqf
    Author: Savage Game Design
    Date: 2024-07-22
    Last Update: 2024-07-22
    Public: Yes

    Description:
        Retrieves all layers in the 3DEN editor that represent target boxes.

    Parameter(s):
        N/A

    Returns:
        3DEN layer entities that are target boxes [Array]

    Example(s):
        [] call vgm_s_fnc_loc_eden_getTargetBoxLayers;
 */

#define EDEN_ENTITIES_LAYERS 6

private _allLayers = all3DENEntities # EDEN_ENTITIES_LAYERS;
// Find the layer called "targetboxes"
private _targetBoxesLayer = _allLayers select (_allLayers findIf { _x get3DENAttribute "Name" select 0 == "targetboxes" });
// All sublayers of "targetboxes" are individual target boxes.
get3DENLayerEntities _targetBoxesLayer;
