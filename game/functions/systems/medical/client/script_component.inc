
// #define DEBUG

#define TYPE_UNIFORM 801

#define BODY_PART_HEAD "head"
#define BODY_PART_ARMS "arms"
#define BODY_PART_TORSO "torso"
#define BODY_PART_LEGS "legs"
#define BODY_PARTS_ARR [BODY_PART_HEAD, BODY_PART_ARMS, BODY_PART_TORSO, BODY_PART_LEGS]

#define WOUND_NONE 0
#define WOUND_MINOR 1
#define WOUND_MAJOR 2
#define WOUND_SEVERE 3
#define WOUND_MAX WOUND_SEVERE

#define WOUNDS_BLEED_THRESHOLD 3

#define BLEED_OUT_TIME 60

#define HEAL_MEDIKIT "medikit"
#define HEAL_FAK "fak"

// debuffs
#define DEBUFF_STAMINA_MINOR 0.1
#define DEBUFF_STAMINA_MAJOR 0.25

#define DEBUFF_RECOIL_MINOR 0.5
#define DEBUFF_RECOIL_MAJOR 1

#define DEBUFF_AIM_MINOR 0.5
#define DEBUFF_AIM_MAJOR 1

#define DEBUFF_THROW_MINOR -0.4
#define DEBUFF_THROW_MAJOR -0.6

#define DEBUFF_INTERACT_MINOR 0.25
#define DEBUFF_INTERACT_MAJOR 0.5

#define DEBUFF_BLURRYVISION_MINOR 0.35
#define DEBUFF_BLURRYVISION_MAJOR 1

// frequent hits to the same hitpoint more often than this value will be ignored
#define MAX_HIT_FREQ 0.75

// disable scrollwheel menu action to heal self
#define MEDICAL_NO_SELF_HEAL_ACTION
