-- main.lua — PromtMZ Black & Purple Ultra Smooth GUI
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local LP = Players.LocalPlayer

_G.PromtMZ = _G.PromtMZ or {}

local S = _G.PromtMZ.S or {
    KillAura=false, Aimbot=false, FarAim=false, AutoShot=false,
    Reach=false, Spin=false, Magnet=false, TP=false,
    Speed=false, Fly=false, Jump=false, Noclip=false, BHop=false,
    LeaveTp=false, Fog=true, Fullbright=false, HUD=false,
    ESP=false, Skeleton=false, Box=false, ChinaHat=false,
    Particles=false, Chams=false, TargetHUD=false, Music=false,
    AspectRatio=false, MotionBlur=false, Optimization=false,
    Console=false, Saturation=false,
    AntiAFK=false, AutoClick=false,
    ReachV=6, SpeedV=20, FlyV=3, JumpV=100,
    SpinV=100, MagR=30, MagS=5, AimS=0.15,
    FarR=500, BHopB=1.05,
    FarAimS=0.35, FarAimFastJump=0.7,
    LeaveTpDist=50, LeaveTpDelay=0.5,
    FogColor=Color3.fromRGB(180,180,190),
    FogStart=0, FogEnd=250,
    AutoShotRange=200,
    AutoShotDelay=0.01,
    AutoShotFOV=30,
    AutoShotPredict=1.0,
    ParticleColor=Color3.fromRGB(255,100,200),
    ParticleSize=1.0,
    ParticleLifetime=1.5,
    MotionBlurStrength=12,
    SaturationValue=1.5
}
_G.PromtMZ.S = S

-- DESCRIPTIONS
local DESCRIPTIONS = {
    KillAura = "Автоматически бьёт ближайшего игрока",
    Aimbot = "Наводит прицел на ближайшего игрока",
    FarAim = "Наводит прицел на дальних игроков",
    AutoShot = "Стреляет, пока прицел на голове",
    Reach = "Увеличивает дистанцию удара",
    SpinBot = "Вращает персонажа вокруг оси",
    Magnet = "Притягивает к ближайшему игроку",
    TP = "Телепорт к ближайшему игроку",
    Speed = "Увеличивает скорость",
    Fly = "Позволяет летать",
    Jump = "Увеличивает высоту прыжка",
    Noclip = "Проходишь сквозь блоки",
    BunnyHop = "Авто-прыжки с ускорением",
    LeaveTp = "Телепорт рывками",
    Fog = "Атмосферный туман",
    Fullbright = "Максимальная яркость",
    HUD = "Watermark + активные функции",
    ESP = "Ники и HP игроков",
    Skeleton = "Скелет игрока",
    Box = "Рамка вокруг игроков",
    ChinaHat = "Красная шляпа",
    Particles = "Круги при прыжке и взрыв",
    Chams = "Глянцевая заливка игроков",
    TargetHUD = "Инфо о цели: аватар, ник, HP",
    Music = "Music Bar в стиле YouTube",
    AspectRatio = "Соотношение 4:3",
    MotionBlur = "Размытие при движении камеры",
    Optimization = "Отключает тяжёлые эффекты",
    Console = "Окно консоли",
    Saturation = "Насыщенность цветов",
    AntiAFK = "Авто-действия против АФК-кика",
    AutoClick = "Авто-клики ЛКМ",
}

-- COLORS
local C = {
    Purple = Color3.fromRGB(145, 55, 255),
    BrightPurple = Color3.fromRGB(210, 120, 255),
    SoftPurple = Color3.fromRGB(100, 35, 170),
    Background = Color3.fromRGB(7, 5, 11),
    Card = Color3.fromRGB(18, 12, 27),
    Text = Color3.fromRGB(245, 240, 255),
    SubText = Color3.fromRGB(145, 130, 165),
}

local CONFIG = {
    Width = 700,
    Height = 460,
    ParticleCount = 26,
    PlasmaCount = 7,
    AnimationSpeed = 0.32,
    ParallaxStrength = 2,
}

