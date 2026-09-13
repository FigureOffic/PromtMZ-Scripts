-- main.lua — PromtMZ Cozy Beige UI (Chams + TargetHUD + Music + Aspect4:3 + MotionBlur + Optimization + Console + Tooltips)
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
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

-- Описания функций для подсказок
local DESCRIPTIONS = {
    KillAura = "Автоматически бьёт ближайшего игрока в радиусе",
    Aimbot = "Наводит прицел на ближайшего игрока (сначала без стены)",
    FarAim = "Наводит прицел на игроков на большой дистанции",
    AutoShot = "Стреляет, пока прицел наведён на голову цели",
    Reach = "Увеличивает дистанцию удара",
    SpinBot = "Вращает персонажа вокруг оси (обход античита)",
    Magnet = "Притягивает тебя к ближайшему игроку",
    TP = "Телепортирует к ближайшему игроку",
    Speed = "Увеличивает скорость передвижения",
    Fly = "Позволяет летать (WASD + Space/Shift)",
    Jump = "Увеличивает высоту прыжка",
    Noclip = "Проходишь сквозь блоки и стены",
    BunnyHop = "Авто-прыжки с ускорением",
    LeaveTp = "Телепорт рывками (blink-режим)",
    Fog = "Атмосферный туман с настройками",
    Fullbright = "Максимальная яркость (видно ночью)",
    HUD = "Показывает Watermark и активные функции",
    ESP = "Ники и HP игроков над головой",
    Skeleton = "Скелет игрока (линии по костям)",
    Box = "Рамка вокруг игроков",
    ChinaHat = "Красная шляпа над головой",
    Particles = "Круги при прыжке и взрыв при клике",
    Chams = "Глянцевая заливка игроков (видно сквозь стены)",
    TargetHUD = "Инфо о цели: аватар, ник, HP",
    Music = "Music Bar в стиле YouTube Music",
    AspectRatio = "Соотношение экрана 4:3 (узкий FOV)",
    MotionBlur = "Размытие при быстром движении камеры",
    Optimization = "Отключает тяжёлые эффекты для FPS",
    Console = "Окно консоли для команд",
    Saturation = "Насыщенность цветов",
    AntiAFK = "Авто-действия чтобы не кикнуло за АФК",
    AutoClick = "Авто-клики ЛКМ",
}

-- COLORS
local C = {
    Cream       = Color3.fromRGB(250, 246, 238),
    Cream2      = Color3.fromRGB(246, 240, 229),
    Cream3      = Color3.fromRGB(238, 229, 214),
    Beige       = Color3.fromRGB(224, 205, 178),
    Beige2      = Color3.fromRGB(211, 188, 155),
    BeigeDark   = Color3.fromRGB(178, 148, 111),
    Warm        = Color3.fromRGB(196, 157, 112),
    WarmDark    = Color3.fromRGB(157, 119, 82),
    Text        = Color3.fromRGB(67, 56, 45),
    TextSoft    = Color3.fromRGB(119, 104, 88),
    Muted       = Color3.fromRGB(154, 139, 121),
    White       = Color3.fromRGB(255, 252, 246),
    Off         = Color3.fromRGB(235, 227, 216),
    On          = Color3.fromRGB(210, 177, 137),
    OnText      = Color3.fromRGB(65, 48, 32),
    Shadow      = Color3.fromRGB(83, 66, 48)
}

local T = {
    Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Soft = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Open = TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Close = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
    Press = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
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
pcall(function() Gui.Parent = game.CoreGui end)

-- SHADOW
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(0, 700, 0, 450)
Shadow.Position = UDim2.new(0.5, -342, 0.5, -217)
Shadow.BackgroundColor3 = C.Shadow
Shadow.BackgroundTransparency = 0.9
Shadow.BorderSizePixel = 0
Shadow.Visible = false
Shadow.ZIndex = 0
Shadow.Parent = Gui
corner(Shadow, 20)

-- MAIN
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 700, 0, 450)
Main.Position = UDim2.new(0.5, -350, 0.5, -225)
Main.BackgroundColor3 = C.Cream
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 2
Main.Parent = Gui
corner(Main, 18)
stroke(Main, C.Beige, 0.35, 1)

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundColor3 = C.Cream2
Header.BorderSizePixel = 0
Header.ZIndex = 5
Header.Parent = Main
corner(Header, 18)

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, -34, 0, 1)
HeaderLine.Position = UDim2.new(0, 17, 1, -1)
HeaderLine.BackgroundColor3 = C.Beige
HeaderLine.BackgroundTransparency = 0.35
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 6
HeaderLine.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 220, 1, 0)
Title.Position = UDim2.new(0, 19, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PromtMZ"
Title.TextColor3 = C.Text
Title.TextSize = 21
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 7
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 300, 0, 18)
Subtitle.Position = UDim2.new(0, 20, 0, 35)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "cozy control panel"
Subtitle.TextColor3 = C.Muted
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 7
Subtitle.Parent = Header

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 7, 0, 7)
Dot.Position = UDim2.new(1, -25, 0, 25)
Dot.BackgroundColor3 = C.Warm
Dot.BorderSizePixel = 0
Dot.ZIndex = 7
Dot.Parent = Header
corner(Dot, 10)

