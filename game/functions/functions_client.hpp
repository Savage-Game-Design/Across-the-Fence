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

        class execNextFrame {};
        class preInit
        {
            preInit = 1;
        };
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
        class logWarning {
            headerType = -1;
        };
    };

    class leveling
    {
        VGM_GLOBAL_PATH(\systems\leveling\global);

        class leveling_parseLevelsCfg {};
        class leveling_preInit
        {
            preInit = 1;
        };
    };

    class medical
    {
        VGM_GLOBAL_PATH(\systems\medical\global);

        class medical_postInit
        {
            postInit = 1;
        };
        class medical_replaceItems {};
    };

    class missions
    {
        VGM_GLOBAL_PATH(\systems\missions\global);

        class missions_getHubSpawnPos {};
    };


    class skills
    {
        VGM_GLOBAL_PATH(\systems\skills\global);

        class skills_canLearn {};
        class skills_canSee {};
        class skills_getByPath {};
        class skills_getSkillTreeFromSkill {};
        class skills_getTreeSkillPoints {};
        class skills_isKnown {};
        class skills_parseTreeCfg {};
        class skills_preInit
        {
            preInit = 1;
        };
        class skills_tierInvested {};
        class skills_tierUnlocked {};
        class skills_treesHashToPathsHash;
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

    class coefficient
    {
        VGM_CLIENT_PATH(\core\client\coefficient);

        class coefficient_create {};
        class coefficient_get {};
        class coefficient_preInit
        {
            preInit = 1;
        };
        class coefficient_remove {};
        class coefficient_set {};
    };

    class displays
    {
        VGM_CLIENT_PATH(\core\client\displays);
        class displaySkills {};
        class displayAbilities {};
        class displayMissions {};
        class displayMissionsTargets {};
        class displayAbilityCooldown {};
        class displayMedical {};
        class displayStaminaBar {};
    };

    class equipment
    {
        VGM_GLOBAL_PATH(\systems\equipment\client);

        class equipment_openArsenal {};
        class equipment_postInit
        {
            postInit = 1;
        };
    };

    class missions
    {
        VGM_CLIENT_PATH(\systems\missions\client);
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

    class loading
    {
        VGM_CLIENT_PATH(\core\client\loading);

        class loading_addHandler {};
        class loading_postInit
        {
            postInit = 1;
        };
        class loading_setText {};
        class loading_tickerDots {};
    };

    class status_effect
    {
        VGM_CLIENT_PATH(\core\client\statusEffect);

        class statusEffect_create {};
        class statusEffect_get {};
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
        class update_loading_screen {};
        class progressBar {};
        class handle_light_level_loop {};
        class stack_controls {};
        class toggle_controls_group_overlay {};
    };

    class shared_hub
    {
        VGM_CLIENT_PATH(\systems\shared_hub\client);

        class sharedHub_areaLimiterDisable {};
        class sharedHub_areaLimiterEnable {};
        class sharedHub_teleportPlayerToHub {};
    };

    class leveling
    {
        VGM_CLIENT_PATH(\systems\leveling\client);

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

        class medical_addDamageModifier {};
        class medical_addWound {};
        class medical_fullHeal {};
        class medical_getArmorHitPoint {};
        class medical_getArmorItem {};
        class medical_getWound {};
        class medical_handleDamage {};
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
    class skill_passives_infantryman
    {
        VGM_CLIENT_PATH(\systems\skill\client\passives\infantryman);

        class skill_passives_infantryman_bornLeader {};
        class skill_passives_infantryman_overprepared {};
    };
    class skill_passives_recon
    {
        VGM_CLIENT_PATH(\systems\skill\client\passives\recon);

        class skill_passives_recon_betterAim {};
        class skill_passives_recon_followTheTracers {};
        class skill_passives_recon_keenEye {};
    };
    class skill_passives_support
    {
        VGM_CLIENT_PATH(\systems\skill\client\passives\support);

        class skill_passives_support_shepherd {};
    };

    class skill_actives
    {
        VGM_CLIENT_PATH(\systems\skill\client\actives);
    };
    class skill_actives_infantryman
    {
        VGM_CLIENT_PATH(\systems\skill\client\actives\infantryman);

        class skill_actives_infantryman_luckySon {};
        class skill_actives_infantryman_steadyAim {};
    };
    class skill_actives_recon
    {
        VGM_CLIENT_PATH(\systems\skill\client\actives\recon);

        class skill_actives_recon_sixthSense {};
        class skill_actives_recon_thickBrush {};
    };
    class skill_actives_support
    {
        VGM_CLIENT_PATH(\systems\skill\client\actives\support);

        // class skill_actives_support_ {};
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
};
