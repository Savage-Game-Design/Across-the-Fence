/*
    File: fn_event_testSystem.sqf
    Author:
    Date: 2022-12-09
    Last Update: 2022-12-24
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

para_s_event_testRunning = true;
para_s_event_clientHealthInfo = createHashMap;

para_l_event_testResults = createHashMapFromArray [["PASSED", []], ["FAILED", []]];
private _testClient = getUserInfo selectRandom allUsers;
private _clientOwner = _testClient # 1;

[[], { para_l_event_test_data = createHashMap; }] remoteExec ["call", [_clientOwner, 2]];

private _fnc_saveTestResult = {
    params ["_data", "_savedParameters", "_eventName", "_topic", "_originMachineId"];
    private _testName = _savedParameters;
    para_l_event_test_data getOrDefault [_testName, [], true] pushBack _this;
};

[
    [_fnc_saveTestResult],
    {
        params ["_fnc_saveTestResult"];
        // Test global listening
        [
            [0],
            "onTestGlobal",
            ["test global listen", _fnc_saveTestResult]
        ] call para_g_fnc_event_subscribe;
        // Test machine-specific listening
        [
            [2],
            "onTestServer",
            ["test machine specific listen", _fnc_saveTestResult]
        ] call para_g_fnc_event_subscribe;
        // Test local listening
        [
            "onTestLocal",
            ["test local listen", _fnc_saveTestResult]
        ] call para_g_fnc_event_subscribeLocal;
        // Test topic filtering
        [
            [2],
            ["onTestTopic", "fish"],
            ["test topic filtering", _fnc_saveTestResult]
        ] call para_g_fnc_event_subscribe;
        // Test listening to a event without providing a topic includes all topics
        [
            [2],
            "onTestTopic",
            ["test topicless listen", _fnc_saveTestResult]
        ] call para_g_fnc_event_subscribe;
        // Test unsubscribing
        para_c_event_testUnsubscribeHandler = [
            [0],
            "onTestUnsubscribe",
            ["test unsubscribe from global event", _fnc_saveTestResult]
        ] call para_g_fnc_event_subscribe;
    }
] remoteExec ["call", _clientOwner];

[
    [0],
    "onTestGlobal",
    ["test global listen on server", _fnc_saveTestResult]
] call para_g_fnc_event_subscribe;

// Give plenty of time for the network calls to finish.
uiSleep 5;

// Fire test events from server
["onTestGlobal", "Global test server data"] call para_g_fnc_event_trigger;
["onTestServer", "Server test server data"] call para_g_fnc_event_trigger;
["onTestLocal", "Local test server data"] call para_g_fnc_event_trigger;
[["onTestTopic", "fish"], "Fish topic test server data"] call para_g_fnc_event_trigger;
[["onTestTopic", "goose"], "Goose topic test server data"] call para_g_fnc_event_trigger;
[["onTestTopic", 3], "Goose topic test server data"] call para_g_fnc_event_trigger;
["onTestUnsubscribe", "Unsubscribe test server data pre unsubscribe"] call para_g_fnc_event_trigger;

// Fire test events from client

[
    [],
    {
        ["onTestGlobal", "Global test client data"] call para_g_fnc_event_trigger;
        ["onTestServer", "Server test client data"] call para_g_fnc_event_trigger;
        ["onTestLocal", "Local test client data"] call para_g_fnc_event_trigger;
    }
] remoteExec ["call", _clientOwner];

// Wait for all events to fire and settle down.
uiSleep 5;

[
    [],
    {
        [para_c_event_testUnsubscribeHandler] call para_g_fnc_event_unsubscribe;
    }
] remoteExec ["call", _clientOwner];

// Wait for client to be unsubscribed
uiSleep 2;

[
    [],
    {
        ["onTestUnsubscribe", "Unsubscribe test client data post unsubscribe"] call para_g_fnc_event_trigger;
    }
] remoteExec ["call", _clientOwner];

["onTestUnsubscribe", "Unsubscribe test server data post unsubscribe"] call para_g_fnc_event_trigger;

// Wait for everything to resolve
uiSleep 5;

// Send test results from client to server
[
    [],
    {
        // Abuse the client health check function to avoid having extremely similar report test functions.
        [para_l_event_test_data] remoteExec ["para_s_fnc_event_reportClientHealth", 2];
    }
] remoteExec ["call", _clientOwner];

// Wait for client to report health data
uiSleep 3;

// Validate test results
private _clientTestData = para_s_event_clientHealthInfo get _clientOwner;
private _serverTestData = para_l_event_test_data;

private _fnc_matchEvent = {
    params [["_testData", []], "_expectedEventName", "_expectedEventTopic", "_expectedOrigin", "_expectedCount"];

    private _total = {
        _x params ["_data", "_savedParameters", "_eventName", "_topic", "_originMachineId"];

        (isNil "_expectedEventName" || { _eventName isEqualTo _expectedEventName })
        && (isNil "_expectedEventTopic" || { _topic isEqualTo _expectedEventTopic })
        && (isNil "_expectedOrigin" || { _originMachineId isEqualTo _expectedOrigin })
    } count _testData;

    if (isNil "_expectedCount") exitWith {
        _total > 0
    };

    _total isEqualTo _expectedCount
};

private _fnc_expect = {
    params ["_testName", "_pass"];

    if (_pass) exitWith {
        para_l_event_testResults get "PASSED" pushBack _testName;
    };

    para_l_event_testResults get "FAILED" pushBack _testName;
};

[
    "the client receives global events",
    [
        _clientTestData getOrDefault ["test global listen", []],
        "onTestGlobal",
        nil,
        2,
        [1, 2] select (_clientOwner isEqualto 2)
    ] call _fnc_matchEvent
    &&
    [
        _clientTestData getOrDefault ["test global listen", []],
        "onTestGlobal",
        nil,
        _clientOwner,
        [1, 2] select (_clientOwner isEqualto 2)
    ] call _fnc_matchEvent
] call _fnc_expect;

[
    "the client receives specific machine events",
    [
        _clientTestData getOrDefault ["test machine specific listen", []],
        "onTestServer",
        nil,
        2,
        [1, 2] select (_clientOwner isEqualto 2)
    ] call _fnc_matchEvent
] call _fnc_expect;

[
    "the client receives local events",
    [
        _clientTestData getOrDefault ["test local listen", []],
        "onTestLocal",
        nil,
        _clientOwner,
        [1, 2] select (_clientOwner isEqualto 2)
    ] call _fnc_matchEvent
] call _fnc_expect;

[
    "the client receives events that match the topic",
    [
        _clientTestData getOrDefault ["test topic filtering", []],
        "onTestTopic",
        "fish",
        2,
        1
    ] call _fnc_matchEvent
] call _fnc_expect;

[
    "the client receives all topics if subscribed to the event",
    [
        _clientTestData getOrDefault ["test topicless listen", []],
        "onTestTopic",
        "fish",
        2,
        1
    ] call _fnc_matchEvent
    &&
    [
        _clientTestData getOrDefault ["test topicless listen", []],
        "onTestTopic",
        "goose",
        2,
        1
    ] call _fnc_matchEvent
    &&
    [
        _clientTestData getOrDefault ["test topicless listen", []],
        "onTestTopic",
        3,
        2,
        1
    ] call _fnc_matchEvent
] call _fnc_expect;

[
    "the server receives global events",
    [
        _serverTestData getOrDefault ["test global listen on server", []],
        "onTestGlobal",
        nil,
        2,
        [1, 2] select (_clientOwner isEqualto 2)
    ] call _fnc_matchEvent
    &&
    [
        _serverTestData getOrDefault ["test global listen on server", []],
        "onTestGlobal",
        nil,
        _clientOwner,
        [1, 2] select (_clientOwner isEqualto 2)
    ] call _fnc_matchEvent
] call _fnc_expect;

[
    "events can be unsubscribed successfully",
    [
        _clientTestData getOrDefault ["test unsubscribe from global event", []],
        "onTestUnsubscribe",
        nil,
        2,
        // Should be 3 calls if the unsubscribe fails
        1
    ] call _fnc_matchEvent
] call _fnc_expect;

["Event system test completed"] remoteExec ["hint", 0];
para_s_event_testRunning = false;
