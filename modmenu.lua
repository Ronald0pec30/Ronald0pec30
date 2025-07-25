local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

local player = Players.LocalPlayer

local function getCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	char:WaitForChild("Humanoid")
	char:WaitForChild("HumanoidRootPart")
	return char
end

-- Crear grupo si no existe
local COLLISION_GROUP = "NoClipGroup"
pcall(function()
	PhysicsService:CreateCollisionGroup(COLLISION_GROUP)
	PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP, "Default", false)
end)

local function setupGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "NoclipGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 180, 0, 45)
	button.Position = UDim2.new(0, 20, 0, 0.1)
	button.Text = "Traspasar Paredes"
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18
	button.Parent = screenGui

	local noclip = false

	local function toggleNoclip()
		noclip = not noclip
		local char = getCharacter()

		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				PhysicsService:SetPartCollisionGroup(part, noclip and COLLISION_GROUP or "Default")
				part.CanCollide = not noclip
			end
		end

		button.Text = noclip and "Desactivar Noclip" or "Traspasar Paredes"
		button.BackgroundColor3 = noclip and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(60, 60, 60)
	end

	button.MouseButton1Click:Connect(toggleNoclip)
end

if not player:FindFirstChild("PlayerGui") then
	player.CharacterAdded:Wait()
end

setupGui()

