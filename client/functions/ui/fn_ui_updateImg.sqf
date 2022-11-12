/*
    File: fn_ui_updateImg.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Updates a control's image.
    
    Parameter(s):
		_mode - 0 = normale Texture | 1 = alternative Texture [Number]
		_ctrl - Control [Control, defaults to controlNull]
    
    Returns: nothing
    
    Example(s): none
*/

params	[
			["_mode", 0, [0]],		//0 = normale Texture | 1 = alternative Texture
			["_ctrl",controlNull,[controlNull]]
		];

private _ctrlList = [];
//store className of ctrl. Needed to check it later with "configFile"
private _ctrlCN = (ctrlClassName _ctrl);
_ctrlList pushback _ctrlCN;

//get the first parent of the ctrl and it's className (that's where we start cycling through later)
private _ctrlParent = (ctrlParentControlsGroup _ctrl);
private _ctrlParentCN = ctrlClassName _ctrlParent;
//try to get the IDD (ID Display)
private _ctrlDisplayCN = ((ctrlParent _ctrl) getVariable ["BIS_fnc_initDisplay_configClass", ""]);

/*
Since we need the className of the IDD -> It must be initialized properly!
Config Entry example:
////////////////////
class someStupidNameForMyDisplay
{
	name = "MyShinyDisplayNameWoot";	//<---look below me
	onLoad = "	[""onLoad"",_this,		""MyShinyDisplayNameWoot"",''] call (uinamespace getvariable 'BIS_fnc_initDisplay');";	//<-------
	onUnload = "[""onUnload"",_this,	""MyShinyDisplayNameWoot"",''] call (uinamespace getvariable 'BIS_fnc_initDisplay');";	//<-------
////////////////////
... and the rest. So if there is no Display properly initialized -> Screw it, let's get outta here man!
*/
if(_ctrlDisplayCN isEqualTo "")exitWith{systemchat "ERROR: UpdateImg: No variable for the Display found (check if 'BIS_fnc_initDisplay' is properly executed at 'onLoad')"};

private _isSearching = true;

//cycle through the parents list, backwards... starting from ctrl back to the display (if there would be an easier way... -.-)
while{_isSearching}do
{
	//check if there is another parent, before the previous parent (parentception! Awesome! I like that (hint: not))
	if(_ctrlParentCN != "")then
	{
		//push it real good *sing* (store name, we need it later (i read that somewhere before... anyway, let us continue:))
		_ctrlList pushback _ctrlParentCN;
		private _toCheck = ctrlParentControlsGroup _ctrlParent;	//try to get the parentClass (ctrlgroup)
		_ctrlParentCN = ctrlClassName _toCheck;	//get the classname
		//make the new found parent to the one we will check again in the next cycle (have i mentioned parentception?!)
		_ctrlParent = _toCheck;
	}else{
		_isSearching = false;
	};
	//"mom, are we done yet?" - "idk, ask your dad (YOU! The coder who reads this mess i write here)"
	_isSearching;
};
//Since it's a pain the in the blackhole to build the string properly -> Let's reverse it. (reminder: We started from ctrl, moved backwards to the display, otherway around is the way to build the configFile check)
reverse _ctrlList;
//yeah, much better.

//"Do you remember what i wrote about reversing the list? Here is the reason why:" (clickbait, wow... this is getting lower and lower)
private _configPath = "";
{
	_configPath = format["%1 >> ""controls"" >> %2", _configPath, str(_x)];
}forEach _ctrlList;

//Up, and Down, Up, and Down (you might not know/remember it... Vengaboys, back in the early 2000)
private _UpDown = if(_mode == 1)then{"textUp"}else{"text"};	//wich one do we want? normal texture or the other one?

//Since Arma can use multiple "configFiles" -> We have to check them both, otherwise guys who added this ctrl in a mission (not addon.pbo) wouldn't be able to use it.
private _mainPath = format[">> %1 %2 >> %3);",str(_ctrlDisplayCN), _configPath, str(_UpDown)];	//"build build"
private _configFilePath = format["getText(configFile %1",_mainPath];			//one for the addon.pb
private _mConfigFilePath = format["getText(missionConfigFile %1",_mainPath];	//and one for the mission

//get from configFile
private _texturePath = call compile _configFilePath;	//check the addon.pbo first (compile = makes a function of a string, pretty handy tho)
//if nothing found -> Check missionConfigFile
if(_texturePath isEqualTo "")then{_texturePath = call compile _mConfigFilePath;};	//if nothing was in the addon -> Check the MissionFile
//if you still haven't found anyting -> Check if created with "ctrlCreate" (oh my... why isn't there an easier way? *cry*)
if(_texturePath isEqualTo "")then
{
	private _texture_List = _ctrl getVariable ["texturePaths",[]];	//check if there is already a variable given, with the textures in it.
	//No Var? ... -.- ... okay, let's make a mess again and build it... (and get the other one)
	if(_texture_List isEqualTo [])then
	{
		//first of all, store the main texture
		_texture_List pushback (ctrlText _ctrl);
		//next one: Get the classname of the ctrls Parent (ctrlGroup)
		private _custom_ctrlParentCN = ctrlClassName(ctrlParentControlsGroup _ctrl);
		
		//now we check, if the parent is in the addon.pbo
		if( isClass(configFile >> _custom_ctrlParentCN) )exitWith
		{
			private _texture_up = getText(configFile >> _custom_ctrlParentCN >> "controls" >> _ctrlCN >> "textUp");	//same as above, get the entry from the configFile
			_texture_List pushback _texture_up;
			_ctrl setVariable ["texturePaths",_texture_List];
		};
		
		//if it is not in addon -> check the mission, maybe it's hidden in there
		if( isClass(missionConfigFile >> _custom_ctrlParentCN) )then
		{
			private _texture_up = getText(missionConfigFile >> _custom_ctrlParentCN >> "controls" >> _ctrlCN >> "textUp");	//same as above, get the entry from the missionConfigFile
			_texture_List pushback _texture_up;
			_ctrl setVariable ["texturePaths",_texture_List];
		};
	};
	//if nothing was found -> maybe no texture was giving at all? Could be, idk, possible, WHY ARE YOU USING THAT CTRL ANYWAY IF YOU DON'T WANT IT! Pff... go away.... pff...
	if(_texturePath isEqualTo [])then
	{
		_texturePath = "";	// empty string = "We exit at the end" aka "WHY DID YOU CHOOSE THIS CTRL?? IT MAKES NO SENSE!" GAWD! YOU WASTE RESSOURCES DUDE! ... -.-
	}else{
		//oh and if found (wow...) -> select wich one we wanted (0 = normal | 1 = up)
		_texturePath = _texture_List#_mode;
	};
};
//Look, "EXITWITH"... we did all the stuff before... for what? JUST TO EXIT RIGHT BEFORE THE END! BECAUSE YOU HAVEN'T GIVEN A SECOND TEXTURE! ("textUp" in the config)
if(_texturePath isEqualTo "")exitWith{};	//SHAME ON YOU! YEAH! Get in the corner behind you, sit there for 10minutes and think about what you did here!
_ctrl ctrlSetText _texturePath;	//erm, set the texture, we have chosen before? Maybe, possible, i think so, i guess this is it.

/*
We hope you had a wonderful Tour through this marvelous function. If you want to know more -> Not my problem. Go away, it's over! hush, go! Now! We are done here.




























































Still here? Holy Maccaroni... find some friends to bother! GO AWAY! YOUR MOMY LOVES YOU! NOW GO! Call her and tell her you love her! NAO! DO IT! DO IT!
*/