-- Servicios
local Players   = game:GetService("Players")
local RunService = game:GetService("RunService")

local player       = Players.LocalPlayer
local noclipActive = false
local lastCFrame   = nil

-- Obtiene referencias que pueden cambiar
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

-- Crea el menú
local function setupGui()
	local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	gui.Name = "ModMenu"
	gui.ResetOnSpawn = false

	local function makeButton(text, ypos)
		local btn = Instance.new("TextButton")
		btn.Size            = UDim2.new(0,200,0,40)
		btn.Position        = UDim2.new(0,20,0,ypos)
		btn.BackgroundColor3= Color3.fromRGB(100,255,100)
		btn.TextScaled      = true
		btn.Font            = Enum.Font.GothamBold
		btn.TextColor3      = Color3.new(0,0,0)
		btn.Text            = text
		btn.Parent          = gui
		return btn
	end

	local btn = makeButton("Noclip: OFF", 20)
	btn.MouseButton1Click:Connect(function()
		noclipActive = not noclipActive
		btn.Text = noclipActive and "Noclip: ON" or "Noclip: OFF"
		btn.BackgroundColor3 = noclipActive
			and Color3.fromRGB(255,100,100)
			or Color3.fromRGB(100,255,100)

		-- Al activar, inicializa lastCFrame y pone PlatformStand
		local char = getChar()
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if noclipActive then
			lastCFrame = hrp and hrp.CFrame
			if humanoid then
				humanoid.PlatformStand = true
			end
		else
			lastCFrame = nil
			if humanoid then
				humanoid.PlatformStand = false
			end
		end
	end)
end

-- Cada frame de física
RunService.Heartbeat:Connect(function()
	if not noclipActive then return end

	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not humanoid then return end

	-- Desactiva colisiones de todas las partes
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end

	-- Fuerza posición para atravesar muros
	if lastCFrame then
		hrp.CFrame = lastCFrame
	end
	lastCFrame = hrp.CFrame
end)

-- Lanzar GUI
setupGui()
