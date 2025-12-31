-- ======================================
-- Luna Hub - Version Modifiée (Teleport fixe 3 positions + 10 places whitelist vides ajoutées)
-- ======================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Camera = Workspace.CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

-- ======================================
-- Joueur et personnage
-- ======================================
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")
local playerGui = player:WaitForChild("PlayerGui")

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)

-- ======================================
-- Whitelist par UserId (10 places vides ajoutées)
-- ======================================
local Whitelist = {
    9173033891, -- moi
    5182071786, -- Ami 1
    5125152468, -- ACHETEUR KETUPAT 105M
    4269265728, -- acheteur 10euro
    1617845814, -- free le bon 13
    1234454555, -- ACHETEUR KEBECOIS
    3212312321,-- Ami 
    9212405626, -- tic tac couz a 13
    4292535585, -- fury
    1387572025, -- secret combi 305M
    0, -- Place libre 4
    0, -- Place libre 5
    0, -- Place libre 6
    0, -- Place libre 7
    0, -- Place libre 8
    0, -- Place libre 9
    0  -- Place libre 10
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
-- Launcher Icon
-- ======================================
local LauncherGui = Instance.new("ScreenGui")
LauncherGui.Name = "LunaHubLauncher"
LauncherGui.ResetOnSpawn = false
LauncherGui.Parent = playerGui

local LauncherButton = Instance.new("TextButton")
LauncherButton.Size = UDim2.new(0, 60, 0, 60)
LauncherButton.Position = UDim2.new(1, -70, 1, -70)
LauncherButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LauncherButton.Text = "LH"
LauncherButton.TextColor3 = Color3.fromRGB(255, 0, 0)
LauncherButton.Font = Enum.Font.GothamBold
LauncherButton.TextSize = 30
LauncherButton.TextStrokeTransparency = 1
LauncherButton.BorderSizePixel = 0
LauncherButton.Active = true
LauncherButton.Draggable = true
LauncherButton.Parent = LauncherGui

Instance.new("UICorner", LauncherButton).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", LauncherButton)
Stroke.Thickness = 3
Stroke.Transparency = 0.3

local hueLauncher = 0
RunService.RenderStepped:Connect(function(dt)
    hueLauncher = (hueLauncher + dt * 0.5) % 1
    Stroke.Color = Color3.fromHSV(hueLauncher, 1, 1)
end)

LauncherButton.MouseEnter:Connect(function()
    LauncherButton:TweenSize(UDim2.new(0, 66, 0, 66), "Out", "Quad", 0.2, true)
end)
LauncherButton.MouseLeave:Connect(function()
    LauncherButton:TweenSize(UDim2.new(0, 60, 0, 60), "Out", "Quad", 0.2, true)
end)

-- ======================================
-- Notifications
-- ======================================
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "NotifGui"
notifGui.ResetOnSpawn = false
notifGui.Parent = playerGui

local function notify(text, isSuccess)
    local duration = 3
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 60)
    frame.Position = UDim2.new(0.5, -160, 0, -70)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = notifGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2
    stroke.Color = isSuccess and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    stroke.Transparency = 0.3
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 40, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = isSuccess and "✅" or "❌"
    icon.TextColor3 = isSuccess and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 36
    icon.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, -10)
    label.Position = UDim2.new(0, 45, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = frame
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, 0, 0, 3)
    progressBg.Position = UDim2.new(0, 0, 1, -3)
    progressBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    progressBg.Parent = frame
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    progressBar.Parent = progressBg
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0, 2)
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -160, 0, 15)}):Play()
    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
    task.delay(duration, function()
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -160, 0, -70)}):Play()
        task.wait(0.45)
        frame:Destroy()
    end)
end

-- ======================================
-- GUI principale avec onglets
-- ======================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunaHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false
ScreenGui.Parent = playerGui

local MainContainer = Instance.new("CanvasGroup")
MainContainer.Size = UDim2.new(0, 240, 0, 400)
MainContainer.Position = UDim2.new(0.5, -120, 0.5, -200)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainContainer.BorderSizePixel = 0
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.GroupTransparency = 1
MainContainer.Parent = ScreenGui

Instance.new("UICorner", MainContainer).CornerRadius = UDim.new(0, 16)
local StrokeMain = Instance.new("UIStroke", MainContainer)
StrokeMain.Thickness = 2

