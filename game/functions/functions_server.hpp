// common_includes.hpp will be automagically included.

#define VGM_SERVER_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))

class vgm_s
{
    class default
    {
        VGM_SERVER_PATH(\);
    };

    class core
    {
        VGM_SERVER_PATH(\core\server);

        class postInit
        {
            postInit = 1;
        };
    };

    class paradigm_interop
    {
        VGM_SERVER_PATH(\paradigm_interop\server);
        class harass_filter_target_players {};
    };

    class db
    {
        VGM_SERVER_PATH(\core\server\db);

        class db_clear {};
        class db_get {};
        class db_save {};
        class db_typed_save {};
    };

    class missions
    {
        VGM_SERVER_PATH(\systems\missions\server);

        class missions_createMission {};
        class missions_endMission {};
        class missions_joinMission {};
        class missions_leaveMission {};
        class missions_preInit {
            preInit = 1;
        };
        class missions_setPlayerReadiness {};
        class missions_startMission {};
    };

    class missions_remoteExec
    {
        VGM_SERVER_PATH(\systems\missions\server\remoteExec);

        class missions_remoteExec_createMission {};
        class missions_remoteExec_joinMission {};
        class missions_remoteExec_leaveMission {};
        class missions_remoteExec_setReadiness {};
        class missions_remoteExec_startMission {};
    };

    class missions_internal
    {
        VGM_SERVER_PATH(\systems\missions\server\internal);

        class missions_attachPlayerToMission {};
        class missions_despawnMission {};
        class missions_preventJoining {};
        class missions_removePlayerFromMission {};
        class missions_spawnMission {};
        class missions_updateStatus {};
    };

    class player
    {
        VGM_SERVER_PATH(\core\server\player);

        class player_fetch {};
        class player_save {};
    };

    class respawn
    {
        VGM_SERVER_PATH(\systems\respawn\server);

        class respawn_onPlayerKilled {};
        class respawn_onPlayerRespawn {};
        class respawn_findSafeSpawnTransformNearTeam {};
        class respawn_findFallbackSpawnTransform {};
    };

    class leveling
    {
        VGM_SERVER_PATH(\systems\leveling\server);

        class leveling_addExperience {};

        class leveling_dataGetCached {};
        class leveling_dbGet {};
        class leveling_dbSave {};

        class leveling_preInit
        {
            preInit = 1;
        };
    };

    class skills
    {
        VGM_SERVER_PATH(\systems\skills\server);

        class skills_addSkillpoint {};

        class skills_dataGetCached {};
        class skills_dbGet {};
        class skills_dbSave {};

        class skills_forgetSkills {};

        class skills_preInit
        {
            preInit = 1;
        };

        class skills_teachSkill {};
    };

    class skills_network
    {
        VGM_SERVER_PATH(\systems\skills\server\network);

        class skills_handle_skillLearnRequest {};
        class skills_handle_skillRespecRequest {};
        class skills_handle_skillsDataRequest {};
    };
};
