

params
[
	["_class","",[""]]
];
private _cfg_Path = missionConfigFile >> "cfgAn_items";
private _size = getArray(_cfg_Path >> _class >> "size");
private _canFlip = getNumber(_cfg_Path >> _class >> "canFlip");
private _cfgBase = getText(_cfg_Path >> _class >> "configBase");
private _class_base = getText(_cfg_Path >> _class >> "classname");

[_size,_canFlip,_cfgBase,_class_base]