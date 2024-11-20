class Tutorial {
    displayName = "Tutorial";

    /*
    class Example {
        displayName = "Example";
        displayNameShort = "E.g.";
        description = "This is an example of a triggerable tutorial.";
        // image = "";

        // Triggers cause the card hint to appear on-screen.
        // A tutorial will only ever show a hint once, no matter how many times its triggered.
        class Triggers {
            // Fires when this marker in the mission.sqm is entered by the player.
            markerEntered = "";
            // Fires when this event is triggered on the client, from any source.
            eventFired = "vgm_tutorial_test";
            // Objects with a `vgm_c_tutorial` variable set can trigger a tutorial.
            // E.g for this tutorial entry:
            //     cursorObject setVariable ["vgm_c_tutorial", ["Tutorial", "Example"]];
        };
    };
    */


    class Tutorial1 {
        displayName = "Tutorial 1";
        displayNameShort = "Tutorial 1";
        description = "This is an example of tutorial text to be used while setting the system up.";
        // image = "";
        // Note: No Image

        class Triggers {
            markerEntered = "";
            eventFired = "vgm_tutorial_test";
            // Objects with a `vgm_c_tutorial` variable set can also trigger.
            // e.g cursorObject setVariable ["vgm_c_tutorial", ["Tutorial", "Tutorial1"]];
        };
    };

    class Tutorial2 {
        displayName = "Tutorial 2";
        displayNameShort = "Tutorial 2";
        description = "This is an example of tutorial text to be used while setting the system up.";
        // image = "";
        // Note: No Image

        class Triggers {
            markerEntered = "tutorial_2";
            //eventFired = "";
            // Objects with a `vgm_c_tutorial` variable set can also trigger.
            // e.g cursorObject setVariable ["vgm_c_tutorial", ["Tutorial", "Tutorial1"]];
        };
    };
};

class Other {
    displayName = "Other";

    class Tutorial1 {
        displayName = "Other 1";
        displayNameShort = "Other 1";
        description = "This is an example of tutorial text to be used while setting the system up.";
        // image = "";
        // Note: No Image
    };
};
