-- AgaloCheat v4.0 - Compact Edition
-- Created by Kast13l

local AgaloCheat = {
    Version = "4.0 (Compact)",
    Creator = "Kast13l",
    PlayerName = "Loading..."
}

-- === ПЛАВАЮЩАЯ КНОПКА ===
local function CreateFloatingButton()
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "FloatingButton"
    buttonGui.Parent = game:GetService("CoreGui")
    
    local mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(0, 50, 0, 50)
    mainButton.Position = UDim2.new(0, 20, 0.5, -25)
    mainButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    mainButton.Text = "☰"
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.TextSize = 20
    mainButton.BorderSizePixel = 0
    mainButton.ZIndex = 10
    mainButton.Parent = buttonGui
    
    -- Закругление
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = mainButton
    
    -- Тень
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 2
    shadow.Parent = mainButton
    
    return buttonGui, mainButton
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
        Hitboxes = false,
        HitboxSize = 3
    },
    Visuals = {
        Chams = false,
        NoFog = true,
        FullBright = true
    },
    Movement = {
        Speed = false,
        SpeedValue = 25,
        Bhop = false,
        JumpPower = 50
    },
    Combat = {
        AimBot = false,
        AimKey = "MouseButton2",
        AimFOV = 50,
        AimSmoothness = 0.4,
        AimAt = "Head"
    },
    Misc = {
        Clock = true,
        FPS = true
    }
}

-- === ХИТБОКСЫ ESP ===
local function InitializeHitboxes()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    local hitboxObjects = {}
    
    local function createHitbox(player)
        if player == localPlayer then return end
        
        hitboxObjects[player] = {}
        
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and (part.Name == "Head" or part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "HumanoidRootPart") then
                    local hitbox = Drawing.new("Square")
                    hitbox.Thickness = 2
                    hitbox.Filled = false
                    hitbox.Color = Color3.new(1, 0, 0)
                    hitbox.Visible = false
                    
                    table.insert(hitboxObjects[player], {Part = part, Drawing = hitbox})
                end
            end
        end
    end
    
    local function updateHitboxes()
        for player, hitboxes in pairs(hitboxObjects) do
            for _, hitboxData in pairs(hitboxes) do
                local part = hitboxData.Part
                local hitbox = hitboxData.Drawing
                
                if part and part.Parent then
                    local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                    
                    if onScreen then
                        hitbox.Visible = Config.ESP.Enabled and Config.ESP.Hitboxes
                        hitbox.Size = Vector2.new(Config.ESP.HitboxSize * 10, Config.ESP.HitboxSize * 10)
                        hitbox.Position = Vector2.new(pos.X - hitbox.Size.X / 2, pos.Y - hitbox.Size.Y / 2)
                    else
                        hitbox.Visible = false
                    end
                else
                    hitbox.Visible = false
                end
            end
        end
    end
    
    -- Инициализация хитбоксов
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            createHitbox(player)
        end
    end
    
    players.PlayerAdded:Connect(createHitbox)
    players.PlayerRemoving:Connect(function(player)
        if hitboxObjects[player] then
            for _, hitboxData in pairs(hitboxObjects[player]) do
                hitboxData.Drawing:Remove()
            end
            hitboxObjects[player] = nil
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(updateHitboxes)
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
                        local scale = math.clamp(1000 / distance, 0.5, 2)
                        
                        local boxHeight = 30 * scale
                        local boxWidth = 15 * scale
                        
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
                        
                        -- Обновляем ESP
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
                        esp.Health.Position = Vector2.new(headPos.X, headPos.Y + boxHeight/2 + 2)
                        esp.Health.Text = math.floor(health)
                        
                        esp.Distance.Visible = Config.ESP.Enabled and Config.ESP.Distance
                        esp.Distance.Color = color
                        esp.Distance.Position = Vector2.new(headPos.X, headPos.Y + boxHeight/2 + 16)
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

-- === РАБОЧИЕ ФУНКЦИИ ДВИЖЕНИЯ ===
local function SpeedHack()
    local player = game:GetService("Players").LocalPlayer
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if Config.Movement.Speed then
                    humanoid.WalkSpeed = Config.Movement.SpeedValue
                else
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end)
end

local function BunnyHop()
    local player = game:GetService("Players").LocalPlayer
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if Config.Movement.Bhop and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local UIS = game:GetService("UserInputService")
            
            if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.A) or 
                   UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.D) then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)
end

local function HighJump()
    local player = game:GetService("Players").LocalPlayer
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = Config.Movement.JumpPower
            end
        end
    end)
end

-- === ВИЗУАЛЬНЫЕ ФУНКЦИИ ===
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

