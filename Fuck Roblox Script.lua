local function callback(Text)
    if Text == "Start" then
        print("Executed")
        -- Load the external script when the "Start" button is clicked
        local scriptUrl = "https://raw.githubusercontent.com/HackercoderEmpire/Rgo-that-is-trash/refs/heads/main/Age%20of%20Fuck%20you.lua"
        local loadedScript = loadstring(game:HttpGet(scriptUrl))()
    elseif Text == "Fuck off" then
        print("Not Executed")
        game:Shutdown()  -- Close the game when the "Fuck off" button is clicked
    end
end

local NotifacationBindable = Instance.new("BindableFunction")
NotifacationBindable.OnInvoke = callback

game.StarterGui:SetCore("SendNotification", {
    Title = "Age Of Heroes";
    Text = "Have Fun No Sharing this Script";
    Icon = "";
    Duration = 5;
    Button1 = "Start";
    Button2 = "Fuck off";
    Callback = NotifacationBindable
})
