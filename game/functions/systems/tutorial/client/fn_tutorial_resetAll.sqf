/*
    File: fn_tutorial_resetAll.sqf
    Author: Savage Game Design
    Date: 2024-11-17
    Last Update: 2024-12-05
    Public: Yes

    Description:
        Resets all tutorials, so they can appear again.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_tutorial_resetAll;
 */

vgm_c_tutorial_seenTutorials = createHashMap;
missionProfileNamespace setVariable ["vgm_tutorial_seenTutorials", vgm_c_tutorial_seenTutorials];
saveMissionProfileNamespace;
