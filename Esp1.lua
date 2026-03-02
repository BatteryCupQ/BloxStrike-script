-- ESP+ с современной панелью, RGB, Skybox, Distance (ИСПРАВЛЕНО)
-- Для исполнителей Roblox (Drawing)

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")

-- ========== НАСТРОЙКИ ==========
local settings = {
    esp = {
        enabled = true,
        boxColor = Color3.fromRGB(255, 0, 0),
        healthColor = Color3.fromRGB(255, 255, 255),
        nameColor = Color3.fromRGB(255, 255, 255),
        distColor = Color3.fromRGB(255, 255, 0),
        skeleton = true,
        teamCheck = false
    },
    aim = {
        enabled = false,
        fov = 150,
        smoothness = 0.3,
        visible = true
    },
    world = {
        skybox = 1
    }
}

-- ========== SKYBOX ==========
local skyboxes = {
    {Name = "Default", Id = ""},
    {Name = "Night", Id = "159454284"},
    {Name = "Sunset", Id = "159454316"},
    {Name = "Desert", Id = "159454357"},
    {Name = "Arctic", Id = "159454393"},
    {Name = "Jungle", Id = "159454429"},
    {Name = "Space", Id = "159454465"},
    {Name = "Clouds", Id = "159454501"}
}

local function setSkybox(index)
    if index == 1 then
        lighting:ClearAllChildren()
        return
    end
    local sky = Instance.new("Sky")
    local id = skyboxes[index].Id
    sky.SkyboxBk = "rbxassetid://" .. id
    sky.SkyboxDn = "rbxassetid://" .. id
    sky.SkyboxFt = "rbxassetid://" .. id
    sky.SkyboxLf = "rbxassetid://" .. id
    sky.SkyboxRt = "rbxassetid://" .. id
    sky.SkyboxUp = "rbxassetid://" .. id
    sky.Parent = lighting
    settings.world.skybox = index
end

-- ========== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ==========
local function createToggle(parent, text, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(1, -55, 0, 2.5)
    btn.BackgroundColor3 = getter() and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    btn.Text = getter() and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local new = not getter()
        setter(new)
        btn.BackgroundColor3 = new and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        btn.Text = new and "ON" or "OFF"
    end)
    return frame
end

local function createSlider(parent, text, getter, setter, min, max, format)
    format = format or "%.1f"
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = string.format(format, getter())
    valueLabel.TextColor3 = Color3.fromRGB(255,255,255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 5)
    sliderBg.Position = UDim2.new(0, 10, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((getter()-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0,120,255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 20, 0, 20)
    button.Position = UDim2.new((getter()-min)/(max-min), -10, 0, -7.5)
    button.BackgroundColor3 = Color3.fromRGB(255,255,255)
    button.Text = ""
    button.BorderSizePixel = 0
    button.Parent = sliderBg

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1,0)
    buttonCorner.Parent = button

    local dragging = false
    button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    uis.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = uis:GetMouseLocation().X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
            local value = min + (max-min) * percent
            setter(value)
            valueLabel.Text = string.format(format, value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            button.Position = UDim2.new(percent, -10, 0, -7.5)
        end
    end)
    return frame
end

local function createRGBControl(parent, text, colorRef)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = frame

    local function createChannel(ch, x, default)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 50, 0, 25)
        box.Position = UDim2.new(0, x, 0, 25)
        box.BackgroundColor3 = Color3.fromRGB(40,40,40)
        box.Text = tostring(math.floor(default * 255))
        box.TextColor3 = Color3.fromRGB(255,255,255)
        box.Font = Enum.Font.Gotham
        box.TextSize = 12
        box.BorderSizePixel = 0
        box.Parent = frame

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0,6)
        boxCorner.Parent = box

        box.FocusLost:Connect(function()
            local val = math.clamp(tonumber(box.Text) or 0, 0, 255) / 255
            local r,g,b = colorRef.R, colorRef.G, colorRef.B
            if ch == "R" then r = val
            elseif ch == "G" then g = val
            else b = val end
            colorRef.Value = Color3.new(r,g,b)
        end)
    end

    createChannel("R", 10, colorRef.R)
    createChannel("G", 70, colorRef.G)
    createChannel("B", 130, colorRef.B)
end

function math.clamp(x, min, max)
    return math.max(min, math.min(max, x))
end

