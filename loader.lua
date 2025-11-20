-- AgaloCheat v1.0 - Simple Working Version
-- Created by Kast13l

local AgaloCheat = {
    Version = "1.0 (Simple)",
    Creator = "Kast13l"
}

-- Простая плавающая кнопка
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

-- Базовая конфигурация
local Config = {
    ESP = {
        Enabled = true,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true
    },
    Movement = {
        Speed = false,
        SpeedValue = 25,
        Bhop = false,
        JumpPower = 50
    },
    Visuals = {
        NoFog = true,
        FullBright = true
    }
}

-- Простой ESP
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
    
    game:GetService("RunService").RenderStepped:Connect(function()
        for player, esp in pairs(espObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local head = player.Character:FindFirstChild("Head")
                
                if rootPart and humanoid and head and humanoid.Health > 0 then
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
                        
                        -- ESP
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

-- Простые функции движения
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
    local UIS = game:GetService("UserInputService")
    
    game:GetService("RunService").Heartbeat:Connect(function()
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
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = Config.Movement.JumpPower
            end
        end
    end)
end

-- Визуальные улучшения
local function VisualEnhancements()
    game:GetService("RunService").Heartbeat:Connect(function()
        if Config.Visuals.NoFog then
            game:GetService("Lighting").FogEnd = 1000000
        end
        
        if Config.Visuals.FullBright then
            game:GetService("Lighting").GlobalShadows = false
        end
    end)
end

-- Простой интерфейс
local function CreateSimpleUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "AgaloCheatUI"
    mainGui.Parent = game:GetService("CoreGui")
    mainGui.Enabled = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 350)
    mainFrame.Position = UDim2.new(0, 80, 0.5, -175)
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
    title.Text = "AgaloCheat v1.0"
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
    
    -- Контент
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, -35)
    contentFrame.Position = UDim2.new(0, 0, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
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
    
    -- Добавляем элементы
    local yPosition = 15
    
    CreateToggle(contentFrame, "ESP Enabled", "ESP", "Enabled", yPosition); yPosition = yPosition + 35
    CreateToggle(contentFrame, "Boxes", "ESP", "Boxes", yPosition); yPosition = yPosition + 35
    CreateToggle(contentFrame, "Names", "ESP", "Names", yPosition); yPosition = yPosition + 35
    CreateToggle(contentFrame, "Health", "ESP", "Health", yPosition); yPosition = yPosition + 35
    CreateToggle(contentFrame, "Distance", "ESP", "Distance", yPosition); yPosition = yPosition + 35
    
    CreateToggle(contentFrame, "Speed Hack", "Movement", "Speed", yPosition); yPosition = yPosition + 35
    CreateSlider(contentFrame, "Speed Value", "Movement", "SpeedValue", 16, 50, yPosition); yPosition = yPosition + 50
    CreateToggle(contentFrame, "Bunny Hop", "Movement", "Bhop", yPosition); yPosition = yPosition + 35
    CreateSlider(contentFrame, "Jump Power", "Movement", "JumpPower", 50, 150, yPosition); yPosition = yPosition + 50
    
    CreateToggle(contentFrame, "No Fog", "Visuals", "NoFog", yPosition); yPosition = yPosition + 35
    CreateToggle(contentFrame, "Full Bright", "Visuals", "FullBright", yPosition); yPosition = yPosition + 35
    
    -- Обработчики кнопок
    closeBtn.MouseButton1Click:Connect(function()
        mainGui.Enabled = false
    end)
    
    return mainGui
end

-- Основная функция
local function Main()
    print("╔══════════════════════════════╗")
    print("║      AgaloCheat v1.0         ║")
    print("║     Created by: Kast13l      ║")
    print("╚══════════════════════════════╝")
    
    -- Создаем плавающую кнопку
    local floatingButtonGui, floatingButton = CreateFloatingButton()
    local mainUI = CreateSimpleUI()
    
    -- Обработчик плавающей кнопки
    floatingButton.MouseButton1Click:Connect(function()
        mainUI.Enabled = not mainUI.Enabled
    end)
    
    -- Инициализация функций
    InitializeESP()
    SpeedHack()
    BunnyHop()
    HighJump()
    VisualEnhancements()
    
    print("[Agalo] All features loaded successfully!")
    print("[Agalo] Click the floating button to open menu")
end

-- Запуск
Main()
