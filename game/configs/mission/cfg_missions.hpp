class vgm_missions {
    class default {
        transportClass = "vn_b_air_uh1d_02_07";

        class deploy {
            onStartServer = "systemChat 'onStartServer'";
            onStartClient = "systemChat 'onStartClient'";

            onFinishServer = "systemChat 'onFinishServer'";
            onFinishClient = "systemChat 'onFinishClient'";
        };
    };
};