local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.5) % 1
    StrokeMain.Color = Color3.fromHSV(hue, 1, 1)
end)

local Title = Instance.new("TextLabel", MainContainer)
Title.Size = UDim2.new(1, -16, 0, 32)
Title.Position = UDim2.new(0, 8, 0, 8)
Title.Text = "Luna Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.TextStrokeTransparency = 0.2
Title.TextXAlignment = Enum.TextXAlignment.Center

-- Barre d'onglets scrollable
local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, -16, 0, 32)
TabScroll.Position = UDim2.new(0, 8, 0, 42)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 8
TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.Parent = MainContainer

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabListLayout.Padding = UDim.new(0, 8)
TabListLayout.Parent = TabScroll

local hueTabScroll = 0
RunService.RenderStepped:Connect(function(dt)
    hueTabScroll = (hueTabScroll + dt * 0.5) % 1
    TabScroll.ScrollBarImageColor3 = Color3.fromHSV(hueTabScroll, 1, 1)
end)

local function createTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 70, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 16
    tabButton.BorderSizePixel = 0
    tabButton.Parent = TabScroll
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)
    return tabButton
end

local MainTab = createTab("Main")
local VisualsTab = createTab("Visuals")
local ConfigTab = createTab("Config")
local VIPTtab = createTab("VIP")

-- Contenu des onglets
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -24, 1, -84)
ContentFrame.Position = UDim2.new(0, 12, 0, 76)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainContainer

local MainContent = Instance.new("Frame")
MainContent.Size = UDim2.new(1, 0, 1, 0)
MainContent.BackgroundTransparency = 1
MainContent.Parent = ContentFrame
MainContent.Visible = true

local VisualsContent = Instance.new("Frame")
VisualsContent.Size = UDim2.new(1, 0, 1, 0)
VisualsContent.BackgroundTransparency = 1
VisualsContent.Parent = ContentFrame
VisualsContent.Visible = false

local ConfigContent = Instance.new("Frame")
ConfigContent.Size = UDim2.new(1, 0, 1, 0)
ConfigContent.BackgroundTransparency = 1
ConfigContent.Parent = ContentFrame
ConfigContent.Visible = false

local VIPScrollingFrame = Instance.new("ScrollingFrame")
VIPScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
VIPScrollingFrame.BackgroundTransparency = 1
VIPScrollingFrame.BorderSizePixel = 0
VIPScrollingFrame.ScrollBarThickness = 10
VIPScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
VIPScrollingFrame.Visible = false
VIPScrollingFrame.Parent = ContentFrame

local hueVIPScroll = 0
RunService.RenderStepped:Connect(function(dt)
    hueVIPScroll = (hueVIPScroll + dt * 0.5) % 1
    VIPScrollingFrame.ScrollBarImageColor3 = Color3.fromHSV(hueVIPScroll, 1, 1)
end)

local VIPLayout = Instance.new("UIListLayout")
VIPLayout.Padding = UDim.new(0, 20)
VIPLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
VIPLayout.Parent = VIPScrollingFrame

local function makeButtonHover(button)
    local originalSize = button.Size
    local hoverStroke = Instance.new("UIStroke", button)
    hoverStroke.Thickness = 2
    hoverStroke.Color = Color3.fromRGB(255, 255, 255)
    hoverStroke.Transparency = 1
    button.MouseEnter:Connect(function()
        button:TweenSize(originalSize + UDim2.new(0, 8, 0, 8), "Out", "Quad", 0.15, true)
        hoverStroke.Transparency = 0
    end)
    button.MouseLeave:Connect(function()
        button:TweenSize(originalSize, "Out", "Quad", 0.15, true)
        hoverStroke.Transparency = 1
    end)
end

-- Seul bouton dans Main : Teleport
local TeleportButton = Instance.new("TextButton", MainContent)
TeleportButton.Size = UDim2.new(0, 160, 0, 40)
TeleportButton.Position = UDim2.new(0.5, -80, 0, 10)
TeleportButton.Text = "Teleport"
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.TextSize = 16
TeleportButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TeleportButton.BorderSizePixel = 0
Instance.new("UICorner", TeleportButton).CornerRadius = UDim.new(0, 12)
makeButtonHover(TeleportButton)

