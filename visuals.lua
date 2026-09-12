-- visuals.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local S = _G.PromtMZ and _G.PromtMZ.S
if not S then
    warn("[PromtMZ] Сначала запусти main.lua!")
    return
end

-- ================= JUMP CIRCLES + LARGE CLICK PARTICLES =================
local CONFIG = {
    JumpCircles = true,
    CircleCount = 4,
    CircleSize = 3,
    CircleColor = Color3.fromRGB(224, 205, 178),

    ClickParticles = true,
    ParticleCount = 28,
    ParticleColor = Color3.fromRGB(224, 205, 178),
    ParticleSpeed = 28,
    ParticleLifetime = 0.7,
    ParticleSize = 0.32,
}

local function createJumpCircle(character)
    if not S.Particles then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for i = 1, CONFIG.CircleCount do
        local circle = Instance.new("Part")
        circle.Name = "JumpCircle"
        circle.Shape = Enum.PartType.Cylinder
        circle.Material = Enum.Material.Neon
        circle.Color = S.ParticleColor or CONFIG.CircleColor
        circle.Transparency = 0.15
        circle.Size = Vector3.new(0.08, CONFIG.CircleSize + i * 0.35, CONFIG.CircleSize + i * 0.35)
        circle.CFrame = root.CFrame * CFrame.new(0, -2.65, 0) * CFrame.Angles(0, 0, math.rad(90))
        circle.Anchored = true
        circle.CanCollide = false
        circle.CanQuery = false
        circle.CanTouch = false
        circle.Parent = workspace

        local targetSize = Vector3.new(0.03, CONFIG.CircleSize + i * 1.5, CONFIG.CircleSize + i * 1.5)
        local tween = TweenService:Create(circle, TweenInfo.new(0.45 + i * 0.06, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = targetSize,
            Transparency = 1
        })
        tween:Play()
        Debris:AddItem(circle, 0.8)
    end
end

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            createJumpCircle(character)
        end
    end)
end

if LP.Character then setupCharacter(LP.Character) end
LP.CharacterAdded:Connect(setupCharacter)

local function createClickBurst(position)
    if not S.Particles then return end
    local holder = Instance.new("Part")
    holder.Name = "ClickBurst"
    holder.Size = Vector3.new(0.1, 0.1, 0.1)
    holder.Transparency = 1
    holder.Anchored = true
    holder.CanCollide = false
    holder.CanQuery = false
    holder.CanTouch = false
    holder.Position = position
    holder.Parent = workspace

    local attachment = Instance.new("Attachment")
    attachment.Parent = holder

    local emitter = Instance.new("ParticleEmitter")
    emitter.Name = "LargeClickParticles"
    emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    emitter.Color = ColorSequence.new(S.ParticleColor or CONFIG.ParticleColor)
    emitter.LightEmission = 0.9
    emitter.LightInfluence = 0
    emitter.Lifetime = NumberRange.new(CONFIG.ParticleLifetime * 0.7, CONFIG.ParticleLifetime)
    emitter.Speed = NumberRange.new(CONFIG.ParticleSpeed * 0.7, CONFIG.ParticleSpeed)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.EmissionDirection = Enum.NormalId.Front
    emitter.Rate = 0
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, CONFIG.ParticleSize),
        NumberSequenceKeypoint.new(0.25, CONFIG.ParticleSize * 0.8),
        NumberSequenceKeypoint.new(0.65, CONFIG.ParticleSize * 0.45),
        NumberSequenceKeypoint.new(1, 0)
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.55, 0.15),
        NumberSequenceKeypoint.new(0.8, 0.55),
        NumberSequenceKeypoint.new(1, 1)
    })
    emitter.Rotation = NumberRange.new(0, 360)
    emitter.RotSpeed = NumberRange.new(-300, 300)
    emitter.Drag = 2
    emitter.Parent = attachment
    emitter:Emit(CONFIG.ParticleCount)
    Debris:AddItem(holder, CONFIG.ParticleLifetime + 0.5)
end

local mouse = LP:GetMouse()
mouse.Button1Down:Connect(function()
    if not S.Particles then return end
    local target = mouse.Target
    if not target then return end
    local model = target:FindFirstAncestorOfClass("Model")
    if not model then return end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")
    if humanoid and root then
        createClickBurst(root.Position)
    end
end)

