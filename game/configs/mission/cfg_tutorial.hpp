class Tutorial {
    displayName = "Tutorial";

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
