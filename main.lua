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
local playerGui = player:WaitForChild("PlayerGui")

-- ======================================
-- Whitelist par UserId
-- ======================================
local Whitelist = {
    9173033891, -- moi
    5182071786, -- Ami 1
    5125152468, -- ACHETEUR KETUPAT 105M
    5182071786, -- acheteur 10euro
    5182071786, -- Ami 4
    5566778899, -- Ami 5
    1029384756, -- Ami 6
    5647382910, -- Ami 7
}


local function isWhitelisted(userId)
    for _, id in pairs(Whitelist) do
        if userId == id then return true end
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
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "NotifGui"
notifGui.ResetOnSpawn = false
notifGui.Parent = playerGui

local function notify(text, color)
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
        TweenService:Create(notif, tweenOut, {Position=UDim2.new(0.5,-150,0,50), BackgroundTransparency=1, BorderSizePixel=0}):Play()
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

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Thickness = 3
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt*0.5) % 1
    Stroke.Color = Color3.fromHSV(hue,1,1)
end)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,-20,0,40)
Title.Position = UDim2.new(0,10,0,10)
Title.Text = "Nova Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1
Title.TextStrokeTransparency = 0.2
Title.TextXAlignment = Enum.TextXAlignment.Center

local function makeButtonHover(button)
    local originalSize = button.Size
    local hoverStroke = Instance.new("UIStroke", button)
    hoverStroke.Thickness = 2
    hoverStroke.Color = Color3.fromRGB(255,255,255)
    hoverStroke.Transparency = 1
    button.MouseEnter:Connect(function()
        button:TweenSize(originalSize + UDim2.new(0,10,0,10),"Out","Quad",0.15,true)
        hoverStroke.Transparency = 0
    end)
    button.MouseLeave:Connect(function()
        button:TweenSize(originalSize,"Out","Quad",0.15,true)
        hoverStroke.Transparency = 1
    end)
end

-- ======================================
-- Buttons
-- ======================================
local TeleportButton = Instance.new("TextButton", Frame)
TeleportButton.Size = UDim2.new(0,180,0,50)
TeleportButton.Position = UDim2.new(0,50,0,70)
TeleportButton.Text = "Teleport"
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.TextSize = 18
TeleportButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
TeleportButton.TextColor3 = Color3.fromRGB(0,0,0)
TeleportButton.BorderSizePixel = 0
Instance.new("UICorner", TeleportButton).CornerRadius = UDim.new(0,15)
makeButtonHover(TeleportButton)

local KeybindButton = Instance.new("TextButton", Frame)
KeybindButton.Size = UDim2.new(0,180,0,50)
KeybindButton.Position = UDim2.new(0,50,0,130)
KeybindButton.Text = "Keybind: [F]"
KeybindButton.Font = Enum.Font.GothamBold
KeybindButton.TextSize = 18
KeybindButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
KeybindButton.TextColor3 = Color3.fromRGB(0,0,0)
KeybindButton.BorderSizePixel = 0
Instance.new("UICorner", KeybindButton).CornerRadius = UDim.new(0,15)
makeButtonHover(KeybindButton)

local ESPButton = Instance.new("TextButton", Frame)
ESPButton.Size = UDim2.new(0,180,0,50)
ESPButton.Position = UDim2.new(0,50,0,190)
ESPButton.Text = "ESP"
ESPButton.Font = Enum.Font.GothamBold
ESPButton.TextSize = 18
ESPButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
ESPButton.TextColor3 = Color3.fromRGB(0,0,0)
ESPButton.BorderSizePixel = 0
Instance.new("UICorner", ESPButton).CornerRadius = UDim.new(0,15)
makeButtonHover(ESPButton)

local OptimizerButton = Instance.new("TextButton", Frame)
OptimizerButton.Size = UDim2.new(0,180,0,50)
OptimizerButton.Position = UDim2.new(0,50,0,250)
OptimizerButton.Text = "Optimizer"
OptimizerButton.Font = Enum.Font.GothamBold
OptimizerButton.TextSize = 18
OptimizerButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
OptimizerButton.TextColor3 = Color3.fromRGB(0,0,0)
OptimizerButton.BorderSizePixel = 0
Instance.new("UICorner", OptimizerButton).CornerRadius = UDim.new(0,15)
makeButtonHover(OptimizerButton)

