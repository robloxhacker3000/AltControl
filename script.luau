-- ====================================================================
-- LUARMOR PREMIUM PROTECTED ENVIRONMENT WITH INTEGRATED SECURITY GATEWAY
-- ====================================================================
print("🚀 luarmor protected engine initializing environment vectors...")

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- CONFIGURATION & VOLATILE SYSTEM STATE
-- ====================================================================
local MAIN_ACCOUNT_NAME = "CreammmyKeyboardTes"
local SERVER_URL = "https://YOUR_NEW_NGROK_LINK_HERE.ngrok-free.app"

_G.WalkSpeedValue = 16
_G.JumpPowerValue = 50
_G.ESPEnabled = true

local Dancing = false
local DanceConnection = nil

-- Clean up legacy workspace interface instances to optimize memory arrays
if CoreGui:FindFirstChild("luarmor_PremiumHub") then
    CoreGui["luarmor_PremiumHub"]:Destroy()
end

-- ====================================================================
-- MODERN SLICK USER INTERFACE ENVIRONMENT DESIGN
-- ====================================================================
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "luarmor_PremiumHub"
mainGui.ResetOnSpawn = false
mainGui.Parent = CoreGui

-- --------------------------------------------------------------------
-- SUB-SYSTEM: STAGE 1 (LUARMOR AUTHENTICATION KEY CARD OVERLAY)
-- --------------------------------------------------------------------
local keyCard = Instance.new("Frame")
keyCard.Size = UDim2.new(0, 340, 0, 220)
keyCard.Position = UDim2.new(0.5, -170, 0.4, -110)
keyCard.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
keyCard.BorderSizePixel = 0
keyCard.Active = true
keyCard.Draggable = true
keyCard.Parent = mainGui

local keyCorners = Instance.new("UICorner")
keyCorners.CornerRadius = UDim.new(0, 10)
keyCorners.Parent = keyCard

local keyAccent = Instance.new("Frame")
keyAccent.Size = UDim2.new(1, 0, 0, 4)
keyAccent.BackgroundColor3 = Color3.fromRGB(218, 165, 32) -- #DAA520 Gold
keyAccent.BorderSizePixel = 0
keyAccent.Parent = keyCard

local keyAccentCorners = Instance.new("UICorner")
keyAccentCorners.CornerRadius = UDim.new(0, 10)
keyAccentCorners.Parent = keyAccent

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, -30, 0, 45)
keyTitle.Position = UDim2.new(0, 15, 0, 4)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "luarmor authentication"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.TextXAlignment = Enum.TextXAlignment.Left
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 18
keyTitle.Parent = keyCard

local keySubtext = Instance.new("TextLabel")
keySubtext.Size = UDim2.new(1, -30, 0, 20)
keySubtext.Position = UDim2.new(0, 15, 0, 36)
keySubtext.BackgroundTransparency = 1
keySubtext.Text = "Enter a valid license key token to verify credentials."
keySubtext.TextColor3 = Color3.fromRGB(140, 140, 145)
keySubtext.TextXAlignment = Enum.TextXAlignment.Left
keySubtext.Font = Enum.Font.GothamSemibold
keySubtext.TextSize = 12
keySubtext.Parent = keyCard

-- Input Text Box Frame Container
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -30, 0, 40)
inputFrame.Position = UDim2.new(0, 15, 0, 75)
inputFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = keyCard

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputFrame

local keyTextBox = Instance.new("TextBox")
keyTextBox.Size = UDim2.new(1, -20, 1, 0)
keyTextBox.Position = UDim2.new(0, 10, 0, 0)
keyTextBox.BackgroundTransparency = 1
keyTextBox.Text = ""
keyTextBox.PlaceholderText = "LUARMOR-XXXX-XXXX-XXXX"
keyTextBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 85)
keyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTextBox.Font = Enum.Font.Code
keyTextBox.TextSize = 13
keyTextBox.Parent = inputFrame

-- Validation Feedback Status Text Frame
local validationFeedback = Instance.new("TextLabel")
validationFeedback.Size = UDim2.new(1, -30, 0, 20)
validationFeedback.Position = UDim2.new(0, 15, 0, 125)
validationFeedback.BackgroundTransparency = 1
validationFeedback.Text = "Status: Awaiting system runtime authorization input..."
validationFeedback.TextColor3 = Color3.fromRGB(120, 120, 125)
validationFeedback.TextXAlignment = Enum.TextXAlignment.Left
validationFeedback.Font = Enum.Font.GothamMedium
validationFeedback.TextSize = 11
validationFeedback.Parent = keyCard

