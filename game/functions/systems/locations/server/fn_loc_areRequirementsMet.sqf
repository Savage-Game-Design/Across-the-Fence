/*
    File: fn_sites_areRequirementsMet.sqf
    Author: Savage Game Design
    Date: 2024-07-04
    Last Update: 2024-08-21
    Public: Yes

    Description:
        Given a list of site requirements, and a list of location tags, determines if the tags meet the site's requirements to be spawned.

    Parameter(s):
        _requirements - List of tags to check [ARRAY]
        _locTags - Tags to check against. Must be all lower case. [ARRAY]

    Returns:
        True if the tags meet the site's requirements, false otherwise [Boolean]

    Example(s):
        [
            [_mySite] call vgm_s_fnc_sites_getSiteTypeRequirements,
            ["small", "jungle"]
        ] call vgm_s_fnc_sites_locRequirementsMet;
 */

params ["_requirements", "_locTags"];

// If no requirements are lost after array intersection, then all requirements are satisfied.
count (_locTags arrayIntersect _requirements) isEqualTo count (_requirements)
