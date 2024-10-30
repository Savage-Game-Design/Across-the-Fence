#include "../../sites.inc"

/*
    File: fn_sites_types_shelter.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-10-30
    Public: Yes

    Description:
        Creates a new "Shelter" site type

        Registered in cfg_site_types.hpp

    Parameter(s):
        N/A

    Returns:
        New site type, see vgm_s_fnc_sites_getTemplate for example [HashMap]

    Example(s):
        # See cfg_site_types.hpp
        # Alternatively:
        [
            []  call vgm_s_fnc_sites_type_shelter;
        ] call vgm_s_fnc_site_addSiteType;
 */

private _shelter = [] call vgm_s_fnc_sites_getTemplate;

_shelter set ["name", "STR_VGM_SITES_SHELTER"];
_shelter set ["size", SITE_FOOTPRINT_SMALL];
_shelter set ["nearbyTerrainTypesToHide", []];
_shelter set ["spawnFunction", {
    params ["_pos2D"];

    private _composition = [["Land_Decal_ScorchMark_01_small_F",[-0.228027,-0.741699],0,0,[0.958084,-0.286487,0],[0,0,1],1,0,"",true,true,false],["vn_o_shelter_01_part1",[-0.0783691,-0.786621],0,0,[0.958084,-0.286487,0],[0,0,1],1,0,"",true,true,false],["vn_o_shelter_01_part1",[-0.262207,-0.865234],0,0,[-0.952649,0.304072,0],[0,0,1],1,0,"",true,true,false],["vn_us_fort_common_can_01",[-2.37085,-2.14453],0,0,[0.957533,-0.288325,0],[0,0,1],1,0,"",true,true,false],["Land_vn_bedrag_01",[-4.67871,0.804688],0,0,[0.260294,0.965529,0],[0,0,1],1,0,"",false,true,false],["Land_vn_c_prop_pot_02",[1.49512,3.86719],9.53674e-05,9.53674e-05,[0.957618,-0.288041,0],[0,0,1],1,0,"",false,true,false],["Land_vn_c_prop_pot_02",[0.186523,-1.06104],0.000423431,9.53674e-05,[0.957595,-0.288092,0.0038273],[-0.00399675,0,0.999992],1,0,"",false,true,false],["Land_vn_c_branchesbig_picea",[3.86182,1.25684],0.00487518,0.00487518,[0.957603,-0.288092,0],[0,0,1],1,0,"",true,true,false],["Land_vn_c_branchesbig_picea",[-4.27441,-2.32813],0.00487518,0.00487518,[0.957533,-0.288325,0],[0,0,1],1,0,"",true,true,false],["Land_vn_bedrag_01",[3.60205,-4.22168],0.0139904,0,[0.743831,0.668361,0.00297293],[-0.00399675,0,0.999992],1,0,"",false,true,false],["Land_FoodSack_01_empty_brown_F",[2.72192,3.96387],0.0411797,0.0411797,[0.957618,-0.288041,0],[0,0,1],1,0,"",false,true,false],["Land_FoodSack_01_empty_brown_F",[1.91577,4.85156],0.0411797,0.0411797,[0.0860177,-0.996294,0],[0,0,1],1,0,"",false,true,false],["Land_FoodSack_01_empty_brown_F",[1.19116,-0.653809],0.0455341,0.0411873,[-0.256885,0.966442,-0.00102671],[-0.00399675,0,0.999992],1,0,"",false,true,false],["Land_vn_c_leaves_dead",[3.96924,1.74121],0.0493069,0.0493069,[-0.515739,0.856746,0],[0,0,1],1,0,"",true,true,false],["Land_vn_c_leaves_dead",[4.052,0.549316],0.0493069,0.0493069,[-0.429607,-0.903016,0],[0,0,1],1,0,"",true,true,false],["Land_vn_c_leaves_dead",[-5.02661,-2.65039],0.0493069,0.0493069,[-0.514828,0.857293,0],[0,0,1],1,0,"",true,true,false],["Land_vn_c_leaves_dead",[-4.15088,-1.8042],0.0493069,0.0493069,[-0.514828,0.857293,0],[0,0,1],1,0,"",true,true,false],["Land_vn_c_leaves_dead",[-3.55615,-2.90674],0.0493069,0.0493069,[-0.911512,0.411274,0],[0,0,1],1,0,"",true,true,false],["Land_vn_bamboofence_01_s_d_f",[-4.52344,-2.5918],0.483315,0.483315,[0.300081,-0.953914,0],[0,0,1],1,0,"",true,true,false],["Land_BambooFence_01_s_pole_F",[4.87646,1.77441],0.50823,0.50823,[0.958084,-0.286487,0],[0,0,1],1,0,"",true,true,false],["Land_vn_o_shelter_03",[1.37866,5.04004],0.754225,0.754225,[0.964804,-0.262969,0],[0,0,1],1,0,"",true,true,false],["Land_vn_o_shelter_06",[-3.26904,3.28711],1.15344,1.15344,[0.732993,-0.680236,0],[0,0,1],1,0,"",true,true,false],["Land_vn_o_shelter_06",[-4.72827,0.974121],1.15344,1.15344,[0.96821,-0.25014,0],[0,0,1],1,0,"",true,true,false],["Land_vn_o_shelter_06",[4.49072,-1.50732],1.16136,1.15344,[-0.960699,0.277592,0],[0,0,1],1,0,"",true,true,false],["Land_vn_o_shelter_06",[3.40601,-3.84131],1.16665,1.15344,[-0.704466,0.709738,0],[0,0,1],1,0,"",true,true,false]];
    private _objects = [_pos2D + [0], 0, _composition] call vgm_g_fnc_objGrabber_map;

    createHashMapFromArray [
        ["objects", _objects]
    ]
}];

_shelter
