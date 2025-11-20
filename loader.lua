-- UNX FPS Flick Cheat
-- Optimized for: [FPS] Flick
-- Style: UNX Loader

local UNX = {
    Name = "UNX FPS Flick Cheat",
    Version = "1.0",
    Game = "[FPS] Flick"
}

-- UNX Style Loader Animation
local function UNXLoader()
    local LoaderGui = Instance.new("ScreenGui")
    LoaderGui.Name = "UNXLoader"
    LoaderGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = LoaderGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    -- UNX Logo/Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = "UNX FPS FLICK"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.TextSize = 28
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 30)
    SubTitle.Position = UDim2.new(0, 0, 0, 60)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Loading Cheat System..."
    SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubTitle.TextSize = 16
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Parent = MainFrame
    
    -- Progress Bar
    local ProgressBg = Instance.new("Frame")
    ProgressBg.Size = UDim2.new(0, 360, 0, 6)
    ProgressBg.Position = UDim2.new(0.5, -180, 0.5, 10)
    ProgressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ProgressBg.BorderSizePixel = 0
    ProgressBg.Parent = MainFrame
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = ProgressBg
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0, 140)
    Status.BackgroundTransparency = 1
    Status.Text = "Initializing..."
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.TextSize = 14
    Status.Font = Enum.Font.Gotham
    Status.Parent = MainFrame
    
    -- Loading steps
    local Steps = {
        "Loading Core Components...",
        "Initializing AimBot System...",
        "Setting Up ESP...",
        "Configuring Visuals...",
        "Preparing Interface...",
        "Finalizing Setup..."
    }
    
    coroutine.wrap(function()
        for i, Step in ipairs(Steps) do
            Status.Text = Step
            ProgressBar:TweenSize(
                UDim2.new(i / #Steps, 0, 1, 0),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.5,
                true
            )
            wait(0.8)
        end
        
        -- Fade out
        for i = 1, 20 do
            MainFrame.BackgroundTransparency = i / 20
            wait(0.03)
        end
        
        LoaderGui:Destroy()
    end)()
    
    return LoaderGui
end

-- UNX Style Configuration
local Config = {
    AimBot = {
        Enabled = true,
        Key = "MouseButton2",
        Part = "Head",
        FOV = 80,
        Smoothness = 0.1,
        Prediction = 0.12,
        ShowFOV = true,
        AutoShoot = false
    },
    
    ESP = {
        Enabled = true,
        Box = true,
        Name = true,
        Health = true,
        Distance = true,
        Weapon = true,
        HealthBar = true,
        Tracers = false
    },
    
    Visuals = {
        NoFog = true,
        FullBright = true,
        Crosshair = true
    },
    
    Movement = {
        Speed = false,
        SpeedValue = 25,
        Bhop = false
    }
}

-- UNX Style ESP for FPS Flick
local function InitializeESP()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    
    local ESPObjects = {}
    
    local function CreateESP(Player)
        if Player == LocalPlayer then return end
        
        ESPObjects[Player] = {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            Health = Drawing.new("Text"),
            Distance = Drawing.new("Text"),
            Weapon = Drawing.new("Text"),
            HealthBar = Drawing.new("Square"),
            HealthBarBg = Drawing.new("Square")
        }
        
        local ESP = ESPObjects[Player]
        
        -- UNX Style Settings
        ESP.Box.Thickness = 2
        ESP.Box.Filled = false
        ESP.Box.Color = Color3.fromRGB(0, 255, 255)
        
        ESP.Name.Size = 14
        ESP.Name.Outline = true
        ESP.Name.Color = Color3.fromRGB(255, 255, 255)
        
        ESP.Health.Size = 12
        ESP.Health.Outline = true
        
        ESP.Distance.Size = 12
        ESP.Distance.Outline = true
        
        ESP.Weapon.Size = 12
        ESP.Weapon.Outline = true
        ESP.Weapon.Color = Color3.fromRGB(255, 255, 0)
        
        ESP.HealthBarBg.Filled = true
        ESP.HealthBarBg.Color = Color3.new(0, 0, 0)
        
        ESP.HealthBar.Filled = true
    end
    
    local function GetWeapon(Player)
        if Player.Character then
            local Tool = Player.Character:FindFirstChildOfClass("Tool")
            if Tool then return Tool.Name end
        end
        return "Fists"
    end
    
    -- High performance ESP
    RunService.RenderStepped:Connect(function()
        for Player, ESP in pairs(ESPObjects) do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local Root = Player.Character.HumanoidRootPart
                local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                local Head = Player.Character:FindFirstChild("Head")
                
                if Root and Humanoid and Humanoid.Health > 0 and Head then
                    local HeadPos, OnScreen = Camera:WorldToViewportPoint(Head.Position)
                    
                    if OnScreen then
                        local Distance = (Root.Position - Camera.CFrame.Position).Magnitude
                        local Scale = math.clamp(1000 / Distance, 0.4, 1.5)
                        
                        local Height = 35 * Scale
                        local Width = 18 * Scale
                        
                        -- Health based color
                        local Health = Humanoid.Health
                        local MaxHealth = Humanoid.MaxHealth
                        local HealthPercent = Health / MaxHealth
                        
                        local Color = Color3.fromRGB(0, 255, 255) -- UNX Cyan
                        if HealthPercent < 0.3 then
                            Color = Color3.fromRGB(255, 0, 0)
                        elseif HealthPercent < 0.6 then
                            Color = Color3.fromRGB(255, 255, 0)
                        end
                        
                        local X = HeadPos.X - Width / 2
                        local Y = HeadPos.Y - Height / 2
                        
                        -- Box
                        ESP.Box.Visible = Config.ESP.Enabled and Config.ESP.Box
                        ESP.Box.Position = Vector2.new(X, Y)
                        ESP.Box.Size = Vector2.new(Width, Height)
                        ESP.Box.Color = Color
                        
                        -- Name
                        ESP.Name.Visible = Config.ESP.Enabled and Config.ESP.Name
                        ESP.Name.Position = Vector2.new(HeadPos.X, Y - 18)
                        ESP.Name.Text = Player.Name
                        
                        -- Health
                        ESP.Health.Visible = Config.ESP.Enabled and Config.ESP.Health
                        ESP.Health.Color = Color
                        ESP.Health.Position = Vector2.new(HeadPos.X, Y + Height + 3)
                        ESP.Health.Text = "HP: " .. math.floor(Health)
                        
                        -- Distance
                        ESP.Distance.Visible = Config.ESP.Enabled and Config.ESP.Distance
                        ESP.Distance.Color = Color
                        ESP.Distance.Position = Vector2.new(HeadPos.X, Y + Height + 18)
                        ESP.Distance.Text = math.floor(Distance) .. "m"
                        
                        -- Weapon
                        ESP.Weapon.Visible = Config.ESP.Enabled and Config.ESP.Weapon
                        ESP.Weapon.Position = Vector2.new(HeadPos.X, Y + Height + 33)
                        ESP.Weapon.Text = GetWeapon(Player)
                        
                        -- Health Bar
                        if Config.ESP.HealthBar then
                            local BarWidth = Width
                            local BarHeight = 3
                            local BarX = X
                            local BarY = Y - 6
                            
                            ESP.HealthBarBg.Visible = true
                            ESP.HealthBarBg.Position = Vector2.new(BarX, BarY)
                            ESP.HealthBarBg.Size = Vector2.new(BarWidth, BarHeight)
                            
                            ESP.HealthBar.Visible = true
                            ESP.HealthBar.Color = Color
                            ESP.HealthBar.Position = Vector2.new(BarX, BarY)
                            ESP.HealthBar.Size = Vector2.new(BarWidth * HealthPercent, BarHeight)
                        else
                            ESP.HealthBarBg.Visible = false
                            ESP.HealthBar.Visible = false
                        end
                        
                    else
                        for _, Drawing in pairs(ESP) do
                            Drawing.Visible = false
                        end
                    end
                else
                    for _, Drawing in pairs(ESP) do
                        Drawing.Visible = false
                    end
                end
            else
                for _, Drawing in pairs(ESP) do
                    Drawing.Visible = false
                end
            end
        end
    end)
    
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            CreateESP(Player)
        end
    end
    
    Players.PlayerAdded:Connect(CreateESP)
    Players.PlayerRemoving:Connect(function(Player)
        if ESPObjects[Player] then
            for _, Drawing in pairs(ESPObjects[Player]) do
                Drawing:Remove()
            end
            ESPObjects[Player] = nil
        end
    end)
end

-- UNX Style AimBot for FPS Flick
local function InitializeAimBot()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    
    -- UNX Style Visuals
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = Config.AimBot.ShowFOV
    FOVCircle.Color = Color3.fromRGB(0, 255, 255)
    FOVCircle.Thickness = 2
    FOVCircle.Filled = false
    FOVCircle.NumSides = 64
    
    local Crosshair = Drawing.new("Circle")
    Crosshair.Visible = Config.Visuals.Crosshair
    Crosshair.Color = Color3.fromRGB(0, 255, 255)
    Crosshair.Thickness = 2
    Crosshair.Filled = false
    Crosshair.Radius = 4
    
    local function FindTarget()
        local BestTarget = nil
        local ClosestDistance = Config.AimBot.FOV
        local MousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                local Part = Player.Character:FindFirstChild(Config.AimBot.Part)
                
                if Humanoid and Humanoid.Health > 0 and Part then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
                    
                    if OnScreen then
                        local Distance = (MousePos - Vector2.new(ScreenPos.X, ScreenPos.Y)).Magnitude
                        
                        if Distance < ClosestDistance then
                            ClosestDistance = Distance
                            BestTarget = Part
                        end
                    end
                end
            end
        end
        
        return BestTarget
    end
    
    RunService.RenderStepped:Connect(function()
        -- Update visuals
        FOVCircle.Visible = Config.AimBot.ShowFOV
        FOVCircle.Radius = Config.AimBot.FOV
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        Crosshair.Visible = Config.Visuals.Crosshair
        Crosshair.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        -- AimBot logic
        if Config.AimBot.Enabled and UIS:IsMouseButtonPressed(Enum.UserInputType[Config.AimBot.Key]) then
            local Target = FindTarget()
            
            if Target then
                local ScreenPos = Camera:WorldToViewportPoint(Target.Position)
                
                -- Prediction for FPS Flick
                local Root = Target.Parent:FindFirstChild("HumanoidRootPart")
                if Root and Config.AimBot.Prediction > 0 then
                    local Velocity = Root.Velocity
                    ScreenPos = Camera:WorldToViewportPoint(Target.Position + (Velocity * Config.AimBot.Prediction))
                end
                
                local TargetPos = Vector2.new(ScreenPos.X, ScreenPos.Y)
                local MousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                
                local Delta = (TargetPos - MousePos) * Config.AimBot.Smoothness
                mousemoverel(Delta.X, Delta.Y)
                
                -- Auto shoot for FPS Flick
                if Config.AimBot.AutoShoot then
                    mouse1press()
                    wait(0.05)
                    mouse1release()
                end
            end
        end
    end)
end

-- UNX Style Visuals
local function InitializeVisuals()
    local RunService = game:GetService("RunService")
    
    RunService.Heartbeat:Connect(function()
        if Config.Visuals.NoFog then
            game:GetService("Lighting").FogEnd = 1000000
        end
        
        if Config.Visuals.FullBright then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Brightness = 2
        end
    end)
end

-- Movement for FPS Flick
local function InitializeMovement()
    local Player = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    
    RunService.Heartbeat:Connect(function()
        if Player.Character then
            local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                -- Speed
                if Config.Movement.Speed then
                    Humanoid.WalkSpeed = Config.Movement.SpeedValue
                else
                    Humanoid.WalkSpeed = 16
                end
                
                -- Bunny Hop for FPS Flick
                if Config.Movement.Bhop and Humanoid.FloorMaterial ~= Enum.Material.Air then
                    if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.A) or 
                       UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.D) then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end
    end)
