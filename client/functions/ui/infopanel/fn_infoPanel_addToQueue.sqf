/*
    File: fn_infoPanel_addToQueue.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Handles adding Data to the the Infopanel Array (handled in: para_c_fnc_infopanel_handler)
    
    Parameter(s):
	   _text - Text to show [STRING, defaults to "" (empty string)]
	   _img - path to Image file [STRING, defaults to "" (empty string)]
	   _quickShow - quick note, used for showing XP/RP gains - only Text input will be used! [BOOL, defaults to False]
    
    Returns: nothing
    
    Example(s):
		//using Text + Image
		["Vietnam Tet Campaign Commemorative Medal","\vn\ui_f_vietnam\data\medals\vn_medal_m_03_01.paa"] call para_c_fnc_infopanel_addToQueue;
		//using Text only
		["quick n short text, that lifes for 2s","",true] call para_c_fnc_infopanel_addToQueue;
*/

params[["_text","",[""]],["_img","",[""]],["_quickShow",false,[false]]];

if(_text isEqualTo "")exitWith{};	//no text -> Leave :angrypepe:

_listName = if(_quickShow)then	{ "para_infopanel_quick_tmpStorage" }	//quickshow - 0.5s, Text only (e.g. XP Notification)
else							{ "para_infopanel_tmpStorage" };		//normal - 4s - Text+Image

private _list = missionNameSpace getVariable [_listName,[]];

_list pushback [_text,_img];	//in case of unifying code and if it will be changed later -> "quickshow" also stores an _img placeholder Variable
missionNameSpace setVariable [_listName,_list];