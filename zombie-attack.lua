-- ===========================================================
-- Mitya Hub — Zombie Attack
-- Dark Theme / White Text
-- Open/Close: K
-- ===========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ========== HTTP ==========
local function httpGet(url)
    local s, r = pcall(function() return game:HttpGet(url, true) end)
    if s and r and r ~= "" then return r end
    local s2, r2 = pcall(function() return syn.request({Url = url, Method = "GET"}).Body end)
    if s2 and r2 and r2 ~= "" then return r2 end
    local s3, r3 = pcall(function() return http_request({Url = url, Method = "GET"}).Body end)
    if s3 and r3 and r3 ~= "" then return r3 end
    return nil
end

-- ========== STATES ==========
local ts = {
    Fly = false, Noclip = false, Gravity = false, Speed = false, Jump = false,
    AutoFarm = false, KillPlatform = false, StealKills = false, NoRecoil = false,
    HitboxExpand = false, Reach = false,
}
local nc, fc, hc, rc = nil, nil, nil, nil
local ex = {}
local gt = nil
local sk = false
local nr = false

-- ========== CLEAR OLD GUI ==========
pcall(function()
    if game.CoreGui:FindFirstChild("MityaHub") then game.CoreGui.MityaHub:Destroy() end
end)
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("MityaHub") then LocalPlayer.PlayerGui.MityaHub:Destroy() end
end)

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "MityaHub"
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.ResetOnSpawn = false
pcall(function() sg.Parent = game.CoreGui end)
if not sg.Parent then sg.Parent = LocalPlayer.PlayerGui end

-- Colors
local C = {
    Bg = Color3.fromRGB(8,8,8), Bg2 = Color3.fromRGB(15,15,15), Bg3 = Color3.fromRGB(25,25,25),
    Accent = Color3.fromRGB(255,255,255), Text = Color3.fromRGB(240,240,240),
    Text2 = Color3.fromRGB(140,140,140), Green = Color3.fromRGB(0,255,100),
    Red = Color3.fromRGB(255,60,60), Border = Color3.fromRGB(35,35,35),
    Hover = Color3.fromRGB(30,30,30), Click = Color3.fromRGB(45,45,45),
}

-- Main Frame
local mf = Instance.new("Frame")
mf.Size = UDim2.new(0, 440, 0, 540)
mf.Position = UDim2.new(0.5, -220, 0.5, -270)
mf.BackgroundColor3 = C.Bg
mf.BorderSizePixel = 0
mf.Parent = sg
Instance.new("UICorner", mf).CornerRadius = UDim.new(0, 10)
local ms = Instance.new("UIStroke", mf)
ms.Color = C.Border
ms.Thickness = 1

-- Titlebar
local tb = Instance.new("Frame")
tb.Size = UDim2.new(1, 0, 0, 46)
tb.BackgroundColor3 = C.Bg2
tb.BorderSizePixel = 0
tb.Parent = mf
Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 10)
local tline = Instance.new("Frame", tb)
tline.Size = UDim2.new(1, 0, 0, 1)
tline.Position = UDim2.new(0, 0, 1, 0)
tline.BackgroundColor3 = C.Border
tline.BorderSizePixel = 0

-- Logo
local lg = Instance.new("Frame")
lg.Size = UDim2.new(0, 30, 0, 30)
lg.Position = UDim2.new(0, 12, 0.5, -15)
lg.BackgroundColor3 = C.Accent
lg.BorderSizePixel = 0
lg.Parent = tb
Instance.new("UICorner", lg).CornerRadius = UDim.new(0, 7)
local lgt = Instance.new("TextLabel", lg)
lgt.Size = UDim2.new(1, 0, 1, 0)
lgt.BackgroundTransparency = 1
lgt.Text = "M"
lgt.TextColor3 = C.Bg
lgt.TextScaled = true
lgt.Font = Enum.Font.GothamBold

