/*
  Author: Aaron Clark

  Description:
	changes stats vars and updates both server and client

  Example Usage:
	[[_player],_varname,1] call vn_an_fnc_change_player_stat;

  Returns:
	NOTHING

  Parameter(s):
*/
params [
	"_players", 	// 0: ARRAY of OBJECTs - player objects
	"_name", 	// 1: STRING - stat name
	["_change", 1]	// 2: NUMBER - ammount to add
];
private _config = (missionConfigFile >> "gamemode" >> "stats" >> _name);
private _awards = (missionConfigFile >> "gamemode" >> "awards" >> _name);
if (isClass _config) then
{
	private _min = getNumber(_config >> "min");
	private _max = getNumber(_config >> "max");
	private _default = getNumber(_config >> "default");
	private _key = format["vn_an_%1",_name];
	{
		private _player = _x;

		// make variable change
		private _val = _player getVariable [_key,_default];
		private _new_val = ((_val + _change) min _max) max _min;
		_player setVariable [_key,_new_val,[2,owner _player]];


		// change rank
		if (_name isEqualTo "rank") then
		{
			([_player] call vn_an_fnc_player_to_rank) params ["", "_rank", "_pointsneeded"];
			_rank = toUpper _rank;
			if !(rank _player isEqualTo _rank) then {
				_player setUnitRank _rank;
			};
		};

		// do awards logic here
		if (isClass _awards) then
		{
			private _player_groupid = groupId (group _player);
			{
				private _award_name = configName _x;
				private _a_required_teams = getArray(_x >> "required_teams");
				private _a_required_code = getText(_x >> "required_code");
				private _a_levels = getArray(_x >> "levels");
				private _a_image = "\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa";
				private _level_logic_code = "";

				private _level_id = 0;
				// find level
				{
					_x params ["_x_image","_x_val",["_x_level_logic",""]];
				    	if (_new_val >= _x_val) then {
						_a_image = _x_image;
						_level_id = _forEachIndex;
						_level_logic_code = _x_level_logic;
					};
				} forEach _a_levels;

				// check that player is in required group
				if ((_a_required_teams isEqualTo []) || _player_groupid in _a_required_teams ) then
				{
					// check that any required logic is met
					if ((_a_required_code isEqualTo "") || {call compile _a_required_code} ) then
					{
						// check that any extra required logic is met for level
						if ((_level_logic_code isEqualTo "") || {call compile _level_logic_code} ) then
						{
							("store award: " + _award_name) call BIS_fnc_log;
							private _awards_var = _player getVariable ["vn_an_awards",[]];

							private _award_given = false;

							_existing_award = _awards_var findIf {(_x param [1,""]) isEqualTo _award_name};
							if !(_existing_award isEqualTo -1) then
							{
								_award_id = (_awards_var select _existing_award) select 2;
								if !(_award_id isEqualTo _level_id) then
								{
									_awards_var set [_existing_award, [_name,_award_name,_level_id]];
									_award_given = true;
								};
							}
							else
							{
								_awards_var pushBack [_name,_award_name,_level_id];
								_award_given = true;
							};

							if (_award_given) then
							{
								_player setVariable ["vn_an_awards",_awards_var,[2,owner _player]];
								// send notification to player
								[
									[
										configName _x,
										_a_image
									],
									{
										titleText [format["<t color='#ff0000' size='2'>%1</t><br/><img size='5' image='%2'/>",localize format["STR_vn_an_%1",(_this select 0)],(_this select 1)], "PLAIN", -1, true, true];
									}
								] remoteExecCall ["call",_player];
							};
						}
						else
						{
							[_level_logic_code] call BIS_fnc_log;
						};

					}
					else
					{
						[_a_required_code] call BIS_fnc_log;
					};
				}
				else
				{
					[_player_groupid,_a_required_teams] call BIS_fnc_log;
				};

			} forEach (configProperties [_awards]);

		};

	} forEach _players;
};
