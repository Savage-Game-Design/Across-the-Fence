/*
  Author: Aaron Clark

  Description:
	sets health stats based effects on player

  Example Usage:
	call vn_an_fnc_health_effects;

  Parameter(s):
  	NA
*/

private _stamina_scheme = "Default";
// disable spriting if player is thirsty
if (player getVariable ["vn_an_thirst", 1] isEqualTo 0) then
{
	_stamina_scheme = "FastDrain";
	player allowSprint false;
}
else
{
	player allowSprint true;
};

// force walk if player is hungry
if (player getVariable ["vn_an_hunger", 1] isEqualTo 0) then
{
	_stamina_scheme = "Exhausted";
	player forceWalk true;
}
else
{
	player forceWalk false;
};

setStaminaScheme _stamina_scheme;
