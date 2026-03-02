-- ESP+ с современной панелью, RGB, Skybox, Distance
-- Для исполнителей Roblox (Drawing)

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local tweenService = game:GetService("TweenService")

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
        skybox = 1,
        fogColor = Color3.fromRGB(128, 128, 128)
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

-- ========== СОЗДАНИЕ ПАНЕЛИ ==========
local function createModernPanel()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernESP"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false

    -- Затемнение фона
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.Visible = false
    overlay.Parent = screenGui

    -- Главная панель
    local panel = Instance.new("Frame")
    panel.Name = "MainPanel"
    panel.Size = UDim2.new(0, 400, 0, 500)
    panel.Position = UDim2.new(0.5, -200, 0.5, -250)
    panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    panel.BackgroundTransparency = 0.1
    panel.BorderSizePixel = 0
    panel.Parent = screenGui

    -- Скругление
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 15)
    panelCorner.Parent = panel

    -- Заголовок
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    header.Parent = panel

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = header

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0.8, 0, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "ESP+ PREMIUM"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    -- Вкладки
    local tabs = Instance.new("Frame")
    tabs.Name = "Tabs"
    tabs.Size = UDim2.new(1, 0, 0, 40)
    tabs.Position = UDim2.new(0, 0, 0, 40)
    tabs.BackgroundTransparency = 1
    tabs.Parent = panel

    local tabButtons = {}
    local tabContents = {}

    local function createTab(name, pos)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Tab"
        btn.Size = UDim2.new(0, 100, 0, 30)
        btn.Position = UDim2.new(0, pos, 0, 5)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = 0.2
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Parent = tabs

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        return btn
    end

    tabButtons.esp = createTab("ESP", 10)
    tabButtons.aim = createTab("AIM", 120)
    tabButtons.world = createTab("WORLD", 230)

    -- Контейнер для контента
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 0, 360)
    content.Position = UDim2.new(0, 10, 0, 90)
    content.BackgroundTransparency = 1
    content.Parent = panel

    -- ESP вкладка
    local espTab = Instance.new("ScrollingFrame")
    espTab.Name = "ESPTab"
    espTab.Size = UDim2.new(1, 0, 1, 0)
    espTab.BackgroundTransparency = 1
    espTab.ScrollBarThickness = 5
    espTab.CanvasSize = UDim2.new(0, 0, 0, 400)
    espTab.Visible = true
    espTab.Parent = content

    local espLayout = Instance.new("UIListLayout")
    espLayout.Padding = UDim.new(0, 10)
    espLayout.Parent = espTab

    -- Кнопка ESP
    local espToggle = createToggle(espTab, "ESP Enabled", settings.esp.enabled, function(v) settings.esp.enabled = v end)
    
    -- RGB контролы
    createRGBControl(espTab, "Box Color", settings.esp, "boxColor")
    createRGBControl(espTab, "Health Color", settings.esp, "healthColor")
    createRGBControl(espTab, "Name Color", settings.esp, "nameColor")
    createRGBControl(espTab, "Distance Color", settings.esp, "distColor")
    
    local skeletonToggle = createToggle(espTab, "Skeleton", settings.esp.skeleton, function(v) settings.esp.skeleton = v end)
    local teamToggle = createToggle(espTab, "Team Check", settings.esp.teamCheck, function(v) settings.esp.teamCheck = v end)

    -- AIM вкладка
    local aimTab = Instance.new("ScrollingFrame")
    aimTab.Name = "AIMTab"
    aimTab.Size = UDim2.new(1, 0, 1, 0)
    aimTab.BackgroundTransparency = 1
    aimTab.ScrollBarThickness = 5
    aimTab.CanvasSize = UDim2.new(0, 0, 0, 300)
    aimTab.Visible = false
    aimTab.Parent = content

    local aimLayout = Instance.new("UIListLayout")
    aimLayout.Padding = UDim.new(0, 10)
    aimLayout.Parent = aimTab

    local aimToggle = createToggle(aimTab, "AIM Enabled", settings.aim.enabled, function(v) settings.aim.enabled = v end)
    createSlider(aimTab, "FOV Radius", settings.aim, "fov", 50, 500)
    createSlider(aimTab, "Smoothness", settings.aim, "smoothness", 0.1, 1)
    local fovToggle = createToggle(aimTab, "Show FOV Circle", settings.aim.visible, function(v) settings.aim.visible = v end)

    -- WORLD вкладка
    local worldTab = Instance.new("ScrollingFrame")
    worldTab.Name = "WORLDTab"
    worldTab.Size = UDim2.new(1, 0, 1, 0)
    worldTab.BackgroundTransparency = 1
    worldTab.ScrollBarThickness = 5
    worldTab.CanvasSize = UDim2.new(0, 0, 0, 300)
    worldTab.Visible = false
    worldTab.Parent = content

    local worldLayout = Instance.new("UIListLayout")
    worldLayout.Padding = UDim.new(0, 10)
    worldLayout.Parent = worldTab

    -- Кнопки скайбокса
    local skyLabel = Instance.new("TextLabel")
    skyLabel.Size = UDim2.new(1, -10, 0, 25)
    skyLabel.BackgroundTransparency = 1
    skyLabel.Text = "Skybox:"
    skyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    skyLabel.TextXAlignment = Enum.TextXAlignment.Left
    skyLabel.Font = Enum.Font.Gotham
    skyLabel.TextSize = 14
    skyLabel.Parent = worldTab

    local skyGrid = Instance.new("Frame")
    skyGrid.Size = UDim2.new(1, -10, 0, 120)
    skyGrid.BackgroundTransparency = 1
    skyGrid.Parent = worldTab

    for i, sky in ipairs(skyboxes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 70, 0, 25)
        btn.Position = UDim2.new(0, ((i-1) % 4) * 75, 0, math.floor((i-1)/4) * 30)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.Text = sky.Name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 10
        btn.BorderSizePixel = 0
        btn.Parent = skyGrid

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            setSkybox(i)
        end)
    end

    -- Переключение вкладок
    local function switchTab(tab)
        espTab.Visible = (tab == "esp")
        aimTab.Visible = (tab == "aim")
        worldTab.Visible = (tab == "world")
        
        for name, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = (name == tab) and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
        end
    end

    tabButtons.esp.MouseButton1Click:Connect(function() switchTab("esp") end)
    tabButtons.aim.MouseButton1Click:Connect(function() switchTab("aim") end)
    tabButtons.world.MouseButton1Click:Connect(function() switchTab("world") end)

    -- Закрытие панели
    closeBtn.MouseButton1Click:Connect(function()
        panel.Visible = false
        overlay.Visible = false
    end)

    -- Открытие по Insert
    uis.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            panel.Visible = not panel.Visible
            overlay.Visible = panel.Visible
        end
    end)

    return panel
