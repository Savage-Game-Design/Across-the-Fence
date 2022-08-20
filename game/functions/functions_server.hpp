// common_includes.hpp will be automagically included.

#define VGM_SERVER_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))

class vgm_s
{
	class default
	{
		VGM_SERVER_PATH(\);
	};
};
