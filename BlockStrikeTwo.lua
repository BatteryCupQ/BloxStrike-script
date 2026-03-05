-- ========== МЕГА КРАСИВОЕ МЕНЮ + ESP + AIM (ЧАСТЬ 1) ==========
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- ========== НАСТРОЙКИ ==========
local settings = {
    esp = {
        enabled = true,
        box = true,
        skeleton = true,
        distance = true,
        teamCheck = false,
        boxScale = 1.2,
        boxColor = Color3.fromRGB(255, 0, 0),
        skeletonColor = Color3.fromRGB(255, 0, 255),
        textColor = Color3.fromRGB(255, 255, 255)
    },
    aim = {
        enabled = false,
        fov = 150,
        smoothness = 0.5,
        targetPart = "Head"
    }
}

-- ========== ФУНКЦИИ ==========
local function isTeammate(plr)
    if not settings.esp.teamCheck then return false end
    if not plr or not player then return false end
    if player.Team and plr.Team then return player.Team == plr.Team end
    if player.TeamColor and plr.TeamColor then return player.TeamColor == plr.TeamColor end
    return false
end

-- ========== КРАСИВОЕ МЕНЮ ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MegaMenu"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- Основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Скругление
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Тень (имитация)
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(-0.03, 0, -0.03, 0)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217" -- тень
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
title.BackgroundTransparency = 0.2
title.Text = "⚡ ULTIMATE ESP ⚡"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

-- Вкладки
local tabFrame = Instance.new("Frame")
tabFrame.Name = "Tabs"
tabFrame.Size = UDim2.new(1, -20, 0, 35)
tabFrame.Position = UDim2.new(0, 10, 0, 45)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local function createTab(name, pos, color)
    local btn = Instance.new("TextButton")
    btn.Name = name.."Tab"
    btn.Size = UDim2.new(0.3, -3, 1, 0)
    btn.Position = UDim2.new(pos, 0, 0, 0)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    return btn
end

local espTab = createTab("ESP", 0, Color3.fromRGB(70, 70, 90))
local aimTab = createTab("AIM", 0.35, Color3.fromRGB(50, 50, 70))
local previewTab = createTab("PREVIEW", 0.7, Color3.fromRGB(50, 50, 70))

-- Контейнер для контента
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 0, 280)
content.Position = UDim2.new(0, 10, 0, 90)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- ========== ВКЛАДКА ESP ==========
local espContent = Instance.new("ScrollingFrame")
espContent.Name = "ESPContent"
espContent.Size = UDim2.new(1, 0, 1, 0)
espContent.BackgroundTransparency = 1
espContent.ScrollBarThickness = 5
espContent.CanvasSize = UDim2.new(0, 0, 0, 400)
espContent.Visible = true
espContent.Parent = content

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = espContent

-- Функция создания переключателя
local function createToggle(parent, text, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 25)
    btn.Position = UDim2.new(1, -65, 0.5, -12.5)
    btn.BackgroundColor3 = getter() and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    btn.Text = getter() and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local new = not getter()
        setter(new)
        btn.BackgroundColor3 = new and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        btn.Text = new and "ON" or "OFF"
    end)
end

