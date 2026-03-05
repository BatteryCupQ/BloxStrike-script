-- ESP + простой аим + плавающее окно (часть 1)
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Настройки ESP
local espEnabled = true
local hitboxEnabled = true
local extendHitbox = false
local teamCheckEnabled = false
local hitboxScale = 1.2
local skeletonEnabled = true

-- Простой аим
local SimpleAim = { enabled = false, targetPart = "Head" }

-- Проверка тиммейта
local function isTeammate(plr)
    if not teamCheckEnabled then return false end
    if not plr or not player then return false end
    if player.Team and plr.Team then return player.Team == plr.Team end
    if player.TeamColor and plr.TeamColor then return player.TeamColor == plr.TeamColor end
    return false
end

-- Поиск ближайшего игрока для аима
local function getClosestPlayer()
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if teamCheckEnabled and isTeammate(plr) then continue end
            local part = plr.Character:FindFirstChild(SimpleAim.targetPart)
            if part then
                local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local d = (myRoot.Position - part.Position).Magnitude
                    if d < shortest then shortest = d; closest = part end
                end
            end
        end
    end
    return closest
end

-- Генератор случайных строк
local function randomString(l)
    local c = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local s = ""
    for i = 1, l do s = s .. c:sub(math.random(1, #c), math.random(1, #c)) end
    return s
end

-- Меню с вкладками
local function createMenu()
    local gui = Instance.new("ScreenGui")
    gui.Name = randomString(10)
    gui.Parent = game:GetService("CoreGui")

    local main = Instance.new("Frame")
    main.Name = randomString(8)
    main.Size = UDim2.new(0, 260, 0, 320)
    main.Position = UDim2.new(0, 10, 0, 10)
    main.BackgroundColor3 = Color3.fromRGB(30,30,30)
    main.BackgroundTransparency = 0.2
    main.Active, main.Draggable = true, true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1,0,0,30)
    title.BackgroundColor3 = Color3.fromRGB(50,50,50)
    title.BackgroundTransparency = 0.3
    title.Text = "ESP+ HITBOX+ AIM"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    local tabs = Instance.new("Frame", main)
    tabs.Size = UDim2.new(1,-20,0,30)
    tabs.Position = UDim2.new(0,10,0,35)
    tabs.BackgroundTransparency = 1

    local function createTab(name, pos)
        local b = Instance.new("TextButton", tabs)
        b.Name = name.."Tab"
        b.Size = UDim2.new(0.33,-3,1,0)
        b.Position = UDim2.new(0,pos,0,5)
        b.BackgroundColor3 = Color3.fromRGB(70,70,70)
        b.Text = name
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        return b
    end

    local espTab = createTab("ESP", 0)
    local aimTab = createTab("AIM", 86)
    local hitTab = createTab("HITBOX", 172)

    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(1,-20,0,215)
    container.Position = UDim2.new(0,10,0,70)
    container.BackgroundTransparency = 1

    local espC = Instance.new("Frame", container)
    espC.Size = UDim2.new(1,0,1,0)
    espC.BackgroundTransparency = 1
    espC.Visible = true

    local aimC = Instance.new("Frame", container)
    aimC.Size = UDim2.new(1,0,1,0)
    aimC.BackgroundTransparency = 1
    aimC.Visible = false

    local hitC = Instance.new("Frame", container)
    hitC.Size = UDim2.new(1,0,1,0)
    hitC.BackgroundTransparency = 1
    hitC.Visible = false

    local function switch(t)
        espC.Visible = (t=="esp")
        aimC.Visible = (t=="aim")
        hitC.Visible = (t=="hit")
        espTab.BackgroundColor3 = (t=="esp") and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
        aimTab.BackgroundColor3 = (t=="aim") and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
        hitTab.BackgroundColor3 = (t=="hit") and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
    end

    espTab.MouseButton1Click:Connect(function() switch("esp") end)
    aimTab.MouseButton1Click:Connect(function() switch("aim") end)
    hitTab.MouseButton1Click:Connect(function() switch("hit") end)

    -- Вкладка ESP
    local y = 5
    local espBtn = Instance.new("TextButton", espC)
    espBtn.Name = randomString(8)
    espBtn.Size = UDim2.new(0,220,0,30)
    espBtn.Position = UDim2.new(0.5,-110,0,y)
    espBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    espBtn.Text = "ESP: ВКЛ"
    espBtn.TextColor3 = Color3.new(1,1,1)
    espBtn.Font = Enum.Font.GothamBold
    espBtn.TextSize = 14
    Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,8)
    espBtn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        espBtn.Text = espEnabled and "ESP: ВКЛ" or "ESP: ВЫКЛ"
    end)
    y = y + 35

    local skelBtn = Instance.new("TextButton", espC)
    skelBtn.Name = randomString(8)
    skelBtn.Size = UDim2.new(0,220,0,30)
    skelBtn.Position = UDim2.new(0.5,-110,0,y)
    skelBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    skelBtn.Text = "СКЕЛЕТ: ВКЛ"
    skelBtn.TextColor3 = Color3.new(1,1,1)
    skelBtn.Font = Enum.Font.GothamBold
    skelBtn.TextSize = 14
    Instance.new("UICorner", skelBtn).CornerRadius = UDim.new(0,8)
    skelBtn.MouseButton1Click:Connect(function()
        skeletonEnabled = not skeletonEnabled
        skelBtn.BackgroundColor3 = skeletonEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        skelBtn.Text = skeletonEnabled and "СКЕЛЕТ: ВКЛ" or "СКЕЛЕТ: ВЫКЛ"
    end)
    y = y + 35

    local teamBtn = Instance.new("TextButton", espC)
    teamBtn.Name = randomString(8)
    teamBtn.Size = UDim2.new(0,220,0,30)
    teamBtn.Position = UDim2.new(0.5,-110,0,y)
    teamBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    teamBtn.Text = "TEAM CHECK: ВЫКЛ"
    teamBtn.TextColor3 = Color3.new(1,1,1)
    teamBtn.Font = Enum.Font.GothamBold
    teamBtn.TextSize = 14
    Instance.new("UICorner", teamBtn).CornerRadius = UDim.new(0,8)
    teamBtn.MouseButton1Click:Connect(function()
        teamCheckEnabled = not teamCheckEnabled
        teamBtn.BackgroundColor3 = teamCheckEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        teamBtn.Text = teamCheckEnabled and "TEAM CHECK: ВКЛ" or "TEAM CHECK: ВЫКЛ"
    end)

    -- Вкладка AIM
    local aimSimpleBtn = Instance.new("TextButton", aimC)
    aimSimpleBtn.Name = randomString(8)
    aimSimpleBtn.Size = UDim2.new(0,220,0,30)
    aimSimpleBtn.Position = UDim2.new(0.5,-110,0,5)
    aimSimpleBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    aimSimpleBtn.Text = "SIMPLE AIM: OFF"
    aimSimpleBtn.TextColor3 = Color3.new(1,1,1)
    aimSimpleBtn.Font = Enum.Font.GothamBold
    aimSimpleBtn.TextSize = 14
    Instance.new("UICorner", aimSimpleBtn).CornerRadius = UDim.new(0,8)
    aimSimpleBtn.MouseButton1Click:Connect(function()
        SimpleAim.enabled = not SimpleAim.enabled
        aimSimpleBtn.BackgroundColor3 = SimpleAim.enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        aimSimpleBtn.Text = SimpleAim.enabled and "SIMPLE AIM: ON" or "SIMPLE AIM: OFF"
    end)

    -- Вкладка HITBOX
    local hitY = 5
    local hitBtn = Instance.new("TextButton", hitC)
    hitBtn.Name = randomString(8)
    hitBtn.Size = UDim2.new(0,220,0,30)
    hitBtn.Position = UDim2.new(0.5,-110,0,hitY)
    hitBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    hitBtn.Text = "HITBOX: ВКЛ"
    hitBtn.TextColor3 = Color3.new(1,1,1)
    hitBtn.Font = Enum.Font.GothamBold
    hitBtn.TextSize = 14
    Instance.new("UICorner", hitBtn).CornerRadius = UDim.new(0,8)
    hitBtn.MouseButton1Click:Connect(function()
        hitboxEnabled = not hitboxEnabled
        hitBtn.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        hitBtn.Text = hitboxEnabled and "HITBOX: ВКЛ" or "HITBOX: ВЫКЛ"
    end)
    hitY = hitY + 35

    local extBtn = Instance.new("TextButton", hitC)
    extBtn.Name = randomString(8)
    extBtn.Size = UDim2.new(0,220,0,30)
    extBtn.Position = UDim2.new(0.5,-110,0,hitY)
    extBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    extBtn.Text = "EXTEND: ВЫКЛ"
    extBtn.TextColor3 = Color3.new(1,1,1)
    extBtn.Font = Enum.Font.GothamBold
    extBtn.TextSize = 14
    Instance.new("UICorner", extBtn).CornerRadius = UDim.new(0,8)
    extBtn.MouseButton1Click:Connect(function()
        extendHitbox = not extendHitbox
        extBtn.BackgroundColor3 = extendHitbox and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        extBtn.Text = extendHitbox and "EXTEND: ВКЛ" or "EXTEND: ВЫКЛ"
    end)
    hitY = hitY + 35

    -- Регулятор масштаба
    local scaleLbl = Instance.new("TextLabel", hitC)
    scaleLbl.Size = UDim2.new(0,100,0,25)
    scaleLbl.Position = UDim2.new(0.5,-120,0,hitY)
    scaleLbl.BackgroundTransparency = 1
    scaleLbl.Text = "Scale: " .. string.format("%.1f", hitboxScale)
    scaleLbl.TextColor3 = Color3.new(1,1,1)
    scaleLbl.Font = Enum.Font.Gotham
    scaleLbl.TextSize = 14

    local minus = Instance.new("TextButton", hitC)
    minus.Size = UDim2.new(0,30,0,25)
    minus.Position = UDim2.new(0.5,-30,0,hitY)
    minus.BackgroundColor3 = Color3.fromRGB(80,80,80)
    minus.Text = "-"
    minus.TextColor3 = Color3.new(1,1,1)
    minus.Font = Enum.Font.GothamBold
    minus.TextSize = 18
    Instance.new("UICorner", minus).CornerRadius = UDim.new(0,6)

    local plus = Instance.new("TextButton", hitC)
    plus.Size = UDim2.new(0,30,0,25)
    plus.Position = UDim2.new(0.5,0,0,hitY)
    plus.BackgroundColor3 = Color3.fromRGB(80,80,80)
    plus.Text = "+"
    plus.TextColor3 = Color3.new(1,1,1)
    plus.Font = Enum.Font.GothamBold
    plus.TextSize = 18
    Instance.new("UICorner", plus).CornerRadius = UDim.new(0,6)

    local valLbl = Instance.new("TextLabel", hitC)
    valLbl.Size = UDim2.new(0,50,0,25)
    valLbl.Position = UDim2.new(0.5,30,0,hitY)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = string.format("%.1f", hitboxScale)
    valLbl.TextColor3 = Color3.new(1,1,1)
    valLbl.Font = Enum.Font.Gotham
    valLbl.TextSize = 14

    minus.MouseButton1Click:Connect(function()
        hitboxScale = math.max(0.5, hitboxScale - 0.1)
        valLbl.Text = string.format("%.1f", hitboxScale)
        scaleLbl.Text = "Scale: " .. string.format("%.1f", hitboxScale)
    end)
    plus.MouseButton1Click:Connect(function()
        hitboxScale = math.min(3.0, hitboxScale + 0.1)
        valLbl.Text = string.format("%.1f", hitboxScale)
        scaleLbl.Text = "Scale: " .. string.format("%.1f", hitboxScale)
    end)