local T = {
    Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Soft = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Open = TweenInfo.new(1.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Close = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
}

local function tween(obj, info, props)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function corner(obj, radius)
    local x = Instance.new("UICorner")
    x.CornerRadius = UDim.new(0, radius)
    x.Parent = obj
    return x
end

local function stroke(obj, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = obj
    return s
end

-- BLUR
local Blur = Lighting:FindFirstChild("PromtMZ_Blur")
if not Blur then
    Blur = Instance.new("BlurEffect")
    Blur.Name = "PromtMZ_Blur"
    Blur.Size = 0
    Blur.Parent = Lighting
end

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "PromtMZ"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
pcall(function() Gui.Parent = game.CoreGui end)

-- SHADOW
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Size = UDim2.fromOffset(CONFIG.Width + 20, CONFIG.Height + 20)
Shadow.Position = UDim2.new(0.5, 9, 1.08, 10)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.5
Shadow.BorderSizePixel = 0
Shadow.Visible = false
Shadow.ZIndex = 1
Shadow.Parent = Gui
corner(Shadow, 20)

-- MAIN
local FinalPosition = UDim2.new(0.5, 0, 0.5, 0)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = UDim2.fromOffset(145, 50)
Main.Position = UDim2.new(0.5, 0, 1.08, 0)
Main.BackgroundColor3 = C.Background
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.ZIndex = 2
Main.Parent = Gui
corner(Main, 17)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C.Purple
MainStroke.Thickness = 1
MainStroke.Transparency = 0.4
MainStroke.Parent = Main

-- GRADIENT
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 4, 10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(19, 9, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 4, 10)),
})
Gradient.Rotation = 35
Gradient.Parent = Main

-- GLOW 1
local Glow1 = Instance.new("Frame")
Glow1.Size = UDim2.fromOffset(270, 270)
Glow1.Position = UDim2.new(0.78, -135, 0.3, -135)
Glow1.BackgroundColor3 = C.Purple
Glow1.BackgroundTransparency = 0.92
Glow1.BorderSizePixel = 0
Glow1.ZIndex = 3
Glow1.Parent = Main
corner(Glow1, 999)

-- GLOW 2
local Glow2 = Instance.new("Frame")
Glow2.Size = UDim2.fromOffset(210, 210)
Glow2.Position = UDim2.new(0.12, -105, 0.82, -105)
Glow2.BackgroundColor3 = C.BrightPurple
Glow2.BackgroundTransparency = 0.95
Glow2.BorderSizePixel = 0
Glow2.ZIndex = 3
Glow2.Parent = Main
corner(Glow2, 999)

-- HEADER
local Header = Instance.new("TextLabel")
Header.Name = "Header"
Header.Size = UDim2.new(1, -35, 0, 40)
Header.Position = UDim2.fromOffset(18, 8)
Header.BackgroundTransparency = 1
Header.Text = "PURPLE // CONTROL"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = C.Text
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.ZIndex = 30
Header.Parent = Main

local SubHeader = Instance.new("TextLabel")
SubHeader.Size = UDim2.new(1, -35, 0, 18)
SubHeader.Position = UDim2.fromOffset(19, 37)
SubHeader.BackgroundTransparency = 1
SubHeader.Text = "ULTRA SMOOTH INTERFACE"
SubHeader.Font = Enum.Font.Gotham
SubHeader.TextSize = 9
SubHeader.TextColor3 = C.SubText
SubHeader.TextXAlignment = Enum.TextXAlignment.Left
SubHeader.ZIndex = 30
SubHeader.Parent = Main

-- ENERGY LINE
local EnergyLine = Instance.new("Frame")
EnergyLine.Size = UDim2.fromOffset(130, 2)
EnergyLine.Position = UDim2.fromOffset(-150, 59)
EnergyLine.BackgroundColor3 = C.BrightPurple
EnergyLine.BorderSizePixel = 0
EnergyLine.ZIndex = 35
EnergyLine.Parent = Main

local EnergyGradient = Instance.new("UIGradient")
EnergyGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
})
EnergyGradient.Parent = EnergyLine

-- TOOLTIP
local Tooltip = Instance.new("TextLabel")
Tooltip.Size = UDim2.new(0, 400, 0, 32)
Tooltip.Position = UDim2.new(0.5, -200, 0, -42)
Tooltip.BackgroundColor3 = C.Card
Tooltip.BackgroundTransparency = 0.05
Tooltip.BorderSizePixel = 0
Tooltip.Text = ""
Tooltip.TextColor3 = C.Text
Tooltip.TextSize = 12
Tooltip.Font = Enum.Font.GothamMedium
Tooltip.TextWrapped = true
Tooltip.Visible = false
Tooltip.ZIndex = 40
Tooltip.Parent = Main
corner(Tooltip, 10)
stroke(Tooltip, C.Purple, 0.4, 1)

