-- AgaloCheat v2.0 - Ultimate Edition
-- Created by Kast13l

local AgaloCheat = {
    Version = "2.0 (Ultimate)",
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
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = loadingGui
    
    -- Логотип
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 300, 0, 80)
    logo.Position = UDim2.new(0.5, -150, 0.4, -40)
    logo.BackgroundTransparency = 1
    logo.Text = "AGALOCHEAT"
    logo.TextColor3 = Color3.fromRGB(0, 170, 255)
    logo.TextSize = 36
    logo.Font = Enum.Font.GothamBold
    logo.Parent = mainFrame
    
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 200, 0, 30)
    version.Position = UDim2.new(0.5, -100, 0.4, 50)
    version.BackgroundTransparency = 1
    version.Text = "v2.0 Ultimate"
    version.TextColor3 = Color3.fromRGB(200, 200, 200)
    version.TextSize = 18
    version.Font = Enum.Font.Gotham
    version.Parent = mainFrame
    
    -- Прогресс бар
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0, 400, 0, 6)
    progressBg.Position = UDim2.new(0.5, -200, 0.6, 0)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = mainFrame
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0, 400, 0, 30)
    statusText.Position = UDim2.new(0.5, -200, 0.6, 20)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Initializing..."
    statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = mainFrame
    
    -- Анимация загрузки
    local steps = {
        "Loading Player Data...",
        "Initializing ESP System...",
        "Setting Up Visuals...",
        "Configuring Movement...",
        "Preparing Interface...",
        "Almost Ready..."
    }
    
    coroutine.wrap(function()
        for i, step in ipairs(steps) do
            statusText.Text = step
            progressBar:TweenSize(
                UDim2.new(i / #steps, 0, 1, 0),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.5,
                true
            )
            wait(0.8)
        end
        
        -- Плавное исчезновение
        for i = 1, 20 do
            mainFrame.BackgroundTransparency = i / 20
            wait(0.02)
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
        Tracers = false
    },
    Visuals = {
        ThirdPerson = false,
        ThirdPersonDistance = 12,
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
        AimFOV = 30,
        AimSmoothness = 0.3,
        Crosshair = true
    },
    Misc = {
        Clock = true,
        FPS = true
    }
}

-- === РАБОЧИЕ ФУНКЦИИ ДВИЖЕНИЯ ===

-- Speed Hack (ИСПРАВЛЕННЫЙ)
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
                    -- Возвращаем стандартную скорость только если не включен спид
                    if humanoid.WalkSpeed ~= defaultWalkSpeed then
                        humanoid.WalkSpeed = defaultWalkSpeed
                    end
                end
            end
        end
    end)
end

-- Bunny Hop (ИСПРАВЛЕННЫЙ)
local function BunnyHop()
    local player = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if Config.Movement.Bhop and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

-- High Jump (ИСПРАВЛЕННЫЙ)
local function HighJump()
    local player = game:GetService("Players").LocalPlayer
    local defaultJumpPower = 50
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if Config.Movement.JumpPower ~= defaultJumpPower then
                    humanoid.JumpPower = Config.Movement.JumpPower
                else
                    humanoid.JumpPower = defaultJumpPower
                end
            end
        end
    end)
end

