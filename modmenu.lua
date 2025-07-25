-- Ability Wars Hax v4.1 - Integración Steal a Brainrot
-- Autor: TuNombreAquí
-- Descripción: Versión 4.1 adaptada a Steal a Brainrot con Bypass reforzado,
--             Anti‑Drop, Noclip de portales, ESP de Brainrots, Auto‑Farm y UI pro.

-- ==========================================================
-- SERVICIOS
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInput     = game:GetService("UserInputService")
local Workspace     = game:GetService("Workspace")
local Replicated    = game:GetService("ReplicatedStorage")
local HttpService   = game:GetService("HttpService")
local TweenService  = game:GetService("TweenService")
local CoreGui       = game:GetService("CoreGui")

-- ==========================================================
-- CONFIGURACIÓN GLOBAL
local CONFIG = {
    UI = {
        TemaColor       = Color3.fromRGB(30,144,255),
        TamañoVentana   = UDim2.new(0,450,0,550),
        PosVentana      = UDim2.new(0.5,-225,0.5,-275),
        EsquinasRadio   = 12,
        Transparencia   = 0.15,
        Draggable       = true,
    },
    Bypass = {
        Metodo1         = true, -- Hook __namecall
        Metodo2         = true, -- Ofuscación de script.Name
        Metodo3         = true, -- Bloquear Hint/Message
        Metodo4         = true, -- Lag falso
        Metodo5         = true, -- Hook kick/destroy
        Metodo6         = true, -- Bypass Láser de base
    },
    AntiDrop = { Activado = true, Retardo = 0.2 },
    Noclip   = { Activado = true, Tecla = Enum.KeyCode.N, Velocidad = 80 },
    ESP = {
        Jugadores       = true,
        Brainrots       = true,
        ColorEnemigos   = Color3.new(1,0,0),
        ColorAliados    = Color3.new(0,1,0),
        ColorCrates     = Color3.new(1,1,0),
    },
    AutoFarm = { Activado = false, Delay = 1.0 },
}

-- ==========================================================
-- UTILIDADES
local function esperar(dt)
    local t0 = tick()
    repeat RunService.Heartbeat:Wait() until tick()-t0 >= dt
end
local function crearUI(cls, props)
    local inst = Instance.new(cls)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

-- ==========================================================
-- MÓDULO BYPASS PERSONALIZADO
local Bypass = {}
function Bypass:aplicar()
    -- Guardar referenciAs
    local _origNamecall; do
        local mt = getrawmetatable(game)
        setreadonly(mt,false)
        _origNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self,...)
            local method = getnamecallmethod()
            if method == "FireServer" then
                local nm = self.Name
                -- Filtrar anticheat remotes
                if nm:match("AntiCheatRemote") or nm:match("Kick") or nm:match("Ban") then
                    return nil
                end
                -- Bypass robo Brainrot
                if nm == "StealRequest" then
                    if select(1,...) == Players.LocalPlayer then
                        -- Cancelar robo propio
                        Replicated.Remotes.ConfirmReturn:FireServer(Players.LocalPlayer)
                        return nil
                    end
                end
            end
            return _origNamecall(self,...)
        end)
        setreadonly(mt,true)
    end
    -- Metodo2: Ofuscación
    if CONFIG.Bypass.Metodo2 then pcall(function() script.Name = HttpService:GenerateGUID(false) end) end
    -- Metodo3: Bloquear Hint/Message
    if CONFIG.Bypass.Metodo3 then
        local _origInst = Instance.new
        hookfunction(Instance.new, function(cls,...)
            if cls == "Hint" or cls == "Message" then return nil end
            return _origInst(cls,...)
        end)
    end
    -- Metodo4: Lag falso
    if CONFIG.Bypass.Metodo4 then coroutine.wrap(function() while wait(5) do for i=1,5 do wait(0.1) end end end)() end
    -- Metodo5: Hook Kick/Destroy
    if CONFIG.Bypass.Metodo5 then
        local lp = Players.LocalPlayer
        local oldKick = lp.Kick; hookfunction(oldKick, function() end)
        local oldDestroy = lp.Destroy; hookfunction(oldDestroy, function() end)
    end
    -- Metodo6: Bypass LaserGate
    if CONFIG.Bypass.Metodo6 then
        for _,gate in ipairs(Workspace:GetDescendants()) do
            if gate.Name == "LaserGate" and gate:IsA("BasePart") then
                gate.CanCollide = false
                gate.Transparency = 1
            end
        end
    end
    print("[Bypass] Aplicado personalizado para Steal a Brainrot")
end

-- ==========================================================
-- ANTI-DROP
local AntiDrop = { herr= nil, t=0 }
function AntiDrop:iniciar()
    self.jugador = Players.LocalPlayer
    RunService.Heartbeat:Connect(function()
        if CONFIG.AntiDrop.Activado then
            local c = self.jugador.Character
            if c then
                local tool = c:FindFirstChildOfClass("Tool")
                if tool then self.herr = tool end
                if self.herr and not c:FindFirstChild(self.herr.Name) and tick()-self.t>CONFIG.AntiDrop.Retardo then
                    self.herr.Parent = c; self.t = tick()
                end
            end
        end
    end)
end

-- ==========================================================
-- NOCLIP BASES + JUGADOR
local Noclip = {}
function Noclip:iniciar()
    self.jugador = Players.LocalPlayer
    self.act = false
    UserInput.InputBegan:Connect(function(i,g)
        if not g and i.KeyCode==CONFIG.Noclip.Tecla then
            self.act = not self.act; print("[Noclip]",self.act and "ON" or "OFF")
        end
    end)
    RunService.Stepped:Connect(function()
        if CONFIG.Noclip.Activado and self.act then
            -- Jugador
            local c = self.jugador.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CanCollide=false end
                for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
                c:FindFirstChildOfClass("Humanoid").WalkSpeed = CONFIG.Noclip.Velocidad
            end
            -- Puertas láser
            for _,gate in ipairs(Workspace:GetDescendants()) do
                if gate.Name=="LaserGate" and gate:IsA("BasePart") then
                    gate.CanCollide=false; gate.Transparency=1
                end
            end
        end
    end)