local ttl = Instance.new("TextLabel")
ttl.Size = UDim2.new(1, -100, 1, 0)
ttl.Position = UDim2.new(0, 50, 0, 0)
ttl.BackgroundTransparency = 1
ttl.Text = "MITYA HUB"
ttl.TextColor3 = C.Text
ttl.TextSize = 17
ttl.Font = Enum.Font.GothamBlack
ttl.TextXAlignment = Enum.TextXAlignment.Left
ttl.Parent = tb

local gml = Instance.new("TextLabel")
gml.Size = UDim2.new(0.35, 0, 1, 0)
gml.Position = UDim2.new(0.55, 0, 0, 0)
gml.BackgroundTransparency = 1
gml.Text = "ZOMBIE ATTACK"
gml.TextColor3 = C.Text2
gml.TextSize = 9
gml.Font = Enum.Font.GothamMedium
gml.TextXAlignment = Enum.TextXAlignment.Right
gml.Parent = tb

-- Minimize
local minb = Instance.new("TextButton")
minb.Size = UDim2.new(0, 30, 0, 30)
minb.Position = UDim2.new(1, -72, 0.5, -15)
minb.BackgroundColor3 = C.Bg3
minb.BorderSizePixel = 0
minb.Text = ""
minb.Parent = tb
Instance.new("UICorner", minb).CornerRadius = UDim.new(0, 6)
local minl = Instance.new("TextLabel", minb)
minl.Size = UDim2.new(1, 0, 1, 0)
minl.BackgroundTransparency = 1
minl.Text = "_"
minl.TextColor3 = C.Text2
minl.TextSize = 16
minl.Font = Enum.Font.GothamBold

local isMin = false
minb.MouseButton1Click:Connect(function()
    isMin = not isMin
    local ts = isMin and UDim2.new(0, 440, 0, 46) or UDim2.new(0, 440, 0, 540)
    TweenService:Create(mf, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = ts}):Play()
end)

-- Close
local clb = Instance.new("TextButton")
clb.Size = UDim2.new(0, 30, 0, 30)
clb.Position = UDim2.new(1, -36, 0.5, -15)
clb.BackgroundColor3 = C.Bg3
clb.BorderSizePixel = 0
clb.Text = ""
clb.Parent = tb
Instance.new("UICorner", clb).CornerRadius = UDim.new(0, 6)
local cll = Instance.new("TextLabel", clb)
cll.Size = UDim2.new(1, 0, 1, 0)
cll.BackgroundTransparency = 1
cll.Text = "X"
cll.TextColor3 = C.Text2
cll.TextSize = 14
cll.Font = Enum.Font.GothamBold

clb.MouseButton1Click:Connect(function()
    mf.Visible = false
end)

-- Hover effects
minb.MouseEnter:Connect(function() TweenService:Create(minb, TweenInfo.new(0.15), {BackgroundColor3 = C.Hover}):Play() minl.TextColor3 = C.Text end)
minb.MouseLeave:Connect(function() TweenService:Create(minb, TweenInfo.new(0.15), {BackgroundColor3 = C.Bg3}):Play() minl.TextColor3 = C.Text2 end)
clb.MouseEnter:Connect(function() TweenService:Create(clb, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60,15,15)}):Play() cll.TextColor3 = C.Red end)
clb.MouseLeave:Connect(function() TweenService:Create(clb, TweenInfo.new(0.15), {BackgroundColor3 = C.Bg3}):Play() cll.TextColor3 = C.Text2 end)

-- Drag
local dt, di, ds, sp
tb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dt = true ds = input.Position sp = mf.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dt = false end end)
    end
end)
tb.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then di = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == di and dt then
        local d = input.Position - ds
        mf.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
    end
end)

-- Content
local cf = Instance.new("ScrollingFrame")
cf.Size = UDim2.new(1, -16, 1, -100)
cf.Position = UDim2.new(0, 8, 0, 54)
cf.BackgroundColor3 = C.Bg
cf.BorderSizePixel = 0
cf.CanvasSize = UDim2.new(0, 0, 0, 0)
cf.ScrollBarThickness = 3
cf.ScrollBarImageColor3 = C.Border
cf.AutomaticCanvasSize = Enum.AutomaticSize.Y
cf.Parent = mf

