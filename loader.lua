-- Mobile Flicker Cheat
getgenv().MobileCheat = {Version = "1.0"}

-- Wait for game
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Simple ESP with error handling
function SimpleESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            pcall(function()
                local highlight = Instance.new("Highlight")
                highlight.Name = "MobileESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.Parent = player.Character
            end)
        end
    end
end

-- Speed function
function SetSpeed(speed)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end)
end

-- Mobile-friendly GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileCheatGUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "Mobile Cheat"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

-- Button creator
local function CreateButton(text, ypos, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, ypos)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 0
    button.MouseButton1Click:Connect(callback)
    button.Parent = MainFrame
end

-- Add buttons
CreateButton("ESP", 40, SimpleESP)
CreateButton("Speed 25", 90, function() SetSpeed(25) end)
CreateButton("Speed 50", 140, function() SetSpeed(50) end)
CreateButton("Reset Speed", 190, function() SetSpeed(16) end)
CreateButton("Remove ESP", 240, function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local esp = player.Character:FindFirstChild("MobileESP")
            if esp then esp:Destroy() end
        end
    end
end)

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

print("Mobile Flicker Cheat Loaded!")
