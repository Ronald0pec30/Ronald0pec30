-- Mejor noclip con botón y velocidad aumentada
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local noclip = false
local normalWalkSpeed = humanoid.WalkSpeed
local noclipSpeed = normalWalkSpeed + 12 -- aumenta 12 de velocidad al activar

-- Función para activar/desactivar noclip
local function setNoclip(active)
	noclip = active
	if noclip then
		-- Activar noclip
		humanoid.WalkSpeed = noclipSpeed
		warn("Noclip ACTIVADO")
	else
		-- Desactivar noclip y restaurar velocidad normal
		humanoid.WalkSpeed = normalWalkSpeed
		warn("Noclip DESACTIVADO")
	end
end

-- Loop que aplica noclip de forma segura
game:GetService("RunService").Stepped:Connect(function()
	if character and humanoid then
		if noclip then
			-- Quita las colisiones para atravesar objetos
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide == true then
					part.CanCollide = false
				end
			end
			-- Evitar empujones y fuerzas contrarias
			humanoid.PlatformStand = true
		else
			-- Restaurar colisiones y estado cuando noclip está desactivado
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide == false then
					part.CanCollide = true
				end
			end
			humanoid.PlatformStand = false
		end
	end
end)

-- Crear GUI para botón
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoclipGui"
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 50)
button.Position = UDim2.new(0, 20, 0, 80)
button.Text = "Activar Noclip"
button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 20
button.Font = Enum.Font.SourceSansBold
button.Parent = screenGui
button.AutoButtonColor = true
button.BorderSizePixel = 0
button.BackgroundTransparency = 0.15

-- Acciones del botón
button.MouseButton1Click:Connect(function()
	setNoclip(not noclip)
	if noclip then
		button.Text = "Desactivar Noclip"
		button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	else
		button.Text = "Activar Noclip"
		button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	end
end)

-- Para evitar problemas de muerte o daño accidental
-- Resetea la salud constantemente mientras esté activo
game:GetService("RunService").Heartbeat:Connect(function()
	if noclip and humanoid and humanoid.Health < humanoid.MaxHealth then
		humanoid.Health = humanoid.MaxHealth
	end
end)