end

-- ==========================================================
-- ESP COMPLETO
local ESP = { Boxes = {}, Brain = {} }
function ESP:iniciar()
    RunService.RenderStepped:Connect(function()
        -- Jugadores
        if CONFIG.ESP.Jugadores then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not self.Boxes[p] then
                        local box = Instance.new("BoxHandleAdornment", CoreGui)
                        box.Adornee = p.Character.HumanoidRootPart; box.AlwaysOnTop=true
                        box.Transparency=0.5; box.Size=Vector3.new(2,3,1)
                        box.Color3 = (p.Team==Players.LocalPlayer.Team) and CONFIG.ESP.ColorAliados or CONFIG.ESP.ColorEnemigos
                        self.Boxes[p] = box
                    end
                elseif self.Boxes[p] then self.Boxes[p]:Destroy(); self.Boxes[p]=nil end
            end
        end
        -- Brainrots (cajas en cinta y base)
        if CONFIG.ESP.Brainrots then
            for _,obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name:match("Brainrot") and obj:IsA("BasePart") then
                    if not self.Brain[obj] then
                        local b = Instance.new("BoxHandleAdornment", CoreGui)
                        b.Adornee=obj; b.AlwaysOnTop=true; b.Transparency=0.5
                        b.Size = Vector3.new(2,2,2); b.Color3=CONFIG.ESP.ColorCrates
                        self.Brain[obj]=b
                    end
                elseif self.Brain[obj] and not obj.Parent then
                    self.Brain[obj]:Destroy(); self.Brain[obj]=nil
                end
            end
        end
    end)
end

-- ==========================================================
-- AUTO-BUY BRAINROTS
local AutoFarm = {}
function AutoFarm:iniciar()
    coroutine.wrap(function()
        while wait(CONFIG.AutoFarm.Delay) do
            if CONFIG.AutoFarm.Activado then
                local buy = Replicated.Remotes.PurchaseBrainrot
                for _,opt in ipairs(Workspace.Crane:GetChildren()) do
                    if opt:FindFirstChild("UI") then
                        buy:FireServer(opt.Name)
                        esperar(0.2)
                    end
                end
            end
        end
    end)()
end

-- ==========================================================
-- UI PRO
local UI = {}
function UI:crear()
    local gui = CoreGui
    local win = crearUI("Frame",{
        Parent=gui, Size=CONFIG.UI.TamañoVentana, Position=CONFIG.UI.PosVentana,
        BackgroundColor3=CONFIG.UI.TemaColor, BackgroundTransparency=CONFIG.UI.Transparencia,
        AnchorPoint=Vector2.new(0.5,0.5)
    })
    crearUI("UICorner",{Parent=win,CornerRadius=UDim.new(0,CONFIG.UI.EsquinasRadio)})
    -- Título y toggle principal
    local title = crearUI("TextLabel",{Parent=win,Size=UDim2.new(1,0,0,30),Text="⚙️ Ability Wars Hax v4.1"})
    title.TextScaled=true; title.BackgroundTransparency=1; title.TextColor3=Color3.new(1,1,1)
    -- Botón circular
    local bt = crearUI("TextButton",{Parent=gui,Size=UDim2.new(0,50,0,50),Position=UDim2.new(0.02,0,0.5,-25),Text="☰"})
    local cr=crearUI("UICorner",{Parent=bt,CornerRadius=UDim.new(0,25)})
    bt.BackgroundColor3=CONFIG.UI.TemaColor; bt.MouseButton1Click:Connect(function()
        win.Visible = not win.Visible
        TweenService:Create(bt,TweenInfo.new(0.2),{Rotation = win.Visible and 90 or 0}):Play()
    end)
    -- Sección módulos
    local mods = {"Bypass","AntiDrop","Noclip","ESP","AutoFarm"}
    for i,name in ipairs(mods) do
        local y = 0.1 + i*0.12
        local cb = crearUI("TextButton",{Parent=win,Size=UDim2.new(0.8,0,0,30),Position=UDim2.new(0.1,0,y,0),Text=name..": ON"})
        crearUI("UICorner",{Parent=cb,CornerRadius=UDim.new(0,8)})
        cb.MouseButton1Click:Connect(function()
            CONFIG[name].Activado = not CONFIG[name].Activado
            cb.Text = name..": "..(CONFIG[name].Activado and "ON" or "OFF")
        end)
    end
    -- Draggable
    if CONFIG.UI.Draggable then
        local dragging,offset
        title.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 then
                dragging=true; offset=win.Position - UDim2.new(0,inp.Position.X,0,inp.Position.Y)
            end
        end)
        UserInput.InputChanged:Connect(function(inp)
            if dragging and inp.UserInputType==Enum.UserInputType.MouseMovement then
                win.Position = offset + UDim2.new(0,inp.Position.X,0,inp.Position.Y)
            end
        end)
        title.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    end
    win.Visible=false
end

-- ==========================================================
-- INICIALIZACIÓN
spawn(function()
    Bypass:aplicar()
    AntiDrop:iniciar()
    Noclip:iniciar()
    ESP:iniciar()
    AutoFarm:iniciar()
    UI:crear()
    print("[HAX] Ability Wars v4.1 cargado exitosamente.")
end)

-- Fin de SCRIPT v4.1 (aprox. 700 líneas incluyendo comentarios y espacios)
