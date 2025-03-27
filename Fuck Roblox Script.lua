local function callback(Text)
    if Text == "Main Script" then
        print("Executed - Loading Start Script")
        local scriptUrl = ""  -- Add your Start script URL here
        local success, err = pcall(function()
           local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Age%20of%20Fuck%20you.lua"))()
        end)
        if not success then
            warn("Failed to execute Start script:", err)
        end

    elseif Text == "Coming soon" then
        print("Executed - Loading Alternative Script")
        local scriptUrl = ""  -- Add your alternative script URL here
        local success, err = pcall(function()
            
        end)
        if not success then
            warn("Failed to execute Fuck off script:", err)
        end
    end
end

-- Create Notification Bindable Function
local NotifacationBindable = Instance.new("BindableFunction")
NotifacationBindable.OnInvoke = callback

-- Send Notification with Cyber Effects
game.StarterGui:SetCore("SendNotification", {
    Title = "Age Of Heroes";  
    Text = "Being Updated, will be back soon!";  
    Icon = "";  
    Duration = 7;  
    Button1 = "Start";  
    Button2 = "Fuck off";  -- Now loads a script instead of closing
    Callback = NotifacationBindable
})

