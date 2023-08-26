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
local SKYFLIGHT_LENGTH =  10

-- TWEEN GOALS
local goal_theOrbit1 = {}
goal_theOrbit1.CFrame = flatRides.The_Orbit.Ride.Tween_Part.CFrame * CFrame.new(0, 80, 0)
local goal_theOrbit2 = {}
goal_theOrbit2.CFrame = flatRides.The_Orbit.Ride.Tween_Part.CFrame

--[[Add tween and their associated ride names here.
This table is returned to the clientside framework where it is used to sync the flatrides back with the server]]
local allGoals = {}
allGoals["The_Orbit"] = {}
allGoals["The_Orbit"].cframe = {goal_theOrbit1.CFrame, goal_theOrbit2.CFrame}
allGoals["The_Orbit"].part = {"Tween_Part", "Tween_Part"}

-- TWEEN INFOS
local info_theOrbit1 = TweenInfo.new(
	20, -- Time
	Enum.EasingStyle.Linear, -- EasingStyle
	Enum.EasingDirection.InOut, -- EasingDirection
	0, -- RepeatCount (when less than zero the tween will loop indefinitely)
	false, -- Reverses (tween will reverse once reaching it's goal)
	0 -- DelayTime
)
local info_theOrbit2 = TweenInfo.new(
	10, -- Time
	Enum.EasingStyle.Linear, -- EasingStyle
	Enum.EasingDirection.InOut, -- EasingDirection
	0, -- RepeatCount (when less than zero the tween will loop indefinitely)
	false, -- Reverses (tween will reverse once reaching it's goal)
	0 -- DelayTime
)

-- CREATE TWEENS
local tween_theOrbit1 = TweenService:Create(flatRides.The_Orbit.Ride.Tween_Part, info_theOrbit1, goal_theOrbit1)
local tween_theOrbit2 = TweenService:Create(flatRides.The_Orbit.Ride.Tween_Part, info_theOrbit2, goal_theOrbit2)

-- SAVE TWEENS TO ARRAY
savedTweens["The_Orbit"] = {}
savedTweens["The_Orbit"].tween = {tween_theOrbit1, tween_theOrbit2}
savedTweens["The_Orbit"].length = {20, 10}


local module = {}
function module.getGoals()
	return allGoals
end

function module.getTweens()	
	return savedTweens
end
return module