-- --------------------------------------------------------------------
-- SUB-SYSTEM: STAGE 2 (LUARMOR DASHBOARD CONTROL PANEL CORE)
-- --------------------------------------------------------------------
local mainCard = Instance.new("Frame")
mainCard.Size = UDim2.new(0, 360, 0, 300)
mainCard.Position = UDim2.new(0.5, -180, 0.4, -150)
mainCard.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
mainCard.BorderSizePixel = 0
mainCard.Active = true
mainCard.Draggable = true
mainCard.Visible = false 
mainCard.Parent = mainGui

local cardCorners = Instance.new("UICorner")
cardCorners.CornerRadius = UDim.new(0, 10)
cardCorners.Parent = mainCard

local topAccent = Instance.new("Frame")
topAccent.Size = UDim2.new(1, 0, 0, 4)
topAccent.BackgroundColor3 = Color3.fromRGB(218, 165, 32)
topAccent.BorderSizePixel = 0
topAccent.Parent = mainCard

local accentCorners = Instance.new("UICorner")
accentCorners.CornerRadius = UDim.new(0, 10)
accentCorners.Parent = topAccent

local titleHeader = Instance.new("TextLabel")
titleHeader.Size = UDim2.new(1, -30, 0, 45)
titleHeader.Position = UDim2.new(0, 15, 0, 4)
titleHeader.BackgroundTransparency = 1
titleHeader.Text = "luarmor script hub"
titleHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
titleHeader.TextXAlignment = Enum.TextXAlignment.Left
titleHeader.Font = Enum.Font.GothamBold
titleHeader.TextSize = 20
titleHeader.Parent = mainCard

local statusSubtext = Instance.new("TextLabel")
statusSubtext.Size = UDim2.new(1, -30, 0, 20)
statusSubtext.Position = UDim2.new(0, 15, 0, 38)
statusSubtext.BackgroundTransparency = 1
statusSubtext.Text = "Luarmor Identity Matrix: " .. (LocalPlayer.Name == MAIN_ACCOUNT_NAME and "👑 MASTER SHELL ADMIN" or "🤖 PROTECTED ALT INTERFACE")
statusSubtext.TextColor3 = LocalPlayer.Name == MAIN_ACCOUNT_NAME and Color3.fromRGB(218, 165, 32) or Color3.fromRGB(46, 204, 113)
statusSubtext.TextXAlignment = Enum.TextXAlignment.Left
statusSubtext.Font = Enum.Font.GothamSemibold
statusSubtext.TextSize = 12
statusSubtext.Parent = mainCard

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -30, 0, 1)
divider.Position = UDim2.new(0, 15, 0, 68)
divider.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
divider.BorderSizePixel = 0
divider.Parent = mainCard

-- Premium UI Interaction Button Factory Function
local function CreateStyledButton(text, position, parent, callback)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0, 160, 0, 38)
    btnFrame.Position = position
    btnFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    btnFrame.BorderSizePixel = 0
    btnFrame.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btnFrame

    local textBtn = Instance.new("TextButton")
    textBtn.Size = UDim2.new(1, 0, 1, 0)
    textBtn.BackgroundTransparency = 1
    textBtn.Text = text
    textBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
    textBtn.Font = Enum.Font.GothamBold
    textBtn.TextSize = 13
    textBtn.Parent = btnFrame

    textBtn.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
    end)
    textBtn.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(24, 24, 28)}):Play()
    end)

    textBtn.MouseButton1Click:Connect(callback)
    return textBtn
end

-- --------------------------------------------------------------------
-- INTERACTION FACTORY SETUP MAPPINGS
-- --------------------------------------------------------------------
CreateStyledButton("⚙️ Reset Security HWID", UDim2.new(0, 15, 0, 85), mainCard, function()
    print("🔄 Luarmor local hardware reference maps flushed successfully.")
end)

CreateStyledButton("📋 Copy Luarmor Boot", UDim2.new(0, 185, 0, 85), mainCard, function()
    setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/Creammmy/AltControl/main/script.lua'))()")
end)

