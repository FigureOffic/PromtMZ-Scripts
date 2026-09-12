-- init.lua
_G.PromtMZ = _G.PromtMZ or {}
local base = "https://raw.githubusercontent.com/FigureOffic/PromtMZ/main/"

loadstring(game:HttpGet(base .. "main.lua"))()
loadstring(game:HttpGet(base .. "visuals.lua"))()