-- TOOLTIP (подсказка над меню)
local Tooltip = Instance.new("TextLabel")
Tooltip.Size = UDim2.new(0, 400, 0, 32)
Tooltip.Position = UDim2.new(0.5, -200, 0, -45)
Tooltip.BackgroundColor3 = C.Cream2
Tooltip.BackgroundTransparency = 0.05
Tooltip.BorderSizePixel = 0
Tooltip.Text = ""
Tooltip.TextColor3 = C.Text
Tooltip.TextSize = 12
Tooltip.Font = Enum.Font.GothamMedium
Tooltip.TextWrapped = true
Tooltip.Visible = false
Tooltip.ZIndex = 20
Tooltip.Parent = Main
corner(Tooltip, 10)
stroke(Tooltip, C.Beige2, 0.35, 1)

local function showTooltip(text)
    if not text or text == "" then
        Tooltip.Visible = false
        return
    end
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
Content.Size = UDim2.new(1, -28, 1, -75)
Content.Position = UDim2.new(0, 14, 0, 68)
Content.BackgroundTransparency = 1
Content.ZIndex = 3
Content.Parent = Main

local function makeCol(name, x)
    local Card = Instance.new("Frame")
    Card.Name = name
    Card.Size = UDim2.new(0, 157, 1, 0)
    Card.Position = UDim2.new(0, x, 0, 0)
    Card.BackgroundColor3 = C.Cream2
    Card.BorderSizePixel = 0
    Card.ZIndex = 3
    Card.Parent = Content
    corner(Card, 13)
    stroke(Card, C.Beige, 0.48, 1)

    local Heading = Instance.new("TextLabel")
    Heading.Size = UDim2.new(1, -24, 0, 28)
    Heading.Position = UDim2.new(0, 12, 0, 7)
    Heading.BackgroundTransparency = 1
    Heading.Text = name
    Heading.TextColor3 = C.WarmDark
    Heading.TextSize = 11
    Heading.Font = Enum.Font.GothamBold
    Heading.TextXAlignment = Enum.TextXAlignment.Left
    Heading.ZIndex = 5
    Heading.Parent = Card

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(0, 25, 0, 2)
    Line.Position = UDim2.new(0, 12, 0, 31)
    Line.BackgroundColor3 = C.Beige2
    Line.BorderSizePixel = 0
    Line.ZIndex = 5
    Line.Parent = Card
    corner(Line, 4)

    local F = Instance.new("ScrollingFrame")
    F.Size = UDim2.new(1, -16, 1, -47)
    F.Position = UDim2.new(0, 8, 0, 42)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0
    F.ScrollBarThickness = 2
    F.ScrollBarImageColor3 = C.BeigeDark
    F.ScrollBarImageTransparency = 0.35
    F.ZIndex = 4
    F.CanvasSize = UDim2.new(0, 0, 0, 0)
    F.AutomaticCanvasSize = Enum.AutomaticSize.Y
    F.Parent = Card

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 7)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = F

    return F, Card
end

local ColC, CardC = makeCol("COMBAT", 0)
local ColM, CardM = makeCol("MOVEMENT", 166)
local ColR, CardR = makeCol("RENDER", 332)
local ColX, CardX = makeCol("MISC", 498)

