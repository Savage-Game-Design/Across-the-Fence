// common_includes.hpp will be automagically included.

#define VGM_CLIENT_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))
#define VGM_GLOBAL_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))

class vgm_g
{
    class default
    {
        VGM_GLOBAL_PATH(\);
    };

    class core
    {
        VGM_GLOBAL_PATH(\core\global);

        class enemySides {};
        class execNextFrame {};
        class itemConfig {};
        class itemType {};
        class manWouldCollideAtPosition {};
        class objectArea {};
        class nearestPointOnLine {};
        class preInit
        {
            preInit = 1;
        };
        class randomPosInRing {};
        class spokenDirection {};
        class startScheduler {
            postInit = 1;
        };
        class waitUntilAndExecute {};
    };

    class core_position_index
    {
        VGM_GLOBAL_PATH(\core\global\position_index);

        class posindex_add {};
        class posindex_create {};
        class posindex_delete {};
        class posindex_deleteAt {};
        class posindex_get {};
        class posindex_getItems {};
        class posindex_inAreaArray {};
        class posindex_inAreaArrayIndexes {};
        class posindex_refreshAllItems {};
        class posindex_refreshItemInSlot {};
    };

    class debug
    {
        VGM_GLOBAL_PATH(\debug\global);

        class log {
            headerType = -1;
        };
        class logDebug {
            headerType = -1;
        };
        class logError {
            headerType = -1;
        };
        class logInfo {
            headerType = -1;
        };
        class logStackTrace {
            headerType = -1;
        };
        class logWarning {
            headerType = -1;
        };
    };

    class ai
    {
        VGM_GLOBAL_PATH(\systems\ai\global);
        class ai_postInit {
            postInit = 1;
        };
        class ai_tickAllBehaviourTrees {};
    };

    class artillery
    {
        VGM_GLOBAL_PATH(\systems\artillery\global);
        class artillery_postInit {
            postInit = 1;
        };
    };

    class behaviour_trees_compiler
    {
        VGM_GLOBAL_PATH(\systems\behaviour_trees\compiler\global);
        class btree_compileTree {};
        class btree_runBasicTest {};
    };

    class behaviour_trees_nodes
    {
        VGM_GLOBAL_PATH(\systems\behaviour_trees\nodes\global);

        /* Template nodes / base nodes */
        class btree_nodeBase {};
        class btree_action_basic {};
        class btree_composite_selector {};
        class btree_composite_sequence {};
        class btree_decorator_basic {};
        class btree_decorator_basicService {};

        /* General purpose nodes */
        class btree_decorator_alwaysFail {};
        class btree_decorator_alwaysSucceed {};
        class btree_decorator_loopInfinitely {};

        /* Custom nodes */
        class btree_action_clearOrders {};
        class btree_action_moveTo {};
        class btree_action_patrolArea {};
        class btree_action_patrolRoute {};
        class btree_action_tracking_findNearbyTracks {};
        class btree_action_tracking_followInferredTrail {};
        class btree_action_tracking_followTracks {};

        class btree_decorator_disableAI {};
        class btree_decorator_fetchNearbyDangerReportAsInvestigationPoint {};
        class btree_decorator_hasOrders {};
        class btree_decorator_suppressionService {};
        class btree_decorator_timeLimit {};
        class btree_decorator_tracking_hasFollowableNearbyTracks {};
        class btree_decorator_updateKnowledgeService {};
    };

    class behaviour_trees_runner
    {
        VGM_GLOBAL_PATH(\systems\behaviour_trees\runner\global);
        class btree_preinit {
            preInit = 1;
        };
        class btree_abort_action {};
        class btree_abort_decorator {};
        class btree_abort_selector {};
        class btree_abort_sequence {};

        class btree_callOnTreeAssignedCallbacks {};
        class btree_callOnTreeUnassignedCallbacks {};

        class btree_childFinished_action {};
        class btree_childFinished_decorator {};
        class btree_childFinished_selector {};
        class btree_childFinished_sequence {};

        class btree_enterNode_action {};
        class btree_enterNode_decorator {};
        class btree_enterNode_selector {};
        class btree_enterNode_sequence {};
        class btree_enterNode {};

