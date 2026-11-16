local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2WindStyleHub"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Плавающая кнопка-молния (перетаскиваемая)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 48, 0, 48)
toggleBtn.Position = UDim2.new(0.04, 0, 0.18, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
toggleBtn.TextColor3 = Color3.fromRGB(230, 40, 40)
toggleBtn.Text = "⚡"
toggleBtn.TextSize = 20
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = screenGui

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.5, 0)
local tStroke = Instance.new("UIStroke", toggleBtn)
tStroke.Color = Color3.fromRGB(45, 45, 55)
tStroke.Thickness = 1.5

-- Перетаскивание кнопки
local dragging, dragInput, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = toggleBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

toggleBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Главное окно в стиле WindUI (темный минимализм)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 340)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
mainFrame.Visible = false
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0.03, 0)
local fStroke = Instance.new("UIStroke", mainFrame)
fStroke.Color = Color3.fromRGB(35, 35, 45)
fStroke.Thickness = 1.5

local clickCheck = true
toggleBtn.InputBegan:Connect(function() clickCheck = true end)
toggleBtn.InputChanged:Connect(function() clickCheck = false end)
toggleBtn.Activated:Connect(function()
	if clickCheck then mainFrame.Visible = not mainFrame.Visible end
end)

-- Верхняя панель (Заголовок + Кнопка закрытия)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.Text = "MM2 Hub  •  Wind UI Style"
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
closeBtn.Text = "✕"
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

closeBtn.Activated:Connect(function() mainFrame.Visible = false end)

-- ЛЕВАЯ БОКОВАЯ ПАНЕЛЬ (Вкладки)
local sidebar = Instance.new("ScrollingFrame")
sidebar.Size = UDim2.new(0, 145, 1, -45)
sidebar.Position = UDim2.new(0, 0, 0, 42)
sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
sidebar.BorderSizePixel = 0
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.ScrollBarThickness = 2
sidebar.Parent = mainFrame

local sideLayout = Instance.new("UIListLayout", sidebar)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding = UDim.new(0, 4)

local sidePadding = Instance.new("UIPadding", sidebar)
sidePadding.PaddingTop = UDim.new(0, 8)
sidePadding.PaddingLeft = UDim.new(0, 8)
sidePadding.PaddingRight = UDim.new(0, 8)

-- ПРАВАЯ ОБЛАСТЬ КОНТЕНТА
local containerArea = Instance.new("Frame")
containerArea.Size = UDim2.new(1, -150, 1, -45)
containerArea.Position = UDim2.new(0, 150, 0, 42)
containerArea.BackgroundTransparency = 1
containerArea.Parent = mainFrame

local tabs = {}
local tabButtons = {}