local espToggle = CreateStyledButton("📊 Toggle ESP: ON", UDim2.new(0, 15, 0, 135), mainCard, function() end)
espToggle.MouseButton1Click:Connect(function()
    _G.ESPEnabled = not _G.ESPEnabled
    espToggle.Text = "📊 Toggle ESP: " .. (_G.ESPEnabled and "ON" or "OFF")
    espToggle.TextColor3 = _G.ESPEnabled and Color3.fromRGB(245, 245, 250) or Color3.fromRGB(231, 76, 60)
end)

CreateStyledButton("🛑 Terminate Luarmor", UDim2.new(0, 185, 0, 135), mainCard, function()
    mainGui:Destroy()
end)

local consoleBox = Instance.new("Frame")
consoleBox.Size = UDim2.new(1, -30, 0, 85)
consoleBox.Position = UDim2.new(0, 15, 0, 195)
consoleBox.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
consoleBox.BorderSizePixel = 0
consoleBox.Parent = mainCard

local consoleCorner = Instance.new("UICorner")
consoleCorner.CornerRadius = UDim.new(0, 6)
consoleCorner.Parent = consoleBox

local consoleText = Instance.new("TextLabel")
consoleText.Size = UDim2.new(1, -20, 1, -10)
consoleText.Position = UDim2.new(0, 10, 0, 5)
consoleText.BackgroundTransparency = 1
consoleText.Text = "Active Command Matrix Routing Links:\n• ;bring -> Teleport Alt to Master Player Vector\n• ;speed [n] -> Adjust Local Walking Velocities\n• ;jump [n] -> Modify Local Jumping Lift Heights\n• ;say [msg] -> Output Mirror Chat Packet Injection"
consoleText.TextColor3 = Color3.fromRGB(150, 152, 160)
consoleText.TextXAlignment = Enum.TextXAlignment.Left
consoleText.TextYAlignment = Enum.TextYAlignment.Top
consoleText.Font = Enum.Font.Code
consoleText.TextSize = 11
consoleText.LineHeight = 1.35
consoleText.Parent = consoleBox

-- --------------------------------------------------------------------
-- REGISTRATION DEPLOYMENT: ASYNCHRONOUS VERIFICATION LINK
-- --------------------------------------------------------------------
local function AnimateAndDisplayDashboard()
    TweenService:Create(keyCard, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -170, -1, 0)}):Play()
    task.wait(0.4)
    keyCard.Visible = false
    mainCard.Visible = true
    mainCard.Position = UDim2.new(0.5, -180, -1, 0)
    TweenService:Create(mainCard, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -180, 0.4, -150)}):Play()
end

CreateStyledButton("🔑 Verify License", UDim2.new(0, 90, 0, 155), keyCard, function()
    local inputtedString = keyTextBox.Text:gsub("%s+", "")
    if #inputtedString == 0 then
        validationFeedback.Text = "❌ Luarmor Error: Key entry field space cannot be null."
        validationFeedback.TextColor3 = Color3.fromRGB(231, 76, 60)
        return
    end

    validationFeedback.Text = "🔄 Handshaking securely with active Luarmor database nodes..."
    validationFeedback.TextColor3 = Color3.fromRGB(218, 165, 32)

    local httpRequest = syn and syn.request or request
    if not httpRequest then
        validationFeedback.Text = "❌ Fatal Exception: Client architecture lacking request links."
        validationFeedback.TextColor3 = Color3.fromRGB(231, 76, 60)
        return
    end

    task.spawn(function()
        local success, response = pcall(function()
            return httpRequest({
                Url = SERVER_URL .. "/checkkey/" .. HttpService:UrlEncode(inputtedString),
                Method = "GET"
            })
        end)

        if success and response and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.valid then
                validationFeedback.Text = "🟢 Success! Luarmor session initialized. Loading dashboard..."
                validationFeedback.TextColor3 = Color3.fromRGB(46, 204, 113)
                task.wait(0.8)
                AnimateAndDisplayDashboard()
            else
                validationFeedback.Text = "❌ Luarmor Rejection: " .. (data.reason or "Invalid key balance.")
                validationFeedback.TextColor3 = Color3.fromRGB(231, 76, 60)
            end
        else
            validationFeedback.Text = "❌ Firewall Error: Verification master servers unresponsive."
            validationFeedback.TextColor3 = Color3.fromRGB(231, 76, 60)
        end
    end)
end)

-- ====================================================================
-- RUNTIME EXPLOIT SYSTEM CHANNELS
-- ====================================================================
task.spawn(function()
    while true do
        task.wait(0.1)
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            humanoid.WalkSpeed = _G.WalkSpeedValue
            if humanoid.UseJumpPower then
                humanoid.JumpPower = _G.JumpPowerValue
            else
                humanoid.JumpHeight = _G.JumpPowerValue / 3.5
            end
        end
    end
end)

