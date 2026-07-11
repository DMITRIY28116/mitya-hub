-- ===========================================================
-- Mitya Hub — Zombie Attack
-- Исправленная версия для Xeno
-- Открыть/закрыть: K
-- ===========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ========== HTTP-ЗАГРУЗЧИК (ИСПРАВЛЕН!) ==========
local function httpGet(url)
    -- Метод 1: game:HttpGet (работает в Xeno)
    local success1, result1 = pcall(function()
        return game:HttpGet(url, true)
    end)
    if success1 and result1 and result1 ~= "" then
        return result1
    end
    
    -- Метод 2: syn.request (Solara/Fluxus)
    local success2, result2 = pcall(function()
        return syn.request({Url = url, Method = "GET"}).Body
    end)
    if success2 and result2 and result2 ~= "" then
        return result2
    end
    
    -- Метод 3: http_request
    local success3, result3 = pcall(function()
        return http_request({Url = url, Method = "GET"}).Body
    end)
    if success3 and result3 and result3 ~= "" then
        return result3
    end
    
    return nil
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

-- ========== ПЕРЕМЕННЫЕ ==========
local noclipConn = nil
local farmConn = nil
local hitboxConn = nil
local reachConn = nil
local expandedParts = {}
local globalTarget = nil
local stealKillsActive = false
local noRecoilActive = false

-- ========== УДАЛЯЕМ СТАРЫЙ GUI ==========
pcall(function()
    if game.CoreGui:FindFirstChild("MityaHub") then
        game.CoreGui.MityaHub:Destroy()
    end
end)
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("MityaHub") then
        LocalPlayer.PlayerGui.MityaHub:Destroy()
    end
end)

-- ========== СОЗДАНИЕ GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MityaHub"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

pcall(function()
    screenGui.Parent = game.CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = LocalPlayer.PlayerGui
end

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 550)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 2, 48)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(140, 50, 210)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.4
mainStroke.Parent = mainFrame

-- ========== ЗАГОЛОВОК ==========
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 0, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Логотип
local logo = Instance.new("Frame")
logo.Size = UDim2.new(0, 28, 0, 28)
logo.Position = UDim2.new(0, 10, 0.5, -14)
logo.BackgroundColor3 = Color3.fromRGB(140, 50, 210)
logo.BorderSizePixel = 0
logo.Parent = titleBar
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 6)

local logoText = Instance.new("TextLabel", logo)
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "M"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextScaled = true
logoText.Font = Enum.Font.GothamBold

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 45, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Mitya Hub"
titleLabel.TextColor3 = Color3.fromRGB(230, 200, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local gameLabel = Instance.new("TextLabel")
gameLabel.Size = UDim2.new(0.4, 0, 1, 0)
gameLabel.Position = UDim2.new(0.58, 0, 0, 0)
gameLabel.BackgroundTransparency = 1
gameLabel.Text = "Zombie Attack"
gameLabel.TextColor3 = Color3.fromRGB(140, 80, 200)
gameLabel.TextSize = 11
gameLabel.Font = Enum.Font.Gotham
gameLabel.TextXAlignment = Enum.TextXAlignment.Right
gameLabel.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Кнопка сворачивания
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -72, 0.5, -14)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 60)
minBtn.BackgroundTransparency = 0.3
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(180, 140, 220)
minBtn.TextSize = 18
minBtn.Font = Enum.Font.Gotham
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 420, 0, 45) or UDim2.new(0, 420, 0, 550)
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
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
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ========== КОНТЕНТ (СКРОЛЛ) ==========
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -16, 1, -95)
contentFrame.Position = UDim2.new(0, 8, 0, 55)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 2, 40)
contentFrame.BackgroundTransparency = 0.2
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(140, 50, 210)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 8)

local contentLayout = Instance.new("UIListLayout")
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 4)
contentLayout.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 4)
contentPadding.PaddingBottom = UDim.new(0, 4)
contentPadding.PaddingLeft = UDim.new(0, 4)
contentPadding.PaddingRight = UDim.new(0, 4)
contentPadding.Parent = contentFrame