-- Функция создания ползунка
local function createSlider(parent, text, getter, setter, min, max, format)
    format = format or "%.1f"
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = string.format(format, getter())
    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 5)
    sliderBg.Position = UDim2.new(0, 10, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((getter()-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 16, 0, 16)
    button.Position = UDim2.new((getter()-min)/(max-min), -8, 0, -5.5)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = ""
    button.BorderSizePixel = 0
    button.Parent = sliderBg

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = button

    local dragging = false
    button.MouseButton1Down:Connect(function() dragging = true end)
    uis.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    uis.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = uis:GetMouseLocation().X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
            local val = min + (max-min) * percent
            setter(val)
            valueLabel.Text = string.format(format, val)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            button.Position = UDim2.new(percent, -8, 0, -5.5)
        end
    end)
end

function math.clamp(x, a, b) return math.max(a, math.min(b, x)) end

-- Наполняем ESP вкладку
createToggle(espContent, "ESP Enabled", function() return settings.esp.enabled end, function(v) settings.esp.enabled = v end)
createToggle(espContent, "Box", function() return settings.esp.box end, function(v) settings.esp.box = v end)
createToggle(espContent, "Skeleton", function() return settings.esp.skeleton end, function(v) settings.esp.skeleton = v end)
createToggle(espContent, "Distance", function() return settings.esp.distance end, function(v) settings.esp.distance = v end)
createToggle(espContent, "Team Check", function() return settings.esp.teamCheck end, function(v) settings.esp.teamCheck = v end)
createSlider(espContent, "Box Scale", function() return settings.esp.boxScale end, function(v) settings.esp.boxScale = v end, 0.5, 3.0, "%.1f")

-- ========== ВКЛАДКА AIM ==========
local aimContent = Instance.new("ScrollingFrame")
aimContent.Name = "AIMContent"
aimContent.Size = UDim2.new(1, 0, 1, 0)
aimContent.BackgroundTransparency = 1
aimContent.ScrollBarThickness = 5
aimContent.CanvasSize = UDim2.new(0, 0, 0, 200)
aimContent.Visible = false
aimContent.Parent = content

local aimLayout = Instance.new("UIListLayout")
aimLayout.Padding = UDim.new(0, 10)
aimLayout.Parent = aimContent

createToggle(aimContent, "AIM Enabled", function() return settings.aim.enabled end, function(v) settings.aim.enabled = v end)
createSlider(aimContent, "FOV Radius", function() return settings.aim.fov end, function(v) settings.aim.fov = v end, 50, 500, "%.0f")
createSlider(aimContent, "Smoothness", function() return settings.aim.smoothness end, function(v) settings.aim.smoothness = v end, 0.1, 1, "%.2f")

-- ========== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК ==========
local function switchTab(tab)
    espContent.Visible = (tab == "esp")
    aimContent.Visible = (tab == "aim")
    previewContent.Visible = (tab == "preview")
    espTab.BackgroundColor3 = (tab == "esp") and Color3.fromRGB(70, 70, 90) or Color3.fromRGB(40, 40, 50)
    aimTab.BackgroundColor3 = (tab == "aim") and Color3.fromRGB(70, 70, 90) or Color3.fromRGB(40, 40, 50)
    previewTab.BackgroundColor3 = (tab == "preview") and Color3.fromRGB(70, 70, 90) or Color3.fromRGB(40, 40, 50)
end

espTab.MouseButton1Click:Connect(function() switchTab("esp") end)
aimTab.MouseButton1Click:Connect(function() switchTab("aim") end)
previewTab.MouseButton1Click:Connect(function() switchTab("preview") end)

-- ========== ВКЛАДКА PREVIEW (будет во второй части) ==========
local previewContent = Instance.new("Frame")
previewContent.Name = "PreviewContent"
previewContent.Size = UDim2.new(1, 0, 1, 0)
previewContent.BackgroundTransparency = 1
previewContent.Visible = false
previewContent.Parent = content
-- ========== ЧАСТЬ 2 ==========
-- ========== ВКЛАДКА PREVIEW ==========
-- Создаём превью ESP прямо в меню
local previewFrame = Instance.new("Frame")
previewFrame.Size = UDim2.new(1, -20, 0, 200)
previewFrame.Position = UDim2.new(0, 10, 0, 10)
previewFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
previewFrame.BackgroundTransparency = 0.2
previewFrame.Parent = previewContent

local previewCorner = Instance.new("UICorner")
previewCorner.CornerRadius = UDim.new(0, 10)
previewCorner.Parent = previewFrame

-- Заголовок превью
local previewTitle = Instance.new("TextLabel")
previewTitle.Size = UDim2.new(1, 0, 0, 30)
previewTitle.BackgroundTransparency = 1
previewTitle.Text = "ESP Preview"
previewTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
previewTitle.Font = Enum.Font.GothamBold
previewTitle.TextSize = 14
previewTitle.Parent = previewFrame

-- Рисуем пример бокса (просто квадрат)
local exampleBox = Instance.new("Frame")
exampleBox.Size = UDim2.new(0, 80, 0, 100)
exampleBox.Position = UDim2.new(0.5, -40, 0, 40)
exampleBox.BackgroundTransparency = 1
exampleBox.BorderSizePixel = 0
exampleBox.Parent = previewFrame

-- Линии бокса (4 стороны)
local function createLine(parent, size, pos, color, thickness)
    local line = Instance.new("Frame")
    line.Size = size
    line.Position = pos
    line.BackgroundColor3 = color
    line.BorderSizePixel = 0
    line.Parent = parent
end

createLine(exampleBox, UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 0, 0), settings.esp.boxColor, 2)
createLine(exampleBox, UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 1, -2), settings.esp.boxColor, 2)
createLine(exampleBox, UDim2.new(0, 2, 1, 0), UDim2.new(0, 0, 0, 0), settings.esp.boxColor, 2)
createLine(exampleBox, UDim2.new(0, 2, 1, 0), UDim2.new(1, -2, 0, 0), settings.esp.boxColor, 2)

