/*
    File: fn_sites_areSiteRequirementsMet.sqf
    Author: Savage Game Design
    Date: 2024-07-04
    Last Update: 2024-07-04
    Public: Yes

    Description:
        Given a site and a list of tags, determines if the tags meet the site's requirements to be spawned.

    Parameter(s):
        _site - Site to check [HashMap]
        _locTags - Tags to check against. Must be all lower case. [ARRAY]

    Returns:
        True if the tags meet the site's requirements, false otherwise [Boolean]

    Example(s):
        [_mySite, ["small", "jungle"]] call vgm_s_fnc_sites_locRequirementsMet;
 */

params ["_site", "_locTags"];

private _requirements = (_site get "locRequirements") + [_site get "size"];

// If no requirements are lost after array intersection, then all requirements are satisfied.
count (_locTags arrayIntersect _requirements) isEqualTo count (_requirements)
