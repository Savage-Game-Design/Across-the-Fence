// enable build mode
if (isNil "vn_an_buildMode") then
{
	// only allow build mode if player is on foot
	if (isNull objectParent player) then
	{
		vn_an_buildMode = true;

		private _config = (missionConfigFile >> "gamemode" >> "buildables");

		private _classes = "isClass _x" configClasses (_config) select {player getVariable ["vn_an_rank",0] >= getNumber(_x >> "rank")};

		private _class = _classes select vn_an_buildindex;

		[format["<t font='VeteranTypewriter' color='#ff0000' size = '.8'>%1</t>",localize getText(_class >> "name")],0,0,1,0,0,789] spawn BIS_fnc_dynamicText;

		// [configName _class] spawn vn_an_fnc_place_object;
	};
} else {
	vn_an_buildMode = nil;
	vn_an_placing = false;
};