        class btree_exitNode_action {};
        class btree_exitNode_decorator {};
        class btree_exitNode_selector {};
        class btree_exitNode_sequence {};

        class btree_getNodeParams {};
        class btree_log {};
        class btree_panic {};
        class btree_returnToParent {};
        class btree_runChild {};

        class btree_runCurrentNode_action {};
        class btree_runCurrentNode_decorator {};
        class btree_runCurrentNode_selector {};
        class btree_runCurrentNode_sequence {};
        class btree_runCurrentNode {};

        class btree_setTreeLocal {};
        class btree_tickGroup {};
        class btree_unwindStackUpToindex {};
    };

    class behaviour_trees_trees
    {
        VGM_GLOBAL_PATH(\systems\behaviour_trees\trees\global);
        class btree_preInit_compiledTrees {
            preInit = 1;
        };

        class btree_getCompiledTree {};
        class btree_setTreeByNameFromGroupGlobalVar {};
        class btree_setTreeByNameLocal {};

        class btree_tree_enemyAI {};
    };

    class behaviour_trees_utilities
    {
        VGM_GLOBAL_PATH(\systems\behaviour_trees\ai_utilities\global);
        class btree_moveTo_execute {};
        class btree_moveTo_start {};
        class btree_moveTo_updateDestination {};
        class btree_setGroupStance {};
        class btree_setWaypoint {};
        class btree_tracking_findNearbyTrails {};
    };

    class danger_reporting
    {
        VGM_GLOBAL_PATH(\systems\danger_reporting\global);

        class dangerReport_getProjectileInfo {};
        class dangerReport_preInit {
            preInit = 1;
        };
    };

    class groupwide_event_handlers
    {
        VGM_GLOBAL_PATH(\systems\groupwide_event_handlers\global);
        class greh_addEventHandlerToAllUnitsInGroup {};
        class greh_addEventHandlerToUnit {};
        class greh_removeEventHandlerFromAllUnitsInGroup {};
        class greh_removeEventHandlerFromUnit {};
    };

    class leveling
    {
        VGM_GLOBAL_PATH(\systems\leveling\global);

        class leveling_getLevelInfo {};
        class leveling_parseLevelsCfg {};
        class leveling_preInit
        {
            preInit = 1;
        };
    };

    class locational_events
    {
        VGM_GLOBAL_PATH(\systems\locational_events\global);

        class locEvents_callHandlers {};
        class locEvents_deleteEventGroup {};
        class locEvents_onNearbyEvent {};
        class locEvents_preInit {
            preInit = 1;
        };
        class locEvents_removeHandlers {};
        class locEvents_removeListener {};
        class locEvents_triggerEvent {};
    };

    class locations
    {
        VGM_GLOBAL_PATH(\systems\locations\global);

        class loc_getTargetBoxBounds {};
        class loc_getTargetBoxMarker {};
    };

    class medical
    {
        VGM_GLOBAL_PATH(\systems\medical\global);

        class medical_isUnconscious {};
        class medical_postInit
        {
            postInit = 1;
        };
        class medical_replaceItems {};
    };

    class mission_objects
    {
        VGM_GLOBAL_PATH(\systems\mission_objects\global);

        class mission_objects_call {};
        class mission_objects_deleteObject {};
        class mission_objects_spawnObjects {};
        class mission_objects_preInit {
            preInit = 1;
        };
    };

    class missions
    {
        VGM_GLOBAL_PATH(\systems\missions\global);

        class missions_getAssignedMissionId {};
        class missions_getHubSpawnPos {};
        class missions_getPublicInfoById {};
        class missions_getZoneMarker {};
        class missions_preInit
        {
            preInit = 1;
        };
    };

    class missions_zones
    {
        VGM_GLOBAL_PATH(\systems\missions_zones\global);

        class missions_zones_postInit
        {
            postInit = 1;
        };
    };

    class object_grabber
    {
        VGM_GLOBAL_PATH(\systems\object_grabber\global);

        class objGrabber_eden_grab {};
        class objGrabber_map {};
    };

    class respawn
    {
        VGM_GLOBAL_PATH(\systems\respawn\global);

        class respawn_findSafeSpawnTransformNearTeam {};
        class respawn_findFallbackSpawnTransform {};
        class respawn_preInit {
            preInit = 1;
        };
        class respawn_remainingRespawns {};
    };

