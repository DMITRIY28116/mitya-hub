-- ===========================================================
-- Mitya Hub — Zombie Attack
-- Темная тема / Белый текст
-- Открыть/закрыть: K
-- ===========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ========== ЦВЕТОВАЯ СХЕМА ==========
local C = {
    Bg = Color3.fromRGB(10, 10, 10),
    Bg2 = Color3.fromRGB(18, 18, 18),
    Bg3 = Color3.fromRGB(28, 28, 28),
    Accent = Color3.fromRGB(255, 255, 255),
    Accent2 = Color3.fromRGB(180, 180, 180),
    Text = Color3.fromRGB(240, 240, 240),
    Text2 = Color3.fromRGB(160, 160, 160),
    Green = Color3.fromRGB(0, 255, 100),
    Red = Color3.fromRGB(255, 60, 60),
    Border = Color3.fromRGB(40, 40, 40),
    Hover = Color3.fromRGB(35, 35, 35),
    Click = Color3.fromRGB(50, 50, 50),
}

-- ========== HTTP-ЗАГРУЗЧИК ==========
local function httpGet(url)
    local success1, result1 = pcall(function()
        return game:HttpGet(url, true)
    end)
    if success1 and result1 and result1 ~= "" then
        return result1
    end
    
    local success2, result2 = pcall(function()
        return syn.request({Url = url, Method = "GET"}).Body
    end)
    if success2 and result2 and result2 ~= "" then
        return result2
    end
    
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

-- Затемнение фона
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.5
bg.Visible = false
bg.Parent = screenGui

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 440, 0, 560)
mainFrame.Position = UDim2.new(0.5, -220, 0.5, -280)
mainFrame.BackgroundColor3 = C.Bg
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.Border
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ZIndex = 0
shadow.Parent = mainFrame

-- ========== ЗАГОЛОВОК ==========
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3 = C.Bg2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Линия под заголовком
local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(1, 0, 0, 1)
titleLine.Position = UDim2.new(0, 0, 1, 0)
titleLine.BackgroundColor3 = C.Border
titleLine.BorderSizePixel = 0
titleLine.Parent = titleBar

-- Логотип (буква M)
local logo = Instance.new("Frame")
logo.Size = UDim2.new(0, 32, 0, 32)
logo.Position = UDim2.new(0, 12, 0.5, -16)
logo.BackgroundColor3 = C.Accent
logo.BorderSizePixel = 0
logo.Parent = titleBar
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 8)

local logoText = Instance.new("TextLabel", logo)
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "M"
logoText.TextColor3 = C.Bg
logoText.TextScaled = true
logoText.Font = Enum.Font.GothamBold

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 52, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MIT HUB"
titleLabel.TextColor3 = C.Text
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local gameLabel = Instance.new("TextLabel")
gameLabel.Size = UDim2.new(0.35, 0, 1, 0)
gameLabel.Position = UDim2.new(0.55, 0, 0, 0)
gameLabel.BackgroundTransparency = 1
gameLabel.Text = "ZOMBIE ATTACK"
gameLabel.TextColor3 = C.Text2
gameLabel.TextSize = 9
gameLabel.Font = Enum.Font.GothamMedium
gameLabel.TextXAlignment = Enum.TextXAlignment.Right
gameLabel.Parent = titleBar

-- Кнопка сворачивания
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -72, 0.5, -15)
minBtn.BackgroundColor3 = C.Bg3
minBtn.BackgroundTransparency = 0.5
minBtn.BorderSizePixel = 0
minBtn.Text = ""
minBtn.TextColor3 = C.Text2
minBtn.TextSize = 18
minBtn.Font = Enum.Font.Gotham
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local minIcon = Instance.new("TextLabel", minBtn)
minIcon.Size = UDim2.new(1, 0, 1, 0)
minIcon.BackgroundTransparency = 1
minIcon.Text = "─"
minIcon.TextColor3 = C.Text2
minIcon.TextSize = 16
minIcon.Font = Enum.Font.GothamBold

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 440, 0, 48) or UDim2.new(0, 440, 0, 560)
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
end)

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -36, 0.5, -15)
closeBtn.BackgroundColor3 = C.Bg3
closeBtn.BackgroundTransparency = 0.5
closeBtn.BorderSizePixel = 0
closeBtn.Text = ""
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local closeIcon = Instance.new("TextLabel", closeBtn)
closeIcon.Size = UDim2.new(1, 0, 1, 0)
closeIcon.BackgroundTransparency = 1
closeIcon.Text = "✕"
closeIcon.TextColor3 = C.Text2
closeIcon.TextSize = 14
closeIcon.Font = Enum.Font.GothamBold

closeBtn.MouseButton1Click:Connect(function()
    bg.Visible = false
    mainFrame.Visible = false
end)

-- Ховер на кнопки
minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.Hover}):Play()
    minIcon.TextColor3 = C.Text
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.Bg3, BackgroundTransparency = 0.5}):Play()
    minIcon.TextColor3 = C.Text2
