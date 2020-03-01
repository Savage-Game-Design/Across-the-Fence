//
class init
{
	file = "functions\masterloop\init.sqf";
};
class events
{
	condition = "alive player";
	file = "functions\masterloop";

	class player_target
	{
		delay = 0.5;
	};
	class debug_monitor
	{
		delay = 1;
	};
};
