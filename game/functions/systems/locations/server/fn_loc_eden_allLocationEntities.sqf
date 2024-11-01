/*
    File: fn_loc_eden_allLocationComments.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-11-01
    Public: Yes

    Description:
        Fetches all of the location comments on the map.

    Parameter(s):
        None

    Returns:
        All comments [ARRAY]

    Example(s):
        [] call vgm_s_fnc_loc_eden_allLocationComments;
 */

private _locationsByTargetBox = [] call vgm_s_fnc_loc_eden_getLocationsByTargetBox;

private _entities = values _locationsByTargetBox apply {_x apply {_x get "edenId"}};

flatten _entities
