// common_includes.hpp will be automagically included.

#define VGM_CLIENT_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,\functions,PATH))
#define VGM_GLOBAL_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,\functions,PATH))

class vgm_c
{
	class default
	{
		VGM_CLIENT_PATH(\);
	};
};

class vgm_g
{
	class default
	{
		VGM_GLOBAL_PATH(\);
	};
};

