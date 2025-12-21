-- ======================================
-- Services
-- ======================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- ======================================
-- Joueur et personnage
-- ======================================
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")

-- ======================================
-- 🔐 WHITELIST PAR USERID (SAFE)
-- ======================================
local Whitelist = {
    9173033891, -- 🔴 REMPLACE PAR TON USERID
    -- 987654321, -- autres UserId si besoin
}

local function isWhitelisted(userId)
    for _, id in ipairs(Whitelist) do
        if userId == id then
            return true
        end
    end
    return false
end

if not isWhitelisted(player.UserId) then
    player:Kick("Not whitelisted")
    return
end

-- ======================================
-- Notifications stylées
-- ======================================
local playerGui = player:WaitForChild("PlayerGui")
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "NotifGui"
notifGui.ResetOnSpawn = false
notifGui.Parent = playerGui

local function notify(text,color)
    color = color or Color3.fromRGB(255,255,255)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0,300,0,50)
    notif.Position = UDim2.new(0.5,-150,0,50)
    notif.BackgroundColor3 = Color3.fromRGB(30,30,30)
    notif.BorderSizePixel = 2
    notif.BorderColor3 = color
    notif.Parent = notifGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0.5
    label.TextWrapped = true
    label.Parent = notif

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(notif, tweenInfo, {Position = UDim2.new(0.5,-150,0,70)}):Play()

    task.delay(2, function()
        local tweenOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(notif, tweenOut, {
            Position = UDim2.new(0.5,-150,0,50),
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        }):Play()
        task.wait(0.35)
        notif:Destroy()
    end)
end

-- ======================================
-- GUI stylée
-- ======================================
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "ZayTeleportGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,280,0,300)
Frame.Position = UDim2.new(0.5,-140,0.5,-150)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,20)

-- Rainbow border
local Stroke = Instance.new("UIStroke", Frame)
Stroke.Thickness = 3
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt*0.5) % 1
    Stroke.Color = Color3.fromHSV(hue,1,1)
end)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,-20,0,40)
Title.Position = UDim2.new(0,10,0,10)
Title.Text = "Zay The Best"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1
Title.TextStrokeTransparency = 0.2
Title.TextXAlignment = Enum.TextXAlignment.Center
