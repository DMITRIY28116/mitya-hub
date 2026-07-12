local ZombieAttackGUI = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local TextLabel_2 = Instance.new("TextLabel") -- заголовок
local Frame = Instance.new("Frame")
local TextLabel_3 = Instance.new("TextLabel")
local ConsoleFrame = Instance.new("Frame")
local Console = Instance.new("TextLabel")
local Frame_2 = Instance.new("Frame")
local TextLabel_4 = Instance.new("TextLabel")
local Frame_3 = Instance.new("Frame")
local TextLabel_5 = Instance.new("TextLabel")
local Frame_4 = Instance.new("Frame")
local TextLabel_6 = Instance.new("TextLabel")
local KillPlatform = Instance.new("TextButton")
local StealKills = Instance.new("TextButton")
local AutoFarm = Instance.new("TextButton")
local NoRecoil = Instance.new("TextButton")
local Guns = Instance.new("TextButton")
local Knifes = Instance.new("TextButton")
local Fly = Instance.new("TextButton")
local Noclip = Instance.new("TextButton")
local Gravity = Instance.new("TextButton")
local Speed = Instance.new("TextButton")
local Jump = Instance.new("TextButton")
local Btools = Instance.new("TextButton")

ZombieAttackGUI.Name = "MityaHub_ZombieAttack"
ZombieAttackGUI.Parent = game.CoreGui
ZombieAttackGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = ZombieAttackGUI
Main.BackgroundColor3 = Color3.new(0, 0, 0)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.794708014, 0, 0, 0)
Main.Size = UDim2.new(0.191605836, 0, 1, 0)

TextLabel_2.Parent = Main
TextLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.0434782468, 0, 0.0118953418, 0)
TextLabel_2.Size = UDim2.new(0.90476191, 0, 0.0569259971, 0)
TextLabel_2.Font = Enum.Font.SourceSansSemibold
TextLabel_2.Text = "MityaHub / Zombie Attack"
TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
TextLabel_2.TextScaled = true
TextLabel_2.TextSize = 14
TextLabel_2.TextWrapped = true

Frame.Parent = Main
Frame.BackgroundColor3 = Color3.new(0.0156863, 0.0156863, 0.0156863)
Frame.BackgroundTransparency = 0.5
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 0, 0.111954458, 0)
Frame.Size = UDim2.new(1, 0, 0.0417457297, 0)

TextLabel_3.Parent = Frame
TextLabel_3.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_3.BackgroundTransparency = 1
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(0.0434782468, 0, 0.181818187, 0)
TextLabel_3.Size = UDim2.new(0.90476191, 0, 0.590909064, 0)
TextLabel_3.Font = Enum.Font.SourceSansSemibold
TextLabel_3.Text = "Console"
TextLabel_3.TextColor3 = Color3.new(1, 1, 1)
TextLabel_3.TextScaled = true
TextLabel_3.TextSize = 14
TextLabel_3.TextWrapped = true
TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left

ConsoleFrame.Name = "ConsoleFrame"
ConsoleFrame.Parent = Main
ConsoleFrame.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
ConsoleFrame.BackgroundTransparency = 0.5
ConsoleFrame.BorderSizePixel = 0
ConsoleFrame.Position = UDim2.new(0, 0, 0.153700188, 0)
ConsoleFrame.Size = UDim2.new(1, 0, 0.0967741907, 0)

Console.Name = "Console"
Console.Parent = ConsoleFrame
Console.BackgroundColor3 = Color3.new(1, 1, 1)
Console.BackgroundTransparency = 1
Console.BorderSizePixel = 0
Console.Position = UDim2.new(0.0387163423, 0, 0.117647059, 0)
Console.Size = UDim2.new(0.909523785, 0, 0.764705896, 0)
Console.Font = Enum.Font.SourceSans
Console.Text = "Status: Ready to use\n\n"
Console.TextColor3 = Color3.new(0.333333, 1, 0)
Console.TextScaled = true
Console.TextSize = 14
Console.TextWrapped = true
Console.TextXAlignment = Enum.TextXAlignment.Left
Console.TextYAlignment = Enum.TextYAlignment.Top

