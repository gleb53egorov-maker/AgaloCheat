-- AgaloCheat v1.0 - Created by Kast13l
-- GitHub: https://github.com/gleb53egorov-maker/AgaloCheat

local AgaloCheat = {
    Version = "1.0 (Stable)",
    Creator = "Kast13l",
    PlayerName = "Loading...",
    LastUpdate = "2024"
}

-- Автоматическое определение ника
local function GetPlayerUsername()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    if localPlayer then
        return localPlayer.Name
    else
        players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        return players.LocalPlayer.Name
    end
end

-- Анимация загрузки
local function LoaderAnimation()
    local loadingSteps = {
        "╔══════════════════════════╗",
        "║      AgaloCheat v1.0     ║",
        "║     Created by Kast13l   ║",
        "╚══════════════════════════╝",
        "🔧 Initializing System...",
        "👤 Loading Player Data...",
        "🎮 Setting Up Interface...",
        "⚡ Loading Features...",
        "╔══════════════════════════╗",
        "║       READY TO USE!      ║",
        "╚══════════════════════════╝"
    }
    
    for i, step in ipairs(loadingSteps) do
        if i == 6 then
            AgaloCheat.PlayerName = GetPlayerUsername()
            print("[Agalo] Player: " .. AgaloCheat.PlayerName)
        end
        print("[Agalo] " .. step)
        wait(0.8)
    end
end

-- Конфигурация
local Config = {
    ESP = {
        Enabled = true,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        Tracers = false
    },
    Visuals = {
        ThirdPerson = false,
        ThirdPersonDistance = 10,
        FOV = 80,
        NoFog = true,
        FullBright = true
    },
    Movement = {
        Speed = false,
        SpeedValue = 25,
        Bhop = false,
        HighJump = false,
        JumpPower = 50
    },
    Combat = {
        Crosshair = true,
        CrosshairType = "Dot",
        NoRecoil = false,
        RapidFire = false
    },
    Misc = {
        Clock = true,
        FPS = true
    }
}

-- Профессиональный ESP
local function InitializeESP()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    local espObjects = {}
    local tracerObjects = {}
    
    local function createESP(player)
        if player == localPlayer then return end
        
        espObjects[player] = {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            Health = Drawing.new("Text"),
            Distance = Drawing.new("Text"),
            BoxFill = Drawing.new("Square")
        }
        
        local esp = espObjects[player]
        
        -- Основной бокс
        esp.Box.Thickness = 2
        esp.Box.Filled = false
        
        -- Заполненный бокс (полупрозрачный)
        esp.BoxFill.Thickness = 1
        esp.BoxFill.Filled = true
        esp.BoxFill.Transparency = 0.3
        
        -- Текст
        esp.Name.Size = 14
        esp.Name.Outline = true
        esp.Name.OutlineColor = Color3.new(0, 0, 0)
        
        esp.Health.Size = 12
        esp.Health.Outline = true
        esp.Health.OutlineColor = Color3.new(0, 0, 0)
        
        esp.Distance.Size = 12
        esp.Distance.Outline = true
        esp.Distance.OutlineColor = Color3.new(0, 0, 0)
    end
    
    local function updateESP()
        for player, esp in pairs(espObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                local rootPart = player.Character.HumanoidRootPart
                local humanoid = player.Character.Humanoid
                local head = player.Character:FindFirstChild("Head")
                
                if rootPart and humanoid and head then
                    local position, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                    
                    if onScreen then
                        local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
                        local scale = 1000 / distance
                        local boxWidth = 20 * scale
                        local boxHeight = 40 * scale
                        
                        local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local feetPos = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                        
                        local boxY = feetPos.Y
                        local boxHeight = math.abs(headPos.Y - feetPos.Y)
                        local boxWidth = boxHeight / 2
                        
                        -- Цвет в зависимости от здоровья
                        local health = humanoid.Health
                        local maxHealth = humanoid.MaxHealth
                        local healthPercent = health / maxHealth
                        
                        local color = Color3.new(1, 1, 1)
                        if healthPercent > 0.7 then
                            color = Color3.new(0, 1, 0) -- Зеленый
                        elseif healthPercent > 0.3 then
                            color = Color3.new(1, 1, 0) -- Желтый
                        else
                            color = Color3.new(1, 0, 0) -- Красный
                        end
                        
                        -- Бокс ESP
                        if Config.ESP.Boxes then
                            esp.Box.Visible = true
                            esp.Box.Color = color
                            esp.Box.Position = Vector2.new(headPos.X - boxWidth/2, headPos.Y - boxHeight)
                            esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                            
                            esp.BoxFill.Visible = true
                            esp.BoxFill.Color = color
                            esp.BoxFill.Position = Vector2.new(headPos.X - boxWidth/2, headPos.Y - boxHeight)
                            esp.BoxFill.Size = Vector2.new(boxWidth, boxHeight)
                        else
                            esp.Box.Visible = false
                            esp.BoxFill.Visible = false
                        end
                        
                        -- Имя игрока
                        if Config.ESP.Names then
                            esp.Name.Visible = true
                            esp.Name.Color = color
                            esp.Name.Position = Vector2.new(headPos.X, headPos.Y - boxHeight - 20)
                            esp.Name.Text = player.Name
                        else
                            esp.Name.Visible = false
                        end
                        
                        -- Здоровье
                        if Config.ESP.Health then
                            esp.Health.Visible = true
                            esp.Health.Color = color
                            esp.Health.Position = Vector2.new(headPos.X, headPos.Y - boxHeight - 5)
                            esp.Health.Text = "HP: " .. math.floor(health)
                        else
                            esp.Health.Visible = false
                        end
                        
                        -- Дистанция
                        if Config.ESP.Distance then
                            esp.Distance.Visible = true
                            esp.Distance.Color = color
                            esp.Distance.Position = Vector2.new(headPos.X, headPos.Y + boxHeight + 5)
                            esp.Distance.Text = math.floor(distance) .. "m"
                        else
                            esp.Distance.Visible = false
                        end
                    else
                        for _, drawing in pairs(esp) do
                            drawing.Visible = false
                        end
                    end
                else
                    for _, drawing in pairs(esp) do
                        drawing.Visible = false
                    end
                end
            else
                for _, drawing in pairs(esp) do
                    drawing.Visible = false
                end
            end
        end
    end
    
    -- Инициализация ESP для всех игроков
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            createESP(player)
        end
    end
    
    players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then
            createESP(player)
        end
    end)
    
    players.PlayerRemoving:Connect(function(player)
        if espObjects[player] then
            for _, drawing in pairs(espObjects[player]) do
                drawing:Remove()
            end
            espObjects[player] = nil
        end
    end)
    
    -- Цикл обновления ESP
    game:GetService("RunService").RenderStepped:Connect(updateESP)