-- Boutons Visuals
local ESPButton = Instance.new("TextButton", VisualsContent)
ESPButton.Size = UDim2.new(0, 160, 0, 40)
ESPButton.Position = UDim2.new(0.5, -80, 0, 10)
ESPButton.Text = "ESP"
ESPButton.Font = Enum.Font.GothamBold
ESPButton.TextSize = 16
ESPButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ESPButton.BorderSizePixel = 0
Instance.new("UICorner", ESPButton).CornerRadius = UDim.new(0, 12)
makeButtonHover(ESPButton)

local FPSBoostButton = Instance.new("TextButton", VisualsContent)
FPSBoostButton.Size = UDim2.new(0, 160, 0, 40)
FPSBoostButton.Position = UDim2.new(0.5, -80, 0, 60)
FPSBoostButton.Text = "FPS Boost"
FPSBoostButton.Font = Enum.Font.GothamBold
FPSBoostButton.TextSize = 16
FPSBoostButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FPSBoostButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FPSBoostButton.BorderSizePixel = 0
Instance.new("UICorner", FPSBoostButton).CornerRadius = UDim.new(0, 12)
makeButtonHover(FPSBoostButton)

-- Onglet Config
local teleportKey = Enum.KeyCode.F
local waitingForKey = false

local KeybindButton = Instance.new("TextButton", ConfigContent)
KeybindButton.Size = UDim2.new(0, 160, 0, 40)
KeybindButton.Position = UDim2.new(0.5, -80, 0, 10)
KeybindButton.Text = "Keybind: [F]"
KeybindButton.Font = Enum.Font.GothamBold
KeybindButton.TextSize = 16
KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeybindButton.TextColor3 = Color3.fromRGB(0, 0, 0)
KeybindButton.BorderSizePixel = 0
Instance.new("UICorner", KeybindButton).CornerRadius = UDim.new(0, 12)
makeButtonHover(KeybindButton)

local ConfigNameBox = Instance.new("TextBox", ConfigContent)
ConfigNameBox.Size = UDim2.new(0, 160, 0, 40)
ConfigNameBox.Position = UDim2.new(0.5, -80, 0, 60)
ConfigNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ConfigNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigNameBox.Font = Enum.Font.Gotham
ConfigNameBox.TextSize = 16
ConfigNameBox.PlaceholderText = "Nom de la config"
ConfigNameBox.Text = ""
Instance.new("UICorner", ConfigNameBox).CornerRadius = UDim.new(0, 8)

local SaveConfigBtn = Instance.new("TextButton", ConfigContent)
SaveConfigBtn.Size = UDim2.new(0, 160, 0, 40)
SaveConfigBtn.Position = UDim2.new(0.5, -80, 0, 110)
SaveConfigBtn.Text = "Sauvegarder Config"
SaveConfigBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SaveConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SaveConfigBtn).CornerRadius = UDim.new(0, 8)
makeButtonHover(SaveConfigBtn)

local ConfigListFrame = Instance.new("ScrollingFrame", ConfigContent)
ConfigListFrame.Size = UDim2.new(0, 160, 0, 100)
ConfigListFrame.Position = UDim2.new(0.5, -80, 0, 160)
ConfigListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ConfigListFrame.BorderSizePixel = 0
ConfigListFrame.ScrollBarThickness = 4
ConfigListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", ConfigListFrame).CornerRadius = UDim.new(0, 8)

local ConfigListLayout = Instance.new("UIListLayout", ConfigListFrame)
ConfigListLayout.Padding = UDim.new(0, 5)

local savedConfigs = {}
local CONFIG_FILE = "LunaHub_Configs.json"