-- ========== СОЗДАНИЕ ПАНЕЛИ ==========
local function createModernPanel()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernESP"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.5
    overlay.Visible = false
    overlay.Parent = screenGui

    local panel = Instance.new("Frame")
    panel.Name = "MainPanel"
    panel.Size = UDim2.new(0,400,0,500)
    panel.Position = UDim2.new(0.5,-200,0.5,-250)
    panel.BackgroundColor3 = Color3.fromRGB(20,20,20)
    panel.BackgroundTransparency = 0.1
    panel.BorderSizePixel = 0
    panel.Parent = screenGui

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0,15)
    panelCorner.Parent = panel

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1,0,0,40)
    header.BackgroundColor3 = Color3.fromRGB(30,30,30)
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    header.Parent = panel

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0,15)
    headerCorner.Parent = header

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0.8,0,1,0)
    title.Position = UDim2.new(0,15,0,0)
    title.BackgroundTransparency = 1
    title.Text = "ESP+ PREMIUM"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0,30,0,30)
    closeBtn.Position = UDim2.new(1,-35,0,5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0,8)
    closeCorner.Parent = closeBtn

    -- Вкладки
    local tabs = Instance.new("Frame")
    tabs.Name = "Tabs"
    tabs.Size = UDim2.new(1,0,0,40)
    tabs.Position = UDim2.new(0,0,0,40)
    tabs.BackgroundTransparency = 1
    tabs.Parent = panel

    local function createTab(name, pos)
        local btn = Instance.new("TextButton")
        btn.Name = name.."Tab"
        btn.Size = UDim2.new(0,100,0,30)
        btn.Position = UDim2.new(0,pos,0,5)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.BackgroundTransparency = 0.2
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Parent = tabs
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0,8)
        btnCorner.Parent = btn
        return btn
    end

    local tabButtons = {
        esp = createTab("ESP",10),
        aim = createTab("AIM",120),
        world = createTab("WORLD",230)
    }

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1,-20,0,360)
    content.Position = UDim2.new(0,10,0,90)
    content.BackgroundTransparency = 1
    content.Parent = panel

    -- ESP вкладка
    local espTab = Instance.new("ScrollingFrame")
    espTab.Name = "ESPTab"
    espTab.Size = UDim2.new(1,0,1,0)
    espTab.BackgroundTransparency = 1
    espTab.ScrollBarThickness = 5
    espTab.CanvasSize = UDim2.new(0,0,0,500)
    espTab.Visible = true
    espTab.Parent = content
    local espLayout = Instance.new("UIListLayout")
    espLayout.Padding = UDim.new(0,10)
    espLayout.Parent = espTab

    createToggle(espTab, "ESP Enabled", function() return settings.esp.enabled end, function(v) settings.esp.enabled = v end)
    createRGBControl(espTab, "Box Color", {Value = settings.esp.boxColor, R=settings.esp.boxColor.R, G=settings.esp.boxColor.G, B=settings.esp.boxColor.B})
    createRGBControl(espTab, "Health Color", {Value = settings.esp.healthColor, R=settings.esp.healthColor.R, G=settings.esp.healthColor.G, B=settings.esp.healthColor.B})
    createRGBControl(espTab, "Name Color", {Value = settings.esp.nameColor, R=settings.esp.nameColor.R, G=settings.esp.nameColor.G, B=settings.esp.nameColor.B})
    createRGBControl(espTab, "Distance Color", {Value = settings.esp.distColor, R=settings.esp.distColor.R, G=settings.esp.distColor.G, B=settings.esp.distColor.B})
    createToggle(espTab, "Skeleton", function() return settings.esp.skeleton end, function(v) settings.esp.skeleton = v end)
    createToggle(espTab, "Team Check", function() return settings.esp.teamCheck end, function(v) settings.esp.teamCheck = v end)

    -- AIM вкладка
    local aimTab = Instance.new("ScrollingFrame")
    aimTab.Name = "AIMTab"
    aimTab.Size = UDim2.new(1,0,1,0)
    aimTab.BackgroundTransparency = 1
    aimTab.ScrollBarThickness = 5
    aimTab.CanvasSize = UDim2.new(0,0,0,300)
    aimTab.Visible = false
    aimTab.Parent = content
    local aimLayout = Instance.new("UIListLayout")
    aimLayout.Padding = UDim.new(0,10)
    aimLayout.Parent = aimTab

    createToggle(aimTab, "AIM Enabled", function() return settings.aim.enabled end, function(v) settings.aim.enabled = v end)
    createSlider(aimTab, "FOV Radius", function() return settings.aim.fov end, function(v) settings.aim.fov = v end, 50, 500, "%.0f")
    createSlider(aimTab, "Smoothness", function() return settings.aim.smoothness end, function(v) settings.aim.smoothness = v end, 0.1, 1, "%.2f")
    createToggle(aimTab, "Show FOV Circle", function() return settings.aim.visible end, function(v) settings.aim.visible = v end)

    -- WORLD вкладка
    local worldTab = Instance.new("ScrollingFrame")
    worldTab.Name = "WORLDTab"
    worldTab.Size = UDim2.new(1,0,1,0)
    worldTab.BackgroundTransparency = 1
    worldTab.ScrollBarThickness = 5
    worldTab.CanvasSize = UDim2.new(0,0,0,200)
    worldTab.Visible = false
    worldTab.Parent = content
    local worldLayout = Instance.new("UIListLayout")
    worldLayout.Padding = UDim.new(0,10)
    worldLayout.Parent = worldTab

    local skyLabel = Instance.new("TextLabel")
    skyLabel.Size = UDim2.new(1,-10,0,25)
    skyLabel.BackgroundTransparency = 1
    skyLabel.Text = "Skybox:"
    skyLabel.TextColor3 = Color3.fromRGB(255,255,255)
    skyLabel.TextXAlignment = Enum.TextXAlignment.Left
    skyLabel.Font = Enum.Font.Gotham
    skyLabel.TextSize = 14
    skyLabel.Parent = worldTab

    local skyGrid = Instance.new("Frame")
    skyGrid.Size = UDim2.new(1,-10,0,120)
    skyGrid.BackgroundTransparency = 1
    skyGrid.Parent = worldTab

    for i, sky in ipairs(skyboxes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,70,0,25)
        btn.Position = UDim2.new(0, ((i-1)%4)*75, 0, math.floor((i-1)/4)*30)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btn.Text = sky.Name
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 10
        btn.BorderSizePixel = 0
        btn.Parent = skyGrid
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0,6)
        btnCorner.Parent = btn
        btn.MouseButton1Click:Connect(function() setSkybox(i) end)
    end

    local function switchTab(tab)
        espTab.Visible = (tab == "esp")
        aimTab.Visible = (tab == "aim")
        worldTab.Visible = (tab == "world")
        for name, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = (name == tab) and Color3.fromRGB(60,60,60) or Color3.fromRGB(30,30,30)
        end
    end
    tabButtons.esp.MouseButton1Click:Connect(function() switchTab("esp") end)
    tabButtons.aim.MouseButton1Click:Connect(function() switchTab("aim") end)
    tabButtons.world.MouseButton1Click:Connect(function() switchTab("world") end)

    closeBtn.MouseButton1Click:Connect(function()
        panel.Visible = false
        overlay.Visible = false
    end)

    uis.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            panel.Visible = not panel.Visible
            overlay.Visible = panel.Visible
        end
    end)
