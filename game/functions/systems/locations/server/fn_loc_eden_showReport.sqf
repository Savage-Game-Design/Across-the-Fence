/*
    File: fn_loc_eden_showReport.sqf
    Author: Savage Game Design
    Date: 2024-07-27
    Last Update: 2024-08-21
    Public: No

    Description:
        Shows a per-targetbox report, outlining the number of valid locations for the sites in that zone.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        [] call vgm_s_fnc_loc_eden_showReport;
 */

private _targetBoxIndexes = [] call vgm_s_fnc_loc_eden_indexAllTargetBoxLocations;
private _locationTypes = values ([] call vgm_s_fnc_loc_getLocationTypes);

private _perTargetBoxReports = [];

{
	private _targetBoxName = _x;
	private _siteLocations = _y;
	private _reports = createHashMap;

	{
		private _locationType = _x;
		private _positions = _siteLocations getOrDefault [_locationType get "id", []];
		private _locTypeName = _locationType get "name";

        // Get total number of positions and color-code accordingly.
		private _totalPositions = count _positions;
		private _colors = ["#eb4034", "#deb01b", "#0d7fbd"];
		private _colorConditions = [_totalPositions <= 0, _totalPositions <= 2, true];
		private _positionCountColor = _colors select (_colorConditions find true);

		private _siteRequirements = str (_locationType get "requirements");

        // Prepare individual report lines for formatting.
        // Splitting it into lines makes it easier to change later, as the format numbers stay low.
		private _reportLines = [
			["<t size='1.3'>%1 - <t color='%3'>%2</t></t>",
				[_locTypeName, _totalPositions, _positionCountColor]],
			["Required tags: %1",
				[_siteRequirements]]
		];

		_reportLines = _reportLines apply { _x params ["_template", "_args"]; format ([_template] + _args) };

		private _report = _reportLines joinString "<br/>";

		_reports set [_locTypeName, _report];
	} forEach _locationTypes;

    // Sort reports by site name, ensuring consistency across different reports.
	private _locTypeNames = keys _reports;
	_locTypeNames sort true;
	private _targetBoxReportLines = [];

    // Join all the individual site reports into one big eport.
	{
		_targetBoxReportLines pushBack (_reports get _x);
	} forEach _locTypeNames;

	private _targetBoxReport = parseText (_targetBoxReportLines joinString "<br/>");

    // Put each target box report on its own tab.
	_perTargetBoxReports pushBack [_targetBoxName, _targetBoxReport];
} forEach _targetBoxIndexes;

[_perTargetBoxReports] call vgm_c_fnc_showTabbedTextDialog;