local function updateConfigList()
    ConfigListFrame:ClearAllChildren()
    ConfigListLayout.Parent = nil
    ConfigListLayout.Parent = ConfigListFrame
    for name, config in pairs(savedConfigs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.Text = name .. " (" .. config.keybind .. ")"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = ConfigListFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        makeButtonHover(btn)
        btn.MouseButton1Click:Connect(function()
            teleportKey = Enum.KeyCode[config.keybind]
            KeybindButton.Text = "Keybind: [" .. config.keybind .. "]"
            notify("Config '" .. name .. "' chargée !", true)
        end)
    end
end

task.spawn(function()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if success and typeof(data) == "table" then
            savedConfigs = data
            updateConfigList()
        end
    end
end)

SaveConfigBtn.MouseButton1Click:Connect(function()
    local name = ConfigNameBox.Text:gsub("%s+", "")
    if name == "" then
        notify("Entre un nom valide", false)
        return
    end
    savedConfigs[name] = {keybind = teleportKey.Name}
    local json = HttpService:JSONEncode(savedConfigs)
    if writefile then
        writefile(CONFIG_FILE, json)
        notify("Config '" .. name .. "' sauvegardée !", true)
    end
    updateConfigList()
    ConfigNameBox.Text = ""
end)

KeybindButton.MouseButton1Click:Connect(function()
    KeybindButton.Text = "Press a key..."
    waitingForKey = true
end)

-- ======================================
-- Onglet VIP (tout intact)
-- ======================================
local VIPTitle = Instance.new("TextLabel")
VIPTitle.Size = UDim2.new(0, 200, 0, 50)
VIPTitle.Text = "Script VIP"
VIPTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
VIPTitle.Font = Enum.Font.GothamBlack
VIPTitle.TextSize = 28
VIPTitle.BackgroundTransparency = 1
VIPTitle.TextXAlignment = Enum.TextXAlignment.Center
VIPTitle.Parent = VIPScrollingFrame

local NamelessButton = Instance.new("TextButton")
NamelessButton.Size = UDim2.new(0, 160, 0, 40)
NamelessButton.Text = "Nameless"
NamelessButton.Font = Enum.Font.GothamBold
NamelessButton.TextSize = 18
NamelessButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
NamelessButton.TextColor3 = Color3.fromRGB(0, 0, 0)
NamelessButton.BorderSizePixel = 0
Instance.new("UICorner", NamelessButton).CornerRadius = UDim.new(0, 12)
makeButtonHover(NamelessButton)
NamelessButton.Parent = VIPScrollingFrame
NamelessButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ily123950/Vulkan/refs/heads/main/Tr"))()
    end)
    if success then notify("Nameless Hub chargé avec succès !", true) else notify("Erreur lors du chargement Nameless", false) end
end)

local AllowDisallowButton = Instance.new("TextButton")
AllowDisallowButton.Size = UDim2.new(0, 160, 0, 40)
AllowDisallowButton.Text = "Allow / Disallow"
AllowDisallowButton.Font = Enum.Font.GothamBold
AllowDisallowButton.TextSize = 16
AllowDisallowButton.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
AllowDisallowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AllowDisallowButton.BorderSizePixel = 0
Instance.new("UICorner", AllowDisallowButton).CornerRadius = UDim.new(0, 12)
makeButtonHover(AllowDisallowButton)
AllowDisallowButton.Parent = VIPScrollingFrame
AllowDisallowButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://pastebin.com/raw/aipXbhpf",true))()
    end)
    if success then notify("Allow/Disallow script chargé !", true) else notify("Erreur lors du chargement Allow/Disallow", false) end
end)

local BlockInstantButton = Instance.new("TextButton")
BlockInstantButton.Size = UDim2.new(0, 160, 0, 40)
BlockInstantButton.Text = "Block Instant"
BlockInstantButton.Font = Enum.Font.GothamBold
BlockInstantButton.TextSize = 18
BlockInstantButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
BlockInstantButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BlockInstantButton.BorderSizePixel = 0
Instance.new("UICorner", BlockInstantButton).CornerRadius = UDim.new(0, 12)
makeButtonHover(BlockInstantButton)
BlockInstantButton.Parent = VIPScrollingFrame
BlockInstantButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sabscripts063-cloud/Kdml-Not-Me/main/BlockPlayer"))()
    end)
    if success then notify("Block Instant chargé avec succès !", true) else notify("Erreur lors du chargement Block Instant", false) end
end)

local AutoKickButton = Instance.new("TextButton")
AutoKickButton.Size = UDim2.new(0, 160, 0, 40)
AutoKickButton.Text = "Auto Kick"
AutoKickButton.Font = Enum.Font.GothamBold
AutoKickButton.TextSize = 18
AutoKickButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
AutoKickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoKickButton.BorderSizePixel = 0
Instance.new("UICorner", AutoKickButton).CornerRadius = UDim.new(0, 12)
makeButtonHover(AutoKickButton)
AutoKickButton.Parent = VIPScrollingFrame
AutoKickButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/avJfNdOe/raw"))()
    end)
    if success then notify("Auto Kick chargé avec succès !", true) else notify("Erreur lors du chargement d'Auto Kick", false) end
