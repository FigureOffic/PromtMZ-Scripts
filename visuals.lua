-- visuals.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local S = _G.PromtMZ and _G.PromtMZ.S
if not S then
    warn("[PromtMZ] Сначала запусти main.lua!")
    return
end

local ok = pcall(function() return Drawing.new("Text") end)
if not ok then return end

-- Универсальный поиск персонажа (для кастомных рендеров)
local function getChar(p)
    if p.Character then
        local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HeadMesh")
        if head then return p.Character end
    end
    -- Фолбэк: ищем модель с ником игрока
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

-- ESP
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

-- Skeleton (исправлен)
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

-- Box (исправлен)
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
        else
            b.Visible = false
        end
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

print("[PromtMZ] visuals загружены")
