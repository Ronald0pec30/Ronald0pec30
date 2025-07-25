local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Aplicar propiedades para minimizar rebotes
local function applyNicePhysics(character)
    local props = PhysicalProperties.new(0.7, 0.5, 0, 1, 100)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CustomPhysicalProperties = props
        end
    end
    character.DescendantAdded:Connect(function(v)
        if v:IsA("BasePart") then
            v.CustomPhysicalProperties = props
        end
    end)
end

-- Antinoclip basado en raycasting
local noclipOn = false
local lastPos = nil
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
raycastParams.FilterDescendantsInstances = {} -- actualizado por jugador
raycastParams.IgnoreWater = true

RunService.Heartbeat:Connect(function()
    if noclipOn and char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        if lastPos and (root.Position - lastPos).Magnitude > 0.1 then
            raycastParams.FilterDescendantsInstances = {char}
            local result = workspace:Raycast(lastPos, root.Position - lastPos, raycastParams)
            if result and result.Instance and result.Instance.CanCollide then
                root.CFrame = CFrame.new(lastPos)
                root.AssemblyLinearVelocity = Vector3.new()
                root.AssemblyAngularVelocity = Vector3.new()
            end
        end
        lastPos = root.Position
    end
end)

local function enablePowerNoclip()
    if not char then return end
    applyNicePhysics(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end
    noclipOn = true
    lastPos = char.HumanoidRootPart.Position
end

local function disablePowerNoclip()
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
            part.Massless = false
            part.CustomPhysicalProperties = nil
        end
    end
    noclipOn = false
end

-- GUI PRINCIPAL
local gui = Instance.new("ScreenGui")
gui.Name = "RomarioScript"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0,150,0,30)
menuButton.Position = UDim2.new(0,10,0,10)
menuButton.Text = "☰ Menú"
menuButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
menuButton.TextColor3 = Color3.new(1,1,1)
menuButton.TextScaled = true
menuButton.Parent = gui

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0,220,0,160)
menuFrame.Position = UDim2.new(0,10,0,50)
menuFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
menuFrame.Visible = false
menuFrame.Parent = gui

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0,5)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = menuFrame

menuButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- ESP
local function activarESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if not player.Character.Head:FindFirstChild("ESP") then
                local esp = Instance.new("BillboardGui", player.Character.Head)
                esp.Size = UDim2.new(0,100,0,40)
                esp.AlwaysOnTop = true
                esp.Name = "ESP"
                local label = Instance.new("TextLabel", esp)
                label.Size = UDim2.new(1,0,1,0)
                label.Text = player.Name
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255,0,0)
                label.TextScaled = true
            end
        end
    end
end
local btnESP = Instance.new("TextButton")
btnESP.Size = UDim2.new(0,200,0,40)
btnESP.Text = "🔍 Activar ESP"
btnESP.BackgroundColor3 = Color3.fromRGB(0,170,255)
btnESP.TextColor3 = Color3.new(1,1,1)
btnESP.TextScaled = true
btnESP.LayoutOrder = 1
btnESP.Parent = menuFrame
btnESP.MouseButton1Click:Connect(activarESP)

-- Noclip
local btnNoclip = Instance.new("TextButton")
btnNoclip.Size = UDim2.new(0,200,0,40)
btnNoclip.Text = "🚪 Atravesar Muros: OFF"
btnNoclip.BackgroundColor3 = Color3.fromRGB(255,100,100)
btnNoclip.TextColor3 = Color3.new(1,1,1)
btnNoclip.TextScaled = true
btnNoclip.LayoutOrder = 2
btnNoclip.Parent = menuFrame
btnNoclip.MouseButton1Click:Connect(function()
    if not noclipOn then
        enablePowerNoclip()
        btnNoclip.Text = "🚪 Atravesar Muros: ON"
    else
        disablePowerNoclip()
        btnNoclip.Text = "🚪 Atravesar Muros: OFF"
    end
end)

-- Protección (burbuja)
local shield, weld; local shieldOn = false
local function crearShield()
    if shield then shield:Destroy() end
    if weld then weld:Destroy() end
    local root = char:WaitForChild("HumanoidRootPart")
    shield = Instance.new("Part")
    shield.Name = "ShieldBubble"
    shield.Shape = Enum.PartType.Ball
    shield.Size = Vector3.new(10,10,10)
    shield.Transparency = 0.3
    shield.Anchored = false
    shield.CanCollide = true
    shield.Material = Enum.Material.ForceField
    shield.Color = Color3.fromRGB(255,0,0)
    shield.Position = root.Position
    shield.Parent = char
    weld = Instance.new("WeldConstraint")
    weld.Part0 = root
    weld.Part1 = shield
    weld.Parent = shield
end
local function removerShield()
    if shield then shield:Destroy() end
    if weld then weld:Destroy() end
    shield, weld = nil, nil
end
local btnShield = Instance.new("TextButton")
btnShield.Size = UDim2.new(0,200,0,40)
btnShield.Text = "🛡 Protección: OFF"
btnShield.BackgroundColor3 = Color3.fromRGB(255,85,85)
btnShield.TextColor3 = Color3.new(1,1,1)
btnShield.TextScaled = true
btnShield.LayoutOrder = 3
btnShield.Parent = menuFrame
btnShield.MouseButton1Click:Connect(function()
    shieldOn = not shieldOn
    if shieldOn then
        crearShield()
        btnShield.Text = "🛡 Protección: ON"
        btnShield.BackgroundColor3 = Color3.fromRGB(85,255,85)
    else
        removerShield()
        btnShield.Text = "🛡 Protección: OFF"
        btnShield.BackgroundColor3 = Color3.fromRGB(255,85,85)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    char = newChar
    if shieldOn then task.wait(1); crearShield() end
end)

-- Drag para mover menú
local dragging, dragInput, dragStart, startPos
menuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = menuFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
menuButton.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        local delta = input.Position - dragStart
        menuFrame.Position = UDim2.new(startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y)
    end
end)
