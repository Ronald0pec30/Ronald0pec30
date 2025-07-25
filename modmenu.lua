-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noclipActive = false
local lastCFrame = nil

-- Crear menú con botones
local function setupGui()
	local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	gui.Name = "ModMenu"
	gui.ResetOnSpawn = false

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

	local noclipBtn = makeButton("Noclip: OFF", 20)
	noclipBtn.MouseButton1Click:Connect(function()
		noclipActive = not noclipActive
		noclipBtn.Text = noclipActive and "Noclip: ON" or "Noclip: OFF"
		noclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
	end)
end

-- Noclip real: desactiva colisiones y fuerza la posición
RunService.Stepped:Connect(function(_, dt)
	if noclipActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local char = player.Character
		local hrp = char:FindFirstChild("HumanoidRootPart")

		-- Desactivar colisiones
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end

		-- Mantener posición estable para evitar corrección
		if lastCFrame then
			hrp.CFrame = lastCFrame
		end

		lastCFrame = hrp.CFrame
	else
		lastCFrame = nil
	end
end)

setupGui()

