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

        class hideTerrainObjects {};
        class unhideTerrainObjects {};

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
        class db_persist {};
        class db_postInit {
            postInit = 1;
        };
        class db_preInit {
            preInit = 1;
        };
        class db_save {};
        class db_typed_save {};
    };
    class db_backend
    {
        VGM_SERVER_PATH(\core\server\db\backend);

        class db_backend_init {};
    };

    class extension
    {
        VGM_SERVER_PATH(\core\server\extension);

        class extension_call {};
        class extension_preInit {
            preInit = 1;
        };
        class extension_setHandler {};
    };

    class ai
    {
        VGM_SERVER_PATH(\systems\ai\server);

    };
;

    class behaviour_trees_trees
    {
        VGM_SERVER_PATH(\systems\behaviour_trees\trees\server);

        class btree_setTreeByNameGlobal {};
    };

    class carry
    {
        VGM_SERVER_PATH(\systems\carry\server);

        class carry_preInit
        {
            preInit = 1;
        };
    };

    class carry_remoteExec
    {
        VGM_SERVER_PATH(\systems\carry\server\remoteExec);

        class carry_attachRequest {};
        class carry_detachRequest {};
    };

    class mission_director
    {
        VGM_SERVER_PATH(\systems\mission_director\server);
        class director_preInit {
            preInit = 1;
        };
        class director_addAlertness {
            headerType = -1;
        };
        class director_attemptReinforcements {};
        class director_checkZombiesEnabled {};
        class director_getDirectorForMissionId {};
        class director_getEnemySquadTemplate {};
        class director_getZombieSquadTemplate {};
        class director_onPlayerNoiseEvent {};
        class director_onRadioTransmission {};
        class director_processMission {};
        class director_spawnAmbientZombies {};
        class director_spawnInitialPatrols {};
        class director_spawnReinforcements {};
        class director_spawnTracker {};
        class director_startMission {};
        class director_stopMission {};
    };

    class mission_director_engagements
    {
        VGM_SERVER_PATH(\systems\mission_director\server\engagements);
        class director_addEnemyGroupToPlayerEngagement {};
        class director_createEngagement {};
        class director_deleteEngagement {};
        class director_deleteEngagementIfEnded {};
        class director_preinitEngagements {};
        class director_removeEnemyGroupFromPlayerEngagement {};
        class director_setupEngagements {};
    };

    class mission_director_reinforcement_requests
    {
        VGM_SERVER_PATH(\systems\mission_director\server\reinforcement_requests);
        class director_handleReinforcementRequest {};
        class director_setupReinforcementRequests {};
    };

    class missions_objects
    {
        VGM_SERVER_PATH(\systems\mission_objects\server);

        class mission_objects_call {};
        class mission_objects_createObject {};
        class mission_objects_deleteObject {};
        class mission_objects_preInit {
            preInit = 1;
        };
        class mission_objects_spawnObjects {};
    };

    class missions
    {
        VGM_SERVER_PATH(\systems\missions\server);

        class missions_createMission {};
        class missions_endMission {};
        class missions_getAllMissions {};
        class missions_getAssignedMission {};
        class missions_getById {};
        class missions_getFullness {};
        class missions_getPlayers {};
        class missions_joinMission {};
        class missions_leaveMission {};
        class missions_preInit {
            preInit = 1;
        };
        class missions_postInit {
            postInit = 1;
        };
        class missions_setPlayerReadiness {};
        class missions_startMission {};
        class missions_createSystemNetmap {};
        class missions_getSystemNetmap {};
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
        class missions_calculateMilestones {};
        class missions_preventJoining {};
        class missions_removePlayerFromMission {};
        class missions_updateStatus {};
    };

    class missions_gameplay
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server);

        class missions_gameplay_createCrewedHelicopter {};
    };

    class missions_gameplay_ambient
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\ambient);

        class missions_gameplay_ambient_departHelicopter {};
    };

    class missions_gameplay_infil
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\infil);

        class missions_gameplay_infil_startInfil {};
    };

    class missions_gameplay_ambient_life
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\ambient_life);

        class amblife_preInit {};
        class amblife_postInit {};
        class amblife_spawnForMission {};
        class amblife_cleanupForMission {};
        class amblife_findWaterPositions {};
        class amblife_findRoadPositions {};
        class amblife_findBuildingPositions {};
        class amblife_spawnCivilians {};
        class amblife_spawnRiverTraffic {};
        class amblife_spawnRoadTraffic {};
        class amblife_spawnBicycleCouriers {};
        class amblife_spawnBicycleConvoys {};
        class amblife_spawnWorkParties {};
        class amblife_spawnCheckpoints {};
        class amblife_spawnWireTaps {};
        class amblife_wireTap_tapWire {};
        class amblife_wireTap_cutWire {};
        class amblife_spawnLivestock {};
        class amblife_civilianReporting {};
        class amblife_walkRoadNetwork {};
        class amblife_findRoadNearPlayer {};
        class amblife_respawnMonitor {};
    };

    class missions_gameplay_extraction
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\extraction);

        class missions_gameplay_extraction_scriptedLand {};
        class missions_gameplay_extraction_startExtract {};
    };

    class missions_gameplay_compromised_lz
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\compromised_lz);

        class compromisedLz_preInit {};
        class compromisedLz_postInit {};
        class compromisedLz_spawnDefenders {};
        class compromisedLz_triggerAmbush {};
        class compromisedLz_occupyLzs {};
        class compromisedLz_cleanup {};
    };

    class missions_gameplay_scouting
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\scouting);

        class missions_gameplay_scouting_calculateMilestones {};
        class missions_gameplay_scouting_handleAdded {};
        class missions_gameplay_scouting_handleMarked {};
        class missions_gameplay_scouting_handleSetSitePhoto {};
        class missions_gameplay_scouting_handleSetSiteType {};
        class missions_gameplay_scouting_onMissionEnded {};
        class missions_gameplay_scouting_onMissionStarted {};
        class missions_gameplay_scouting_postInit
        {
            postInit = 1;
        };
        class missions_gameplay_scouting_registerMission {};
        class missions_gameplay_scouting_setSpottable {};
        class missions_gameplay_scouting_registerVirtualSite {};
        class missions_gameplay_scouting_spawnOfficer {};
        class missions_gameplay_scouting_monitorOfficer {};
    };

    class missions_gameplay_bda
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\bda);

        class bda_preInit {};
        class bda_postInit {};
        class bda_buildScene {};
        class bda_spawnForMission {};
        class bda_cleanupForMission {};
    };

    class missions_gameplay_snatch
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\snatch);

        class missions_gameplay_snatch_calculateMilestones {};
        class missions_gameplay_snatch_monitorTarget {};
        class missions_gameplay_snatch_onMissionEnded {};
        class missions_gameplay_snatch_onMissionStarted {};
        class missions_gameplay_snatch_postInit
        {
            postInit = 1;
        };
        class missions_gameplay_snatch_registerMission {};
        class missions_gameplay_snatch_setupTarget {};
    };

    class missions_gameplay_bright_light
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\bright_light);

        class missions_gameplay_bright_light_calculateMilestones {};
        class missions_gameplay_bright_light_monitorTarget {};
        class missions_gameplay_bright_light_onMissionEnded {};
        class missions_gameplay_bright_light_onMissionStarted {};
        class missions_gameplay_bright_light_postInit
        {
            postInit = 1;
        };
        class missions_gameplay_bright_light_registerMission {};
        class bright_light_createCrashScene {};
    };

    class missions_gameplay_hatchet
    {
        VGM_SERVER_PATH(\systems\missions_gameplay\server\hatchet);

        class missions_gameplay_hatchet_calculateMilestones {};
        class missions_gameplay_hatchet_monitorTeam {};
        class missions_gameplay_hatchet_onMissionEnded {};
        class missions_gameplay_hatchet_onMissionStarted {};
        class missions_gameplay_hatchet_postInit
        {
            postInit = 1;
        };
        class missions_gameplay_hatchet_registerMission {};
        class missions_gameplay_hatchet_spawnCounterattack {};
    };

    class missions_zones
    {
        VGM_SERVER_PATH(\systems\missions_zones\server);

        class missions_zones_clearSites {};
        class missions_zones_freeZone {};
        class missions_zones_getSites {};
        class missions_zones_getStartPos {};
        class missions_zones_postInit
        {
            postInit = 1;
        };
        class missions_zones_preInit
        {
            preInit = 1;
        };
        class missions_zones_reserveZone {};
        class missions_zones_spawnRandomSites {};
    };
    class missions_zones_remoteExec
    {
        VGM_SERVER_PATH(\systems\missions_zones\server\remoteExec);

        class missions_zones_remoteExec_getList {};
    };

    class persistence
    {
        VGM_SERVER_PATH(\systems\persistence\server);

        class persistence_cacheKey {};
        class persistence_dbCommit {};
        class persistence_dbGet {};
        class persistence_dbSet {};

        class persistence_load {};
        class persistence_preInit
        {
            preInit = 1;
        };
        class persistence_registerSchema {};
    };

    class player
    {
        VGM_SERVER_PATH(\core\server\player);

        class player_fetch {};
        class player_fromId {};
        class player_save {};
    };

    class respawn
    {
        VGM_SERVER_PATH(\systems\respawn\server);

        class respawn_clearMissionRallyPoint {};
        class respawn_postInit {
            postInit = 1;
        };
        class respawn_setMissionRallyPoint {};
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

        class leveling_skipToLevel {};
    };

    class locations
    {
        VGM_SERVER_PATH(\systems\locations\server);

        class loc_areRequirementsMet {};
        class loc_eden_allLocationEntities {};
        class loc_eden_createLocationIndexAllTargetBoxes {};
        class loc_eden_getLocationsByTargetBox {};
        class loc_eden_indexAllTargetBoxLocations {};
        class loc_eden_getTargetBoxLayers {};
        class loc_eden_getTargetBoxMarkers {};
        class loc_eden_showOverlay {};
        class loc_eden_showReport {};
        class loc_eden_transformLocationNames {};
        class loc_getLocationTypes {};
        class loc_getTargetBoxIds {};
        class loc_getTargetBoxLocations {};
        class loc_preInit {
            preInit = 1;
        };
        class loc_setTargetBoxIndex {};
    };

    class shared_hub
    {
        VGM_SERVER_PATH(\systems\shared_hub\server);

        class sharedHub_preInit
        {
            preInit = 1;
        };
    };

    class sites
    {
        VGM_SERVER_PATH(\systems\sites\server);

        class sites_preInit
        {
            preInit = 1;
        };
        class sites_postInit
        {
            postInit = 1;
        };

        class sites_addSiteType {};
        class sites_delete {};
        class sites_getAllSiteTypes {};
        class sites_getSiteType {};
        class sites_getSiteTypeRequirements {};
        class sites_getTemplate {};
        class sites_isInMission {};
        class sites_loadSiteTypesFromConfig {};
        class sites_spawn {};
        class sites_spawnPunjiTraps {};
        class sites_spawnRandomFortifications {};
        class sites_onObjectDestroyed {};
    };

    class sites_hints
    {
        VGM_SERVER_PATH(\systems\sites_hints\server);

        class sites_hints_getConfig {};
        class sites_hints_place {};
        class sites_hints_preInit
        {
            preInit = 1;
        };
        class sites_hints_registerMission {};
    };

    class site_types
    {
        VGM_SERVER_PATH(\systems\sites\types\server);

        class sites_type_aa {};
        class sites_type_ammoCache {};
        class sites_type_bulldozer {};
        class sites_type_campfire {};
        class sites_type_encampment {};
        class sites_type_shelter {};
        class sites_type_supplyDump {};
        class sites_type_transmitter {};
        class sites_type_truckPark {};
        class sites_type_waystation {};
    };

    class skill
    {
        VGM_SERVER_PATH(\systems\skill\server);

        class skill_preInit
        {
            preInit = 1;
        };

        class skill_trapDisarm_process {};
        class skill_slam_destroyHvt {};
        class skill_saboteur_process {};
        class skill_dynamite_spawnClaymores {};
        class skill_lethalGifts_placeMine {};
        class skill_lethalGifts2_placeClaymore {};
        class skill_alternateLz_requestNewLz {};
        class skill_cutthroat_suppressAlert {};
        class skill_eldestSon_plantBoobyTrap {};
        class skill_maBell_wiretap {};
        class skill_pileOfLeaves_hideBody {};
        class skill_prairieFire_spawnCAS {};
        class skill_prairieFire_shootdown {};
        class skill_staboExtract_startExtract {};
        class skill_targetFolder_revealIntel {};
    };

    class ron_server
    {
        VGM_SERVER_PATH(\systems\ron\server);

        class ron_execute {};
        class ron_spawnProbe {};
    };

    class skill_server_rto
    {
        VGM_SERVER_PATH(\systems\skill\server\rto);

        class skill_actives_sitrep_server {};
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
        class skills_handle_skillUnlearnRequest {};
        class skills_handle_skillsDataRequest {};
    };

    class skill_presets
    {
        VGM_SERVER_PATH(\systems\skill_presets\server);

        class skillPresets_preInit
        {
            preInit = 1;
        };
        class skillPresets_dbGet {};
        class skillPresets_dbSave {};
        class skillPresets_handle_fetchRequest {};
        class skillPresets_handle_saveRequest {};
        class skillPresets_handle_loadRequest {};
        class skillPresets_handle_deleteRequest {};
    };

    class prestige
    {
        VGM_SERVER_PATH(\systems\prestige\server);

        class prestige_handle_request {};
    };

    class time_of_day_voting
    {
        VGM_SERVER_PATH(\systems\time_of_day_voting\server);
        class timeOfDayVote_preInit { preInit = 1; };
        class timeOfDayVote_remoteExec_startPreMissionVote {};
        class timeOfDayVote_setTime {};
        class timeOfDayVote_startPreMissionVote {};
    };

    class virtsquad
    {
        VGM_SERVER_PATH(\systems\virtual_squads\server);

        class virtsquad_create {};
        class virtsquad_createMissionSquadsInfo {};
        class virtsquad_delete {};
        class virtsquad_despawn {};
        class virtsquad_destroyGroup {};
        class virtsquad_getMissionSquadsInfo {};
        class virtsquad_perFrame {
            headerType = -1;
        };
        class virtsquad_postInit {
            postInit = 1;
        };
        class virtsquad_preinit {
            preInit = 1;
        };
        class virtsquad_scaleComposition {};
        class virtsquad_spawn {};
        class virtsquad_spawnLoop {};
    };

    class radiocheckin
    {
        VGM_SERVER_PATH(\systems\radiocheckin\server);

        class radiocheckin_postInit {};
        class radiocheckin_onCheckin {};
    };

    class radio_jamming_server
    {
        VGM_SERVER_PATH(\systems\radio_jamming\server);

        class radioJamming_preInit {
            preInit = 1;
        };
        class radioJamming_detonateSatchel {};
    };

    class voicelines
    {
        VGM_SERVER_PATH(\systems\voicelines\server);

        class voicelines_init {
            postInit = 1;
        };
        class voicelines_play {};
        class voicelines_playDelayed {};
    };

    class mortar_barrage
    {
        VGM_SERVER_PATH(\systems\mortar_barrage\server);

        class mortar_preinit {
            preInit = 1;
        };
        class mortar_start {};
        class mortar_stop {};
        class mortar_processState {};
        class mortar_fireRound {};
        class mortar_getTeamCentroid {};
    };
;
};
