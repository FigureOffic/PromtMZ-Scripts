-- init.lua
_G.PromtMZ = _G.PromtMZ or {}
local base = "https://raw.githubusercontent.com/FigureOffic/PromtMZ-Scripts/main/"

local function load(name)
    local ok, err = pcall(function()
        local code = game:HttpGet(base .. name)
        if not code or code == "" then
            warn("[PromtMZ] Не удалось скачать " .. name)
            return
        end
        local fn, compileErr = loadstring(code)
        if not fn then
            warn("[PromtMZ] Ошибка компиляции " .. name .. ": " .. tostring(compileErr))
            return
        end
        fn()
        print("[PromtMZ] " .. name .. " загружен")
    end)
    if not ok then
        warn("[PromtMZ] Ошибка " .. name .. ": " .. tostring(err))
    end
end

load("main.lua")
task.wait(1)
load("functions.lua")
task.wait(0.5)
load("visuals.lua")
