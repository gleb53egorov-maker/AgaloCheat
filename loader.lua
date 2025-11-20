-- AgaloCheat v1.0 - Created by Kast13l
-- GitHub: https://github.com/gleb53egorov-maker/AgaloCheat

local AgaloCheat = {
    Version = "1.0 (Stable)",
    Creator = "Kast13l", 
    PlayerName = "Loading..."
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

-- Конфигурация
local Config = {
    ESP = {
        Enabled = true,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true
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
        NoRecoil = false
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
        esp.Box.Visible = Config.ESP.Enabled and Config.ESP.Boxes
        
        esp.Name.Size = 14
        esp.Name.Outline = true
        esp.Name.OutlineColor = Color3.new(0, 0, 0)
        esp.Name.Visible = Config.ESP.Enabled and Config.ESP.Names
        
        esp.Health.Size = 12
        esp.Health.Outline = true
        esp.Health.OutlineColor = Color3.new(0, 0, 0)
        esp.Health.Visible = Config.ESP.Enabled and Config.ESP.Health
        
        esp.Distance.Size = 12
        esp.Distance.Outline = true
        esp.Distance.OutlineColor = Color3.new(0, 0, 0)
        esp.Distance.Visible = Config.ESP.Enabled and Config.ESP.Distance
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
                        local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local feetPos = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                        
                        local boxHeight = math.abs(headPos.Y - feetPos.Y)
                        local boxWidth = boxHeight / 2
                        
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
                        
                        -- Бокс
                        if Config.ESP.Enabled and Config.ESP.Boxes then
                            esp.Box.Visible = true
                            esp.Box.Color = color
                            esp.Box.Position = Vector2.new(headPos.X - boxWidth/2, headPos.Y - boxHeight)
                            esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                        else
                            esp.Box.Visible = false
                        end
                        
                        -- Имя
                        if Config.ESP.Enabled and Config.ESP.Names then
                            esp.Name.Visible = true
                            esp.Name.Color = color
                            esp.Name.Position = Vector2.new(headPos.X, headPos.Y - boxHeight - 20)
                            esp.Name.Text = player.Name
                        else
                            esp.Name.Visible = false
                        end
                        
                        -- Здоровье
                        if Config.ESP.Enabled and Config.ESP.Health then
                            esp.Health.Visible = true
                            esp.Health.Color = color
                            esp.Health.Position = Vector2.new(headPos.X, headPos.Y - boxHeight - 5)
                            esp.Health.Text = "HP: " .. math.floor(health)
                        else
                            esp.Health.Visible = false
                        end
                        
                        -- Дистанция
                        if Config.ESP.Enabled and Config.ESP.Distance then
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
    
    -- Инициализация ESP
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

-- Bunny Hop
local function BunnyHop()
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
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if Config.Movement.Speed then
                    humanoid.WalkSpeed = Config.Movement.SpeedValue
                else
                    humanoid.WalkSpeed = 16 -- Стандартная скорость
                end
            end
        end
    end)
end

-- High Jump
local function HighJump()
    local player = game:GetService("Players").LocalPlayer
    
    game:GetService("RunService").RenderStepped:Connect(function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if Config.Movement.HighJump then
                    humanoid.JumpPower = Config.Movement.JumpPower
                else
                    humanoid.JumpPower = 50 -- Стандартная высота прыжка
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
            end
        else
            crosshair.Visible = false
        end
    end)
end

-- Часы и FPS
local function ClockAndFPS()
    local clockText = Drawing.new("Text")
    clockText.Visible = false
    clockText.Size = 16
    clockText.Color = Color3.new(1, 1, 1)
    clockText.Outline = true
    
    local fpsText = Drawing.new("Text")
    fpsText.Visible = false
    fpsText.Size = 16
    fpsText.Color = Color3.new(1, 1, 1)
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
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Visuals.NoFog then
            game:GetService("Lighting").FogEnd = 1000000
        end
        
        if Config.Visuals.FullBright then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Brightness = 2
        end
    end)
end

-- Исправленный интерфейс
local function CreateFixedUI()
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    -- Основной GUI
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "AgaloCheatUI"
    mainGui.Parent = game:GetService("CoreGui")
    
    -- Главное окно
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = mainGui
    
    -- Заголовок
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "AgaloCheat v1.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Parent = header
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.BorderSizePixel = 0
    closeButton.Parent = header
    
    closeButton.MouseButton1Click:Connect(function()
        mainGui:Destroy()
    end)
    
    -- Вкладки
    local tabs = {"ESP", "Visuals", "Movement", "Combat", "Misc"}
    local currentTab = "ESP"
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    -- Контент
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, -60)
    contentFrame.Position = UDim2.new(0, 0, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
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
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 40, 0, 20)
        toggle.Position = UDim2.new(0.7, 0, 0.5, -10)
        toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
        toggle.Text = ""
        toggle.BorderSizePixel = 0
        toggle.Parent = toggleFrame
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        toggleIndicator.Position = UDim2.new(0, Config[configCategory][configKey] and 22 or 2, 0.5, -8)
        toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Parent = toggle
        
        toggle.MouseButton1Click:Connect(function()
            Config[configCategory][configKey] = not Config[configCategory][configKey]
            
            toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
            
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(toggleIndicator, tweenInfo, {
                Position = UDim2.new(0, Config[configCategory][configKey] and 22 or 2, 0.5, -8)
            })
            tween:Play()
        end)
        
        return toggleFrame
    end
    
    -- Функция создания слайдера
    local function CreateSlider(parent, name, configCategory, configKey, min, max, yPosition)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -20, 0, 40)
        sliderFrame.Position = UDim2.new(0, 10, 0, yPosition)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name .. ": " .. Config[configCategory][configKey]
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame
        
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, 0, 0, 4)
        slider.Position = UDim2.new(0, 0, 0, 25)
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        slider.BorderSizePixel = 0
        slider.Parent = sliderFrame
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((Config[configCategory][configKey] - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = slider
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 12, 0, 12)
        sliderButton.Position = UDim2.new((Config[configCategory][configKey] - min) / (max - min), -6, 0, 21)
        sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderButton.Text = ""
        sliderButton.BorderSizePixel = 0
        sliderButton.ZIndex = 2
        sliderButton.Parent = sliderFrame
        
        local function updateSlider(input)
            local relativeX = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            
            local value = min + (max - min) * relativeX
            Config[configCategory][configKey] = math.floor(value)
            
            label.Text = name .. ": " .. Config[configCategory][configKey]
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -6, 0, 21)
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
                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end)
        
        return sliderFrame
    end
    
    -- Функция обновления контента вкладки
    local function UpdateTabContent(tabName)
        -- Очищаем контент
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
            CreateSlider(contentFrame, "TP Distance", "Visuals", "ThirdPersonDistance", 5, 20, yPosition); yPosition = yPosition + 45
            CreateToggle(contentFrame, "No Fog", "Visuals", "NoFog", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Full Bright", "Visuals", "FullBright", yPosition); yPosition = yPosition + 30
            
        elseif tabName == "Movement" then
            CreateToggle(contentFrame, "Speed Hack", "Movement", "Speed", yPosition); yPosition = yPosition + 30
            CreateSlider(contentFrame, "Speed Value", "Movement", "SpeedValue", 16, 100, yPosition); yPosition = yPosition + 45
            CreateToggle(contentFrame, "Bunny Hop", "Movement", "Bhop", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "High Jump", "Movement", "HighJump", yPosition); yPosition = yPosition + 30
            CreateSlider(contentFrame, "Jump Power", "Movement", "JumpPower", 50, 200, yPosition); yPosition = yPosition + 45
            
        elseif tabName == "Combat" then
            CreateToggle(contentFrame, "Crosshair", "Combat", "Crosshair", yPosition); yPosition = yPosition + 30
            
            -- Выбор типа прицела
            local crosshairFrame = Instance.new("Frame")
            crosshairFrame.Size = UDim2.new(1, -20, 0, 25)
            crosshairFrame.Position = UDim2.new(0, 10, 0, yPosition)
            crosshairFrame.BackgroundTransparency = 1
            crosshairFrame.Parent = contentFrame
            
            local crosshairLabel = Instance.new("TextLabel")
            crosshairLabel.Size = UDim2.new(0.5, 0, 1, 0)
            crosshairLabel.BackgroundTransparency = 1
            crosshairLabel.Text = "Crosshair Type:"
            crosshairLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            crosshairLabel.TextSize = 12
            crosshairLabel.TextXAlignment = Enum.TextXAlignment.Left
            crosshairLabel.Parent = crosshairFrame
            
            local crosshairDropdown = Instance.new("TextButton")
            crosshairDropdown.Size = UDim2.new(0.4, 0, 1, 0)
            crosshairDropdown.Position = UDim2.new(0.5, 0, 0, 0)
            crosshairDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            crosshairDropdown.Text = Config.Combat.CrosshairType
            crosshairDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
            crosshairDropdown.TextSize = 12
            crosshairDropdown.BorderSizePixel = 0
            crosshairDropdown.Parent = crosshairFrame
            
            crosshairDropdown.MouseButton1Click:Connect(function()
                if Config.Combat.CrosshairType == "Dot" then
                    Config.Combat.CrosshairType = "Circle"
                else
                    Config.Combat.CrosshairType = "Dot"
                end
                crosshairDropdown.Text = Config.Combat.CrosshairType
            end)
            
            yPosition = yPosition + 35
            
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
        tabButton.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(30, 30, 40)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 11
        tabButton.Font = Enum.Font.Gotham
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabContainer
        
        tabButton.MouseButton1Click:Connect(function()
            currentTab = tabName
            -- Обновляем цвета кнопок
            for _, btn in ipairs(tabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Text == currentTab and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(30, 30, 40)
                end
            end
            UpdateTabContent(currentTab)
        end)
    end
    
    -- Инициализация первой вкладки
    UpdateTabContent(currentTab)
    
    return mainGui
end

-- Основная функция
local function Main()
    AgaloCheat.PlayerName = GetPlayerUsername()
    
    print("╔══════════════════════════════╗")
    print("║      AgaloCheat v1.0         ║")
    print("║     Created by: Kast13l      ║")
    print("║    Player: " .. AgaloCheat.PlayerName .. "   ║")
    print("╚══════════════════════════════╝")
    
    -- Инициализация всех функций
    InitializeESP()
    ThirdPerson()
    BunnyHop()
    SpeedHack()
    HighJump()
    CustomCrosshair()
    ClockAndFPS()
    VisualEnhancements()
    CreateFixedUI()
    
    print("[Agalo] All features loaded successfully!")
    print("[Agalo] Interface is ready - check your screen!")
end

-- Запуск
Main()