-- ESP система
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
            Distance = Drawing.new("Text")
        }
        
        local esp = espObjects[player]
        
        esp.Box.Thickness = 2
        esp.Box.Filled = false
        
        esp.Name.Size = 14
        esp.Name.Outline = true
        
        esp.Health.Size = 12
        esp.Health.Outline = true
        
        esp.Distance.Size = 12
        esp.Distance.Outline = true
    end
    
    local function updateESP()
        for player, esp in pairs(espObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local head = player.Character:FindFirstChild("Head")
                
                if rootPart and humanoid and head then
                    local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
                        local scale = 1000 / distance
                        
                        local boxHeight = 40 * scale
                        local boxWidth = 20 * scale
                        
                        -- Цвет по здоровью
                        local health = humanoid.Health
                        local maxHealth = humanoid.MaxHealth
                        local healthPercent = health / maxHealth
                        
                        local color = Color3.new(1, 1, 1)
                        if healthPercent > 0.7 then
                            color = Color3.new(0, 1, 0)
                        elseif healthPercent > 0.3 then
                            color = Color3.new(1, 1, 0)
                        else
                            color = Color3.new(1, 0, 0)
                        end
                        
                        -- Обновляем видимость и позиции
                        esp.Box.Visible = Config.ESP.Enabled and Config.ESP.Boxes
                        esp.Box.Color = color
                        esp.Box.Position = Vector2.new(headPos.X - boxWidth/2, headPos.Y - boxHeight/2)
                        esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                        
                        esp.Name.Visible = Config.ESP.Enabled and Config.ESP.Names
                        esp.Name.Color = color
                        esp.Name.Position = Vector2.new(headPos.X, headPos.Y - boxHeight/2 - 15)
                        esp.Name.Text = player.Name
                        
                        esp.Health.Visible = Config.ESP.Enabled and Config.ESP.Health
                        esp.Health.Color = color
                        esp.Health.Position = Vector2.new(headPos.X, headPos.Y - boxHeight/2)
                        esp.Health.Text = "HP: " .. math.floor(health)
                        
                        esp.Distance.Visible = Config.ESP.Enabled and Config.ESP.Distance
                        esp.Distance.Color = color
                        esp.Distance.Position = Vector2.new(headPos.X, headPos.Y + boxHeight/2 + 5)
                        esp.Distance.Text = math.floor(distance) .. "m"
                    else
                        for _, drawing in pairs(esp) do
                            drawing.Visible = false
                        end
                    end
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

-- AimBot система
local function InitializeAimBot()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    local UIS = game:GetService("UserInputService")
    
    local function findClosestTarget()
        local closestTarget = nil
        local closestDistance = Config.Combat.AimFOV
        local mousePos = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local head = player.Character:FindFirstChild("Head")
                
                if humanoid and humanoid.Health > 0 and head then
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestTarget = head
                        end
                    end
                end
            end
        end
        
        return closestTarget
    end
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Combat.AimBot and UIS:IsMouseButtonPressed(Enum.UserInputType[Config.Combat.AimKey]) then
            local target = findClosestTarget()
            if target then
                local screenPos = camera:WorldToViewportPoint(target.Position)
                local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                local mousePos = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                
                local delta = (targetPos - mousePos) * Config.Combat.AimSmoothness
                mousemoverel(delta.X, delta.Y)
            end
        end
    end)
end

-- Другие функции (ThirdPerson, Crosshair, ClockAndFPS, VisualEnhancements)
local function ThirdPerson()
    local camera = workspace.CurrentCamera
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Visuals.ThirdPerson then
            local character = game:GetService("Players").LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                local offset = root.CFrame * CFrame.new(0, 0, Config.Visuals.ThirdPersonDistance)
                camera.CFrame = CFrame.new(offset.Position, root.Position)
                camera.CameraType = Enum.CameraType.Scriptable
            end
        else
            camera.CameraType = Enum.CameraType.Custom
        end
    end)
end

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
        crosshair.Radius = 4
    end)
end

local function ClockAndFPS()
    local clockText = Drawing.new("Text")
    clockText.Size = 16
    clockText.Outline = true
    
    local fpsText = Drawing.new("Text")
    fpsText.Size = 16
    fpsText.Outline = true
    
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
        end
        
        if Config.Visuals.FullBright then
            game:GetService("Lighting").GlobalShadows = false
        end
    end)
end

