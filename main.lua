-- main.lua
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

_G.PromtMZ = _G.PromtMZ or {}
local S = _G.PromtMZ.S or {
    KillAura=false, Aimbot=false, FarAim=false, AutoShot=false,
    Reach=false, Spin=false, Magnet=false, TP=false,
    Speed=false, Fly=false, Jump=false, Noclip=false, BHop=false,
    LeaveTp=false, Fog=true, Fullbright=false, HUD=false,
    ESP=false, Skeleton=false, Box=false, ChinaHat=false, Particles=false,
    AntiAFK=false, AutoClick=false,
    ReachV=6, SpeedV=20, FlyV=3, JumpV=100,
    SpinV=100, MagR=30, MagS=5, AimS=0.15, FarR=500, BHopB=1.05,
    FarAimS=0.35, FarAimFastJump=0.7,
    LeaveTpDist=50, LeaveTpDelay=0.5,
    FogColor=Color3.fromRGB(180,180,190), FogStart=0, FogEnd=250,
    AutoShotRange=200, AutoShotDelay=0.01, AutoShotFOV=30, AutoShotPredict=1.0,
    ParticleColor=Color3.fromRGB(255,100,200), ParticleSize=1.0, ParticleLifetime=1.5
}
_G.PromtMZ.S = S

local Gui = Instance.new("ScreenGui")
Gui.Name = "PromtMZ"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() Gui.Parent = game.CoreGui end)

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 700, 0, 450)
Main.Position = UDim2.new(0.5, -350, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20,20,25)
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 1
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
Title.ZIndex = 5
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0,10)

local function makeCol(name, x)
    local C = Instance.new("Frame")
    C.Size = UDim2.new(0, 160, 1, -60)
    C.Position = UDim2.new(0, x, 0, 50)
    C.BackgroundTransparency = 1
    C.ZIndex = 1
    C.Parent = Main
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, 0, 0, 25)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(0,200,255)
    L.TextSize = 14
    L.Font = Enum.Font.GothamBold
    L.ZIndex = 5
    L.Parent = C
    local F = Instance.new("ScrollingFrame")
    F.Size = UDim2.new(1, 0, 1, -30)
    F.Position = UDim2.new(0, 0, 0, 28)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0
    F.ScrollBarThickness = 3
    F.ZIndex = 2
    F.CanvasSize = UDim2.new(0, 0, 0, 500)
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

-- Панель настроек
local Panel = Instance.new("Frame")
Panel.Name = "SettingsPanel"
Panel.Size = UDim2.new(0, 280, 0, 400)
Panel.Position = UDim2.new(1, 10, 0, 50)
Panel.BackgroundColor3 = Color3.fromRGB(25,25,30)
Panel.BorderSizePixel = 0
Panel.Visible = false
Panel.ZIndex = 20
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
PanelScroll.ZIndex = 21
PanelScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
PanelScroll.Parent = Panel

local PanelLayout = Instance.new("UIListLayout")
PanelLayout.Padding = UDim.new(0, 6)
PanelLayout.Parent = PanelScroll