local cll2 = Instance.new("UIListLayout", cf)
cll2.SortOrder = Enum.SortOrder.LayoutOrder
cll2.Padding = UDim.new(0, 5)

local cp = Instance.new("UIPadding", cf)
cp.PaddingTop = UDim.new(0, 5)
cp.PaddingBottom = UDim.new(0, 5)
cp.PaddingLeft = UDim.new(0, 2)
cp.PaddingRight = UDim.new(0, 2)

-- Status
local sb = Instance.new("Frame")
sb.Size = UDim2.new(1, -16, 0, 26)
sb.Position = UDim2.new(0, 8, 1, -32)
sb.BackgroundColor3 = C.Bg2
sb.BorderSizePixel = 0
sb.Parent = mf
Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 6)

local sd = Instance.new("Frame")
sd.Size = UDim2.new(0, 7, 0, 7)
sd.Position = UDim2.new(0, 8, 0.5, -3)
sd.BackgroundColor3 = C.Green
sd.BorderSizePixel = 0
sd.Parent = sb
Instance.new("UICorner", sd).CornerRadius = UDim.new(1, 0)

local sl = Instance.new("TextLabel", sb)
sl.Size = UDim2.new(1, -20, 1, 0)
sl.Position = UDim2.new(0, 18, 0, 0)
sl.BackgroundTransparency = 1
sl.Font = Enum.Font.Code
sl.Text = "READY"
sl.TextColor3 = C.Text2
sl.TextSize = 10
sl.TextXAlignment = Enum.TextXAlignment.Left

local function log(msg, col)
    sl.Text = msg
    sl.TextColor3 = col or C.Text2
    sd.BackgroundColor3 = col or C.Text2
end

-- Elements
local lo = 0

local function sec(t)
    local s = Instance.new("Frame")
    s.Size = UDim2.new(1, 0, 0, 24)
    s.BackgroundColor3 = C.Bg2
    s.BorderSizePixel = 0
    s.LayoutOrder = lo
    s.Parent = cf
    Instance.new("UICorner", s).CornerRadius = UDim.new(0, 5)
    local a = Instance.new("Frame")
    a.Size = UDim2.new(0, 2, 1, -8)
    a.Position = UDim2.new(0, 0, 0, 4)
    a.BackgroundColor3 = C.Accent
    a.BorderSizePixel = 0
    a.Parent = s
    local l = Instance.new("TextLabel", s)
    l.Size = UDim2.new(1, -10, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold
    l.Text = string.upper(t)
    l.TextColor3 = C.Text
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    lo = lo + 1
    return s
end

local function tog(lbl, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = C.Bg2
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = lo
    b.Parent = cf
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    
    local bl = Instance.new("TextLabel", b)
    bl.Size = UDim2.new(1, -50, 1, 0)
    bl.Position = UDim2.new(0, 12, 0, 0)
    bl.BackgroundTransparency = 1
    bl.Font = Enum.Font.GothamMedium
    bl.Text = lbl
    bl.TextColor3 = C.Text
    bl.TextSize = 11
    bl.TextXAlignment = Enum.TextXAlignment.Left
    
    local tr = Instance.new("Frame")
    tr.Size = UDim2.new(0, 34, 0, 16)
    tr.Position = UDim2.new(1, -44, 0.5, -8)
    tr.BackgroundColor3 = Color3.fromRGB(40,40,40)
    tr.BorderSizePixel = 0
    tr.Parent = b
    Instance.new("UICorner", tr).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 2, 0.5, -6)
    dot.BackgroundColor3 = C.Text2
    dot.BorderSizePixel = 0
    dot.Parent = tr
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Hover}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Bg2}):Play() end)
    b.MouseButton1Click:Connect(function()
        cb(b, dot)
        TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = C.Click}):Play()
        task.wait(0.08)
        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = C.Bg2}):Play()
    end)
    
    lo = lo + 1
    return b, dot
end

