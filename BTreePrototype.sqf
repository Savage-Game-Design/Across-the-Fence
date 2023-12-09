// Setup tree

params ["_tree", "_group"];

private _currentTree = _group getVariable "vgm_l_btree_current";

if (!isNil "_currentTree" && { _currentTree isNotEqualTo _tree }) then {
	[_group] call vgm_g_fnc_btree_abortCurrentTree;
};

_group setVariable ["vgm_l_btree_current", _tree];
_group setVariable ["vgm_l_btree_state", createHashMap];


// Executing behaviour tree

#define RESULT_SUCCEEDED "succeeded"
#define RESULT_FAILED "failed"
#define RESULT_ABORTED "aborted"
#define RESULT_RUNNING "running"

params ["_group"];

private _actionLog = [];
private _messageLog = [];

private _tree = _group getVariable "vgm_l_currentBehaviourTree";

if (isNil "_tree") exitWith {};

private _state = _group getVariable "vgm_l_btree_state";

private _stack = _state getOrDefault ["stack", [], true];
private _priorityInterruptStack = _state getOrDefault ["priorityInterruptStack", [], true];
private _currentInterruptStack = _state getOrDefault ["currentInterruptStack", [], true];
private _servicesStack = _state getOrDefault ["currentInterruptStack", [], true];

// Each execution step effectively returns what the next execution step in the btree is.
//  E.g "return to parent", "keep running", "run child"

// Needs to depend on what the individual node is
// They're all going to execute slightly differently.
// ^ Also makes handling priority and interrupt nodes easy, as can check current node before next node.

// Aborted is... interesting. I'm not sure it makes sense for a node to choose to return aborted.
// It's more something done ONTO a node.

// TODO - Pull out into functions, and make them return the next function to call.
// TODO - Logic for aborting and service checks

// (Re)start tree execution.

private _nextAction = "run current node";
private _nextActionParams = [];

if (count _stack == 0) then {
	_nextAction = "run root node";
};

