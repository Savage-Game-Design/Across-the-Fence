if (isNil "vn_mf_enable_debug_monitor") then
{
	vn_mf_enable_debug_monitor = true;
}
else
{
	vn_mf_enable_debug_monitor = nil;
	hintSilent "Debug Monitor: disabled";
};
