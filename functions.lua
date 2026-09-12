-- functions.lua
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local S = _G.PromtMZ and _G.PromtMZ.S
if not S then
    warn("[PromtMZ] Сначала запусти main.lua!")
    return
end

local function getTargets()
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HeadMesh")
            if hum and head and hum.Health > 0 then
                table.insert(targets, {player = p, char = p.Character, hum = hum, head = head})
            end
        end
    end
    return targets
end

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
    if S.Speed and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = S.SpeedV end
    end
end)

-- Jump
RunService.RenderStepped:Connect(function()
    if S.Jump and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = S.JumpV end
    end
end)

-- Fly
RunService.RenderStepped:Connect(function()
    if not S.Fly or not LP.Character then return end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart") or LP.Character:FindFirstChild("Torso")
    if not hrp then return end
    local d = Vector3.new()
    if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + Cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - Cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - Cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + Cam.CFrame.RightVector end
    hrp.Velocity = d * (S.FlyV * 10)
end)

-- Noclip
RunService.Stepped:Connect(function()
    if not S.Noclip or not LP.Character then return end
    for _, p in ipairs(LP.Character:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
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
    if not LP.Character then return end
    local h = LP.Character:FindFirstChildOfClass("Humanoid")
    if not h then return end
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
    if not S.LeaveTp or not LP.Character then return end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
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
    if not S.KillAura or not LP.Character then return end
    local myHead = LP.Character:FindFirstChild("Head")
    if not myHead then return end
    local targets = getTargets()
    local closest, shortest = nil, S.ReachV
    for _, t in ipairs(targets) do
        local d = (myHead.Position - t.head.Position).Magnitude
        if d < shortest then shortest = d; closest = t end
    end
    if closest then
        local tool = LP.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
        if mouse1click then pcall(mouse1click) end
    end
end)

-- Aimbot (сначала без стены, потом остальные)
RunService.RenderStepped:Connect(function()
    if not S.Aimbot or not LP.Character then return end
    local myHead = LP.Character:FindFirstChild("Head")
    if not myHead then return end

    local function findTarget(checkWalls)
        local targets = getTargets()
        local closest, shortest = nil, S.ReachV
        for _, t in ipairs(targets) do
            local d = (myHead.Position - t.head.Position).Magnitude
            if d < shortest then
                if checkWalls then
                    local rp = RaycastParams.new()
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    rp.FilterDescendantsInstances = {LP.Character}
                    local rr = workspace:Raycast(myHead.Position, t.head.Position - myHead.Position, rp)
                    local vis = false
                    if rr then
                        if rr.Instance and rr.Instance:IsDescendantOf(t.char) then vis = true end
                    else vis = true end
                    if not vis then continue end
                end
                shortest = d
                closest = t
            end
        end
        return closest
    end

    local target = findTarget(true) or findTarget(false)
    if target then
        local newCFrame = CFrame.lookAt(myHead.Position, target.head.Position)
        Cam.CFrame = Cam.CFrame:Lerp(newCFrame, S.AimS)
    end
end)

-- FarAim (без кусков — всегда в голову)
RunService.RenderStepped:Connect(function()
    if not S.FarAim or not LP.Character then return end
    local myHead = LP.Character:FindFirstChild("Head")
    if not myHead then return end

    local targets = getTargets()

    local function isVisible(t)
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = {LP.Character}
        local rr = workspace:Raycast(myHead.Position, t.head.Position - myHead.Position, rp)
        if rr then
            if rr.Instance and rr.Instance:IsDescendantOf(t.char) then return true end
            return false
        end
        return true
    end

    local visibleTarget, visibleDist = nil, S.FarR
    for _, t in ipairs(targets) do
        local d = (myHead.Position - t.head.Position).Magnitude
        if d < visibleDist and isVisible(t) then
            visibleDist = d
            visibleTarget = t
        end
    end

    local blockedTarget, blockedDist = nil, S.FarR
    if not visibleTarget then
        for _, t in ipairs(targets) do
            local d = (myHead.Position - t.head.Position).Magnitude
            if d < blockedDist then
                blockedDist = d
                blockedTarget = t
            end
        end
    end

    local target = visibleTarget or blockedTarget
    if target then
        local newCFrame = CFrame.lookAt(myHead.Position, target.head.Position)
        Cam.CFrame = Cam.CFrame:Lerp(newCFrame, S.FarAimS)
    end
end)

-- AUTOSHOT — клики пока прицел на голове
RunService.RenderStepped:Connect(function()
    if not S.AutoShot or not LP.Character then return end
    local myHead = LP.Character:FindFirstChild("Head")
    if not myHead then return end

    local targets = getTargets()
    local closest, shortest = nil, S.AutoShotRange
    for _, t in ipairs(targets) do
        local d = (myHead.Position - t.head.Position).Magnitude
        if d < shortest then
            local rp = RaycastParams.new()
            rp.FilterType = Enum.RaycastFilterType.Exclude
            rp.FilterDescendantsInstances = {LP.Character}
            local rr = workspace:Raycast(myHead.Position, t.head.Position - myHead.Position, rp)
            local visible = false
            if rr then
                if rr.Instance and rr.Instance:IsDescendantOf(t.char) then visible = true end
            else
                visible = true
            end
            if visible then
                shortest = d
                closest = t
            end
        end
    end

    if not closest then return end

    local sp, onScr = Cam:WorldToViewportPoint(closest.head.Position)
    if not onScr then return end
    local vp = Cam.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    local dC = math.sqrt((sp.X - cx)^2 + (sp.Y - cy)^2)
    if dC > S.AutoShotFOV then return end

    local tool = LP.Character:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
    if mouse1click then pcall(mouse1click) end
end)

-- Spin
RunService.RenderStepped:Connect(function()
    if not S.Spin or not LP.Character then return end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart") or LP.Character:FindFirstChild("Torso")
    if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.SpinV), 0) end
end)

-- Magnet
RunService.RenderStepped:Connect(function()
    if not S.Magnet or not LP.Character then return end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local targets = getTargets()
    local c, s = nil, S.MagR
    for _, t in ipairs(targets) do
        local d = (hrp.Position - t.head.Position).Magnitude
        if d < s then s = d; c = t end
    end
    if c then hrp.Velocity = (c.head.Position - hrp.Position).Unit * (S.MagS * 10) end
end)

-- TP
RunService.RenderStepped:Connect(function()
    if not S.TP or not LP.Character then return end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local targets = getTargets()
    local c, s = nil, math.huge
    for _, t in ipairs(targets) do
        local d = (hrp.Position - t.head.Position).Magnitude
        if d < s then s = d; c = t end
    end
    if c then
        local tHrp = c.char:FindFirstChild("HumanoidRootPart")
        if tHrp then hrp.CFrame = tHrp.CFrame + Vector3.new(0,3,0) end
    end
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
        if S.AutoClick and LP.Character then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

print("[PromtMZ] functions загружены")
