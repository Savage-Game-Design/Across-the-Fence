#include "../../sites.inc"

/*
    File: fn_sites_types_ammoCache.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-10-24
    Public: Yes

    Description:
        Creates a new "Ammo cache" site type

        Registered in cfg_site_types.hpp

    Parameter(s):
        N/A

    Returns:
        New site type, see vgm_s_fnc_sites_getTemplate for example [HashMap]

    Example(s):
        # See cfg_site_types.hpp
        # Alternatively:
        [
            []  call vgm_s_fnc_sites_type_ammoCache;
        ] call vgm_s_fnc_site_addSiteType;
 */

private _site = [] call vgm_s_fnc_sites_getTemplate;

_site set ["name", "STR_VGM_SITES_AMMO_CACHE"];
_site set ["size", SITE_FOOTPRINT_SMALL];
_site set ["locRequirements", []];
_site set ["spawnFunction", {
    params ["_pos2D"];

    private _composition = [["Land_vn_o_wallfoliage_01",[-3.51086,0.700195],-0.173187,-0.183695,[-0.332812,-0.942993,0.000131577],[0.7173,-0.253068,0.649182],1,0,"",true,true,false],["Land_vn_b_pipermeth_f",[-4.64807,-1.9751],-0.132771,-0.150105,[-0.31529,-0.948982,-0.00505295],[-0.00399675,-0.00399663,0.999984],1,0,"",true,true,false],["Land_vn_o_wallfoliage_01",[3.79395,-1.67383],-0.0915909,-0.0858402,[0.331685,0.94339,0.0001342],[-0.717601,0.252208,0.649184],1,0,"",true,true,false],["Land_vn_o_wallfoliage_01",[1.42444,3.36035],-0.0226154,-0.033514,[-0.941537,0.33691,2.6226e-06],[-0.256269,-0.716179,0.649164],1,0,"",true,true,false],["Land_vn_o_wallfoliage_01",[-1.81372,-4.6333],0.000326157,0,[0.951723,-0.306959,0],[0,0,1],1,0,"",true,true,false],["vn_o_ammobox_full_06",[-0.116089,-1.21924],0.397177,0.402927,[-0.311422,-0.950272,0],[0,0,1],1,0,"",true,true,false],["Land_vn_o_bunker_04",[-0.000366211,-1.40967],0.663597,0.669348,[0.34587,0.938282,0],[0,0,1],1,0,"",true,true,false],["Land_vn_b_calochlaena_f",[0.944458,-4.9248],0.82712,0.83287,[-0.10763,-0.994184,-0.00376147],[0.00424223,-0.00424267,0.999982],1,0,"",true,true,false],["Land_vn_b_calochlaena_f",[2.6853,3.33057],0.838207,0.834875,[0.6087,0.793391,-0.00376147],[-0.00141892,0.00582953,0.999982],1,0,"",true,true,false],["Land_vn_b_calochlaena_f",[-2.30457,4.05127],0.853321,0.829071,[-0.626945,0.779055,-0.00376178],[-0.00600007,0,0.999982],1,0,"",true,true,false],["Land_vn_b_cycas_f",[0.185425,4.12158],0.865681,0.847351,[0,0.999423,-0.0339789],[-0.0100007,0.0339772,0.999373],1,0,"",true,true,false],["Land_vn_b_leucaena_f",[5.00623,2.14404],1.44666,1.45241,[-0.888497,-0.458883,0],[0,0,1],1,0,"",true,true,false],["Land_vn_b_leucaena_f",[-4.93079,1.2666],1.46701,1.44798,[0.986149,-0.165863,0],[0,0,1],1,0,"",true,true,false],["Land_vn_t_banana_wild_f",[3.36084,-2.43359],2.12215,2.1279,[0,0.999838,0.0179961],[0,-0.0179961,0.999838],1,0,"",true,true,false],["Land_vn_t_leucaena_f",[2.6582,-5.62305],4.59838,4.60413,[0.0655861,-0.997847,0],[0,0,1],1,0,"",true,true,false],["Land_vn_t_leucaena_f",[-2.73389,4.91943],4.62838,4.60413,[-0.193747,0.981052,0],[0,0,1],1,0,"",true,true,false]];
    private _objects = [_pos2D + [0], 0, _composition] call vgm_g_fnc_objGrabber_map;

    createHashMapFromArray [
        ["objects", _objects]
    ]
}];

_site
