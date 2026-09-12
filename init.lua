-- init.lua
_G.PromtMZ = _G.PromtMZ or {}
local base = "https://raw.githubusercontent.com/FigureOffic/PromtMZ-Scripts/main/"

local m = loadstring(game:HttpGet(base .. "main.lua"))
if m then m() end
task.wait(1)

local f = loadstring(game:HttpGet(base .. "functions.lua"))
if f then f() end
task.wait(0.5)

local v = loadstring(game:HttpGet(base .. "visuals.lua"))
if v then v() end
