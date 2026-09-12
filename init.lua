-- init.lua
_G.PromtMZ = _G.PromtMZ or {}
local base = "https://raw.githubusercontent.com/FigureOffic/PromtMZ-Scripts/main/"

local m = loadstring(game:HttpGet(base .. "main.lua"))
if m then m() else warn("main.lua не скомпилировался") end
task.wait(1)

local f = loadstring(game:HttpGet(base .. "functions.lua"))
if f then f() else warn("functions.lua не скомпилировался") end
task.wait(0.5)

local v = loadstring(game:HttpGet(base .. "visuals.lua"))
if v then v() else warn("visuals.lua не скомпилировался") end
