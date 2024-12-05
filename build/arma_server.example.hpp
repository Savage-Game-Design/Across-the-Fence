hostname="VGM Development";

loopback = true;
localClient[] = {"127.0.0.1"};

admins[] = {
    "76561197993041837", // veteran29
    "76561198011383725"  // Spoffy
};
passwordAdmin = "admin";

voteThreshold = 1;
voteMissionPlayers = 2;
allowedVoteCmds[] = {};


armaUnitsTimeout = 1;
allowedFilePatching = 2;
battlEye = 0;
persistent = 1;
verifySignatures = 0;

class Missions {
    class vgm {
        template = "MISSION_NAME";
        difficulty = "regular";
        class Params {};
    };
};

class AdvancedOptions {
    LogObjectNotFound = true;
    SkipDescriptionParsing = false;
    ignoreMissionLoadErrors = true;
};
