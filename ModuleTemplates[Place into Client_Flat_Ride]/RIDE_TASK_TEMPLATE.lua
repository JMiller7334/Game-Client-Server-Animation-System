--[[RIDE TASK MODULE:
** rename module name to the ride name it is for. ____ ie: this module should be called carsouel if it is for the ride coursel.

Tasks are fired along side the rides animation tweens. If the ride does not use animation tweens task will not be called.
MUST CONTAIN FUNCTIONS:
	module.task_first()
	module.task_final()
	
	-- DEFAULT PASSED ARGUMENTS/PARAMETERS to above functions --
	player: 
		The player instance of the player is passed to each of beforementioned functions
		
	originalHeight: 
		The Y position of the player when the entered the ride. - this is also the starting height of the ride.
	
	fps_connection: 
		The linked connection to fps cam is also passed to the functions. This can used to disable the fps cam mode from the
		task modules. This usually necessary if you need to tween the camera since fps cam does not work well while tweens are running that change
		the rides Y position or cframe.y value. use tweens to update the camera during drastic changes to y position involving tweens.
]]

--feel free to declare any variables needed below this line.
local module = {}

--[[TASK FIRST:
plays while the rides first tween is being played. This function should cover any tasks
that should be performed at that time.
]]
function module.task_first(player)
    --do something(executs alongside rides first tween animation if applicable)
end

--[[TASK FINAL:
plays while the final ride tween is being played. This function should cover any tasks that
should be performed at that time.
]]
function module.task_final(player, originalHeight, fps_connection)
	--do somthing(executs alongside rides final tween aniimation if applicable)
	---------------------------
end

return module