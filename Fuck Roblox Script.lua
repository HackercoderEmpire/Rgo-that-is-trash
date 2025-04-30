local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "(Scripters) God Script",
    LoadingTitle = "(Scripters) 2026 Hub",
    LoadingSubtitle = "by Scripter",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Fuck you"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true 
    },
    KeySystem = true,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "Get the fucking key to use it",
        FileName = "The Fucking Key",
        SaveKey = false,
        GrabKeyFromSite = true,
        Key = {"https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Key"}
    }
})

Rayfield:Notify({
    Title = "Follow Scripter ON Roblox",
    Content = "Fuck Roblox",
    Duration = 5,
    Image = nil,
    Actions = { 
        Ignore = {
            Name = "Okay",
            Callback = function()
                print("The user tapped Okay!")
            end
        }
    },
})

-- Tabs Setup
local MainTab = Window:CreateTab("Main Scripts", nil)
local MainSection = MainTab:CreateSection("")
local PlayerTab = Window:CreateTab("Player", nil)
local PlayerSection = PlayerTab:CreateSection("")



-- GUI Tab

local Button = MainTab:CreateButton({
    Name = "Age Of Fuck You",
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/LOLOLOLOLOLOL.lua"))()
})
local Button = MainTab:CreateButton({
    Name = "Krnl Executor Neon",
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Custom%20Krnl.lua"))()
})
local Button = MainTab:CreateButton({
    Name = "Mini Tools",
    local library = loadstring(game:httpsGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/mini%20tools.lua"))()
})
local Button = MainTab:CreateButton({
    Name = "Infinite Yield",
    local library = loadstring(game:httpsGet("https://cdn.wearedevs.net/scripts/Infinite%20Yield.txt"))()  
})
local Button = MainTab:CreateButton({
    Name = "Solara Hub v3",
    local library = loadstring(game:httpsGet("https://cdn.wearedevs.net/scripts/Solara%20Hub%20v3.txt"))()
})











-- Player Tab

local Button = PlayerTab:CreateButton({
    Name = "Remove Legs",
    local library = loadstring(game:httpsGet("https://cdn.wearedevs.net/scripts/Remove%20Legs.txt"))()
})
local Button = PlayerTab:CreateButton({
    Name = "Fly",
    local library = loadstring(game:httpsGet("https://cdn.wearedevs.net/scripts/Fly.txt"))()
})
local Button = PlayerTab:CreateButton({
    Name = "Infinity Jump",
    local library = loadstring(game:httpsGet("https://cdn.wearedevs.net/scripts/Infinite%20Jump.txt"))()
})
local Button = PlayerTab:CreateButton({
    Name = "ESP",
    local library = loadstring(game:httpsGet("https://cdn.wearedevs.net/scripts/WRD%20ESP.txt"))()
})
