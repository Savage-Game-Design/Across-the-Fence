- Start a mission
- Mark mission members as ready
- Explicitly start deployment
- Mission executes
- Player can abandon mission at any time (with mission ending when last player abandons)
-- Implies adaptive difficulty?
- Mission ends when all players die
- Mission ends when all player succeed


Replicate mission info into global mission namespace, rather than assigning it to player object.
Subset of mission info - client visible only
Map player id to mission in backend (for re-joiners)

[player] call leaveCurrentMission
- Removes a player from the current mission
- Returns the player to the shared hub if currently on a mission

[missionParameters] call setupMission
- Creates a new mission that the backend knows about
- Assigns mission creator to mission via joinMissing
- Returns a reference to the public part of the mission object - can't really do pure functional niceness here.

[] call cancelMission
- Cancels a mission that's not in-progress
- Updates status of mission
- Unassigns players
- Calls same function as leaveCurrentMission (removePlayerFromMission?)

[] call endMission
- Disables damage on players
- Fades screen to black for all players
- Teleports players back to base
-- Needs to handle players in the middle of respawning, or that are downed.
- Shows end mission screen


[player] call joinMission
- Assigns a player to the mission

[player] call readyPlayer
- Readies the player in the mission data structure
- Handle mission in-progress

[] call startMission
- Fades the player screen to black
- Teleports player
- Unfades the screen

- Calls deployOnMission on players
- Generates the mission (spawns entities)
- Teleports the players to the start position
- "Triggers the mission code to start adapting the mission" - Some kind of mission director? Need to get this nailed down.

deployOnMission
- Fades the screen to black for all players (or do this using local state?)

// TODO - Write request response system, when needed


// For debug UI
- Trigger mission creation
- Call 'addAction' when a new mission is available
- Call 'removeAction' when a mission is unavailable (deployed on)
- How do I handle JIP?!?!?!?!
