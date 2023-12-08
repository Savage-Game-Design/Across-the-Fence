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

private _tree = _group getVariable "vgm_l_currentBehaviourTree";

if (isNil "_tree") exitWith {};

private _state = _group getVariable "vgm_l_btree_state";

private _stack = _state getOrDefault ["stack", [], true];
private _priorityInterruptStack = _state getOrDefault ["priorityInterruptStack", [], true];
private _currentInterruptStack = _state getOrDefault ["currentInterruptStack", [], true];
private _servicesStack = _state getOrDefault ["currentInterruptStack", [], true];

// No next node, but a status code that indicates where execution should go next.
// SUCCEEDED/FAILED goes to parent
// ABORTED keeps rolling up the stack
// RUNNING keeps same node for next tick
// CHILD [INDEX] runs the child at that index.
// Needs to depend on what the individual node is
// They're all going to execute slightly differently.
// ^ Also makes handling priority and interrupt nodes easy, as can check current node before next node.

// Aborted is... interesting. I'm not sure it makes sense for a node to choose to return aborted.
// It's more something done ONTO a node.

// TODO - Pull out into functions, and make them return the next function to call.

// (Re)start tree execution.

private _nextAction = "run root node";
private _nextActionParams = [];

if (count _stack == 0) then {
	_nextAction = "run root node";
};

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
};


private _fnc_enterNode = {
	params ["_node"];

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
        };
		case "selector": {
            _nextAction = "run child";
            _nextActionParams = [0];
        };
		case "decorator": {
			_executionResult = [_node, _nodeState] call (_node get "onEnter");
            switch (_executionResult # 0) do {
                case RESULT_FAILED;
                case RESULT_SUCCEEDED: {
                    _nextAction = "return to parent";
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
		};
		case "action": {
			_executionResult = [_node, _nodeState] call (_node get "onEnter");
            switch (_executionResult # 0) do {
                case RESULT_FAILED;
                case RESULT_SUCCEEDED: {
                    _nextAction= "return to parent";
                };
                case RESULT_RUNNING: {
                    _nextAction = "run current node";
                    _nextActionParams = [];
                };
            };
		};
	};

    [_nextAction, _nextActionParams]
};

private _fnc_returnToParent = {
    private _currentStackIndex = count _stack - 1;
    (_stack # _currentStackIndex) params ["_node", "_state"];
    (_stack # (_currentStackIndex - 1)) params ["_parentNode", "_parentState"];

    switch (_node get "type") do {
        case "sequence": {
            // Do nothing?
        };
        case "selector": {
            // Do nothing?
        };
        case "decorator": {
            // Fire exit handler
        };
        case "action": {
            // Fire exit handler
        };
    };

    switch (_parentNode get "type") do {
        case "sequence": {
            // Check result type, continue if possible
        };
        case "selector": {
            // Check result type, continue if possible
            // Add abort if needed
        };
        case "decorator": {
            // Call "onChileNodeFinished" to know what to do next.
        };
        case "action": {
            // Bad case, shouldn't happen
        };
    };


    // Maybe replace these with just a single stack frame?
    _stack deleteAt _currentStackIndex;
    _priorityInterruptStack deleteAt _currentStackIndex;
    _currentInterruptStack deleteAt _currentStackIndex;
    _servicesStack deleteAt _currentStackIndex;
};

// Try writing out ideal logic for when a new node is entered. I mean, you already have this, flesh it out more on the left.