end)

local AdminSpammerButton = Instance.new("TextButton")
AdminSpammerButton.Size = UDim2.new(0, 160, 0, 40)
AdminSpammerButton.Text = "Admin Spammer"
AdminSpammerButton.Font = Enum.Font.GothamBold
AdminSpammerButton.TextSize = 18
AdminSpammerButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
AdminSpammerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AdminSpammerButton.BorderSizePixel = 0
Instance.new("UICorner", AdminSpammerButton).CornerRadius = UDim.new(0, 12)
makeButtonHover(AdminSpammerButton)
AdminSpammerButton.Parent = VIPScrollingFrame
AdminSpammerButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/sC8g14Ek/raw"))()
    end)
    if success then notify("Admin Spammer chargé avec succès !", true) else notify("Erreur lors du chargement d'Admin Spammer", false) end
end)

-- ======================================
-- Téléport fixe (du premier script Zay Hub)
-- ======================================
local REQUIRED_TOOL = "Flying Carpet"
local lastStealer = nil

local spots = {
    CFrame.new(-402.18, -6.34, 131.83) * CFrame.Angles(0, math.rad(-20.08), 0),
    CFrame.new(-416.66, -6.34, -2.05) * CFrame.Angles(0, math.rad(-62.89), 0),
    CFrame.new(-329.37, -4.68, 18.12) * CFrame.Angles(0, math.rad(-30.53), 0)
}

local function equipFlyingCarpet()
    local tool = char:FindFirstChild(REQUIRED_TOOL) or backpack:FindFirstChild(REQUIRED_TOOL)
    if not tool then
        notify("Flying Carpet non trouvé", false)
        return false
    end
    humanoid:EquipTool(tool)
    while char:FindFirstChildOfClass("Tool") ~= tool do task.wait() end
    return true
end

local function block(plr)
    if not plr or plr == player then return end
    pcall(function()
        StarterGui:SetCore("PromptBlockPlayer", plr)
        notify("Utilisateur " .. plr.Name .. " bloqué", true)
    end)
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
    notify("Téléportation effectuée", true)
    if lastStealer then block(lastStealer) end
end

TeleportButton.MouseButton1Click:Connect(teleportAll)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == teleportKey then
        teleportAll()
    elseif waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
        teleportKey = input.KeyCode
        KeybindButton.Text = "Keybind: [" .. teleportKey.Name .. "]"
        waitingForKey = false
    end
end)

-- ======================================
-- Gestion onglets
-- ======================================
local function selectTab(selected)
    MainTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    VisualsTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    VisualsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    ConfigTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ConfigTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    VIPTtab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    VIPTtab.TextColor3 = Color3.fromRGB(200, 200, 200)
    selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    selected.TextColor3 = Color3.fromRGB(0, 0, 0)
    MainContent.Visible = selected == MainTab
    VisualsContent.Visible = selected == VisualsTab
    ConfigContent.Visible = selected == ConfigTab
    VIPScrollingFrame.Visible = selected == VIPTtab
end

MainTab.MouseButton1Click:Connect(function() selectTab(MainTab) end)
VisualsTab.MouseButton1Click:Connect(function() selectTab(VisualsTab) end)
ConfigTab.MouseButton1Click:Connect(function() selectTab(ConfigTab) end)
VIPTtab.MouseButton1Click:Connect(function() selectTab(VIPTtab) end)
selectTab(MainTab)

-- Toggle GUI
local function openGUI()
    ScreenGui.Enabled = true
    TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        GroupTransparency = 0,
        Size = UDim2.new(0, 240, 0, 400)
    }):Play()
end

local function closeGUI()
    TweenService:Create(MainContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        GroupTransparency = 1,
        Size = UDim2.new(0, 200, 0, 360)
    }):Play()
    task.delay(0.25, function()
        ScreenGui.Enabled = false
    end)
end

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -36, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 24
CloseButton.BorderSizePixel = 0
CloseButton.Parent = MainContainer
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 14)
CloseButton.MouseButton1Click:Connect(closeGUI)
CloseButton.MouseEnter:Connect(function() CloseButton:TweenSize(UDim2.new(0, 32, 0, 32), "Out", "Quad", 0.15, true) end)
CloseButton.MouseLeave:Connect(function() CloseButton:TweenSize(UDim2.new(0, 28, 0, 28), "Out", "Quad", 0.15, true) end)

