-- PromtMZ — full version (GUI + HUD + fixed Visuals)
-- Open: RightShift or 2
-- LMB - toggle, RMB - settings

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local S = {
    KillAura = false, Aimbot = false, FarAim = false, AutoShot = false,
    Reach = false, Spin = false, Magnet = false, TP = false,
    Speed = false, Fly = false, Jump = false, Noclip = false, BHop = false,
    LeaveTp = false, Fog = true, Fullbright = false, HUD = false,
    ESP = false, Skeleton = false, Box = false, ChinaHat = false,
    AntiAFK = false, AutoClick = false,
    ReachV = 6, SpeedV = 20, FlyV = 3, JumpV = 100,
    SpinV = 100, MagR = 30, MagS = 5, AimS = 0.15, FarR = 500, BHopB = 1.05,
    FarAimS = 0.35, FarAimFastJump = 0.7,
    LeaveTpDist = 50, LeaveTpDelay = 0.5,
    FogColor = Color3.fromRGB(180,180,190), FogStart = 0, FogEnd = 250,
    AutoShotRange = 200, AutoShotDelay = 0.01, AutoShotFOV = 30, AutoShotPredict = 1.0
}

-- ================= GUI =================
local Gui = Instance.new("ScreenGui")
Gui.Name = "PromtMZ"
Gui.ResetOnSpawn = false
Gui.Parent = game.CoreGui

-- ================= HUD =================
local HudGui = Instance.new("ScreenGui")
HudGui.Name = "PromtMZ_HUD"
HudGui.ResetOnSpawn = false
HudGui.Parent = game.CoreGui

local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(0, 280, 0, 30)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundColor3 = Color3.fromRGB(20,20,25)
Watermark.BackgroundTransparency = 0.3
Watermark.BorderSizePixel = 0
Watermark.TextColor3 = Color3.fromRGB(0,200,255)
Watermark.TextSize = 14
Watermark.Font = Enum.Font.GothamBold
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.Visible = false
Watermark.Parent = HudGui
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0,6)

local ActiveFrame = Instance.new("Frame")
ActiveFrame.Size = UDim2.new(0, 200, 0, 300)
ActiveFrame.Position = UDim2.new(1, -210, 0, 10)
ActiveFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
ActiveFrame.BackgroundTransparency = 0.3
ActiveFrame.BorderSizePixel = 0
ActiveFrame.Visible = false
ActiveFrame.Parent = HudGui
Instance.new("UICorner", ActiveFrame).CornerRadius = UDim.new(0,6)

local ActiveTitle = Instance.new("TextLabel")
ActiveTitle.Size = UDim2.new(1, 0, 0, 25)
ActiveTitle.BackgroundTransparency = 1
ActiveTitle.Text = "  Active Functions"
ActiveTitle.TextColor3 = Color3.fromRGB(0,200,255)
ActiveTitle.TextSize = 13
ActiveTitle.Font = Enum.Font.GothamBold
ActiveTitle.TextXAlignment = Enum.TextXAlignment.Left
ActiveTitle.Parent = ActiveFrame

local hudLabels = {}

RunService.RenderStepped:Connect(function()
    Watermark.Visible = S.HUD
    ActiveFrame.Visible = S.HUD

    if not S.HUD then
        for _, l in ipairs(hudLabels) do l:Destroy() end
        hudLabels = {}
        return
    end

    Watermark.Text = "  PromtMZ | " .. LP.Name

    for _, l in ipairs(hudLabels) do l:Destroy() end
    hudLabels = {}

    local exclude = {
        HUD=true, Fog=true, Fullbright=true, ReachV=true, SpeedV=true, FlyV=true, JumpV=true,
        SpinV=true, MagR=true, MagS=true, AimS=true, FarR=true, BHopB=true,
        FarAimS=true, FarAimFastJump=true, LeaveTpDist=true, LeaveTpDelay=true,
        FogColor=true, FogStart=true, FogEnd=true,
        AutoShotRange=true, AutoShotDelay=true, AutoShotFOV=true, AutoShotPredict=true
    }

    local list = {}
    for k, v in pairs(S) do
        if v == true and not exclude[k] then table.insert(list, k) end
    end
    table.sort(list)

    for i, name in ipairs(list) do
        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(1, -10, 0, 18)
        L.Position = UDim2.new(0, 10, 0, 30 + (i-1)*20)
        L.BackgroundTransparency = 1
        L.Text = "• " .. name
        L.TextColor3 = Color3.fromRGB(200,200,200)
        L.TextSize = 12
        L.Font = Enum.Font.Gotham
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.Parent = ActiveFrame
        table.insert(hudLabels, L)
    end
end)

