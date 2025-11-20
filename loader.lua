-- AgaloCheat v3.0 - Professional Edition
-- Created by Kast13l

local AgaloCheat = {
    Version = "3.0 (Professional)",
    Creator = "Kast13l",
    PlayerName = "Loading..."
}

-- === ЭКРАН ЗАГРУЗКИ ===
local function CreateLoadingScreen()
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "LoadingScreen"
    loadingGui.Parent = game:GetService("CoreGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = loadingGui
    
    -- Логотип
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 400, 0, 100)
    logo.Position = UDim2.new(0.5, -200, 0.3, -50)
    logo.BackgroundTransparency = 1
    logo.Text = "AGALOCHEAT"
    logo.TextColor3 = Color3.fromRGB(0, 200, 255)
    logo.TextSize = 42
    logo.Font = Enum.Font.GothamBlack
    logo.TextStrokeTransparency = 0.8
    logo.Parent = mainFrame
    
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 300, 0, 30)
    version.Position = UDim2.new(0.5, -150, 0.3, 60)
    version.BackgroundTransparency = 1
    version.Text = "v3.0 Professional Edition"
    version.TextColor3 = Color3.fromRGB(180, 180, 180)
    version.TextSize = 16
    version.Font = Enum.Font.Gotham
    version.Parent = mainFrame
    
    -- Прогресс бар
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0, 500, 0, 8)
    progressBg.Position = UDim2.new(0.5, -250, 0.6, 0)
    progressBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = mainFrame
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0, 500, 0, 30)
    statusText.Position = UDim2.new(0.5, -250, 0.6, 20)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Initializing..."
    statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
    statusText.TextSize = 16
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = mainFrame
    
    -- Анимация загрузки
    local steps = {
        "Loading Player Data...",
        "Initializing ESP System...",
        "Setting Up Visuals...",
        "Configuring AimBot...",
        "Preparing Interface...",
        "Finalizing Setup..."
    }
    
    coroutine.wrap(function()
        for i, step in ipairs(steps) do
            statusText.Text = step
            progressBar:TweenSize(
                UDim2.new(i / #steps, 0, 1, 0),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.6,
                true
            )
            wait(0.8)
        end
        
        -- Плавное исчезновение
        for i = 1, 25 do
            mainFrame.BackgroundTransparency = i / 25
            wait(0.03)
        end
        
        loadingGui:Destroy()
    end)()
    
    return loadingGui
end

-- Автоматическое определение ника
local function GetPlayerUsername()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    return localPlayer and localPlayer.Name or "Player"
end

-- Конфигурация
local Config = {
    ESP = {
        Enabled = true,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        Tracers = false,
        Skeletons = false
    },
    Visuals = {
        Chams = false,
        ChamsColor = Color3.fromRGB(255, 0, 0),
        Wireframe = false,
        FOV = 80,
        NoFog = true,
        FullBright = true
    },
    Movement = {
        Speed = false,
        SpeedValue = 23,
        Bhop = false,
        JumpPower = 50
    },
    Combat = {
        AimBot = false,
        AimKey = "MouseButton2",
        AimFOV = 50,
        AimSmoothness = 0.4,
        AimAt = "Head", -- Head, Torso
        Crosshair = true,
        CrosshairType = "Dot" -- Dot, Circle, Cross
    },
    Misc = {
        Clock = true,
        FPS = true
    }
}

-- === РАБОЧИЕ ФУНКЦИИ ===

-- Speed Hack (РАБОЧИЙ)
local function SpeedHack()
    local player = game:GetService("Players").LocalPlayer
    local defaultWalkSpeed = 16
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if Config.Movement.Speed then
                    humanoid.WalkSpeed = Config.Movement.SpeedValue
                else
                    if humanoid.WalkSpeed ~= defaultWalkSpeed then
                        humanoid.WalkSpeed = defaultWalkSpeed
                    end
                end
            end
        end
    end)
end

-- Bunny Hop (РАБОЧИЙ)
local function BunnyHop()
    local player = game:GetService("Players").LocalPlayer
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if Config.Movement.Bhop and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local UIS = game:GetService("UserInputService")
            
            if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.W) or 
                   UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.S) or 
                   UIS:IsKeyDown(Enum.KeyCode.D) then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)
