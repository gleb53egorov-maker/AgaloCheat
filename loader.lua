-- AgaloCheat v5.0 - Ultimate Edition
-- Created by Kast13l

local AgaloCheat = {
    Version = "5.0 (Ultimate)",
    Creator = "Kast13l", 
    PlayerName = "Loading..."
}

-- === АНТИЧИТ ОБХОД ===
local function AntiCheatBypass()
    pcall(function()
        getgenv().secure_mode = true
        if hookmetamethod then
            local mt = getrawmetatable(game)
            local old = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(...)
                local method = getnamecallmethod()
                if method:lower():find("kick") or method:lower():find("ban") then
                    return
                end
                return old(...)
            end)
            setreadonly(mt, true)
        end
    end)
end

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
        Tracers = false,
        Skeletons = false,
        Hitboxes = true,
        HitboxSize = 3
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
        FlySpeed = 25,
        Noclip = false
    },
    Combat = {
        AimBot = false,
        AimKey = "MouseButton2",
        AimFOV = 50,
        AimSmoothness = 0.4,
        AimAt = "Head",
        TriggerBot = false,
        TriggerDelay = 0.1,
        SilentAim = false,
        WallBang = false
    },
    Misc = {
        Clock = true,
        FPS = true,
        AutoFarm = false,
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
    fovCircle.Radius = Config.Combat.AimFOV
    
    local function findClosestTarget()
        if not localPlayer or not localPlayer.Character then return nil end
        
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

-- === ТРИГГЕРБОТ ===
local function InitializeTriggerBot()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    
    RunService.RenderStepped:Connect(function()
        if Config.Combat.TriggerBot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
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
                            
                            if distance < 10 then
                                target = player
                                break
                            end
                        end
                    end
                end
            end
            
            if target then
                wait(Config.Combat.TriggerDelay)
                mouse1click()
            end
        end
    end)
end

-- === ХИТБОКСЫ ===
local function InitializeHitboxes()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    
    local hitboxObjects = {}
    
    local function createHitbox(player)
        if player == localPlayer then return end
        
        hitboxObjects[player] = {}
        
        if player.Character then
            local parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
            
            for _, partName in pairs(parts) do
                local part = player.Character:FindFirstChild(partName)
                if part then
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
    
    RunService.RenderStepped:Connect(function()
        for player, hitboxes in pairs(hitboxObjects) do
            for _, hitboxData in pairs(hitboxes) do
                local part = hitboxData.Part
                local hitbox = hitboxData.Drawing
                
                if part and part.Parent and player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                    
                    if onScreen then
                        hitbox.Visible = Config.ESP.Enabled and Config.ESP.Hitboxes
                        local size = Config.ESP.HitboxSize * 8
                        hitbox.Size = Vector2.new(size, size)
                        hitbox.Position = Vector2.new(pos.X - size/2, pos.Y - size/2)
                    else
                        hitbox.Visible = false
                    end
                else
                    hitbox.Visible = false
                end
            end
        end
    end)
    
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
end

-- === ОПТИМИЗИРОВАННЫЙ ESP ===
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
        
        esp.Health.Size = 12
        esp.Health.Outline = true
        
        esp.Distance.Size = 12
        esp.Distance.Outline = true
        
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
                        local scale = math.clamp(1200 / distance, 0.3, 1.5)
                        
                        local boxHeight = 35 * scale
                        local boxWidth = 18 * scale
                        
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
                        esp.Name.Position = Vector2.new(headPos.X, headPos.Y - boxHeight/2 - 18)
                        esp.Name.Text = player.Name
                        
                        esp.Health.Visible = Config.ESP.Enabled and Config.ESP.Health
                        esp.Health.Color = color
                        esp.Health.Position = Vector2.new(headPos.X, headPos.Y + boxHeight/2 + 2)
                        esp.Health.Text = math.floor(health)
                        
                        esp.Distance.Visible = Config.ESP.Enabled and Config.ESP.Distance
                        esp.Distance.Color = color
                        esp.Distance.Position = Vector2.new(headPos.X, headPos.Y + boxHeight/2 + 16)
                        esp.Distance.Text = math.floor(distance) .. "m"
                        
                        -- Health Bar
                        local barWidth = boxWidth
                        local barHeight = 3
                        local barX = headPos.X - boxWidth/2
                        local barY = headPos.Y - boxHeight/2 - 6
                        
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
                    if humanoid.WalkSpeed ~= 16 then
                        humanoid.WalkSpeed = 16
                    end
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
    
    local flying = false
    local bodyVelocity
    
    local function startFlying()
        if not player.Character then return end
        
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            humanoid.PlatformStand = true
            
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            bodyVelocity.Parent = rootPart
            
            flying = true
        end
    end
    
    local function stopFlying()
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        flying = false
    end
    
    RunService.Heartbeat:Connect(function()
        if Config.Movement.Fly and player.Character then
            if not flying then
                startFlying()
            end
            
            if bodyVelocity and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
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
        elseif flying then
            stopFlying()
        end
    end)
end

-- === NOCLIP ===
local function Noclip()
    local player = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    
    RunService.Stepped:Connect(function()
        if Config.Movement.Noclip and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
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
            game:GetService("Lighting").Brightness = 2
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
    local Players = game:GetService("Players")
    
    Players.LocalPlayer.Idled:Connect(function()
        if Config.Misc.AntiAFK then
            VirtualInputManager:SendKeyEvent(true, "Space", false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "Space", false, game)
        end
    end)
end

-- === КОМПАКТНЫЙ ИНТЕРФЕЙС ===
local function CreateCompactUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "AgaloCheatUI"
    mainGui.Parent = game:GetService("CoreGui")
    mainGui.Enabled = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 320, 0, 450)
    mainFrame.Position = UDim2.new(0, 80, 0.5, -225)
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
    title.Text = "AgaloCheat v5.0"
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
    local tabs = {"ESP", "Movement", "Combat", "Visuals", "Misc"}
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
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
    contentFrame.Parent = mainFrame
    
    -- Функция создания переключателя с кнопками значений
    local function CreateValueToggle(parent, name, configCategory, configKey, values, yPosition)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 45)
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
        buttonContainer.Size = UDim2.new(1, 0, 0, 25)
        buttonContainer.Position = UDim2.new(0, 0, 0, 20)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = toggleFrame
        
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
    
    -- Функция обновления контента вкладки
    local function UpdateTabContent(tabName)
        for _, child in ipairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        local yPosition = 10
        
        if tabName == "ESP" then
            CreateToggle(contentFrame, "ESP Enabled", "ESP", "Enabled", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Boxes", "ESP", "Boxes", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Names", "ESP", "Names", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Health", "ESP", "Health", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Distance", "ESP", "Distance", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Hitboxes", "ESP", "Hitboxes", yPosition); yPosition = yPosition + 35
            CreateValueToggle(contentFrame, "Hitbox Size", "ESP", "HitboxSize", {2, 3, 4, 5}, yPosition); yPosition = yPosition + 50
            
        elseif tabName == "Movement" then
            CreateToggle(contentFrame, "Speed Hack", "Movement", "Speed", yPosition); yPosition = yPosition + 35
            CreateValueToggle(contentFrame, "Speed", "Movement", "SpeedValue", {20, 25, 30, 40, 50}, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "Bunny Hop", "Movement", "Bhop", yPosition); yPosition = yPosition + 35
            CreateValueToggle(contentFrame, "Jump Power", "Movement", "JumpPower", {50, 75, 100, 125, 150}, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "Fly Hack", "Movement", "Fly", yPosition); yPosition = yPosition + 35
            CreateValueToggle(contentFrame, "Fly Speed", "Movement", "FlySpeed", {20, 25, 30, 40, 50}, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "Noclip", "Movement", "Noclip", yPosition); yPosition = yPosition + 35
            
        elseif tabName == "Combat" then
            CreateToggle(contentFrame, "AimBot", "Combat", "AimBot", yPosition); yPosition = yPosition + 35
            CreateValueToggle(contentFrame, "Aim FOV", "Combat", "AimFOV", {30, 50, 70, 90}, yPosition); yPosition = yPosition + 50
            CreateValueToggle(contentFrame, "Smoothness", "Combat", "AimSmoothness", {0.3, 0.4, 0.5, 0.6}, yPosition); yPosition = yPosition + 50
            CreateToggle(contentFrame, "TriggerBot", "Combat", "TriggerBot", yPosition); yPosition = yPosition + 35
            CreateValueToggle(contentFrame, "Trigger Delay", "Combat", "TriggerDelay", {0.1, 0.15, 0.2, 0.25}, yPosition); yPosition = yPosition + 50
            
        elseif tabName == "Visuals" then
            CreateToggle(contentFrame, "No Fog", "Visuals", "NoFog", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Full Bright", "Visuals", "FullBright", yPosition); yPosition = yPosition + 35
            CreateToggle(contentFrame, "Time Changer", "Visuals", "TimeChanger", yPosition); yPosition = yPosition + 35
            CreateValueToggle(contentFrame, "Time", "Visuals", "TimeValue", {12, 14, 16, 18, 20}, yPosition); yPosition = yPosition + 50
            
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
    -- Античит обход
    AntiCheatBypass()
    
    AgaloCheat.PlayerName = GetPlayerUsername()
    
    print("╔══════════════════════════════╗")
    print("║      AgaloCheat v5.0         ║")
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
    InitializeAimBot()
    InitializeTriggerBot()
    SpeedHack()
    BunnyHop()
    HighJump()
    FlyHack()
    Noclip()
    VisualEnhancements()
    ClockAndFPS()
    AntiAFK()
    
    print("[Agalo] All features loaded successfully!")
    print("[Agalo] Click the floating button to open menu")
    print("[Agalo] AimBot: Press RMB - FOV circle visible")
    print("[Agalo] Hitboxes: Red squares on player body parts")
    print("[Agalo] Anti-Cheat: Protection active")
end

-- Запуск
Main()
