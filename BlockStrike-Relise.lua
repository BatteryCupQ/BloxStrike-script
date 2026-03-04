-- Антидетект ESP: обводка, HP, скелет + расширение хитбокса + AIM (триггер на голову) + ВКЛАДКИ + ДИСТАНЦИЯ
-- Для исполнителей Roblox (Drawing)

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Настройки
local espEnabled = true
local hitboxEnabled = true
local extendHitbox = false
local teamCheckEnabled = false
local aimEnabled = false
local hitboxScale = 1.2
local aimRadius = 150
local skeletonEnabled = true

-- НАСТРОЙКИ АИМА
local aimSmoothness = 0.3
local aimMethod = "mouse"

local currentTarget = nil

-- Генератор случайных строк
local function randomString(len)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local s = ""
    for i = 1, len do
        s = s .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return s
end

-- Проверка тиммейта
local function isTeammate(plr)
    if not teamCheckEnabled then return false end
    if not plr or not player then return false end
    if player.Team and plr.Team then
        return player.Team == plr.Team
    end
    if player.TeamColor and plr.TeamColor then
        return player.TeamColor == plr.TeamColor
    end
    return false
end

-- Круг FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Thickness = 2
fovCircle.NumSides = 60
fovCircle.Filled = false
fovCircle.Radius = aimRadius

-- Поиск ближайшей головы в круге
local function getTargetInFov()
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closestDist = math.huge
    local targetHead = nil
    local targetPlayer = nil

    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and not isTeammate(plr) then
            local head = plr.Character:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local headVec = Vector2.new(headPos.X, headPos.Y)
                    local dist = (headVec - center).Magnitude
                    if dist <= aimRadius and dist < closestDist then
                        closestDist = dist
                        targetHead = head
                        targetPlayer = plr
                    end
                end
            end
        end
    end
    return targetHead, targetPlayer
end

-- Функция аима
local function aimAtTarget(targetHead)
    if not targetHead then return end
    local targetPos = targetHead.Position
    local myHead = player.Character and player.Character:FindFirstChild("Head")
    if not myHead then return end

    if aimMethod == "mouse" and mousemoverel then
        local vec, onScreen = camera:WorldToViewportPoint(targetPos)
        if onScreen then
            local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            local delta = Vector2.new(vec.X, vec.Y) - screenCenter
            mousemoverel(delta.X * aimSmoothness, delta.Y * aimSmoothness)
            return true
        end
    end

    if aimMethod == "camera" or not mousemoverel then
        local direction = (targetPos - myHead.Position).unit
        local currentCF = camera.CFrame
        local targetCF = CFrame.lookAt(myHead.Position, myHead.Position + direction)
        camera.CFrame = currentCF:Lerp(targetCF, aimSmoothness)
        return true
    end
    return false
end

