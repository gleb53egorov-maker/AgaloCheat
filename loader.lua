-- AgaloCheat v2.0 - Ultimate Working Edition
-- Created by Kast13l

local AgaloCheat = {
    Version = "2.0 (Ultimate)",
    Creator = "Kast13l"
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
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = mainButton
    
    return buttonGui, mainButton
end

-- === КОНФИГУРАЦИЯ ===
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
        NoFog = true,
        FullBright = true,
        TimeChanger = false,
        TimeValue = 12
    },
    Movement = {
        Speed = false,
        SpeedValue = 25,
        Bhop = false,
        JumpPower = 50,
        Fly = false,
        FlySpeed = 25
    },
    Combat = {
        AimBot = false,
        AimKey = "MouseButton2",
        AimFOV = 50,
        AimSmoothness = 0.4,
        AimAt = "Head",
        TriggerBot = false,
        TriggerDelay = 0.1,
        SpinBot = false,
        SpinSpeed = 5
    },
    Misc = {
        Clock = true,
        FPS = true,
        AntiAFK = true
    }
}

-- === РАБОЧИЙ AIMBOT ===
local function InitializeAimBot()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    
    -- FOV круг
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.new(1, 1, 1)
    fovCircle.Thickness = 2
    fovCircle.Filled = false
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
    
    RunService.RenderStepped:Connect(function()
        -- Обновляем FOV круг
        fovCircle.Visible = Config.Combat.AimBot
        fovCircle.Radius = Config.Combat.AimFOV
        fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        
        -- AimBot логика
        if Config.Combat.AimBot and UIS:IsMouseButtonPressed(Enum.UserInputType[Config.Combat.AimKey]) then
            local target = findClosestTarget()
            if target then
                local screenPos = camera:WorldToViewportPoint(target.Position)
                local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                
                local delta = (targetPos - mousePos) * Config.Combat.AimSmoothness
                
                -- Плавное перемещение мыши
                local steps = 5
                for i = 1, steps do
                    mousemoverel(delta.X / steps, delta.Y / steps)
                    wait()
                end
            end
        end
    end)
end