-- ======================================
-- Teleport Logic
-- ======================================
local REQUIRED_TOOL = "Flying Carpet"
local teleportKey = Enum.KeyCode.F
local waitingForKey = false
local lastStealer = nil

local spots = {
    CFrame.new(-402.18,-6.34,131.83)*CFrame.Angles(0,math.rad(-20.08),0),
    CFrame.new(-416.66,-6.34,-2.05)*CFrame.Angles(0,math.rad(-62.89),0),
    CFrame.new(-329.37,-4.68,18.12)*CFrame.Angles(0,math.rad(-30.53),0)
}

local function equipFlyingCarpet()
    local tool = char:FindFirstChild(REQUIRED_TOOL) or backpack:FindFirstChild(REQUIRED_TOOL)
    if not tool then notify("Flying Carpet non trouvé ❌",Color3.fromRGB(255,0,0)) return false end
    humanoid:EquipTool(tool)
    while char:FindFirstChildOfClass("Tool") ~= tool do task.wait() end
    return true
end

local function block(plr)
    if not plr or plr == player then return end
    local success, err = pcall(function()
        StarterGui:SetCore("PromptBlockPlayer", plr)
    end)
    if success then
        notify("Utilisateur "..plr.Name.." bloqué ✅", Color3.fromRGB(255,0,0))
    else
        notify("Impossible de bloquer "..plr.Name.." ❌", Color3.fromRGB(255,0,0))
    end
end

local function teleportAll()
    if not equipFlyingCarpet() then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then lastStealer = plr break end
    end
    for _, spot in ipairs(spots) do
        hrp.CFrame = spot
        task.wait(0.12)
    end
    notify("Téléportation réussie ✅",Color3.fromRGB(0,255,0))
    if lastStealer then block(lastStealer) end
end

TeleportButton.MouseButton1Click:Connect(teleportAll)

KeybindButton.MouseButton1Click:Connect(function()
    KeybindButton.Text = "Press a key..."
    waitingForKey = true
end)

UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if waitingForKey and input.UserInputType==Enum.UserInputType.Keyboard then
        teleportKey=input.KeyCode
        KeybindButton.Text="Keybind: ["..teleportKey.Name.."]"
        waitingForKey=false
    elseif input.KeyCode==teleportKey then
        teleportAll()
    end
end)

-- ======================================
-- ESP Stylé
-- ======================================
local ESPEnabled = false
local ESPLines = {}
local ESPTexts = {}

local jointsListESP = {
    {"Head","HumanoidRootPart"},
    {"HumanoidRootPart","LeftUpperArm","LeftLowerArm","LeftHand"},
    {"HumanoidRootPart","RightUpperArm","RightLowerArm","RightHand"},
    {"HumanoidRootPart","LeftUpperLeg","LeftLowerLeg","LeftFoot"},
    {"HumanoidRootPart","RightUpperLeg","RightLowerLeg","RightFoot"}
}

