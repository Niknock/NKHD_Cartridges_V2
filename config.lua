Config = {}

Config.Framework = 'auto' -- 'auto', 'ESX' or 'QBCore'
Config.Debug = false
Config.SpamCooldown = 2000 -- 2000 = 2 Sekunden

Config.MaxCartridges = 3  -- How many shots per Cartridge
Config.ReloadKey = 45  -- R (https://docs.fivem.net/docs/game-references/controls/)

-- ESX
Config.ESXItemName = 'taser_cartridge'

-- QBCore
Config.QBCoreItemName = 'taser_cartridge'

-- Performance
Config.NonTaserTickRate = 500 -- ms

-- UI
Config.EnableUI = true -- UI
Config.UIRefreshRate = 1000 -- UI-Refreshtime
Config.UILowAmmoThreshold = 0.3 -- (0.3 = 30%) -> when the Number gets Yellow