-- === ТРИГГЕРБОТ ===
local function InitializeTriggerBot()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    
    local lastShot = 0
    
    RunService.RenderStepped:Connect(function()
        if Config.Combat.TriggerBot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local currentTime = tick()
            if currentTime - lastShot < Config.Combat.TriggerDelay then return end
            
            local target = nil
            local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            
            for _, player in pairs(players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    local head = player.Character:FindFirstChild("Head")
                    
                    if humanoid and humanoid.Health > 0 and head then
                        local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                        
                        if onScreen then
                            local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                            
                            if distance < 15 then -- Маленький радиус для точности
                                target = player
                                break
                            end
                        end
                    end
                end
            end
            
            if target then
                mouse1press()
                wait(0.05)
                mouse1release()
                lastShot = tick()
            end
        end
    end)
end

-- === SPIN BOT ===
local function InitializeSpinBot()
    local player = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    
    RunService.Heartbeat:Connect(function()
        if Config.Combat.SpinBot and player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local currentCFrame = rootPart.CFrame
                local rotation = CFrame.Angles(0, math.rad(Config.Combat.SpinSpeed * 10), 0)
                rootPart.CFrame = currentCFrame * rotation
            end
        end
    end)
end

-- === CHAMS SYSTEM ===
local function InitializeChams()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local RunService = game:GetService("RunService")
    
    local chamsObjects = {}
    
    local function createChams(player)
        if player == localPlayer then return end
        
        chamsObjects[player] = {}
        
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "AgaloChams"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.FillTransparency = 0.6
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0
                    highlight.Enabled = Config.Visuals.Chams
                    highlight.Adornee = part
                    highlight.Parent = part
                    
                    table.insert(chamsObjects[player], highlight)
                end
            end
        end
    end
    
    RunService.Heartbeat:Connect(function()
        for player, highlights in pairs(chamsObjects) do
            for _, highlight in pairs(highlights) do
                highlight.Enabled = Config.Visuals.Chams
            end
        end
    end)
    
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
end

-- === УЛУЧШЕННЫЙ ESP ===
local function InitializeESP()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    
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
        
        esp.HealthBarBg.Filled = true
        esp.HealthBarBg.Color = Color3.new(0, 0, 0)
        
        esp.HealthBar.Filled = true
    end
    
    RunService.RenderStepped:Connect(function()
        for player, esp in pairs(espObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local head = player.Character:FindFirstChild("Head")
                
                if rootPart and humanoid and humanoid.Health > 0 and head then
                    local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
                        local scale = math.clamp(1200 / distance, 0.4, 1.8)
                        
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
                        
                        -- ESP элементы
                        esp.Box.Visible = Config.ESP.Enabled and Config.ESP.Boxes
                        esp.Box.Color = color
                        esp.Box.Position = Vector2.new(headPos.X - boxWidth/2, headPos.Y - boxHeight/2)
                        esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                        
                        esp.Name.Visible = Config.ESP.Enabled and Config.ESP.Names
                        esp.Name.Color = color
                        esp.Name.Position = Vector2.new(headPos.X, headPos.Y - boxHeight/2 - 20)
                        esp.Name.Text = player.Name
                        
                        esp.Health.Visible = Config.ESP.Enabled and Config.ESP.Health
                        esp.Health.Color = color
                        esp.Health.Position = Vector2.new(headPos.X, headPos.Y + boxHeight/2 + 5)
                        esp.Health.Text = math.floor(health)
                        
                        esp.Distance.Visible = Config.ESP.Enabled and Config.ESP.Distance
                        esp.Distance.Color = color
                        esp.Distance.Position = Vector2.new(headPos.X, headPos.Y + boxHeight/2 + 20)
                        esp.Distance.Text = math.floor(distance) .. "m"
                        
                        -- Health Bar
                        local barWidth = boxWidth
                        local barHeight = 4
                        local barX = headPos.X - boxWidth/2
                        local barY = headPos.Y - boxHeight/2 - 8
                        
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
    end)
    
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
end

-- === РАБОЧИЕ ФУНКЦИИ ДВИЖЕНИЯ ===
local function SpeedHack()
    local player = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    
    RunService.Heartbeat:Connect(function()
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
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    
    RunService.Heartbeat:Connect(function()
        if Config.Movement.Bhop and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
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
    local RunService = game:GetService("RunService")
    
    RunService.Heartbeat:Connect(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = Config.Movement.JumpPower
            end
        end
    end)
end

-- === FLY HACK ===
local function FlyHack()
    local player = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    
    local bodyVelocity
    
    RunService.Heartbeat:Connect(function()
        if Config.Movement.Fly and player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                if not bodyVelocity then
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                    bodyVelocity.Parent = rootPart
                end
                
                local velocity = Vector3.new(0, 0, 0)
                
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    velocity = velocity + rootPart.CFrame.LookVector * Config.Movement.FlySpeed
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    velocity = velocity - rootPart.CFrame.LookVector * Config.Movement.FlySpeed
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    velocity = velocity - rootPart.CFrame.RightVector * Config.Movement.FlySpeed
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    velocity = velocity + rootPart.CFrame.RightVector * Config.Movement.FlySpeed
                end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + Vector3.new(0, Config.Movement.FlySpeed, 0)
                end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                    velocity = velocity - Vector3.new(0, Config.Movement.FlySpeed, 0)
                end
                
                bodyVelocity.Velocity = velocity
            end
        elseif bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end)
end

-- === ВИЗУАЛЬНЫЕ ФУНКЦИИ ===
local function VisualEnhancements()
    local RunService = game:GetService("RunService")
    
    RunService.Heartbeat:Connect(function()
        if Config.Visuals.NoFog then
            game:GetService("Lighting").FogEnd = 1000000
        end
        
        if Config.Visuals.FullBright then
            game:GetService("Lighting").GlobalShadows = false
        end
        
        if Config.Visuals.TimeChanger then
            game:GetService("Lighting").ClockTime = Config.Visuals.TimeValue
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
    local RunService = game:GetService("RunService")
    
    RunService.RenderStepped:Connect(function()
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

-- === ANTI-AFK ===
local function AntiAFK()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    
    while true do
        if Config.Misc.AntiAFK then
            VirtualInputManager:SendKeyEvent(true, "Space", false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "Space", false, game)
        end
        wait(30) -- Каждые 30 секунд
    end
end

-- === ИНТЕРФЕЙС ===
local function CreateUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "AgaloCheatUI"
    mainGui.Parent = game:GetService("CoreGui")
    mainGui.Enabled = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 500)
    mainFrame.Position = UDim2.new(0, 80, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Заголовок
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -70, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "AgaloCheat v2.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
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
    local tabs = {"ESP", "Visuals", "Movement", "Combat", "Misc"}
    local currentTab = "ESP"
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    -- Контент
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, -70)
    contentFrame.Position = UDim2.new(0, 0, 0, 70)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
    contentFrame.Parent = mainFrame
    
    -- Функция создания переключателя
    local function CreateToggle(parent, name, configCategory, configKey, yPosition)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 30)
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
        toggle.Size = UDim2.new(0, 45, 0, 22)
        toggle.Position = UDim2.new(0.7, 0, 0.5, -11)
        toggle.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(70, 70, 80)
        toggle.Text = ""
        toggle.BorderSizePixel = 0
        toggle.Parent = toggleFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 11)
        toggleCorner.Parent = toggle
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Size = UDim2.new(0, 18, 0, 18)
        toggleIndicator.Position = UDim2.new(0, Config[configCategory][configKey] and 25 or 2, 0.5, -9)
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
                UDim2.new(0, Config[configCategory][configKey] and 25 or 2, 0.5, -9),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.15,
                true
            )
        end)
        
        return toggleFrame
    end
    
    -- Функция создания слайдера
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
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
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
            
            local value = min + (max - min) * relativeX
            if configKey == "AimSmoothness" then
                value = math.floor(value * 100) / 100
            else
                value = math.floor(value)
            end
            
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
            CreateToggle(contentFrame, "Time Changer", "Visuals", "TimeChanger", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Time", "Visuals", "TimeValue", 0, 24, yPosition); yPosition = yPosition + 50
            
        elseif tabName == "Movement" then
            CreateToggle(contentFrame, "Speed Hack", "Movement", "Speed", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Speed", "Movement", "SpeedValue", 16, 100, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "Bunny Hop", "Movement", "Bhop", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Jump Power", "Movement", "JumpPower", 50, 150, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "Fly Hack", "Movement", "Fly", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Fly Speed", "Movement", "FlySpeed", 10, 50, yPosition); yPosition = yPosition + 50
            
        elseif tabName == "Combat" then
            CreateToggle(contentFrame, "AimBot", "Combat", "AimBot", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Aim FOV", "Combat", "AimFOV", 10, 100, yPosition); yPosition = yPosition + 50
            CreateSlider(contentFrame, "Aim Smoothness", "Combat", "AimSmoothness", 0.1, 1, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "TriggerBot", "Combat", "TriggerBot", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Trigger Delay", "Combat", "TriggerDelay", 0.05, 0.5, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "Spin Bot", "Combat", "SpinBot", yPosition); yPosition = yPosition + 35
            CreateSlider(contentFrame, "Spin Speed", "Combat", "SpinSpeed", 1, 20, yPosition); yPosition = yPosition + 50
            
        elseif tabName == "Misc" then
            CreateToggle(contentFrame, "Show Clock", "Misc", "Clock", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Show FPS", "Misc", "FPS", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Anti-AFK", "Misc", "AntiAFK", yPosition); yPosition = yPosition + 35
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
    print("╔══════════════════════════════╗")
    print("║      AgaloCheat v2.0         ║")
    print("║     Created by: Kast13l      ║")
    print("╚══════════════════════════════╝")
    
    -- Создаем плавающую кнопку
    local floatingButtonGui, floatingButton = CreateFloatingButton()
    local mainUI = CreateUI()
    
    -- Обработчик плавающей кнопки
    floatingButton.MouseButton1Click:Connect(function()
        mainUI.Enabled = not mainUI.Enabled
    end)
    
    -- Инициализация всех функций
    InitializeESP()
    InitializeChams()
    InitializeAimBot()
    InitializeTriggerBot()
    InitializeSpinBot()
    SpeedHack()
    BunnyHop()
    HighJump()
    FlyHack()
    VisualEnhancements()
    ClockAndFPS()
    spawn(AntiAFK)
    
    print("[Agalo] All features loaded successfully!")
    print("[Agalo] Click the floating button to open menu")
    print("[Agalo] AimBot: Press RMB - FOV circle visible")
    print("[Agalo] TriggerBot: Auto-shoot when aiming at head")
    print("[Agalo] SpinBot: Rotates your character")
end

-- Запуск
Main()
