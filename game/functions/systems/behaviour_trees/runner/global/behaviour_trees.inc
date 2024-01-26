#ifdef VGM_BEHAVIOUR_TREES
#else

#define VGM_BEHAVIOUR_TREES

#define RESULT_SUCCEEDED "succeeded"
#define RESULT_FAILED "failed"
#define RESULT_ABORTED "aborted"
#define RESULT_RUNNING "running"

#define NODE_TYPE_DECORATOR "decorator"
#define NODE_TYPE_SEQUENCE "sequence"
#define NODE_TYPE_SELECTOR "selector"
#define NODE_TYPE_ACTION "action"

#define ACTION_RUN_CHILD vgm_g_fnc_btree_runChild
#define ACTION_ENTER_NODE vgm_g_fnc_btree_enterNode
#define ACTION_RETURN_TO_PARENT vgm_g_fnc_btree_returnToParent
#define ACTION_RUN_CURRENT_NODE vgm_g_fnc_btree_runCurrentNode
#define ACTION_PANIC vgm_g_fnc_btree_panic

#define NO_NEXT_ACTION [[], {}]

#endif
