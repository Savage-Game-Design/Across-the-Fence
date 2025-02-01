#define MAX_DETECTION_DISTANCE 400

// This assumes the player is on west, and the enemy is east.
// Saves us frames using this, instead of checking in SQF.
#define ENEMY_SOLDIER_BASE_CLASS "SoldierEB"
#define ENEMY_SIDE east

// Double this for the full angle - this is angle of offset from the center
#define VISION_CONE_ANGLE 45
// At larger angles than this, the player is considered to be in peripheral vision
// I.e Out of focus and harder to see.
#define PERIPHERAL_START_ANGLE 30