-- Имя
local exampleName = Instance.new("TextLabel")
exampleName.Size = UDim2.new(1, 0, 0, 20)
exampleName.Position = UDim2.new(0.5, -50, 0, -20)
exampleName.BackgroundTransparency = 1
exampleName.Text = "Player"
exampleName.TextColor3 = settings.esp.textColor
exampleName.Font = Enum.Font.Gotham
exampleName.TextSize = 12
exampleName.Parent = exampleBox

-- Полоска здоровья
local hpBg = Instance.new("Frame")
hpBg.Size = UDim2.new(0, 60, 0, 4)
hpBg.Position = UDim2.new(0.5, -30, 0, 20)
hpBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
hpBg.BackgroundTransparency = 0.3
hpBg.Parent = exampleBox

local hpFill = Instance.new("Frame")
hpFill.Size = UDim2.new(0.7, 0, 1, 0)
hpFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hpFill.Parent = hpBg

-- Скелет (линии)
local function createSkeletonLine(parent, p1, p2, color)
    -- упрощённо: просто добавим несколько линий
end
-- Добавим несколько линий для скелета
local skel1 = Instance.new("Frame")
skel1.Size = UDim2.new(0, 2, 0, 30)
skel1.Position = UDim2.new(0.5, -1, 0, 30)
skel1.BackgroundColor3 = settings.esp.skeletonColor
skel1.BorderSizePixel = 0
skel1.Parent = exampleBox
local skel2 = Instance.new("Frame")
skel2.Size = UDim2.new(0, 2, 0, 30)
skel2.Position = UDim2.new(0.5, -1, 0, 60)
skel2.BackgroundColor3 = settings.esp.skeletonColor
skel2.BorderSizePixel = 0
skel2.Rotation = 30
skel2.Parent = exampleBox

-- Дистанция
local exampleDist = Instance.new("TextLabel")
exampleDist.Size = UDim2.new(1, 0, 0, 20)
exampleDist.Position = UDim2.new(0.5, -50, 0, 90)
exampleDist.BackgroundTransparency = 1
exampleDist.Text = "15m"
exampleDist.TextColor3 = settings.esp.textColor
exampleDist.Font = Enum.Font.Gotham
exampleDist.TextSize = 10
exampleDist.Parent = exampleBox

-- Подпись
local previewNote = Instance.new("TextLabel")
previewNote.Size = UDim2.new(1, 0, 0, 30)
previewNote.Position = UDim2.new(0, 0, 1, -30)
previewNote.BackgroundTransparency = 1
previewNote.Text = "Цвета соответствуют настройкам"
previewNote.TextColor3 = Color3.fromRGB(150, 150, 150)
previewNote.Font = Enum.Font.Gotham
previewNote.TextSize = 10
previewNote.Parent = previewFrame

-- ========== ESP (Drawing) ==========
local espObjects = {}
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Thickness = 2
fovCircle.NumSides = 60
fovCircle.Filled = false
fovCircle.Radius = settings.aim.fov

local function getTargetInFov()
    local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    local closest = settings.aim.fov
    local target = nil
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and not isTeammate(plr) then
            local part = plr.Character:FindFirstChild(settings.aim.targetPart)
            if part then
                local pos, on = camera:WorldToViewportPoint(part.Position)
                if on then
                    local vec = Vector2.new(pos.X, pos.Y)
                    local dist = (vec - center).Magnitude
                    if dist < closest then
                        closest = dist; target = part
                    end
                end
            end
        end
    end
    return target
end

local function aimAt(part)
    if not part then return end
    if mousemoverel then
        local pos, on = camera:WorldToViewportPoint(part.Position)
        if on then
            local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
            local delta = Vector2.new(pos.X, pos.Y) - center
            mousemoverel(delta.X * settings.aim.smoothness, delta.Y * settings.aim.smoothness)
        end
    else
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, part.Position)
    end
end