end)
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 15, 15)}):Play()
    closeIcon.TextColor3 = C.Red
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.Bg3, BackgroundTransparency = 0.5}):Play()
    closeIcon.TextColor3 = C.Text2
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

-- ========== КОНТЕНТ ==========
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -108)
contentFrame.Position = UDim2.new(0, 10, 0, 58)
contentFrame.BackgroundColor3 = C.Bg
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ScrollBarThickness = 3
contentFrame.ScrollBarImageColor3 = C.Border
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 6)
contentLayout.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 6)
contentPadding.PaddingBottom = UDim.new(0, 6)
contentPadding.PaddingLeft = UDim.new(0, 2)
contentPadding.PaddingRight = UDim.new(0, 2)
contentPadding.Parent = contentFrame

-- ========== СТАТУС-БАР ==========
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, -20, 0, 28)
statusBar.Position = UDim2.new(0, 10, 1, -34)
statusBar.BackgroundColor3 = C.Bg2
statusBar.BorderSizePixel = 0
statusBar.Parent = mainFrame
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 6)

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 8, 0.5, -4)
statusDot.BackgroundColor3 = C.Green
statusDot.BorderSizePixel = 0
statusDot.Parent = statusBar
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel", statusBar)
statusLabel.Size = UDim2.new(1, -20, 1, 0)
statusLabel.Position = UDim2.new(0, 20, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Code
statusLabel.Text = "READY"
statusLabel.TextColor3 = C.Text2
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local function logConsole(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or C.Text2
    if color == C.Green then
        statusDot.BackgroundColor3 = C.Green
    elseif color == C.Red then
        statusDot.BackgroundColor3 = C.Red
    else
        statusDot.BackgroundColor3 = C.Text2
    end
end

-- ========== ФУНКЦИИ ЭЛЕМЕНТОВ ==========
local layoutOrder = 0

local function createSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 26)
    section.BackgroundColor3 = C.Bg2
    section.BorderSizePixel = 0
    section.LayoutOrder = layoutOrder
    section.Parent = contentFrame
    Instance.new("UICorner", section).CornerRadius = UDim.new(0, 5)
    
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(0, 3, 1, -8)
    accentLine.Position = UDim2.new(0, 0, 0, 4)
    accentLine.BackgroundColor3 = C.Accent
    accentLine.BorderSizePixel = 0
    accentLine.Parent = section
    Instance.new("UICorner", accentLine).CornerRadius = UDim.new(0, 2)
    
    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(0.9, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = string.upper(title)
    label.TextColor3 = C.Text
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    layoutOrder = layoutOrder + 1
    return section
end

local function createToggleButton(label, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = C.Bg2
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder
    btn.Parent = contentFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local btnLabel = Instance.new("TextLabel", btn)
    btnLabel.Size = UDim2.new(1, -40, 1, 0)
    btnLabel.Position = UDim2.new(0, 14, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Font = Enum.Font.GothamMedium
    btnLabel.Text = label
    btnLabel.TextColor3 = C.Text
    btnLabel.TextSize = 12
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 36, 0, 18)
    indicator.Position = UDim2.new(1, -46, 0.5, -9)
    indicator.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    local indicatorDot = Instance.new("Frame")
    indicatorDot.Size = UDim2.new(0, 14, 0, 14)
    indicatorDot.Position = UDim2.new(0, 2, 0.5, -7)
    indicatorDot.BackgroundColor3 = C.Text2
    indicatorDot.BorderSizePixel = 0
    indicatorDot.Parent = indicator
    Instance.new("UICorner", indicatorDot).CornerRadius = UDim.new(1, 0)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.Hover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.Bg2}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn, indicatorDot)
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = C.Click}):Play()
        task.wait(0.08)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Bg2}):Play()
    end)
    
    layoutOrder = layoutOrder + 1
    return btn, indicatorDot, indicator
end

local function createActionButton(label, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = C.Bg2
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder
    btn.Parent = contentFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local btnLabel = Instance.new("TextLabel", btn)
    btnLabel.Size = UDim2.new(1, -28, 1, 0)
    btnLabel.Position = UDim2.new(0, 14, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Font = Enum.Font.GothamMedium
    btnLabel.Text = label
    btnLabel.TextColor3 = C.Text
    btnLabel.TextSize = 12
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local arrow = Instance.new("TextLabel", btn)
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -30, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = ">"
    arrow.TextColor3 = C.Text2
    arrow.TextSize = 14
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.Hover}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.15), {TextColor3 = C.Accent}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.Bg2}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.15), {TextColor3 = C.Text2}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback()
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = C.Click}):Play()
        task.wait(0.08)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C.Bg2}):Play()
    end)
    
    layoutOrder = layoutOrder + 1
    return btn
end

local function updateIndicator(dot, state)
    if dot then
        local targetPos = state and UDim2.new(0, 20, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = state and C.Accent or C.Text2
        TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Position = targetPos,
            BackgroundColor3 = targetColor
        }):Play()
    end
end

-- ========== СЕКЦИИ И КНОПКИ ==========

