-- AgaloCheat v5.0 - Ultimate Edition
-- Created by Kast13l

local AgaloCheat = {
    Version = "5.0 (Ultimate)",
    Creator = "Kast13l",
    PlayerName = "Loading..."
}

-- === АНТИЧИТ ОБХОД ===
local function AntiCheatBypass()
    -- Скрываем наши действия
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
