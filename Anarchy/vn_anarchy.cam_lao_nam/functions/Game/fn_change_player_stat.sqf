/*
  Author: Aaron Clark

  Description:
	changes stats vars and updates both server and client

  Example Usage:
	[_player,_varname,1] call vn_an_fnc_change_player_stat;

  Returns:
	NOTHING

  Parameter(s):
*/
params [
	"_player", 	// 0: OBJECT - player object
	"_name", 	// 1: STRING - stat name
	["_change", 1]	// 2: NUMBER - ammount to add
];

private _config = (missionConfigFile >> "gamemode" >> "stats" >> _name);
if (isClass _config) then
{
	_player_groupid = groupId (group _player);

	private _min = getNumber(_config >> "min");
	private _max = getNumber(_config >> "max");
	private _key = format["vn_an_%1",_name];
	private _val = _player getVariable [_key,0];
	_player setVariable [_key,((_val + _change) min _max) max _min,[2,owner _player]];

	// make any changes based on stats updates

	// change rank
	if (_name isEqualTo "rank") then
	{
		([_player] call vn_an_fnc_player_to_rank) params ["", "_rank", "_pointsneeded"];
		_rank = toUpper _rank;
		if !(rank _player isEqualTo _rank) then {
			_player setUnitRank _rank;
		};
	};


	private _awards = (missionConfigFile >> "gamemode" >> "awards" >> _name);
	// do awards logic here
	if (isClass _awards) then
	{
		{
			private _award_name = configName _x;
			private _a_val = getNumber(_x >> "count");
			private _a_required_teams = getArray(_x >> "required_teams");
			private _a_required_code = getText(_x >> "required_code");
			private _a_levels = getArray(_x >> "levels");
			private _a_image = "\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa";
			private _level_logic_code = "";

			private _level_id = 0;
			// find level
			{
				_x params ["_x_image","_x_val",["_x_level_logic",""]];
			    	if (_val >= _x_val) then {
					_a_image = _x_image;
					_a_val = _x_val;
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
						// todo Store
						diag_log "store award: " + _award_name;
						private _awards_var = _player getVariable ["vn_an_awards",[]];

						private _award_given = false;

						_existing_award = _awards_var findIf {(_x param [0,""]) isEqualTo _award_name};
						if !(_existing_award isEqualTo -1) then
						{
							_award_id = (_awards_var select _existing_award) select 1;
							if !(_award_id isEqualTo _level_id) then
							{
								_awards_var set [_existing_award, [_award_name,_level_id]];
								_award_given = true;
							};
						}
						else
						{
							_awards_var pushBack [_award_name,_level_id];
							_award_given = true;
						};

						if (_award_given) then
						{
							_player setVariable ["vn_an_awards",_awards_var,[2,owner _player]];
							// send notification to player
							// todo display award to player

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
						diag_log "_level_logic_code false";
						[_level_logic_code] call BIS_fnc_log;
					};

				}
				else
				{
					diag_log "_a_required_code false";
					[_a_required_code] call BIS_fnc_log;
				};
			}
			else
			{
				diag_log "_a_required_teams false";
				[_player_groupid,_a_required_teams] call BIS_fnc_log;
			};

		} forEach (configProperties [_awards]);

	};

};