createSection("COMBAT")

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
        
        logConsole("AUTO FARM: ACTIVE", C.Green)
    else
        if farmConn then farmConn:Disconnect(); farmConn = nil end
        globalTarget = nil
        logConsole("AUTO FARM: DISABLED", C.Red)
    end
end)

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
        logConsole("KILL PLATFORM: ACTIVE", C.Green)
    else
        pcall(function()
            local p = Workspace:FindFirstChild("MityaKillPlatform")
            if p then p:Destroy() end
        end)
        logConsole("KILL PLATFORM: DISABLED", C.Red)
    end
end)

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
        logConsole("STEAL KILLS: ACTIVE", C.Green)
    else
        stealKillsActive = false
        logConsole("STEAL KILLS: DISABLED", C.Red)
    end
end)

createSection("WEAPONS")

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
        logConsole("NO RECOIL: ACTIVE", C.Green)
    else
        noRecoilActive = false
        logConsole("NO RECOIL: DISABLED", C.Red)
    end
end)

createToggleButton("Expand Hitboxes", function(btn, ind)
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
        logConsole("HITBOX EXPAND: 40x40x40", C.Green)
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
        logConsole("HITBOX EXPAND: OFF", C.Red)
    end
end)

createToggleButton("Reach Extender", function(btn, ind)
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
        logConsole("REACH: 60x60x60", C.Green)
    else
        if reachConn then reachConn:Disconnect(); reachConn = nil end
        logConsole("REACH: OFF", C.Red)
    end
end)

createActionButton("Equip All Guns", function()
    pcall(function()
        for _, thing in pairs(ReplicatedStorage.Guns:GetChildren()) do
            if thing:IsA("Tool") then thing.Parent = LocalPlayer.Backpack end
        end
    end)
    logConsole("ALL GUNS EQUIPPED", C.Green)
end)

createActionButton("Equip All Knives", function()
    pcall(function()
        for _, thing in pairs(ReplicatedStorage.Knives:GetChildren()) do
            if thing:IsA("Tool") then thing.Parent = LocalPlayer.Backpack end
        end
    end)
    logConsole("ALL KNIVES EQUIPPED", C.Green)
end)

createSection("PLAYER")

createToggleButton("Fly Mode", function(btn, ind)
    toggleStates.Fly = not toggleStates.Fly
    updateIndicator(ind, toggleStates.Fly)
    
    if toggleStates.Fly then
        logConsole("LOADING FLY...", C.Text2)
        task.spawn(function()
            local code = httpGet("https://pastebin.com/raw/7rXZ9VNc")
            if code then
                local fn, err = loadstring(code)
                if fn then
                    pcall(fn)
                    logConsole("FLY: PRESS E", C.Green)
                else
                    logConsole("FLY ERROR: " .. tostring(err), C.Red)
                end
            else
                logConsole("FLY: FAILED TO LOAD", C.Red)
            end
        end)
    else
        logConsole("FLY: TOGGLE WITH E", C.Red)
    end
end)

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
        logConsole("NOCLIP: ACTIVE", C.Green)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        logConsole("NOCLIP: DISABLED", C.Red)
    end
end)

createToggleButton("Low Gravity", function(btn, ind)
    toggleStates.Gravity = not toggleStates.Gravity
    updateIndicator(ind, toggleStates.Gravity)
    
    if toggleStates.Gravity then
        Workspace.Gravity = 5
        logConsole("GRAVITY: 5", C.Green)
    else
        Workspace.Gravity = 196.2
        logConsole("GRAVITY: NORMAL", C.Red)
    end
end)

createToggleButton("Super Speed", function(btn, ind)
    toggleStates.Speed = not toggleStates.Speed
    updateIndicator(ind, toggleStates.Speed)
    
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = toggleStates.Speed and 60 or 16
        end
    end)
    logConsole(toggleStates.Speed and "SPEED: 60" or "SPEED: 16", toggleStates.Speed and C.Green or C.Red)
end)

createToggleButton("Super Jump", function(btn, ind)
    toggleStates.Jump = not toggleStates.Jump
    updateIndicator(ind, toggleStates.Jump)
    
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = toggleStates.Jump and 100 or 50
        end
    end)
    logConsole(toggleStates.Jump and "JUMP: 100" or "JUMP: 50", toggleStates.Jump and C.Green or C.Red)
end)

createSection("UTILITY")

createActionButton("B-Tools", function()
    task.spawn(function()
        local code = httpGet("https://pastebin.com/raw/T0qaXjAR")
        if code then
            local fn, err = loadstring(code)
            if fn then
                pcall(fn)
                logConsole("B-TOOLS: LOADED", C.Green)
            else
                logConsole("B-TOOLS ERROR", C.Red)
            end
        else
            logConsole("B-TOOLS: FAILED", C.Red)
        end
    end)
end)

createActionButton("Teleport to Center", function()
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
    logConsole("TELEPORTED", C.Green)
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
        local visible = not mainFrame.Visible
        bg.Visible = visible
        mainFrame.Visible = visible
    end
end)

-- ========== СТАРТ ==========
logConsole("MIT HUB LOADED | PRESS K", C.Green)