end

-- UNX Style Interface
local function CreateUNXInterface()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "UNXInterface"
    MainGui.Parent = game:GetService("CoreGui")
    MainGui.Enabled = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0, 80, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    -- UNX Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "UNX FPS FLICK"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Parent = Header
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 18
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Content
    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1, 0, 1, -40)
    Content.Position = UDim2.new(0, 0, 0, 40)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 6
    Content.CanvasSize = UDim2.new(0, 0, 0, 500)
    Content.Parent = MainFrame
    
    local function CreateToggle(Parent, Name, Category, Key, YPos)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
        ToggleFrame.Position = UDim2.new(0, 10, 0, YPos)
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Parent = Parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Color3.fromRGB(0, 255, 255)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(0, 45, 0, 22)
        Toggle.Position = UDim2.new(0.7, 0, 0.5, -11)
        Toggle.BackgroundColor3 = Config[Category][Key] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(50, 50, 60)
        Toggle.Text = ""
        Toggle.BorderSizePixel = 0
        Toggle.Parent = ToggleFrame
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 11)
        ToggleCorner.Parent = Toggle
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 18, 0, 18)
        Indicator.Position = UDim2.new(0, Config[Category][Key] and 25 or 2, 0.5, -9)
        Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Indicator.BorderSizePixel = 0
        Indicator.Parent = Toggle
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = Indicator
        
        Toggle.MouseButton1Click:Connect(function()
            Config[Category][Key] = not Config[Category][Key]
            Toggle.BackgroundColor3 = Config[Category][Key] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(50, 50, 60)
            
            Indicator:TweenPosition(
                UDim2.new(0, Config[Category][Key] and 25 or 2, 0.5, -9),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.15,
                true
            )
        end)
        
        return ToggleFrame
    end
    
    local YPos = 15
    
    -- AimBot Section
    CreateToggle(Content, "🎯 AimBot", "AimBot", "Enabled", YPos); YPos = YPos + 35
    CreateToggle(Content, "👁️ Show FOV", "AimBot", "ShowFOV", YPos); YPos = YPos + 35
    CreateToggle(Content, "🔫 Auto Shoot", "AimBot", "AutoShoot", YPos); YPos = YPos + 35
    
    -- ESP Section
    CreateToggle(Content, "📱 ESP", "ESP", "Enabled", YPos); YPos = YPos + 35
    CreateToggle(Content, "🟦 Box", "ESP", "Box", YPos); YPos = YPos + 35
    CreateToggle(Content, "👤 Name", "ESP", "Name", YPos); YPos = YPos + 35
    CreateToggle(Content, "❤️ Health", "ESP", "Health", YPos); YPos = YPos + 35
    CreateToggle(Content, "📏 Distance", "ESP", "Distance", YPos); YPos = YPos + 35
    CreateToggle(Content, "🔫 Weapon", "ESP", "Weapon", YPos); YPos = YPos + 35
    CreateToggle(Content, "📊 Health Bar", "ESP", "HealthBar", YPos); YPos = YPos + 35
    
    -- Visuals Section
    CreateToggle(Content, "🌫️ No Fog", "Visuals", "NoFog", YPos); YPos = YPos + 35
    CreateToggle(Content, "💡 Full Bright", "Visuals", "FullBright", YPos); YPos = YPos + 35
    CreateToggle(Content, "🎯 Crosshair", "Visuals", "Crosshair", YPos); YPos = YPos + 35
    
    -- Movement Section
    CreateToggle(Content, "🏃 Speed", "Movement", "Speed", YPos); YPos = YPos + 35
    CreateToggle(Content, "🐇 Bunny Hop", "Movement", "Bhop", YPos); YPos = YPos + 35
    
    CloseBtn.MouseButton1Click:Connect(function()
        MainGui.Enabled = false
    end)
    
    return MainGui
