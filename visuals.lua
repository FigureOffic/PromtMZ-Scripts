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

-- ================= CHAMS (Glossy Highlight, видно сквозь стены) =================
local ChamsConfig = {
    FillColor = Color3.fromRGB(235, 220, 195),
    OutlineColor = Color3.fromRGB(255, 248, 230),
    FillTransparency = 0.18,
    OutlineTransparency = 0,
    UseShine = true,
}

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
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop  -- ← видно сквозь стены
    highlight.FillColor = ChamsConfig.FillColor
    highlight.FillTransparency = ChamsConfig.FillTransparency
    highlight.OutlineColor = ChamsConfig.OutlineColor
    highlight.OutlineTransparency = ChamsConfig.OutlineTransparency
    highlight.Enabled = true
    highlight.Parent = character

    if ChamsConfig.UseShine then
        highlight:SetAttribute("Glossy", true)
    end
end

-- Обновление Chams при переключении
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
        task.defer(function()
            addGlossyHighlight(player.Character)
        end)
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

print("[PromtMZ] visuals загружены (particles + chams)")