    class skills
    {
        VGM_GLOBAL_PATH(\systems\skills\global);

        class skills_canLearn {};
        class skills_canLearnWithReason {};
        class skills_canSee {};
        class skills_getByPath {};
        class skills_getSkillTreeFromSkill {};
        class skills_getTreeSkillPoints {};
        class skills_getTreeSkillPointsBelowTier {};
        class skills_isKnown {};
        class skills_knownSkillsInTier {};
        class skills_parseTreeCfg {};
        class skills_preInit
        {
            preInit = 1;
        };
        class skills_tierUnlocked {};
        class skills_treesHashToPathsHash;
    };

    class suppression
    {
        VGM_GLOBAL_PATH(\systems\suppression\global);

        class suppression_add {};
        class suppression_decay {};
        class suppression_get {
            headerType = -1;
        };
        class suppression_setShooterMultiplier {};
        class suppression_updateEffects {};
    };

    class tracking
    {
        VGM_GLOBAL_PATH(\systems\tracking\global);
        class tracking_debugHideTracks {};
        class tracking_debugShowTracks {};
        class tracking_deleteTrackingGroup {};
        class tracking_getTrackPositions {};
        class tracking_nearbyTracks {};
        class tracking_nearbyTrails {};
        class tracking_preInit {
            preInit = 1;
        };
        class tracking_postInit {
            postInit = 1;
        };
        class tracking_recordTracks {};
        class tracking_startRecordingTracks {};
        class tracking_stopRecordingTracks {};
        class tracking_trackRecordingJob {};
    };
};

class vgm_c
{
    class default
    {
        VGM_CLIENT_PATH(\);
    };

    class debug
    {
        VGM_CLIENT_PATH(\debug\client);

        class initDebugMenu
        {
            postInit = 1;
        };
    };

    class db
    {
        VGM_CLIENT_PATH(\core\client\db);

        class db_preInit {
            preInit = 1;
        };
    };

    class ai
    {
        VGM_CLIENT_PATH(\systems\ai\client);
        class ai_postInit
        {
            postInit = 1;
        };
    };

    class coefficient
    {
        VGM_CLIENT_PATH(\core\client\coefficient);

        class coefficient_create {};
        class coefficient_get {};
        class coefficient_hasReason {};
        class coefficient_override {};
        class coefficient_postInit
        {
            postInit = 1;
        };
        class coefficient_preInit
        {
            preInit = 1;
        };
        class coefficient_remove {};
        class coefficient_set {};
        class coefficient_unitInit {};
    };

    class displays
    {
        VGM_CLIENT_PATH(\core\client\displays);

        class display_preInit
        {
            preInit = 1;
        };

        class display_postInit
        {
            postInit = 1;
        };

        class displaySkills {};
        class displayAbilities {};
        class displayMissions {};
        class displayMissionsTargets {};
        class displayNotepad {};
        class displayAbilityCooldown {};
        class displayMedical {};
        class displayStaminaBar {};
        class displayEndOfMission {};
        class displayMenuBase {};
        class displayLoading {};
        class displayLevelIndicator {};
    };

    class artillery
    {
        VGM_CLIENT_PATH(\systems\artillery\client);

        class artillery_addActions {};
        class artillery_menu {};
        class artillery_removeActions {};
    };

    class carry
    {
        VGM_CLIENT_PATH(\systems\carry\client);

        class carry_canCarry {};
        class carry_doCarry {};
        class carry_preInit
        {
            preInit = 1;
        };
        class carry_tryMoveIn {};
    };

    class carry_remoteExec
    {
        VGM_CLIENT_PATH(\systems\carry\client\remoteExec);

        class carry_attachResponse {};
        class carry_detachResponse {};
    };

    class danger_reporting
    {
        VGM_CLIENT_PATH(\systems\danger_reporting\client);

        class dangerReport_playerFiredManHandler {};
        class dangerReport_postInit {
            postInit = 1;
        };
        class dangerReport_sendRecentShotsToServer {};
    };

    class equipment
    {
        VGM_CLIENT_PATH(\systems\equipment\client);

