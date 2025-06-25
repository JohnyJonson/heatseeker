local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local OWNER_USER_ID = game.CreatorId


local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- BodyVelocity setup
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
bodyVelocity.P = 1e4
bodyVelocity.Name = "FlyBurst"

-- Fly control
local flyEnabled = false
local isBoosting = true
local timer = 0

-- Burst speed settings
local boostSpeed = 111
local slowSpeed = 31
local boostDuration = 0.096
local slowDuration = 1.4

-- Toggle fly on/off
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		flyEnabled = not flyEnabled
		timer = 0

		if flyEnabled then
			bodyVelocity.Parent = hrp
			print("Fly Burst: ENABLED")
		else
			bodyVelocity.Parent = nil
			hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
			print("Fly Burst: DISABLED")
		end
	end
end)

-- Get direction from input + camera
local function getFlyDirection()
	local cam = workspace.CurrentCamera.CFrame
	local direction = Vector3.zero

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.E) then direction += cam.UpVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Q) then direction -= cam.UpVector end

	return direction.Magnitude > 0 and direction.Unit or Vector3.zero
end

-- Handle bursts each frame
RunService.RenderStepped:Connect(function(dt)
	if not flyEnabled then return end

	timer += dt
	if isBoosting and timer >= boostDuration then
		isBoosting = false
		timer = 0
	elseif not isBoosting and timer >= slowDuration then
		isBoosting = true
		timer = 0
	end

	local direction = getFlyDirection()
	local speed = isBoosting and boostSpeed or slowSpeed
	bodyVelocity.Velocity = direction * speed
end)