local function showTooltip(text)
    if not text or text == "" then Tooltip.Visible = false return end
    Tooltip.Text = "  " .. text .. "  "
    Tooltip.Visible = true
    Tooltip.Size = UDim2.new(0, math.clamp(#text * 7 + 30, 200, 600), 0, 32)
    Tooltip.Position = UDim2.new(0.5, -Tooltip.Size.X.Offset / 2, 0, -42)
end

local function hideTooltip()
    Tooltip.Visible = false
end

-- CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -28, 1, -82)
Content.Position = UDim2.fromOffset(14, 72)
Content.BackgroundTransparency = 1
Content.ZIndex = 20
Content.Parent = Main

local function makeCol(name, x)
    local Card = Instance.new("Frame")
    Card.Name = name
    Card.Size = UDim2.new(0, 163, 1, 0)
    Card.Position = UDim2.fromOffset(x, 0)
    Card.BackgroundColor3 = C.Card
    Card.BackgroundTransparency = 0.08
    Card.BorderSizePixel = 0
    Card.ZIndex = 20
    Card.Parent = Content
    corner(Card, 12)
    stroke(Card, C.Purple, 0.72, 1)

    local Heading = Instance.new("TextLabel")
    Heading.Size = UDim2.new(1, -24, 0, 26)
    Heading.Position = UDim2.fromOffset(12, 7)
    Heading.BackgroundTransparency = 1
    Heading.Text = name
    Heading.TextColor3 = C.BrightPurple
    Heading.TextSize = 11
    Heading.Font = Enum.Font.GothamBold
    Heading.TextXAlignment = Enum.TextXAlignment.Left
    Heading.ZIndex = 22
    Heading.Parent = Card

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(0, 25, 0, 2)
    Line.Position = UDim2.fromOffset(12, 30)
    Line.BackgroundColor3 = C.BrightPurple
    Line.BorderSizePixel = 0
    Line.ZIndex = 22
    Line.Parent = Card
    corner(Line, 4)

    local F = Instance.new("ScrollingFrame")
    F.Size = UDim2.new(1, -16, 1, -47)
    F.Position = UDim2.fromOffset(8, 42)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0
    F.ScrollBarThickness = 2
    F.ScrollBarImageColor3 = C.Purple
    F.ScrollBarImageTransparency = 0.35
    F.ZIndex = 21
    F.AutomaticCanvasSize = Enum.AutomaticSize.Y
    F.CanvasSize = UDim2.new(0, 0, 0, 0)
    F.Parent = Card

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 7)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = F

    return F, Card
end

local ColC, CardC = makeCol("COMBAT", 0)
local ColM, CardM = makeCol("MOVEMENT", 171)
local ColR, CardR = makeCol("RENDER", 342)
local ColX, CardX = makeCol("MISC", 513)

-- PANEL
local Panel = Instance.new("Frame")
Panel.Name = "SettingsPanel"
Panel.Size = UDim2.new(0, 280, 0, 390)
Panel.Position = UDim2.new(1, 15, 0, 72)
Panel.BackgroundColor3 = C.Card
Panel.BorderSizePixel = 0
Panel.Visible = false
Panel.ZIndex = 50
Panel.Parent = Main
corner(Panel, 14)
stroke(Panel, C.Purple, 0.4, 1)

local PanelHeader = Instance.new("Frame")
PanelHeader.Size = UDim2.new(1, 0, 0, 46)
PanelHeader.BackgroundColor3 = Color3.fromRGB(25, 17, 36)
PanelHeader.BorderSizePixel = 0
PanelHeader.ZIndex = 51
PanelHeader.Parent = Panel
corner(PanelHeader, 14)

local PanelTitle = Instance.new("TextLabel")
PanelTitle.Size = UDim2.new(1, -25, 1, 0)
PanelTitle.Position = UDim2.fromOffset(15, 0)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Text = "Settings"
PanelTitle.TextColor3 = C.Text
PanelTitle.TextSize = 13
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.ZIndex = 52
PanelTitle.Parent = PanelHeader

local PanelScroll = Instance.new("ScrollingFrame")
PanelScroll.Size = UDim2.new(1, -18, 1, -58)
PanelScroll.Position = UDim2.fromOffset(9, 52)
PanelScroll.BackgroundTransparency = 1
PanelScroll.BorderSizePixel = 0
PanelScroll.ScrollBarThickness = 2
PanelScroll.ScrollBarImageColor3 = C.Purple
PanelScroll.ZIndex = 51
PanelScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PanelScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PanelScroll.Parent = Panel

local PanelLayout = Instance.new("UIListLayout")
PanelLayout.Padding = UDim.new(0, 9)
PanelLayout.Parent = PanelScroll

