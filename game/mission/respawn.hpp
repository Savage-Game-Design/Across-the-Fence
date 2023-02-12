class CfgRespawnTemplates
{
    class vgm_respawn
    {
        onPlayerRespawn = "functions\systems\respawn\server\fn_respawn_onPlayerRespawn.sqf";
    };
};

respawn = "BASE";
respawnDialog = 0;
respawnButton = 1;
respawnOnStart = -1;
respawnDelay = 0;
respawnTemplates[] = { "vgm_respawn" };