-- ========== КОНСОЛЬ ==========
local consoleFrame = Instance.new("Frame")
consoleFrame.Size = UDim2.new(1, -16, 0, 30)
consoleFrame.Position = UDim2.new(0, 8, 1, -36)
consoleFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 25)
consoleFrame.BackgroundTransparency = 0.3
consoleFrame.BorderSizePixel = 0
consoleFrame.Parent = mainFrame
Instance.new("UICorner", consoleFrame).CornerRadius = UDim.new(0, 6)

local consoleLabel = Instance.new("TextLabel", consoleFrame)
consoleLabel.Size = UDim2.new(1, -6, 1, -4)
consoleLabel.Position = UDim2.new(0, 3, 0, 2)
consoleLabel.BackgroundTransparency = 1
consoleLabel.Font = Enum.Font.Code
consoleLabel.Text = "Status: Ready"
consoleLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
consoleLabel.TextSize = 11
consoleLabel.TextWrapped = true
consoleLabel.TextXAlignment = Enum.TextXAlignment.Left

local function logConsole(text, color)
    consoleLabel.Text = text
    consoleLabel.TextColor3 = color or Color3.fromRGB(80, 255, 80)
end

-- ========== ФУНКЦИИ КНОПОК ==========
local layoutOrder = 0

local function createSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 22)
    section.BackgroundColor3 = Color3.fromRGB(45, 5, 70)
    section.BackgroundTransparency = 0.3
    section.BorderSizePixel = 0
    section.LayoutOrder = layoutOrder
    section.Parent = contentFrame
    Instance.new("UICorner", section).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(0.9, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Text = "▸ " .. string.upper(title)
    label.TextColor3 = Color3.fromRGB(180, 100, 255)
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    layoutOrder = layoutOrder + 1
    return section
end

local function createToggleButton(label, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(45, 10, 70)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = "  " .. label
    btn.TextColor3 = Color3.fromRGB(220, 200, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder
    btn.Parent = contentFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 10, 0, 10)
    indicator.Position = UDim2.new(1, -16, 0.5, -5)
    indicator.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 15, 90)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 10, 70), BackgroundTransparency = 0.3}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn, indicator)
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(80, 25, 120)}):Play()
        task.wait(0.08)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 10, 70)}):Play()
    end)
    
    layoutOrder = layoutOrder + 1
    return btn, indicator
end

local function createActionButton(label, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(45, 10, 70)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = "  ▸ " .. label
    btn.TextColor3 = Color3.fromRGB(220, 200, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder
    btn.Parent = contentFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 15, 90)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 10, 70), BackgroundTransparency = 0.3}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback()
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(80, 25, 120)}):Play()
        task.wait(0.08)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 10, 70)}):Play()
    end)
    
    layoutOrder = layoutOrder + 1
    return btn
end

local function updateIndicator(ind, state)
    if ind then
        TweenService:Create(ind, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = state and Color3.fromRGB(30, 200, 30) or Color3.fromRGB(150, 30, 30)
        }):Play()
    end
end

-- ═══════════════════════════════════════════════════════════════
-- СЕКЦИИ И КНОПКИ
-- ═══════════════════════════════════════════════════════════════

createSection("Main Mods")

