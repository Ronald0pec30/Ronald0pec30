-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Variables
local noclipActive = false

-- Función para obtener el personaje
local function getCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	char:WaitForChild("HumanoidRootPart")
	return char
end

-- Crear menú con botones
local function setupGui()
	local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	gui.Name = "ModMenu"
	gui.ResetOnSpawn = false

	-- Función para crear botones
	local function makeButton(name, yPos)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0, 200, 0, 40)
		btn.Position = UDim2.new(0, 20, 0, yPos)
		btn.Text = name
		btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
		btn.TextScaled = true
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = Color3.new(0, 0, 0)
		btn.Parent = gui
		return btn
	end

	-- Botón Noclip
	local noclipBtn = makeButton("Noclip: OFF", 20)
	noclipBtn.MouseButton1Click:Connect(function()
		noclipActive = not noclipActive
		noclipBtn.Text = noclipActive and "Noclip: ON" or "Noclip: OFF"
		noclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
	end)
end

-- Activar noclip en cada frame si está habilitado
RunService.Stepped:Connect(function()
	if noclipActive and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Ejecutar el menú
setupGui()

