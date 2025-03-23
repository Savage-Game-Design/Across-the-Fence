#include "../../sites.inc"

/*
    File: fn_sites_types_aa.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-09-21
    Public: Yes

    Description:
        Creates a new "AA Gun" site type

        Registered in cfg_site_types.hpp

    Parameter(s):
        N/A

    Returns:
        New site type, see vgm_s_fnc_sites_getTemplate for example [HashMap]

    Example(s):
        # See cfg_site_types.hpp
        # Alternatively:
        [
            []  call vgm_s_fnc_sites_type_aa;
        ] call vgm_s_fnc_site_addSiteType;
 */

private _site = [] call vgm_s_fnc_sites_getTemplate;

_site set ["size", SITE_FOOTPRINT_SMALL];
_site set ["locRequirements", ["skylines"]];
_site set ["spawnFunction", {
    params ["_pos2D"];

    private _composition = [["Land_vn_o_wallfoliage_01",[-1.42578,0.0822754],-2.32894,-2.32927,[-0.019373,-0.999812,0],[0,0,1],1,0,"",true,false,false],["Land_vn_bridge_road_hue_04",[-1.75391,-1.21411],-1.86047,-1.85562,[0.999748,-0.0224298,0],[0,0,1],1,0,"",true,false,false],["Land_vn_o_wallfoliage_01",[2.65039,-0.113525],-1.0538,-1.05334,[0.00476003,0.999989,0],[0,0,1],1,0,"",true,false,false],["Land_vn_o_wallfoliage_01",[0.552734,-1.94214],-1.00957,-1.0018,[0.999951,-0.00994146,0],[0,0,1],1,0,"",true,false,false],["Land_vn_o_wallfoliage_01",[0.332031,1.80981],-0.855946,-0.862961,[-0.999556,0.0298051,0],[0,0,1],1,0,"",true,false,false],["Land_vn_o_wallfoliage_01",[-1.8252,1.8606],-0.360554,-0.36821,[-0.0103209,-0.0232181,-0.999677],[-0.0344955,-0.999127,0.0235615],1,0,"",true,false,false],["Land_vn_woodenwall_01_m_4m_f",[0.38623,-1.03979],0.440205,0.444365,[0.000142148,0.00120157,0.999999],[0.00286657,-0.999995,0.00120116],1,0,"",true,false,false],["Land_vn_woodenwall_01_m_4m_f",[0.322266,0.795166],0.458883,0.455702,[-8.28183e-005,0.00121512,0.999999],[-0.00316338,0.999994,-0.00121538],1,0,"",true,false,false],["vn_o_nva_65_static_zgu1_01",[0.760254,-0.237305],2.10837,2.10932,[-0.881555,0.472081,0],[0,0,1],1,0,"",true,true,false]];
    private _objects = [_pos2D + [0], 0, _composition] call vgm_g_fnc_objGrabber_map;

    createHashMapFromArray [
        ["objects", _objects]
    ]
}];

_site
