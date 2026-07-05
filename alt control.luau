-- ====================================================================
-- CONFIGURATION: Swap out this link whenever you reboot ngrok!
-- ====================================================================
local SERVER_URL = "https://underwear-candied-stool.ngrok-free.dev"

-- ====================================================================
-- SYSTEM ENGINE LOCKOUT
-- ====================================================================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Check if the executor environment has HTTP capabilities
if not syn or not syn.request then
    if not request then
        LocalPlayer:Kick("❌ Execution Failure: Your exploit client environment is missing HTTP request channels.")
        return
    end
end

local httpRequest = syn and syn.request or request

-- 1. Grab the current license key entered into your interface textbox UI frame
-- (Replace _G.ScriptKey with whichever variable holds the text string entered by your user)
local UserInputKey = _G.ScriptKey or "K8EV8XWB-5EY8ZIYW-8MRDD26W-DVL45KD5"

-- 2. Send authorization handshake telemetry payload request back to your node server API
local success, response = pcall(function()
    return httpRequest({
        Url = SERVER_URL .. "/checkkey/" .. HttpService:UrlEncode(UserInputKey),
        Method = "GET"
    })
end)

if not success or not response or response.StatusCode ~= 200 then
    LocalPlayer:Kick("❌ Connection Error: Verification server is offline. Check tunnel hosting configs.")
    return
end

-- 3. Decode payload return arrays
local data = HttpService:JSONDecode(response.Body)

if data.valid then
    print("✅ License Key Verified! Launching project environment vectors...")
    
    -- Load and run your master project code array securely from GitHub
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Creammmy/AltControl/main/script.lua"))()
else
    local reason = data.reason or "Expired, Invalid, or Flagged Balance"
    LocalPlayer:Kick("❌ Script Hub Rejection: " .. reason)
end