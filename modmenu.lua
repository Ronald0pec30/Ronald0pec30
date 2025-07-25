--💥 Romario Script [NUEVO] con Menú Desplegable y Movible
--✅ ESP (wallhack)
--✅ Atravesar Muros (Noclip)
--✅ Protección con Burbuja (manual)
--✅ Interfaz móvil completa

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- GUI Principal
local gui = Instance.new("ScreenGui")
gui.Name = "RomarioScript"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Botón para Mostrar/Ocultar Menú
local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0, 150, 0, 30)
menuButton.Position = UDim2.new(0, 10, 0, 10)
menuButton.Text = "☰ Menú"
menuButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
menuButton.TextColor3 = Color3.new(1,1,1)
menuButton.TextScaled = true
menuButton.Parent = gui

-- Contenedor del Menú
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 220, 0, 160)
menuFrame.Position = UDim2.new(0, 10, 0, 50)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menuFrame.Visible = false
menuFrame.Parent = gui

-- Diseño Vertical para Botones
local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 5)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = menuFrame

-- Mostrar/Ocultar Menú
menuButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Funcionalidad ESP
local function activarESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if not player.Character.Head:FindFirstChild("ESP") then
                local esp = Instance.new("BillboardGui", player.Character.Head)
                esp.Size = UDim2.new(0, 100, 0, 40)
                esp.AlwaysOnTop = true
                esp.Name = "ESP"
                local label = Instance.new("TextLabel", esp)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = player.Name
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                label.TextScaled = true
            end
        end
    end
end

-- Botón ESP
local btnESP = Instance.new("TextButton")
btnESP.Size = UDim2.new(0, 200, 0, 40)
btnESP.Text = "🔍 Activar ESP"
btnESP.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
btnESP.TextColor3 = Color3.new(1,1,1)
btnESP.TextScaled = true
btnESP.LayoutOrder = 1
btnESP.Parent = menuFrame
btnESP.MouseButton1Click:Connect(activarESP)

-- Funcionalidad Noclip
local noclipOn = false
RunService.Stepped:Connect(function()
    if noclipOn and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Botón Noclip
local btnNoclip = Instance.new("TextButton")
btnNoclip.Size = UDim2.new(0, 200, 0, 40)
btnNoclip.Text = "🚪 Atravesar Muros: OFF"
btnNoclip.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
btnNoclip.TextColor3 = Color3.new(1,1,1)
btnNoclip.TextScaled = true
btnNoclip.LayoutOrder = 2
btnNoclip.Parent = menuFrame
btnNoclip.MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    btnNoclip.Text = noclipOn and "🚪 Atravesar Muros: ON" or "🚪 Atravesar Muros: OFF"
end)

-- Funcionalidad Protección
local shield, weld
local shieldOn = false
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

-- Botón Protección
local btnShield = Instance.new("TextButton")
btnShield.Size = UDim2.new(0, 200, 0, 40)
btnShield.Text = "🛡️ Protección: OFF"
btnShield.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
btnShield.TextColor3 = Color3.new(1,1,1)
btnShield.TextScaled = true
btnShield.LayoutOrder = 3
btnShield.Parent = menuFrame
btnShield.MouseButton1Click:Connect(function()
    shieldOn = not shieldOn
    if shieldOn then
        crearShield()
        btnShield.Text = "🛡️ Protección: ON"
        btnShield.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
    else
        removerShield()
        btnShield.Text = "🛡️ Protección: OFF"
        btnShield.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    end
end)

-- Mantener protección al reaparecer
LocalPlayer.CharacterAdded:Connect(function(newChar)
    char = newChar
    if shieldOn then
        task.wait(1)
        crearShield()
    end
end)

-- Hacer el menú movible arrastrando el botón
local dragging, dragInput, dragStart, startPos

menuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = menuFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

menuButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        menuFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