-- SETTINGS PANEL
local Panel = Instance.new("Frame")
Panel.Name = "SettingsPanel"
Panel.Size = UDim2.new(0, 270, 0, 382)
Panel.Position = UDim2.new(1, 15, 0, 68)
Panel.BackgroundColor3 = C.Cream
Panel.BorderSizePixel = 0
Panel.Visible = false
Panel.ZIndex = 30
Panel.Parent = Main
corner(Panel, 16)
stroke(Panel, C.Beige2, 0.35, 1)

local PanelHeader = Instance.new("Frame")
PanelHeader.Size = UDim2.new(1, 0, 0, 49)
PanelHeader.BackgroundColor3 = C.Cream2
PanelHeader.BorderSizePixel = 0
PanelHeader.ZIndex = 31
PanelHeader.Parent = Panel
corner(PanelHeader, 16)

local PanelTitle = Instance.new("TextLabel")
PanelTitle.Size = UDim2.new(1, -25, 1, 0)
PanelTitle.Position = UDim2.new(0, 15, 0, 0)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Text = "Settings"
PanelTitle.TextColor3 = C.Text
PanelTitle.TextSize = 14
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.ZIndex = 32
PanelTitle.Parent = PanelHeader

local PanelDot = Instance.new("Frame")
PanelDot.Size = UDim2.new(0, 6, 0, 6)
PanelDot.Position = UDim2.new(1, -17, 0, 22)
PanelDot.BackgroundColor3 = C.Warm
PanelDot.BorderSizePixel = 0
PanelDot.ZIndex = 32
PanelDot.Parent = PanelHeader
corner(PanelDot, 6)

local PanelScroll = Instance.new("ScrollingFrame")
PanelScroll.Size = UDim2.new(1, -18, 1, -61)
PanelScroll.Position = UDim2.new(0, 9, 0, 54)
PanelScroll.BackgroundTransparency = 1
PanelScroll.BorderSizePixel = 0
PanelScroll.ScrollBarThickness = 2
PanelScroll.ScrollBarImageColor3 = C.BeigeDark
PanelScroll.ZIndex = 31
PanelScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PanelScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PanelScroll.Parent = Panel

local PanelLayout = Instance.new("UIListLayout")
PanelLayout.Padding = UDim.new(0, 9)
PanelLayout.Parent = PanelScroll

-- SLIDER
local function makeSlider(parent, label, minV, maxV, currentV, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 53)
    Container.BackgroundTransparency = 1
    Container.ZIndex = 35
    Container.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 19)
    Label.BackgroundTransparency = 1
    Label.Text = label .. ": " .. string.format("%.2f", currentV)
    Label.TextColor3 = C.TextSoft
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 36
    Label.Parent = Container

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(1, 0, 0, 8)
    Bg.Position = UDim2.new(0, 0, 0, 28)
    Bg.BackgroundColor3 = C.Off
    Bg.BorderSizePixel = 0
    Bg.ZIndex = 36
    Bg.Parent = Container
    corner(Bg, 10)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(math.clamp((currentV - minV) / (maxV - minV), 0, 1), 0, 1, 0)
    Fill.BackgroundColor3 = C.Warm
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 37
    Fill.Parent = Bg
    corner(Fill, 10)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(math.clamp((currentV - minV) / (maxV - minV), 0, 1), 0, 0.5, 0)
    Knob.BackgroundColor3 = C.White
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 38
    Knob.Parent = Bg
    corner(Knob, 20)
    stroke(Knob, C.Beige2, 0.1, 1)

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

-- SETTINGS OPEN
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
        Panel.Position = UDim2.new(1, 15, 0, 68)
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
        Info.TextColor3 = C.Muted
        Info.TextSize = 11
        Info.Font = Enum.Font.Gotham
        Info.TextWrapped = true
        Info.ZIndex = 35
        Info.Parent = PanelScroll
    end

    Panel.Visible = true
    Panel.Position = UDim2.new(1, 15, 0, 68)
    tween(Panel, T.Open, { Position = UDim2.new(1, -250, 0, 68) })
end