end

-- High Jump (РАБОЧИЙ)
local function HighJump()
    local player = game:GetService("Players").LocalPlayer
    local defaultJumpPower = 50
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = Config.Movement.JumpPower
            end
        end
    end)
end

-- === ПРОФЕССИОНАЛЬНЫЙ ESP ===
local function InitializeESP()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    local espObjects = {}
    
    local function createESP(player)
        if player == localPlayer then return end
        
        espObjects[player] = {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            Health = Drawing.new("Text"),
            Distance = Drawing.new("Text"),
            HealthBar = Drawing.new("Square"),
            HealthBarBg = Drawing.new("Square")
        }
        
        local esp = espObjects[player]
        
        -- Настройка стилей
        esp.Box.Thickness = 2
        esp.Box.Filled = false
        
        esp.Name.Size = 14
        esp.Name.Outline = true
        esp.Name.OutlineColor = Color3.new(0, 0, 0)
        
        esp.Health.Size = 12
        esp.Health.Outline = true
        esp.Health.OutlineColor = Color3.new(0, 0, 0)
        
        esp.Distance.Size = 12
        esp.Distance.Outline = true
        esp.Distance.OutlineColor = Color3.new(0, 0, 0)
        
        -- Health Bar
        esp.HealthBarBg.Thickness = 1
        esp.HealthBarBg.Filled = true
        esp.HealthBarBg.Color = Color3.new(0, 0, 0)
        
        esp.HealthBar.Thickness = 1
        esp.HealthBar.Filled = true
    end
    
    local function updateESP()
        for player, esp in pairs(espObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local head = player.Character:FindFirstChild("Head")
                
                if rootPart and humanoid and head then
                    local headPos, headOnScreen = camera:WorldToViewportPoint(head.Position)
                    local rootPos, rootOnScreen = camera:WorldToViewportPoint(rootPart.Position)
                    
                    if headOnScreen then
                        local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
                        
                        -- Расчет размеров
                        local scale = math.clamp(2000 / distance, 0.5, 3)
                        local boxHeight = 35 * scale
                        local boxWidth = 18 * scale
                        
                        -- Цвет по здоровью
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
                        
                        -- Позиции элементов
                        local boxX = headPos.X - boxWidth / 2
                        local boxY = headPos.Y - boxHeight / 2
                        
                        -- Бокс ESP
                        esp.Box.Visible = Config.ESP.Enabled and Config.ESP.Boxes
                        esp.Box.Color = color
                        esp.Box.Position = Vector2.new(boxX, boxY)
                        esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                        
                        -- Имя игрока
                        esp.Name.Visible = Config.ESP.Enabled and Config.ESP.Names
                        esp.Name.Color = color
                        esp.Name.Position = Vector2.new(headPos.X, boxY - 18)
                        esp.Name.Text = player.Name
                        
                        -- Здоровье
                        esp.Health.Visible = Config.ESP.Enabled and Config.ESP.Health
                        esp.Health.Color = color
                        esp.Health.Position = Vector2.new(headPos.X, boxY + boxHeight + 2)
                        esp.Health.Text = math.floor(health) .. "/" .. math.floor(maxHealth)
                        
                        -- Дистанция
                        esp.Distance.Visible = Config.ESP.Enabled and Config.ESP.Distance
                        esp.Distance.Color = color
                        esp.Distance.Position = Vector2.new(headPos.X, boxY + boxHeight + 16)
                        esp.Distance.Text = math.floor(distance) .. "m"
                        
                        -- Health Bar
                        local barWidth = boxWidth
                        local barHeight = 3
                        local barX = boxX
                        local barY = boxY - 6
                        
                        esp.HealthBarBg.Visible = Config.ESP.Enabled and Config.ESP.Health
                        esp.HealthBarBg.Position = Vector2.new(barX, barY)
                        esp.HealthBarBg.Size = Vector2.new(barWidth, barHeight)
                        
                        esp.HealthBar.Visible = Config.ESP.Enabled and Config.ESP.Health
                        esp.HealthBar.Color = color
                        esp.HealthBar.Position = Vector2.new(barX, barY)
                        esp.HealthBar.Size = Vector2.new(barWidth * healthPercent, barHeight)
                        
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
    
    -- Инициализация ESP
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            createESP(player)
        end
    end
    
    players.PlayerAdded:Connect(createESP)
    players.PlayerRemoving:Connect(function(player)
        if espObjects[player] then
            for _, drawing in pairs(espObjects[player]) do
                drawing:Remove()
            end
            espObjects[player] = nil
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(updateESP)
end

-- === ТОЧНЫЙ AIMBOT ===
local function InitializeAimBot()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    local UIS = game:GetService("UserInputService")
    
    -- Визуализация FOV
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.new(1, 1, 1)
    fovCircle.Thickness = 2
    fovCircle.NumSides = 64
    
    local function findClosestTarget()
        local closestTarget = nil
        local closestDistance = Config.Combat.AimFOV
        local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local aimPart = player.Character:FindFirstChild(Config.Combat.AimAt)
                
                if humanoid and humanoid.Health > 0 and aimPart then
                    local screenPos, onScreen = camera:WorldToViewportPoint(aimPart.Position)
                    
                    if onScreen then
                        local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestTarget = aimPart
                        end
                    end
                end
            end
        end
        
        return closestTarget
    end
    
    game:GetService("RunService").RenderStepped:Connect(function()
        -- Обновляем FOV круг
        fovCircle.Visible = Config.Combat.AimBot
        fovCircle.Radius = Config.Combat.AimFOV
        fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        
        if Config.Combat.AimBot and UIS:IsMouseButtonPressed(Enum.UserInputType[Config.Combat.AimKey]) then
            local target = findClosestTarget()
            if target then
                local screenPos = camera:WorldToViewportPoint(target.Position)
                local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                
                local delta = (targetPos - mousePos) * Config.Combat.AimSmoothness
                mousemoverel(delta.X, delta.Y)
            end
        end
    end)
end

-- === CHAMS SYSTEM ===
local function InitializeChams()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    
    local chamsObjects = {}
    
    local function createChams(player)
        if player == localPlayer then return end
        
        chamsObjects[player] = {}
        
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "AgaloChams"
                    highlight.FillColor = Config.Visuals.ChamsColor
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Config.Visuals.ChamsColor
                    highlight.OutlineTransparency = 0
                    highlight.Enabled = Config.Visuals.Chams
                    highlight.Adornee = part
                    highlight.Parent = part
                    
                    table.insert(chamsObjects[player], highlight)
                end
            end
        end
    end
    
    local function updateChams()
        for player, highlights in pairs(chamsObjects) do
            for _, highlight in pairs(highlights) do
                highlight.Enabled = Config.Visuals.Chams
                highlight.FillColor = Config.Visuals.ChamsColor
                highlight.OutlineColor = Config.Visuals.ChamsColor
            end
        end
    end
    
    -- Инициализация Chams
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            createChams(player)
        end
    end
    
    players.PlayerAdded:Connect(createChams)
    players.PlayerRemoving:Connect(function(player)
        if chamsObjects[player] then
            for _, highlight in pairs(chamsObjects[player]) do
                highlight:Destroy()
            end
            chamsObjects[player] = nil
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(updateChams)
end

-- === ВИЗУАЛЬНЫЕ ФУНКЦИИ ===
local function CustomCrosshair()
    local crosshair = Drawing.new("Circle")
    crosshair.Visible = false
    crosshair.Thickness = 2
    crosshair.Color = Color3.new(1, 1, 1)
    crosshair.NumSides = 12
    
    game:GetService("RunService").RenderStepped:Connect(function()
        crosshair.Visible = Config.Combat.Crosshair
        crosshair.Position = Vector2.new(
            workspace.CurrentCamera.ViewportSize.X / 2,
            workspace.CurrentCamera.ViewportSize.Y / 2
        )
        
        if Config.Combat.CrosshairType == "Dot" then
            crosshair.Radius = 2
            crosshair.Filled = true
        elseif Config.Combat.CrosshairType == "Circle" then
            crosshair.Radius = 6
            crosshair.Filled = false
        end
    end)
end

local function ClockAndFPS()
    local clockText = Drawing.new("Text")
    clockText.Size = 16
    clockText.Outline = true
    clockText.Color = Color3.new(1, 1, 1)
    
    local fpsText = Drawing.new("Text")
    fpsText.Size = 16
    fpsText.Outline = true
    fpsText.Color = Color3.new(1, 1, 1)
    
    local frameCount = 0
    local lastTime = tick()
    
    game:GetService("RunService").RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            frameCount = 0
            lastTime = currentTime
            
            fpsText.Visible = Config.Misc.FPS
            fpsText.Text = "FPS: " .. fps
            fpsText.Position = Vector2.new(10, 30)
        end
        
        clockText.Visible = Config.Misc.Clock
        clockText.Text = "Time: " .. os.date("%H:%M:%S")
        clockText.Position = Vector2.new(10, 10)
    end)
end

local function VisualEnhancements()
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Visuals.NoFog then
            game:GetService("Lighting").FogEnd = 1000000
        else
            game:GetService("Lighting").FogEnd = 1000
        end
        
        if Config.Visuals.FullBright then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Brightness = 2
        else
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").Brightness = 1
        end
    end)
end

-- === ПРОФЕССИОНАЛЬНЫЙ ИНТЕРФЕЙС ===
local function CreateProfessionalUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "AgaloCheatUI"
    mainGui.Parent = game:GetService("CoreGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainGui
    
    -- Заголовок
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -70, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "AGALOCHEAT v3.0"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Parent = header
    
    -- Кнопка свернуть
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    minimizeBtn.Text = "─"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 18
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = header
    
    -- Кнопка закрыть
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header
    
    -- Вкладки
    local tabs = {"ESP", "Visuals", "Movement", "Combat", "Misc"}
    local currentTab = "ESP"
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    -- Контент
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, -70)
    contentFrame.Position = UDim2.new(0, 0, 0, 70)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
    contentFrame.Parent = mainFrame
    
    -- Функция создания переключателя
    local function CreateToggle(parent, name, configCategory, configKey, yPosition)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -30, 0, 30)
        toggleFrame.Position = UDim2.new(0, 15, 0, yPosition)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 24)
        toggle.Position = UDim2.new(0.7, 0, 0.5, -12)
        toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(70, 70, 80)
        toggle.Text = ""
        toggle.BorderSizePixel = 0
        toggle.Parent = toggleFrame
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
        toggleIndicator.Position = UDim2.new(0, Config[configCategory][configKey] and 28 or 2, 0.5, -10)
        toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Parent = toggle
        
        toggle.MouseButton1Click:Connect(function()
            Config[configCategory][configKey] = not Config[configCategory][configKey]
            toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(70, 70, 80)
            
            toggleIndicator:TweenPosition(
                UDim2.new(0, Config[configCategory][configKey] and 28 or 2, 0.5, -10),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.15,
                true
            )
        end)
        
        return toggleFrame
    end
    
    -- Функция создания слайдера (РАБОЧИЙ)
    local function CreateSlider(parent, name, configCategory, configKey, min, max, yPosition)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -30, 0, 50)
        sliderFrame.Position = UDim2.new(0, 15, 0, yPosition)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name .. ": " .. Config[configCategory][configKey]
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 8)
        sliderBg.Position = UDim2.new(0, 0, 0, 30)
        sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderFrame
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((Config[configCategory][configKey] - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 18, 0, 18)
        sliderButton.Position = UDim2.new((Config[configCategory][configKey] - min) / (max - min), -9, 0, 25)
        sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderButton.Text = ""
        sliderButton.BorderSizePixel = 0
        sliderButton.ZIndex = 2
        sliderButton.Parent = sliderFrame
        
        local function updateSlider(input)
            local relativeX = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            
            local value = min + (max - min) * relativeX
            if configKey == "AimSmoothness" then
                value = math.floor(value * 100) / 100
            else
                value = math.floor(value)
            end
            
            Config[configCategory][configKey] = value
            label.Text = name .. ": " .. value
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -9, 0, 25)
        end
        
        sliderButton.MouseButton1Down:Connect(function()
            local connection
            connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    connection:Disconnect()
                end
            end)
        end)
        
        return sliderFrame
    end
    
    -- Функция обновления контента вкладки
    local function UpdateTabContent(tabName)
        for _, child in ipairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        local yPosition = 15
        
        if tabName == "ESP" then
            CreateToggle(contentFrame, "ESP Enabled", "ESP", "Enabled", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Boxes", "ESP", "Boxes", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Names", "ESP", "Names", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Health", "ESP", "Health", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Distance", "ESP", "Distance", yPosition); yPosition = yPosition + 35
            
        elseif tabName == "Visuals" then
            CreateToggle(contentFrame, "Chams", "Visuals", "Chams", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "No Fog", "Visuals", "NoFog", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Full Bright", "Visuals", "FullBright", yPosition); yPosition = yPosition + 35
            
        elseif tabName == "Movement" then
            CreateToggle(contentFrame, "Speed Hack", "Movement", "Speed", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Speed Value", "Movement", "SpeedValue", 16, 100, yPosition); yPosition = yPosition + 55
            CreateToggle(contentFrame, "Bunny Hop", "Movement", "Bhop", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Jump Power", "Movement", "JumpPower", 50, 150, yPosition); yPosition = yPosition + 55
            
        elseif tabName == "Combat" then
            CreateToggle(contentFrame, "AimBot", "Combat", "AimBot", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Aim FOV", "Combat", "AimFOV", 10, 100, yPosition); yPosition = yPosition + 55
            CreateSlider(contentFrame, "Aim Smoothness", "Combat", "AimSmoothness", 0.1, 1, yPosition); yPosition = yPosition + 55
            CreateToggle(contentFrame, "Crosshair", "Combat", "Crosshair", yPosition); yPosition = yPosition + 35
            
        elseif tabName == "Misc" then
            CreateToggle(contentFrame, "Show Clock", "Misc", "Clock", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Show FPS", "Misc", "FPS", yPosition); yPosition = yPosition + 35
        end
    end
    
    -- Создание вкладок
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1 / #tabs, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1) / #tabs, 0, 0, 0)
        tabButton.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(35, 35, 45)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabTextSize = 12
        tabButton.Font = Enum.Font.GothamBold
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabContainer
        
        tabButton.MouseButton1Click:Connect(function()
            currentTab = tabName
            for _, btn in ipairs(tabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Text == currentTab and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(35, 35, 45)
                end
            end
            UpdateTabContent(currentTab)
        end)
    end
    
    -- Обработчики кнопок
    local isMinimized = false
    local originalSize = mainFrame.Size
    
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            mainFrame:TweenSize(UDim2.new(0, 450, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        else
            mainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        mainGui:Destroy()
    end)
    
    -- Инициализация первой вкладки
    UpdateTabContent(currentTab)
    
    return mainGui
end

-- === ОСНОВНАЯ ФУНКЦИЯ ===
local function Main()
    -- Показываем экран загрузки
    CreateLoadingScreen()
    
    -- Ждем завершения анимации
    wait(5)
    
    AgaloCheat.PlayerName = GetPlayerUsername()
    
    print("╔══════════════════════════════╗")
    print("║      AgaloCheat v3.0         ║")
    print("║     Created by: Kast13l      ║")
    print("║    Player: " .. AgaloCheat.PlayerName .. "   ║")
    print("╚══════════════════════════════╝")
    
    -- Инициализация всех функций
    InitializeESP()
    SpeedHack()
    BunnyHop()
    HighJump()
    InitializeAimBot()
    InitializeChams()
    CustomCrosshair()
    ClockAndFPS()
    VisualEnhancements()
    CreateProfessionalUI()
    
    print("[Agalo] All features loaded successfully!")
    print("[Agalo] ESP: Professional boxes with health bars")
    print("[Agalo] AimBot: Press RMB to activate")
    print("[Agalo] Movement: All sliders working perfectly")
end

-- Запуск
Main()
