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

-- Aimbot (сначала без стены, потом остальные)
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
    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
        local newCFrame = CFrame.lookAt(myHead.Position, closest.Character.Head.Position)
        Cam.CFrame = Cam.CFrame:Lerp(newCFrame, S.FarAimS)
    end
end)

-- AutoShot (исправлен)
local lastShot = 0
RunService.RenderStepped:Connect(function()
    if not S.AutoShot then return end
    if not LP.Character then return end
    local now = tick()
    if now - lastShot < S.AutoShotDelay then return end
    local myHead = LP.Character:FindFirstChild("Head")
    if not myHead then return end

    -- Ищем ближайшую цель
    local closest, shortest = nil, S.AutoShotRange
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            if head and hum and hum.Health > 0 then
                local d = (myHead.Position - head.Position).Magnitude
                if d < shortest then
                    shortest = d
                    closest = p
                end
            end
        end
    end

    if not closest or not closest.Character then return end

    local head = closest.Character:FindFirstChild("Head")
    local hrp = closest.Character:FindFirstChild("HumanoidRootPart")
    if not head then return end

    -- Predict
    local tVel = hrp and hrp.Velocity * S.AutoShotPredict or Vector3.new()
    local dist = (myHead.Position - head.Position).Magnitude
    local tTime = math.clamp(dist / 2000, 0.01, 0.3)
    local pred = head.Position + tVel * tTime

    -- Проверка стены
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LP.Character}
    local rr = workspace:Raycast(myHead.Position, pred - myHead.Position, rp)
    local vis = false
    if rr then
        if rr.Instance and rr.Instance:IsDescendantOf(closest.Character) then vis = true end
    else
        vis = true
    end
    if not vis then return end

    -- Проверка прицела
    local sp, onScr = Cam:WorldToViewportPoint(pred)
    if not onScr then return end
    local vp = Cam.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    local dC = math.sqrt((sp.X - cx)^2 + (sp.Y - cy)^2)
    if dC > S.AutoShotFOV then return end

    -- Стреляем
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

print("[PromtMZ] functions загружены")