local function act(lbl, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = C.Bg2
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = lo
    b.Parent = cf
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    
    local bl = Instance.new("TextLabel", b)
    bl.Size = UDim2.new(1, -28, 1, 0)
    bl.Position = UDim2.new(0, 12, 0, 0)
    bl.BackgroundTransparency = 1
    bl.Font = Enum.Font.GothamMedium
    bl.Text = lbl
    bl.TextColor3 = C.Text
    bl.TextSize = 11
    bl.TextXAlignment = Enum.TextXAlignment.Left
    
    local ar = Instance.new("TextLabel", b)
    ar.Size = UDim2.new(0, 20, 0, 20)
    ar.Position = UDim2.new(1, -28, 0.5, -10)
    ar.BackgroundTransparency = 1
    ar.Font = Enum.Font.GothamBold
    ar.Text = ">"
    ar.TextColor3 = C.Text2
    ar.TextSize = 13
    
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Hover}):Play() ar.TextColor3 = C.Accent end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Bg2}):Play() ar.TextColor3 = C.Text2 end)
    b.MouseButton1Click:Connect(function()
        cb()
        TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = C.Click}):Play()
        task.wait(0.08)
        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = C.Bg2}):Play()
    end)
    
    lo = lo + 1
    return b
end

local function upd(dot, st)
    if dot then
        local tp = st and UDim2.new(0, 20, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        local tc = st and C.Accent or C.Text2
        TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = tp, BackgroundColor3 = tc}):Play()
    end
end

-- ========== SECTIONS ==========

sec("COMBAT")

tog("Auto Farm", function(btn, ind)
    ts.AutoFarm = not ts.AutoFarm
    upd(ind, ts.AutoFarm)
    if ts.AutoFarm then
        task.spawn(function()
            local gd = 8
            local function gn()
                local n, d = nil, 99999
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return nil end
                pcall(function() for _, v in pairs(Workspace.BossFolder:GetChildren()) do if v:FindFirstChild("Head") then local m = (LocalPlayer.Character.Head.Position - v.Head.Position).Magnitude if m < d then d = m n = v end end end end)
                pcall(function() for _, v in pairs(Workspace.enemies:GetChildren()) do if v:FindFirstChild("Head") then local m = (LocalPlayer.Character.Head.Position - v.Head.Position).Magnitude if m < d then d = m n = v end end end end)
                return n
            end
            fc = RunService.RenderStepped:Connect(function()
                if not ts.AutoFarm then return end
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local t = gn()
                if t and t:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = t.HumanoidRootPart.CFrame * CFrame.new(0, gd, 9)
                    gt = t
                end
            end)
            while ts.AutoFarm do
                task.wait(0.05)
                if gt and gt:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    pcall(function()
                        ReplicatedStorage.Gun:FireServer({Normal=Vector3.new(0,0,0),Direction=gt.Head.Position,Name=LocalPlayer.Character:FindFirstChildOfClass("Tool").Name,Hit=gt.Head,Origin=gt.Head.Position,Pos=gt.Head.Position})
                    end)
                end
            end
            if fc then fc:Disconnect() fc = nil end
        end)
        task.spawn(function() while ts.AutoFarm do task.wait() pcall(function() if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) end end) end end)
        log("AUTO FARM: ON", C.Green)
    else
        if fc then fc:Disconnect() fc = nil end
        gt = nil
        log("AUTO FARM: OFF", C.Red)
    end
end)

tog("Kill Platform", function(btn, ind)
    ts.KillPlatform = not ts.KillPlatform
    upd(ind, ts.KillPlatform)
    if ts.KillPlatform then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local p = Instance.new("Part")
            p.Name = "MKP" p.Size = Vector3.new(100,0.5,100) p.Anchored = true p.Position = Vector3.new(555,555,555) p.Material = Enum.Material.Neon p.Color = Color3.fromRGB(120,0,180) p.Parent = Workspace
            root.CFrame = p.CFrame * CFrame.new(0,4,0)
            pcall(function() for _, a in pairs(Workspace.enemies:GetChildren()) do for _, b in pairs(a:GetChildren()) do if b:IsA("BasePart") then b.Anchored = true b.CFrame = root.CFrame * CFrame.new(2,0,2) end end end end)
        end
        log("KILL PLATFORM: ON", C.Green)
    else
        pcall(function() local p = Workspace:FindFirstChild("MKP") if p then p:Destroy() end end)
        log("KILL PLATFORM: OFF", C.Red)
    end
end)

