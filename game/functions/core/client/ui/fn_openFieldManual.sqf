/*
    File: fn_openFieldManual.sqf
    Author: Savage Game Design
    Date: 2024-11-23
    Last Update: 2024-11-23
    Public: Yes

    Description:
        Opens the field manual, with additional events fired.

    Parameter(s):
        Identical to BIS_fnc_openFieldManual

    Returns:
        Nothing

    Example(s):
        ["vgm_tutorial", "getting_started"] call vgm_fnc_openFieldManual
 */

_this call para_c_fnc_ui_hints_openFieldManual;

[] spawn {
    waitUntil {isNull (uiNamespace getVariable ["RscDisplayFieldManual", displayNull])};
    ["vgm_field_manual_closed", []] call para_g_fnc_event_triggerLocal;
};
