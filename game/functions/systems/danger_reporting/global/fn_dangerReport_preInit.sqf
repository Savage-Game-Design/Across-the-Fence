/*
    File: fn_dangerReport_preInit.sqf
    Author: Savage Game Design
    Date: 2024-03-02
    Last Update: 2024-04-03
    Public: Yes

    Description:
        Preinit for sound reporting.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
 */

// Event group to broadcast events to.
vgm_g_dangerReport_defaultLocEventGroup = "dangerReports";
// Set it in global preInit, as it depends on the default group above.
vgm_c_dangerReport_locEventGroup = vgm_g_dangerReport_defaultLocEventGroup;
//
vgm_g_dangerReport_projectileInfoCache = createHashMap;
