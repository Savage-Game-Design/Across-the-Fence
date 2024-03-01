#ifdef VGM_BEHAVIOUR_TREES_COMPILER
#else
#define VGM_BEHAVIOUR_TREES_COMPILER

#define SELECTOR vgm_g_fnc_btree_composite_selector
#define SEQUENCE vgm_g_fnc_btree_composite_sequence
#define CONDITION( NAME ) vgm_g_fnc_btree_condition_##NAME
#define ACTION( NAME ) vgm_g_fnc_btree_action_##NAME
#define DECORATOR( NAME ) vgm_g_fnc_btree_decorator_##NAME

#endif
