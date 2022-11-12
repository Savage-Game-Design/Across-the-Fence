/*
	Author: Muf (modified by Karel Moricky, Joris-Jan van 't Land, Spoffy)

	Description:
		* Opens Field Manual in briefing (SP, MP Server, MP Client) and player's map.
		* Selects the topic and hint passed as parameters.
		* Can apply a (search) filter if desired.

	Parameter(s):
		0: STRING - class name of a Field Manual topic
		1: STRING - class name of a Field Manual hint
		2 (Optional): DISPLAY - specific custom display to use as parent
		3 (Optional): STRING - filter to pre-fill the search field with

	Returns:
		NOTHING
*/

disableSerialization;

private ["_topic", "_hint", "_parentDisplay"];
_topic = _this param [0, "", [""]];
_hint = _this param [1, "", [""]];
_parentDisplay = _this param [2, displayNull, [displayNull]];
_filter = _this param [3, "", [""]];

private _hintConfig = configfile >> "CfgHints" >> _topic >> _hint;
private _missionHintConfig = missionConfigFile >> "CfgHints" >> _topic >> _hint;
private _selectedConfig = if (isClass _missionHintConfig) then { _missionHintConfig } else { _hintConfig };
 

uiNamespace setVariable ["RscDisplayFieldManual_selected", str _selectedConfig];

_parentDisplay = switch true do 
{
	case !(isnull _parentDisplay): {_parentDisplay}; // Custom display (has priority)
	case !isnull(findDisplay 129): {findDisplay 129}; // Tasks after J key in game (RscDisplayDiary)
	case !isnull(findDisplay 37): {findDisplay 37}; // SP Briefing (DisplayGetReady)
	case !isnull(findDisplay 52): {findDisplay 52}; // MP Server Briefing (RscDisplayServerGetReady)
	case !isnull(findDisplay 53): {findDisplay 53}; // MP Client Briefing (RscDisplayClientGetReady)
	case (visibleMap && !isnull(findDisplay 12)): {findDisplay 12}; // Map (RscDisplayMainMap)
	case !isnull(findDisplay 46): {findDisplay 46}; //Main mission display (RscDisplayMission)
};
private _display = _parentDisplay createDisplay "RscDisplayFieldManual";

if (_filter != "") then 
{
	private _search = _display displayCtrl 1400;
	_search ctrlSetText _filter;
};