-- ========== НОВОЕ МЕНЮ С ВКЛАДКАМИ ==========
local function createMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = randomString(10)
    screenGui.Parent = game:GetService("CoreGui")

    -- Основной фрейм
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = randomString(8)
    mainFrame.Size = UDim2.new(0, 260, 0, 320)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.Name = randomString(6)
    uiCorner.CornerRadius = UDim.new(0,10)
    uiCorner.Parent = mainFrame

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Name = randomString(7)
    title.Size = UDim2.new(1,0,0,30)
    title.BackgroundColor3 = Color3.fromRGB(50,50,50)
    title.BackgroundTransparency = 0.3
    title.BorderSizePixel = 0
    title.Text = "ESP+ HITBOX+ AIM"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = mainFrame

    -- === ВКЛАДКИ ===
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = randomString(6)
    tabFrame.Size = UDim2.new(1, -20, 0, 30)
    tabFrame.Position = UDim2.new(0, 10, 0, 35)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame

    local espTabBtn = Instance.new("TextButton")
    espTabBtn.Name = randomString(6)
    espTabBtn.Size = UDim2.new(0.33, -3, 1, 0)
    espTabBtn.Position = UDim2.new(0, 0, 0, 0)
    espTabBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    espTabBtn.Text = "ESP"
    espTabBtn.TextColor3 = Color3.new(1,1,1)
    espTabBtn.Font = Enum.Font.GothamBold
    espTabBtn.TextSize = 14
    espTabBtn.BorderSizePixel = 0
    espTabBtn.Parent = tabFrame

    local aimTabBtn = Instance.new("TextButton")
    aimTabBtn.Name = randomString(6)
    aimTabBtn.Size = UDim2.new(0.33, -3, 1, 0)
    aimTabBtn.Position = UDim2.new(0.34, 0, 0, 0)
    aimTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    aimTabBtn.Text = "AIM"
    aimTabBtn.TextColor3 = Color3.new(1,1,1)
    aimTabBtn.Font = Enum.Font.GothamBold
    aimTabBtn.TextSize = 14
    aimTabBtn.BorderSizePixel = 0
    aimTabBtn.Parent = tabFrame

    local hitTabBtn = Instance.new("TextButton")
    hitTabBtn.Name = randomString(6)
    hitTabBtn.Size = UDim2.new(0.33, -3, 1, 0)
    hitTabBtn.Position = UDim2.new(0.67, 0, 0, 0)
    hitTabBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    hitTabBtn.Text = "HITBOX"
    hitTabBtn.TextColor3 = Color3.new(1,1,1)
    hitTabBtn.Font = Enum.Font.GothamBold
    hitTabBtn.TextSize = 14
    hitTabBtn.BorderSizePixel = 0
    hitTabBtn.Parent = tabFrame

    for _, btn in ipairs({espTabBtn, aimTabBtn, hitTabBtn}) do
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0,6)
        btnCorner.Parent = btn
    end

    -- === КОНТЕЙНЕРЫ ДЛЯ КАЖДОЙ ВКЛАДКИ ===
    local containerFrame = Instance.new("Frame")
    containerFrame.Name = randomString(6)
    containerFrame.Size = UDim2.new(1, -20, 0, 215)
    containerFrame.Position = UDim2.new(0, 10, 0, 70)
    containerFrame.BackgroundTransparency = 1
    containerFrame.Parent = mainFrame

    -- Вкладка ESP
    local espContainer = Instance.new("Frame")
    espContainer.Name = randomString(6)
    espContainer.Size = UDim2.new(1,0,1,0)
    espContainer.BackgroundTransparency = 1
    espContainer.Visible = true
    espContainer.Parent = containerFrame

    -- Вкладка AIM
    local aimContainer = Instance.new("Frame")
    aimContainer.Name = randomString(6)
    aimContainer.Size = UDim2.new(1,0,1,0)
    aimContainer.BackgroundTransparency = 1
    aimContainer.Visible = false
    aimContainer.Parent = containerFrame

    -- Вкладка HITBOX
    local hitContainer = Instance.new("Frame")
    hitContainer.Name = randomString(6)
    hitContainer.Size = UDim2.new(1,0,1,0)
    hitContainer.BackgroundTransparency = 1
    hitContainer.Visible = false
    hitContainer.Parent = containerFrame

    -- Функция переключения вкладок
    local function switchTab(tab)
        espContainer.Visible = (tab == "esp")
        aimContainer.Visible = (tab == "aim")
        hitContainer.Visible = (tab == "hit")
        espTabBtn.BackgroundColor3 = (tab == "esp") and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
        aimTabBtn.BackgroundColor3 = (tab == "aim") and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
        hitTabBtn.BackgroundColor3 = (tab == "hit") and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
    end

    espTabBtn.MouseButton1Click:Connect(function() switchTab("esp") end)
    aimTabBtn.MouseButton1Click:Connect(function() switchTab("aim") end)
    hitTabBtn.MouseButton1Click:Connect(function() switchTab("hit") end)

    -- === НАПОЛНЕНИЕ ВКЛАДКИ ESP ===
    local yPosEsp = 5

    local espBtn = Instance.new("TextButton")
    espBtn.Name = randomString(8)
    espBtn.Size = UDim2.new(0,220,0,30)
    espBtn.Position = UDim2.new(0.5,-110,0,yPosEsp)
    espBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    espBtn.Text = "ESP: ВКЛ"
    espBtn.TextColor3 = Color3.new(1,1,1)
    espBtn.Font = Enum.Font.GothamBold
    espBtn.TextSize = 14
    espBtn.BorderSizePixel = 0
    espBtn.Parent = espContainer
    yPosEsp = yPosEsp + 35

    local btnCornerEsp = Instance.new("UICorner")
    btnCornerEsp.Name = randomString(6)
    btnCornerEsp.CornerRadius = UDim.new(0,8)
    btnCornerEsp.Parent = espBtn

    espBtn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        espBtn.Text = espEnabled and "ESP: ВКЛ" or "ESP: ВЫКЛ"
    end)

    local skeletonBtn = Instance.new("TextButton")
    skeletonBtn.Name = randomString(8)
    skeletonBtn.Size = UDim2.new(0,220,0,30)
    skeletonBtn.Position = UDim2.new(0.5,-110,0,yPosEsp)
    skeletonBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    skeletonBtn.Text = "СКЕЛЕТ: ВКЛ"
    skeletonBtn.TextColor3 = Color3.new(1,1,1)
    skeletonBtn.Font = Enum.Font.GothamBold
    skeletonBtn.TextSize = 14
    skeletonBtn.BorderSizePixel = 0
    skeletonBtn.Parent = espContainer
    yPosEsp = yPosEsp + 35

    local btnCornerSkel = Instance.new("UICorner")
    btnCornerSkel.Name = randomString(6)
    btnCornerSkel.CornerRadius = UDim.new(0,8)
    btnCornerSkel.Parent = skeletonBtn

    skeletonBtn.MouseButton1Click:Connect(function()
        skeletonEnabled = not skeletonEnabled
        skeletonBtn.BackgroundColor3 = skeletonEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        skeletonBtn.Text = skeletonEnabled and "СКЕЛЕТ: ВКЛ" or "СКЕЛЕТ: ВЫКЛ"
    end)

    local teamBtn = Instance.new("TextButton")
    teamBtn.Name = randomString(8)
    teamBtn.Size = UDim2.new(0,220,0,30)
    teamBtn.Position = UDim2.new(0.5,-110,0,yPosEsp)
    teamBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    teamBtn.Text = "TEAM CHECK: ВЫКЛ"
    teamBtn.TextColor3 = Color3.new(1,1,1)
    teamBtn.Font = Enum.Font.GothamBold
    teamBtn.TextSize = 14
    teamBtn.BorderSizePixel = 0
    teamBtn.Parent = espContainer
    yPosEsp = yPosEsp + 35

    local btnCornerTeam = Instance.new("UICorner")
    btnCornerTeam.Name = randomString(6)
    btnCornerTeam.CornerRadius = UDim.new(0,8)
    btnCornerTeam.Parent = teamBtn

    teamBtn.MouseButton1Click:Connect(function()
        teamCheckEnabled = not teamCheckEnabled
        teamBtn.BackgroundColor3 = teamCheckEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        teamBtn.Text = teamCheckEnabled and "TEAM CHECK: ВКЛ" or "TEAM CHECK: ВЫКЛ"
    end)
    -- === НАПОЛНЕНИЕ ВКЛАДКИ AIM ===
    local yPosAim = 5

    local aimBtn = Instance.new("TextButton")
    aimBtn.Name = randomString(8)
    aimBtn.Size = UDim2.new(0,220,0,30)
    aimBtn.Position = UDim2.new(0.5,-110,0,yPosAim)
    aimBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    aimBtn.Text = "AIM: ВЫКЛ"
    aimBtn.TextColor3 = Color3.new(1,1,1)
    aimBtn.Font = Enum.Font.GothamBold
    aimBtn.TextSize = 14
    aimBtn.BorderSizePixel = 0
    aimBtn.Parent = aimContainer
    yPosAim = yPosAim + 35

    local btnCornerAim = Instance.new("UICorner")
    btnCornerAim.Name = randomString(6)
    btnCornerAim.CornerRadius = UDim.new(0,8)
    btnCornerAim.Parent = aimBtn

    aimBtn.MouseButton1Click:Connect(function()
        aimEnabled = not aimEnabled
        if aimEnabled then
            aimBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
            aimBtn.Text = "AIM: ВКЛ"
        else
            aimBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
            aimBtn.Text = "AIM: ВЫКЛ"
            currentTarget = nil
        end
    end)

    -- === НАПОЛНЕНИЕ ВКЛАДКИ HITBOX ===
    local yPosHit = 5

    local hitBtn = Instance.new("TextButton")
    hitBtn.Name = randomString(8)
    hitBtn.Size = UDim2.new(0,220,0,30)
    hitBtn.Position = UDim2.new(0.5,-110,0,yPosHit)
    hitBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    hitBtn.Text = "HITBOX: ВКЛ"
    hitBtn.TextColor3 = Color3.new(1,1,1)
    hitBtn.Font = Enum.Font.GothamBold
    hitBtn.TextSize = 14
    hitBtn.BorderSizePixel = 0
    hitBtn.Parent = hitContainer
    yPosHit = yPosHit + 35

    local btnCornerHit = Instance.new("UICorner")
    btnCornerHit.Name = randomString(6)
    btnCornerHit.CornerRadius = UDim.new(0,8)
    btnCornerHit.Parent = hitBtn

    hitBtn.MouseButton1Click:Connect(function()
        hitboxEnabled = not hitboxEnabled
        hitBtn.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        hitBtn.Text = hitboxEnabled and "HITBOX: ВКЛ" or "HITBOX: ВЫКЛ"
    end)

    local extBtn = Instance.new("TextButton")
    extBtn.Name = randomString(8)
    extBtn.Size = UDim2.new(0,220,0,30)
    extBtn.Position = UDim2.new(0.5,-110,0,yPosHit)
    extBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    extBtn.Text = "EXTEND: ВЫКЛ"
    extBtn.TextColor3 = Color3.new(1,1,1)
    extBtn.Font = Enum.Font.GothamBold
    extBtn.TextSize = 14
    extBtn.BorderSizePixel = 0
    extBtn.Parent = hitContainer
    yPosHit = yPosHit + 35

    local btnCornerExt = Instance.new("UICorner")
    btnCornerExt.Name = randomString(6)
    btnCornerExt.CornerRadius = UDim.new(0,8)
    btnCornerExt.Parent = extBtn

    extBtn.MouseButton1Click:Connect(function()
        extendHitbox = not extendHitbox
        extBtn.BackgroundColor3 = extendHitbox and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        extBtn.Text = extendHitbox and "EXTEND: ВКЛ" or "EXTEND: ВЫКЛ"
    end)

    -- Регулятор масштаба
    local scaleLabel = Instance.new("TextLabel")
    scaleLabel.Name = randomString(7)
    scaleLabel.Size = UDim2.new(0,100,0,25)
    scaleLabel.Position = UDim2.new(0.5,-120,0,yPosHit)
    scaleLabel.BackgroundTransparency = 1
    scaleLabel.Text = "Scale: " .. string.format("%.1f", hitboxScale)
    scaleLabel.TextColor3 = Color3.new(1,1,1)
    scaleLabel.Font = Enum.Font.Gotham
    scaleLabel.TextSize = 14
    scaleLabel.Parent = hitContainer

    local minusBtn = Instance.new("TextButton")
    minusBtn.Name = randomString(6)
    minusBtn.Size = UDim2.new(0,30,0,25)
    minusBtn.Position = UDim2.new(0.5,-30,0,yPosHit)
    minusBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.new(1,1,1)
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 18
    minusBtn.BorderSizePixel = 0
    minusBtn.Parent = hitContainer

    local plusBtn = Instance.new("TextButton")
    plusBtn.Name = randomString(6)
    plusBtn.Size = UDim2.new(0,30,0,25)
    plusBtn.Position = UDim2.new(0.5,0,0,yPosHit)
    plusBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.new(1,1,1)
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 18
    plusBtn.BorderSizePixel = 0
    plusBtn.Parent = hitContainer

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = randomString(7)
    valueLabel.Size = UDim2.new(0,50,0,25)
    valueLabel.Position = UDim2.new(0.5,30,0,yPosHit)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = string.format("%.1f", hitboxScale)
    valueLabel.TextColor3 = Color3.new(1,1,1)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.Parent = hitContainer

    local btnCornerMinus = Instance.new("UICorner")
    btnCornerMinus.CornerRadius = UDim.new(0,6)
    btnCornerMinus.Parent = minusBtn

    local btnCornerPlus = Instance.new("UICorner")
    btnCornerPlus.CornerRadius = UDim.new(0,6)
    btnCornerPlus.Parent = plusBtn

    minusBtn.MouseButton1Click:Connect(function()
        hitboxScale = math.max(0.5, hitboxScale - 0.1)
        valueLabel.Text = string.format("%.1f", hitboxScale)
        scaleLabel.Text = "Scale: " .. string.format("%.1f", hitboxScale)
    end)

    plusBtn.MouseButton1Click:Connect(function()
        hitboxScale = math.min(3.0, hitboxScale + 0.1)
        valueLabel.Text = string.format("%.1f", hitboxScale)
        scaleLabel.Text = "Scale: " .. string.format("%.1f", hitboxScale)
    end)
