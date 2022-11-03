// common_includes.hpp will be automagically included.

#define VGM_SERVER_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))

class vgm_s
{
	class default
	{
		VGM_SERVER_PATH(\);
	};

	class paradigm_interop
	{
		VGM_SERVER_PATH(\paradigm_interop\server);
		class harass_filter_target_players {};
	};

	class db
	{
		VGM_SERVER_PATH(\core\server\db);

		class db_init {};
		class db_set_player_vars {};
		class db_get_player_vars {};
		class db_query {};
		class db_get_type {};
	};
};