local function createESPForPlayer(plr)
    if plr == player then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = settings.esp.boxColor
    box.Thickness = 2
    box.Filled = false

    local nameT = Drawing.new("Text")
    nameT.Visible = false
    nameT.Color = settings.esp.textColor
    nameT.Center = true
    nameT.Size = 16
    nameT.Outline = true
    nameT.OutlineColor = Color3.fromRGB(0,0,0)
    nameT.Font = 2

    local hpBg = Drawing.new("Square")
    hpBg.Visible = false
    hpBg.Color = Color3.fromRGB(0,0,0)
    hpBg.Thickness = 1
    hpBg.Filled = true
    hpBg.Transparency = 0.5

    local hpFill = Drawing.new("Square")
    hpFill.Visible = false
    hpFill.Color = Color3.fromRGB(255,255,255)
    hpFill.Thickness = 1
    hpFill.Filled = true

    local distT = Drawing.new("Text")
    distT.Visible = false
    distT.Color = settings.esp.textColor
    distT.Center = true
    distT.Size = 12
    distT.Outline = true
    distT.OutlineColor = Color3.fromRGB(0,0,0)
    distT.Font = 2

    local skel = {}
    for i=1,10 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = settings.esp.skeletonColor
        line.Thickness = 2
        skel[i] = line
    end

    espObjects[plr] = {box=box, name=nameT, hpBg=hpBg, hpFill=hpFill, dist=distT, skel=skel}

    local heartbeat = runService.Heartbeat:Connect(function()
        -- Обновляем цвета при изменении в меню
        box.Color = settings.esp.boxColor
        nameT.Color = settings.esp.textColor
        distT.Color = settings.esp.textColor
        for _,l in ipairs(skel) do l.Color = settings.esp.skeletonColor end

        if not settings.esp.enabled or not plr.Character or isTeammate(plr) then
            box.Visible = false; nameT.Visible = false; hpBg.Visible = false; hpFill.Visible = false; distT.Visible = false
            for _,l in ipairs(skel) do l.Visible = false end
            return
        end
        local char = plr.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not root or not hum then
            box.Visible = false; nameT.Visible = false; hpBg.Visible = false; hpFill.Visible = false; distT.Visible = false
            for _,l in ipairs(skel) do l.Visible = false end
            return
        end
        local pos, on = camera:WorldToViewportPoint(root.Position)
        if not on then
            box.Visible = false; nameT.Visible = false; hpBg.Visible = false; hpFill.Visible = false; distT.Visible = false
            for _,l in ipairs(skel) do l.Visible = false end
            return
        end
        local d = (camera.CFrame.Position - root.Position).Magnitude
        local scale = 600/(d+0.001)
        local w = 4*scale; local h = 6*scale

        if settings.esp.box then
            box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2 - 20)
            box.Size = Vector2.new(w, h); box.Visible = true
        else box.Visible = false end

        nameT.Position = Vector2.new(pos.X, pos.Y - h/2 - 40)
        nameT.Text = plr.Name; nameT.Visible = true

        local hp = hum.Health/hum.MaxHealth
        local barW = 60; local barH = 6
        local barX = pos.X - barW/2; local barY = pos.Y - h/2 - 50
        hpBg.Position = Vector2.new(barX, barY); hpBg.Size = Vector2.new(barW, barH); hpBg.Visible = true
        hpFill.Position = Vector2.new(barX, barY); hpFill.Size = Vector2.new(barW * hp, barH); hpFill.Visible = true

        if settings.esp.distance then
            distT.Position = Vector2.new(pos.X, pos.Y - h/2 - 65)
            distT.Text = math.floor(d) .. "m"; distT.Visible = true
        else distT.Visible = false end

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
                    local pp, vis = camera:WorldToViewportPoint(part.Position)
                    if vis then partPos[part] = Vector2.new(pp.X, pp.Y) end
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
            for i=1,10 do
                if i <= #lines then
                    skel[i].From = lines[i][1]; skel[i].To = lines[i][2]; skel[i].Visible = true
                else skel[i].Visible = false end
            end
        else
            for _,l in ipairs(skel) do l.Visible = false end
        end
    end)

    plr.AncestryChanged:Connect(function()
        if not plr.Parent then
            heartbeat:Disconnect()
            box:Remove(); nameT:Remove(); hpBg:Remove(); hpFill:Remove(); distT:Remove()
            for _,l in ipairs(skel) do l:Remove() end
            espObjects[plr] = nil
        end
    end)
end

-- ========== ГЛАВНЫЙ ЦИКЛ АИМА ==========
runService.Heartbeat:Connect(function()
    if settings.aim.enabled then
        fovCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        fovCircle.Radius = settings.aim.fov
        fovCircle.Visible = true
        local target = getTargetInFov()
        if target then aimAt(target) end
    else
        fovCircle.Visible = false
    end
end)

-- ========== ЗАПУСК ESP ==========
for _, plr in ipairs(game.Players:GetPlayers()) do
    createESPForPlayer(plr)
end
game.Players.PlayerAdded:Connect(createESPForPlayer)
