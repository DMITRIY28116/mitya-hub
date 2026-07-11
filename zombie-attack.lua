-- ===========================================================
-- Zombie Attack Hub – полностью исправленная версия
-- Все русские ключевые слова заменены на английские,
-- task → wait/spawn, CoreGui → PlayerGui,
-- внешние скрипты загружаются через универсальный httpGet.
-- Открыть/закрыть: K
-- ===========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")  -- вместо CoreGui
local LocalPlayer = Players.LocalPlayer

-- ========== УНИВЕРСАЛЬНЫЙ HTTP-ЗАГРУЗЧИК (для внешних скриптов) ==========
local function httpGet(url)
    local methods = {
        function() return syn and syn.request({ Url = url, Method = "GET" }).Body end,
        function() return http_request and http_request({ Url = url }).Body end,
        function() return request and request({ Url = url }).Body end,
        function() return game:HttpGet(url, true) end  -- запасной
    }
    for _, method in ipairs(methods) do
        local success, result = pcall(method)
        if success and result then return result end
    end
    error("Не удалось загрузить: " .. url)
end

-- ========== СОСТОЯНИЯ ТОГГЛОВ ==========
local toggleStates = {
    Fly = false,
    Noclip = false,
    Gravity = false,
    Speed = false,
    Jump = false,
    AutoFarm = false,
    KillPlatform = false,
    StealKills = false,
    NoRecoil = false,
    HitboxExpand = false,
    Reach = false,
}

-- ========== ПЕРЕМЕННЫЕ ДЛЯ ПОТОКОВ ==========
local noclipConn = nil
local farmConn = nil
local hitboxConn = nil
local reachConn = nil
local expandedParts = {}
local globalTarget = nil
local farmAttackThread = nil
local noRecoilThread = nil
local stealKillsThread = nil
local stealKillsActive = false  -- флаг для остановки цикла

-- ========== УДАЛЯЕМ СТАРЫЙ GUI ==========
pcall(function() PlayerGui:FindFirstChild("ZombieAttackHub"):Destroy() end)

-- ========== СОЗДАНИЕ GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZombieAttackHub"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui  -- изменено

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 550)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.Parent = screenGui

-- Тень
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 12, 1, 12)
shadow.Position = UDim2.new(0, -6, 0, -6)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 16)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- ========== ЗАГОЛОВОК ==========
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local logo = Instance.new("Frame")
logo.Size = UDim2.new(0, 28, 0, 28)
logo.Position = UDim2.new(0, 10, 0.5, -14)
logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
logo.BorderSizePixel = 0
logo.Parent = titleBar
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 6)
local logoText = Instance.new("TextLabel", logo)
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "Z"
logoText.TextColor3 = Color3.fromRGB(0, 0, 0)
logoText.TextScaled = true
logoText.Font = Enum.Font.GothamBold

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 45, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Атака зомби"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.BackgroundTransparency = 0.5
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -72, 0.5, -14)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.BackgroundTransparency = 0.5
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.TextSize = 18
minBtn.Font = Enum.Font.Gotham
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)
local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local size = isMinimized and UDim2.new(0, 420, 0, 45) or UDim2.new(0, 420, 0, 550)
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = size}):Play()
end)

-- Двойной клик по заголовку
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputState == Enum.UserInputState.Begin and input.ClickCount == 2 then
        isMinimized = not isMinimized
        local size = isMinimized and UDim2.new(0, 420, 0, 45) or UDim2.new(0, 420, 0, 550)
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = size}):Play()
    end
end)

-- Перетаскивание
local dragToggle, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragToggle then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ========== КОНТЕЙНЕР С КНОПКАМИ (СКРОЛЛ) ==========
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -16, 1, -95)
contentFrame.Position = UDim2.new(0, 8, 0, 55)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentFrame.BackgroundTransparency = 0
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ScrollBarThickness = 6
contentFrame.Parent = mainFrame
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 8)

