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
	class fps_tracker
	{
		delay = 20;
	};
	class critical_stats
	{
		delay = 2;
	};
	class once_a_minute
	{
		delay = 60;
	};
};
