/*
    File: fn_loc_eden_showSitesReport.sqf
    Author: Savage Game Design
    Date: 2024-07-27
    Last Update: 2024-07-27
    Public: No

    Description:
        Shows a per-targetbox report, outlining the number of valid locations for the sites in that zone.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        [] call vgm_s_fnc_loc_eden_showSitesReport;
 */

private _targetBoxIndexes = [] call vgm_s_fnc_loc_eden_getSiteLocationsByTargetBox;
private _siteTypes = values ([] call vgm_s_fnc_sites_getAllSiteTypes);

private _perTargetBoxReports = [];

{
	private _targetBoxName = _x;
	private _siteLocations = _y;
	private _siteReports = createHashMap;

	{
		private _siteTemplate = _x;
		private _positions = _siteLocations getOrDefault [_siteTemplate get "id", []];
		private _siteName = (_siteTemplate get "name") call para_c_fnc_localize;

        // Get total number of positions and color-code accordingly.
		private _totalPositions = count _positions;
		private _colors = ["#eb4034", "#deb01b", "#0d7fbd"];
		private _colorConditions = [_totalPositions <= 0, _totalPositions <= 2, true];
		private _positionCountColor = _colors select (_colorConditions find true);

		private _siteRequirements = str (([_siteTemplate get "size"]) + (_siteTemplate get "locRequirements"));

        // Prepare individual report lines for formatting.
        // Splitting it into lines makes it easier to change later, as the format numbers stay low.
		private _siteReportLines = [
			["<t size='1.3'>%1 - <t color='%3'>%2</t></t>",
				[_siteName, _totalPositions, _positionCountColor]],
			["Required tags: %1",
				[_siteRequirements]]
		];

		_siteReportLines = _siteReportLines apply { _x params ["_template", "_args"]; format ([_template] + _args) };

		private _siteReport = _siteReportLines joinString "<br/>";

		_siteReports set [_siteName, _siteReport];
	} forEach _siteTypes;

    // Sort reports by site name, ensuring consistency across different reports.
	private _siteNames = keys _siteReports;
	_siteNames sort true;
	private _targetBoxReportLines = [];

    // Join all the individual site reports into one big eport.
	{
		_targetBoxReportLines pushBack (_siteReports get _x);
	} forEach _siteNames;

	private _targetBoxReport = parseText (_targetBoxReportLines joinString "<br/>");

    // Put each target box report on its own tab.
	_perTargetBoxReports pushBack [_targetBoxName, _targetBoxReport];
} forEach _targetBoxIndexes;

[_perTargetBoxReports] call vgm_c_fnc_showTabbedTextDialog;
