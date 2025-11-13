#define NOTIFICATION_GUI_GRID_WAbs			((safezoneW / safezoneH) min 1.2)
#define NOTIFICATION_GUI_GRID_HAbs			(NOTIFICATION_GUI_GRID_WAbs / 1.2)
#define NOTIFICATION_GUI_GRID_W			(NOTIFICATION_GUI_GRID_WAbs / 40)
#define NOTIFICATION_GUI_GRID_H			(NOTIFICATION_GUI_GRID_HAbs / 25)

class Para_CfgNotifications {
    maxOnScreen = 3;
    refresh = 0.1;
    notificationGap = 8 * pixelH;
    animationDuration = 0.3;
    topOffset = 2.5 * NOTIFICATION_GUI_GRID_H;
};
