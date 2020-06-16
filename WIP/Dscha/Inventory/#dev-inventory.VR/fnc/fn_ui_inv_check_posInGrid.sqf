/*
	simple check if given vars are within a given range
	
	Input:
		[curX, maxX, curY, maxY]
*/

params["_t_x","_g_x","_t_y","_g_y"];

//return negated result (True == False)
!(
	_t_x < 0 ||
	{_t_x > (_g_x-1)} ||
	{_t_y < 0} ||
	{_t_y > (_g_y-1)}
)