LauncherButton.MouseButton1Click:Connect(function()
    if ScreenGui.Enabled then closeGUI() else openGUI() end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        if ScreenGui.Enabled then closeGUI() else openGUI() end
    end
end)

-- ======================================
-- ESP + FPS Boost + HUD
-- ======================================
local ESPEnabled = false
local ESPObjects = {}
local myAttachment = Instance.new("Attachment")
myAttachment.Parent = hrp

local function createESP(plr)
    if plr == player or ESPObjects[plr] then return end
    local character = plr.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Head") then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
    highlight.OutlineTransparency = 0
    highlight.Adornee = character
    highlight.Parent = character
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = character:FindFirstChild("Head")
    billboard.Size = UDim2.new(0, 80, 0, 32)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = playerGui
    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextScaled = true
    nameLabel.TextStrokeTransparency = 0
    local att1 = Instance.new("Attachment")
    att1.Parent = character:FindFirstChild("HumanoidRootPart")
    local beam = Instance.new("Beam")
    beam.Attachment0 = myAttachment
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.Transparency = NumberSequence.new(0.3)
    beam.LightEmission = 1
    beam.FaceCamera = true
    beam.Parent = Workspace
    ESPObjects[plr] = {highlight = highlight, billboard = billboard, beam = beam, att1 = att1}
end

local function removeESP(plr)
    if ESPObjects[plr] then
        ESPObjects[plr].highlight:Destroy()
        ESPObjects[plr].billboard:Destroy()
        ESPObjects[plr].beam:Destroy()
        ESPObjects[plr].att1:Destroy()
        ESPObjects[plr] = nil
    end
end

local function toggleESP()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        notify("ESP activé", true)
        for _, plr in ipairs(Players:GetPlayers()) do createESP(plr) end
    else
        notify("ESP désactivé", false)
        for plr, _ in pairs(ESPObjects) do removeESP(plr) end
    end
end

ESPButton.MouseButton1Click:Connect(toggleESP)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if ESPEnabled then createESP(plr) end
    end)
end)

Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)

player.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    hrp = newChar:WaitForChild("HumanoidRootPart")
    if myAttachment and myAttachment.Parent then myAttachment:Destroy() end
    myAttachment = Instance.new("Attachment")
    myAttachment.Parent = hrp
end)

local function fpsBoost()
    notify("FPS Boost en cours...", true)
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        end
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        end
    end
    notify("FPS Boost activé (ultra low)", true)
end

FPSBoostButton.MouseButton1Click:Connect(fpsBoost)

-- HUD FPS / Heure
local hudGui = Instance.new("ScreenGui")
hudGui.Name = "HUDGui"
hudGui.ResetOnSpawn = false
hudGui.Parent = playerGui

local hudFrame = Instance.new("Frame")
hudFrame.Size = UDim2.new(0, 180, 0, 40)
hudFrame.Position = UDim2.new(0.5, -90, 0, 8)
hudFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
hudFrame.BackgroundTransparency = 0.1
hudFrame.BorderSizePixel = 2
hudFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
hudFrame.Active = true
hudFrame.Draggable = true
hudFrame.Parent = hudGui
Instance.new("UICorner", hudFrame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke")
stroke.Parent = hudFrame
stroke.Thickness = 2

local hueHUD = 0
RunService.RenderStepped:Connect(function(dt)
    hueHUD = (hueHUD + dt * 0.5) % 1
    stroke.Color = Color3.fromHSV(hueHUD, 1, 1)
end)

local hudText = Instance.new("TextLabel")
hudText.Size = UDim2.new(1, 0, 1, 0)
hudText.BackgroundTransparency = 1
hudText.TextColor3 = Color3.fromRGB(255, 255, 255)
hudText.Font = Enum.Font.GothamBold
hudText.TextSize = 14
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
    local fps = math.floor(1 / delta + 0.5)
    local timeString = os.date("%H:%M:%S")
    hudText.Text = "FPS: " .. fps .. "\nDEV BY ZAY\n" .. timeString
end)

notify("Luna Hub chargé ! Teleport fixe sur 3 positions + 10 places whitelist libres 🔥", true)