-- === УЛУЧШЕННЫЙ ИНТЕРФЕЙС ===
local function CreateImprovedUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "AgaloCheatUI"
    mainGui.Parent = game:GetService("CoreGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainGui
    
    -- Заголовок с кнопками
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "AgaloCheat v2.0"
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Parent = header
    
    -- Кнопка свернуть
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    minimizeBtn.Text = "_"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 16
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = header
    
    -- Кнопка закрыть
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header
    
    -- Вкладки
    local tabs = {"ESP", "Visuals", "Movement", "Combat", "Misc"}
    local currentTab = "ESP"
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    -- Контент
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, -60)
    contentFrame.Position = UDim2.new(0, 0, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    contentFrame.Parent = mainFrame
    
    -- Функция создания переключателя
    local function CreateToggle(parent, name, configCategory, configKey, yPosition)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 25)
        toggleFrame.Position = UDim2.new(0, 10, 0, yPosition)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 45, 0, 20)
        toggle.Position = UDim2.new(0.7, 0, 0.5, -10)
        toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
        toggle.Text = ""
        toggle.BorderSizePixel = 0
        toggle.Parent = toggleFrame
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        toggleIndicator.Position = UDim2.new(0, Config[configCategory][configKey] and 27 or 2, 0.5, -8)
        toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Parent = toggle
        
        toggle.MouseButton1Click:Connect(function()
            Config[configCategory][configKey] = not Config[configCategory][configKey]
            toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
            
            -- Анимация переключения
            toggleIndicator:TweenPosition(
                UDim2.new(0, Config[configCategory][configKey] and 27 or 2, 0.5, -8),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
        end)
        
        return toggleFrame
    end
    
    -- Функция создания слайдера (РАБОЧИЙ)
    local function CreateSlider(parent, name, configCategory, configKey, min, max, yPosition)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -20, 0, 45)
        sliderFrame.Position = UDim2.new(0, 10, 0, yPosition)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name .. ": " .. Config[configCategory][configKey]
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 6)
        sliderBg.Position = UDim2.new(0, 0, 0, 25)
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderFrame
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((Config[configCategory][configKey] - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 16, 0, 16)
        sliderButton.Position = UDim2.new((Config[configCategory][configKey] - min) / (max - min), -8, 0, 20)
        sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderButton.Text = ""
        sliderButton.BorderSizePixel = 0
        sliderButton.ZIndex = 2
        sliderButton.Parent = sliderFrame
        
        local function updateSlider(input)
            local relativeX = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            
            local value = math.floor(min + (max - min) * relativeX)
            Config[configCategory][configKey] = value
            
            label.Text = name .. ": " .. value
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -8, 0, 20)
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
        
        local yPosition = 10
        
        if tabName == "ESP" then
            CreateToggle(contentFrame, "ESP Enabled", "ESP", "Enabled", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Boxes", "ESP", "Boxes", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Names", "ESP", "Names", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Health", "ESP", "Health", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Distance", "ESP", "Distance", yPosition); yPosition = yPosition + 30
            
        elseif tabName == "Visuals" then
            CreateToggle(contentFrame, "Third Person", "Visuals", "ThirdPerson", yPosition); yPosition = yPosition + 30
            CreateSlider(contentFrame, "TP Distance", "Visuals", "ThirdPersonDistance", 5, 20, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "No Fog", "Visuals", "NoFog", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Full Bright", "Visuals", "FullBright", yPosition); yPosition = yPosition + 30
            
        elseif tabName == "Movement" then
            CreateToggle(contentFrame, "Speed Hack", "Movement", "Speed", yPosition); yPosition = yPosition + 30
            CreateSlider(contentFrame, "Speed Value", "Movement", "SpeedValue", 16, 100, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "Bunny Hop", "Movement", "Bhop", yPosition); yPosition = yPosition + 30
            CreateSlider(contentFrame, "Jump Power", "Movement", "JumpPower", 50, 150, yPosition); yPosition = yPosition + 50
            
        elseif tabName == "Combat" then
            CreateToggle(contentFrame, "AimBot", "Combat", "AimBot", yPosition); yPosition = yPosition + 30
            CreateSlider(contentFrame, "Aim FOV", "Combat", "AimFOV", 10, 100, yPosition); yPosition = yPosition + 50
            CreateSlider(contentFrame, "Aim Smoothness", "Combat", "AimSmoothness", 0.1, 1, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "Crosshair", "Combat", "Crosshair", yPosition); yPosition = yPosition + 30
            
        elseif tabName == "Misc" then
            CreateToggle(contentFrame, "Show Clock", "Misc", "Clock", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Show FPS", "Misc", "FPS", yPosition); yPosition = yPosition + 30
        end
    end
    
    -- Создание вкладок
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1 / #tabs, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1) / #tabs, 0, 0, 0)
        tabButton.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 12
        tabButton.Font = Enum.Font.Gotham
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabContainer
        
        tabButton.MouseButton1Click:Connect(function()
            currentTab = tabName
            for _, btn in ipairs(tabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Text == currentTab and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
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
            mainFrame:TweenSize(UDim2.new(0, 400, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
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
    -- Сначала показываем экран загрузки
    CreateLoadingScreen()
    
    -- Ждем немного перед инициализацией
    wait(2)
    
    AgaloCheat.PlayerName = GetPlayerUsername()
    
    print("╔══════════════════════════════╗")
    print("║      AgaloCheat v2.0         ║")
    print("║     Created by: Kast13l      ║")
    print("║    Player: " .. AgaloCheat.PlayerName .. "   ║")
    print("╚══════════════════════════════╝")
    
    -- Инициализация всех функций
    InitializeESP()
    ThirdPerson()
    SpeedHack()
    BunnyHop()
    HighJump()
    InitializeAimBot()
    CustomCrosshair()
    ClockAndFPS()
    VisualEnhancements()
    CreateImprovedUI()
    
    print("[Agalo] All features loaded successfully!")
    print("[Agalo] Speed Hack: Use slider in Movement tab")
    print("[Agalo] Bunny Hop: Auto-jump when moving")
    print("[Agalo] Interface ready - Drag to move")
end

-- Запуск
Main()
