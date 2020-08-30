/*
	Formats the json path to a arma-readable format.
	
	Example:
	"\\A3\\Weapons_F_Beta\\Pistols\\ACPC2\\Data\\UI\\gear_Acpc2_X_CA.paa"
	->
	"\A3\Weapons_F_Beta\Pistols\ACPC2\Data\UI\gear_Acpc2_X_CA.paa"
*/

params["_p"];
// Check if leading \ is given/needed. split/join string would remove this, so we have to add it manualy.
private _t = "";
if(_p select [0,2] == "\\")then{_t = "\";};
_p = format["%1%2", _t, (_p splitString "\\" joinString "\")];
_p