-- BUTTONS
local function makeBtn(parent, name, key)
    local B = Instance.new("TextButton")
    B.Name = key
    B.Size = UDim2.new(1, 0, 0, 34)
    B.BackgroundColor3 = S[key] == true and C.On or C.Off
    B.BorderSizePixel = 0
    B.Text = ""
    B.AutoButtonColor = false
    B.Active = true
    B.ZIndex = 10
    B.Parent = parent

    corner(B, 9)
    local Border = stroke(B, C.Beige, 0.5, 1)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = S[key] == true and C.OnText or C.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = B

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 6, 0, 6)
    Indicator.Position = UDim2.new(1, -15, 0.5, -3)
    Indicator.BackgroundColor3 = S[key] == true and C.WarmDark or C.BeigeDark
    Indicator.BackgroundTransparency = S[key] == true and 0 or 0.65
    Indicator.BorderSizePixel = 0
    Indicator.ZIndex = 12
    Indicator.Parent = B
    corner(Indicator, 8)

    local baseSize = B.Size

    B.MouseEnter:Connect(function()
        tween(B, T.Soft, { BackgroundColor3 = S[key] and C.On:Lerp(C.White, 0.15) or C.Off:Lerp(C.White, 0.3) })
        tween(B, T.Soft, { Size = UDim2.new(baseSize.X.Scale, baseSize.X.Offset, baseSize.Y.Scale, baseSize.Y.Offset - 1) })
        tween(Border, T.Soft, { Transparency = 0.15 })
        showTooltip(DESCRIPTIONS[key] or name)
    end)

    B.MouseLeave:Connect(function()
        tween(B, T.Soft, { BackgroundColor3 = S[key] and C.On or C.Off, Size = baseSize })
        tween(Border, T.Soft, { Transparency = 0.5 })
        hideTooltip()
    end)

    B.MouseButton1Down:Connect(function()
        tween(B, T.Press, { Size = UDim2.new(baseSize.X.Scale, baseSize.X.Offset - 4, baseSize.Y.Scale, baseSize.Y.Offset - 3) })
    end)

    B.MouseButton1Up:Connect(function()
        tween(B, T.Press, { Size = baseSize })
    end)

    B.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        local active = S[key] == true
        tween(B, T.Soft, { BackgroundColor3 = active and C.On or C.Off })
        tween(Label, T.Soft, { TextColor3 = active and C.OnText or C.Text })
        tween(Indicator, T.Soft, { BackgroundColor3 = active and C.WarmDark or C.BeigeDark, BackgroundTransparency = active and 0 or 0.65 })
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

-- CONSOLE WINDOW
local ConsoleGui = Instance.new("ScreenGui")
ConsoleGui.Name = "PromtMZ_Console"
ConsoleGui.ResetOnSpawn = false
ConsoleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ConsoleGui.Parent = game.CoreGui end)

local ConsoleFrame = Instance.new("Frame")
ConsoleFrame.Name = "ConsoleFrame"
ConsoleFrame.Size = UDim2.new(0, 600, 0, 400)
ConsoleFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ConsoleFrame.BorderSizePixel = 0
ConsoleFrame.Visible = false
ConsoleFrame.ZIndex = 100
ConsoleFrame.Parent = ConsoleGui
corner(ConsoleFrame, 14)
stroke(ConsoleFrame, C.Beige2, 0.5, 1)

local ConsoleHeader = Instance.new("Frame")
ConsoleHeader.Size = UDim2.new(1, 0, 0, 36)
ConsoleHeader.BackgroundColor3 = C.Cream2
ConsoleHeader.BorderSizePixel = 0
ConsoleHeader.ZIndex = 101
ConsoleHeader.Parent = ConsoleFrame
corner(ConsoleHeader, 14)

local ConsoleTitle = Instance.new("TextLabel")
ConsoleTitle.Size = UDim2.new(1, -60, 1, 0)
ConsoleTitle.Position = UDim2.new(0, 15, 0, 0)
ConsoleTitle.BackgroundTransparency = 1
ConsoleTitle.Text = "Console"
ConsoleTitle.TextColor3 = C.Text
ConsoleTitle.TextSize = 13
ConsoleTitle.Font = Enum.Font.GothamBold
ConsoleTitle.TextXAlignment = Enum.TextXAlignment.Left
ConsoleTitle.ZIndex = 102
ConsoleTitle.Parent = ConsoleHeader

