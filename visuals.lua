-- visuals.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local UNIQUE = nil
for k, v in pairs(_G) do
    if type(k) == "string" and k:sub(1, 3) == "PZ_" then UNIQUE = k; break end
end
if not UNIQUE or not _G[UNIQUE] or not _G[UNIQUE].S then
    warn("[PromtMZ] Сначала запусти main.lua!")
    return
end
local S = _G[UNIQUE].S

local ok = pcall(function() return Drawing.new("Text") end)
if not ok then return end

-- Универсальный поиск персонажа
local function getChar(p)
    if p.Character then return p.Character end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == p.Name and obj:FindFirstChildOfClass("Humanoid") then
            return obj
        end
    end
    return nil
end

local function espFor(p)
    local e = Drawing.new("Text")
    e.Visible = false
    e.Color = Color3.fromRGB(255,50,50)
    e.Size = 16
    e.Center = true
    e.Outline = true
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not S.ESP then e.Visible = false return end
            local char = getChar(p)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HeadMesh"))
            if not char or not hum or not head or hum.Health <= 0 then e.Visible = false return end
            local pos, on = Cam:WorldToViewportPoint(head.Position)
            if on then
                e.Position = Vector2.new(pos.X, pos.Y - 25)
                e.Text = p.Name .. " | " .. math.floor(hum.Health)
                e.Visible = true
            else
                e.Visible = false
            end
        end)
    end)
end

local function boxFor(p)
    local b = Drawing.new("Square")
    b.Visible = false
    b.Color = Color3.fromRGB(255,50,50)
    b.Thickness = 1.5
    b.Filled = false
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not S.Box then b.Visible = false return end
            local char = getChar(p)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum or hum.Health <= 0 then b.Visible = false return end
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            local head = char:FindFirstChild("Head")
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
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP then
        espFor(p); boxFor(p)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LP then
        espFor(p); boxFor(p)
    end
end)

print("[PromtMZ] visuals загружены")