local function createTab(name)
	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.BorderSizePixel = 0
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 350)
	tabContent.ScrollBarThickness = 3
	tabContent.Visible = false
	tabContent.Parent = containerArea
	
	local layout = Instance.new("UIListLayout", tabContent)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	
	local pad = Instance.new("UIPadding", tabContent)
	pad.PaddingTop = UDim.new(0, 5)
	pad.PaddingLeft = UDim.new(0, 10)
	pad.PaddingRight = UDim.new(0, 10)
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	btn.TextColor3 = Color3.fromRGB(150, 150, 170)
	btn.Text = "  " .. name
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamMedium
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = sidebar
	
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0.2, 0)
	
	table.insert(tabs, tabContent)
	table.insert(tabButtons, {Button = btn, Content = tabContent})
	
	btn.Activated:Connect(function()
		for _, t in ipairs(tabs) do t.Visible = false end
		for _, b in ipairs(tabButtons) do 
			b.Button.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
			b.Button.TextColor3 = Color3.fromRGB(150, 150, 170)
		end
		tabContent.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
	
	return tabContent
end

-- Создаем вкладки
local tabCombat = createTab("Боевые")
local tabMurder = createTab("Убийца")
local tabVisuals = createTab("Визуал (ESP)")
local tabMovement = createTab("Игрок")
local tabRoles = createTab("Инфо Ролей")

tabs[1].Visible = true
tabButtons[1].Button.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
tabButtons[1].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Функция создания переключателей в стиле минимализма
local function addToggle(parentTab, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 325, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
	btn.TextColor3 = Color3.fromRGB(190, 190, 205)
	btn.Text = "   " .. text .. " [OFF]"
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamMedium
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = parentTab
	
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0.2, 0)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(35, 35, 48)
	stroke.Thickness = 1
	
	local state = false
	btn.Activated:Connect(function()
		state = not state
		if state then
			btn.Text = "   " .. text .. " [ON]"
			btn.BackgroundColor3 = Color3.fromRGB(45, 18, 22)
			btn.TextColor3 = Color3.fromRGB(255, 80, 80)
			stroke.Color = Color3.fromRGB(220, 40, 40)
		else
			btn.Text = "   " .. text .. " [OFF]"
			btn.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
			btn.TextColor3 = Color3.fromRGB(190, 190, 205)
			stroke.Color = Color3.fromRGB(35, 35, 48)
		end
		callback(state)
	end)
end

---------------------------------------------------------
-- ФУНКЦИОНАЛ ЛОГИКИ
---------------------------------------------------------

local function getPlayerRoleType(player)
	local char = player.Character
	if not char then return "Innocent" end
	local backpack = player:FindFirstChild("Backpack")
	
	for _, item in ipairs(char:GetChildren()) do
		if item:IsA("Tool") then
			local name = item.Name:lower()
			if name:find("knife") or name:find("dagger") then return "Murderer"
			elseif name:find("gun") or name:find("revolver") then return "Sheriff" end
		end
	end
	
	if backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") then
				local name = item.Name:lower()
				if name:find("knife") then return "Murderer"
				elseif name:find("gun") then return "Sheriff" end
			end
		end
	end
	return "Innocent"
end

-- 1. Боевые
local aimEnabled = false
addToggle(tabCombat, "AimLock (Общий)", function(state) aimEnabled = state end)

local sheriffAimEnabled = false
addToggle(tabCombat, "Sheriff Aim (Только в Убийцу)", function(state) sheriffAimEnabled = state end)

local function getClosestPlayer(onlyMurderer)
	local closestPlayer = nil
	local shortestDistance = math.huge
	local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			if not onlyMurderer or getPlayerRoleType(player) == "Murderer" then
				local head = player.Character.Head
				local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
				if onScreen then
					local distance = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
					if distance < shortestDistance then
						shortestDistance = distance
						closestPlayer = player
					end
				end
			end
		end
	end
	return closestPlayer
end

RunService.RenderStepped:Connect(function()
	if sheriffAimEnabled then
		local target = getClosestPlayer(true)
		if target and target.Character and target.Character:FindFirstChild("Head") then
			Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.3)
		end
	elseif aimEnabled then
		local target = getClosestPlayer(false)
		if target and target.Character and target.Character:FindFirstChild("Head") then
			Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.3)
		end
	end
end)

local autoGunEnabled = false
addToggle(tabCombat, "Auto Gun (С возвратом)", function(state) autoGunEnabled = state end)

task.spawn(function()
	while true do
		if autoGunEnabled then
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local hrp = char.HumanoidRootPart
				local originalPos = hrp.CFrame
				local foundGun, gunPart = false, nil
				for _, obj in ipairs(workspace:GetDescendants()) do
					local nameLower = obj.Name:lower()
					if nameLower:find("gundrop") or nameLower:find("gun_drop") or nameLower == "drop" then
						gunPart = obj:FindFirstChild("Handle") or obj:FindFirstChild("Part") or (obj:IsA("BasePart") and obj)
						if gunPart then foundGun = true break end
					elseif obj:IsA("Tool") and not obj.Parent:IsA("Backpack") and not obj.Parent:IsA("Model") then
						gunPart = obj:FindFirstChild("Handle")
						if gunPart then foundGun = true break end
					end
				end
				if foundGun and gunPart then
					hrp.CFrame = gunPart.CFrame
					task.wait(0.15)
					hrp.CFrame = originalPos
				end
			end
		end
		task.wait(0.3)
	end
end)

-- 2. Убийца
local knifeAuraEnabled = false
addToggle(tabMurder, "Knife Aura (Убить всех)", function(state) knifeAuraEnabled = state end)

task.spawn(function()
	while true do
		if knifeAuraEnabled then
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local hrp = char.HumanoidRootPart
				local knife = char:FindFirstChildOfClass("Tool")
				if knife and (knife.Name:lower():find("knife") or knife.Name:lower():find("dagger")) then
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							local targetHrp = p.Character.HumanoidRootPart
							local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
							if humanoid and humanoid.Health > 0 and (hrp.Position - targetHrp.Position).Magnitude < 18 then
								hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 2)
								knife:Activate()
							end
						end
					end
				end
			end
		end
		task.wait(0.1)
	end
