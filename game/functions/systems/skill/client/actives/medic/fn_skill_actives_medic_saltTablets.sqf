/*
    File: fn_skill_actives_medic_saltTablets.sqf
    Author: Savage Game Design
    Date: 2026-01-11
    Last Update: 2026-01-11
    Public: No

    Description:
        Adds logic for Medic Active Salt Tablets skill.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_medic_saltTablets
 */

["vgm_stamina_adjust", [player, 50]] call para_g_fnc_event_triggerLocal;