end

-- ========== ESP ==========
local espObjects = {}
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255,0,0)
fovCircle.Thickness = 2
fovCircle.NumSides = 60
fovCircle.Filled = false
fovCircle.Radius = settings.aim.fov

local function isTeammate(plr)
    if not settings.esp.teamCheck then return false end
    if player.Team and plr.Team then return player.Team == plr.Team end
    if player.TeamColor and plr.TeamColor then return player.TeamColor == plr.TeamColor end
    return false
end

local function getTarget()
    local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    local closest = math.huge
    local target = nil
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and not isTeammate(plr) then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local pos, vis = camera:WorldToViewportPoint(head.Position)
                if vis then
                    local vec = Vector2.new(pos.X, pos.Y)
                    local dist = (vec - center).Magnitude
                    if dist < settings.aim.fov and dist < closest then
                        closest = dist
                        target = head
                    end
                end
            end
        end
    end
    return target
end

local function aimAt(head)
    if not head or not settings.aim.enabled then return end
    if mousemoverel then
        local pos, vis = camera:WorldToViewportPoint(head.Position)
        if vis then
            local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
            local delta = Vector2.new(pos.X, pos.Y) - center
            mousemoverel(delta.X * settings.aim.smoothness, delta.Y * settings.aim.smoothness)
        end
    end
end

