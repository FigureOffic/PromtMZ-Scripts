-- init.lua
if _G.PromtMZ and _G.PromtMZ.loaded then
    warn("[PromtMZ] Уже загружен")
    return
end

_G.PromtMZ = _G.PromtMZ or {}
_G.PromtMZ.loaded = true

local base = "https://raw.githubusercontent.com/FigureOffic/PromtMZ-Scripts/main/"
local salt = "?t=" .. tostring(tick())

loadstring(game:HttpGet(base .. "main.lua" .. salt))()
task.wait(1)
loadstring(game:HttpGet(base .. "functions.lua" .. salt))()
task.wait(0.5)
loadstring(game:HttpGet(base .. "visuals.lua" .. salt))()
