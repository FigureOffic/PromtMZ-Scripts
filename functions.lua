-- functions.lua
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
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

-- Универсальный поиск цели
local function getTargets()
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local char = p.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local head = char:FindFirstChild("Head") or char:FindFirstChild("HeadMesh")
                if hum and head and hum.Health > 0 then
                    table.insert(targets, {player = p, char = char, hum = hum, head = head})
                end
            end
        end
    end
    return targets
end

pcall(function()
    -- Fog
    RunService.RenderStepped:Connect(function()
        pcall(function()
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
    end)

    -- Speed
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if S.Speed and LP.Character then
                local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = S.SpeedV end
            end
        end)
    end)

    -- Fly
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not S.Fly then return end
            if not LP.Character then return end
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart") or LP.Character:FindFirstChild("Torso")
            if not hrp then return end
            local d = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + Cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - Cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - Cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + Cam.CFrame.RightVector end
            hrp.Velocity = d * (S.FlyV * 10)
        end)
    end)

    -- Noclip
    RunService.Stepped:Connect(function()
        pcall(function()
            if not S.Noclip or not LP.Character then return end
            for _, p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end)

    -- KillAura
    RunService.RenderStepped:Connect(function()
        pcall(function()
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
                if tool then pcall(function() tool:Activate() end) end
                if mouse1click then pcall(mouse1click) end
            end
        end)
    end)

    -- Aimbot
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not S.Aimbot or not LP.Character then return end
            local myHead = LP.Character:FindFirstChild("Head")
            if not myHead then return end
            local targets = getTargets()
            local closest, shortest = nil, S.ReachV
            for _, t in ipairs(targets) do
                local d = (myHead.Position - t.head.Position).Magnitude
                if d < shortest then shortest = d; closest = t end
            end
            if closest then
                local newCFrame = CFrame.lookAt(myHead.Position, closest.head.Position)
                Cam.CFrame = Cam.CFrame:Lerp(newCFrame, S.AimS)
            end
        end)
    end)

    -- FarAim
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not S.FarAim or not LP.Character then return end
            local myHead = LP.Character:FindFirstChild("Head")
            if not myHead then return end
            local targets = getTargets()
            local closest, shortest = nil, S.FarR
            for _, t in ipairs(targets) do
                local d = (myHead.Position - t.head.Position).Magnitude
                if d < shortest then shortest = d; closest = t end
            end
            if closest then
                local newCFrame = CFrame.lookAt(myHead.Position, closest.head.Position)
                Cam.CFrame = Cam.CFrame:Lerp(newCFrame, S.FarAimS)
            end
        end)
    end)

    -- AutoShot
    local lastShot = 0
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not S.AutoShot or not LP.Character then return end
            local now = tick()
            if now - lastShot < S.AutoShotDelay then return end
            local myHead = LP.Character:FindFirstChild("Head")
            if not myHead then return end
            local targets = getTargets()
            local closest, shortest = nil, S.AutoShotRange
            for _, t in ipairs(targets) do
                local d = (myHead.Position - t.head.Position).Magnitude
                if d < shortest then shortest = d; closest = t end
            end
            if closest then
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
                if mouse1click then pcall(mouse1click) end
                lastShot = now
            end
        end)
    end)

    -- Spin
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not S.Spin or not LP.Character then return end
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart") or LP.Character:FindFirstChild("Torso")
            if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.SpinV), 0) end
        end)
    end)

    -- AntiAFK
    task.spawn(function()
        while task.wait(60) do
            pcall(function()
                if S.AntiAFK then
                    local vu = game:GetService("VirtualUser")
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end
            end)
        end
    end)
end)

print("[PromtMZ] functions загружены")
