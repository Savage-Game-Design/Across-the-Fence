/*
    File: fn_loc_eden_getSiteLocationsByTargetBox.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-07-22
    Public: Yes

    Description:
        Creates an index of all marked locations in 3DEN, indexing them by target box and type.

        Uses vgm_s_fnc_loc_eden_getLocationsByTargetBox to retrieve a list of locations within the target box.

        See that function for more details on how to define locations.

    Parameter(s):
        None

    Returns:
        Newly created index [HashMap]

    Example(s):
        [] call vgm_s_fnc_loc_eden_getSiteLocationsByTargetBox;
 */

[] call vgm_s_fnc_sites_loadSiteTypesFromConfig;

private _locationsByTargetBox = [] call vgm_s_fnc_loc_eden_getLocationsByTargetBox;

private _locationIndex = createHashMap;
private _siteTypes = values ([] call vgm_s_fnc_sites_getAllSiteTypes);

{
    private _zoneId = _x;
    private _locations = _y;
    private _currentZoneIndex = createHashMap;
    _locationIndex set [_zoneId, _currentZoneIndex];

    {
        private _currentSiteTypeLocationsInZone = [];
        private _siteType = _x;
        _currentZoneIndex set [_siteType get "id", _currentSiteTypeLocationsInZone];

        {
            private _locData = _x;

            if ([_siteType, _locData get "tags"] call vgm_s_fnc_loc_areSiteRequirementsMet) then {
                _currentSiteTypeLocationsInZone pushBack _locData;
            };
        } forEach _locations;
    } forEach _siteTypes;
} forEach _locationsByTargetBox;

_locationIndex