        class equipment_arsenalInit {};
        class equipment_filterLoadout {};
        class equipment_openArsenal {};
        class equipment_postInit
        {
            postInit = 1;
        };
        class equipment_setDefaultLoadout {};
        class equipment_showRemovedEquipmentMessage {};
    };

    class keyhandler
    {
        VGM_CLIENT_PATH(\core\client\keyhandler);

        class keyhandler_postInit
        {
            postInit = 1;
        };
    };

    class mission_director
    {
        VGM_CLIENT_PATH(\systems\mission_director\client);
        class director_startClientsideMonitoring {};
        class director_stopClientsideMonitoring {};
    };

    class missions
    {
        VGM_CLIENT_PATH(\systems\missions\client);

        class missions_coverMap {};
        class missions_getCurrentMission {};
        class missions_getMissions {};
        class missions_makeMissionGiver {};
        class missions_preInit {
            preInit = 1;
        };
        class missions_postInit {
            postInit = 1;
        };
    };

    class missions_internal
    {
        VGM_CLIENT_PATH(\systems\missions\client\internal);

        class missions_endMission {};
        class missions_finishDeploy {};
        class missions_startDeploy {};
    };

    class missions_gameplay
    {
        VGM_CLIENT_PATH(\systems\missions_gameplay\client);

        class missions_gameplay_postInit
        {
            postInit = 1;
        };
    };

    class missions_gameplay_extraction
    {
        VGM_CLIENT_PATH(\systems\missions_gameplay\client\extraction);

        class missions_gameplay_extraction_addAction_requestExtract {};
        class missions_gameplay_extraction_addAction_evacNow {};
        class missions_gameplay_extraction_addAction_evacAt {};
        class missions_gameplay_extraction_requestExtraction {};
        class missions_gameplay_extraction_getNearbyRadio {};
    };

    class missions_gameplay_scouting
    {
        VGM_CLIENT_PATH(\systems\missions_gameplay\client\scouting);

        class missions_gameplay_scouting_onPhoto {};
        class missions_gameplay_scouting_createUpdateLocation {};
        class missions_gameplay_scouting_getSiteById {};
        class missions_gameplay_scouting_preInit
        {
            preInit = 1;
        };
        class missions_gameplay_scouting_postInit
        {
            postInit = 1;
        };
    };

    class missions_zones
    {
        VGM_CLIENT_PATH(\systems\missions_zones\client);

        class missions_zones_getSites {};
        class missions_zones_openMissionsDialog {};
    };
    class missions_zones_remoteExec
    {
        VGM_CLIENT_PATH(\systems\missions_zones\client\remoteExec);

        class missions_zones_remoteExec_receiveList {};
    };

    class persistence
    {
        VGM_CLIENT_PATH(\systems\persistence\client);

        class persistence_addHandler {};
        class persistence_postInit
        {
            postInit = 1;
        };
        class persistence_registerSchema {};
    };

    class loading
    {
        VGM_CLIENT_PATH(\core\client\loading);

        class loading_addHandler {};
        class loading_postInit
        {
            postInit = 1;
        };
        class loading_preInit
        {
            preInit = 1;
        };
        class loading_setText {};
        class loading_tickerDots {};
    };

    class status_effect
    {
        VGM_CLIENT_PATH(\core\client\statusEffect);

        class statusEffect_create {};
        class statusEffect_get {};
        class statusEffect_postInit
        {
            postInit = 1;
        };
        class statusEffect_preInit
        {
            preInit = 1;
        };
        class statusEffect_remove {};
        class statusEffect_set {};
    };

    class ui
    {
        VGM_CLIENT_PATH(\core\client\ui);
        class handle_light_level_loop {};
        class openFieldManual {};
        class update_loading_screen {};
        class progressBar {};
        class showTabbedTextDialog {};
        class stack_controls {};
        class toggle_controls_group_overlay {};
        class watermark
        {
            postInit = 1;
        };
    };

    class shared_hub
    {
        VGM_CLIENT_PATH(\systems\shared_hub\client);

        class sharedHub_disableHub {};
        class sharedHub_enableHub {};
        class sharedHub_drawPlaque3d {};
        class sharedHub_postInit
        {
            postInit = 1;
        };
        class sharedHub_teleportPlayerToHub {};
    };

    class sites_hints
    {
        VGM_CLIENT_PATH(\systems\sites_hints\client);