local function makeSlider(parent, label, minV, maxV, currentV, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 53)
    Container.BackgroundTransparency = 1
    Container.ZIndex = 55
    Container.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 19)
    Label.BackgroundTransparency = 1
    Label.Text = label .. ": " .. string.format("%.2f", currentV)
    Label.TextColor3 = C.SubText
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 56
    Label.Parent = Container

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(1, 0, 0, 8)
    Bg.Position = UDim2.fromOffset(0, 28)
    Bg.BackgroundColor3 = C.Background
    Bg.BorderSizePixel = 0
    Bg.ZIndex = 56
    Bg.Parent = Container
    corner(Bg, 10)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(math.clamp((currentV - minV) / (maxV - minV), 0, 1), 0, 1, 0)
    Fill.BackgroundColor3 = C.BrightPurple
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 57
    Fill.Parent = Bg
    corner(Fill, 10)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(12, 12)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(math.clamp((currentV - minV) / (maxV - minV), 0, 1), 0, 0.5, 0)
    Knob.BackgroundColor3 = C.Text
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 58
    Knob.Parent = Bg
    corner(Knob, 20)

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
        tween(Fill, T.Fast, { Size = UDim2.new(rel, 0, 1, 0) })
        tween(Knob, T.Fast, { Position = UDim2.new(rel, 0, 0.5, 0) })
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local currentOpen = nil

local function clearPanel()
    for _, child in ipairs(PanelScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function openSettings(name, key)
    if currentOpen == name then
        currentOpen = nil
        Panel.Visible = false
        Panel.Position = UDim2.new(1, 15, 0, 72)
        return
    end

    currentOpen = name
    PanelTitle.Text = name .. " Settings"
    clearPanel()

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
    elseif name == "Motion Blur" then
        makeSlider(PanelScroll, "Strength", 1, 30, S.MotionBlurStrength, function(v) S.MotionBlurStrength = v end)
    elseif name == "Saturation" then
        makeSlider(PanelScroll, "Saturation", 0, 3, S.SaturationValue, function(v) S.SaturationValue = v end)
    else
        local Info = Instance.new("TextLabel")
        Info.Size = UDim2.new(1, 0, 0, 40)
        Info.BackgroundTransparency = 1
        Info.Text = "Для этой функции\nнет дополнительных настроек"
        Info.TextColor3 = C.SubText
        Info.TextSize = 11
        Info.Font = Enum.Font.Gotham
        Info.TextWrapped = true
        Info.ZIndex = 55
        Info.Parent = PanelScroll
    end

    Panel.Visible = true
    Panel.Position = UDim2.new(1, 15, 0, 72)
    tween(Panel, T.Smooth, { Position = UDim2.new(1, -260, 0, 72) })
end

-- BUTTON
local function makeBtn(parent, name, key)
    local B = Instance.new("TextButton")
    B.Name = key
    B.Size = UDim2.new(1, -5, 0, 38)
    B.BackgroundColor3 = C.Card
    B.BackgroundTransparency = 0.08
    B.BorderSizePixel = 0
    B.Text = ""
    B.AutoButtonColor = false
    B.ClipsDescendants = true
    B.ZIndex = 25
    B.Parent = parent
    corner(B, 10)

    local Border = stroke(B, C.Purple, 0.84, 1)

    local Side = Instance.new("Frame")
    Side.Size = UDim2.fromOffset(2, 0)
    Side.Position = UDim2.new(0, 0, 0.5, 0)
    Side.AnchorPoint = Vector2.new(0, 0.5)
    Side.BackgroundColor3 = C.BrightPurple
    Side.BorderSizePixel = 0
    Side.ZIndex = 28
    Side.Parent = B

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.Position = UDim2.fromOffset(14, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = S[key] == true and C.BrightPurple or C.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 29
    Label.Parent = B

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.fromOffset(6, 6)
    Indicator.Position = UDim2.new(1, -15, 0.5, -3)
    Indicator.BackgroundColor3 = S[key] == true and C.BrightPurple or C.SoftPurple
    Indicator.BackgroundTransparency = S[key] == true and 0 or 0.5
    Indicator.BorderSizePixel = 0
    Indicator.ZIndex = 29
    Indicator.Parent = B
    corner(Indicator, 8)

    B.MouseEnter:Connect(function()
        tween(B, T.Soft, { BackgroundColor3 = Color3.fromRGB(31, 18, 46) })
        tween(Border, T.Soft, { Transparency = 0.28 })
        tween(Side, T.Soft, { Size = UDim2.fromOffset(3, 28) })
        showTooltip(DESCRIPTIONS[key] or name)
    end)

    B.MouseLeave:Connect(function()
        tween(B, T.Soft, { BackgroundColor3 = C.Card })
        tween(Border, T.Soft, { Transparency = 0.84 })
        tween(Side, T.Soft, { Size = UDim2.fromOffset(2, 0) })
        hideTooltip()
    end)

    B.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        local active = S[key] == true

        tween(B, T.Soft, { BackgroundColor3 = active and Color3.fromRGB(31, 18, 46) or C.Card })
        tween(Label, T.Soft, { TextColor3 = active and C.BrightPurple or C.Text })
        tween(Indicator, T.Soft, { BackgroundColor3 = active and C.BrightPurple or C.SoftPurple, BackgroundTransparency = active and 0 or 0.5 })

        local flash = Instance.new("Frame")
        flash.Size = UDim2.fromScale(0, 1)
        flash.BackgroundColor3 = C.BrightPurple
        flash.BackgroundTransparency = 0.7
        flash.BorderSizePixel = 0
        flash.ZIndex = 27
        flash.Parent = B
        tween(flash, TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1
        })
        Debris:AddItem(flash, 0.7)

        print("[PromtMZ]", name, "=", tostring(S[key]))
    end)

    B.MouseButton2Click:Connect(function()
        openSettings(name, key)
    end)