local function createESP(plr)
    if plr == player then return end
    local char = plr.Character
    if not char then return end
    ESPLines[plr] = {}

    for _,jointGroup in ipairs(jointsListESP) do
        for i=1,#jointGroup-1 do
            local part0 = char:FindFirstChild(jointGroup[i])
            local part1 = char:FindFirstChild(jointGroup[i+1])
            if part0 and part1 then
                local att0 = Instance.new("Attachment", part0)
                local att1 = Instance.new("Attachment", part1)
                local beam = Instance.new("Beam")
                beam.Attachment0 = att0
                beam.Attachment1 = att1
                beam.FaceCamera = true
                beam.Width0 = 0.05
                beam.Width1 = 0.05
                beam.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
                beam.Transparency = NumberSequence.new(0.4)
                beam.LightEmission = 1
                beam.Parent = Workspace
                table.insert(ESPLines[plr], {beam=beam, att0=att0, att1=att1})
            end
        end
    end

    local Billboard = Instance.new("BillboardGui")
    Billboard.Adornee = char:FindFirstChild("Head")
    Billboard.Size = UDim2.new(0,120,0,50)
    Billboard.StudsOffset = Vector3.new(0,2.2,0)
    Billboard.AlwaysOnTop = true

    local TextLabel = Instance.new("TextLabel", Billboard)
    TextLabel.Size = UDim2.new(1,0,1,0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = plr.Name
    TextLabel.TextColor3 = Color3.fromRGB(255,0,0)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextScaled = true
    TextLabel.TextStrokeColor3 = Color3.fromRGB(255,0,0)
    TextLabel.TextStrokeTransparency = 0.5

    Billboard.Parent = playerGui
    ESPTexts[plr] = Billboard
end

local function removeESP(plr)
    if ESPLines[plr] then
        for _,obj in ipairs(ESPLines[plr]) do
            obj.beam:Destroy()
            obj.att0:Destroy()
            obj.att1:Destroy()
        end
        ESPLines[plr] = nil
    end
    if ESPTexts[plr] then
        ESPTexts[plr]:Destroy()
        ESPTexts[plr] = nil
    end
end

local function toggleESP()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then notify("ESP activé ✅", Color3.fromRGB(0,0,255))
    else notify("ESP désactivé ❌", Color3.fromRGB(0,0,255)) end
    for _,plr in ipairs(Players:GetPlayers()) do
        if ESPEnabled then createESP(plr) else removeESP(plr) end
    end
end

ESPButton.MouseButton1Click:Connect(toggleESP)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if ESPEnabled then createESP(plr) end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

-- ======================================
-- Optimizer (FPS boost sans toucher au sol)
-- ======================================
local function optimizer()
    notify("Optimisation en cours...", Color3.fromRGB(255,255,0))
    -- Supprime les effets inutiles
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") then
            v.Enabled = false
        end
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
        if v:IsA("MeshPart") and v.Name ~= "HumanoidRootPart" then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        end
    end
    notify("Optimisation effectuée ✅", Color3.fromRGB(0,255,0))
end

OptimizerButton.MouseButton1Click:Connect(optimizer)

-- ======================================
-- HUD FPS / DEV BY ZAY / Heure (déplaçable)
-- ======================================
local hudGui = Instance.new("ScreenGui")
hudGui.Name = "HUDGui"
hudGui.ResetOnSpawn = false
hudGui.Parent = playerGui

local hudFrame = Instance.new("Frame")
hudFrame.Size = UDim2.new(0,220,0,50)
hudFrame.Position = UDim2.new(0.5,-110,0,10)
hudFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
hudFrame.BackgroundTransparency = 0.1
hudFrame.BorderSizePixel = 3
hudFrame.BorderColor3 = Color3.fromRGB(255,0,0)
hudFrame.Active = true
hudFrame.Draggable = true
hudFrame.Parent = hudGui
Instance.new("UICorner", hudFrame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke")
stroke.Parent = hudFrame
stroke.Thickness = 3
stroke.Transparency = 0
local hueHUD = 0
RunService.RenderStepped:Connect(function(dt)
    hueHUD = (hueHUD + dt*0.5) % 1
    stroke.Color = Color3.fromHSV(hueHUD,1,1)
end)

local hudText = Instance.new("TextLabel")
hudText.Size = UDim2.new(1,0,1,0)
hudText.BackgroundTransparency = 1
hudText.TextColor3 = Color3.fromRGB(255,255,255)
hudText.Font = Enum.Font.GothamBold
hudText.TextSize = 16
hudText.TextStrokeTransparency = 0.5
hudText.TextWrapped = true
hudText.TextXAlignment = Enum.TextXAlignment.Center
hudText.TextYAlignment = Enum.TextYAlignment.Center
hudText.Text = "FPS: 0\nDEV BY ZAY\n00:00"
hudText.Parent = hudFrame

local lastTime = tick()
RunService.RenderStepped:Connect(function()
    local now = tick()
    local delta = now - lastTime
    lastTime = now
    local fps = math.floor(1 / delta)
    local timeString = os.date("%H:%M:%S")
    hudText.Text = "FPS: "..fps.."\nDEV BY ZAY\n"..timeString
end)