-- ================= MAIN GUI =================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 700, 0, 450)
Main.Position = UDim2.new(0.5, -350, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20,20,25)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30,30,40)
Title.BorderSizePixel = 0
Title.Text = "  PromtMZ GUI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0,10)

local function makeCol(name, x)
    local C = Instance.new("Frame")
    C.Size = UDim2.new(0, 160, 1, -60)
    C.Position = UDim2.new(0, x, 0, 50)
    C.BackgroundTransparency = 1
    C.Parent = Main

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, 0, 0, 25)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(0,200,255)
    L.TextSize = 14
    L.Font = Enum.Font.GothamBold
    L.Parent = C

    local F = Instance.new("ScrollingFrame")
    F.Size = UDim2.new(1, 0, 1, -30)
    F.Position = UDim2.new(0, 0, 0, 28)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0
    F.ScrollBarThickness = 3
    F.Parent = C

    local L2 = Instance.new("UIListLayout")
    L2.Padding = UDim.new(0, 6)
    L2.Parent = F

    return F
end

local ColC = makeCol("COMBAT", 10)
local ColM = makeCol("MOVEMENT", 180)
local ColR = makeCol("RENDER", 350)
local ColX = makeCol("MISC", 520)

-- ================= SETTINGS PANEL =================
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 300, 0, 400)
Panel.Position = UDim2.new(1, 10, 0, 50)
Panel.BackgroundColor3 = Color3.fromRGB(25,25,30)
Panel.BorderSizePixel = 0
Panel.Visible = false
Panel.Parent = Main
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0,8)

local PanelTitle = Instance.new("TextLabel")
PanelTitle.Size = UDim2.new(1, 0, 0, 30)
PanelTitle.BackgroundColor3 = Color3.fromRGB(35,35,45)
PanelTitle.BorderSizePixel = 0
PanelTitle.Text = "Settings"
PanelTitle.TextColor3 = Color3.fromRGB(0,200,255)
PanelTitle.TextSize = 14
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.Parent = Panel
Instance.new("UICorner", PanelTitle).CornerRadius = UDim.new(0,8)

local PanelScroll = Instance.new("ScrollingFrame")
PanelScroll.Size = UDim2.new(1, -10, 1, -40)
PanelScroll.Position = UDim2.new(0, 5, 0, 35)
PanelScroll.BackgroundTransparency = 1
PanelScroll.BorderSizePixel = 0
PanelScroll.ScrollBarThickness = 3
PanelScroll.Parent = Panel

local PanelLayout = Instance.new("UIListLayout")
PanelLayout.Padding = UDim.new(0, 6)
PanelLayout.Parent = PanelScroll