end

-- BUTTONS
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
makeBtn(ColR, "Chams", "Chams")
makeBtn(ColR, "TargetHUD", "TargetHUD")
makeBtn(ColR, "Music", "Music")
makeBtn(ColR, "Aspect 4:3", "AspectRatio")
makeBtn(ColR, "Motion Blur", "MotionBlur")
makeBtn(ColR, "Optimization", "Optimization")
makeBtn(ColR, "Saturation", "Saturation")

makeBtn(ColX, "AntiAFK", "AntiAFK")
makeBtn(ColX, "AutoClick", "AutoClick")
makeBtn(ColX, "Console", "Console")

-- CONSOLE
local ConsoleGui = Instance.new("ScreenGui")
ConsoleGui.Name = "PromtMZ_Console"
ConsoleGui.ResetOnSpawn = false
pcall(function() ConsoleGui.Parent = game.CoreGui end)

local ConsoleFrame = Instance.new("Frame")
ConsoleFrame.Size = UDim2.fromOffset(600, 400)
ConsoleFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
ConsoleFrame.BackgroundColor3 = C.Background
ConsoleFrame.BorderSizePixel = 0
ConsoleFrame.Visible = false
ConsoleFrame.ZIndex = 100
ConsoleFrame.Parent = ConsoleGui
corner(ConsoleFrame, 14)
stroke(ConsoleFrame, C.Purple, 0.5, 1)

local ConsoleHeader = Instance.new("Frame")
ConsoleHeader.Size = UDim2.new(1, 0, 0, 36)
ConsoleHeader.BackgroundColor3 = C.Card
ConsoleHeader.BorderSizePixel = 0
ConsoleHeader.ZIndex = 101
ConsoleHeader.Parent = ConsoleFrame
corner(ConsoleHeader, 14)

local ConsoleTitle = Instance.new("TextLabel")
ConsoleTitle.Size = UDim2.new(1, -60, 1, 0)
ConsoleTitle.Position = UDim2.fromOffset(15, 0)
ConsoleTitle.BackgroundTransparency = 1
ConsoleTitle.Text = "Console"
ConsoleTitle.TextColor3 = C.Text
ConsoleTitle.TextSize = 13
ConsoleTitle.Font = Enum.Font.GothamBold
ConsoleTitle.TextXAlignment = Enum.TextXAlignment.Left
ConsoleTitle.ZIndex = 102
ConsoleTitle.Parent = ConsoleHeader

local ConsoleClose = Instance.new("TextButton")
ConsoleClose.Size = UDim2.fromOffset(30, 30)
ConsoleClose.Position = UDim2.new(1, -36, 0, 3)
ConsoleClose.BackgroundTransparency = 1
ConsoleClose.Text = "×"
ConsoleClose.TextColor3 = C.SubText
ConsoleClose.TextSize = 20
ConsoleClose.Font = Enum.Font.GothamBold
ConsoleClose.AutoButtonColor = false
ConsoleClose.ZIndex = 102
ConsoleClose.Parent = ConsoleHeader

ConsoleClose.MouseButton1Click:Connect(function()
    ConsoleFrame.Visible = false
    S.Console = false
end)

local ConsoleOutput = Instance.new("ScrollingFrame")
ConsoleOutput.Size = UDim2.new(1, -20, 1, -90)
ConsoleOutput.Position = UDim2.fromOffset(10, 42)
ConsoleOutput.BackgroundTransparency = 1
ConsoleOutput.BorderSizePixel = 0
ConsoleOutput.ScrollBarThickness = 4
ConsoleOutput.ScrollBarImageColor3 = C.Purple
ConsoleOutput.AutomaticCanvasSize = Enum.AutomaticSize.Y
ConsoleOutput.CanvasSize = UDim2.new(0, 0, 0, 0)
ConsoleOutput.ZIndex = 101
ConsoleOutput.Parent = ConsoleFrame

