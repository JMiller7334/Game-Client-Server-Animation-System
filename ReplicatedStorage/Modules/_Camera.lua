local module = {}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--camera functions
function module.tweenCamera(player, desiredCframe, tweenLength)
	local camera = game.Workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable
	local TweenServ = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(tweenLength, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
	local tweenGoal = {}
	tweenGoal.CFrame = desiredCframe
	TweenServ:Create(camera, tweenInfo, tweenGoal):Play()
end

function module.returnCamera(player)
	local camera = game.Workspace.CurrentCamera
	local charater = player.Character
	if charater then
		module.tweenCamera(player, player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 5), 0.5)
		task.wait(0.5)
		
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = player.Character.Humanoid
		player.CameraMaxZoomDistance = 30
		player.CameraMinZoomDistance = 0
	end
end


function module.enableFpsCam(player, hideWholePlayer, camRad2, camRad1)
	local camera = game.Workspace.CurrentCamera
	
	if firstPerson then return end
	firstPerson = true
	-- calc camera cf on userinput
	local fps_connection
	fps_connection = UserInputService.InputChanged:connect(function(input, _inputProcessed)
		--print("_fpsCam: input connection")
		local delta_input = -input.Delta * 0.1
		camRad2 = math.clamp(camRad2 + delta_input.Y, -60, 60)
		camRad1 = math.clamp(camRad1 + delta_input.X, -75, 75)
	end)
	-- hide player
	for iPlayer, vPlayer in pairs(player.Character:GetChildren()) do
		if vPlayer:IsA("Accessory") then
			if vPlayer:FindFirstChild("Handle") then
				vPlayer.Handle.Transparency = 1
			end
		end
		player.Character.Head.Transparency = 1
		if hideWholePlayer and vPlayer:IsA("MeshPart") then
			vPlayer.Transparency = 1
		end
	end
	-- binds the function to renderStep with an identifier, priority.
	RunService:BindToRenderStep("_Camera", Enum.RenderPriority.Last.Value+1, function()
		--print("_fpsCam: rendered")
		local Player_Camera_ = workspace.CurrentCamera
		if firstPerson then
			local camera_cfs = player.Character.Head.CFrame * CFrame.new(0, -2, 0)
			local calc_cf = camera_cfs * CFrame.new(0, 0.5, 0) * CFrame.new(0, 2, 0) * CFrame.Angles(0, 0, 0)

			if firstPerson then						
				camera.CFrame = calc_cf * CFrame.Angles(0, math.rad(camRad1), 0) * CFrame.Angles(math.rad(camRad2), 0, 0)
			end
		end
	end)
	return fps_connection
end


function module.disableFpsCam(player, showWholePlayer, fps_connection)
	if showWholePlayer then
		-- show player
		for iPlayer, vPlayer in pairs(player.Character:GetChildren()) do
			if vPlayer == player.Character.Head then
				vPlayer.Transparency = 0
			end
			if vPlayer:IsA("Accessory") then
				if vPlayer:FindFirstChild("Handle") then
					vPlayer.Handle.Transparency = 0
				end
			end
			if vPlayer:IsA("MeshPart") then
				vPlayer.Transparency = 0
			end
		end
	end
	
	-- disable connections
	if not firstPerson then return end
	firstPerson = false
	RunService:UnbindFromRenderStep("_Camera")
	if fps_connection then
		fps_connection:Disconnect()
		fps_connection = nil
	end
end

return module