-- ================= CHAMS =================
local function addGlossyHighlight(character)
    if not character then return end
    if not S.Chams then
        local old = character:FindFirstChild("GlossyHighlight")
        if old then old:Destroy() end
        return
    end

    local old = character:FindFirstChild("GlossyHighlight")
    if old then old:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Name = "GlossyHighlight"
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(235, 220, 195)
    highlight.FillTransparency = 0.18
    highlight.OutlineColor = Color3.fromRGB(255, 248, 230)
    highlight.OutlineTransparency = 0
    highlight.Enabled = true
    highlight.Parent = character
end

RunService.RenderStepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hl = p.Character:FindFirstChild("GlossyHighlight")
            if S.Chams and not hl then
                addGlossyHighlight(p.Character)
            elseif not S.Chams and hl then
                hl:Destroy()
            end
        end
    end
end)

local function setupPlayer(player)
    if player.Character then
        task.defer(function() addGlossyHighlight(player.Character) end)
    end
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid", 5)
        task.wait(0.1)
        addGlossyHighlight(character)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LP then setupPlayer(player) end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LP then setupPlayer(player) end
end)

-- ================= TARGET HUD =================
local TargetGui = Instance.new("ScreenGui")
TargetGui.Name = "PromtMZ_TargetHUD"
TargetGui.ResetOnSpawn = false
TargetGui.IgnoreGuiInset = true
pcall(function() TargetGui.Parent = game.CoreGui end)

local TH = {
    Width = 245,
    Height = 72,
    Position = UDim2.new(0.5, -330, 0.5, 45),
    Background = Color3.fromRGB(35, 29, 24),
    Card = Color3.fromRGB(49, 41, 34),
    Accent = Color3.fromRGB(224, 194, 155),
    Text = Color3.fromRGB(245, 235, 220),
    SubText = Color3.fromRGB(180, 165, 148),
    Health = Color3.fromRGB(116, 190, 120),
    CornerRadius = 12,
}

local TargetShadow = Instance.new("Frame")
TargetShadow.Size = UDim2.fromOffset(TH.Width + 6, TH.Height + 6)
TargetShadow.Position = TH.Position + UDim2.fromOffset(4, 5)
TargetShadow.BackgroundColor3 = Color3.fromRGB(15, 12, 10)
TargetShadow.BackgroundTransparency = 0.65
TargetShadow.BorderSizePixel = 0
TargetShadow.Visible = false
TargetShadow.Parent = TargetGui
Instance.new("UICorner", TargetShadow).CornerRadius = UDim.new(0, TH.CornerRadius + 2)

local TargetMain = Instance.new("Frame")
TargetMain.Size = UDim2.fromOffset(TH.Width, TH.Height)
TargetMain.Position = TH.Position + UDim2.fromOffset(-15, 0)
TargetMain.BackgroundColor3 = TH.Background
TargetMain.BackgroundTransparency = 0.04
TargetMain.BorderSizePixel = 0
TargetMain.Visible = false
TargetMain.Parent = TargetGui
Instance.new("UICorner", TargetMain).CornerRadius = UDim.new(0, TH.CornerRadius)

local TargetStroke = Instance.new("UIStroke")
TargetStroke.Color = TH.Accent
TargetStroke.Transparency = 0.7
TargetStroke.Thickness = 1
TargetStroke.Parent = TargetMain

-- Head
local HeadFrame = Instance.new("Frame")
HeadFrame.Size = UDim2.fromOffset(54, 54)
HeadFrame.Position = UDim2.fromOffset(9, 9)
HeadFrame.BackgroundColor3 = TH.Card
HeadFrame.BorderSizePixel = 0
HeadFrame.ClipsDescendants = true
HeadFrame.Parent = TargetMain
Instance.new("UICorner", HeadFrame).CornerRadius = UDim.new(0, 9)

local HeadStroke = Instance.new("UIStroke")
HeadStroke.Color = TH.Accent
HeadStroke.Transparency = 0.35
HeadStroke.Thickness = 1
HeadStroke.Parent = HeadFrame

local HeadImage = Instance.new("ImageLabel")
HeadImage.Size = UDim2.fromScale(1, 1)
HeadImage.BackgroundTransparency = 1
HeadImage.ScaleType = Enum.ScaleType.Crop
HeadImage.Parent = HeadFrame
Instance.new("UICorner", HeadImage).CornerRadius = UDim.new(0, 8)