-- ========== КОНСОЛЬ ==========
local consoleFrame = Instance.new("Frame")
consoleFrame.Size = UDim2.new(1, -16, 0, 30)
consoleFrame.Position = UDim2.new(0, 8, 1, -36)
consoleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
consoleFrame.BackgroundTransparency = 0.3
consoleFrame.BorderSizePixel = 0
consoleFrame.Parent = mainFrame
Instance.new("UICorner", consoleFrame).CornerRadius = UDim.new(0, 6)
local consoleLabel = Instance.new("TextLabel", consoleFrame)
consoleLabel.Size = UDim2.new(1, -6, 1, -4)
consoleLabel.Position = UDim2.new(0, 3, 0, 2)
consoleLabel.BackgroundTransparency = 1
consoleLabel.Font = Enum.Font.Code
consoleLabel.Text = "Статус: Готово"
consoleLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
consoleLabel.TextSize = 11
consoleLabel.TextWrapped = true
consoleLabel.TextXAlignment = Enum.TextXAlignment.Left

local function logConsole(text, color)
    consoleLabel.Text = text
    consoleLabel.TextColor3 = color or Color3.fromRGB(80, 255, 80)
end

-- ========== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ КНОПОК ==========
local function createToggleButton(parent, label, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.Position = UDim2.new(0.04, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Text = " " .. label
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 12, 0, 12)
    indicator.Position = UDim2.new(1, -18, 0.5, -6)
    indicator.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    -- Ховер
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        callback(btn, indicator)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
        wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)
    return btn, indicator
end

