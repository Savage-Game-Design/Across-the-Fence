
if(isNil "AN_S_ServerData")then
{
	(_this#0) params["_ip","_port"];
	private _txt = format["AN_ASC - AN_ASC_ADDRESS_SET - _ip: %1 || _port: %2", _ip, _port];
	diag_log _txt;
	
	// compileFinal "AN_ServerData_tmp" var and also make "AN_S_ServerData" useable as a simple array (without the extra "call")
	AN_S_ServerData = compileFinal str[_ip, _port];
};