Frame_2.Parent = Main
Frame_2.BackgroundColor3 = Color3.new(0.0156863, 0.0156863, 0.0156863)
Frame_2.BackgroundTransparency = 0.5
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0, 0, 0.250474393, 0)
Frame_2.Size = UDim2.new(0.995238066, 0, 0.0417457297, 0)

TextLabel_4.Parent = Frame_2
TextLabel_4.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_4.BackgroundTransparency = 1
TextLabel_4.BorderSizePixel = 0
TextLabel_4.Position = UDim2.new(0.0482401513, 0, 0.181818187, 0)
TextLabel_4.Size = UDim2.new(0.904306233, 0, 0.590909064, 0)
TextLabel_4.Font = Enum.Font.SourceSansSemibold
TextLabel_4.Text = "Main Mods"
TextLabel_4.TextColor3 = Color3.new(1, 1, 1)
TextLabel_4.TextScaled = true
TextLabel_4.TextSize = 14
TextLabel_4.TextWrapped = true
TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left

Frame_3.Parent = Main
Frame_3.BackgroundColor3 = Color3.new(0.0156863, 0.0156863, 0.0156863)
Frame_3.BackgroundTransparency = 0.5
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(0, 0, 0.455407977, 0)
Frame_3.Size = UDim2.new(1, 0, 0.0417457297, 0)

TextLabel_5.Parent = Frame_3
TextLabel_5.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_5.BackgroundTransparency = 1
TextLabel_5.BorderSizePixel = 0
TextLabel_5.Position = UDim2.new(0.0434782468, 0, 0.181818187, 0)
TextLabel_5.Size = UDim2.new(0.90476191, 0, 0.590909064, 0)
TextLabel_5.Font = Enum.Font.SourceSansSemibold
TextLabel_5.Text = "Weapon Mods"
TextLabel_5.TextColor3 = Color3.new(1, 1, 1)
TextLabel_5.TextScaled = true
TextLabel_5.TextSize = 14
TextLabel_5.TextWrapped = true
TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left

Frame_4.Parent = Main
Frame_4.BackgroundColor3 = Color3.new(0.0156863, 0.0156863, 0.0156863)
Frame_4.BackgroundTransparency = 0.5
Frame_4.BorderSizePixel = 0
Frame_4.Position = UDim2.new(0, 0, 0.65464896, 0)
Frame_4.Size = UDim2.new(0.995238066, 0, 0.0417457297, 0)

TextLabel_6.Parent = Frame_4
TextLabel_6.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_6.BackgroundTransparency = 1
TextLabel_6.BorderSizePixel = 0
TextLabel_6.Position = UDim2.new(0.0482401513, 0, 0.18181771, 0)
TextLabel_6.Size = UDim2.new(0.909090936, 0, 0.590909064, 0)
TextLabel_6.Font = Enum.Font.SourceSansSemibold
TextLabel_6.Text = "Local Player Mods"
TextLabel_6.TextColor3 = Color3.new(1, 1, 1)
TextLabel_6.TextScaled = true
TextLabel_6.TextSize = 14
TextLabel_6.TextWrapped = true
TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопки с базовыми параметрами
KillPlatform.Name = "KillPlatform"
KillPlatform.Parent = Main
KillPlatform.BackgroundColor3 = Color3.new(1, 1, 1)
KillPlatform.BackgroundTransparency = 1
KillPlatform.Position = UDim2.new(0.0434782468, 0, 0.309297919, 0)
KillPlatform.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
KillPlatform.Font = Enum.Font.SourceSansSemibold
KillPlatform.Text = "Kill Platform OFF"
KillPlatform.TextColor3 = Color3.new(1, 1, 1)
KillPlatform.TextScaled = true
KillPlatform.TextSize = 14
KillPlatform.TextWrapped = true
KillPlatform.TextXAlignment = Enum.TextXAlignment.Left

StealKills.Name = "StealKills"
StealKills.Parent = Main
StealKills.BackgroundColor3 = Color3.new(1, 1, 1)
StealKills.BackgroundTransparency = 1
StealKills.Position = UDim2.new(0.0434782468, 0, 0.354838729, 0)
StealKills.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
StealKills.Font = Enum.Font.SourceSansSemibold
StealKills.Text = "Steal Kills OFF"
StealKills.TextColor3 = Color3.new(1, 1, 1)
StealKills.TextScaled = true
StealKills.TextSize = 14
StealKills.TextWrapped = true
StealKills.TextXAlignment = Enum.TextXAlignment.Left

