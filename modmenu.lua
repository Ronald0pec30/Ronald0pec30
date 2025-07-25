-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

-- Jugador
local player = Players.LocalPlayer

-- Función para obtener el personaje y asegurarse de que esté cargado
local function getCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	char:WaitForChild("Humanoid")
	char:WaitForChild("HumanoidRootPart")
	return char
end

-- Crear grupo de colisión si no existe
local COLLISION_GROUP = "NoClipGroup"
pcall(function()
	PhysicsService:CreateCollisionGroup(COLLISION_GROUP)
	PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP, "Default", false)
end)

-- Función principal del menú
local function setupGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TraspasarGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	-- Botón UI
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 180, 0, 45)
	btn.Position = UDim2.new(0, 20, 0, 0.1)
	btn.Text = "Traspasar Paredes"
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Parent = screenGui

	-- Estado de noclip
	local noclip = false

	-- Activar/desactivar colisiones (excepto el suelo)
	local function toggleNoclip()
		noclip = not noclip
		local char = getCharacter()
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				PhysicsService:SetPartCollisionGroup(part, noclip and COLLISION_GROUP or "Default")
			end
		end
		btn.Text = noclip and "Desactivar Noclip" or "Traspasar Paredes"
		btn.BackgroundColor3 = noclip and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(60, 60, 60)
	end

	btn.MouseButton1Click:Connect(toggleNoclip)
end

-- Esperar a que PlayerGui esté listo
if not player:FindFirstChild("PlayerGui") then
	player.CharacterAdded:Wait()
end

setupGui()