        class sites_hints_getHintsInRange {};
        class sites_hints_glint {};
        class sites_hints_glintJob {};
        class sites_hints_initObject {};
        class sites_hints_inspect {};
        class sites_hints_inspectInit {};
        class sites_hints_markOnMap {};
        class sites_hints_postInit
        {
            postInit = 1;
        };
        class sites_hints_preInit
        {
            preInit = 1;
        };
    };

    class leveling
    {
        VGM_CLIENT_PATH(\systems\leveling\client);

        class leveling_getLevel {};
        class leveling_preInit
        {
            preInit = 1;
        };
        class leveling_postInit
        {
            postInit = 1;
        };
    };

    class medical
    {
        VGM_CLIENT_PATH(\systems\medical\client);

        class medical_addAction {};
        class medical_addDamageModifier {};
        class medical_addWound {};
        class medical_fullHeal {};
        class medical_getArmorHitPoint {};
        class medical_getArmorItem {};
        class medical_getWound {};
        class medical_handleDamage {};
        class medical_itemAnimation {};
        class medical_itemApply {};
        class medical_itemApplyFAK {};
        class medical_itemApplyMedikit {};
        class medical_openMedicalMenu {};
        class medical_postInit
        {
            postInit = 1;
        };
        class medical_preInit
        {
            preInit = 1;
        };
        class medical_receiveDamage {};
        class medical_removeWound {};
        class medical_setStructuralDamage {};
        class medical_setUnconscious {};
        class medical_shouldBleed {};
        class medical_statusEffectBleeding {};
        class medical_unitInit {};
        class medical_updateVisuals {};
    };

    class medical_feedback
    {
        VGM_CLIENT_PATH(\systems\medical\client\feedback);

        class medical_feedback_init {};
        class medical_feedbackBleeding {};
        class medical_feedbackHit {};
    };

    class medical_injury_effects
    {
        VGM_CLIENT_PATH(\systems\medical\client\injuryEffects);

        class medical_injuryEffects_init {};
        class medical_injuryEffectsUpdate {};
    };

    class respawn
    {
        VGM_CLIENT_PATH(\systems\respawn\client);

        class respawn_addHoldAction {};
        class respawn_decayInventory {};
        class respawn_onPauseMenu {};
        class respawn_onPlayerKilled {};
        class respawn_onPlayerRespawn {};
        class respawn_postInit
        {
            postInit = 1;
        };
        class respawn_preInit
        {
            preInit = 1;
        };
        class respawn_showRespawnInfo {};
    };

    class skills
    {
        VGM_CLIENT_PATH(\systems\skills\client);

        class skills_getSkillPoints {};
        class skills_openSkillTree {};
        class skills_postInit
        {
            postInit = 1;
        };
        class skills_preInit
        {
            preInit = 1;
        };
    };

    class skills_active
    {
        VGM_CLIENT_PATH(\systems\skills\client\active);

        class skills_active_isSlotOnCooldown {};
        class skills_active_getSlot {};
        class skills_active_assignSkillToSlot {};
        class skills_active_openAssignMenu {};
        class skills_active_openSkillWheel {};
        class skills_active_skillWheelActivate {};
        class skills_active_toggleHud {};

        class skills_active_init {};
    };

    class skills_network
    {
        VGM_CLIENT_PATH(\systems\skills\client\network);

        class skills_receiveSkillLearn {};
        class skills_receiveSkillRespec {};
        class skills_receiveSkillsData {};

        class skills_requestSkillLearn {};
        class skills_requestSkillRespec {};
        class skills_requestSkillsData {};
    };

    class skill_passives
    {
        VGM_CLIENT_PATH(\systems\skill\client\passives);

        class skill_passives_preInit
        {
            preInit = 1;
        };
    };
    class skill_passives_combat
    {
        VGM_CLIENT_PATH(\systems\skill\client\passives\combat);

        class skill_passives_ammoPouch {};
        class skill_passives_noRestraint {};
        class skill_passives_reconByFire {};
        class skill_passives_stablePlatform {};
    };
    class skill_passives_infantryman
    {
        VGM_CLIENT_PATH(\systems\skill\client\passives\infantryman);

        class skill_passives_infantryman_bornLeader {};
    };
    class skill_passives_pointman
    {
        VGM_CLIENT_PATH(\systems\skill\client\passives\pointman);