-- === КОМПАКТНЫЙ ИНТЕРФЕЙС ===
local function CreateCompactUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "AgaloCheatUI"
    mainGui.Parent = game:GetService("CoreGui")
    mainGui.Enabled = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0, 80, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainGui
    
    -- Закругление
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Заголовок
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "AgaloCheat v4.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Parent = header
    
    -- Кнопка закрыть
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    -- Вкладки
    local tabs = {"ESP", "Movement", "Combat", "Visuals"}
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
    
    -- Функция создания переключателя с кнопками значений
    local function CreateValueToggle(parent, name, configCategory, configKey, values, yPosition)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 40)
        toggleFrame.Position = UDim2.new(0, 10, 0, yPosition)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.4, 0, 0, 20)
        valueLabel.Position = UDim2.new(0.6, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(Config[configCategory][configKey])
        valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        valueLabel.TextSize = 13
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = toggleFrame
        
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Size = UDim2.new(1, 0, 0, 20)
        buttonContainer.Position = UDim2.new(0, 0, 0, 20)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = toggleFrame
        
        -- Кнопки значений
        for i, value in ipairs(values) do
            local valueButton = Instance.new("TextButton")
            valueButton.Size = UDim2.new(1 / #values, -2, 1, 0)
            valueButton.Position = UDim2.new((i-1) / #values, 0, 0, 0)
            valueButton.BackgroundColor3 = Config[configCategory][configKey] == value and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 60)
            valueButton.Text = tostring(value)
            valueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueButton.TextSize = 11
            valueButton.BorderSizePixel = 0
            valueButton.Parent = buttonContainer
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = valueButton
            
            valueButton.MouseButton1Click:Connect(function()
                Config[configCategory][configKey] = value
                valueLabel.Text = tostring(value)
                
                -- Обновляем цвета кнопок
                for _, btn in ipairs(buttonContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = btn.Text == tostring(value) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 60)
                    end
                end
            end)
        end
        
        return toggleFrame
    end
    
    -- Функция создания обычного переключателя
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
        toggle.Size = UDim2.new(0, 40, 0, 20)
        toggle.Position = UDim2.new(0.7, 0, 0.5, -10)
        toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(70, 70, 80)
        toggle.Text = ""
        toggle.BorderSizePixel = 0
        toggle.Parent = toggleFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 10)
        toggleCorner.Parent = toggle
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        toggleIndicator.Position = UDim2.new(0, Config[configCategory][configKey] and 22 or 2, 0.5, -8)
        toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Parent = toggle
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = toggleIndicator
        
        toggle.MouseButton1Click:Connect(function()
            Config[configCategory][configKey] = not Config[configCategory][configKey]
            toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(70, 70, 80)
            
            toggleIndicator:TweenPosition(
                UDim2.new(0, Config[configCategory][configKey] and 22 or 2, 0.5, -8),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.15,
                true
            )
        end)
        
        return toggleFrame
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
            CreateToggle(contentFrame, "Hitboxes", "ESP", "Hitboxes", yPosition); yPosition = yPosition + 30
            CreateValueToggle(contentFrame, "Hitbox Size", "ESP", "HitboxSize", {2, 3, 4, 5}, yPosition); yPosition = yPosition + 45
            
        elseif tabName == "Movement" then
            CreateToggle(contentFrame, "Speed Hack", "Movement", "Speed", yPosition); yPosition = yPosition + 30
            CreateValueToggle(contentFrame, "Speed", "Movement", "SpeedValue", {20, 25, 30, 40, 50}, yPosition); yPosition = yPosition + 45
            CreateToggle(contentFrame, "Bunny Hop", "Movement", "Bhop", yPosition); yPosition = yPosition + 30
            CreateValueToggle(contentFrame, "Jump Power", "Movement", "JumpPower", {50, 75, 100, 125, 150}, yPosition); yPosition = yPosition + 45
            
        elseif tabName == "Combat" then
            CreateToggle(contentFrame, "AimBot", "Combat", "AimBot", yPosition); yPosition = yPosition + 30
            CreateValueToggle(contentFrame, "Aim FOV", "Combat", "AimFOV", {30, 50, 70, 90}, yPosition); yPosition = yPosition + 45
            CreateValueToggle(contentFrame, "Smoothness", "Combat", "AimSmoothness", {0.3, 0.4, 0.5, 0.6}, yPosition); yPosition = yPosition + 45
            
        elseif tabName == "Visuals" then
            CreateToggle(contentFrame, "No Fog", "Visuals", "NoFog", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Full Bright", "Visuals", "FullBright", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Show Clock", "Misc", "Clock", yPosition); yPosition = yPosition + 30
            CreateToggle(contentFrame, "Show FPS", "Misc", "FPS", yPosition); yPosition = yPosition + 30
        end
    end
    
    -- Создание вкладок
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1 / #tabs, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1) / #tabs, 0, 0, 0)
        tabButton.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 11
        tabButton.Font = Enum.Font.GothamBold
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabContainer
        
        tabButton.MouseButton1Click:Connect(function()
            currentTab = tabName
            for _, btn in ipairs(tabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Text == currentTab and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50)
                end
            end
            UpdateTabContent(currentTab)
        end)
    end
    
    -- Обработчики кнопок
    closeBtn.MouseButton1Click:Connect(function()
        mainGui.Enabled = false
    end)
    
    -- Инициализация первой вкладки
    UpdateTabContent(currentTab)
    
    return mainGui
end

-- === ОСНОВНАЯ ФУНКЦИЯ ===
local function Main()
    AgaloCheat.PlayerName = GetPlayerUsername()
    
    print("╔══════════════════════════════╗")
    print("║      AgaloCheat v4.0         ║")
    print("║     Created by: Kast13l      ║")
    print("║    Player: " .. AgaloCheat.PlayerName .. "   ║")
    print("╚══════════════════════════════╝")
    
    -- Создаем плавающую кнопку
    local floatingButtonGui, floatingButton = CreateFloatingButton()
    local mainUI = CreateCompactUI()
    
    -- Обработчик плавающей кнопки
    floatingButton.MouseButton1Click:Connect(function()
        mainUI.Enabled = not mainUI.Enabled
    end)
    
    -- Инициализация всех функций
    InitializeESP()
    InitializeHitboxes()
    SpeedHack()
    BunnyHop()
    HighJump()
    InitializeAimBot()
    VisualEnhancements()
    ClockAndFPS()
    
    print("[Agalo] All features loaded successfully!")
    print("[Agalo] Click the floating button to open menu")
    print("[Agalo] Hitboxes: Red squares on player parts")
    print("[Agalo] AimBot: Press RMB to activate")
end

-- Запуск
Main()