local function makeSlider(parent, label, minV, maxV, currentV, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 50)
    Container.BackgroundTransparency = 1
    Container.ZIndex = 25
    Container.Parent = parent
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = label .. ": " .. string.format("%.2f", currentV)
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 26
    Label.Parent = Container
    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(1, 0, 0, 10)
    Bg.Position = UDim2.new(0, 0, 0, 25)
    Bg.BackgroundColor3 = Color3.fromRGB(40,40,50)
    Bg.BorderSizePixel = 0
    Bg.ZIndex = 26
    Bg.Parent = Container
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(0,5)
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((currentV - minV) / (maxV - minV), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0,120,255)
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 27
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
        if c:IsA("Frame") then c:Destroy() end
    end
    if name == "KillAura" or name == "Aimbot" then
        makeSlider(PanelScroll, "Radius", 1, 20, S.ReachV, function(v) S.ReachV = v end)
        makeSlider(PanelScroll, "Smooth", 0.01, 1, S.AimS, function(v) S.AimS = v end)
    elseif name == "Far Aimbot" then
        makeSlider(PanelScroll, "Range", 50, 1000, S.FarR, function(v) S.FarR = v end)
        makeSlider(PanelScroll, "Smooth", 0.05, 1, S.FarAimS, function(v) S.FarAimS = v end)
    elseif name == "Auto Shot" then
        makeSlider(PanelScroll, "Range", 10, 500, S.AutoShotRange, function(v) S.AutoShotRange = v end)
        makeSlider(PanelScroll, "Delay", 0.01, 1, S.AutoShotDelay, function(v) S.AutoShotDelay = v end)
        makeSlider(PanelScroll, "FOV", 10, 300, S.AutoShotFOV, function(v) S.AutoShotFOV = v end)
    elseif name == "Speed" then
        makeSlider(PanelScroll, "Walkspeed", 16, 200, S.SpeedV, function(v) S.SpeedV = v end)
    elseif name == "Fly" then
        makeSlider(PanelScroll, "Fly Speed", 1, 20, S.FlyV, function(v) S.FlyV = v end)
    elseif name == "Jump" then
        makeSlider(PanelScroll, "Jump Power", 50, 500, S.JumpV, function(v) S.JumpV = v end)
    elseif name == "BunnyHop" then
        makeSlider(PanelScroll, "Boost", 1.01, 1.5, S.BHopB, function(v) S.BHopB = v end)
    elseif name == "Fog" then
        makeSlider(PanelScroll, "Start", 0, 500, S.FogStart, function(v) S.FogStart = v end)
        makeSlider(PanelScroll, "End", 50, 2000, S.FogEnd, function(v) S.FogEnd = v end)
    elseif name == "Particles" then
        makeSlider(PanelScroll, "Size", 0.1, 5, S.ParticleSize, function(v) S.ParticleSize = v end)
        makeSlider(PanelScroll, "Lifetime", 0.5, 5, S.ParticleLifetime, function(v) S.ParticleLifetime = v end)
    else
        local Info = Instance.new("TextLabel")
        Info.Size = UDim2.new(1, 0, 0, 30)
        Info.BackgroundTransparency = 1
        Info.Text = "Нет настроек"
        Info.TextColor3 = Color3.fromRGB(150,150,150)
        Info.TextSize = 12
        Info.Font = Enum.Font.Gotham
        Info.ZIndex = 25
        Info.Parent = PanelScroll
    end
end

local function makeBtn(parent, name, key)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 30)
    B.BackgroundColor3 = (S[key] == true) and Color3.fromRGB(0,120,255) or Color3.fromRGB(40,40,50)
    B.BorderSizePixel = 0
    B.Text = "  " .. name
    B.TextColor3 = Color3.fromRGB(255,255,255)
    B.TextSize = 12
    B.Font = Enum.Font.Gotham
    B.TextXAlignment = Enum.TextXAlignment.Left
    B.ZIndex = 10
    B.Active = true
    B.AutoButtonColor = false
    B.Parent = parent
    Instance.new("UICorner", B).CornerRadius = UDim.new(0,5)

    B.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        B.BackgroundColor3 = (S[key] == true) and Color3.fromRGB(0,120,255) or Color3.fromRGB(40,40,50)
        print("[PromtMZ]", name, "=", tostring(S[key]))
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
makeBtn(ColR, "Particles", "Particles")

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

-- HUD
local HudGui = Instance.new("ScreenGui")
HudGui.Name = "PromtMZ_HUD"
HudGui.ResetOnSpawn = false
pcall(function() HudGui.Parent = game.CoreGui end)

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
            local L = Instance.new("TextLabel")
            L.Size = UDim2.new(1, -10, 0, 18)
            L.BackgroundTransparency = 1
            L.Text = "• " .. k
            L.TextColor3 = Color3.fromRGB(200,200,200)
            L.TextSize = 12
            L.Font = Enum.Font.Gotham
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Parent = ActiveFrame
            table.insert(hudLabels, L)
        end
    end
end)

print("[PromtMZ] main загружен")
