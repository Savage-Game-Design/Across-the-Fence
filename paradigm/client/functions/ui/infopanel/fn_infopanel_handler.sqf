/*
    File: fn_infopanel_handler.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Handles the Animation and Info shown for the Infopanel, taken from the "para_infopanel_tmpStorage" Variable.
		called/added by the scheduler (via "para_g_fnc_scheduler_add_job" - Checkcycle: 1 sec)
    
    Parameter(s): none
    
    Returns: nothing
    
    Example(s):
		[] call para_c_fnc_infopanel_handler
		
*/

#include "..\..\..\configs\ui\ui_def_base.inc"


//Main Infopanel:
private _ctrl = PARA_INFOPANEL_MAIN_CTRL;
private _timer = _ctrl getVariable ["timer",diag_tickTime];

//Hide
if((_timer <= diag_tickTime) && (ctrlFade _ctrl == 0))then
{
	_ctrl ctrlsetFade 1;	//hide
	_ctrl ctrlCommit 0.2;
};

_list = missionNameSpace getVariable ["para_infopanel_tmpStorage",[]];
//Check if anything else needs to be shown
if !(_list isEqualTo [])then
{
	(_list#0) params[["_text","",[""]],["_img","",[""]]];
	
	//show
	//if hidden > show it
	if(ctrlFade _ctrl == 1)then
	{
		PARA_INFOPANEL_MAIN_TXT_CTRL ctrlSetStructuredText parseText _text;
		PARA_INFOPANEL_MAIN_IMG_CTRL ctrlSetText _img;
		
		//show
		_ctrl ctrlsetFade 0;
		_ctrl setVariable ["timer",(diag_tickTime+4)];
		_ctrl ctrlCommit 0.2;
		
		//delete the currently used entry
		_list deleteAt 0;
	};
};


//Quickshow
private _list_quick_prev = missionNameSpace getVariable ["para_infopanel_quick_ctrlIDCs",[]];
if !(_list_quick_prev isEqualTo []) then
{
	private _curCtrl = PARA_INFOPANEL_QUICK_CTRL((_list_quick_prev#0));
	if(ctrlCommitted _curCtrl)then
	{
		ctrlDelete _curCtrl;
		_list_quick_prev deleteAt 0;
	};
};

private _list_quick = missionNameSpace getVariable ["para_infopanel_quick_tmpStorage",[]];
if !(_list_quick isEqualTo [])then
{
	(_list_quick#0) params[["_text","",[""]],["_img","",[""]]];
	_list_quick deleteAt 0;
	
	private _idc_counter = missionNameSpace getVariable ["para_infopanel_quick_idc_counter",3000];
	_idc_counter = _idc_counter + 1;
	missionNameSpace setVariable ["para_infopanel_quick_idc_counter",_idc_counter];
	
	private _ctrl_quick_grp = PARA_DISP_INFOPANEL ctrlCreate ["para_infopanel_quick_base",_idc_counter];
	PARA_INFOPANEL_QUICK_TXT_CTRL(_idc_counter) ctrlSetStructuredText parseText _text;	//get txt ctrl and set the text
	_ctrl_quick_grp ctrlSetFade 1;
	_ctrl_quick_grp ctrlSetPositionY UIY_BU(0);	//move to outside (bottom)
	_ctrl_quick_grp ctrlCommit 2;
	
	//store used IDCs
	private _list_quick_IDCs = missionNameSpace getVariable ["para_infopanel_quick_ctrlIDCs",[]];
	_list_quick_IDCs pushback _idc_counter;
	missionNameSpace setVariable ["para_infopanel_quick_ctrlIDCs",_list_quick_IDCs];
};