end

-- Вид от третьего лица
local function ThirdPerson()
    local camera = workspace.CurrentCamera
    local originalOffset = camera.CFrame
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Visuals.ThirdPerson then
            local character = game:GetService("Players").LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                local offset = CFrame.new(root.Position - root.CFrame.LookVector * Config.Visuals.ThirdPersonDistance)
                camera.CFrame = offset
                camera.CameraType = Enum.CameraType.Scriptable
            end
        else
            camera.CameraType = Enum.CameraType.Custom
        end
    end)
end

-- Bunny Hop (Auto Jump)
local function BunnyHop()
    local UIS = game:GetService("UserInputService")
    local player = game:GetService("Players").LocalPlayer
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Movement.Bhop then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)
end

-- Speed Hack
local function SpeedHack()
    local player = game:GetService("Players").LocalPlayer
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Movement.Speed then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Config.Movement.SpeedValue
                end
            end
        end
    end)
end

-- High Jump
local function HighJump()
    local player = game:GetService("Players").LocalPlayer
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Movement.HighJump then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = Config.Movement.JumpPower
                end
            end
        end
    end)
end

-- Кастомный прицел
local function CustomCrosshair()
    local crosshair = Drawing.new("Circle")
    crosshair.Visible = false
    crosshair.Thickness = 2
    crosshair.Color = Color3.new(1, 1, 1)
    crosshair.NumSides = 64
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Combat.Crosshair then
            crosshair.Visible = true
            crosshair.Position = Vector2.new(
                workspace.CurrentCamera.ViewportSize.X / 2,
                workspace.CurrentCamera.ViewportSize.Y / 2
            )
            
            if Config.Combat.CrosshairType == "Dot" then
                crosshair.Radius = 2
                crosshair.Filled = true
            elseif Config.Combat.CrosshairType == "Circle" then
                crosshair.Radius = 8
                crosshair.Filled = false
            elseif Config.Combat.CrosshairType == "Cross" then
                -- Можно добавить крестообразный прицел
                crosshair.Radius = 6
                crosshair.Filled = false
            end
        else
            crosshair.Visible = false
        end
    end)
    
    return crosshair
end

-- Часы и FPS
local function ClockAndFPS()
    local clockText = Drawing.new("Text")
    clockText.Visible = false
    clockText.Size = 16
    clockText.Color = Color3.new(1, 1, 1)
    clockText.Outline = true
    clockText.OutlineColor = Color3.new(0, 0, 0)
    
    local fpsText = Drawing.new("Text")
    fpsText.Visible = false
    fpsText.Size = 16
    fpsText.Color = Color3.new(1, 1, 1)
    fpsText.Outline = true
    fpsText.OutlineColor = Color3.new(0, 0, 0)
    
    local frameCount = 0
    local lastTime = tick()
    
    game:GetService("RunService").RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            frameCount = 0
            lastTime = currentTime
            
            if Config.Misc.FPS then
                fpsText.Visible = true
                fpsText.Text = "FPS: " .. fps
                fpsText.Position = Vector2.new(10, 30)
            else
                fpsText.Visible = false
            end
        end
        
        if Config.Misc.Clock then
            clockText.Visible = true
            local time = os.date("%H:%M:%S")
            clockText.Text = "Time: " .. time
            clockText.Position = Vector2.new(10, 10)
        else
            clockText.Visible = false
        end
    end)
