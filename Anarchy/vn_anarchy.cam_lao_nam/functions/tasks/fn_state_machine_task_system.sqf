/*
  Author: Spoffy

  Description:
	Task script for the 'state machine task system'.

	Less rigid than the 'Simple task System', but more rigid than writing a task yourself.
	Avoids the need to directly manage when subtasks are created and completed, and keep track of the current task state.

	Not a 'Finite State Machine', as it can be in several states simultaneously.

	Essentially:
		Uses 'stateMachineCode' to initialise the state machine, by adding several code blocks to a namespace/data store:
		- 'INIT' - Called once, when the state machine starts the first time.
		- '$subtask_id' - A code block for each subtask, that is run while that subtask is active
		- 'FINISH' - Called once, when the tasks completes, to clean up any resources used by the tasks, such as units/vehicles.

  Params:
	_taskDataStore - Data store for the top-level task using this script.

  Task Parameters:
    stateMachineCode - String that, when run, returns the code to initialise the state machine
	
	Any additional parameters needed by the state machine being run.

  Returns:
	None

  Example Usage:
	Shouldn't be called directly.
*/

params ["_taskDataStore"];

//Do nothing if we've terminated the state machine already.
if (_taskDataStore getVariable ["stateMachineFinished", false]) exitWith {
	false
};

//Deliberately writing this to error if there isn't a taskConfig.
private _taskConfig = _taskDataStore getVariable "taskConfig";
private _taskParameters = _taskConfig >> "parameters";

if (!isClass _taskParameters) exitWith {
	diag_log "Error: State machine task system given task with no parameters.";
	false
};

///////////////////////////////////////////////////////////////////////////
//These functions should NOT be called directly from within subtask code.//
///////////////////////////////////////////////////////////////////////////

//Ends a given subtask with the specified result, and removes it form the list of subtasks to run/
private _fnc_endSubtask = {
	params ["_subtaskId", "_result"];

	[_taskDataStore, _subtaskId, _result] call vn_mf_fnc_task_subtask_complete;

	private _currentStates = _taskDataStore getVariable "stateMachineCurrentStates";
	//Remove the current state from the list of states we're in.
	_currentStates deleteAt (_currentStates find _currentSubtaskId);
};

//Starts 1 or more new subtasks, creating the tasks in the task list and adding them to the state machine
private _fnc_startSubtasks = {
	params [["_newSubtasks", []]];

	private _currentStates = _taskDataStore getVariable "stateMachineCurrentStates";

	{
		_x params ["_newSubtaskId", ["_newSubtaskLocation", objNull]];
		[_taskDataStore, _newSubtaskId, _newSubtaskLocation] call vn_mf_fnc_task_subtask_create;
		_currentStates pushBack _newSubtaskId;
	} forEach _newSubtasks;
};

////////////////////////////////////////////////////////////////////
//These functions CAN be called directly from within subtask code.//
//They require these variables defined before they can be called: //
// _currentSubtaskId                                              //
// _subtasksToRun                                                 //
////////////////////////////////////////////////////////////////////

//Sets the initial subtasks to run.
//Should ONLY be called from the 'INIT' section of a state machine.
private _fnc_initialSubtasks = {
	params [["_initialSubtasks", []]];

	[_initialSubtasks] call _fnc_startSubtasks;
};

//Finishes the current subtask, and optionally starts 1 or more new subtasks.
private _fnc_finishSubtask = {
	params ["_result", ["_nextSubtasks", []]];

	[_currentSubtaskId, _result] call _fnc_endSubtask;
	[_nextSubtasks] call _fnc_startSubtasks;
};

//Finishes the task, terminating the state machine and calling the 'FINISH' section to perform cleanup.
private _fnc_finishTask = {
	params ["_result"];

	//Empty to the current states to make sure none of them continue running.
	_taskDataStore setVariable ["stateMachineFinished", true];
	_taskDataStore setVariable ["stateMachineResult", _result];
	[_taskDataStore] call (_taskDataStore getVariable ["FINISH", {}]);
	[_taskDataStore, _result] call vn_mf_fnc_task_complete;
};

/////////////////////////////////////////////////////////////////////
// State machine code - Initialising and running the state machine //
/////////////////////////////////////////////////////////////////////
 
//Initialise the state machine if it's not already initialised
if !(_taskDataStore getVariable ["stateMachineInitialised", false]) then {
	private _initCodeString = getText (_taskParameters >> "stateMachineCode");

	_taskDataStore setVariable ["stateMachineCurrentStates", []];
	
	//Initialise the FSM by calling the state machine code
	//This code should return the code we need to run to initialise the FSM.
	[_taskDataStore] call (call compile _initCodeString);
	[_taskDataStore] call (_taskDataStore getVariable "INIT");

	_taskDataStore setVariable ["stateMachineInitialised", true];
};

//Run all of the current subtasks/states;.
//Copy the array, so it isn't modified while we iterate over it.
//The copied array CAN be modified by the functions called in the state machine code.
private _subtasksToRun = +(_taskDataStore getVariable "stateMachineCurrentStates");
private _currentSubtaskPosition = 0;

//While loop allows us to push items onto 'subtasksToRun' if we want to.
while  {_currentSubtaskPosition < count _subtasksToRun} do 
{
	private _currentSubtaskId = _subtasksToRun select _currentSubtaskPosition;

	//run the code for the subtask
	[_taskDataStore] call (_taskDataStore getVariable [_currentSubtaskId, {}]);	

	//If running the code for the subtask has finished the state machine, stop running states.
	if (_taskDataStore getVariable ["stateMachineFinished", false]) exitWith {};

	//Move to the next state in the queue that we need to run.
	_currentSubtaskPosition = _currentSubtaskPosition + 1;
};