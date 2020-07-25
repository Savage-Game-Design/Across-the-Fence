if (isNil "vn_an_enable_debug_monitor") then
{
	vn_an_enable_debug_monitor = true;
}
else
{
	vn_an_enable_debug_monitor = nil;
	hintSilent "Debug Monitor: disabled";
};
