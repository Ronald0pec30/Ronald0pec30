-- Mod Menu: Noclip, Velocidad, Super Salto (compatible con juegos tipo Steal a Brainrot)

local Players        = game:GetService("Players") local RunService     = game:GetService("RunService") local PhysicsService = game:GetService("PhysicsService")

local player         = Players.LocalPlayer local character      = player.Character or player.CharacterAdded:Wait() local humanoid       = character:WaitForChild("Humanoid") local rootPart       = character:WaitForChild("HumanoidRootPart")

-- Estados local noclip = false local fastSpeed = false local superJump = false

local NORMAL_SPEED = 16 local FAST_SPEED = 40 local NORMAL_JUMP = 50 local SUPER_JUMP = 120 local COLLISION_GROUP = "NoClipGroup"

-- Crear grupo de colisiones si no existe if not pcall(function() PhysicsService:GetCollisionGroupId(COLLISION_GROUP) end) then PhysicsService:CreateCollisionGroup(COLLISION_GROUP) PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP, "Default", false) end

-- Noclip toggle local function toggleNoclip(active) noclip = active for _, part in ipairs(character:GetDescendants()) do if part:IsA("BasePart") and part ~= rootPart then PhysicsService:SetPartCollisionGroup(part, active and COLLISION_GROUP or "Default") end end end

-- Velocidad toggle local function toggleSpeed(active) fastSpeed = active humanoid.WalkSpeed = active and FAST_SPEED or NORMAL_SPEED end

-- Super salto toggle local function toggleJump(active) superJump = active humanoid.JumpPower = active and SUPER_JUMP or NORMAL_JUMP end

-- GUI principal local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")) screenGui.Name = "ModMenuGui"

local function createButton(text, position, callback) local button = Instance.new("TextButton") button.Size = UDim2.new(0, 180, 0, 40) button.Position = position button.Text = text button.TextSize = 18 button.Font = Enum.Font.SourceSansBold button.BackgroundColor3 = Color3.fromRGB(60, 60, 200) button.TextColor3 = Color3.new(1, 1, 1) button.Parent = screenGui button.MouseButton1Click:Connect(callback) return button end

local noclipBtn = createButton("[Noclip] OFF", UDim2.new(0, 20, 0, 80), function() noclip = not noclip toggleNoclip(noclip) noclipBtn.Text = noclip and "[Noclip] ON" or "[Noclip] OFF" end)

local speedBtn = createButton("[Speed] OFF", UDim2.new(0, 20, 0, 130), function() fastSpeed = not fastSpeed toggleSpeed(fastSpeed) speedBtn.Text = fastSpeed and "[Speed] ON" or "[Speed] OFF" end)

local jumpBtn = createButton("[Super Jump] OFF", UDim2.new(0, 20, 0, 180), function() superJump = not superJump toggleJump(superJump) jumpBtn.Text = superJump and "[Super Jump] ON" or "[Super Jump] OFF" end)

-- Inicialización humanoid.WalkSpeed = NORMAL_SPEED humanoid.JumpPower = NORMAL_JUMP

-- Reasignar si el personaje reaparece player.CharacterAdded:Connect(function(char) character = char humanoid = character:WaitForChild("Humanoid") rootPart = character:WaitForChild("HumanoidRootPart") toggleSpeed(fastSpeed) toggleJump(superJump) toggleNoclip(noclip) end)

-- Mantener salud RunService.Heartbeat:Connect(function() if noclip and humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end end)

print("✅ Mod Menu Cargado correctamente")