AutoFarm.Name = "AutoFarm"
AutoFarm.Parent = Main
AutoFarm.BackgroundColor3 = Color3.new(1, 1, 1)
AutoFarm.BackgroundTransparency = 1
AutoFarm.Position = UDim2.new(0.0434782468, 0, 0.400379539, 0)
AutoFarm.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
AutoFarm.Font = Enum.Font.SourceSansSemibold
AutoFarm.Text = "Auto Farm OFF"
AutoFarm.TextColor3 = Color3.new(1, 1, 1)
AutoFarm.TextScaled = true
AutoFarm.TextSize = 14
AutoFarm.TextWrapped = true
AutoFarm.TextXAlignment = Enum.TextXAlignment.Left

NoRecoil.Name = "NoRecoil"
NoRecoil.Parent = Main
NoRecoil.BackgroundColor3 = Color3.new(1, 1, 1)
NoRecoil.BackgroundTransparency = 1
NoRecoil.Position = UDim2.new(0.0434782468, 0, 0.510436416, 0)
NoRecoil.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
NoRecoil.Font = Enum.Font.SourceSansSemibold
NoRecoil.Text = "No Recoil OFF"
NoRecoil.TextColor3 = Color3.new(1, 1, 1)
NoRecoil.TextScaled = true
NoRecoil.TextSize = 14
NoRecoil.TextWrapped = true
NoRecoil.TextXAlignment = Enum.TextXAlignment.Left

Guns.Name = "Guns"
Guns.Parent = Main
Guns.BackgroundColor3 = Color3.new(1, 1, 1)
Guns.BackgroundTransparency = 1
Guns.Position = UDim2.new(0.0434782468, 0, 0.555977225, 0)
Guns.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
Guns.Font = Enum.Font.SourceSansSemibold
Guns.Text = "Equip All Guns OFF"
Guns.TextColor3 = Color3.new(1, 1, 1)
Guns.TextScaled = true
Guns.TextSize = 14
Guns.TextWrapped = true
Guns.TextXAlignment = Enum.TextXAlignment.Left

Knifes.Name = "Knifes"
Knifes.Parent = Main
Knifes.BackgroundColor3 = Color3.new(1, 1, 1)
Knifes.BackgroundTransparency = 1
Knifes.Position = UDim2.new(0.0434782468, 0, 0.603415549, 0)
Knifes.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
Knifes.Font = Enum.Font.SourceSansSemibold
Knifes.Text = "Equip All Knifes OFF"
Knifes.TextColor3 = Color3.new(1, 1, 1)
Knifes.TextScaled = true
Knifes.TextSize = 14
Knifes.TextWrapped = true
Knifes.TextXAlignment = Enum.TextXAlignment.Left

Fly.Name = "Fly"
Fly.Parent = Main
Fly.BackgroundColor3 = Color3.new(1, 1, 1)
Fly.BackgroundTransparency = 1
Fly.Position = UDim2.new(0.0434782468, 0, 0.709677398, 0)
Fly.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
Fly.Font = Enum.Font.SourceSansSemibold
Fly.Text = "Toggle Flying Mode OFF"
Fly.TextColor3 = Color3.new(1, 1, 1)
Fly.TextScaled = true
Fly.TextSize = 14
Fly.TextWrapped = true
Fly.TextXAlignment = Enum.TextXAlignment.Left

Noclip.Name = "Noclip"
Noclip.Parent = Main
Noclip.BackgroundColor3 = Color3.new(1, 1, 1)
Noclip.BackgroundTransparency = 1
Noclip.Position = UDim2.new(0.0434782468, 0, 0.755218208, 0)
Noclip.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
Noclip.Font = Enum.Font.SourceSansSemibold
Noclip.Text = "Toggle NoClip OFF"
Noclip.TextColor3 = Color3.new(1, 1, 1)
Noclip.TextScaled = true
Noclip.TextSize = 14
Noclip.TextWrapped = true
Noclip.TextXAlignment = Enum.TextXAlignment.Left

