local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local OWNER_USER_ID = game.CreatorId


local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1e5, 0, 1e5)  -- horizontal only
bodyVelocity.P = 1e4
bodyVelocity.Parent = hrp

local boostSpeed = 123       -- fast speed during burst
local slowSpeed = 50         -- slow speed during cooldown
local boostDuration = 0.098    -- burst lasts this long
local slowDuration = 1.2     -- slow speed lasts this long

local timer = 0
local isBoosting = true

RunService.RenderStepped:Connect(function(dt)
    timer = timer + dt

    if isBoosting and timer >= boostDuration then
        isBoosting = false
        timer = 0
    elseif not isBoosting and timer >= slowDuration then
        isBoosting = true
        timer = 0
    end

    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude > 0 then
        local speed = isBoosting and boostSpeed or slowSpeed
        bodyVelocity.Velocity = Vector3.new(moveDir.X * speed, hrp.Velocity.Y, moveDir.Z * speed)
    else
        -- no movement input: stop horizontal velocity but keep vertical velocity intact
        bodyVelocity.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
    end
end)
