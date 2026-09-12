-- init.lua
if _G.PromtMZ and _G.PromtMZ.loaded then
    warn("[PromtMZ] Уже загружен")
    return
end

_G.PromtMZ = _G.PromtMZ or {}
_G.PromtMZ.loaded = true

local base = "https://raw.githubusercontent.com/FigureOffic/PromtMZ-Scripts/main/"

loadstring(game:HttpGet(base .. "main.lua"))()
task.wait(1)
loadstring(game:HttpGet(base .. "functions.lua"))()
task.wait(0.5)
loadstring(game:HttpGet(base .. "visuals.lua"))()
