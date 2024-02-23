/*
    File: fn_locEvents_onNearbyEvent.sqf
    Author:
    Date: 2024-02-16
    Last Update: 2024-02-16
    Public: No

    Description:
        Register a handler to be called if an event of one of the specified types occurs near to a location.

        The range is determined by the event itself.

        The location can be an object, group or position 2D.

        This function can be called in the preInit phase.

    Parameter(s):
        _perceptionGroup - Which perception group to listen to? [STRING]
    	_listener - The unit, group or position listening. A listener of nil or "" listens to all events. [ARRAY]
        _types - One or more types of sound to listen for [ARRAY]
        _arguments - Arguments for the listener [ARRAY]
        _handler - Code called when a sound is emitted nearby [CODE]

    Returns:
        Handler IDs to be used for removal [ARRAY]

    Example(s):
        ["mission1", group _enemy, ["gunshots"], [_enemy], { }] call vgm_g_fnc_perception_listenForSound;
 */

params ["_perceptionGroup", ["_listener", ""], "_types", "_arguments", "_handler"];

private _locEventsData = localNamespace getVariable "vgm_l_locEvents_data";

if (isNil "_locEventsData") then {
    _locEventsData = [] call vgm_g_fnc_locEvents_preInit;
};

private _listenerEventTypes = _locEventsData get "listenerEventTypes";
private _perceptionGroups = _locEventsData get "perceptionGroups";

private _groupDetails = _perceptionGroups getOrDefaultCall [
    _perceptionGroup,
    { createHashMapFromArray [["listenersByType", createHashMap]] },
    true
];

private _listenerHash = hashValue _listener;
private _listenersByType = _groupDetails get "listenersByType";

if !(_listenerHash in _listenerEventTypes) then {
    _listenerEventTypes set [_listenerHash, createHashMap];

    // Make sure to clean up if we've got an object or group listening.
    if (_listener isEqualTypeAny [objNull, grpNull]) then {
        _listener addEventHandler ["Deleted", {
            params ["_thing"];
            [_thing] call vgm_g_fnc_locEvents_removeListener;
        }];
    };
};


private _handlerIndexes = _types apply {
    private _type = _x;


    private _typeListeners = _listenersByType getOrDefaultCall [
        _type,
        {
            createHashMapFromArray [
                ["allListeners", []],
                ["listenerHandlers", createHashMap]
            ]
        },
        true
    ];

    _typeListeners get "allListeners" pushBackUnique _listener;

    private _listenerHandlers = _typeListeners get "listenerHandlers" getOrDefaultCall [
        _listenerHash,
        {
            createHashMapFromArray [
                ["listener", _listener],
                ["counter", 0],
                ["handlers", createHashMap]
            ]
        },
        true
    ];

    // Store handlers in a hashmap instead of array, so we don't leave gaps when handlers are deleted.
    private _handlerCount = _listenerHandlers get "counter";
    _listenerHandlers set ["counter", _handlerCount + 1];
    _listenerHandlers get "handlers" set [_handlerCount, [_arguments, _handler]];

    // Record the perception group and type, so we can easily clean up if the listener is removed..
    _listenerEventTypes get _listenerHash set [[_perceptionGroup, _type], true];

    [
        _type,
        _handlerCount
    ]
};

[
    _perceptionGroup,
    _listenerHash,
    _handlerIndexes
]