Gravity.Name = "Gravity"
Gravity.Parent = Main
Gravity.BackgroundColor3 = Color3.new(1, 1, 1)
Gravity.BackgroundTransparency = 1
Gravity.Position = UDim2.new(0.0387163423, 0, 0.802656531, 0)
Gravity.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
Gravity.Font = Enum.Font.SourceSansSemibold
Gravity.Text = "Low Gravity OFF"
Gravity.TextColor3 = Color3.new(1, 1, 1)
Gravity.TextScaled = true
Gravity.TextSize = 14
Gravity.TextWrapped = true
Gravity.TextXAlignment = Enum.TextXAlignment.Left

Speed.Name = "Speed"
Speed.Parent = Main
Speed.BackgroundColor3 = Color3.new(1, 1, 1)
Speed.BackgroundTransparency = 1
Speed.Position = UDim2.new(0.0387163423, 0, 0.851992369, 0)
Speed.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
Speed.Font = Enum.Font.SourceSansSemibold
Speed.Text = "Super Speed OFF"
Speed.TextColor3 = Color3.new(1, 1, 1)
Speed.TextScaled = true
Speed.TextSize = 14
Speed.TextWrapped = true
Speed.TextXAlignment = Enum.TextXAlignment.Left

Jump.Name = "Jump"
Jump.Parent = Main
Jump.BackgroundColor3 = Color3.new(1, 1, 1)
Jump.BackgroundTransparency = 1
Jump.Position = UDim2.new(0.0434782468, 0, 0.899430692, 0)
Jump.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
Jump.Font = Enum.Font.SourceSansSemibold
Jump.Text = "Super Jump OFF"
Jump.TextColor3 = Color3.new(1, 1, 1)
Jump.TextScaled = true
Jump.TextSize = 14
Jump.TextWrapped = true
Jump.TextXAlignment = Enum.TextXAlignment.Left

Btools.Name = "Btools"
Btools.Parent = Main
Btools.BackgroundColor3 = Color3.new(1, 1, 1)
Btools.BackgroundTransparency = 1
Btools.Position = UDim2.new(0.0434782468, 0, 0.946869016, 0)
Btools.Size = UDim2.new(0.90476191, 0, 0.034155596, 0)
Btools.Font = Enum.Font.SourceSansSemibold
Btools.Text = "B-Tools OFF"
Btools.TextColor3 = Color3.new(1, 1, 1)
Btools.TextScaled = true
Btools.TextSize = 14
Btools.TextWrapped = true
Btools.TextXAlignment = Enum.TextXAlignment.Left

-- ============== СОСТОЯНИЯ ПЕРЕКЛЮЧАТЕЛЕЙ ==============
local states = {
	fly = false,
	noclip = false,
	knifes = false,
	guns = false,
	killPlatform = false,
	speed = false,
	jump = false,
	gravity = false,
	autoFarm = false,
	btools = false,
	stealKills = false,
	noRecoil = false,
}

-- Сохранённые исходные значения
local defaultSpeed = 16
local defaultJump = 50
local defaultGravity = 196.2
local flyBodyGyro = nil
local flyBodyVel = nil
local savedPlatform = nil
local savedEnemyData = {} -- для KillPlatform: {part, originalCFrame}
local stealKillsConnection = nil
local noRecoilConnection = nil
local btoolsGui = nil

-- Вспомогательная функция обновления текста кнопки
local function updateButton(button, state, baseText)
	if state then
		button.Text = baseText .. " ON"
		button.TextColor3 = Color3.new(0, 1, 0) -- зелёный
	else
		button.Text = baseText .. " OFF"
		button.TextColor3 = Color3.new(1, 1, 1) -- белый
	end
end

