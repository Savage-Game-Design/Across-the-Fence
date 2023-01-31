/*
    File: idcs.inc
    Author: Savage Game Design
    Date: 2023-01-31
    Public: No

    Description:
        IDDs/IDCs to handle access to displays/controls.

    Example(s):
        // config:
        class MyControl: MyParent
        {
            idc = VGM_IDC_DISPLAYSEXAMPLE_MYCONTROL;
            ...
        };

        // sqf:
        _ctrlMyControl = _display displayCtrl VGM_IDC_DISPLAYSEXAMPLE_MYCONTROL;
*/

// VGM_DisplaySkills, Skill Tree UI
#define VGM_IDD_RSCDISPLAYSKILLS 23000
#define VGM_IDC_RSCDISPLAYSKILLS_SPAVAILABLE 1000
#define VGM_IDC_RSCDISPLAYSKILLS_SKILLS 1001
#define VGM_IDC_RSCDISPLAYSKILLS_DESCRIPTION 1002
#define VGM_IDC_RSCDISPLAYSKILLS_SKILLTREE 1003

#define VGM_IDC_RSCDISPLAYSKILLS_SKILLDESCRIPTION 100

#define VGM_IDC_RSCDISPLAYSKILLS_BRANCHNAME_NAME 100

