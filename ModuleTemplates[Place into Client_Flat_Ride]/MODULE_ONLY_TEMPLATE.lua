--[[MODULE ONLY RIDES:
** rename module name to the ride name it is for. ____ ie: this module should be called carousel if it is for the ride coursel.

1. module only rides run a basis of whether or not any players are riding them.
2. module only rides cannot be unsynced from the server and run regardless of whether or not rides are disabled.
3. module only rides must have functions - module.start(), module.stop()
]]


--feel free to declare any variables needed below this line.


--[[RESET FUNCTION:
this function should be coded to reset the ride to it's non running position/cframe
]]
function reset()
    --do something(executes when there are no players left on the ride.)
end


local module = {}

--[[STOP FUNCTION:
this should call the reset function
]]
function module.stop()
	reset()
end


--[[START FUNCTION:
this is where you should code your rides cframe animation or whatever other type of animation you're using.
]]
function module.start()
	--do something(executes when a player enters the ride.)
end

return module