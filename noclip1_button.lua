
-- Mejor noclip con CollisionGroups para no caer al vacío
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

local player         = Players.LocalPlayer
local character      = player.Character or player.CharacterAdded:Wait()
local humanoid       = character:WaitForChild("Humanoid")
local rootPart       = character:WaitForChild("HumanoidRootPart")

-- Velocidades
local normalWalkSpeed = humanoid.WalkSpeed
local noclipSpeed     = normalWalkSpeed + 12

-- Estado
local noclip = false
local COLLISION_GROUP = "NoClipGroup"

-- Asegúrate de que existe el CollisionGroup y que Default no colisione con él
if not pcall(function() PhysicsService:GetCollisionGroupId(COLLISION_GROUP) end) then
    PhysicsService:CreateCollisionGroup(COLLISION_GROUP)
    PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP, "Default", false)
end

-- Función para togglear noclip
local function setNoclip(active)
    noclip = active
    humanoid.WalkSpeed = active and noclipSpeed or normalWalkSpeed

    -- Asignar cada parte al grupo o devolverla a Default,
    -- pero EXCLUYENDO el HumanoidRootPart para que siga colisionando con el suelo
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part ~= rootPart then
            PhysicsService:SetPartCollisionGroup(part, active and COLLISION_GROUP or "Default")
        end
    end

    -- Opcional: mantener siempre salud al máximo
    if not active then
        humanoid.Health = humanoid.MaxHealth
    end
end

-- Hook para restaurar salud si quisieras, pero no usamos PlatformStand
RunService.Heartbeat:Connect(function()
    if noclip and humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
    end
end)

-- Creación de la interfaz
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "NoclipGui"

local button = Instance.new("TextButton")
button.Size               = UDim2.new(0, 160, 0, 50)
button.Position           = UDim2.new(0, 20, 0, 80)
button.TextSize           = 20
button.Font               = Enum.Font.SourceSansBold
button.BorderSizePixel    = 0
button.BackgroundTransparency = 0.15
button.Parent             = screenGui

local function updateButton()
    if noclip then
        button.Text             = "Desactivar Noclip"
        button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    else
        button.Text             = "Activar Noclip"
        button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    end
end

button.MouseButton1Click:Connect(function()
    setNoclip(not noclip)
    updateButton()
end)

-- Inicializa texto/color
updateButton()
