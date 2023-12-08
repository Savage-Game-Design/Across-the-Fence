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
#define RESULT_RUN_CHILD "run child"

params ["_group"];

private _tree = _group getVariable "vgm_l_currentBehaviourTree";

if (isNil "_tree") exitWith {};

private _state = _group getVariable "vgm_l_btree_state";

private _stack = _state getOrDefault ["stack", [], true];
private _priorityInterruptStack = _state getOrDefault ["priorityInterruptStack", [], true];

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

// (Re)start tree execution.

private _nextAction = "run root node";
private _nextActionParams = [];

if (count _stack == 0) then {
	_nextAction = "run root node";
};

switch (_nextAction) do {
	case "run root node": {
		private _result = [_tree get "root"] call _fnc_enterNode;
		// Pull out into a function?
		switch (_result # 0) do {
			case RESULT_ABORTED: {};
			case RESULT_FAILED: {
				_nextAction = "return to parent";
			};
			case RESULT_SUCCEEDED: {
				_nextAction = "return to parent";
			};
			case RESULT_RUNNING: {
				_nextAction = "run current node";
			};
			case RESULT_RUN_CHILD: {
				_nextAction = "run child";
				_nextActionParams = [_result # 1];
			};
		};
	};
	case "run child": {
		_nextActionParams params ["_childIndex"];

	};
};


private _fnc_enterNode = {
	params ["_node"];

	private _nodeState = createHashMap;

	_stack pushBack [_node, _nodeState];

	private _nodeType = _node get "type";
	private _executionResult = [RESULT_RUNNING];

	switch (_nodeType) do {
		case "sequence": {};
		case "selector": {};
		// Decorators need to have control over their children. How do I do that? They need to decide when to execute.
		case "decorator": {
			_executionResult = [_node, _nodeState] call (_node get "onEnter");
		};
		// Are conditions a special case of decorators? Or does it makes sense for them to be an optimisation?
		case "condition": {
			_executionResult = [_node, _nodeState] call (_node get "condition");
		};
		case "action": {
			_executionResult = [_node, _nodeState] call (_node get "onEnter");
		};
	};


	_executionResult
};


// Maybe need a func here to handle the execution result, and modify the state of this runner accordingly?

// Try writing out ideal logic for when a new node is entered. I mean, you already have this, flesh it out more on the left.

// Needs to potentially result in the child nodes being scheduled too.
// They need to be able to start execution of new nodes! Decorators is the big one, but composites too.
// Maybe this is easier if we don't special case it? Have a more generic API approach?