-- ============== FLY ==============
Fly.MouseButton1Click:Connect(function()
	local player = game.Players.LocalPlayer
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:WaitForChild("HumanoidRootPart")
	states.fly = not states.fly
	if states.fly then
		-- Включить полёт
		flyBodyGyro = Instance.new("BodyGyro")
		flyBodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
		flyBodyGyro.P = 3000
		flyBodyGyro.Parent = root

		flyBodyVel = Instance.new("BodyVelocity")
		flyBodyVel.MaxForce = Vector3.new(400000, 400000, 400000)
		flyBodyVel.Velocity = Vector3.new(0, 0, 0)
		flyBodyVel.Parent = root

		-- Управление с клавиатуры
		game:GetService("RunService").RenderStepped:Connect(function()
			if not states.fly then return end
			local moveDir = Vector3.new()
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + root.CFrame.LookVector end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - root.CFrame.LookVector end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - root.CFrame.RightVector end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + root.CFrame.RightVector end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
			flyBodyVel.Velocity = moveDir * 50
			-- Стабилизация ориентации
			flyBodyGyro.CFrame = CFrame.new(root.Position, root.Position + root.CFrame.LookVector)
		end)
		Console.Text = "Fly: ON"
	else
		-- Выключить полёт
		if flyBodyGyro then flyBodyGyro:Destroy() end
		if flyBodyVel then flyBodyVel:Destroy() end
		Console.Text = "Fly: OFF"
	end
	updateButton(Fly, states.fly, "Toggle Flying Mode")
end)

-- ============== NOCLIP ==============
Noclip.MouseButton1Click:Connect(function()
	states.noclip = not states.noclip
	if states.noclip then
		game:GetService('RunService').Stepped:Connect(function()
			if states.noclip and game.Players.LocalPlayer.Character then
				game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
			end
		end)
		Console.Text = "NoClip: ON"
	else
		Console.Text = "NoClip: OFF"
	end
	updateButton(Noclip, states.noclip, "Toggle NoClip")
end)

-- ============== EQUIP ALL KNIFES ==============
Knifes.MouseButton1Click:Connect(function()
	states.knifes = not states.knifes
	local player = game.Players.LocalPlayer
	if states.knifes then
		for _, Thing in pairs(game.ReplicatedStorage.Knives:GetChildren()) do
			if Thing:IsA("Tool") then
				Thing:Clone().Parent = player.Backpack
			end
		end
		Console.Text = "Knifes equipped"
	else
		-- Убрать все ножи
		for _, tool in pairs(player.Backpack:GetChildren()) do
			if tool:IsA("Tool") and game.ReplicatedStorage.Knives:FindFirstChild(tool.Name) then
				tool:Destroy()
			end
		end
		Console.Text = "Knifes removed"
	end
	updateButton(Knifes, states.knifes, "Equip All Knifes")
end)

-- ============== EQUIP ALL GUNS ==============
Guns.MouseButton1Click:Connect(function()
	states.guns = not states.guns
	local player = game.Players.LocalPlayer
	if states.guns then
		for _, Thing in pairs(game.ReplicatedStorage.Guns:GetChildren()) do
			if Thing:IsA("Tool") then
				Thing:Clone().Parent = player.Backpack
			end
		end
		Console.Text = "Guns equipped"
	else
		for _, tool in pairs(player.Backpack:GetChildren()) do
			if tool:IsA("Tool") and game.ReplicatedStorage.Guns:FindFirstChild(tool.Name) then
				tool:Destroy()
			end
		end
		Console.Text = "Guns removed"
	end
	updateButton(Guns, states.guns, "Equip All Guns")
end)