local ConsoleLayout = Instance.new("UIListLayout")
ConsoleLayout.Padding = UDim.new(0, 4)
ConsoleLayout.Parent = ConsoleOutput

local ConsoleInput = Instance.new("TextBox")
ConsoleInput.Size = UDim2.new(1, -20, 0, 34)
ConsoleInput.Position = UDim2.new(0, 10, 1, -44)
ConsoleInput.BackgroundColor3 = C.Card
ConsoleInput.BorderSizePixel = 0
ConsoleInput.Text = ""
ConsoleInput.PlaceholderText = "Введите команду..."
ConsoleInput.TextColor3 = C.Text
ConsoleInput.PlaceholderColor3 = C.SubText
ConsoleInput.TextSize = 12
ConsoleInput.Font = Enum.Font.Gotham
ConsoleInput.TextXAlignment = Enum.TextXAlignment.Left
ConsoleInput.ClearTextOnFocus = false
ConsoleInput.ZIndex = 102
ConsoleInput.Parent = ConsoleFrame
corner(ConsoleInput, 8)
stroke(ConsoleInput, C.Purple, 0.6, 1)

local function consolePrint(text, color)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, 0, 0, 18)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = color or C.Text
    L.TextSize = 11
    L.Font = Enum.Font.Code
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.TextWrapped = true
    L.ZIndex = 101
    L.Parent = ConsoleOutput
end

_G.PromtMZ.Console = { print = consolePrint }

ConsoleInput.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local cmd = ConsoleInput.Text
    if cmd == "" then return end
    ConsoleInput.Text = ""
    consolePrint("> " .. cmd, C.BrightPurple)

    local args = {}
    for word in cmd:gmatch("%S+") do table.insert(args, word) end

    if args[1] == "help" then
        consolePrint("Команды: help, clear, toggle <функция>, set <параметр> <значение>", C.SubText)
    elseif args[1] == "clear" then
        for _, child in ipairs(ConsoleOutput:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
    elseif args[1] == "toggle" and args[2] then
        local key = args[2]
        if S[key] ~= nil and type(S[key]) == "boolean" then
            S[key] = not S[key]
            consolePrint("[OK] " .. key .. " = " .. tostring(S[key]), C.BrightPurple)
        else
            consolePrint("[ERR] Функция не найдена: " .. key, Color3.fromRGB(205, 95, 80))
        end
    elseif args[1] == "set" and args[2] and args[3] then
        local key = args[2]
        local val = tonumber(args[3])
        if val and S[key] ~= nil then
            S[key] = val
            consolePrint("[OK] " .. key .. " = " .. val, C.BrightPurple)
        else
            consolePrint("[ERR] Неверный параметр или значение", Color3.fromRGB(205, 95, 80))
        end
    else
        consolePrint("[ERR] Неизвестная команда", Color3.fromRGB(205, 95, 80))
    end
end)

RunService.RenderStepped:Connect(function()
    if S.Console and not ConsoleFrame.Visible then
        ConsoleFrame.Visible = true
    elseif not S.Console and ConsoleFrame.Visible then
        ConsoleFrame.Visible = false
    end
end)

-- SMOOTH MATH
local function SmoothVal(current, target, speed, dt)
    local alpha = 1 - math.exp(-speed * dt)
    return current + (target - current) * alpha
end

-- PARTICLES
local Particles = {}
for i = 1, CONFIG.ParticleCount do
    local p = Instance.new("Frame")
    local size = math.random(1, 3)
    p.Size = UDim2.fromOffset(size, size)
    p.Position = UDim2.fromScale(math.random(), math.random())
    p.BackgroundColor3 = i % 3 == 0 and C.BrightPurple or C.Purple
    p.BackgroundTransparency = math.random(45, 80) / 100
    p.BorderSizePixel = 0
    p.ZIndex = 6
    p.Parent = Main
    corner(p, 999)
    table.insert(Particles, {
        Object = p,
        Speed = math.random(5, 15) / 100,
        Offset = math.random(),
        Direction = math.random(0, 1) == 0 and -1 or 1,
    })
end

-- ORBS
local Orbs = {}
for i = 1, CONFIG.PlasmaCount do
    local o = Instance.new("Frame")
    local size = math.random(3, 6)
    o.Size = UDim2.fromOffset(size, size)
    o.Position = UDim2.fromScale(math.random(), math.random())
    o.BackgroundColor3 = C.BrightPurple
    o.BackgroundTransparency = 0.35
    o.BorderSizePixel = 0
    o.ZIndex = 8
    o.Parent = Main
    corner(o, 999)
    table.insert(Orbs, {
        Object = o,
        Angle = math.random() * math.pi * 2,
        Radius = math.random(45, 140),
        Speed = math.random(15, 35) / 100,
        CenterX = math.random(25, 75) / 100,
        CenterY = math.random(25, 75) / 100,
    })