end

-- UNX Floating Button
local function CreateUNXButton()
    local ButtonGui = Instance.new("ScreenGui")
    ButtonGui.Name = "UNXButton"
    ButtonGui.Parent = game:GetService("CoreGui")
    
    local MainButton = Instance.new("TextButton")
    MainButton.Size = UDim2.new(0, 60, 0, 60)
    MainButton.Position = UDim2.new(0, 20, 0.5, -30)
    MainButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    MainButton.Text = "UNX"
    MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainButton.TextSize = 14
    MainButton.BorderSizePixel = 0
    MainButton.ZIndex = 10
    MainButton.Parent = ButtonGui
    
    local Corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainButton
    
    return ButtonGui, MainButton
end

-- Main UNX Function
local function Main()
    -- Show UNX Loader
    UNXLoader()
    
    -- Wait for loader to finish
    wait(5)
    
    -- Create interface
    local UNXButton, MainButton = CreateUNXButton()
    local UNXInterface = CreateUNXInterface()
    
    -- Button handler
    MainButton.MouseButton1Click:Connect(function()
        UNXInterface.Enabled = not UNXInterface.Enabled
    end)
    
    -- Initialize features
    InitializeESP()
    InitializeAimBot()
    InitializeVisuals()
    InitializeMovement()
    
    -- UNX Style print messages
    print("╔══════════════════════════════╗")
    print("║         UNX FPS FLICK        ║")
    print("║        Cheat Loaded!         ║")
    print("║     Optimized for FPS Flick  ║")
    print("╚══════════════════════════════╝")
    print("[UNX] 🎯 AimBot: Right Click to Activate")
    print("[UNX] 📱 ESP: Full player information")
    print("[UNX] 🏃 Movement: Speed & Bunny Hop")
    print("[UNX] 👆 Click UNX button to open menu")
end

-- Start UNX Cheat
Main()
