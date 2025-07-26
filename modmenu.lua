--[[ 
  LocalScript: AntiCleanTools v3 (para servidores públicos)
  Colócalo en StarterPlayer → StarterPlayerScripts
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player   = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- Carpeta de respaldo oculta
local backup = ReplicatedStorage:FindFirstChild("__TB")
if not backup then
    backup = Instance.new("Folder")
    backup.Name = "__TB"
    backup.Archivable = false
    backup:SetAttribute("P", true)
    backup.Parent = ReplicatedStorage
end

local function backupTool(tool)
    if tool:IsA("Tool") and not backup:FindFirstChild(tool.Name) then
        local c = tool:Clone()
        c.Parent = backup
    end
end

-- Inicial
for _, t in ipairs(backpack:GetChildren()) do
    backupTool(t)
end
backpack.ChildAdded:Connect(backupTool)

-- Restauración
local function watchContainer(cont)
    cont.ChildRemoved:Connect(function(old)
        if old:IsA("Tool") then
            RunService.Heartbeat:Wait()
            local st = backup:FindFirstChild(old.Name)
            if st then st:Clone().Parent = backpack end
        end
    end)
end

watchContainer(backpack)
player.CharacterAdded:Connect(function(c)
    watchContainer(c)
end)
if player.Character then watchContainer(player.Character) end

-- Hook dinámico
local function applyHooks()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNC = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod():lower()
        if self:IsA and self:IsA("Tool") then
            if m == "destroy" or m == "remove" or m == "clearallchildren" then
                return nil
            end
            if m == "setattribute" and select(1, ...) == "Parent" then
                return nil
            end
        end
        return oldNC(self, ...)
    end)
    setreadonly(mt, true)
end

applyHooks()

-- Neutralizar eventos “de limpieza”
local function neutralizar()
    for _, srv in ipairs({workspace, ReplicatedStorage}) do
        for _, obj in ipairs(srv:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local n = obj.Name:lower()
                if n:match("clean") or n:match("remove") or n:match("delete") or n:match("clear") then
                    pcall(function() obj.OnClientEvent:ClearAllListeners() end)
                    pcall(function() obj.OnClientInvoke = function() end end)
                end
            end
        end
    end
end

neutralizar()
spawn(function()
    while true do
        task.wait(5)
        applyHooks()
        neutralizar()
    end
end)

print("[AntiCleanTools] Protección activa para servidores públicos.")

