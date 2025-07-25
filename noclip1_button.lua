local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local noclip = false
local defaultWalkSpeed = humanoid.WalkSpeed

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "BetterNoclipGui"

-- Botón Noclip
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 140, 0, 40)
noclipButton.Position = UDim2.new(0, 20, 0, 80)
noclipButton.Text = "Activar Noclip"
noclipButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
noclipButton.TextColor3 = Color3.new(1, 1, 1)
noclipButton.TextSize = 18
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.Parent = ScreenGui
noclipButton.AutoButtonColor = true
noclipButton.BorderSizePixel = 0

-- Botón Teleport
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 140, 0, 40)
teleportButton.Position = UDim2.new(0, 20, 0, 130)
teleportButton.Text = "TP a mi base"
teleportButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
teleportButton.TextColor3 = Color3.new(0, 0, 0)
teleportButton.TextSize = 18
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.Parent = ScreenGui
teleportButton.AutoButtonColor = true
teleportButton.BorderSizePixel = 0

-- Noclip activador
local function setNoclip(active)
	noclip = active
	if noclip then
		noclipButton.Text = "Desactivar Noclip"
		noclipButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
		humanoid.WalkSpeed = 50 -- velocidad aumentada
	else
		noclipButton.Text = "Activar Noclip"
		noclipButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
		humanoid.WalkSpeed = defaultWalkSpeed
	end
end

-- Loop anticaída (noclip estable)
game:GetService("RunService").Stepped:Connect(function()
	if noclip and character and humanoid and humanoid.Health > 0 then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				part.CanCollide = false
			end
		end
	end
end)

-- Acción botón noclip
noclipButton.MouseButton1Click:Connect(function()
	setNoclip(not noclip)
end)

-- Acción botón teleport
teleportButton.MouseButton1Click:Connect(function()
	if character and character:FindFirstChild("HumanoidRootPart") then
		-- Cambia esta posición a donde esté tu base exactamente
		character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0, 10, 0))
	end
end)