end)

-- 3. Визуал (ESP)
local espEnabled = false
addToggle(tabVisuals, "ESP (Цвета ролей)", function(state)
	espEnabled = state
	if not state then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local hl = p.Character:FindFirstChild("MM2_RoleHighlight")
				if hl then hl:Destroy() end
			end
		end
	end
end)

task.spawn(function()
	while true do
		if espEnabled then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character then
					local char = p.Character
					local hl = char:FindFirstChild("MM2_RoleHighlight")
					if not hl then
						hl = Instance.new("Highlight")
						hl.Name = "MM2_RoleHighlight"
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						hl.FillTransparency = 0.4
						hl.Parent = char
					end
					local role = getPlayerRoleType(p)
					if role == "Murderer" then hl.FillColor = Color3.fromRGB(255, 40, 40) -- Красный
					elseif role == "Sheriff" then hl.FillColor = Color3.fromRGB(40, 140, 255) -- Синий
					else hl.FillColor = Color3.fromRGB(40, 220, 40) end -- Зеленый
				end
			end
		end
		task.wait(1)
	end
end)

-- 4. Игрок
local speedEnabled = false
addToggle(tabMovement, "Speed (Бег 32)", function(state) speedEnabled = state end)

RunService.RenderStepped:Connect(function()
	if speedEnabled then
		local char = LocalPlayer.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid").WalkSpeed = 32
		end
	end
end)

local flyEnabled = false
local flySpeed, bv, bg = 50, nil, nil
addToggle(tabMovement, "Fly (Полет камеры)", function(state)
	flyEnabled = state
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	if flyEnabled then
		bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bv.Velocity = Vector3.zero
		bg = Instance.new("BodyGyro", char.HumanoidRootPart)
		bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.CFrame = char.HumanoidRootPart.CFrame
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

RunService.RenderStepped:Connect(function()
	if flyEnabled then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") and bv and bg then
			bg.CFrame = Camera.CFrame
			local moveDir = Vector3.zero
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.MoveDirection.Magnitude > 0 then
				moveDir = Camera.CFrame.LookVector * humanoid.MoveDirection.Z * flySpeed + Camera.CFrame.RightVector * humanoid.MoveDirection.X * flySpeed
			end
			bv.Velocity = moveDir
		end
	end
end)

-- 5. Инфо ролей
local rolesScroll = Instance.new("ScrollingFrame")
rolesScroll.Size = UDim2.new(0, 325, 0, 250)
rolesScroll.BackgroundTransparency = 1
rolesScroll.BorderSizePixel = 0
rolesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
rolesScroll.ScrollBarThickness = 3
rolesScroll.Parent = tabRoles

local function getPlayerRoleInfo(player)
	local role = getPlayerRoleType(player)
	if role == "Murderer" then return "🔪 УБИЙЦА", Color3.fromRGB(255, 60, 60), Color3.fromRGB(40, 15, 18)
	elseif role == "Sheriff" then return "⭐ ШЕРИФ", Color3.fromRGB(60, 160, 255), Color3.fromRGB(15, 25, 45)
	else return "🛡️ Невиновен", Color3.fromRGB(140, 180, 140), Color3.fromRGB(18, 22, 24) end
end

task.spawn(function()
	while true do
		for _, child in ipairs(rolesScroll:GetChildren()) do
			if child:IsA("Frame") then child:Destroy() end
		end
		local yOffset = 2
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local roleText, roleColor, bgColor = getPlayerRoleInfo(player)
				local card = Instance.new("Frame")
				card.Size = UDim2.new(1, 0, 0, 26)
				card.Position = UDim2.new(0, 0, 0, yOffset)
				card.BackgroundColor3 = bgColor
				card.Parent = rolesScroll
				
				Instance.new("UICorner", card).CornerRadius = UDim.new(0.2, 0)
				local stroke = Instance.new("UIStroke", card)
				stroke.Color = roleColor
				stroke.Transparency = 0.5
				
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, -10, 1, 0)
				lbl.Position = UDim2.new(0, 8, 0, 0)
				lbl.BackgroundTransparency = 1
				lbl.TextColor3 = roleColor
				lbl.Text = player.Name .. "  ➔  " .. roleText
				lbl.TextSize = 10
				lbl.Font = Enum.Font.GothamBold
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.Parent = card
				
				yOffset = yOffset + 30
			end
		end
		rolesScroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)
		task.wait(1.5)
	end
end)
