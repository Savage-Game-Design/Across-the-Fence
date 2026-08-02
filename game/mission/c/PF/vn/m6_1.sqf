//Land_vn_shower_01
isNil{params["_b"];
_b setVariable["PF",[]];
private _dir = getDir _b;



private _eh = {
params [ "_a" ];
_a addEventHandler [ "AnimDone" ,
{
	params["_a","_an"];
	_a switchMove _an;
}];
};



private _man = {
params["_b","_dir","_pos"];
private _a = "vn_b_men_army_28"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a removeWeapon(handgunWeapon _a);
	removeUniform _a;
	removeVest _a;
	removeHeadgear _a;
	removeGoggles _a;
	_a switchMove(selectRandom["AidlPercMstpSnonWnonDnon_G04","Acts_Taking_Cover_From_Jets_loop","Acts_Grieving","HubBriefing_scratch"]);
	_a setMimic "unconscious";
	_a call _eh;
	_a setFace (selectRandom baseFaces);
	_a setDir random 359;
	_a setPosASL [_pos#0,_pos#1,(_pos#2)-3.1];
	_a disableCollisionWith _b;
};



_off = -1.5;
for "_x" from 1 to 4 do
{
if(floor random 3==1)then
{
private _speed = 1;
private _lifetime = 1;
private _size = 0.025;
private _coeff = 1;
private _color_start = [0.6,0.6,1,0.15];
private _color_end = [0.6,0.6,1,0.15];

// Get direction for speed array
private _direction = [0,0,0];
private _position = AGLToASL(_b modelToWorld[-0.5,_off,2]);

// Create the particle source local for the client
private _particle_source = "#particlesource" createVehicleLocal _position;
private _sound_source = "#particlesource" createVehicleLocal _position;
(_b getVariable"PF")pushBack _particle_source;
(_b getVariable"PF")pushBack _sound_source;

// Set position of particle source at the modules exact position
_particle_source setPosASL _position;

// Particle parameters
_particle_source setParticleParams
[
	// Particle shape
	"a3\data_f\cl_water.p3d",
	// Animation name
	"",
	// Particle type
	"Billboard",
	// Timer period
	1,
	// Life time
	_lifetime,
	// Position
	[0, 0, 0],
	// Move velocity
	[_direction#0, _direction#1, -0.1],
	// Rotation Velocity
	0,
	// Weight
	5,
	// Volume
	1,
	// Rubbing
	0,
	// Size
	[
		// Start
		_size,
		// End
		_size * _coeff
	],
	// Color
	[
		// Start
		_color_start,
		// End
		_color_end
	],
	// Animation speed
	[
		// Start
		1,
		// End
		1
	],
	// Random direction period
	0,
	// Random direction intensity
	0,
	// onTimer script
	"",
	// beforeDestroy script
	"",
	// Particle source
	_particle_source,
	// Angle
	0,
	// On surface
	false,
	// Bounce on surface
	0
];
_particle_source setParticleCircle
[
	// Radius
	0,
	// Velocity
	[0,0,0]
];
_particle_source setParticleRandom
[
	// Particle life time
	0,
	// Random start position
	[0.1, 0.1, 0.1],
	// Random move position
	[0, 0, 0],
	// Rotation velocity
	0,
	// Particle size
	0,
	// Particle color
	[0, 0, 0, 0.3],
	// Direction period
	0,
	// Random direction intensity
	0,
	// Particle angle
	0,
	// Bounce on surface
	0.1
];
_particle_source setDropInterval 0.02;

		[ _b , _dir , _position ] call _man;
		};
	_off = _off + 1;
	};
_off
}