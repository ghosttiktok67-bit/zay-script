-- ======================================
-- Services
-- ======================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Camera = Workspace.CurrentCamera
-- ======================================
-- Joueur et personnage
-- ======================================
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")
local playerGui = player:WaitForChild("PlayerGui")
-- Gestion respawn (fix crash)
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)
-- ======================================
-- Whitelist par UserId
-- ======================================
local Whitelist = {
    9173033891, -- moi
    5182071786, -- Ami 1
    5125152468, -- ACHETEUR KETUPAT 105M
    4269265728, -- acheteur 10euro
    1617845814, -- free le bon 13
    1234454555, -- ACHETEUR KEBECOIS
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
-- Launcher Icon Luna Hub (contour rainbow animé autour du bouton, texte sans stroke)
-- ======================================
local LauncherGui = Instance.new("ScreenGui")
LauncherGui.Name = "LunaHubLauncher"
LauncherGui.ResetOnSpawn = false
LauncherGui.Parent = playerGui
local LauncherButton = Instance.new("TextButton")
LauncherButton.Size = UDim2.new(0, 60, 0, 60) -- Réduit pour plus de compacité
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
local Corner = Instance.new("UICorner", LauncherButton)
Corner.CornerRadius = UDim.new(0, 12)
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
-- Notifications (Style Discord Toast avec barre de progression + ✅ stylé)
-- ======================================
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "NotifGui"
notifGui.ResetOnSpawn = false
notifGui.Parent = playerGui
local function notify(text, isSuccess)
    local duration = 3
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 60) -- Réduit pour compacité
    frame.Position = UDim2.new(0.5, -160, 0, -70)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = notifGui
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)
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
    icon.TextStrokeTransparency = 0.6
    icon.TextStrokeColor3 = isSuccess and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 100, 100)
    icon.TextXAlignment = Enum.TextXAlignment.Center
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
    progressBg.BorderSizePixel = 0
    progressBg.Parent = frame
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    local progressCorner = Instance.new("UICorner", progressBar)
    progressCorner.CornerRadius = UDim.new(0, 2)
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -160, 0, 15)}):Play()
    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
    task.delay(duration, function()
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -160, 0, -70)}):Play()
        task.wait(0.45)
        frame:Destroy()
    end)
end
-- ======================================
-- GUI principale avec onglets horizontaux
-- ======================================
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "LunaHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false
local MainContainer = Instance.new("CanvasGroup")
MainContainer.Size = UDim2.new(0, 240, 0, 320) -- Réduit (avant 280x430)
MainContainer.Position = UDim2.new(0.5, -120, 0.5, -160)
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
Title.Size = UDim2.new(1, -16, 0, 32) -- Réduit
Title.Position = UDim2.new(0, 8, 0, 8)
Title.Text = "Luna Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.TextStrokeTransparency = 0.2
Title.TextXAlignment = Enum.TextXAlignment.Center
-- Barre d'onglets
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 32) -- Réduit
TabBar.Position = UDim2.new(0, 8, 0, 42)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainContainer
local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Padding = UDim.new(0, 8)
TabListLayout.Parent = TabBar
local function createTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 70, 1, 0) -- Réduit (avant 90)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 16
    tabButton.BorderSizePixel = 0
    tabButton.Parent = TabBar
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)
    return tabButton
end
local MainTab = createTab("Main")
local VisualsTab = createTab("Visuals")
local ConfigTab = createTab("Config")
-- Contenu des onglets
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -24, 1, -84) -- Ajusté pour compacité
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
-- Hover boutons
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
-- Boutons Main
local TeleportButton = Instance.new("TextButton", MainContent)
TeleportButton.Size = UDim2.new(0, 160, 0, 40) -- Réduit
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
-- Boutons Config
local teleportKey = Enum.KeyCode.F -- Déplacé ici pour éviter erreur dans SaveConfig
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
local ConfigBox = Instance.new("TextBox", ConfigContent)
ConfigBox.Size = UDim2.new(0, 180, 0, 60) -- Réduit
ConfigBox.Position = UDim2.new(0.5, -90, 0, 60)
ConfigBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ConfigBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigBox.Font = Enum.Font.Gotham
ConfigBox.TextSize = 12
ConfigBox.MultiLine = true
ConfigBox.PlaceholderText = "Entre ta config ici pour load"
ConfigBox.Text = ""
Instance.new("UICorner", ConfigBox).CornerRadius = UDim.new(0, 8)
local SaveConfigBtn = Instance.new("TextButton", ConfigContent)
SaveConfigBtn.Size = UDim2.new(0, 80, 0, 32)
SaveConfigBtn.Position = UDim2.new(0.5, -85, 0, 130)
SaveConfigBtn.Text = "Save"
SaveConfigBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SaveConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SaveConfigBtn).CornerRadius = UDim.new(0, 8)
makeButtonHover(SaveConfigBtn)
local LoadConfigBtn = Instance.new("TextButton", ConfigContent)
LoadConfigBtn.Size = UDim2.new(0, 80, 0, 32)
LoadConfigBtn.Position = UDim2.new(0.5, 5, 0, 130)
LoadConfigBtn.Text = "Load"
LoadConfigBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
LoadConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", LoadConfigBtn).CornerRadius = UDim.new(0, 8)
makeButtonHover(LoadConfigBtn)
-- Toggles logic (seulement pour config keybind)
SaveConfigBtn.MouseButton1Click:Connect(function()
    local configStr = "Keybind:" .. teleportKey.Name
    ConfigBox.Text = configStr
    notify("Config saved ! Copie le texte.", true)
end)
LoadConfigBtn.MouseButton1Click:Connect(function()
    local txt = ConfigBox.Text
    local key = txt:match("Keybind:(%w+)")
    if key and Enum.KeyCode[key] then
        teleportKey = Enum.KeyCode[key]
        KeybindButton.Text = "Keybind: [" .. key .. "]"
        notify("Config loaded !", true)
    else
        notify("Config invalide", false)
    end
end)
-- Gestion onglets
local function selectTab(selected)
    for _, tab in pairs({MainTab, VisualsTab, ConfigTab}) do
        tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    selected.TextColor3 = Color3.fromRGB(0, 0, 0)
    MainContent.Visible = selected == MainTab
    VisualsContent.Visible = selected == VisualsTab
    ConfigContent.Visible = selected == ConfigTab
