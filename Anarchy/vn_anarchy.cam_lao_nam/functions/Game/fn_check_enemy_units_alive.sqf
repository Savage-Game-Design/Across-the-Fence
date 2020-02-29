/*
  Author: Aaron Clark

  Description:
	Checks if enemy are alive within area

  Example Usage:
	['marker_7'] call vn_mf_fnc_check_enemy_units_alive;

  Returns:
	BOOL - (True) if no enemy left alive in area

  Parameter(s):
*/
params [
	"_marker" // 0: STRING or ARRAY - marker name, location, trigger or [center, a, b, angle, isRectangle, c]
];
(allUnits inAreaArray _marker) select {alive _x && side _x == east} isEqualTo []