tog("Steal Kills", function(btn, ind)
    ts.StealKills = not ts.StealKills
    upd(ind, ts.StealKills)
    if ts.StealKills then
        sk = true
        task.spawn(function() while sk do task.wait(0.1) pcall(function() for _, v in pairs(Workspace.enemies:GetChildren()) do if v:FindFirstChild("Humanoid") and v.Humanoid.Health < v.Humanoid.MaxHealth*0.5 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then ReplicatedStorage.Gun:FireServer({Normal=Vector3.new(0,0,0),Direction=v.Head.Position,Name=LocalPlayer.Character:FindFirstChildOfClass("Tool").Name,Hit=v.Head,Origin=v.Head.Position,Pos=v.Head.Position}) end end end) end end)
        log("STEAL KILLS: ON", C.Green)
    else
        sk = false
        log("STEAL KILLS: OFF", C.Red)
    end
end)

sec("WEAPONS")

tog("No Recoil", function(btn, ind)
    ts.NoRecoil = not ts.NoRecoil
    upd(ind, ts.NoRecoil)
    if ts.NoRecoil then
        nr = true
        task.spawn(function() while nr do task.wait() pcall(function() if LocalPlayer.Character then for _, tool in pairs(LocalPlayer.Character:GetChildren()) do if tool:IsA("Tool") then for _, mod in pairs(tool:GetDescendants()) do if mod:IsA("Configuration") then for _, val in pairs(mod:GetChildren()) do if val.Name:lower():find("recoil") and val:IsA("ValueBase") then val.Value = 0 end end end end end end end end) end end)
        log("NO RECOIL: ON", C.Green)
    else
        nr = false
        log("NO RECOIL: OFF", C.Red)
    end
end)

