/*
  Author: Aaron Clark

  Description:
	player respawned event to reapply unit loadout

  Parameter(s):
*/
params ["_entity", "_corpse"];
// respawn player with same loadout as before death
if (isPlayer _entity) then
{
	// get loadout from body
	private _loadout = getUnitLoadout _corpse;

	// get nearby dropped weapons
	private _weaponholders = nearestObjects[_corpse, ["WeaponHolderSimulated"], 12];
	private _delete = [];
	reverse _weaponholders;
	{
		private _current_weaponholder = _x;
		{
			private _type = getNumber(configfile >> "cfgweapons" >> (_x select 0) >> "type");
			switch _type do
			{
				case 1: {_loadout set [0,_x]; _delete pushBackUnique _current_weaponholder};
				case 4: {_loadout set [1,_x]; _delete pushBackUnique _current_weaponholder};
			};
		} forEach (weaponsItemsCargo _x);
	} foreach _weaponholders;

	// remove weapons
	{
		if (!isnull _x) then {deletevehicle _x};
	} foreach _delete;

	// restore loadout
	_entity setUnitLoadout [_loadout, false];
};
