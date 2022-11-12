/*
	File: fn_buildable_overlay_init.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Initialises the interaction overlay of a buildable object.

	Parameter(s):
		_object - Buildable object to initialise the interaction overlay on

	Returns:
		Function reached the end [BOOL]

	Example(s):
		[cursorObject] call para_c_fnc_buildable_overlay_init
*/

params ["_object"];

private _building = _object getVariable ["para_g_building", objNull];

if (isNull _building) exitWith {diag_log format ["ERROR: Paradigm: Attempted to initialise overlay on invalid building %1", typeOf _object];};

private _buildclass = (_building getVariable "para_g_buildclass");

private _config = missionConfigFile >> "gamemode" >> "buildables" >> _buildClass;

if !(isClass _config) exitWith {diag_log format ["ERROR: Paradigm: Buildable of type %1 has no config", _buildclass];};

private _name = (getText (_config >> "name")) call para_c_fnc_localize;
private _description = localize "@STR_para_overlay_buildable_description";
private _variables = {
	private _building = _this getVariable "para_g_building";
	private _buildProgress = _building getVariable "para_g_build_progress";
	private _buildingIsDecaying = [_building] call para_g_fnc_building_is_decaying;
	private _statusText = localize (["STR_para_overlay_good", "STR_para_overlay_decaying"] select _buildingIsDecaying);
	private _color = ['<t color="#00ce45">%1</t>', '<t color="#e77000">%1</t>'] select _buildingIsDecaying;
	private _status = format [localize "STR_para_overlay_buildable_status", format [_color, _statusText]];

	if (_buildProgress < 1) exitWith {
		[
			[
				_status,
				format [localize "STR_para_overlay_buildable_build_progress", "%", _buildProgress * 100 toFixed 0]
			] joinString "<br/>"
		]
	};

	private _base = _building getVariable ["para_g_base", objNull];
	private _baseText = if (isNull _base) then {localize "STR_para_overlay_buildable_standalone"} else {_base getVariable "para_g_base_name"};

	_building call para_c_fnc_buildable_resupply_info params ["_percentFull", "_currentSupplies", "_suppliesUntilFull", "_lifetimeSecs", "_supplyCapacity"];
	_result = 	[
		format [localize "STR_para_overlay_buildable_base", _baseText],
		_status,
		format [localize "STR_para_overlay_buildable_percentage_filled", _percentFull * 100 toFixed 1],
		format [localize "STR_para_overlay_buildable_current_supplies", _currentSupplies toFixed 1],
		format [localize "STR_para_overlay_buildable_supplies_until_full", _suppliesUntilFull toFixed 1],
		format [localize "STR_para_overlay_buildable_supply_capacity", _supplyCapacity toFixed 1],
		format [localize "STR_para_overlay_buildable_lifetime", str floor (_lifetimeSecs / 3600), str floor ((_lifetimeSecs % 3600) / 60)]
	] joinString "<br/>";

	private _buildableConfig = [_building] call para_g_fnc_get_building_config;
	private _isWreckRecovery = isClass (_buildableConfig >> "features" >> "wreck_recovery");
	if (_isWreckRecovery) then {
		private _nextUsageTimestamp = [_building] call para_g_fnc_bf_wreck_recovery_cooldown_check;
		private _buildingOnCooldown = _nextUsageTimestamp > 0;
		private _recoveryStatusColor = ['<t color="#00ce45">%1</t>', '<t color="#e77000">%1</t>'] select _buildingOnCooldown;
		private _recoveryStatusText = localize (["STR_para_overlay_ready", "STR_para_overlay_in_progress"] select _buildingOnCooldown);
		private _recoveryStatus = format [localize "STR_para_overlay_wreck_recovery_status", format [_recoveryStatusColor, _recoveryStatusText]];
		private _recoverName = _building getVariable ["bf_wreck_recoverName", "Unknown"];

		private _recoveryBuildingInfo = [
			"<br/>",
			_recoveryStatus
		] joinString "<br/>";

		if(_buildingOnCooldown) exitWith {
			private _recoveryInfo = format ["<br/>" + localize "STR_para_overlay_wreck_recovery_time_left", _recoverName, round _nextUsageTimestamp];

			_result = _result + _recoveryBuildingInfo + _recoveryInfo
		};

		_result = _result + _recoveryBuildingInfo
	};
	
	[_result];
};

[_object, _name, "", "%1", _variables] call para_c_fnc_interactionOverlay_add;