-- Info
local Info = Instance.new("Frame")
Info.Size = UDim2.new(1, -76, 1, -12)
Info.Position = UDim2.fromOffset(72, 6)
Info.BackgroundTransparency = 1
Info.Parent = TargetMain

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(1, 0, 0, 25)
NameLabel.Position = UDim2.fromOffset(0, 2)
NameLabel.BackgroundTransparency = 1
NameLabel.Font = Enum.Font.GothamSemibold
NameLabel.TextSize = 15
NameLabel.TextColor3 = TH.Text
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
NameLabel.Parent = Info

local HPLabel = Instance.new("TextLabel")
HPLabel.Size = UDim2.new(1, 0, 0, 17)
HPLabel.Position = UDim2.fromOffset(0, 26)
HPLabel.BackgroundTransparency = 1
HPLabel.Font = Enum.Font.Gotham
HPLabel.TextSize = 11
HPLabel.TextColor3 = TH.SubText
HPLabel.TextXAlignment = Enum.TextXAlignment.Left
HPLabel.Parent = Info

local HealthBg = Instance.new("Frame")
HealthBg.Size = UDim2.new(1, -2, 0, 5)
HealthBg.Position = UDim2.new(0, 0, 1, -10)
HealthBg.BackgroundColor3 = Color3.fromRGB(70, 60, 51)
HealthBg.BorderSizePixel = 0
HealthBg.Parent = Info
Instance.new("UICorner", HealthBg).CornerRadius = UDim.new(1, 0)

local HealthBar = Instance.new("Frame")
HealthBar.Size = UDim2.fromScale(1, 1)
HealthBar.BackgroundColor3 = TH.Health
HealthBar.BorderSizePixel = 0
HealthBar.Parent = HealthBg
Instance.new("UICorner", HealthBar).CornerRadius = UDim.new(1, 0)

-- TARGET LOGIC
local currentTarget = nil

local function getTarget()
    local mousePosition = UIS:GetMouseLocation()
    local ray = Cam:ViewportPointToRay(mousePosition.X, mousePosition.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character}
    local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    if not result then return nil end
    local character = result.Instance:FindFirstAncestorOfClass("Model")
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    local player = Players:GetPlayerFromCharacter(character)
    if not player or player == LP then return nil end
    return player, humanoid
end

