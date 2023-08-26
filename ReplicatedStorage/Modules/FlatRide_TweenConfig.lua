--[[RIDE TWEENS:
For flat rides that have tween animations that run alongside their standard animations.
Tweens that fit this desc should be configured here.
]]

local TweenService = game:GetService("TweenService")

--workspace
local flatRides = game.Workspace:WaitForChild("FlatRides")

--tween config
--[[CONFIGURE TWEENS HERE
set up tweens here.
the savedTweens array must take in all the animations that will play.
Tweens will be played in the order they a placed into the array. The last tween will be played at very end of the rides standard animation.
]]
repeat wait() until game:IsLoaded()
print("loading client_flatRide/tweenConfig")

-- savedTweens
local savedTweens = {}

-- TWEEN GOALS
local goal_example1 = {}
goal_example1.CFrame = flatRides.yourRideName.Ride.Tween_Part.CFrame * CFrame.new(0, 80, 0)

local goal_example2 = {}
goal_example2.CFrame = flatRides.yourRideName.Tween_Part.CFrame

--[[Add tween and their associated ride names here.
This table is returned to the clientside framework where it is used to sync the flatrides back with the server]]
local allGoals = {}
allGoals["yourRideName"] = {}
allGoals["yourRideName"].cframe = {goal_example1.CFrame, goal_example2.CFrame} --list each of your tween goals(up to 2)
allGoals["yourRideName"].part = {"Tween_Part", "Tween_Part"} --list the part(s) your tweening with each tween

-- TWEEN INFOS
local info_example1 = TweenInfo.new(
	20, -- Time
	Enum.EasingStyle.Linear, -- EasingStyle
	Enum.EasingDirection.InOut, -- EasingDirection
	0, -- RepeatCount (when less than zero the tween will loop indefinitely)
	false, -- Reverses (tween will reverse once reaching it's goal)
	0 -- DelayTime
)
local info_example2 = TweenInfo.new(
	10, -- Time
	Enum.EasingStyle.Linear, -- EasingStyle
	Enum.EasingDirection.InOut, -- EasingDirection
	0, -- RepeatCount (when less than zero the tween will loop indefinitely)
	false, -- Reverses (tween will reverse once reaching it's goal)
	0 -- DelayTime
)

-- CREATE TWEENS
local tween_example1 = TweenService:Create(flatRides.The_Orbit.Ride.Tween_Part, info_example1, goal_example1)
local tween_example2 = TweenService:Create(flatRides.The_Orbit.Ride.Tween_Part, info_example2, goal_example2)

-- SAVE TWEENS TO ARRAY
--[[
	init a class to hold the tweens for your ride. This required please use the ride name you used in the FlateRides folder in workspace.
	Example below:
]]
savedTweens["yourRideName"] = {}
savedTweens["yourRideName"].tween = {tween_example1, tween_example2} --place the tweens you created here
savedTweens["yourRideName"].length = {20, 10} --place the time in seconds as an int for each tween here. NOTE: this is an parallal array with the array 1 line above.


-- Do not touch
local module = {}
function module.getGoals()
	return allGoals
end

function module.getTweens()	
	return savedTweens
end
return module
