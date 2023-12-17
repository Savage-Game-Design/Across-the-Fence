tree =createHashMapFromArray [
	["type", "sequence"],
	["name", "testsequence"],
	["children", [
		createHashMapFromArray [
			["type", "action"],
			["name", "testaction1"],
			["onEnter", { ["running"] }],
			["onTick", { ["succeeded"] }],
			["onExit", {}]
		],
		createHashMapFromArray [
			["type", "selector"],
			["name", "testselector"],
			["children", [
				createHashMapFromArray [
					["type", "decorator"],
					["name", "testdecorator"],
					["condition", {!isNil "treepass"}],
					["onEnter", {["running"]}],
					["abortLowerPriority", true],
					["onChildFinished", { _this # 2 }],
					["onExit", {}],
					["children", [
						createHashMapFromArray [
							["type", "action"],
							["name", "testaction4"],
							["onEnter", { ["running"] }],
							["onTick", { ["succeeded"] }],
							["onExit", {}]
						]
					]]
				],
				createHashMapFromArray [
					["type", "action"],
					["name", "testaction3"],
					["onEnter", { ["running"] }],
					["onTick", { ["running"] }],
					["onExit", {}]
				]
			]]
		],
		createHashMapFromArray [
			["type", "decorator"],
			["name", "testdecorator"],
			["onEnter", { ["failed"] }],
			["onChildFinished", { _this }],
			["onExit", {}],
			["children", [
				createHashMapFromArray [
					["type", "action"],
					["name", "testaction4"],
					["onEnter", { ["running"] }],
					["onTick", { ["succeeded"] }],
					["onExit", {}]
				]
			]]
		],
		createHashMapFromArray [
			["type", "action"],
			["name", "testaction5"],
			["onEnter", { ["running"] }],
			["onTick", { ["succeeded"] }],
			["onExit", {}]
		]
	]]
]


// Setup tree

params ["_group"];

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

private _tree = _group getVariable "vgm_l_btree_current";

if (isNil "_tree") exitWith {};

private _state = _group getVariable "vgm_l_btree_state";

private _stack = _state getOrDefault ["stack", [], true];

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

	private _stackItem = (createHashMapFromArray [
        ["node", _node],
        ["state", _nodeState],
        ["higherPriorityNodes", []],
        ["interruptNode", false],
        ["serviceNode", false]
    ]);

    _stack pushBack _stackItem;

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
			private _conditionResult = [_node] call (_node get "condition");
            if (!_conditionResult) exitWith {
                _nextAction = "return to parent";
                _nextActionParams = [RESULT_FAILED]
            };
            _executionResult = [_node] call (_node get "onEnter");
            switch (_executionResult # 0) do {
                case RESULT_FAILED;
                case RESULT_SUCCEEDED: {
                    _nextAction = "return to parent";
                    _nextActionParams = [_executionResult # 0];
                };
                case RESULT_RUNNING: {
                    _stackitem set ["interruptNode", _node get "abortChildrenOnConditionFailure"];
                    _stackitem set ["serviceNode", _node get "isService"];
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
    private _currentStackItem = (_stack # _currentStackIndex);
    private _node = _currentStackItem get "node";
    private _state = _currentStackItem get "state";

    _messageLog pushBack format ["Running current node: %1", _node getOrDefault ["name", ""]];

    private _nextAction = "";
    private _nextActionParams = [];

    switch (_node get "type") do {
        case "sequence": {
            // Do nothing - bad case, shouldn't happen. Reset tree if it does.
            // TODO - Log and return to parent, as it shouldn't happen.
        };
        case "selector": {
            // Do nothing - bad case, shouldn't happen. Reset tree if it does.
            // TODO - Log and return to parent, shouldn't happen.
        };
        case "decorator": {
            // Do nothing - bad case, shouldn't happen. Reset tree if it does.
            // TODO - Log and return to parent, shouldn't happen.
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
    private _currentStackItem = (_stack # _currentStackIndex);
    private _node = _currentStackItem get "node";
    private _state = _currentStackItem get "state";

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
            [_node, _state, _result] call (_node get "onExit");
        };
        case "action": {
            _messageLog pushBack "Calling exit handler for action";
            [_node, _state, _result] call (_node get "onExit");
        };
    };

    _stack deleteAt _currentStackIndex;

    if (count _stack == 0) exitWith {
        _messageLog pushBack "Ending execution, returning from root node";
        _nextAction = "";
        _nextActionParams = [];
        // Hit the root node, finished execution. Wait for next tick.
    };

    private _parentStackItem = (_stack # (_currentStackIndex - 1));
    private _parentNode = _parentStackItem get "node";
    private _parentState = _parentStackItem get "state";

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
                private _children = _parentNode get "children";
                if (_lastExecutedChild < count _children) then {
                    if (_children # _lastExecutedChild get "abortLowerPriority") then {
                        _parentStackItem get "higherPriorityNodes" pushBackUnique _lastExecutedChild;
                    };
                    _nextAction = "run child";
                    _nextActionParams = [_lastExecutedChild + 1];
                };
                // TODO - Add abort
            };

            _messageLog pushBack format ["Returned to selector, next: %1 (%2)", _nextAction, _nextActionParams];
        };
        case "decorator": {
            _messageLog pushBack "Returned to decorator, checking onChildFinished";
            private _parentResult = [_parentNode, _parentState, _result] call (_parentNode get "onChildFinished");

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

private _fnc_abortUntilStackIndex = {
    params ["_index"];

    private _currentStackIndex = count _stack - 1;

    while {_currentStackIndex > _index} do {
        private _currentStackItem = (_stack # _currentStackIndex);
        private _node = _currentStackItem get "node";
        private _state = _currentStackItem get "state";

        _messageLog pushBack format ["Aborting %1 at stack position %2", _node getOrDefault ["name", ""], _currentStackIndex];

        switch (_node get "type") do {
            case "sequence": {
                // Do nothing
            };
            case "selector": {
                // Do nothing
            };
            case "decorator": {
                _messageLog pushBack "Aborting decorator.";
                [_node, _state, RESULT_ABORTED] call (_parentNode get "onChildFinished");
                [_node, _state, RESULT_ABORTED] call (_parentNode get "onExit");

            };
            case "action": {
                _messageLog pushBack "Aborting action.";
                [_node, _state, RESULT_ABORTED] call (_node get "onExit");
            };
        };

        _stack deleteAt _currentStackIndex;

        _currentStackIndex = _currentStackIndex - 1;
    };
};

{
    private _item = _x;
    if (_item get "interruptNode" && {[_item get "node", _item get "state"] call (_item get "condition") isEqualTo RESULT_FAILED} ) exitWith {
        [_forEachIndex] call _fnc_abortUntilStackIndex;
        _nextAction = "return to parent";
        _nextActionParams = [RESULT_FAILED];
    };

    // TODO - Service nodes

    private _newChildToRunIndex = _item getOrDefault ["higherPriorityNodes", []] findIf {
        private _child = _item get "node" get "children" select _x;
        [_child get "node"] call (_child get "condition")
    };

    if (_newChildToRunIndex > -1) exitWith {
        [_forEachIndex] call _fnc_abortUntilStackIndex;
        _nextAction = "run child";
        _nextActionParams = _item get "higherPriorityNodes" select _newChildToRunIndex;
    };
} forEach _stack;

while {_nextAction isNotEqualTo ""} do {
    _actionLog pushBack [_nextAction, _nextActionParams];
    switch (_nextAction) do {
        case "run root node": {
            private _result = [_tree] call _fnc_enterNode;
            _nextAction = _result # 0;
            _nextActionParams = _result # 1;
        };
		case "run child": {
			_nextActionParams params ["_childIndex"];
			// Possible bug if stack is empty here
			private _stackItem = (_stack # (count _stack - 1));
			private _node = _stackItem get "node";
			private _child = _node get "children" select _childIndex;
			_stackItem get "state" set ["executingChild", _childIndex];
			private _result = [_child] call _fnc_enterNode;
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
