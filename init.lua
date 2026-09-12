-- init.lua
_G.PromtMZ = _G.PromtMZ or {}
local base = "https://raw.githubusercontent.com/FigureOffic/PromtMZ-Scripts/main/"

loadstring(game:HttpGet(base .. "main.lua"))()
task.wait(0.5)
loadstring(game:HttpGet(base .. "visuals.lua"))()
