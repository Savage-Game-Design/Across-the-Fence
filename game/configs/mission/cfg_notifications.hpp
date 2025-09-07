class CfgNotifications
{
    class VGM_Default
    {
        title = "";				// Title displayed as text on black background. Filled by arguments.
        iconPicture = "";		// Small icon displayed in left part. Colored by "color", filled by arguments.
        iconText = "";			// Short text displayed over the icon. Colored by "color", filled by arguments.
        description = "";		// Brief description displayed as structured text. Colored by "color", filled by arguments.
        color[] = {1,1,1,1};	// Icon and text color
        duration = 5;			// How many seconds will the notification be displayed
        priority = 0;			// Priority; higher number = more important; tasks in queue are selected by priority
        difficulty[] = {};		// Required difficulty settings. All listed difficulties has to be enabled
    };

    class VGM_SiteAdded: VGM_Default
    {
        title = "$STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_ADDED_TITLE";
        iconPicture = "\a3\ui_f\data\Map\Diary\Icons\diaryLocateTask_ca.paa";
        description = "$STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_ADDED_DESCRIPTION";
    };

    class VGM_SiteTypeChanged: VGM_Default
    {
        title = "$STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_EDITED_TITLE";
        iconPicture = "\a3\ui_f\data\Map\Diary\Icons\diaryLocateTask_ca.paa";
        description = "$STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_CHANGED_TYPE_DESCRIPTION";
    };

    class VGM_SitePositionChanged: VGM_Default
    {
        title = "$STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_EDITED_TITLE";
        iconPicture = "\a3\ui_f\data\Map\Diary\Icons\diaryLocateTask_ca.paa";
        description = "$STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_CHANGED_POSITION_DESCRIPTION";
    };

    class VGM_SitePhotoChanged: VGM_Default
    {
        title = "$STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_EDITED_TITLE";
        iconPicture = "\a3\ui_f\data\Map\Diary\Icons\diaryLocateTask_ca.paa";
        description = "$STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_CHANGED_PHOTO_DESCRIPTION";
    };

    class VGM_ExtractionEvacNow: VGM_Default
    {
        title = "$STR_VGM_MISSIONS_EXTRACTION_NOTIFICATION_TITLE";
        iconPicture = "\a3\ui_f\data\Map\Markers\Military\warning_ca.paa";
        description = "$STR_VGM_MISSIONS_EXTRACTION_NOTIFICATION_EVACNOW_DESCRIPTION";
        color[] = {0.8,0,0,1};
    };

    class VGM_ExtractionEvacAt: VGM_Default
    {
        title = "$STR_VGM_MISSIONS_EXTRACTION_NOTIFICATION_TITLE";
        iconPicture = "\a3\ui_f\data\Map\Markers\Military\warning_ca.paa";
        description = "$STR_VGM_MISSIONS_EXTRACTION_NOTIFICATION_EVACAT_DESCRIPTION";
        color[] = {0.8,0,0,1};
    };

};