local function makeSlider(parent, label, minV, maxV, currentV, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = label .. ": " .. string.format("%.2f", currentV)
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(1, 0, 0, 10)
    Bg.Position = UDim2.new(0, 0, 0, 25)
    Bg.BackgroundColor3 = Color3.fromRGB(40,40,50)
    Bg.BorderSizePixel = 0
    Bg.Parent = Container
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(0,5)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((currentV - minV) / (maxV - minV), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0,120,255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bg
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0,5)

    local dragging = false

    local function update(input)
        local rel = math.clamp((input.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        local val = minV + (maxV - minV) * rel
        Label.Text = label .. ": " .. string.format("%.2f", val)
        callback(val)
    end

    Bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

local currentOpen = nil
local function openSettings(name, key)
    if currentOpen == name then
        Panel.Visible = false
        currentOpen = nil
        return
    end
    currentOpen = name
    Panel.Visible = true
    PanelTitle.Text = name .. " Settings"

    for _, c in ipairs(PanelScroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
    end

    if name == "KillAura" or name == "Aimbot" then
        makeSlider(PanelScroll, "Radius", 1, 20, S.ReachV, function(v) S.ReachV = v end)
        makeSlider(PanelScroll, "Smooth", 0.01, 1, S.AimS, function(v) S.AimS = v end)
    elseif name == "Far Aimbot" then
        makeSlider(PanelScroll, "Range", 50, 1000, S.FarR, function(v) S.FarR = v end)
        makeSlider(PanelScroll, "Smooth", 0.05, 1, S.FarAimS, function(v) S.FarAimS = v end)
        makeSlider(PanelScroll, "Fast Jump", 0.1, 1, S.FarAimFastJump, function(v) S.FarAimFastJump = v end)
    elseif name == "Reach" then
        makeSlider(PanelScroll, "Distance", 1, 20, S.ReachV, function(v) S.ReachV = v end)
    elseif name == "SpinBot" then
        makeSlider(PanelScroll, "Speed", 10, 500, S.SpinV, function(v) S.SpinV = v end)
    elseif name == "Magnet" then
        makeSlider(PanelScroll, "Range", 5, 100, S.MagR, function(v) S.MagR = v end)
        makeSlider(PanelScroll, "Speed", 1, 50, S.MagS, function(v) S.MagS = v end)
    elseif name == "Auto Shot" then
        makeSlider(PanelScroll, "Range", 10, 500, S.AutoShotRange, function(v) S.AutoShotRange = v end)
        makeSlider(PanelScroll, "Delay", 0.01, 1, S.AutoShotDelay, function(v) S.AutoShotDelay = v end)
        makeSlider(PanelScroll, "FOV", 10, 300, S.AutoShotFOV, function(v) S.AutoShotFOV = v end)
        makeSlider(PanelScroll, "Predict", 0, 3, S.AutoShotPredict, function(v) S.AutoShotPredict = v end)
    elseif name == "Speed" then
        makeSlider(PanelScroll, "Walkspeed", 16, 200, S.SpeedV, function(v) S.SpeedV = v end)
    elseif name == "Fly" then
        makeSlider(PanelScroll, "Fly Speed", 1, 20, S.FlyV, function(v) S.FlyV = v end)
    elseif name == "Jump" then
        makeSlider(PanelScroll, "Jump Power", 50, 500, S.JumpV, function(v) S.JumpV = v end)
    elseif name == "BunnyHop" then
        makeSlider(PanelScroll, "Boost", 1.01, 1.5, S.BHopB, function(v) S.BHopB = v end)
    elseif name == "LeaveTp" then
        makeSlider(PanelScroll, "Distance", 10, 200, S.LeaveTpDist, function(v) S.LeaveTpDist = v end)
        makeSlider(PanelScroll, "Delay", 0.1, 2, S.LeaveTpDelay, function(v) S.LeaveTpDelay = v end)
    elseif name == "Fog" then
        makeSlider(PanelScroll, "Start", 0, 500, S.FogStart, function(v) S.FogStart = v end)
        makeSlider(PanelScroll, "End", 50, 2000, S.FogEnd, function(v) S.FogEnd = v end)
    else
        local Info = Instance.new("TextLabel")
        Info.Size = UDim2.new(1, 0, 0, 30)
        Info.BackgroundTransparency = 1
        Info.Text = "Нет настроек"
        Info.TextColor3 = Color3.fromRGB(150,150,150)
        Info.TextSize = 12
        Info.Font = Enum.Font.Gotham
        Info.Parent = PanelScroll
    end
end

local function makeBtn(parent, name, key)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 30)
    B.BackgroundColor3 = S[key] and Color3.fromRGB(0,120,255) or Color3.fromRGB(40,40,50)
    B.BorderSizePixel = 0
    B.Text = "  " .. name
    B.TextColor3 = Color3.fromRGB(255,255,255)
    B.TextSize = 12
    B.Font = Enum.Font.Gotham
    B.TextXAlignment = Enum.TextXAlignment.Left
    B.Parent = parent
    Instance.new("UICorner", B).CornerRadius = UDim.new(0,5)

    B.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        B.BackgroundColor3 = S[key] and Color3.fromRGB(0,120,255) or Color3.fromRGB(40,40,50)
    end)

    B.MouseButton2Click:Connect(function()
        openSettings(name, key)
    end)
end

makeBtn(ColC, "KillAura", "KillAura")
makeBtn(ColC, "Aimbot", "Aimbot")
makeBtn(ColC, "Far Aimbot", "FarAim")
makeBtn(ColC, "Auto Shot", "AutoShot")
makeBtn(ColC, "Reach", "Reach")
makeBtn(ColC, "SpinBot", "Spin")
makeBtn(ColC, "Magnet", "Magnet")
makeBtn(ColC, "TP", "TP")

makeBtn(ColM, "Speed", "Speed")
makeBtn(ColM, "Fly", "Fly")
makeBtn(ColM, "Jump", "Jump")
makeBtn(ColM, "Noclip", "Noclip")
makeBtn(ColM, "BunnyHop", "BHop")
makeBtn(ColM, "LeaveTp", "LeaveTp")

makeBtn(ColR, "Fog", "Fog")
makeBtn(ColR, "Fullbright", "Fullbright")
makeBtn(ColR, "HUD", "HUD")
makeBtn(ColR, "ESP", "ESP")
makeBtn(ColR, "Skeleton", "Skeleton")
makeBtn(ColR, "Box", "Box")
makeBtn(ColR, "China Hat", "ChinaHat")

makeBtn(ColX, "AntiAFK", "AntiAFK")
makeBtn(ColX, "AutoClick", "AutoClick")

local opened = false
local function open()
    if opened then return end
    opened = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 700, 0, 450),
        Position = UDim2.new(0.5, -350, 0.5, -225)
    }):Play()