end

-- ========== КОНЕЦ ЧАСТИ 1 ==========
-- Теперь скопируй часть 2
-- ========== ЧАСТЬ 2 ==========
-- Плавающее окно для аима
local function createSimpleAimGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "SimpleAimGUI"
    gui.Parent = player:FindFirstChild("PlayerGui") or player.PlayerGui
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,150,0,60)
    frame.Position = UDim2.new(0,10,0,10)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BackgroundTransparency = 0.2
    frame.Active, frame.Draggable = true, true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,25)
    title.BackgroundTransparency = 1
    title.Text = "Simple Aim"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8,0,0,25)
    btn.Position = UDim2.new(0.1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    local function update() 
        if SimpleAim.enabled then
            btn.BackgroundColor3 = Color3.fromRGB(0,255,0)
            btn.Text = "ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(255,0,0)
            btn.Text = "OFF"
        end
    end
    update()

    btn.MouseButton1Click:Connect(function()
        SimpleAim.enabled = not SimpleAim.enabled
        update()
    end)
end

-- ESP для игроков
local espObjects = {}
local function createESPForPlayer(plr)
    if plr == player then return end

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255,0,0)
    box.Thickness = 2

    local nameT = Drawing.new("Text")
    nameT.Visible = false
    nameT.Color = Color3.fromRGB(255,255,255)
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
    distT.Color = Color3.fromRGB(255,255,255)
    distT.Center = true
    distT.Size = 12
    distT.Outline = true
    distT.OutlineColor = Color3.fromRGB(0,0,0)
    distT.Font = 2

    local hitbox = Drawing.new("Square")
    hitbox.Visible = false
    hitbox.Color = Color3.fromRGB(255,255,0)
    hitbox.Thickness = 2

    local skel = {}
    for i=1,10 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255,0,255)
        line.Thickness = 2
        skel[i] = line
    end

    local data = {box=box, name=nameT, hpBg=hpBg, hpFill=hpFill, dist=distT, hitbox=hitbox, skel=skel}
    espObjects[plr] = data

    local heartbeat = runService.Heartbeat:Connect(function()
        if not espEnabled or not plr.Character or isTeammate(plr) then
            box.Visible = false; nameT.Visible = false; hpBg.Visible = false; hpFill.Visible = false
            distT.Visible = false; hitbox.Visible = false
            for _,l in ipairs(skel) do l.Visible = false end
            return
        end
        local char = plr.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not root or not hum then
            box.Visible = false; nameT.Visible = false; hpBg.Visible = false; hpFill.Visible = false
            distT.Visible = false; hitbox.Visible = false
            for _,l in ipairs(skel) do l.Visible = false end
            return
        end
        local pos, on = camera:WorldToViewportPoint(root.Position)
        if not on then
            box.Visible = false; nameT.Visible = false; hpBg.Visible = false; hpFill.Visible = false
            distT.Visible = false; hitbox.Visible = false
            for _,l in ipairs(skel) do l.Visible = false end
            return
        end
        local d = (camera.CFrame.Position - root.Position).Magnitude
        local scale = 600/(d+0.001)
        local w = 4*scale; local h = 6*scale

        box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2 - 20)
        box.Size = Vector2.new(w, h); box.Visible = true

        nameT.Position = Vector2.new(pos.X, pos.Y - h/2 - 40)
        nameT.Text = plr.Name; nameT.Visible = true

        local hp = hum.Health/hum.MaxHealth
        local barW = 60; local barH = 6
        local barX = pos.X - barW/2; local barY = pos.Y - h/2 - 50
        hpBg.Position = Vector2.new(barX, barY); hpBg.Size = Vector2.new(barW, barH); hpBg.Visible = true
        hpFill.Position = Vector2.new(barX, barY); hpFill.Size = Vector2.new(barW * hp, barH); hpFill.Visible = true

        distT.Position = Vector2.new(pos.X, pos.Y - h/2 - 65)
        distT.Text = math.floor(d) .. "m"; distT.Visible = true

        if hitboxEnabled then
            local hbW = w * hitboxScale; local hbH = h * hitboxScale
            hitbox.Position = Vector2.new(pos.X - hbW/2, pos.Y - hbH/2 - 20)
            hitbox.Size = Vector2.new(hbW, hbH); hitbox.Visible = true
        else hitbox.Visible = false end

        if skeletonEnabled then
            local pts = {
                Head = char:FindFirstChild("Head"),
                Torso = root,
                LeftArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"),
                RightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"),
                LeftLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"),
                RightLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
            }
            local ppos = {}
            for _, part in pairs(pts) do
                if part and part:IsA("BasePart") then
                    local pp, vis = camera:WorldToViewportPoint(part.Position)
                    if vis then ppos[part] = Vector2.new(pp.X, pp.Y) end
                end
            end
            local lines = {}
            if pts.Head and pts.Torso and ppos[pts.Head] and ppos[pts.Torso] then
                table.insert(lines, {ppos[pts.Head], ppos[pts.Torso]})
            end
            if pts.Torso and pts.LeftArm and ppos[pts.Torso] and ppos[pts.LeftArm] then
                table.insert(lines, {ppos[pts.Torso], ppos[pts.LeftArm]})
            end
            if pts.Torso and pts.RightArm and ppos[pts.Torso] and ppos[pts.RightArm] then
                table.insert(lines, {ppos[pts.Torso], ppos[pts.RightArm]})
            end
            if pts.Torso and pts.LeftLeg and ppos[pts.Torso] and ppos[pts.LeftLeg] then
                table.insert(lines, {ppos[pts.Torso], ppos[pts.LeftLeg]})
            end
            if pts.Torso and pts.RightLeg and ppos[pts.Torso] and ppos[pts.RightLeg] then
                table.insert(lines, {ppos[pts.Torso], ppos[pts.RightLeg]})
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
            box:Remove(); nameT:Remove(); hpBg:Remove(); hpFill:Remove()
            distT:Remove(); hitbox:Remove()
            for _,l in ipairs(skel) do l:Remove() end
            espObjects[plr] = nil
        end
    end)
end

-- Главный цикл аима
runService.Heartbeat:Connect(function()
    if SimpleAim.enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local target = getClosestPlayer()
        if target then
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, target.Position)
        end
    end
end)

-- Запуск
if not _G.ESPLoaded then
    _G.ESPLoaded = true
    createMenu()
    createSimpleAimGUI()
    for _,p in ipairs(game.Players:GetPlayers()) do createESPForPlayer(p) end
    game.Players.PlayerAdded:Connect(createESPForPlayer)
end

if syn and syn.protect_gui then syn.protect_gui(player.PlayerGui) end
