/*
    File: fn_loc_eden_getTargetBoxMarkers.sqf
    Author: Savage Game Design
    Date: 2024-07-04
    Last Update: 2024-07-04
    Public: Yes

    Description:
        Gets all of the markers which define target box locations.

    Parameter(s):
        N/A

    Returns:
        Markers [Array]

    Example(s):
        [] call vgm_s_fnc_log_eden_getTargetBoxMarkers;
 */

all3DENEntities # 5 select {_x select [0, 4] == "tbox"}
