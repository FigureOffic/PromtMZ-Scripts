-- main.lua — TEST
_G.PromtMZ = _G.PromtMZ or {}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local S = {
    KillAura=false, Aimbot=false, FarAim=false, AutoShot=false,
    Reach=false, Spin=false, Magnet=false, TP=false,
    Speed=false, Fly=false, Jump=false, Noclip=false, BHop=false,
    LeaveTp=false, Fog=true, Fullbright=false, HUD=false,
    ESP=false, Skeleton=false, Box=false, ChinaHat=false,
    AntiAFK=false, AutoClick=false,
    ReachV=6, SpeedV=20, FlyV=3, JumpV=100,
    SpinV=100, MagR=30, MagS=5, AimS=0.15, FarR=500, BHopB=1.05,
    FarAimS=0.35, FarAimFastJump=0.7,
    LeaveTpDist=50, LeaveTpDelay=0.5,
    FogColor=Color3.fromRGB(180,180,190), FogStart=0, FogEnd=250,
    AutoShotRange=200, AutoShotDelay=0.01, AutoShotFOV=30, AutoShotPredict=1.0
}
_G.PromtMZ.S = S
print("[PromtMZ] S создан:", _G.PromtMZ.S)
