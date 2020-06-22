/*
	simple check if given vars are within a given range
	called by "fn_ui_inv_get_GridPos.sqf"
	
	Input:
		[
			 curX	// FLOAT - x Pos to check
			,maxX	// FLOAT - x max of Grid
			,curY	// FLOAT - Y Pos to check
			,maxY	// FLOAT - Y max of Grid
		]
*/

params["_t_x","_g_x","_t_y","_g_y"];

//return negated result (True == False)
!(
	_t_x < 0 ||
	{_t_x > (_g_x-1)} ||
	{_t_y < 0} ||
	{_t_y > (_g_y-1)}
)