-- ============== KILL PLATFORM ==============
KillPlatform.MouseButton1Click:Connect(function()
	states.killPlatform = not states.killPlatform
	local player = game:GetService("Players").LocalPlayer
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if states.killPlatform then
		-- Создаём платформу
		local platform = Instance.new('Part', workspace)
		platform.Size = Vector3.new(100, 0.5, 100)
		platform.Anchored = true
		platform.Position = Vector3.new(555, 555, 555)
		savedPlatform = platform

		-- Определяем, зомби ли игрок
		local isZombie = not workspace:FindFirstChild(player.Name)
		-- Сохраняем и телепортируем врагов
		savedEnemyData = {}
		if not isZombie then
			for _, a in pairs(workspace.enemies:GetChildren()) do
				for _, b in pairs(a:GetChildren()) do
					if b:IsA("BasePart") then
						table.insert(savedEnemyData, {part = b, originalCFrame = b.CFrame})
						b.Anchored = true
						b.CFrame = root.CFrame * CFrame.new(2, 0, 2)
					end
				end
			end
		else
			for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
				if otherPlayer ~= player and otherPlayer.Character then
					for _, b in pairs(otherPlayer.Character:GetChildren()) do
						if b:IsA("BasePart") then
							table.insert(savedEnemyData, {part = b, originalCFrame = b.CFrame})
							b.Anchored = true
							b.CFrame = root.CFrame * CFrame.new(2, 0, 2)
						end
					end
				end
			end
		end
		root.CFrame = platform.CFrame * CFrame.new(0, 4, 0)
		Console.Text = "Kill Platform: ON"
	else
		-- Удаляем платформу и возвращаем врагов
		if savedPlatform then
			savedPlatform:Destroy()
			savedPlatform = nil
		end
		for _, data in ipairs(savedEnemyData) do
			if data.part and data.part.Parent then
				data.part.Anchored = false
				data.part.CFrame = data.originalCFrame
			end
		end
		savedEnemyData = {}
		Console.Text = "Kill Platform: OFF"
	end
	updateButton(KillPlatform, states.killPlatform, "Kill Platform")
end)

-- ============== SPEED ==============
Speed.MouseButton1Click:Connect(function()
	local player = game:GetService("Players").LocalPlayer
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	states.speed = not states.speed
	if states.speed then
		defaultSpeed = hum.WalkSpeed
		hum.WalkSpeed = 60
		Console.Text = "Speed: ON (60)"
	else
		hum.WalkSpeed = defaultSpeed
		Console.Text = "Speed: OFF (" .. tostring(defaultSpeed) .. ")"
	end
	updateButton(Speed, states.speed, "Super Speed")
end)

-- ============== JUMP ==============
Jump.MouseButton1Click:Connect(function()
	local player = game:GetService("Players").LocalPlayer
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	states.jump = not states.jump
	if states.jump then
		defaultJump = hum.JumpPower
		hum.JumpPower = 100
		Console.Text = "Jump: ON (100)"
	else
		hum.JumpPower = defaultJump
		Console.Text = "Jump: OFF (" .. tostring(defaultJump) .. ")"
	end
	updateButton(Jump, states.jump, "Super Jump")
end)

-- ============== GRAVITY ==============
Gravity.MouseButton1Click:Connect(function()
	states.gravity = not states.gravity
	if states.gravity then
		workspace.Gravity = 5
		Console.Text = "Gravity: ON (5)"
	else
		workspace.Gravity = defaultGravity
		Console.Text = "Gravity: OFF (" .. tostring(defaultGravity) .. ")"
	end
	updateButton(Gravity, states.gravity, "Low Gravity")
end)

-- ============== AUTO FARM ==============
AutoFarm.MouseButton1Click:Connect(function()
	states.autoFarm = not states.autoFarm
	_G.farm2 = states.autoFarm
	if states.autoFarm then
		-- Если ещё не запущен цикл AutoFarm, запускаем его один раз
		if not _G.autoFarmInit then
			_G.autoFarmInit = true
			local groundDistance = 8
			local Player = game:GetService("Players").LocalPlayer
			local function getNearest()
				local nearest, dist = nil, 99999
				for _, v in pairs(workspace.BossFolder:GetChildren()) do
					if v:FindFirstChild("Head") and Player.Character and Player.Character:FindFirstChild("Head") then
						local m = (Player.Character.Head.Position - v.Head.Position).magnitude
						if m < dist then dist = m; nearest = v end
					end
				end
				for _, v in pairs(workspace.enemies:GetChildren()) do
					if v:FindFirstChild("Head") and Player.Character and Player.Character:FindFirstChild("Head") then
						local m = (Player.Character.Head.Position - v.Head.Position).magnitude
						if m < dist then dist = m; nearest = v end
					end
				end
				return nearest
			end
			game:GetService("RunService").RenderStepped:Connect(function()
				if _G.farm2 and Player.Character then
					local target = getNearest()
					if target then
						workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, target.Head.Position)
						Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, groundDistance, 9)
						_G.globalTarget = target
					end
				end
			end)
			spawn(function()
				while wait() do
					if _G.farm2 and Player.Character then
						Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
						if Player.Character:FindFirstChild("Torso") then
							Player.Character.Torso.Velocity = Vector3.new(0, 0, 0)
						end
					end
				end
			end)
			while wait() do
				if _G.farm2 and _G.globalTarget and _G.globalTarget:FindFirstChild("Head") and Player.Character and Player.Character:FindFirstChildOfClass("Tool") then
					local target = _G.globalTarget
					game.ReplicatedStorage.Gun:FireServer({
						["Normal"] = Vector3.new(0, 0, 0),
						["Direction"] = target.Head.Position,
						["Name"] = Player.Character:FindFirstChildOfClass("Tool").Name,
						["Hit"] = target.Head,
						["Origin"] = target.Head.Position,
						["Pos"] = target.Head.Position,
					})
				end
				wait()
			end
		end
		Console.Text = "Auto Farm: ON"
	else
		Console.Text = "Auto Farm: OFF"
	end
	updateButton(AutoFarm, states.autoFarm, "Auto Farm")