end

-- No Fog & Full Bright
local function VisualEnhancements()
    if Config.Visuals.NoFog then
        game:GetService("Lighting").FogEnd = 1000000
    end
    
    if Config.Visuals.FullBright then
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Brightness = 2
    end
end

-- Профессиональный интерфейс
local function CreateProfessionalUI()
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    -- Основной GUI
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "AgaloCheatUI"
    mainGui.Parent = game:GetService("CoreGui")
    
    -- Главное окно
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainGui
    
    -- Заголовок
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "AgaloCheat v1.0 | by Kast13l"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = header
    
    -- Вкладки
    local tabs = {"ESP", "Visuals", "Movement", "Combat", "Misc"}
    local currentTab = "ESP"
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    -- Контент
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -70)
    contentFrame.Position = UDim2.new(0, 0, 0, 70)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Функция создания переключателя
    local function CreateToggle(parent, name, configCategory, configKey, position)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 30)
        toggleFrame.Position = position
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 25)
        toggle.Position = UDim2.new(0.7, 0, 0.5, -12)
        toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 70)
        toggle.Text = ""
        toggle.BorderSizePixel = 0
        toggle.Parent = toggleFrame
        
        local toggleSlider = Instance.new("Frame")
        toggleSlider.Size = UDim2.new(0, 21, 0, 21)
        toggleSlider.Position = UDim2.new(0, Config[configCategory][configKey] and 27 or 2, 0.5, -10)
        toggleSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleSlider.BorderSizePixel = 0
        toggleSlider.Parent = toggle
        
        toggle.MouseButton1Click:Connect(function()
            Config[configCategory][configKey] = not Config[configCategory][configKey]
            
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(toggleSlider, tweenInfo, {
                Position = UDim2.new(0, Config[configCategory][configKey] and 27 or 2, 0.5, -10)
            })
            
            tween:Play()
            
            toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 70)
        end)
        
        return toggleFrame
    end
    
    -- Функция создания слайдера
    local function CreateSlider(parent, name, configCategory, configKey, min, max, position)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -20, 0, 50)
        sliderFrame.Position = position
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name .. ": " .. Config[configCategory][configKey]
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame
        
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, 0, 0, 5)
        slider.Position = UDim2.new(0, 0, 0, 30)
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        slider.BorderSizePixel = 0
        slider.Parent = sliderFrame
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((Config[configCategory][configKey] - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = slider
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 15, 0, 15)
        sliderButton.Position = UDim2.new((Config[configCategory][configKey] - min) / (max - min), -7, 0, -5)
        sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderButton.Text = ""
        sliderButton.BorderSizePixel = 0
        sliderButton.Parent = sliderFrame
        
        local function updateSlider(input)
            local relativeX = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            
            local value = min + (max - min) * relativeX
            Config[configCategory][configKey] = math.floor(value)
            
            label.Text = name .. ": " .. Config[configCategory][configKey]
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -7, 0, -5)
        end
        
        sliderButton.MouseButton1Down:Connect(function()
            local connection
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    connection:Disconnect()
                end
            end)
        end)
        
        return sliderFrame
    end
    
    -- Создание вкладок
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1 / #tabs, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1) / #tabs, 0, 0, 0)
        tabButton.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(25, 25, 30)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 12
        tabButton.Font = Enum.Font.Gotham
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabContainer
        
        tabButton.MouseButton1Click:Connect(function()
            currentTab = tabName
            -- Здесь будет логика переключения вкладок
        end)
    end
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 12
    closeButton.BorderSizePixel = 0
    closeButton.Parent = header
    
    closeButton.MouseButton1Click:Connect(function()
        mainGui:Destroy()
    end)
    
    return mainGui
end

-- Основная функция
local function Main()
    print("╔══════════════════════════════╗")
    print("║      AgaloCheat v1.0         ║")
    print("║     Created by: Kast13l      ║")
    print("╚══════════════════════════════╝")
    
    LoaderAnimation()
    
    -- Инициализация всех функций
    InitializeESP()
    ThirdPerson()
    BunnyHop()
    SpeedHack()
    HighJump()
    CustomCrosshair()
    ClockAndFPS()
    VisualEnhancements()
    CreateProfessionalUI()
    
    print("[Agalo] All features loaded successfully!")
    print("[Agalo] Player: " .. AgaloCheat.PlayerName)
    print("[Agalo] Enjoy using AgaloCheat! 🚀")
end

-- Запуск
Main()
