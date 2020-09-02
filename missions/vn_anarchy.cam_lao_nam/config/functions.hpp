class cfgfunctions
{
	//Function definitions for mission-specific paradigm features.
	/*
	class para_interop {
		class interop {
			file = "functions\paradigm_interop";
			class get_squad_composition {};
			class valid_attack_angles {};
		};
	};
	*/
	class vn_an
	{

		class client
		{
			class debug_monitor {};
			class start_game_client {};
			class start_game_headless {};
			class start_game_stage2 {};
			class update_loading_screen {};
		};

		class init
		{
			class pre_init
			{
				preinit = 1;
			};
			class post_init
			{
				postinit = 1;
			};
		};

		class server
		{
			class end_mission {};
			class init_player {};
			class start_game_server {};
		};

	};
};
