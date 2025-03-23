#include "script_component.inc"
/*
    File: fn_medical_injuryEffects_init.sqf
    Author: Savage Game Design
    Date: 2023-09-02
    Last Update: 2024-07-09
    Public: No

    Description:
        Initializes medical injury effects system.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_medical_injuryEffects_init
 */

vgm_medical_injuryEffects = createHashMapFromArray [
    [BODY_PART_HEAD,
        createHashMapFromArray [
            [WOUND_NONE, createHashMapFromArray [
                ["coefficient", [
                    ["blurryVision", 0]
                ]]
            ]],
            [WOUND_MINOR, createHashMapFromArray [
                ["coefficient", [
                    ["blurryVision", DEBUFF_BLURRYVISION_MINOR]
                ]]
            ]],
            [WOUND_MAJOR, createHashMapFromArray [
                ["coefficient", [
                    ["blurryVision", DEBUFF_BLURRYVISION_MAJOR]
                ]]
            ]],
            [WOUND_SEVERE, createHashMapFromArray [
                ["code", {
                    _this call vgm_c_fnc_medical_setUnconscious;
                }]
            ]]
        ]
    ],
    [BODY_PART_ARMS,
        createHashMapFromArray [
            [WOUND_NONE, createHashMapFromArray [
                ["coefficient", [
                    ["recoil", 0]
                ]]
            ]],
            [WOUND_MINOR, createHashMapFromArray [
                ["coefficient", [
                    ["recoil", DEBUFF_RECOIL_MINOR],
                    ["aim", 0],
                    ["throw", 0],
                    ["interact", 0]
                ]]
            ]],
            [WOUND_MAJOR, createHashMapFromArray [
                ["coefficient", [
                    ["aim", DEBUFF_AIM_MINOR],
                    ["throw", DEBUFF_THROW_MINOR],
                    ["interact", DEBUFF_INTERACT_MINOR]
                ]],
                ["statusEffect", [
                    ["blockADS", false]
                ]]
            ]],
            [WOUND_SEVERE, createHashMapFromArray [
                ["coefficient", [
                    ["recoil", DEBUFF_RECOIL_MAJOR],
                    ["aim", DEBUFF_AIM_MAJOR],
                    ["throw", DEBUFF_THROW_MAJOR],
                    ["interact", DEBUFF_INTERACT_MAJOR]
                ]],
                ["statusEffect", [
                    ["blockADS", true]
                ]]
            ]]
        ]
    ],
    [BODY_PART_TORSO,
        createHashMapFromArray [
            [WOUND_NONE, createHashMapFromArray [
                ["coefficient", [
                    ["staminaDrain", 0]
                ]]
            ]],
            [WOUND_MINOR, createHashMapFromArray [
                ["coefficient", [
                    ["staminaDrain", DEBUFF_STAMINA_MINOR]
                ]]
            ]],
            [WOUND_MAJOR, createHashMapFromArray [
                ["coefficient", [
                    ["staminaDrain", DEBUFF_STAMINA_MAJOR]
                ]],
                ["code", {
                    // dice roll if unconscious
                }]
            ]],
            [WOUND_SEVERE, createHashMapFromArray [
                ["code", {
                    _this call vgm_c_fnc_medical_setUnconscious;
                }]
            ]]
        ]
    ],
    [BODY_PART_LEGS,
        createHashMapFromArray [
            [WOUND_NONE, createHashMapFromArray [
                ["statusEffect", [
                    ["forceJog", false]
                ]]
            ]],
            [WOUND_MINOR, createHashMapFromArray [
                ["statusEffect", [
                    ["forceJog", true],
                    ["forceWalk", false]
                ]]
            ]],
            [WOUND_MAJOR, createHashMapFromArray [
                ["statusEffect", [
                    ["forceWalk", true],
                    ["forceCrawl", false]
                ]]
            ]],
            [WOUND_SEVERE, createHashMapFromArray [
                ["statusEffect", [
                    ["forceCrawl", true]
                ]]
            ]]
        ]
    ]
];

vgm_medical_injuryEffectsIcons = createHashMapFromArray [
    ["bleeding", "assets\medical\bleeding_ca.paa"],
    ["forceCrawl", "assets\medical\force_crawl_ca.paa"],
    ["blockADS", "assets\medical\block_ads_ca.paa"]
];