end
MainTab.MouseButton1Click:Connect(function() selectTab(MainTab) end)
VisualsTab.MouseButton1Click:Connect(function() selectTab(VisualsTab) end)
ConfigTab.MouseButton1Click:Connect(function() selectTab(ConfigTab) end)
selectTab(MainTab)
-- Toggle GUI
local tweenInfoPop = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local function openGUI()
    ScreenGui.Enabled = true
    MainContainer.GroupTransparency = 0.6
    MainContainer.Size = UDim2.new(0, 200, 0, 280)
    TweenService:Create(MainContainer, tweenInfoPop, {
        GroupTransparency = 0,
        Size = UDim2.new(0, 240, 0, 320)
    }):Play()
end
local function closeGUI()
    TweenService:Create(MainContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        GroupTransparency = 1,
        Size = UDim2.new(0, 200, 0, 280)
    }):Play()
    task.delay(0.25, function()
        ScreenGui.Enabled = false
    end)
end
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
-- Teleport Logic
-- ======================================
local REQUIRED_TOOL = "Flying Carpet"
local waitingForKey = false
local lastStealer = nil
local spots = {
    CFrame.new(-402.18, -6.34, 131.83) * CFrame.Angles(0, math.rad(-20.08), 0),
    CFrame.new(-416.66, -6.34, -2.05) * CFrame.Angles(0, math.rad(-62.89), 0),
    CFrame.new(-329.37, -4.68, 18.12) * CFrame.Angles(0, math.rad(-30.53), 0)
}
local function equipFlyingCarpet()
    local tool = char:FindFirstChild(REQUIRED_TOOL) or backpack:FindFirstChild(REQUIRED_TOOL)
    if not tool then notify("Flying Carpet non trouvé", false) return false end
    humanoid:EquipTool(tool)
    while char:FindFirstChildOfClass("Tool") ~= tool do task.wait() end
    return true
end
local function block(plr)
    if not plr or plr == player then return end
    local success = pcall(function()
        StarterGui:SetCore("PromptBlockPlayer", plr)
    end)
    if success then
        notify("Utilisateur " .. plr.Name .. " bloqué", true)
    else
        notify("Impossible de bloquer " .. plr.Name, false)
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
    notify("Téléportation effectuée", true)
    if lastStealer then block(lastStealer) end
end
TeleportButton.MouseButton1Click:Connect(teleportAll)
KeybindButton.MouseButton1Click:Connect(function()
    KeybindButton.Text = "Press a key..."
    waitingForKey = true
end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
        teleportKey = input.KeyCode
        KeybindButton.Text = "Keybind: [" .. teleportKey.Name .. "]"
        waitingForKey = false
    elseif input.KeyCode == teleportKey then
        teleportAll()
    end
end)
-- ======================================
-- ESP
-- ======================================
local ESPEnabled = false
local ESPObjects = {}
local function createESP(plr)
    if plr == player or ESPObjects[plr] then return end
    local character = plr.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
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
    local att0 = Instance.new("Attachment")
    att0.Parent = hrp
    local beam = Instance.new("Beam")
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.Transparency = NumberSequence.new(0.3)
    beam.LightEmission = 1
    beam.FaceCamera = true
    beam.Parent = Workspace
    ESPObjects[plr] = {highlight = highlight, billboard = billboard, beam = beam, att0 = att0, att1 = att1}
end
local function removeESP(plr)
    if ESPObjects[plr] then
        ESPObjects[plr].highlight:Destroy()
        ESPObjects[plr].billboard:Destroy()
        ESPObjects[plr].beam:Destroy()
        ESPObjects[plr].att0:Destroy()
        ESPObjects[plr].att1:Destroy()
        ESPObjects[plr] = nil
    end
end
local function toggleESP()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        notify("ESP activé", true)
        for _, plr in ipairs(Players:GetPlayers()) do
            createESP(plr)
        end
    else
        notify("ESP désactivé", false)
        for plr, _ in pairs(ESPObjects) do
            removeESP(plr)
        end
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
-- FPS Boost
-- ======================================
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
-- ======================================
-- HUD FPS / DEV BY ZAY / Heure
-- ======================================
local hudGui = Instance.new("ScreenGui")
hudGui.Name = "HUDGui"
hudGui.ResetOnSpawn = false
hudGui.Parent = playerGui
local hudFrame = Instance.new("Frame")
hudFrame.Size = UDim2.new(0, 180, 0, 40) -- Réduit
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