end

local function close()
    if not opened then return end
    opened = false
    Panel.Visible = false
    currentOpen = nil
    local t = TweenService:Create(Main, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    t:Play()
    t.Completed:Connect(function() Main.Visible = false end)
end

local drag, ds, sp
Title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true; ds = i.Position; sp = Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightShift or i.KeyCode == Enum.KeyCode.Two then
        if opened then close() else open() end
    end
end)

-- ================= FUNCTIONS =================

-- Fog
RunService.RenderStepped:Connect(function()
    if S.Fog then
        Lighting.FogColor = S.FogColor
        Lighting.FogStart = S.FogStart
        Lighting.FogEnd = S.FogEnd
    else
        Lighting.FogColor = Color3.fromRGB(192,192,192)
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
    end
end)

-- Speed
RunService.RenderStepped:Connect(function()
    if S.Speed and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = S.SpeedV
    end
end)

-- Jump
RunService.RenderStepped:Connect(function()
    if S.Jump and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = S.JumpV
    end
end)

-- Fly
RunService.RenderStepped:Connect(function()
    if not S.Fly then return end
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    local d = Vector3.new()
    if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + Cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - Cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - Cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + Cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0,1,0) end
    hrp.Velocity = d * (S.FlyV * 10)
end)

-- Noclip
RunService.Stepped:Connect(function()
    if not S.Noclip then return end
    if LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- Fullbright
RunService.RenderStepped:Connect(function()
    if S.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.Brightness = 1
    end
end)

-- BunnyHop
local bhop = 0
RunService.RenderStepped:Connect(function()
    if not S.BHop then bhop = 0 return end
    if not LP.Character or not LP.Character:FindFirstChild("Humanoid") then return end
    local h = LP.Character.Humanoid
    if h.FloorMaterial ~= Enum.Material.Air then
        h.Jump = true
        bhop = bhop + S.BHopB
        if bhop > 200 then bhop = 200 end
        h.WalkSpeed = bhop
    end
end)

-- LeaveTp
local lastTpTime = 0
RunService.RenderStepped:Connect(function()
    if not S.LeaveTp then return end
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    local now = tick()
    if now - lastTpTime > S.LeaveTpDelay then
        lastTpTime = now
        local vel = hrp.Velocity
        if vel.Magnitude > 1 then
            hrp.CFrame = CFrame.new(hrp.Position + vel.Unit * S.LeaveTpDist) * (hrp.CFrame - hrp.Position)
        end
    end
end)

-- KillAura
RunService.RenderStepped:Connect(function()
    if not S.KillAura then return end
    if not LP.Character then return end
    local myHead = LP.Character:FindFirstChild("Head")
    if not myHead then return end
    local closest, shortest = nil, S.ReachV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            if head and hum and hum.Health > 0 then
                local d = (myHead.Position - head.Position).Magnitude
                if d < shortest then shortest = d; closest = p end
            end
        end
    end
    if closest and closest.Character then
        local tool = LP.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
        if mouse1click then pcall(mouse1click) end
    end
end)

-- Aimbot
RunService.RenderStepped:Connect(function()
    if not S.Aimbot then return end
    if not LP.Character then return end
    local myHead = LP.Character:FindFirstChild("Head")
    if not myHead then return end

    local function findTarget(checkWalls)
        local closest, shortest = nil, S.ReachV
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local head = p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChild("Humanoid")
                if head and hum and hum.Health > 0 then
                    local d = (myHead.Position - head.Position).Magnitude
                    if d < shortest then
                        if checkWalls then
                            local rp = RaycastParams.new()
                            rp.FilterType = Enum.RaycastFilterType.Exclude
                            rp.FilterDescendantsInstances = {LP.Character}
                            local rr = workspace:Raycast(myHead.Position, head.Position - myHead.Position, rp)
                            local vis = false
                            if rr then
                                if rr.Instance and rr.Instance:IsDescendantOf(p.Character) then vis = true end
                            else vis = true end
                            if not vis then continue end
                        end
                        shortest = d
                        closest = p
                    end
                end
            end
        end
        return closest
    end

    local target = findTarget(true) or findTarget(false)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local newCFrame = CFrame.lookAt(myHead.Position, target.Character.Head.Position)
        Cam.CFrame = Cam.CFrame:Lerp(newCFrame, S.AimS)
    end
end)

-- FarAim
RunService.RenderStepped:Connect(function()
    if not S.FarAim then return end
    if not LP.Character then return end
    local myHead = LP.Character:FindFirstChild("Head")
    if not myHead then return end
    local closest, shortest = nil, S.FarR
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            if head and hum and hum.Health > 0 then
                local d = (myHead.Position - head.Position).Magnitude
                if d < shortest then shortest = d; closest = p end
            end
        end
    end
    if not (closest and closest.Character and closest.Character:FindFirstChild("Head")) then return end
    local tHead = closest.Character.Head
    local tHrp = closest.Character:FindFirstChild("HumanoidRootPart")
    local tVel = tHrp and tHrp.Velocity or Vector3.new()
    local dist = (myHead.Position - tHead.Position).Magnitude
    local tTime = math.clamp(dist / 2000, 0.01, 0.2)
    local pred = tHead.Position + tVel * tTime
    local sm = S.FarAimS
    if tVel.Y > 5 then sm = S.FarAimFastJump
    elseif tVel.Magnitude > 20 then sm = math.min(S.FarAimS * 1.3, 1) end
    local newCFrame = CFrame.lookAt(myHead.Position, pred)
    Cam.CFrame = Cam.CFrame:Lerp(newCFrame, sm)
end)

-- AutoShot
local lastShot = 0
RunService.RenderStepped:Connect(function()
    if not S.AutoShot then return end
    if not LP.Character then return end
    local now = tick()
    if now - lastShot < S.AutoShotDelay then return end
    local myHead = LP.Character:FindFirstChild("Head")
    if not myHead then return end
    local closest, shortest = nil, S.AutoShotRange
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            if head and hum and hum.Health > 0 then
                local d = (myHead.Position - head.Position).Magnitude
                if d < shortest then shortest = d; closest = p end
            end
        end
    end
    if not closest or not closest.Character then return end
    local head = closest.Character:FindFirstChild("Head")
    local hrp = closest.Character:FindFirstChild("HumanoidRootPart")
    if not head then return end
    local tVel = hrp and hrp.Velocity * S.AutoShotPredict or Vector3.new()
    local dist = (myHead.Position - head.Position).Magnitude
    local tTime = math.clamp(dist / 2000, 0.01, 0.3)
    local pred = head.Position + tVel * tTime
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LP.Character}
    local rr = workspace:Raycast(myHead.Position, pred - myHead.Position, rp)
    local vis = false
    if rr then
        if rr.Instance and rr.Instance:IsDescendantOf(closest.Character) then vis = true end
    else vis = true end
    if not vis then return end
    local sp, onScr = Cam:WorldToViewportPoint(pred)
    if not onScr then return end
    local vp = Cam.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    local dC = math.sqrt((sp.X - cx)^2 + (sp.Y - cy)^2)
    if dC > S.AutoShotFOV then return end
    local cr = workspace:Raycast(myHead.Position, head.Position - myHead.Position, rp)
    if cr and cr.Instance and not cr.Instance:IsDescendantOf(closest.Character) then return end
    local tool = LP.Character:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
    if mouse1click then pcall(mouse1click) end
    lastShot = now
end)

