if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Servicios
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local LocalizationService = game:GetService("LocalizationService")

-- Función para cargar scripts de forma segura
local function cargarScript(url)
    local exito, resultado = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    if not exito then
        warn("[Error al cargar]:", url, resultado)
    end
end

-- Función para crear la interfaz de usuario
local function crearInterfaz()
    local gui = Instance.new("ScreenGui")
    gui.Name = "SelectorDeIdioma"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local marcoPrincipal = Instance.new("Frame")
    marcoPrincipal.Size = UDim2.new(0, 400, 0, 300)
    marcoPrincipal.Position = UDim2.new(0.5, -200, 0.5, -150)
    marcoPrincipal.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    marcoPrincipal.BorderSizePixel = 0
    marcoPrincipal.Parent = gui

    local titulo = Instance.new("TextLabel")
    titulo.Size = UDim2.new(1, 0, 0, 50)
    titulo.Text = "Selecciona tu idioma"
    titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
    titulo.Font = Enum.Font.SourceSansBold
    titulo.TextSize = 24
    titulo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titulo.BorderSizePixel = 0
    titulo.Parent = marcoPrincipal

    local contenedorBotones = Instance.new("Frame")
    contenedorBotones.Size = UDim2.new(1, -20, 0, 100)
    contenedorBotones.Position = UDim2.new(0, 10, 0, 60)
    contenedorBotones.BackgroundTransparency = 1
    contenedorBotones.Parent = marcoPrincipal

    local botonEspañol = Instance.new("TextButton")
    botonEspañol.Size = UDim2.new(0.5, -5, 1, -5)
    botonEspañol.Position = UDim2.new(0, 0, 0, 0)
    botonEspañol.Text = "Español"
    botonEspañol.TextColor3 = Color3.fromRGB(255, 255, 255)
    botonEspañol.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    botonEspañol.Font = Enum.Font.SourceSansBold
    botonEspañol.TextSize = 20
    botonEspañol.Parent = contenedorBotones

    local botonIngles = Instance.new("TextButton")
    botonIngles.Size = UDim2.new(0.5, -5, 1, -5)
    botonIngles.Position = UDim2.new(0.5, 5, 0, 0)
    botonIngles.Text = "Inglés"
    botonIngles.TextColor3 = Color3.fromRGB(255, 255, 255)
    botonIngles.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    botonIngles.Font = Enum.Font.SourceSansBold
    botonIngles.TextSize = 20
    botonIngles.Parent = contenedorBotones

    -- Función para manejar la selección de idioma
    local function seleccionarIdioma(idioma)
        local traductor = LocalizationService:GetTranslatorForLocaleAsync(idioma)
        traductor:Translate(gui, "Screen")
        gui:Destroy()
    end

    botonEspañol.MouseButton1Click:Connect(function()
        seleccionarIdioma("es")
    end)

    botonIngles.MouseButton1Click:Connect(function()
        seleccionarIdioma("en")
    end)
end

-- Crear la interfaz al iniciar el juego
crearInterfaz()

-- Función para teletransportarse a la cima
local function teletransportarACima()
    local personaje = player.Character or player.CharacterAdded:Wait()
    local humanoide = personaje:WaitForChild("Humanoid")
    local raizHumanoide = personaje:WaitForChild("HumanoidRootPart")

    -- Desactivar colisiones y anclar el personaje
    for _, parte in ipairs(personaje:GetDescendants()) do
        if parte:IsA("BasePart") then
            parte.CanCollide = false
        end
    end
    humanoide.PlatformStand = true
    raizHumanoide.Anchored = true

    -- Teletransportar al personaje a la cima
    raizHumanoide.CFrame = CFrame.new(0, 1000, 0)

    -- Rehabilitar colisiones y desanclar el personaje después de un breve retraso
    wait(2)
    for _, parte in ipairs(personaje:GetDescendants()) do
        if parte:IsA("BasePart") then
            parte.CanCollide = true
        end
    end
    humanoide.PlatformStand = false
    raizHumanoide.Anchored = false
end

-- Ejecutar la función de teletransportación
teletransportarACima()