-- Kill Platform
createToggleButton("Kill Platform", function(btn, ind)
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
                        if b:IsA("BasePart") then
                            b.Anchored = true
                            b.CFrame = root.CFrame * CFrame.new(2, 0, 2)
                        end
                    end
                end
            end)
        end
        logConsole("Kill Platform: Active", Color3.fromRGB(30, 180, 30))
    else
        pcall(function()
            local p = Workspace:FindFirstChild("MityaKillPlatform")
            if p then p:Destroy() end
        end)
        logConsole("Kill Platform: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)

-- Steal Kills
createToggleButton("Steal Kills", function(btn, ind)
    toggleStates.StealKills = not toggleStates.StealKills
    updateIndicator(ind, toggleStates.StealKills)
    
    if toggleStates.StealKills then
        stealKillsActive = true
        task.spawn(function()
            while stealKillsActive do
                task.wait(0.1)
                pcall(function()
                    for _, v in pairs(Workspace.enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health < v.Humanoid.MaxHealth * 0.5 then
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChildOfClass("Tool") then
                                ReplicatedStorage.Gun:FireServer({
                                    Normal = Vector3.new(0, 0, 0),
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
        logConsole("Steal Kills: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)

-- Auto Farm
createToggleButton("Auto Farm", function(btn, ind)
    toggleStates.AutoFarm = not toggleStates.AutoFarm
    updateIndicator(ind, toggleStates.AutoFarm)
    
    if toggleStates.AutoFarm then
        task.spawn(function()
            local groundDistance = 8
            
            local function getNearest()
                local nearest, dist = nil, 99999
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return nil end
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
                    char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, groundDistance, 9)
                    globalTarget = target
                end
            end)
            
            while toggleStates.AutoFarm do
                task.wait(0.05)
                if globalTarget and globalTarget:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    pcall(function()
                        ReplicatedStorage.Gun:FireServer({
                            Normal = Vector3.new(0, 0, 0),
                            Direction = globalTarget.Head.Position,
                            Name = LocalPlayer.Character:FindFirstChildOfClass("Tool").Name,
                            Hit = globalTarget.Head,
                            Origin = globalTarget.Head.Position,
                            Pos = globalTarget.Head.Position,
                        })
                    end)
                end
            end
            
            if farmConn then farmConn:Disconnect(); farmConn = nil end
        end)
        
        -- Обнуление скорости
        task.spawn(function()
            while toggleStates.AutoFarm do
                task.wait()
                pcall(function()
                    if LocalPlayer.Character then
                        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        if LocalPlayer.Character:FindFirstChild("Torso") then
                            LocalPlayer.Character.Torso.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end)
            end
        end)
        
        logConsole("Auto Farm: Active", Color3.fromRGB(30, 180, 30))
    else
        if farmConn then farmConn:Disconnect(); farmConn = nil end
        globalTarget = nil
        logConsole("Auto Farm: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)

createSection("Weapon Mods")

-- No Recoil
createToggleButton("No Recoil", function(btn, ind)
    toggleStates.NoRecoil = not toggleStates.NoRecoil
    updateIndicator(ind, toggleStates.NoRecoil)
    
    if toggleStates.NoRecoil then
        noRecoilActive = true
        task.spawn(function()
            while noRecoilActive do
                task.wait()
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
        noRecoilActive = false
        logConsole("No Recoil: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)

-- Equip All Guns
createActionButton("Equip All Guns", function()
    pcall(function()
        for _, thing in pairs(ReplicatedStorage.Guns:GetChildren()) do
            if thing:IsA("Tool") then thing.Parent = LocalPlayer.Backpack end
        end
    end)
    logConsole("All guns equipped", Color3.fromRGB(80, 255, 80))
end)

-- Equip All Knives
createActionButton("Equip All Knives", function()
    pcall(function()
        for _, thing in pairs(ReplicatedStorage.Knives:GetChildren()) do
            if thing:IsA("Tool") then thing.Parent = LocalPlayer.Backpack end
        end
    end)
    logConsole("All knives equipped", Color3.fromRGB(80, 255, 80))
end)

-- Hitbox Expand
createToggleButton("Expand Zombie Hitboxes", function(btn, ind)
    toggleStates.HitboxExpand = not toggleStates.HitboxExpand
    updateIndicator(ind, toggleStates.HitboxExpand)
    
    if toggleStates.HitboxExpand then
        local hitboxSize = Vector3.new(40, 40, 40)
        hitboxConn = RunService.Heartbeat:Connect(function()
            if not toggleStates.HitboxExpand then return end
            pcall(function()
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Parent and obj.Parent:FindFirstChild("Humanoid") 
                       and not Players:GetPlayerFromCharacter(obj.Parent) 
                       and obj.Parent:FindFirstChild("HumanoidRootPart") 
                       and obj.Parent.Humanoid.Health > 0 
                       and not expandedParts[obj] then
                        expandedParts[obj] = {
                            OriginalSize = obj.Size,
                            OriginalTransparency = obj.Transparency,
                            OriginalCollision = obj.CanCollide,
                        }
                        obj.Size = hitboxSize
                        obj.Transparency = 0.85
                        obj.CanCollide = false
                    end
                end
            end)
        end)
        logConsole("Hitbox Expand: Active (40x40x40)", Color3.fromRGB(30, 180, 30))
    else
        if hitboxConn then hitboxConn:Disconnect(); hitboxConn = nil end
        for obj, data in pairs(expandedParts) do
            pcall(function()
                if obj and obj.Parent then
                    obj.Size = data.OriginalSize
                    obj.Transparency = data.OriginalTransparency
                    obj.CanCollide = data.OriginalCollision
                end
            end)
        end
        expandedParts = {}
        logConsole("Hitbox Expand: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)

-- Weapon Reach Extender
createToggleButton("Weapon Reach Extender", function(btn, ind)
    toggleStates.Reach = not toggleStates.Reach
    updateIndicator(ind, toggleStates.Reach)
    
    if toggleStates.Reach then
        local reachSize = Vector3.new(60, 60, 60)
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
        logConsole("Reach Extender: Active (60x60x60)", Color3.fromRGB(30, 180, 30))
    else
        if reachConn then reachConn:Disconnect(); reachConn = nil end
        logConsole("Reach Extender: Disabled", Color3.fromRGB(150, 30, 30))
    end
end)

createSection("Local Player Mods")

-- Fly Mode (ИСПРАВЛЕН!)
createToggleButton("Fly Mode (E)", function(btn, ind)
    toggleStates.Fly = not toggleStates.Fly
    updateIndicator(ind, toggleStates.Fly)
    
    if toggleStates.Fly then
        logConsole("Loading fly script...", Color3.fromRGB(80, 180, 255))
        task.spawn(function()
            local code = httpGet("https://pastebin.com/raw/7rXZ9VNc")
            if code then
                local fn, err = loadstring(code)
                if fn then
                    pcall(fn)
                    logConsole("Fly: Press E to toggle", Color3.fromRGB(80, 180, 255))
                else
                    logConsole("Fly: Script error - " .. tostring(err), Color3.fromRGB(255, 80, 80))
                end
            else
                logConsole("Fly: Failed to load script", Color3.fromRGB(255, 80, 80))
            end
        end)
    else
        logConsole("Fly: Toggle with E key", Color3.fromRGB(150, 30, 30))
    end
end)

-- NoClip
createToggleButton("NoClip", function(btn, ind)
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

-- Low Gravity
createToggleButton("Low Gravity", function(btn, ind)
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

-- Super Speed
createToggleButton("Super Speed", function(btn, ind)
    toggleStates.Speed = not toggleStates.Speed
    updateIndicator(ind, toggleStates.Speed)
    
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = toggleStates.Speed and 60 or 16
        end
    end)
    logConsole(toggleStates.Speed and "Speed: 60" or "Speed: Normal", toggleStates.Speed and Color3.fromRGB(30, 180, 30) or Color3.fromRGB(150, 30, 30))
end)

-- Super Jump
createToggleButton("Super Jump", function(btn, ind)
    toggleStates.Jump = not toggleStates.Jump
    updateIndicator(ind, toggleStates.Jump)
    
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = toggleStates.Jump and 100 or 50
        end
    end)
    logConsole(toggleStates.Jump and "Jump: 100" or "Jump: Normal", toggleStates.Jump and Color3.fromRGB(30, 180, 30) or Color3.fromRGB(150, 30, 30))
end)

-- B-Tools (ИСПРАВЛЕН!)
createActionButton("B-Tools", function()
    task.spawn(function()
        local code = httpGet("https://pastebin.com/raw/T0qaXjAR")
        if code then
            local fn, err = loadstring(code)
            if fn then
                pcall(fn)
                logConsole("B-Tools: Loaded", Color3.fromRGB(80, 255, 80))
            else
                logConsole("B-Tools: Error - " .. tostring(err), Color3.fromRGB(255, 80, 80))
            end
        else
            logConsole("B-Tools: Failed to load", Color3.fromRGB(255, 80, 80))
        end
    end)
end)

-- Teleport to Map Center
createActionButton("Teleport to Map Center", function()
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
            local total, count = Vector3.new(0, 0, 0), 0
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") 
                   and not Players:GetPlayerFromCharacter(obj) then
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

-- ========== РЕСПАВН ==========
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
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

-- ========== СТАРТ ==========
logConsole("Mitya Hub loaded! Press K to toggle", Color3.fromRGB(80, 255, 80))
