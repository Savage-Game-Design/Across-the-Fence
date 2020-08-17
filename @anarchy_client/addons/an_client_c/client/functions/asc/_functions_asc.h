#include "..\fnc_makros_c.h"

#define FOLDER asc

// ToDo: set "asc_init" to be called from the Server via remoteExec, so the initial Data Package can't be send before the CallbackEH is set up!
C_FNC_POSTINIT(FOLDER,asc_init)
C_FNC(FOLDER,clientData_init)
C_FNC(FOLDER,ext_CE_callback_client)
