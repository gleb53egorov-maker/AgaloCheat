-- AgaloCheat v0.1 - Created by Kast13l
-- GitHub: https://github.com/gleb53egorov-maker/AgaloCheat

local AgaloCheat = {
    Version = "0.1 (Beta)",
    LoaderName = "AgaloLoader", 
    CheatName = "AgaloCheat",
    Creator = "Kast13l",
    PlayerName = "Loading...",
    Platform = "Mobile"
}

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

local function Kast13lLoaderAnimation()
    local loadingSteps = {
        "╔══════════════════════════╗",
        "║     AgaloLoader v0.1     ║",
        "║    Created by Kast13l    ║",
        "╚══════════════════════════╝",
        "Initializing System...",
        "Loading Player Data...",
        "Welcome: " .. GetPlayerUsername(),
        "Loading AgaloCheat Components...",
        "╔══════════════════════════╗",
        "║       READY TO USE!      ║",
        "╚══════════════════════════╝"
    }
    
    for i, step in ipairs(loadingSteps) do
        if i == 6 then
            AgaloCheat.PlayerName = GetPlayerUsername()
            print("[Kast13l] Player: " .. AgaloCheat.PlayerName)
        end
        print("[Kast13l] " .. step)
        wait(1.0)
    end
end

local function CreateMobileUI()
    local touchGui = Instance.new("ScreenGui")
    touchGui.Name = "Kast13lMobileUI"
    touchGui.Parent = game:GetService("CoreGui")
    
    local mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(0, 60, 0, 60)
    mainButton.Position = UDim2.new(0, 20, 0.5, -30)
    mainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainButton.Text = "🎮"
    mainButton.TextSize = 20
    mainButton.ZIndex = 10
    mainButton.Parent = touchGui
    
    local mainMenu = Instance.new("Frame")
    mainMenu.Size = UDim2.new(0, 250, 0, 300)
    mainMenu.Position = UDim2.new(0, 90, 0.5, -150)
    mainMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainMenu.Visible = false
    mainMenu.Parent = touchGui
    
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    header.Text = "AgaloCheat v0.1\nby Kast13l"
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 14
    header.Parent = mainMenu
    
    local mobileFeatures = {
        {"ESP Boxes", true},
        {"Player Info", true},
        {"Aim Assist", false},
        {"No Recoil", false}
    }
    
    for i, feature in ipairs(mobileFeatures) do
        local featureFrame = Instance.new("Frame")
        featureFrame.Size = UDim2.new(1, -20, 0, 35)
        featureFrame.Position = UDim2.new(0, 10, 0, 45 + (i-1)*40)
        featureFrame.BackgroundTransparency = 1
        featureFrame.Parent = mainMenu
        
        local featureText = Instance.new("TextLabel")
        featureText.Size = UDim2.new(0.7, 0, 1, 0)
        featureText.Text = feature[1]
        featureText.TextColor3 = Color3.fromRGB(200, 200, 200)
        featureText.TextSize = 14
        featureText.BackgroundTransparency = 1
        featureText.Parent = featureFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 50, 0, 25)
        toggleButton.Position = UDim2.new(0.7, 0, 0.5, -12)
        toggleButton.BackgroundColor3 = feature[2] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        toggleButton.Text = feature[2] and "ON" or "OFF"
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.Parent = featureFrame
        
        toggleButton.MouseButton1Click:Connect(function()
            feature[2] = not feature[2]
            toggleButton.BackgroundColor3 = feature[2] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
            toggleButton.Text = feature[2] and "ON" or "OFF"
        end)
    end
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(1, -20, 0, 30)
    closeButton.Position = UDim2.new(0, 10, 1, -40)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.Text = "Close Menu"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = mainMenu
    
    mainButton.MouseButton1Click:Connect(function()
        mainMenu.Visible = not mainMenu.Visible
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        mainMenu.Visible = false
    end)
    
    return touchGui
end

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
            Distance = Drawing.new("Text")
        }
        
        local esp = espObjects[player]
        esp.Box.Visible = true
        esp.Box.Color = Color3.fromRGB(0, 255, 0)
        esp.Box.Thickness = 2
        
        esp.Name.Visible = true
        esp.Name.Color = Color3.fromRGB(255, 255, 255)
        esp.Name.Size = 14
        esp.Name.Text = player.Name
        
        esp.Distance.Visible = true
        esp.Distance.Color = Color3.fromRGB(200, 200, 200)
        esp.Distance.Size = 12
    end
    
    local function updateESP()
        for player, esp in pairs(espObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local position, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
                    
                    esp.Box.Position = Vector2.new(position.X - 25, position.Y - 50)
                    esp.Box.Size = Vector2.new(50, 100)
                    esp.Box.Visible = true
                    
                    esp.Name.Position = Vector2.new(position.X, position.Y - 60)
                    esp.Name.Text = player.Name
                    esp.Name.Visible = true
                    
                    esp.Distance.Position = Vector2.new(position.X, position.Y + 60)
                    esp.Distance.Text = math.floor(distance) .. "m"
                    esp.Distance.Visible = true
                else
                    esp.Box.Visible = false
                    esp.Name.Visible = false
                    esp.Distance.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
            end
        end
    end
    
    for _, player in pairs(players:GetPlayers()) do
        createESP(player)
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

local function Main()
    print("╔══════════════════════════════╗")
    print("║    AgaloCheat v0.1 (Beta)    ║")
    print("║     Created by: Kast13l      ║")
    print("╚══════════════════════════════╝")
    
    Kast13lLoaderAnimation()
    CreateMobileUI()
    InitializeESP()
    
    print("[Kast13l] AgaloCheat successfully loaded!")
    print("[Kast13l] Player: " .. AgaloCheat.PlayerName)
    print("[Kast13l] Use the floating button to open menu")
end

Main()
