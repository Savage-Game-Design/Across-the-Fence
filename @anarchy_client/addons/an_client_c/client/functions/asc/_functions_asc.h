#include "..\fnc_macros_c.h"

// ToDo: set "asc_init" to be called from the Server via remoteExec, so the initial Data Package can't be send before the CallbackEH is set up!
C_FNC_POSTINIT(asc,asc_init)
C_FNC(asc,clientData_init)
C_FNC(asc,ext_CE_callback_client)