end

-- MAIN ANIMATION
local Time = 0
local MouseX, MouseY = 0, 0
local TargetMouseX, TargetMouseY = 0, 0

RunService.RenderStepped:Connect(function(dt)
    dt = math.clamp(dt, 0, 1 / 30)
    Time += dt * CONFIG.AnimationSpeed

    local Camera = workspace.CurrentCamera
    if Camera then
        local Mouse = UIS:GetMouseLocation()
        local Viewport = Camera.ViewportSize
        TargetMouseX = (Mouse.X / Viewport.X - 0.5) * CONFIG.ParallaxStrength
        TargetMouseY = (Mouse.Y / Viewport.Y - 0.5) * CONFIG.ParallaxStrength
    end
    MouseX = SmoothVal(MouseX, TargetMouseX, 2, dt)
    MouseY = SmoothVal(MouseY, TargetMouseY, 2, dt)

    Glow1.Position = UDim2.new(0.78 + MouseX * 0.012, -135, 0.3 + MouseY * 0.012, -135)
    Glow2.Position = UDim2.new(0.12 - MouseX * 0.009, -105, 0.82 - MouseY * 0.009, -105)

    for _, data in ipairs(Particles) do
        local obj = data.Object
        if obj.Parent then
            local x = obj.Position.X.Scale
            local y = obj.Position.Y.Scale
            local targetX = x + data.Direction * data.Speed * dt * 0.035
            local wave = math.sin(Time * 1.1 + data.Offset * 10) * 0.00018
            local targetY = y + wave
            if targetX > 1.05 then targetX = -0.05 end
            if targetX < -0.05 then targetX = 1.05 end
            obj.Position = UDim2.new(SmoothVal(x, targetX, 2.2, dt), 0, SmoothVal(y, targetY, 2.2, dt), 0)
        end
    end

    for _, data in ipairs(Orbs) do
        local obj = data.Object
        if obj.Parent then
            data.Angle += data.Speed * dt * CONFIG.AnimationSpeed
            local targetX = data.CenterX + math.cos(data.Angle) * (data.Radius / CONFIG.Width)
            local targetY = data.CenterY + math.sin(data.Angle * 1.15) * (data.Radius / CONFIG.Height)
            local x = obj.Position.X.Scale
            local y = obj.Position.Y.Scale
            obj.Position = UDim2.fromScale(SmoothVal(x, targetX, 2, dt), SmoothVal(y, targetY, 2, dt))
            local pulse = (math.sin(Time * 1.35 + data.Angle) + 1) * 0.5
            obj.BackgroundTransparency = SmoothVal(obj.BackgroundTransparency, 0.25 + pulse * 0.45, 1.4, dt)
        end
    end

    Gradient.Rotation = SmoothVal(Gradient.Rotation, 35 + math.sin(Time * 0.18) * 18, 1, dt)

    local GlowPulse = (math.sin(Time * 0.7) + 1) * 0.5
    Glow1.BackgroundTransparency = SmoothVal(Glow1.BackgroundTransparency, 0.91 - GlowPulse * 0.055, 1.5, dt)
    Glow2.BackgroundTransparency = SmoothVal(Glow2.BackgroundTransparency, 0.94 - GlowPulse * 0.035, 1.3, dt)

    local BorderPulse = (math.sin(Time * 0.55) + 1) * 0.5
    MainStroke.Transparency = SmoothVal(MainStroke.Transparency, 0.27 + BorderPulse * 0.28, 1.3, dt)

    local TargetLine = (Time * 45 % (CONFIG.Width + 280)) - 280
    EnergyLine.Position = UDim2.fromOffset(SmoothVal(EnergyLine.Position.X.Offset, TargetLine, 2.2, dt), 59)
end)

-- OPEN / CLOSE
local opened = false

local function open()
    if opened then return end
    opened = true

    Main.Visible = true
    Shadow.Visible = true

    Main.Position = UDim2.new(0.5, 0, 1.08, 0)
    Main.Size = UDim2.fromOffset(145, 50)
    Main.BackgroundTransparency = 0.15
    Shadow.Position = UDim2.new(0.5, 9, 1.08, 10)
    Shadow.Size = UDim2.fromOffset(165, 60)
    Shadow.BackgroundTransparency = 0.55

    tween(Main, T.Open, {
        Position = FinalPosition,
        Size = UDim2.fromOffset(CONFIG.Width, CONFIG.Height),
        BackgroundTransparency = 0
    })
    tween(Shadow, T.Open, {
        Position = FinalPosition + UDim2.fromOffset(9, 10),
        Size = UDim2.fromOffset(CONFIG.Width + 20, CONFIG.Height + 20),
        BackgroundTransparency = 0.3
    })
    tween(Blur, TweenInfo.new(0.5, Enum.EasingStyle.Quint), { Size = 18 })
