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
#define VGM_IDD_DISPLAYSKILLS 23000
#define VGM_IDC_DISPLAYSKILLS_SPAVAILABLE 1000
#define VGM_IDC_DISPLAYSKILLS_SKILLS 1001
#define VGM_IDC_DISPLAYSKILLS_DESCRIPTION 1002
#define VGM_IDC_DISPLAYSKILLS_SKILLTREE 1003
#define VGM_IDC_DISPLAYSKILLS_UNLOCK 1004
#define VGM_IDC_DISPLAYSKILLS_TITLE 1005

#define VGM_IDC_DISPLAYSKILLS_SKILLDESCRIPTION 100
#define VGM_IDC_DISPLAYSKILLS_SKILLCOST 101
#define VGM_IDC_DISPLAYSKILLS_SKILLUNLOCK 102

#define VGM_IDC_DISPLAYSKILLS_BRANCHNAME_NAME 100

