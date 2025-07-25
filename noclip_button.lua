-- Noclip con botón en pantalla
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local noclip = false

-- Función para activar/desactivar noclip
local function setNoclip(active)
	noclip = active
	if noclip then
		warn("Noclip ACTIVADO")
	else
		warn("Noclip DESACTIVADO")
	end
end

-- Loop que aplica noclip
game:GetService("RunService").Stepped:Connect(function()
	if noclip and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "NoclipGui"

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0, 20, 0, 80)
button.Text = "Activar Noclip"
button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 18
button.Font = Enum.Font.SourceSansBold
button.Parent = ScreenGui
button.AutoButtonColor = true
button.BorderSizePixel = 0
button.BackgroundTransparency = 0.1

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