private _fnc_enterNode = {
	params ["_node"];

    _messageLog pushBack format ["Entering node: %1", _node getOrDefault ["name", ""]];

	private _nodeState = createHashMap;

	_stack pushBack [_node, _nodeState];

	private _nodeType = _node get "type";
	private _executionResult = [RESULT_RUNNING];
    private _nextAction = "";
    private _nextActionParams = [];

	switch (_nodeType) do {
		case "sequence": {
            _nextAction = "run child";
            _nextActionParams = [0];
            _nodeState set ["executingChild", 0];

            _messageLog pushBack format ["Entering sequence, next: %1 (%2)", _nextAction, _nextActionParams];
        };
		case "selector": {
            _nextAction = "run child";
            _nextActionParams = [0];
            _nodeState set ["executingChild", 0];

            _messageLog pushBack format ["Entering selector, next: %1 (%2)", _nextAction, _nextActionParams];
        };
		case "decorator": {
			_executionResult = [_node, _nodeState] call (_node get "onEnter");
            switch (_executionResult # 0) do {
                case RESULT_FAILED;
                case RESULT_SUCCEEDED: {
                    _nextAction = "return to parent";
                    _nextActionParams = [_executionResult # 0];
                };
                case RESULT_RUNNING: {
                    // TODO: Add abort if needed
                    // TODO: Services stack
                    _nextAction = "run child";
                    _nextActionParams = [0];
                };
                // Can't be aborted.
                // NEED DOCS
            };

            _messageLog pushBack format ["Entering decorator, next: %1 (%2)", _nextAction, _nextActionParams];
		};
		case "action": {
			_executionResult = [_node, _nodeState] call (_node get "onEnter");
            switch (_executionResult # 0) do {
                case RESULT_FAILED;
                case RESULT_SUCCEEDED: {
                    _nextAction= "return to parent";
                    _nextActionParams = [_executionResult # 0];
                };
                case RESULT_RUNNING: {
                    _nextAction = "run current node";
                    _nextActionParams = [];
                };
            };

            _messageLog pushBack format ["Entering action, next: %1 (%2)", _nextAction, _nextActionParams];
		};
	};

    [_nextAction, _nextActionParams]
};

private _fnc_runCurrentNode = {
    private _currentStackIndex = count _stack - 1;
    (_stack # _currentStackIndex) params ["_node", "_state"];

    _messageLog pushBack format ["Running current node: %1", _node getOrDefault ["name", ""]];

    private _nextAction = "";
    private _nextActionParams = [];

    switch (_node get "type") do {
        case "sequence": {
            // Do nothing - bad case, shouldn't happen.
        };
        case "selector": {
            // Do nothing - bad case, shouldn't happen.
        };
        case "decorator": {
            // Do nothing - bad case, shouldn't happen.
        };
        case "action": {
            private _result = [_state] call (_node get "onTick");
            switch (_result # 0) do {
                case RESULT_RUNNING: {
                    // No further action until next tick.
                    _nextAction = "";
                    _nextActionParams = [];
                };
                default {
                    _nextAction = "return to parent";
                    _nextActionParams = [_result # 0];
                };
            };
        };
    };

    [_nextAction, _nextActionParams];
};

private _fnc_returnToParent = {
    params ["_result"];
    private _currentStackIndex = count _stack - 1;
    (_stack # _currentStackIndex) params ["_node", "_state"];

    _messageLog pushBack format ["Returning from %1 - result %2", _node getOrDefault ["name", ""], _result];

    private _nextAction = "";
    private _nextActionParams = [];

    switch (_node get "type") do {
        case "sequence": {
            // Do nothing
            _messageLog pushBack "Trying to return from sequence!";
        };
        case "selector": {
            // Do nothing
            _messageLog pushBack "Trying to return from selector!";
        };
        case "decorator": {
            _messageLog pushBack "Calling exit handler for decorator";
            [_state, _result] call (_node get "onExit");
        };
        case "action": {
            _messageLog pushBack "Calling exit handler for action";
            [_state, _result] call (_node get "onExit");
        };
    };

    // Maybe replace these with just a single stack frame?
    _stack deleteAt _currentStackIndex;
    _priorityInterruptStack deleteAt _currentStackIndex;
    _currentInterruptStack deleteAt _currentStackIndex;
    _servicesStack deleteAt _currentStackIndex;

    if (count _stack == 0) exitWith {
        _messageLog pushBack "Ending execution, returning from root node";
        _nextAction = "";
        _nextActionParams = [];
        // Hit the root node, finished execution. Wait for next tick.
    };

    (_stack # (_currentStackIndex - 1)) params ["_parentNode", "_parentState"];

    switch (_parentNode get "type") do {
        case "sequence": {
            _nextAction = "return to parent";
            _nextActionParams = [_result];

            if (_result isEqualTo RESULT_SUCCEEDED) then {
                private _lastExecutedChild = _parentState get "executingChild";
                if (_lastExecutedChild < count (_parentNode get "children")) then {
                    _nextAction = "run child";
                    _nextActionParams = [_lastExecutedChild + 1];
                };
            };

            _messageLog pushBack format ["Returned to sequence, next: %1 (%2)", _nextAction, _nextActionParams];
        };
        case "selector": {
            _nextAction = "return to parent";
            _nextActionParams = [_result];

            if (_result isEqualTo RESULT_FAILED) then {
                private _lastExecutedChild = _parentState get "executingChild";
                if (_lastExecutedChild < count (_parentNode get "children")) then {
                    _nextAction = "run child";
                    _nextActionParams = [_lastExecutedChild + 1];
                };
                // TODO - Add abort
            };

            _messageLog pushBack format ["Returned to selector, next: %1 (%2)", _nextAction, _nextActionParams];
        };
        case "decorator": {
            _messageLog pushBack "Returned to decorator, checking onChildFinished";
            private _parentResult = [_parentState, _result] call (_parentNode get "onChildFinished");

            _nextAction = "return to parent";
            _nextActionParams = [_parentResult];

            if (_parentResult isEqualTo RESULT_RUNNING) then {
                _nextAction = "run child";
                _nextActionParams = [0];
            };

            _messageLog pushBack format ["Returned to decorator, next: %1 (%2)", _nextAction, _nextActionParams];
        };
        case "action": {
            // Bad case, shouldn't happen
            _messageLog pushBack "Returned to action - ERROR";
        };
    };

    [_nextAction, _nextActionParams]
};

while {_nextAction isNotEqualTo ""} do {
    _actionLog pushBack [_nextAction, _nextActionParams];
    switch (_nextAction) do {
        case "run root node": {
            private _result = [_tree get "root"] call _fnc_enterNode;
            _nextAction = _result # 0;
            _nextActionParams = _result # 1;
        };
        case "run child": {
            _nextActionParams params ["_childIndex"];
            // Possible bug if stack is empty here
            private _result = [_stack select (count _stack - 1)] call _fnc_enterNode;
            _nextAction = _result # 0;
            _nextActionParams = _result # 1;
        };
        case "return to parent": {
            private _result = _nextActionParams call _fnc_returnToParent;
            _nextAction = _result # 0;
            _nextActionParams = _result # 1;
        };
        case "run current node": {
            private _result = [] call _fnc_runCurrentNode;
            _nextAction = _result # 0;
            _nextActionParams = _result # 1;
        };
    };
};

[_actionLog, _messageLog]



// Try writing out ideal logic for when a new node is entered. I mean, you already have this, flesh it out more on the left.
