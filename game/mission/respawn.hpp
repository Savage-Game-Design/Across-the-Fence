class CfgRespawnTemplates
{
    class vgm_respawn
    {
        onPlayerKilled = "functions\systems\respawn\server\fn_respawn_onPlayerKilled.sqf";
        onPlayerRespawn = "functions\systems\respawn\server\fn_respawn_onPlayerRespawn.sqf";
    };
};

respawn = "INSTANT";
respawnButton = 1;
respawnDialog = 0;
respawnDelay = 5;
respawnOnStart = -1;
respawnTemplates[] = { "vgm_respawn" };
