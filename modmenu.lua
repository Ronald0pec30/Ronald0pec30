-- Servicios
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local PhysicsService= game:GetService("PhysicsService")

-- Constants
local COLLISION_GROUP = "NoClipGroup"

-- Jugador y personaje
local player = Players.LocalPlayer
local function getCharacter()
    local c = player.Character or player.CharacterAdded:Wait()
    c:WaitForChild("HumanoidRootPart")
    return c
end

-- Crear CollisionGroup y desactivar colisión con el mundo
if not pcall(function() PhysicsService:GetCollisionGroupId(COLLISION_GROUP) end) then
    PhysicsService:CreateCollisionGroup(COLLISION_GROUP)
    PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP, "Default", false)
end

-- Estado
local noclip = false

-- GUI
local function setupGui()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "NoClipGui"
    gui.ResetOnSpawn = false

    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0,180,0,45)
    btn.Position         = UDim2.new(0,20,0,50)
    btn.Font             = Enum.Font.SourceSansBold
    btn.TextSize         = 18
    btn.TextColor3       = Color3.new(1,1,1)
    btn.BackgroundColor3= Color3.fromRGB(60,60,60)
    btn.Parent           = gui

    local function updateButton()
        if noclip then
            btn.Text = "Desactivar Noclip"
            btn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        else
            btn.Text = "Traspasar Paredes"
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
    end

    btn.MouseButton1Click:Connect(function()
        noclip = not noclip
        updateButton()
    end)

    updateButton()
end

-- Loop que anula colisiones CONSTANTEMENTE
RunService.Stepped:Connect(function()
    if not noclip then return end
    local char = player.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            -- Forzar CollisionGroup y CanCollide = false cada frame
            PhysicsService:SetPartCollisionGroup(part, COLLISION_GROUP)
            part.CanCollide = false
        end
    end
end)

-- Inicializar GUI cuando PlayerGui esté listo
if player:FindFirstChild("PlayerGui") then
    setupGui()
else
    player.CharacterAdded:Wait()
    setupGui()
end
