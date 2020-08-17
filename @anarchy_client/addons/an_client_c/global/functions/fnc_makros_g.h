#define G_FNC(SUBFOLDER,FNAME) class FNAME {file = G_PATH(SUBFOLDER,FNAME);};
#define G_FNC_INIT(SUBFOLDER,FNAME) class FNAME {file = G_PATH(SUBFOLDER,FNAME); init=1;};
#define G_FNC_PREINIT(SUBFOLDER,FNAME) class FNAME {file = G_PATH(SUBFOLDER,FNAME); preInit=1;};
#define G_FNC_POSTINIT(SUBFOLDER,FNAME) class FNAME {file = G_PATH(SUBFOLDER,FNAME); postInit=1;};
#define G_FNC_PRESTART(SUBFOLDER,FNAME) class FNAME {file = G_PATH(SUBFOLDER,FNAME); postInit=1;};
#define G_PATH(SUBFOLDER,FILENAME) \sgd\anarchy\an_client_c\global\functions\##SUBFOLDER##\##FILENAME##.sqf