        class skill_passives_friendOrFoe {};
        class skill_passives_senseOfScale {};
    };
    class skill_passives_fireSupport
    {
        VGM_CLIENT_PATH(\systems\skill\client\passives\fire_support);

    };
    class skill_passives_support
    {
        VGM_CLIENT_PATH(\systems\skill\client\passives\support);

        class skill_passives_support_shepherd {};
    };

    class skill_actives
    {
        VGM_CLIENT_PATH(\systems\skill\client\actives);

        class skill_actives_preInit
        {
            preInit = 1;
        };

        class skill_actives_setCoefficientForDuration {};
        class skill_actives_setStatusForDuration {};
    };
    class skill_actives_combat
    {
        VGM_CLIENT_PATH(\systems\skill\client\actives\combat);

        class skill_actives_bulletHose {};
        class skill_actives_steelRain {};
    };
    class skill_actives_recon
    {
        VGM_CLIENT_PATH(\systems\skill\client\actives\recon);

        class skill_actives_recon_thickBrush {};
    };
    class skill_actives_pointman
    {
        VGM_CLIENT_PATH(\systems\skill\client\actives\pointman);

        class skill_actives_keenEye {};
        class skill_actives_oneOfThem {};
        class skill_actives_stonesThrow {};
        class skill_actives_tacticalSense {};
    };
    class skill_actives_support
    {
        VGM_CLIENT_PATH(\systems\skill\client\actives\support);

        class skill_actives_support_getToTheLz {};
        class skill_actives_support_quickBandage {};
    };

    class skill_investigate
    {
        VGM_CLIENT_PATH(\systems\skill_investigate\client);

        class skill_investigate_addAction {};
        class skill_investigate_addPlayerFiredEh {};
        class skill_investigate_addFiredEh {};
        class skill_investigate_canFocus {
            headerType = -1;
        };
        class skill_investigate_drawSoundWaves
        {
            headerType = -1;
        };
        class skill_investigate_getSpeedDrawCoef {};
        class skill_investigate_getVoiceDrawCoef {};
        class skill_investigate_postInit
        {
            postInit = 1;
        };
        class skill_investigate_preInit
        {
            preInit = 1;
        };
        class skill_investigate_queueNoise
        {
            headerType = -1;
        };
        class skill_investigate_setDesaturation {};
        class skill_investigate_setFocusMode {};
        class skill_investigate_setListenMode {};
        class skill_investigate_toggleFocusMode {};
    };

    class squad_ui
    {
        VGM_CLIENT_PATH(\systems\squad_ui\client);

        class squad_ui_preInit
        {
            preInit = 1;
        };
        class squad_ui_postInit
        {
            postInit = 1;
        };

        class squad_ui_drawPlayersOnMapEventHandler {};
    };

    class stamina
    {
        VGM_CLIENT_PATH(\systems\stamina\client);

        class stamina_getAnimCoef
        {
            headerType = -1;
        };
        class stamina_preInit
        {
            preInit = 1;
        };
        class stamina_postInit
        {
            postInit = 1;
        };
        class stamina_unitInit {};
    };

    class stealth
    {
        VGM_CLIENT_PATH(\systems\stealth\client);

        class stealth_addPlayerFiredEH {};
        class stealth_eachFrame {
            headerType = -1;
        };
        class stealth_getLighting {};
        class stealth_getVisibilityForUnit {
            headerType = -1;
        };
        class stealth_isVisibleToUnit {};
        class stealth_postInit {
            postInit = 1;
        };
        class stealth_preInit {
            preInit = 1;
        };
        class stealth_setVisible {};
        class stealth_setVisibleForDuration {};
        class stealth_setVisibleForDurationAfterDelay {};
    };

    class suppression
    {
        VGM_CLIENT_PATH(\systems\suppression\client);

        class suppression_preInit
        {
            preInit = 1;
        };
    };

    class tutorial
    {
        VGM_CLIENT_PATH(\systems\tutorial\client);

        class tutorial_preInit
        {
            preInit = 1;
        };
        class tutorial_postInit
        {
            postInit = 1;
        };

        class tutorial_resetAll {};
        class tutorial_trigger {};
    };
};
