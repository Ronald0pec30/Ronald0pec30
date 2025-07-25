-- Servicios
local Players, RunService = game:GetService("Players"), game:GetService("RunService")
local player = Players.LocalPlayer

local noclipActive, lastCFrame = false, nil
local lastHealth = nil

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

-- Función para crear GUI
local function setupGui()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "ModMenu"; gui.ResetOnSpawn = false

    local function makeButton(text, y)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,200,0,40)
        btn.Position = UDim2.new(0,20,0,y)
        btn.BackgroundColor3 = Color3.fromRGB(100,255,100)
        btn.TextScaled = true; btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.new(0,0,0)
        btn.Text = text; btn.Parent = gui; return btn
    end

    local btn = makeButton("Noclip: OFF", 20)
    btn.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        btn.Text = noclipActive and "Noclip: ON" or "Noclip: OFF"
        btn.BackgroundColor3 = noclipActive and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,255,100)

        local char = getChar()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if noclipActive then
            lastCFrame = hrp and hrp.CFrame
            if humanoid then humanoid.PlatformStand = true end
        else
            lastCFrame = nil
            if humanoid then humanoid.PlatformStand = false end
        end
    end)
end

-- Conectar eventos al personaje actual
local function setupChar(char)
    local humanoid = char:WaitForChild("Humanoid")
    lastHealth = humanoid.Health

    humanoid.Died:Connect(function()
        print("[DEBUG] ¡Humanoid.Died fired!")
        noclipActive = false
        lastCFrame = nil
    end)

    humanoid.HealthChanged:Connect(function(new)
        if lastHealth and new < lastHealth then
            local diff = lastHealth - new
            print(("[DEBUG] Has recibido daño: %.1f HP"):format(diff))
        end
        lastHealth = new
    end)
end

player.CharacterAdded:Connect(setupChar)
if player.Character then setupChar(player.Character) end

-- Forzar noclip cada frame de física
RunService.Heartbeat:Connect(function()
    if not noclipActive then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end

    if lastCFrame then hrp.CFrame = lastCFrame end
    lastCFrame = hrp.CFrame
end)

setupGui()

