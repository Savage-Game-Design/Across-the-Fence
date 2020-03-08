class Draw3D
{ // Drawing HUD event
	targets[] = {HEADED_CLIENT_HOST,HEADED_CLIENT};
	// optional: files[] = {"eventHandlers\mission\eh_EntityKilled_yourcustomheader.sqf","eventHandlers\mission\eh_EntityKilled.sqf","eventHandlers\mission\eh_EntityKilled_yourcustomfooter.sqf"};
};
class EachFrame
{ // on each frame event
	targets[] = {HEADED_CLIENT_HOST,HEADED_CLIENT};
};
class EntityKilled
{ // Some entity death event
	targets[] = {HEADED_CLIENT_HOST,DEDICATED_SERVER};
};
class PreloadFinished
{ // preload event finished
	targets[] = {HEADED_CLIENT_HOST,HEADED_CLIENT};
};
class EntityRespawned
{
	targets[] = {HEADED_CLIENT_HOST,DEDICATED_SERVER};
};
class HandleDisconnect
{
	targets[] = {HEADED_CLIENT_HOST,DEDICATED_SERVER};
};
class PlayerConnected
{
	targets[] = {HEADED_CLIENT_HOST,DEDICATED_SERVER};
};