local function CreateESP(player)
    if player == LocalPlayer then return end
    local BoxOutline = Instance.new("BoxHandleAdornment")
    BoxOutline.Name = "ESP_Box"
    BoxOutline.AlwaysOnTop = true
    BoxOutline.ZIndex = 5
    BoxOutline.Color3 = Color3.fromRGB(218, 165, 32)
    BoxOutline.Transparency = 0.4
    BoxOutline.Size = Vector3.new(4, 5.5, 1)

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESP_Text"
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    Billboard.AlwaysOnTop = true

    local TextLabel = Instance.new("TextLabel", Billboard)
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = player.Name
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextStrokeTransparency = 0
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 13

    local function ApplyESP(character)
        task.spawn(function()
            while character and character.Parent do
                task.wait(0.5)
                if _G.ESPEnabled and mainCard.Visible then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        BoxOutline.Adornee = root
                        BoxOutline.Parent = CoreGui
                        Billboard.Adornee = root
                        Billboard.Parent = CoreGui
                    end
                else
                    BoxOutline.Adornee = nil
                    Billboard.Adornee = nil
                end
            end
        end)
    end
    if player.Character then ApplyESP(player.Character) end
    player.CharacterAdded:Connect(ApplyESP)
end

for _, player in ipairs(Players:GetPlayers()) do CreateESP(player) end
Players.PlayerAdded:Connect(CreateESP)

-- ====================================================================
-- MASTER SECURED CHAT DECODING CHANNELS
-- ====================================================================
local function HandleIncomingChat(msg, speaker)
    if not mainCard.Visible then return end
    if LocalPlayer.Name == MAIN_ACCOUNT_NAME then return end
    if speaker.Name ~= MAIN_ACCOUNT_NAME then return end
    
    local args = string.split(msg, " ") 
    local command = string.lower(args[1])
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if command == ";bring" then
        local mainPlayer = Players:FindFirstChild(MAIN_ACCOUNT_NAME)
        if mainPlayer and mainPlayer.Character and mainPlayer.Character:FindFirstChild("HumanoidRootPart") and rootPart then
            rootPart.CFrame = mainPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
    if command == ";speed" and args[2] and tonumber(args[2]) then _G.WalkSpeedValue = tonumber(args[2]) end
    if command == ";jump" then
        if args[2] and tonumber(args[2]) then _G.JumpPowerValue = tonumber(args[2]) elseif humanoid then humanoid.Jump = true end
    end
    if command == ";sit" and humanoid then humanoid.Sit = true end
    if command == ";freeze" and rootPart then rootPart.Anchored = true end
    if command == ";unfreeze" and rootPart then rootPart.Anchored = false end
    if command == ";dance" and rootPart and not Dancing then
        Dancing = true
        DanceConnection = RunService.Heartbeat:Connect(function()
            if rootPart and Dancing then rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(15), 0) end
        end)
    end
    if command == ";undance" and Dancing then
        Dancing = false
        if DanceConnection then DanceConnection:Disconnect() DanceConnection = nil end
    end
    if command == ";say" and #args > 1 then
        table.remove(args, 1)
        local repeatMessage = table.concat(args, " ")
        if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local textChannels = TextChatService:FindFirstChild("TextChannels")
            local targetChannel = textChannels and (textChannels:FindFirstChild("RBXGeneral") or textChannels:FindFirstChild("RBXSystem"))
            if targetChannel then targetChannel:SendAsync(repeatMessage) end
        end
        local legacyChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if legacyChat and legacyChat:FindFirstChild("SayMessageRequest") then
            legacyChat.SayMessageRequest:FireServer(repeatMessage, "All")
        end
    end
end

if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(textMessage)
        if textMessage.TextSource then
            local speaker = Players:GetPlayerByUserId(textMessage.TextSource.UserId)
            if speaker then HandleIncomingChat(textMessage.Text, speaker) end
        end
    end)
else
    for _, player in ipairs(Players:GetPlayers()) do player.Chatted:Connect(function(msg) HandleIncomingChat(msg, player) end) end
    Players.PlayerAdded:Connect(function(player) player.Chatted:Connect(function(msg) HandleIncomingChat(msg, player) end) end)
end