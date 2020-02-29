if !(isNil "vn_mf_buildMode") then
{
	private _config = (missionConfigFile >> "gamemode" >> "buildables");
	private _classes = "isClass _x" configClasses (_config) select {player getVariable ["vn_mf_rank",0] >= getNumber(_x >> "rank")};
	vn_mf_buildindex = vn_mf_buildindex + 1 min ((count _classes) -1);
	// selected class
	private _name = getText((_classes select vn_mf_buildindex) >> "name");
	[format["<t font='VeteranTypewriter' color='#ff0000' size = '.8'>%1</t>",localize _name],0,0,1,0,0,789] spawn BIS_fnc_dynamicText;
};