end

-- ========== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ UI ==========
function createToggle(parent, text, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(1, -55, 0, 2.5)
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    btn.Text = defaultValue and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local new = not (btn.Text == "ON")
        btn.BackgroundColor3 = new and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        btn.Text = new and "ON" or "OFF"
        callback(new)
    end)

    return frame
end

function createSlider(parent, text, settingsTable, settingName, min, max)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(settingsTable[settingName])
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.Parent = frame

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -20, 0, 5)
    slider.Position = UDim2.new(0, 10, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    slider.BorderSizePixel = 0
    slider.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((settingsTable[settingName] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 20, 0, 20)
    button.Position = UDim2.new((settingsTable[settingName] - min) / (max - min), -10, 0, -7.5)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = ""
    button.BorderSizePixel = 0
    button.Parent = slider

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
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
            local pos = uis:GetMouseLocation().X - slider.AbsolutePosition.X
            local percent = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            if type(min) == "number" and math.floor then
                value = math.floor(value * 10) / 10
            end
            settingsTable[settingName] = value
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            button.Position = UDim2.new(percent, -10, 0, -7.5)
        end
    end)
end

function createRGBControl(parent, text, settingsTable, colorName)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = frame

    local color = settingsTable[colorName]

    local function updateColor()
        settingsTable[colorName] = color
    end

    local function createChannel(channel, xPos, defaultVal)
        local channelFrame = Instance.new("Frame")
        channelFrame.Size = UDim2.new(0, 100, 0, 30)
        channelFrame.Position = UDim2.new(0, xPos, 0, 25)
        channelFrame.BackgroundTransparency = 1
        channelFrame.Parent = frame

        local channelLabel = Instance.new("TextLabel")
        channelLabel.Size = UDim2.new(0, 20, 0, 20)
        channelLabel.Position = UDim2.new(0, 0, 0, 5)
        channelLabel.BackgroundTransparency = 1
        channelLabel.Text = channel
        channelLabel.TextColor3 = channel == "R" and Color3.fromRGB(255,0,0) or (channel == "G" and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,0,255))
        channelLabel.Font = Enum.Font.GothamBold
        channelLabel.TextSize = 14
        channelLabel.Parent = channelFrame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 50, 0, 25)
        box.Position = UDim2.new(0, 25, 0, 2.5)
        box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        box.Text = tostring(math.floor(color[channel:lower()] * 255))
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.Font = Enum.Font.Gotham
        box.TextSize = 12
        box.BorderSizePixel = 0
        box.Parent = channelFrame

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 6)
        boxCorner.Parent = box

        box.FocusLost:Connect(function()
            local val = math.clamp(tonumber(box.Text) or defaultVal, 0, 255) / 255
            color = Color3.new(
                channel == "R" and val or color.R,
                channel == "G" and val or color.G,
                channel == "B" and val or color.B
            )
            settingsTable[colorName] = color
        end)
    end

    createChannel("R", 0, color.R * 255)
    createChannel("G", 110, color.G * 255)
    createChannel("B", 220, color.B * 255)
