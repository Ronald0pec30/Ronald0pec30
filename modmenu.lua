-- Mod Menu Mejorado con Noclip Real, Velocidad y Súper Salto
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

-- Crear CollisionGroup seguro
local COLLISION_GROUP = "NoClipGroup"
if not pcall(function() PhysicsService:GetCollisionGroupId(COLLISION_GROUP) end) then
	PhysicsService:CreateCollisionGroup(COLLISION_GROUP)
end
PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP, "Default", false)

-- MOD MENU
local function setupGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ModMenu"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local function makeButton(name, posY, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 200, 0, 40)
		btn.Position = UDim2.new(0, 20, 0, posY)
		btn.Text = name
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 18
		btn.Parent = screenGui
		btn.MouseButton1Click:Connect(callback)
		return btn
	end

	local noclip = false
	local fast = false
	local jump = false

	local function applyNoclip(state)
		local char = getCharacter()
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				PhysicsService:SetPartCollisionGroup(part, state and COLLISION_GROUP or "Default")
			end
		end
	end

	makeButton("🔹 Noclip ON/OFF", 0.1, function()
		noclip = not noclip
		applyNoclip(noclip)
	end)

	makeButton("⚡ Velocidad X2", 0.2, function()
		local hum = getCharacter():WaitForChild("Humanoid")
		fast = not fast
		hum.WalkSpeed = fast and 32 or 16
	end)

	makeButton("🚀 Súper salto", 0.3, function()
		local hum = getCharacter():WaitForChild("Humanoid")
		jump = not jump
		hum.JumpPower = jump and 120 or 50
	end)
end

-- Espera y lanza interfaz
if not player:FindFirstChild("PlayerGui") then
	repeat task.wait() until player:FindFirstChild("PlayerGui")
end

setupGui()
