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

local function setupGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ModMenu"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local function makeButton(name, posY, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 180, 0, 40)
		btn.Position = UDim2.new(0, 20, 0, posY)
		btn.Text = name
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 18
		btn.Parent = screenGui
		btn.MouseButton1Click:Connect(callback)
		return btn
	end

	-- Noclip con CollisionGroup
	local noclip = false
	local COLLISION_GROUP = "NoClipGroup"
	pcall(function()
		PhysicsService:CreateCollisionGroup(COLLISION_GROUP)
		PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP, "Default", false)
	end)

	local function toggleNoclip()
		noclip = not noclip
		local char = getCharacter()
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				PhysicsService:SetPartCollisionGroup(part, noclip and COLLISION_GROUP or "Default")
			end
		end
	end

	-- Velocidad
	local fast = false
	local function toggleSpeed()
		local hum = getCharacter():WaitForChild("Humanoid")
		fast = not fast
		hum.WalkSpeed = fast and 32 or 16
	end

	-- Super salto
	local jump = false
	local function toggleJump()
		local hum = getCharacter():WaitForChild("Humanoid")
		jump = not jump
		hum.JumpPower = jump and 120 or 50
	end

	makeButton("Noclip Activar", 0.1, toggleNoclip)
	makeButton("Velocidad X2", 0.2, toggleSpeed)
	makeButton("Súper Salto", 0.3, toggleJump)
end

-- Esperar a que todo esté listo
if not player:FindFirstChild("PlayerGui") then
	player.CharacterAdded:Wait()
end

setupGui()
