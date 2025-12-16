local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local character, humanoid, hrp

local noclip = false
local fly = false
local flySpeed = 60
local walkSpeed = 16
local jumpPower = 50
local vertical = 0
local antiVoid = true

local lastSafeCFrame = CFrame.new(0,5,0)

local function onCharacterAdded(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid.WalkSpeed = walkSpeed
	humanoid.JumpPower = jumpPower
	lastSafeCFrame = hrp.CFrame
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

local function applyNoclip(state)
	if not character then return end
	for _, v in ipairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = not state
		end
	end
end

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)
local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
bg.P = 1e5
bg.D = 1e3

spawn(function()
	while true do
		wait(10)
		if hrp then
			lastSafeCFrame = hrp.CFrame
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if fly and hrp and humanoid then
		local move = humanoid.MoveDirection * flySpeed
		bv.Velocity = Vector3.new(move.X, vertical*flySpeed, move.Z)
		bg.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
		bv.Parent = hrp
		bg.Parent = hrp
	else
		bv.Parent = nil
		bg.Parent = nil
	end
	if noclip then
		applyNoclip(true)
	end
	if antiVoid and hrp and hrp.Position.Y < -50 then
		hrp.CFrame = lastSafeCFrame + Vector3.new(0,5,0)
		if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "RedXHub 1.0 Beta"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.5,0.72)
frame.Position = UDim2.fromScale(0.25,0.22)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local function label(text,size,pos)
	local l = Instance.new("TextLabel", frame)
	l.Size = size
	l.Position = pos
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextScaled = true
	l.Font = Enum.Font.GothamBold
	l.TextColor3 = Color3.fromRGB(255,50,50)
	l.ZIndex = 11
	return l
end

local function button(text,pos)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.85,0.08)
	b.Position = pos
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.BackgroundColor3 = Color3.fromRGB(45,0,0)
	b.ZIndex = 11
	local corner = Instance.new("UICorner",b)
	corner.CornerRadius = UDim.new(0,10)
	return b
end

local spacingY = 0.095
local curY = 0

label("RedXHub 1.0 Beta",UDim2.fromScale(1,0.08),UDim2.fromScale(0,curY))
curY = curY + spacingY

local noclipBtn = button("Noclip: OFF",UDim2.fromScale(0.075,curY))
curY = curY + spacingY

local flyBtn = button("Fly: OFF",UDim2.fromScale(0.075,curY))
curY = curY + spacingY

label("WalkSpeed (1-100)",UDim2.fromScale(1,0.08),UDim2.fromScale(0,curY))
curY = curY + spacingY
local walkBox = Instance.new("TextBox",frame)
walkBox.Size = UDim2.fromScale(0.4,0.08)
walkBox.Position = UDim2.fromScale(0.075,curY)
walkBox.Text = tostring(walkSpeed)
walkBox.TextScaled = true
walkBox.Font = Enum.Font.GothamBold
walkBox.BackgroundColor3 = Color3.fromRGB(60,0,0)
walkBox.TextColor3 = Color3.fromRGB(255,255,255)
walkBox.ClearTextOnFocus = false
walkBox.ZIndex = 11
Instance.new("UICorner", walkBox).CornerRadius = UDim.new(0,10)

local walkMinus = Instance.new("TextButton",frame)
walkMinus.Size = UDim2.fromScale(0.18,0.08)
walkMinus.Position = UDim2.fromScale(0.5,curY)
walkMinus.Text="-"
walkMinus.TextScaled=true
walkMinus.Font=Enum.Font.GothamBold
walkMinus.BackgroundColor3=Color3.fromRGB(80,0,0)
walkMinus.TextColor3=Color3.fromRGB(255,255,255)
walkMinus.ZIndex=11
Instance.new("UICorner",walkMinus).CornerRadius=UDim.new(0,10)

local walkPlus = Instance.new("TextButton",frame)
walkPlus.Size=UDim2.fromScale(0.18,0.08)
walkPlus.Position = UDim2.fromScale(0.71,curY)
walkPlus.Text="+"
walkPlus.TextScaled=true
walkPlus.Font=Enum.Font.GothamBold
walkPlus.BackgroundColor3=Color3.fromRGB(80,0,0)
walkPlus.TextColor3=Color3.fromRGB(255,255,255)
walkPlus.ZIndex=11
Instance.new("UICorner",walkPlus).CornerRadius=UDim.new(0,10)
curY = curY + spacingY

label("Jump Height (1-100)",UDim2.fromScale(1,0.08),UDim2.fromScale(0,curY))
curY = curY + spacingY
local jumpBox = Instance.new("TextBox",frame)
jumpBox.Size = UDim2.fromScale(0.4,0.08)
jumpBox.Position = UDim2.fromScale(0.075,curY)
jumpBox.Text=tostring(jumpPower)
jumpBox.TextScaled=true
jumpBox.Font=Enum.Font.GothamBold
jumpBox.BackgroundColor3 = Color3.fromRGB(60,0,0)
jumpBox.TextColor3=Color3.fromRGB(255,255,255)
jumpBox.ClearTextOnFocus=false
jumpBox.ZIndex=11
Instance.new("UICorner",jumpBox).CornerRadius=UDim.new(0,10)