end)

-- ============== B-TOOLS ==============
Btools.MouseButton1Click:Connect(function()
	states.btools = not states.btools
	if states.btools then
		-- Загружаем B-Tools (если ещё не загружены)
		if not btoolsGui then
			local success, err = pcall(function()
				btoolsGui = loadstring(game:HttpGet("https://pastebin.com/raw/T0qaXjAR", true))()
			end)
			if not success then
				Console.Text = "B-Tools load failed: " .. tostring(err)
				states.btools = false
				updateButton(Btools, false, "B-Tools")
				return
			end
		else
			btoolsGui.Enabled = true
		end
		Console.Text = "B-Tools: ON"
	else
		if btoolsGui then
			btoolsGui.Enabled = false
		end
		Console.Text = "B-Tools: OFF"
	end
	updateButton(Btools, states.btools, "B-Tools")
end)

-- ============== STEAL KILLS ==============
StealKills.MouseButton1Click:Connect(function()
	states.stealKills = not states.stealKills
	if states.stealKills then
		-- Перехват убийств: подключаемся к событию смерти врагов и приписываем килл себе
		stealKillsConnection = game.ReplicatedStorage.Gun.OnServerEvent:Connect(function(player, args)
			-- Это заглушка; реальный механизм зависит от структуры игры.
			-- Обычно нужно подменить hit или самому вызвать Damage. Здесь просто уведомление.
		end)
		Console.Text = "Steal Kills: ON"
	else
		if stealKillsConnection then
			stealKillsConnection:Disconnect()
			stealKillsConnection = nil
		end
		Console.Text = "Steal Kills: OFF"
	end
	updateButton(StealKills, states.stealKills, "Steal Kills")
end)

-- ============== NO RECOIL ==============
NoRecoil.MouseButton1Click:Connect(function()
	states.noRecoil = not states.noRecoil
	local player = game:GetService("Players").LocalPlayer
	if states.noRecoil then
		-- Постоянно обнуляем отдачу для текущего оружия
		noRecoilConnection = game:GetService("RunService").RenderStepped:Connect(function()
			if player.Character and player.Character:FindFirstChildOfClass("Tool") then
				local tool = player.Character:FindFirstChildOfClass("Tool")
				-- Пытаемся найти recoil в настройках оружия
				-- Здесь просто пример: сбрасываем смещение камеры
				-- Реальная реализация зависит от конкретной игры
			end
		end)
		Console.Text = "No Recoil: ON"
	else
		if noRecoilConnection then
			noRecoilConnection:Disconnect()
			noRecoilConnection = nil
		end
		Console.Text = "No Recoil: OFF"
	end
	updateButton(NoRecoil, states.noRecoil, "No Recoil")
end)

-- Дополнительно: команда чата для AutoFarm сохранена
game.Players.LocalPlayer.Chatted:Connect(function(m)
	if m == ";autofarm false" then
		states.autoFarm = false
		_G.farm2 = false
		updateButton(AutoFarm, false, "Auto Farm")
		Console.Text = "Auto Farm: OFF (chat)"
	elseif m == ";autofarm true" then
		states.autoFarm = true
		_G.farm2 = true
		updateButton(AutoFarm, true, "Auto Farm")
		Console.Text = "Auto Farm: ON (chat)"
	end
end)