local function updatePortrait(player)
    pcall(function()
        HeadImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
end

local function showTarget(player, humanoid)
    currentTarget = player
    NameLabel.Text = player.DisplayName
    if player.DisplayName ~= player.Name then
        NameLabel.Text = player.DisplayName .. "  @" .. player.Name
    end
    updatePortrait(player)
    local hp = math.max(0, humanoid.Health)
    local maxHP = math.max(1, humanoid.MaxHealth)
    local percent = math.clamp(hp / maxHP, 0, 1)
    HPLabel.Text = string.format("%d / %d HP", math.floor(hp), math.floor(maxHP))
    HealthBar.Size = UDim2.new(percent, 0, 1, 0)
    TargetMain.Visible = true
    TargetShadow.Visible = true
    TargetMain.Position = TH.Position + UDim2.fromOffset(-15, 0)
    TargetShadow.Position = TH.Position + UDim2.fromOffset(-11, 5)
    TweenService:Create(TargetMain, TweenInfo.new(0.22, Enum.EasingStyle.Quint), { Position = TH.Position }):Play()
    TweenService:Create(TargetShadow, TweenInfo.new(0.22, Enum.EasingStyle.Quint), { Position = TH.Position + UDim2.fromOffset(4, 5) }):Play()
end

local function hideTarget()
    currentTarget = nil
    TargetMain.Visible = false
    TargetShadow.Visible = false
end

RunService.RenderStepped:Connect(function()
    if not S.TargetHUD then
        if TargetMain.Visible then hideTarget() end
        return
    end

    local player, humanoid = getTarget()
    if player and humanoid then
        if player ~= currentTarget then
            showTarget(player, humanoid)
        else
            local hp = math.max(0, humanoid.Health)
            local maxHP = math.max(1, humanoid.MaxHealth)
            local percent = math.clamp(hp / maxHP, 0, 1)
            HPLabel.Text = string.format("%d / %d HP", math.floor(hp), math.floor(maxHP))
            HealthBar.Size = UDim2.new(percent, 0, 1, 0)
            if percent > 0.6 then
                HealthBar.BackgroundColor3 = Color3.fromRGB(116, 190, 120)
            elseif percent > 0.3 then
                HealthBar.BackgroundColor3 = Color3.fromRGB(220, 180, 95)
            else
                HealthBar.BackgroundColor3 = Color3.fromRGB(205, 95, 80)
            end
        end
    elseif currentTarget then
        hideTarget()
    end
end)

-- ================= ESP / SKELETON / BOX =================
local ok = pcall(function() return Drawing.new("Text") end)
if not ok then return end

local function getChar(p)
    if p.Character then
        local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HeadMesh")
        if head then return p.Character end
    end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == p.Name then
            if obj:FindFirstChildOfClass("Humanoid") then
                return obj
            end
        end
    end
    return nil
end

local function getHead(char)
    return char:FindFirstChild("Head") or char:FindFirstChild("HeadMesh") or char:FindFirstChild("head")
end

local function getTorso(char)
    return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Chest")
end

local function getHRP(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
end

local function espFor(p)
    local e = Drawing.new("Text")
    e.Visible = false
    e.Color = Color3.fromRGB(255,50,50)
    e.Size = 16
    e.Center = true
    e.Outline = true
    RunService.RenderStepped:Connect(function()
        if not S.ESP then e.Visible = false return end
        local char = getChar(p)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and getHead(char)
        if not char or not hum or not head or hum.Health <= 0 then e.Visible = false return end
        local pos, on = Cam:WorldToViewportPoint(head.Position)
        if on then
            e.Position = Vector2.new(pos.X, pos.Y - 25)
            e.Text = p.Name .. " | " .. math.floor(hum.Health)
            e.Visible = true
        else e.Visible = false end
    end)
end

local function skelFor(p)
    local lines = {}
    for i = 1, 5 do
        local l = Drawing.new("Line")
        l.Visible = false
        l.Color = Color3.fromRGB(0,255,100)
        l.Thickness = 1.5
        table.insert(lines, l)
    end
    RunService.RenderStepped:Connect(function()
        if not S.Skeleton then
            for _, l in ipairs(lines) do l.Visible = false end
            return
        end
        local char = getChar(p)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health <= 0 then
            for _, l in ipairs(lines) do l.Visible = false end
            return
        end
        local head = getHead(char)
        local torso = getTorso(char)
        local larm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftArm")
        local rarm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") or char:FindFirstChild("RightArm")
        local lleg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftLeg")
        local rleg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLeg")

        if not head or not torso then
            for _, l in ipairs(lines) do l.Visible = false end
            return
        end

        local hp, ho = Cam:WorldToViewportPoint(head.Position)
        local tp, to = Cam:WorldToViewportPoint(torso.Position)

        if ho and to then
            lines[1].From = Vector2.new(hp.X, hp.Y)
            lines[1].To = Vector2.new(tp.X, tp.Y)
            lines[1].Visible = true
            local function setLine(i, part)
                if part then
                    local a, b = Cam:WorldToViewportPoint(part.Position)
                    if b then
                        lines[i].From = Vector2.new(tp.X, tp.Y)
                        lines[i].To = Vector2.new(a.X, a.Y)
                        lines[i].Visible = true
                    else lines[i].Visible = false end
                else lines[i].Visible = false end
            end
            setLine(2, larm)
            setLine(3, rarm)
            setLine(4, lleg)
            setLine(5, rleg)
        else
            for _, l in ipairs(lines) do l.Visible = false end
        end
    end)
end

local function boxFor(p)
    local b = Drawing.new("Square")
    b.Visible = false
    b.Color = Color3.fromRGB(255,50,50)
    b.Thickness = 1.5
    b.Filled = false
    RunService.RenderStepped:Connect(function()
        if not S.Box then b.Visible = false return end
        local char = getChar(p)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health <= 0 then b.Visible = false return end
        local hrp = getHRP(char)
        local head = getHead(char)
        if not hrp or not head then b.Visible = false return end
        local pos, on = Cam:WorldToViewportPoint(hrp.Position)
        local hpos, hon = Cam:WorldToViewportPoint(head.Position)
        if on and hon then
            local top = hpos.Y - 25
            local bottom = pos.Y + 35
            local height = bottom - top
            local width = height * 0.5
            b.Size = Vector2.new(width, height)
            b.Position = Vector2.new(pos.X - width / 2, top)
            b.Visible = true
        else b.Visible = false end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP then
        espFor(p); skelFor(p); boxFor(p)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LP then
        espFor(p); skelFor(p); boxFor(p)
    end
end)

print("[PromtMZ] visuals загружены (particles + chams + targetHUD)")
