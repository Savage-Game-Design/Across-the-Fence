/*
  Author: Aaron Clark

  Description:
	on player connected event

  Parameter(s):
*/
params [
	"_id",
	"_uid",
	"_name",
	"_jip",
	"_owner"
];

diag_log format["PlayerConnected mEH: %1", _this];