tog("Expand Hitboxes", function(btn, ind)
    ts.HitboxExpand = not ts.HitboxExpand
    upd(ind, ts.HitboxExpand)
    if ts.HitboxExpand then
        local hs = Vector3.new(40,40,40)
        hc = RunService.Heartbeat:Connect(function()
            if not ts.HitboxExpand then return end
            pcall(function() for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") and obj.Parent and obj.Parent:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj.Parent) and obj.Parent:FindFirstChild("HumanoidRootPart") and obj.Parent.Humanoid.Health > 0 and not ex[obj] then ex[obj] = {OriginalSize=obj.Size,OriginalTransparency=obj.Transparency,OriginalCollision=obj.CanCollide} obj.Size = hs obj.Transparency = 0.85 obj.CanCollide = false end end end)
        end)
        log("HITBOX: 40x40x40", C.Green)
    else
        if hc then hc:Disconnect() hc = nil end
        for obj, data in pairs(ex) do pcall(function() if obj and obj.Parent then obj.Size = data.OriginalSize obj.Transparency = data.OriginalTransparency obj.CanCollide = data.OriginalCollision end end) end
        ex = {}
        log("HITBOX: OFF", C.Red)
    end
end)

tog("Reach Extender", function(btn, ind)
    ts.Reach = not ts.Reach
    upd(ind, ts.Reach)
    if ts.Reach then
        local rs = Vector3.new(60,60,60)
        rc = RunService.Heartbeat:Connect(function()
            if not ts.Reach then return end
            pcall(function() if LocalPlayer.Character then for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do if tool:IsA("Tool") and tool:FindFirstChild("Handle") then tool.Handle.Size = rs tool.Handle.Transparency = 1 tool.Handle.CanCollide = false tool.Handle.Massless = true end end end end)
        end)
        log("REACH: 60x60x60", C.Green)
    else
        if rc then rc:Disconnect() rc = nil end
        log("REACH: OFF", C.Red)
    end
end)

act("Equip All Guns", function()
    pcall(function() for _, t in pairs(ReplicatedStorage.Guns:GetChildren()) do if t:IsA("Tool") then t.Parent = LocalPlayer.Backpack end end end)
    log("GUNS EQUIPPED", C.Green)
end)

act("Equip All Knives", function()
    pcall(function() for _, t in pairs(ReplicatedStorage.Knives:GetChildren()) do if t:IsA("Tool") then t.Parent = LocalPlayer.Backpack end end end)
    log("KNIVES EQUIPPED", C.Green)
end)

sec("PLAYER")

tog("Fly Mode", function(btn, ind)
    ts.Fly = not ts.Fly
    upd(ind, ts.Fly)
    if ts.Fly then
        log("LOADING FLY...", C.Text2)
        task.spawn(function()
            local code = httpGet("https://pastebin.com/raw/7rXZ9VNc")
            if code then
                local fn, err = loadstring(code)
                if fn then pcall(fn) log("FLY: PRESS E", C.Green) else log("FLY ERR", C.Red) end
            else log("FLY FAIL", C.Red) end
        end)
    else log("FLY: OFF", C.Red) end
end)

tog("NoClip", function(btn, ind)
    ts.Noclip = not ts.Noclip
    upd(ind, ts.Noclip)
    if ts.Noclip then
        nc = RunService.Stepped:Connect(function() if ts.Noclip and LocalPlayer.Character then local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if hum then hum:ChangeState(11) end end end)
        log("NOCLIP: ON", C.Green)
    else if nc then nc:Disconnect() nc = nil end log("NOCLIP: OFF", C.Red) end
end)

tog("Low Gravity", function(btn, ind)
    ts.Gravity = not ts.Gravity
    upd(ind, ts.Gravity)
    Workspace.Gravity = ts.Gravity and 5 or 196.2
    log(ts.Gravity and "GRAVITY: 5" or "GRAVITY: NORMAL", ts.Gravity and C.Green or C.Red)
end)

tog("Super Speed", function(btn, ind)
    ts.Speed = not ts.Speed
    upd(ind, ts.Speed)
    pcall(function() local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed = ts.Speed and 60 or 16 end end)
    log(ts.Speed and "SPEED: 60" or "SPEED: 16", ts.Speed and C.Green or C.Red)
end)

tog("Super Jump", function(btn, ind)
    ts.Jump = not ts.Jump
    upd(ind, ts.Jump)
    pcall(function() local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if hum then hum.JumpPower = ts.Jump and 100 or 50 end end)
    log(ts.Jump and "JUMP: 100" or "JUMP: 50", ts.Jump and C.Green or C.Red)
end)

sec("UTILITY")

act("B-Tools", function()
    task.spawn(function()
        local code = httpGet("https://pastebin.com/raw/T0qaXjAR")
        if code then local fn, err = loadstring(code) if fn then pcall(fn) log("B-TOOLS OK", C.Green) else log("B-TOOLS ERR", C.Red) end else log("B-TOOLS FAIL", C.Red) end
    end)
end)

act("Teleport Center", function()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local mc = nil
    pcall(function() for _, obj in ipairs(Workspace:GetDescendants()) do if obj.Name:lower():find("spawn") and obj:IsA("BasePart") then mc = obj.Position break end end end)
    if not mc then pcall(function() local t, cnt = Vector3.new(0,0,0), 0 for _, obj in ipairs(Workspace:GetDescendants()) do if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj) then t = t + obj.HumanoidRootPart.Position cnt = cnt + 1 end end if cnt > 0 then mc = t / cnt end end) end
    if not mc then mc = Vector3.new(0,50,0) end
    root.CFrame = CFrame.new(mc.X, mc.Y + 50, mc.Z)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end
    root.Anchored = true
    log("TELEPORTED", C.Green)
end)

-- ========== RESPAWN ==========
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if ts.Speed then hum.WalkSpeed = 60 end
            if ts.Jump then hum.JumpPower = 100 end
        end
    end)
end)

-- ========== HOTKEY K ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        mf.Visible = not mf.Visible
    end
end)

-- ========== START ==========
log("MITYA HUB | PRESS K", C.Green)