end

function math.clamp(x, min, max)
    return math.max(min, math.min(max, x))
end

-- ========== ESP ==========
local espObjects = {}
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Thickness = 2
fovCircle.NumSides = 60
fovCircle.Filled = false

-- Проверка тиммейта
local function isTeammate(plr)
    if not settings.esp.teamCheck then return false end
    if player.Team and plr.Team then return player.Team == plr.Team end
    if player.TeamColor and plr.TeamColor then return player.TeamColor == plr.TeamColor end
    return false
end

-- Поиск цели для аима
local function getTarget()
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
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

-- Аим
local function aimAt(head)
    if not head or not settings.aim.enabled then return end
    if mousemoverel then
        local pos, vis = camera:WorldToViewportPoint(head.Position)
        if vis then
            local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            local delta = Vector2.new(pos.X, pos.Y) - center
            mousemoverel(delta.X * settings.aim.smoothness, delta.Y * settings.aim.smoothness)
        end
    end
end

-- Создание ESP для игрока
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

    local distanceText = Drawing.new("Text")
    distanceText. Visible = false
    distanceText.Center = true
    distanceText.Size = 12
    distanceText.Outline = true
    distanceText.OutlineColor = Color3.fromRGB(0,0,0)
    distanceText.Font = 2

    local skeletonLines = {}
    for i=1,10 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255,0,255)
        line.Thickness = 2
        table.insert(skeletonLines, line)
    end

    local data = {
        box = box,
        name = nameText,
        hpBg = healthBarBg,
        hpFill = healthBarFill,
        distance = distanceText,
        skeleton = skeletonLines
    }
    espObjects[plr] = data

    local heartbeat = runService.Heartbeat:Connect(function()
        -- Обновление цветов
        box.Color = settings.esp.boxColor
        nameText.Color = settings.esp.nameColor
        healthBarFill.Color = settings.esp.healthColor
        distanceText.Color = settings.esp.distColor

        if not settings.esp.enabled or not plr.Character or isTeammate(plr) then
            box.Visible = false
            nameText.Visible = false
            healthBarBg.Visible = false
            healthBarFill.Visible = false
            distanceText.Visible = false
            for _,l in ipairs(skeletonLines) do l.Visible = false end
            return
        end

        local char = plr.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not root or not hum then
            box.Visible = false
            nameText.Visible = false
            healthBarBg.Visible = false
            healthBarFill.Visible = false
            distanceText.Visible = false
            for _,l in ipairs(skeletonLines) do l.Visible = false end
            return
        end

        local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
        if not onScreen then
            box.Visible = false
            nameText.Visible = false
            healthBarBg.Visible = false
            healthBarFill.Visible = false
            distanceText.Visible = false
            for _,l in ipairs(skeletonLines) do l.Visible = false end
            return
        end

        local dist = (camera.CFrame.Position - root.Position).Magnitude
        local scale = 600 / (dist + 0.001)
        local width = 4 * scale
        local height = 6 * scale

        -- Бокс
        box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2 - 20)
        box.Size = Vector2.new(width, height)
        box.Visible = true

        -- Имя
        nameText.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 40)
        nameText.Text = plr.Name
        nameText.Visible = true

        -- Полоска здоровья
        local healthPercent = hum.Health / hum.MaxHealth
        local barWidth = 60
        local barHeight = 6
        local barX = rootPos.X - barWidth/2
        local barY = rootPos.Y - height/2 - 50

        healthBarBg.Position = Vector2.new(barX, barY)
        healthBarBg.Size = Vector2.new(barWidth, barHeight)
        healthBarBg.Visible = true

        healthBarFill.Position = Vector2.new(barX, barY)
        healthBarFill.Size = Vector2.new(barWidth * healthPercent, barHeight)
        healthBarFill.Visible = true

        -- Дистанция
        distanceText.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 65)
        distanceText.Text = math.floor(dist) .. "m"
        distanceText.Visible = true

        -- Скелет
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
                    line.From = lines[i][1]
                    line.To = lines[i][2]
                    line.Visible = true
                else
                    line.Visible = false
                end
            end
        else
            for _,line in ipairs(skeletonLines) do line.Visible = false end
        end
    end)

    plr.AncestryChanged:Connect(function()
        if not plr.Parent then
            heartbeat:Disconnect()
            box:Remove()
            nameText:Remove()
            healthBarBg:Remove()
            healthBarFill:Remove()
            distanceText:Remove()
            for _,l in ipairs(skeletonLines) do l:Remove() end
            espObjects[plr] = nil
        end
    end)
end

-- Главный цикл
runService.Heartbeat:Connect(function()
    if settings.aim.enabled and settings.aim.visible then
        fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        fovCircle.Radius = settings.aim.fov
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end

    if settings.aim.enabled then
        local target = getTarget()
        aimAt(target)
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