end

-- Таблица ESP
local espObjects = {}

-- Функция создания ESP для игрока
local function createESPForPlayer(plr)
    if plr == player then return end

    -- Основные объекты Drawing
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255,0,0)
    box.Thickness = 2
    box.Filled = false

    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Color = Color3.fromRGB(255,255,255)
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
    healthBarFill.Color = Color3.fromRGB(255,255,255)
    healthBarFill.Thickness = 1
    healthBarFill.Filled = true

    -- НОВЫЙ ОБЪЕКТ ДЛЯ ДИСТАНЦИИ
    local distanceText = Drawing.new("Text")
    distanceText.Visible = false
    distanceText.Color = Color3.fromRGB(255,255,255)
    distanceText.Center = true
    distanceText.Size = 12
    distanceText.Outline = true
    distanceText.OutlineColor = Color3.fromRGB(0,0,0)
    distanceText.Font = 2

    local hitbox = Drawing.new("Square")
    hitbox.Visible = false
    hitbox.Color = Color3.fromRGB(255,255,0)
    hitbox.Thickness = 2
    hitbox.Filled = false

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
        hitbox = hitbox,
        skeleton = skeletonLines
    }
    espObjects[plr] = data

    local heartbeat = runService.Heartbeat:Connect(function()
        if not espEnabled or not plr.Character or isTeammate(plr) then
            box.Visible = false
            nameText.Visible = false
            healthBarBg.Visible = false
            healthBarFill.Visible = false
            distanceText.Visible = false
            hitbox.Visible = false
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
            hitbox.Visible = false
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
            hitbox.Visible = false
            for _,l in ipairs(skeletonLines) do l.Visible = false end
            return
        end

        local dist = (camera.CFrame.Position - root.Position).Magnitude
        local scale = 600 / (dist + 0.001)
        local width = 4 * scale
        local height = 6 * scale

        -- Бокс (обычный)
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

        -- === ДИСТАНЦИЯ (ПОД ПОЛОСКОЙ HP) ===
        distanceText.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 65)
        distanceText.Text = math.floor(dist) .. "m"
        distanceText.Visible = true

        -- Хитбокс (если включён)
        if hitboxEnabled then
            local hbWidth = width * hitboxScale
            local hbHeight = height * hitboxScale
            hitbox.Position = Vector2.new(rootPos.X - hbWidth/2, rootPos.Y - hbHeight/2 - 20)
            hitbox.Size = Vector2.new(hbWidth, hbHeight)
            hitbox.Visible = true
        else
            hitbox.Visible = false
        end

        -- Скелет (если включён)
        if skeletonEnabled then
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
            for _,l in ipairs(skeletonLines) do l.Visible = false end
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
            hitbox:Remove()
            for _,l in ipairs(skeletonLines) do l:Remove() end
            espObjects[plr] = nil
        end
    end)
end

-- Главный цикл аима
runService.Heartbeat:Connect(function()
    if aimEnabled then
        fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        fovCircle.Radius = aimRadius
        fovCircle.Visible = true

        local targetHead, targetPlr = getTargetInFov()
        if targetHead then
            currentTarget = targetPlr
            aimAtTarget(targetHead)
        else
            currentTarget = nil
        end
    else
        fovCircle.Visible = false
        currentTarget = nil
    end
end)

-- Запуск
if not _G.ESPLoaded then
    _G.ESPLoaded = true
    createMenu()
    for _,plr in ipairs(game.Players:GetPlayers()) do
        createESPForPlayer(plr)
    end
    game.Players.PlayerAdded:Connect(createESPForPlayer)
end

if syn and syn.protect_gui then
    syn.protect_gui(player.PlayerGui)
end