local ConsoleClose = Instance.new("TextButton")
ConsoleClose.Size = UDim2.new(0, 30, 0, 30)
ConsoleClose.Position = UDim2.new(1, -36, 0, 3)
ConsoleClose.BackgroundTransparency = 1
ConsoleClose.Text = "×"
ConsoleClose.TextColor3 = C.Muted
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
ConsoleOutput.Position = UDim2.new(0, 10, 0, 42)
ConsoleOutput.BackgroundTransparency = 1
ConsoleOutput.BorderSizePixel = 0
ConsoleOutput.ScrollBarThickness = 4
ConsoleOutput.ScrollBarImageColor3 = C.BeigeDark
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
ConsoleInput.BackgroundColor3 = Color3.fromRGB(35, 30, 26)
ConsoleInput.BorderSizePixel = 0
ConsoleInput.Text = ""
ConsoleInput.PlaceholderText = "Введите команду..."
ConsoleInput.TextColor3 = C.Text
ConsoleInput.PlaceholderColor3 = C.Muted
ConsoleInput.TextSize = 12
ConsoleInput.Font = Enum.Font.Gotham
ConsoleInput.TextXAlignment = Enum.TextXAlignment.Left
ConsoleInput.ClearTextOnFocus = false
ConsoleInput.ZIndex = 102
ConsoleInput.Parent = ConsoleFrame
corner(ConsoleInput, 8)
stroke(ConsoleInput, C.Beige2, 0.6, 1)

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

_G.PromtMZ.Console = {
    print = consolePrint
}

ConsoleInput.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local cmd = ConsoleInput.Text
    if cmd == "" then return end
    ConsoleInput.Text = ""

    consolePrint("> " .. cmd, C.Warm)

    local args = {}
    for word in cmd:gmatch("%S+") do
        table.insert(args, word)
    end

    if args[1] == "help" then
        consolePrint("Доступные команды:", C.WarmDark)
        consolePrint("  help — список команд", C.TextSoft)
        consolePrint("  clear — очистить консоль", C.TextSoft)
        consolePrint("  toggle <функция> — вкл/выкл функцию", C.TextSoft)
        consolePrint("  set <параметр> <значение> — установить значение", C.TextSoft)
    elseif args[1] == "clear" then
        for _, child in ipairs(ConsoleOutput:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        consolePrint("Консоль очищена", C.Warm)
    elseif args[1] == "toggle" and args[2] then
        local key = args[2]
        if S[key] ~= nil and type(S[key]) == "boolean" then
            S[key] = not S[key]
            consolePrint("[OK] " .. key .. " = " .. tostring(S[key]), C.Warm)
        else
            consolePrint("[ERR] Функция не найдена: " .. key, Color3.fromRGB(205, 95, 80))
        end
    elseif args[1] == "set" and args[2] and args[3] then
        local key = args[2]
        local val = tonumber(args[3])
        if val and S[key] ~= nil then
            S[key] = val
            consolePrint("[OK] " .. key .. " = " .. val, C.Warm)
        else
            consolePrint("[ERR] Неверный параметр или значение", Color3.fromRGB(205, 95, 80))
        end
    else
        consolePrint("[ERR] Неизвестная команда: " .. args[1], Color3.fromRGB(205, 95, 80))
    end
end)

RunService.RenderStepped:Connect(function()
    if S.Console and not ConsoleFrame.Visible then
        ConsoleFrame.Visible = true
    elseif not S.Console and ConsoleFrame.Visible then
        ConsoleFrame.Visible = false
    end
end)

-- OPEN / CLOSE
local opened = false

local function open()
    if opened then return end
    opened = true

    Main.Visible = true
    Shadow.Visible = true

    Main.Size = UDim2.new(0, 20, 0, 20)
    Main.Position = UDim2.new(0.5, -10, 0.5, -10)
    Shadow.Size = UDim2.new(0, 20, 0, 20)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)

    tween(Main, T.Open, { Size = UDim2.new(0, 700, 0, 450), Position = UDim2.new(0.5, -350, 0.5, -225) })
    tween(Shadow, T.Open, { Size = UDim2.new(0, 710, 0, 460), Position = UDim2.new(0.5, -347, 0.5, -220), BackgroundTransparency = 0.94 })
    tween(Blur, T.Smooth, { Size = 18 })

    local cards = {CardC, CardM, CardR, CardX}
    for i, card in ipairs(cards) do
        local target = card.Position
        card.Position = UDim2.new(target.X.Scale, target.X.Offset, 0, target.Y.Offset + 18)
        card.BackgroundTransparency = 1
        task.delay(0.08 + (i * 0.055), function()
            if not opened then return end
            tween(card, T.Open, { Position = target, BackgroundTransparency = 0 })
        end)
    end