local function createESPForPlayer(plr)
    if plr == player then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 2
    box.Filled = false
    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Center = true
    nameText.Size = 16
    nameText.Outline = true
    nameText.OutlineColor = Color3.fromRGB(0,0,0)
    nameText.Font = 2
    local healthBarBg = Drawing.new("Square")
    healthBarBg.Visible = false
    healthBarBg.Color = Color3.fromRGB(0,0,0)
    healthBarBg.Thickness = 1
    healthBarBg.Filled = true
    healthBarBg.Transparency = 0.5
    local healthBarFill = Drawing.new("Square")
    healthBarFill.Visible = false
    healthBarFill.Thickness = 1
    healthBarFill.Filled = true
    local distText = Drawing.new("Text")
    distText.Visible = false
    distText.Center = true
    distText.Size = 12
    distText.Outline = true
    distText.OutlineColor = Color3.fromRGB(0,0,0)
    distText.Font = 2
    local skeletonLines = {}
    for i=1,10 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255,0,255)
        line.Thickness = 2
        table.insert(skeletonLines, line)
    end
    local data = {box=box, name=nameText, hpBg=healthBarBg, hpFill=healthBarFill, dist=distText, skeleton=skeletonLines}
    espObjects[plr] = data

    local heartbeat = runService.Heartbeat:Connect(function()
        box.Color = settings.esp.boxColor
        nameText.Color = settings.esp.nameColor
        healthBarFill.Color = settings.esp.healthColor
        distText.Color = settings.esp.distColor

        if not settings.esp.enabled or not plr.Character or isTeammate(plr) then
            box.Visible = false; nameText.Visible = false; healthBarBg.Visible = false; healthBarFill.Visible = false; distText.Visible = false
            for _,l in ipairs(skeletonLines) do l.Visible = false end
            return
        end

        local char = plr.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not root or not hum then
            box.Visible = false; nameText.Visible = false; healthBarBg.Visible = false; healthBarFill.Visible = false; distText.Visible = false
            for _,l in ipairs(skeletonLines) do l.Visible = false end
            return
        end

        local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
        if not onScreen then
            box.Visible = false; nameText.Visible = false; healthBarBg.Visible = false; healthBarFill.Visible = false; distText.Visible = false
            for _,l in ipairs(skeletonLines) do l.Visible = false end
            return
        end

        local dist = (camera.CFrame.Position - root.Position).Magnitude
        local scale = 600 / (dist + 0.001)
        local width = 4 * scale
        local height = 6 * scale

        box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2 - 20)
        box.Size = Vector2.new(width, height)
        box.Visible = true

        nameText.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 40)
        nameText.Text = plr.Name
        nameText.Visible = true

        local healthPercent = hum.Health / hum.MaxHealth
        local barWidth = 60; local barHeight = 6
        local barX = rootPos.X - barWidth/2
        local barY = rootPos.Y - height/2 - 50

        healthBarBg.Position = Vector2.new(barX, barY)
        healthBarBg.Size = Vector2.new(barWidth, barHeight)
        healthBarBg.Visible = true

        healthBarFill.Position = Vector2.new(barX, barY)
        healthBarFill.Size = Vector2.new(barWidth * healthPercent, barHeight)
        healthBarFill.Visible = true

        distText.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 65)
        distText.Text = math.floor(dist) .. "m"
        distText.Visible = true

        if settings.esp.skeleton then
            local parts = {
                Head = char:FindFirstChild("Head"),
                Torso = root,
                LeftArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"),
                RightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"),
                LeftLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"),
                RightLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
            }
            local partPos = {}
            for _,part in pairs(parts) do
                if part and part:IsA("BasePart") then
                    local pos, vis = camera:WorldToViewportPoint(part.Position)
                    if vis then partPos[part] = Vector2.new(pos.X, pos.Y) end
                end
            end
            local lines = {}
            if parts.Head and parts.Torso and partPos[parts.Head] and partPos[parts.Torso] then
                table.insert(lines, {partPos[parts.Head], partPos[parts.Torso]})
            end
            if parts.Torso and parts.LeftArm and partPos[parts.Torso] and partPos[parts.LeftArm] then
                table.insert(lines, {partPos[parts.Torso], partPos[parts.LeftArm]})
            end
            if parts.Torso and parts.RightArm and partPos[parts.Torso] and partPos[parts.RightArm] then
                table.insert(lines, {partPos[parts.Torso], partPos[parts.RightArm]})
            end
            if parts.Torso and parts.LeftLeg and partPos[parts.Torso] and partPos[parts.LeftLeg] then
                table.insert(lines, {partPos[parts.Torso], partPos[parts.LeftLeg]})
            end
            if parts.Torso and parts.RightLeg and partPos[parts.Torso] and partPos[parts.RightLeg] then
                table.insert(lines, {partPos[parts.Torso], partPos[parts.RightLeg]})
            end
            for i,line in ipairs(skeletonLines) do
                if i <= #lines then
                    line.From = lines[i][1]; line.To = lines[i][2]; line.Visible = true
                else
                    line.Visible = false
                end
            end
        else
            for _,l in ipairs(skeletonLines) do l.Visible = false end
        end
    end)

    plr.AncestryChanged:Connect(function()
        if not plr.Parent then
            heartbeat:Disconnect()
            box:Remove(); nameText:Remove(); healthBarBg:Remove(); healthBarFill:Remove(); distText:Remove()
            for _,l in ipairs(skeletonLines) do l:Remove() end
            espObjects[plr] = nil
        end
    end)
end

-- Главный цикл
runService.Heartbeat:Connect(function()
    if settings.aim.enabled and settings.aim.visible then
        fovCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        fovCircle.Radius = settings.aim.fov
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end
    if settings.aim.enabled then
        aimAt(getTarget())
    end
end)

-- Запуск
if not _G.ESPLoaded then
    _G.ESPLoaded = true
    createModernPanel()
    for _,plr in ipairs(game.Players:GetPlayers()) do
        createESPForPlayer(plr)
    end
    game.Players.PlayerAdded:Connect(createESPForPlayer)
end

if syn and syn.protect_gui then
    syn.protect_gui(player.PlayerGui)
end
