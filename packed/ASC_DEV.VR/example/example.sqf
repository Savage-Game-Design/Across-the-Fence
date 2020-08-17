/*
	Simple example for callbacks
*/

//Don't forget to include the ASC-Macros!
#include "\sgd\anarchy\an_client_c\global\asc_macros.inc"

params["_data"];
private _txt = ["ASC EXAMPLE MSG RECEIVED: ",_data];
systemchat str _txt;
diag_log _txt;

{
	private _tag = _x#0;
	private _entryData = ENTRY_GET(_tag, _data);
	diag_log "------------------------------------------";
	systemchat str ["ASC EXAMPLE - _tag      :", _tag];
	systemchat str ["ASC EXAMPLE - _entryData:", _entryData];
	diag_log ["ASC EXAMPLE - _tag	        :", _tag];
	diag_log ["ASC EXAMPLE - _entryData 	:", _entryData];
}forEach _data;