end

local function close()
    if not opened then return end
    opened = false
    currentOpen = nil
    Panel.Visible = false
    hideTooltip()

    tween(Main, T.Close, {
        Position = UDim2.new(0.5, 0, 1.08, 0),
        Size = UDim2.fromOffset(145, 50),
        BackgroundTransparency = 0.15
    })
    tween(Shadow, T.Close, {
        Position = UDim2.new(0.5, 9, 1.08, 10),
        Size = UDim2.fromOffset(165, 60),
        BackgroundTransparency = 0.55
    })
    tween(Blur, TweenInfo.new(0.5, Enum.EasingStyle.Quint), { Size = 0 })

    task.delay(0.8, function()
        if not opened then
            Main.Visible = false
            Shadow.Visible = false
        end
    end)
end

-- DRAG
local Dragging = false
local DragStart
local StartPosition
local DragTarget = Vector2.zero
local DragCurrent = Vector2.zero

Header.InputBegan:Connect(function(Input)
    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    Dragging = true
    DragStart = Input.Position
    StartPosition = Main.Position
    DragTarget = Vector2.zero
end)

UIS.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local Delta = Input.Position - DragStart
    DragTarget = Vector2.new(Delta.X, Delta.Y)
end)

UIS.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
        DragTarget = Vector2.zero
    end
end)

RunService.RenderStepped:Connect(function(dt)
    DragCurrent = DragCurrent:Lerp(DragTarget, 1 - math.exp(-12 * dt))
    if Dragging then
        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + DragCurrent.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + DragCurrent.Y
        )
    end
    Shadow.Position = UDim2.new(
        Main.Position.X.Scale,
        Main.Position.X.Offset + 9,
        Main.Position.Y.Scale,
        Main.Position.Y.Offset + 10
    )
end)

-- HOTKEYS
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Two then
        if opened then close() else open() end
    end
end)

-- HUD
local HudGui = Instance.new("ScreenGui")
HudGui.Name = "PromtMZ_HUD"
HudGui.ResetOnSpawn = false
pcall(function() HudGui.Parent = game.CoreGui end)

local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.fromOffset(250, 36)
Watermark.Position = UDim2.fromOffset(14, 14)
Watermark.BackgroundColor3 = C.Background
Watermark.BackgroundTransparency = 0.08
Watermark.BorderSizePixel = 0
Watermark.TextColor3 = C.Text
Watermark.TextSize = 12
Watermark.Font = Enum.Font.GothamBold
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.Visible = false
Watermark.Parent = HudGui
corner(Watermark, 10)
stroke(Watermark, C.Purple, 0.4, 1)

local ActiveFrame = Instance.new("Frame")
ActiveFrame.Size = UDim2.fromOffset(205, 300)
ActiveFrame.Position = UDim2.new(1, -220, 0, 14)
ActiveFrame.BackgroundColor3 = C.Background
ActiveFrame.BackgroundTransparency = 0.08
ActiveFrame.BorderSizePixel = 0
ActiveFrame.Visible = false
ActiveFrame.Parent = HudGui
corner(ActiveFrame, 12)
stroke(ActiveFrame, C.Purple, 0.4, 1)

local hudLabels = {}
RunService.RenderStepped:Connect(function()
    Watermark.Visible = S.HUD
    ActiveFrame.Visible = S.HUD
    if not S.HUD then
        for _, l in ipairs(hudLabels) do l:Destroy() end
        hudLabels = {}
        return
    end
    Watermark.Text = "  PromtMZ  •  " .. LP.Name
    for _, l in ipairs(hudLabels) do l:Destroy() end
    hudLabels = {}
    local y = 10
    for k, v in pairs(S) do
        if v == true and type(k) == "string" and k ~= "HUD" and k ~= "Fog" and k ~= "Fullbright" then
            local L = Instance.new("TextLabel")
            L.Size = UDim2.new(1, -20, 0, 19)
            L.Position = UDim2.fromOffset(10, y)
            L.BackgroundTransparency = 1
            L.Text = "•  " .. k
            L.TextColor3 = C.SubText
            L.TextSize = 11
            L.Font = Enum.Font.Gotham
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Parent = ActiveFrame
            table.insert(hudLabels, L)
            y += 20
        end
    end
end)

print("[PromtMZ] Black & Purple Ultra Smooth GUI загружен (Chams + TargetHUD + Music + Aspect4:3 + MotionBlur + Optimization + Console + Tooltips + Saturation)")
