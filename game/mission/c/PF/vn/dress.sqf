/*	AUTHOR: Phronk
	OBJECT FINDER
	Description: Dress AI in a random outfit based on their building classname.
	Params: [ _agentObject , _building ]
	Example: [ _a , _b ] call PFL_vn_Dress;

*/
params[ "_a" , "_b" ];
private _b = if ( isNil "_b" ) then { objNull } else { _b };
private _patch =
[
	["\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f_01_ca.paa","\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f.rvmat"],
	[]
];

_p = ( selectRandom ( ( configProperties [ configFile >> "CfgUnitInsignia" , "true" ] ) select { "vn_b_insignia_" in str _x  } ) );
private _patch = [ getText ( _p >> "texture" ) , getText ( _p >> "material" ) ];
_a setObjectTexture[2,(_patch#0)];
_a setObjectMaterial[3,(_patch#1)];

if( floor random 5 == 1)then{ "vn_g_spectacles_02" };
_a setFace ( selectRandom baseFaces );

private _u = selectRandom ( switch ( toLowerANSI typeOf _b ) do
{
	case"vn_b_mortarpit_01"://All T-Shirts
	{
		[
			"vn_b_uniform_macv_06_07",
			"vn_b_uniform_macv_06_02",
			"vn_b_uniform_macv_06_01"
		]
	};

	default
	{
		[
			"vn_b_uniform_macv_01_07",
			"vn_b_uniform_macv_04_07",
			"vn_b_uniform_macv_05_07"
		]
	};
} );

_a forceAddUniform _u;