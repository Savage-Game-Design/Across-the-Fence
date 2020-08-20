#define C_FNC(SUBFOLDER,FNAME) class FNAME {file = C_PATH(SUBFOLDER,FNAME); recompile = 1;};
#define C_FNC_INIT(SUBFOLDER,FNAME) class FNAME {file = C_PATH(SUBFOLDER,FNAME); init=1; recompile = 1;};
#define C_FNC_PREINIT(SUBFOLDER,FNAME) class FNAME {file = C_PATH(SUBFOLDER,FNAME); preInit=1; recompile = 1;};
#define C_FNC_POSTINIT(SUBFOLDER,FNAME) class FNAME {file = C_PATH(SUBFOLDER,FNAME); postInit=1; recompile = 1;};
#define C_FNC_PRESTART(SUBFOLDER,FNAME) class FNAME {file = C_PATH(SUBFOLDER,FNAME); postInit=1; recompile = 1;};
#define C_PATH(SUBFOLDER,FILENAME) \sgd\anarchy\an_client_c\client\functions\##SUBFOLDER##\##FILENAME##.sqf