end

local function close()
    if not opened then return end
    opened = false
    currentOpen = nil
    Panel.Visible = false
    hideTooltip()

    tween(Main, T.Close, { Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0.5, -10, 0.5, -10) })
    tween(Shadow, T.Close, { Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1 })
    tween(Blur, T.Smooth, { Size = 0 })

    task.delay(0.28, function()
        if not opened then
            Main.Visible = false
            Shadow.Visible = false
        end
    end)
end

-- SMOOTH DRAG
local dragging = false
local dragStart
local startPos
local velocity = Vector2.zero
local lastMousePos
local lastTime = os.clock()
local inertiaConnection

local function setWindowPosition(pos)
    Main.Position = pos
    Shadow.Position = UDim2.new(pos.X.Scale, pos.X.Offset + 8, pos.Y.Scale, pos.Y.Offset + 8)
end

local function startInertia()
    if inertiaConnection then
        inertiaConnection:Disconnect()
        inertiaConnection = nil
    end
    local last = os.clock()
    inertiaConnection = RunService.RenderStepped:Connect(function()
        if dragging then return end
        local now = os.clock()
        local dt = math.clamp(now - last, 0, 0.05)
        last = now
        if velocity.Magnitude > 2 then
            local current = Main.Position
            local nextX = current.X.Offset + velocity.X * dt
            local nextY = current.Y.Offset + velocity.Y * dt
            local nextPos = UDim2.new(current.X.Scale, nextX, current.Y.Scale, nextY)
            setWindowPosition(nextPos)
            local friction = math.pow(0.055, dt)
            velocity *= friction
        else
            velocity = Vector2.zero
            if inertiaConnection then
                inertiaConnection:Disconnect()
                inertiaConnection = nil
            end
        end
    end)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    dragging = true
    dragStart = input.Position
    startPos = Main.Position
    lastMousePos = input.Position
    lastTime = os.clock()
    velocity = Vector2.zero
    if inertiaConnection then
        inertiaConnection:Disconnect()
        inertiaConnection = nil
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local now = os.clock()
    local dt = math.max(now - lastTime, 0.001)
    local mousePos = input.Position
    local delta = mousePos - dragStart
    local newPos = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
    setWindowPosition(newPos)
    local movement = mousePos - lastMousePos
    local currentVelocity = movement / dt
    velocity = velocity:Lerp(Vector2.new(
        math.clamp(currentVelocity.X, -2500, 2500),
        math.clamp(currentVelocity.Y, -2500, 2500)
    ), 0.35)
    lastMousePos = mousePos
    lastTime = now
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not dragging then return end
    dragging = false
    velocity *= 0.72
    startInertia()
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
Watermark.Size = UDim2.new(0, 250, 0, 36)
Watermark.Position = UDim2.new(0, 14, 0, 14)
Watermark.BackgroundColor3 = C.Cream
Watermark.BackgroundTransparency = 0.08
Watermark.BorderSizePixel = 0
Watermark.TextColor3 = C.Text
Watermark.TextSize = 12
Watermark.Font = Enum.Font.GothamBold
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.Visible = false
Watermark.Parent = HudGui
corner(Watermark, 10)
stroke(Watermark, C.Beige, 0.35, 1)

local ActiveFrame = Instance.new("Frame")
ActiveFrame.Size = UDim2.new(0, 205, 0, 300)
ActiveFrame.Position = UDim2.new(1, -220, 0, 14)
ActiveFrame.BackgroundColor3 = C.Cream
ActiveFrame.BackgroundTransparency = 0.08
ActiveFrame.BorderSizePixel = 0
ActiveFrame.Visible = false
ActiveFrame.Parent = HudGui
corner(ActiveFrame, 12)
stroke(ActiveFrame, C.Beige, 0.35, 1)

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
            L.Position = UDim2.new(0, 10, 0, y)
            L.BackgroundTransparency = 1
            L.Text = "•  " .. k
            L.TextColor3 = C.TextSoft
            L.TextSize = 11
            L.Font = Enum.Font.Gotham
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Parent = ActiveFrame
            table.insert(hudLabels, L)
            y += 20
        end
    end
end)

print("[PromtMZ] Cozy Beige UI загружен (Chams + TargetHUD + Music + Aspect4:3 + MotionBlur + Optimization + Console + Tooltips + Saturation)")