local function createActionButton(parent, label, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.Position = UDim2.new(0.04, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Text = " " .. label
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        callback()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
        wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)
    return btn
end

local function updateIndicator(ind, state)
    if ind then ind.BackgroundColor3 = state and Color3.fromRGB(30, 180, 30) or Color3.fromRGB(150, 30, 30) end
end

-- ========== РАЗМЕЩЕНИЕ КНОПОК ==========
local yOff = 8

-- Kill Platform
createToggleButton(contentFrame, "Kill Platform", yOff, function(btn, ind)
    toggleStates.KillPlatform = not toggleStates.KillPlatform
    updateIndicator(ind, toggleStates.KillPlatform)
    if toggleStates.KillPlatform then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local platform = Instance.new("Part")
            platform.Name = "MityaKillPlatform"
            platform.Size = Vector3.new(100, 0.5, 100)
            platform.Anchored = true
            platform.Position = Vector3.new(555, 555, 555)
            platform.Material = Enum.Material.Neon
            platform.Color = Color3.fromRGB(120, 0, 180)
            platform.Parent = Workspace
            root.CFrame = platform.CFrame * CFrame.new(0, 4, 0)
            pcall(function()
                for _, a in pairs(Workspace.enemies:GetChildren()) do
                    for _, b in pairs(a:GetChildren()) do
                        if b:IsA("BasePart") then b.Anchored = true; b.CFrame = root.CFrame * CFrame.new(2,0,2) end
                    end
                end
            end)
        end
        logConsole("Kill Platform: Active", Color3.fromRGB(30, 180, 30))
    else
        pcall(function() Workspace:FindFirstChild("MityaKillPlatform"):Destroy() end)
        logConsole("Kill Platform: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)
yOff = yOff + 38

-- Steal Kills
createToggleButton(contentFrame, "Steal Kills", yOff, function(btn, ind)
    toggleStates.StealKills = not toggleStates.StealKills
    updateIndicator(ind, toggleStates.StealKills)
    if toggleStates.StealKills then
        stealKillsActive = true
        stealKillsThread = spawn(function()
            while stealKillsActive do
                wait(0.1)
                pcall(function()
                    for _, v in pairs(Workspace.enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health < v.Humanoid.MaxHealth * 0.5 then
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChildOfClass("Tool") then
                                ReplicatedStorage.Gun:FireServer({
                                    Normal = Vector3.new(0,0,0),
                                    Direction = v.Head.Position,
                                    Name = char:FindFirstChildOfClass("Tool").Name,
                                    Hit = v.Head,
                                    Origin = v.Head.Position,
                                    Pos = v.Head.Position,
                                })
                            end
                        end
                    end
                end)
            end
        end)
        logConsole("Steal Kills: Active", Color3.fromRGB(30, 180, 30))
    else
        stealKillsActive = false
        if stealKillsThread then stealKillsThread = nil end
        logConsole("Steal Kills: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)
yOff = yOff + 38

-- Auto Farm
createToggleButton(contentFrame, "Auto Farm", yOff, function(btn, ind)
    toggleStates.AutoFarm = not toggleStates.AutoFarm
    updateIndicator(ind, toggleStates.AutoFarm)
    if toggleStates.AutoFarm then
        local function getNearest()
            local nearest, dist = nil, 99999
            pcall(function()
                for _, v in pairs(Workspace.BossFolder:GetChildren()) do
                    if v:FindFirstChild("Head") then
                        local m = (LocalPlayer.Character.Head.Position - v.Head.Position).Magnitude
                        if m < dist then dist = m; nearest = v end
                    end
                end
            end)
            pcall(function()
                for _, v in pairs(Workspace.enemies:GetChildren()) do
                    if v:FindFirstChild("Head") then
                        local m = (LocalPlayer.Character.Head.Position - v.Head.Position).Magnitude
                        if m < dist then dist = m; nearest = v end
                    end
                end
            end)
            return nearest
        end
        farmConn = RunService.RenderStepped:Connect(function()
            if not toggleStates.AutoFarm then return end
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local target = getNearest()
            if target and target:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 8, 9)
                globalTarget = target
            end
        end)
        farmAttackThread = spawn(function()
            while toggleStates.AutoFarm do
                wait(0.05)
                if globalTarget and globalTarget:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    pcall(function()
                        ReplicatedStorage.Gun:FireServer({
                            Normal = Vector3.new(0,0,0),
                            Direction = globalTarget.Head.Position,
                            Name = LocalPlayer.Character:FindFirstChildOfClass("Tool").Name,
                            Hit = globalTarget.Head,
                            Origin = globalTarget.Head.Position,
                            Pos = globalTarget.Head.Position,
                        })
                    end)
                end
            end
        end)
        spawn(function()
            while toggleStates.AutoFarm do
                wait()
                pcall(function()
                    if LocalPlayer.Character then
                        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        if LocalPlayer.Character:FindFirstChild("Torso") then
                            LocalPlayer.Character.Torso.Velocity = Vector3.new(0,0,0)
                        end
                    end
                end)
            end
        end)
        logConsole("Auto Farm: Active", Color3.fromRGB(30, 180, 30))
    else
        if farmConn then farmConn:Disconnect(); farmConn = nil end
        if farmAttackThread then farmAttackThread = nil end
        globalTarget = nil
        logConsole("Auto Farm: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)
yOff = yOff + 38

-- No Recoil
createToggleButton(contentFrame, "No Recoil", yOff, function(btn, ind)
    toggleStates.NoRecoil = not toggleStates.NoRecoil
    updateIndicator(ind, toggleStates.NoRecoil)
    if toggleStates.NoRecoil then
        noRecoilThread = spawn(function()
            while toggleStates.NoRecoil do
                wait()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        for _, tool in pairs(char:GetChildren()) do
                            if tool:IsA("Tool") then
                                for _, mod in pairs(tool:GetDescendants()) do
                                    if mod:IsA("Configuration") then
                                        for _, val in pairs(mod:GetChildren()) do
                                            if val.Name:lower():find("recoil") and val:IsA("ValueBase") then
                                                val.Value = 0
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
        logConsole("No Recoil: Active", Color3.fromRGB(30, 180, 30))
    else
        if noRecoilThread then noRecoilThread = nil end
        logConsole("No Recoil: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)
yOff = yOff + 38

-- Equip All Guns
createActionButton(contentFrame, "Equip All Guns", yOff, function()
    pcall(function()
        for _, thing in pairs(ReplicatedStorage.Guns:GetChildren()) do
            if thing:IsA("Tool") then thing.Parent = LocalPlayer.Backpack end
        end
    end)
    logConsole("Equipped all guns", Color3.fromRGB(80, 255, 80))
end)
yOff = yOff + 38

-- Equip All Knives
createActionButton(contentFrame, "Equip All Knives", yOff, function()
    pcall(function()
        for _, thing in pairs(ReplicatedStorage.Knives:GetChildren()) do
            if thing:IsA("Tool") then thing.Parent = LocalPlayer.Backpack end
        end
    end)
    logConsole("Equipped all knives", Color3.fromRGB(80, 255, 80))
end)
yOff = yOff + 38

-- Fly Mode (E)
createToggleButton(contentFrame, "Fly Mode (E)", yOff, function(btn, ind)
    toggleStates.Fly = not toggleStates.Fly
    updateIndicator(ind, toggleStates.Fly)
    if toggleStates.Fly then
        logConsole("Fly: Press E to toggle", Color3.fromRGB(80, 180, 255))
        local flyScript = pcall(httpGet, "https://pastebin.com/raw/7rXZ9VNc")
        if flyScript then loadstring(flyScript)() end
    else
        logConsole("Fly: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)
yOff = yOff + 38

-- NoClip
createToggleButton(contentFrame, "NoClip", yOff, function(btn, ind)
    toggleStates.Noclip = not toggleStates.Noclip
    updateIndicator(ind, toggleStates.Noclip)
    if toggleStates.Noclip then
        noclipConn = RunService.Stepped:Connect(function()
            if toggleStates.Noclip and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(11) end
            end
        end)
        logConsole("NoClip: Active", Color3.fromRGB(30, 180, 30))
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        logConsole("NoClip: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)
yOff = yOff + 38

-- Low Gravity
createToggleButton(contentFrame, "Low Gravity", yOff, function(btn, ind)
    toggleStates.Gravity = not toggleStates.Gravity
    updateIndicator(ind, toggleStates.Gravity)
    if toggleStates.Gravity then
        Workspace.Gravity = 5
        logConsole("Low Gravity: Active", Color3.fromRGB(30, 180, 30))
    else
        Workspace.Gravity = 196.2
        logConsole("Gravity: Normal", Color3.fromRGB(150, 30, 30))
    end
end)
yOff = yOff + 38

-- Super Speed
createToggleButton(contentFrame, "Super Speed", yOff, function(btn, ind)
    toggleStates.Speed = not toggleStates.Speed
    updateIndicator(ind, toggleStates.Speed)
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = toggleStates.Speed and 60 or 16
            logConsole(toggleStates.Speed and "Speed: 60" or "Speed: Normal", toggleStates.Speed and Color3.fromRGB(30,180,30) or Color3.fromRGB(150,30,30))
        end
    end)
end)
yOff = yOff + 38

-- Super Jump
createToggleButton(contentFrame, "Super Jump", yOff, function(btn, ind)
    toggleStates.Jump = not toggleStates.Jump
    updateIndicator(ind, toggleStates.Jump)
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = toggleStates.Jump and 100 or 50
            logConsole(toggleStates.Jump and "Jump: 100" or "Jump: Normal", toggleStates.Jump and Color3.fromRGB(30,180,30) or Color3.fromRGB(150,30,30))
        end
    end)
end)
yOff = yOff + 38

-- B-Tools
createActionButton(contentFrame, "B-Tools", yOff, function()
    local btScript = pcall(httpGet, "https://pastebin.com/raw/T0qaXjAR")
    if btScript then loadstring(btScript)() end
    logConsole("B-Tools Loaded", Color3.fromRGB(80, 255, 80))
end)
yOff = yOff + 38

-- Expand Zombie Hitboxes
createToggleButton(contentFrame, "Expand Zombie Hitboxes", yOff, function(btn, ind)
    toggleStates.HitboxExpand = not toggleStates.HitboxExpand
    updateIndicator(ind, toggleStates.HitboxExpand)
    if toggleStates.HitboxExpand then
        local hitboxSize = Vector3.new(40,40,40)
        hitboxConn = RunService.Heartbeat:Connect(function()
            if not toggleStates.HitboxExpand then return end
            pcall(function()
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Parent and obj.Parent:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj.Parent) and obj.Parent:FindFirstChild("HumanoidRootPart") and obj.Parent.Humanoid.Health > 0 and not expandedParts[obj] then
                        expandedParts[obj] = {OriginalSize = obj.Size, OriginalTransparency = obj.Transparency, OriginalCollision = obj.CanCollide}
                        obj.Size = hitboxSize
                        obj.Transparency = 0.85
                        obj.CanCollide = false
                        obj.Anchored = true
                    end
                end
            end)
        end)
        logConsole("Hitbox Expand: Active", Color3.fromRGB(30, 180, 30))
    else
        if hitboxConn then hitboxConn:Disconnect(); hitboxConn = nil end
        for obj, data in pairs(expandedParts) do
            pcall(function()
                if obj and obj.Parent then
                    obj.Size = data.OriginalSize
                    obj.Transparency = data.OriginalTransparency
                    obj.CanCollide = data.OriginalCollision
                    obj.Anchored = false
                end
            end)
        end
        expandedParts = {}
        logConsole("Hitbox Expand: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)
yOff = yOff + 38

-- Weapon Reach Extender
createToggleButton(contentFrame, "Weapon Reach Extender", yOff, function(btn, ind)
    toggleStates.Reach = not toggleStates.Reach
    updateIndicator(ind, toggleStates.Reach)
    if toggleStates.Reach then
        local reachSize = Vector3.new(60,60,60)
        reachConn = RunService.Heartbeat:Connect(function()
            if not toggleStates.Reach then return end
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        local handle = tool.Handle
                        handle.Size = reachSize
                        handle.Transparency = 1
                        handle.CanCollide = false
                        handle.Massless = true
                    end
                end
            end)
        end)
        logConsole("Reach Extender: Active", Color3.fromRGB(30, 180, 30))
    else
        if reachConn then reachConn:Disconnect(); reachConn = nil end
        logConsole("Reach Extender: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)
yOff = yOff + 38

-- Teleport to Map Center
createActionButton(contentFrame, "Teleport to Map Center", yOff, function()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local mapCenter = nil
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("spawn") and obj:IsA("BasePart") then
                mapCenter = obj.Position
                break
            end
        end
    end)
    if not mapCenter then
        pcall(function()
            local total, count = Vector3.new(0,0,0), 0
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj) then
                    total = total + obj.HumanoidRootPart.Position
                    count = count + 1
                end
            end
            if count > 0 then mapCenter = total / count end
        end)
    end
    if not mapCenter then mapCenter = Vector3.new(0, 50, 0) end
    root.CFrame = CFrame.new(mapCenter.X, mapCenter.Y + 50, mapCenter.Z)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end
    root.Anchored = true
    logConsole("Teleported to center", Color3.fromRGB(80, 255, 80))
end)
yOff = yOff + 38

-- Обновляем размер холста
contentFrame.CanvasSize = UDim2.new(0, 0, 0, yOff + 20)

-- ========== ОБНОВЛЕНИЕ СТАТУСА ПРИ РЕСПАВНЕ ==========
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if toggleStates.Speed then hum.WalkSpeed = 60 end
            if toggleStates.Jump then hum.JumpPower = 100 end
        end
    end)
end)

-- ========== ГОРЯЧАЯ КЛАВИША K ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ========== НАЧАЛО ==========
logConsole("Zombie Attack Hub loaded. Press K to toggle", Color3.fromRGB(80, 255, 80))

-- Уведомление
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 280, 0, 36)
notify.Position = UDim2.new(0.5, -140, 0.1, 0)
notify.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
notify.Text = "Zombie Attack Hub loaded! Press K"
notify.TextColor3 = Color3.fromRGB(255, 255, 255)
notify.TextSize = 16
notify.Font = Enum.Font.GothamBold
notify.BackgroundTransparency = 0.2
notify.BorderSizePixel = 0
notify.Parent = screenGui
Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)
game:GetService("Debris"):AddItem(notify, 3)