-- Spin
RunService.RenderStepped:Connect(function()
    if not S.Spin then return end
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.SpinV), 0)
end)

-- Magnet
RunService.RenderStepped:Connect(function()
    if not S.Magnet then return end
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    local c, s = nil, S.MagR
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < s then s = d; c = p end
        end
    end
    if c then hrp.Velocity = (c.Character.HumanoidRootPart.Position - hrp.Position).Unit * (S.MagS * 10) end
end)

-- TP
RunService.RenderStepped:Connect(function()
    if not S.TP then return end
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local c, s = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < s then s = d; c = p end
        end
    end
    if c then LP.Character.HumanoidRootPart.CFrame = c.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0) end
end)

-- AntiAFK
task.spawn(function()
    while task.wait(60) do
        if S.AntiAFK then
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end
end)

-- AutoClick
task.spawn(function()
    while task.wait(0.1) do
        if S.AutoClick then
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

-- ================= VISUALS =================
local ok = pcall(function() return Drawing.new("Text") end)
if ok then
    -- ESP
    local function espFor(p)
        local e = Drawing.new("Text")
        e.Visible = false
        e.Color = Color3.fromRGB(255, 50, 50)
        e.Size = 16
        e.Center = true
        e.Outline = true
        e.Font = 2
        RunService.RenderStepped:Connect(function()
            if not S.ESP then e.Visible = false return end
            local char = p.Character
            local hum = char and char:FindFirstChild("Humanoid")
            local head = char and char:FindFirstChild("Head")
            if not char or not hum or not head or hum.Health <= 0 then
                e.Visible = false
                return
            end
            local pos, on = Cam:WorldToViewportPoint(head.Position)
            if on then
                e.Position = Vector2.new(pos.X, pos.Y - 25)
                e.Text = p.Name .. " | " .. math.floor(hum.Health)
                e.Visible = true
            else
                e.Visible = false
            end
        end)
    end

    -- Skeleton
    local function skelFor(p)
        local lines = {}
        for i = 1, 5 do
            local l = Drawing.new("Line")
            l.Visible = false
            l.Color = Color3.fromRGB(0, 255, 100)
            l.Thickness = 1.5
            table.insert(lines, l)
        end
        RunService.RenderStepped:Connect(function()
            if not S.Skeleton then
                for _, l in ipairs(lines) do l.Visible = false end
                return
            end
            local char = p.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if not char or not hum or hum.Health <= 0 then
                for _, l in ipairs(lines) do l.Visible = false end
                return
            end
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
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
                        else
                            lines[i].Visible = false
                        end
                    else
                        lines[i].Visible = false
                    end
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

    -- Box
    local function boxFor(p)
        local b = Drawing.new("Square")
        b.Visible = false
        b.Color = Color3.fromRGB(255, 50, 50)
        b.Thickness = 1.5
        b.Filled = false
        RunService.RenderStepped:Connect(function()
            if not S.Box then b.Visible = false return end
            local char = p.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if not char or not hum or hum.Health <= 0 then
                b.Visible = false
                return
            end
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            local head = char:FindFirstChild("Head")
            if not hrp or not head then
                b.Visible = false
                return
            end
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
            else
                b.Visible = false
            end
        end)
    end

    -- China Hat
    local hats = {}
    local function createHat(p)
        if not p.Character then return end
        local head = p.Character:FindFirstChild("Head")
        if not head then return end
        if hats[p] and hats[p].Parent then return end
        local hat = Instance.new("Part")
        hat.Name = "PromtMZ_ChinaHat"
        hat.Shape = Enum.PartType.Cylinder
        hat.Size = Vector3.new(0.2, 3, 3)
        hat.Color = Color3.fromRGB(255, 0, 0)
        hat.Material = Enum.Material.Neon
        hat.CanCollide = false
        hat.Anchored = false
        hat.Massless = true
        hat.Parent = head
        hats[p] = hat
    end

    RunService.RenderStepped:Connect(function()
        for p, hat in pairs(hats) do
            if hat and hat.Parent then
                if not S.ChinaHat then
                    hat.Transparency = 1
                else
                    hat.Transparency = 0
                    local head = p.Character and p.Character:FindFirstChild("Head")
                    if head then
                        hat.CFrame = head.CFrame * CFrame.new(0, 2.5, 0) * CFrame.Angles(0, 0, math.rad(90))
                    end
                end
            end
        end
    end)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            espFor(p); skelFor(p); boxFor(p)
            p.CharacterAdded:Connect(function()
                task.wait(0.5)
                createHat(p)
            end)
            if p.Character then createHat(p) end
        end
    end
    Players.PlayerAdded:Connect(function(p)
        if p ~= LP then
            espFor(p); skelFor(p); boxFor(p)
            p.CharacterAdded:Connect(function()
                task.wait(0.5)
                createHat(p)
            end)
        end
    end)
    Players.PlayerRemoving:Connect(function(p)
        if hats[p] then
            hats[p]:Destroy()
            hats[p] = nil
        end
    end)
end

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PromtMZ",
    Text = "RightShift или 2 — меню. ПКМ по функции — настройки.",
    Duration = 5
})
