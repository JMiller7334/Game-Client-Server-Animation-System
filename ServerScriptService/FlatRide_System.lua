--[[SERVER SIDE FRAMEWORK:
Keeps track of what rides are running and where each ride should be in it's animation.
This also tells all clients/players when a ride should be started and who has rode a ride 
through it's whole animation. Also handles the rides start timer countdown - these are sent to the client.
]]

-- service
local ServScript = game:GetService("ServerScriptService")
local RepStore = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")

-- workspace
local flatRides = game.Workspace.FlatRides

-- variables
local START_TIMER = 10
local MODULE_ONLY = {}

--remote events/func
local remote_rideSync = Instance.new("RemoteFunction")
remote_rideSync.Name = "remote_flatride_sync"
remote_rideSync.Parent = RepStore

local event_rideStart = Instance.new("RemoteEvent")
event_rideStart.Name = "event_flatride_start"
event_rideStart.Parent = RepStore

local event_manageRiders = Instance.new("RemoteEvent")
event_manageRiders.Name = "event_flatRide_manageRiders"
event_manageRiders.Parent = RepStore

local event_rideStop = Instance.new("RemoteEvent")
event_rideStop.Name = "event_flatRide_stop"
event_rideStop.Parent = RepStore


--[[RUN RIDE FUNC (coroutine):
handles updating ride animations times

rid.riders: array value of string. 
	contains player names of those who rode to completion of a ride.
]]
function runRide(ride)
	local startTime = os.time()
	wait()
	local currentTime = os.time()
	local timePassed = currentTime - startTime
	ride.animPosition += timePassed

	if ride.animPosition >= ride.animlength then
		print("flatRides/"..ride.name..": ANIMATION FINISHED")
		
		--OUTPUT riders who rode whole ride to completion--
		print("-------------")
		print("LISTED RIDERS")
		for riderIndex, rider in pairs(ride.riders) do
			print(rider)
			
			--do something
		end
		print("-------------")
		
		ride.riders = {}
		ride.active = false
		ride.animPosition = 0.0
		flatRides[ride.name].Countdown.Value = START_TIMER
		return
	end
	runRide(ride)
end

--[[CLASS INIT:
initialize classes for each ride in the FlatRides folder.
These classes contain all needed data for each ride.
]]
local ClassRides = {}
for _, v in pairs(flatRides:GetChildren()) do
	ClassRides[v.Name] = {}
	local Class = ClassRides[v.Name]
	Class.name = v.Name
	
	local animTrack
	if v.Ride:FindFirstChild("AnimationController") then
		animTrack = v.Ride.AnimationController.Animator:LoadAnimation(v.Animation)
		ContentProvider:PreloadAsync({v.Animation}) -- ensures animation time can be retieved.
		Class.animlength = animTrack.Length
	else
		animTrack = v.Animation
		Class.animlength = animTrack.Length.Value
	end
	

	Class.animPosition = 0.0
	Class.active = false
	Class.riders = {}
	Class.run = function()
		Class.active = true
		local rideThread = coroutine.wrap(runRide)
		rideThread(Class)
	end
	print("FlatRides/core: loaded "..v.Name.." | "..Class.animlength)
	
	--[[config model
	tag the seats of the ride so the client framework can
	sense when the the player sits in the ride.
	]]
	local countDown = Instance.new("IntValue")
	countDown.Name = "Countdown"
	countDown.Parent = v
	countDown.Value = START_TIMER
	local rideModel = v.Ride
	for _, child in pairs(rideModel:GetChildren()) do
		if child.ClassName == "Seat" then
			local tag = Instance.new("StringValue")
			tag.Name = ("Flat_Ride_Tag")
			tag.Parent = child
			tag.Value = v.Name
		end
	end
end

--[[signal clients to run ride animation

this function signals the clients to start their ride
animations. This function also handles updating the
countdown time for the ride.
]]
event_rideStart.OnServerEvent:Connect(function(player, rideName)	
	print("flateRides: request - "..rideName)
	if ClassRides[rideName] then
		local ride = ClassRides[rideName]
		if ride.active == false and ride.animPosition <= 0 then
			ride.active = true
			print("FlatRides/"..rideName.." ANIMATION STARTING")
			event_rideStart:FireAllClients(ride.name)
			if table.find(MODULE_ONLY, rideName) then
				return
			end
			
			local rideModel = flatRides[ride.name]
			rideModel.Countdown.Value = START_TIMER
			for i = 1, START_TIMER do
				wait(1)
				rideModel.Countdown.Value -=1
			end
			
			ride.run()
		end
	end
end)

--[[MANGE RIDERS:
Manages who is current on each ride
NOTE: this only keeps track of players who got on the ride before
it's animation started.
]]
event_manageRiders.OnServerEvent:Connect(function(player, character, rideName)
	if ClassRides[rideName] and character then
		if not character:FindFirstChild("Humanoid") then return end -- ensure humanoid exists!
		
		local riders = ClassRides[rideName].riders
		local riderIndex = table.find(riders, player.Name)
		if not riderIndex then
			if ClassRides[rideName].animPosition < 1 then
				if ClassRides[rideName].active and character.Humanoid.SeatPart then
					-- make sure the player is actually seated in the ride to prevent exploits
					if character.Humanoid.SeatPart.Parent.Parent.Name == rideName then
						
						print("flatRide: player-"..player.Name.." added to "..rideName.." rider list")
						table.insert(riders, player.Name)
					end
				end
			end
		else
			print("flatRide: player-"..player.Name.." removed from "..rideName.." rider list")
			table.remove(riders, riderIndex)
		end
		
		-- Module only rides stop when there are not players on them
		if #riders < 1 and table.find(MODULE_ONLY, rideName) then
			print("SHUTDOWN")
			ClassRides[rideName].active = false
			event_rideStop:FireAllClients(rideName)
		end
	end
end)


--[[Gathers the current animation times from the server
and send them to the client along with whether the ride is active.
]]
function syncRides(player)
	local animationTimes = {}
	for _, classOfRide in pairs(ClassRides) do
		animationTimes[classOfRide.name] = {}
		animationTimes[classOfRide.name].animPosition = classOfRide.animPosition
		animationTimes[classOfRide.name].name = classOfRide.name
		animationTimes[classOfRide.name].active = classOfRide.active
	end
	return animationTimes
end
remote_rideSync.OnServerInvoke = syncRides

--[[
Most rides will remove the player from it's rider array automatically.
Rides that function only from a module(MODULE ONLY RIDES) will not, this function handles 
removing riders from the ride class's property - rider array
]]
Players.PlayerRemoving:Connect(function(player)
	for _, mod_only in pairs(MODULE_ONLY) do
		local riderIndex = table.find(ClassRides[mod_only].riders, player.Name) 
		if ClassRides[mod_only] and riderIndex then
			print("FlatRides: player left-"..player.Name.." | removing from queu "..ClassRides[mod_only].riders[riderIndex])
			table.remove(ClassRides[mod_only], riderIndex)
		end
	end
end)