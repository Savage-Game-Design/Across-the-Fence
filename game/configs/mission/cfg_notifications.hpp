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

    class VGM_SiteSpotted: VGM_Default
    {
        title = "$STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_SPOTTED_TITLE";
        iconPicture = "\a3\ui_f\data\Map\Diary\Icons\diaryLocateTask_ca.paa";
        description = "%1";
        priority = 10;
    };
};