local jumpMinus = Instance.new("TextButton",frame)
jumpMinus.Size=UDim2.fromScale(0.18,0.08)
jumpMinus.Position = UDim2.fromScale(0.5,curY)
jumpMinus.Text="-"
jumpMinus.TextScaled=true
jumpMinus.Font=Enum.Font.GothamBold
jumpMinus.BackgroundColor3=Color3.fromRGB(80,0,0)
jumpMinus.TextColor3=Color3.fromRGB(255,255,255)
jumpMinus.ZIndex=11
Instance.new("UICorner",jumpMinus).CornerRadius=UDim.new(0,10)

local jumpPlus = Instance.new("TextButton",frame)
jumpPlus.Size=UDim2.fromScale(0.18,0.08)
jumpPlus.Position = UDim2.fromScale(0.71,curY)
jumpPlus.Text="+"
jumpPlus.TextScaled=true
jumpPlus.Font=Enum.Font.GothamBold
jumpPlus.BackgroundColor3=Color3.fromRGB(80,0,0)
jumpPlus.TextColor3=Color3.fromRGB(255,255,255)
jumpPlus.ZIndex=11
Instance.new("UICorner",jumpPlus).CornerRadius=UDim.new(0,10)
curY = curY + spacingY

local teleportBtn = button("Click Teleport: OFF",UDim2.fromScale(0.075,curY))
local teleportActive = false
curY = curY + spacingY

local antiVoidBtn = button("Anti-Void: ON",UDim2.fromScale(0.075,curY))
curY = curY + spacingY

local upBtn = button("UP",UDim2.fromScale(0.075,curY))
curY = curY + spacingY
local downBtn = button("DOWN",UDim2.fromScale(0.075,curY))

local function clamp(v) return math.clamp(math.floor(tonumber(v) or 1),1,100) end

walkBox.FocusLost:Connect(function()
	walkSpeed = clamp(walkBox.Text)
	if humanoid then humanoid.WalkSpeed=walkSpeed end
	walkBox.Text=tostring(walkSpeed)
end)
walkPlus.MouseButton1Click:Connect(function() walkSpeed=clamp(walkSpeed+5) if humanoid then humanoid.WalkSpeed=walkSpeed end walkBox.Text=tostring(walkSpeed) end)
walkMinus.MouseButton1Click:Connect(function() walkSpeed=clamp(walkSpeed-5) if humanoid then humanoid.WalkSpeed=walkSpeed end walkBox.Text=tostring(walkSpeed) end)

jumpBox.FocusLost:Connect(function()
	jumpPower=clamp(jumpBox.Text)
	if humanoid then humanoid.JumpPower=jumpPower end
	jumpBox.Text=tostring(jumpPower)
end)
jumpPlus.MouseButton1Click:Connect(function() jumpPower=clamp(jumpPower+5) if humanoid then humanoid.JumpPower=jumpPower end jumpBox.Text=tostring(jumpPower) end)
jumpMinus.MouseButton1Click:Connect(function() jumpPower=clamp(jumpPower-5) if humanoid then humanoid.JumpPower=jumpPower end jumpBox.Text=tostring(jumpPower) end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	applyNoclip(noclip)
	noclipBtn.Text="Noclip: "..(noclip and "ON" or "OFF")
	noclipBtn.BackgroundColor3=noclip and Color3.fromRGB(180,20,20) or Color3.fromRGB(45,0,0)
end)

flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	if humanoid then humanoid:ChangeState(fly and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp) end
	vertical=0
	flyBtn.Text="Fly: "..(fly and "ON" or "OFF")
	flyBtn.BackgroundColor3=fly and Color3.fromRGB(180,20,20) or Color3.fromRGB(45,0,0)
end)

teleportBtn.MouseButton1Click:Connect(function()
	teleportActive = not teleportActive
	teleportBtn.Text = "Click Teleport: "..(teleportActive and "ON" or "OFF")
	teleportBtn.BackgroundColor3 = teleportActive and Color3.fromRGB(180,20,20) or Color3.fromRGB(45,0,0)
end)

antiVoidBtn.MouseButton1Click:Connect(function()
	antiVoid = not antiVoid
	antiVoidBtn.Text = "Anti-Void: "..(antiVoid and "ON" or "OFF")
	antiVoidBtn.BackgroundColor3 = antiVoid and Color3.fromRGB(180,20,20) or Color3.fromRGB(45,0,0)
end)

local teleportTouchTime = 0
UserInputService.InputBegan:Connect(function(input,gp)
	if teleportActive and input.UserInputType==Enum.UserInputType.Touch then
		teleportTouchTime = tick()
	end
end)
UserInputService.InputEnded:Connect(function(input,gp)
	if teleportActive and input.UserInputType==Enum.UserInputType.Touch then
		if tick() - teleportTouchTime >= 0.4 then
			local touchPos = input.Position
			local ray = Camera:ScreenPointToRay(touchPos.X,touchPos.Y)
			local targetPos = ray.Origin + ray.Direction*100
			if hrp then hrp.CFrame = CFrame.new(targetPos.X,targetPos.Y,targetPos.Z) end
		end
	end
end)

upBtn.MouseButton1Down:Connect(function() vertical=1 end)
upBtn.MouseButton1Up:Connect(function() vertical=0 end)
downBtn.MouseButton1Down:Connect(function() vertical=-1 end)
downBtn.MouseButton1Up:Connect(function() vertical=0 end)
