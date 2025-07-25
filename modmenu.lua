-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local function getCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart")
    return char
end

-- Posición guardada
local savedCFrame = nil

-- Crear menú con botones
local function setupGui()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "TeleporterGui"
    gui.ResetOnSpawn = false

    local function makeButton(name, yPos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 200, 0, 50)
        btn.Position = UDim2.new(0, 20, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 20
        btn.Text = name
        btn.Parent = gui
        return btn
    end

    -- Botón para guardar posición
    local btnSave = makeButton("Guardar posición", 80)
    btnSave.MouseButton1Click:Connect(function()
        local hrp = getCharacter():FindFirstChild("HumanoidRootPart")
        if hrp then
            savedCFrame = hrp.CFrame
            btnSave.Text = "Posición guardada ✅"
            task.delay(1, function()
                btnSave.Text = "Guardar posición"
            end)
        end
    end)

    -- Botón para teletransportarse
    local btnTeleport = makeButton("Ir a posición", 150)
    btnTeleport.MouseButton1Click:Connect(function()
        if savedCFrame then
            local char = getCharacter()
            char:PivotTo(savedCFrame)
        else
            btnTeleport.Text = "No hay posición 💡"
            task.delay(1, function()
                btnTeleport.Text = "Ir a posición"
            end)
        end
    end)
end

-- Iniciar GUI
if player:FindFirstChild("PlayerGui") then
    setupGui()
else
    player.CharacterAdded:Wait()
    setupGui()
end
