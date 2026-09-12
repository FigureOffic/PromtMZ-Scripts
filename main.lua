-- PromtMZ Main
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

_G.PromtMZ = _G.PromtMZ or {}
local S = _G.PromtMZ.S or {
    KillAura=false, Aimbot=false, FarAim=false, AutoShot=false,
    Reach=false, Spin=false, Magnet=false, TP=false,
    Speed=false, Fly=false, Jump=false, Noclip=false, BHop=false,
    LeaveTp=false, Fog=true, Fullbright=false, HUD=false,
    ESP=false, Skeleton=false, Box=false, ChinaHat=false,
    AntiAFK=false, AutoClick=false,
    ReachV=6, SpeedV=20, FlyV=3, JumpV=100,
    SpinV=100, MagR=30, MagS=5, AimS=0.15, FarR=500, BHopB=1.05,
    FarAimS=0.35, FarAimFastJump=0.7,
    LeaveTpDist=50, LeaveTpDelay=0.5,
    FogColor=Color3.fromRGB(180,180,190), FogStart=0, FogEnd=250,
    AutoShotRange=200, AutoShotDelay=0.01, AutoShotFOV=30, AutoShotPredict=1.0
}
_G.PromtMZ.S = S

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "PromtMZ"
Gui.ResetOnSpawn = false
Gui.Parent = game.CoreGui

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
Title.Text = "  PromtMZ"
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

-- HUD
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
    for k, v in pairs(S) do
        if v == true and type(k) == "string" and k ~= "HUD" and k ~= "Fog" and k ~= "Fullbright" then
            table.insert(hudLabels, k)
        end
    end
end)

-- FUNCTIONS
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

RunService.RenderStepped:Connect(function()
    if S.Speed and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = S.SpeedV
    end
end)

RunService.RenderStepped:Connect(function()
    if S.Jump and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = S.JumpV
    end
end)

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

RunService.Stepped:Connect(function()
    if not S.Noclip then return end
    if LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if S.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.Brightness = 1
    end
end)

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
    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
        local newCFrame = CFrame.lookAt(myHead.Position, closest.Character.Head.Position)
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
    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
        local newCFrame = CFrame.lookAt(myHead.Position, closest.Character.Head.Position)
        Cam.CFrame = Cam.CFrame:Lerp(newCFrame, S.FarAimS)
    end
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

print("[PromtMZ] Main загружен")
