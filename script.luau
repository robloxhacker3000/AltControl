-- ====================================================================
-- LUARMOR SECURE OAUTH & ROLE SENSITIVE VERIFICATION ENVIRONMENT
-- ====================================================================
print("🚀 luarmor dynamic role parsing engine initializing...")

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- SYSTEM SETTINGS
-- ====================================================================
local MAIN_ACCOUNT_NAME = "CreammmyKeyboardTes"
local SERVER_URL = "https://underwear-candied-stool.ngrok-free.dev"

_G.WalkSpeedValue = 16
_G.JumpPowerValue = 50
_G.ESPEnabled = true

local Dancing = false
local DanceConnection = nil

-- Clean up older interface garbage instances to prevent runtime overlaps
if CoreGui:FindFirstChild("luarmor_OAuthHub") then
    CoreGui["luarmor_OAuthHub"]:Destroy()
end

-- Create Screen Container Layout
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "luarmor_OAuthHub"
mainGui.ResetOnSpawn = false
mainGui.Parent = CoreGui

-- --------------------------------------------------------------------
-- BACKEND ASYNCHRONOUS ROLE EXTRACTION HANDSHAKE
-- --------------------------------------------------------------------
local httpRequest = syn and syn.request or request
if not httpRequest then
    LocalPlayer:Kick("❌ Execution Interrupted: Missing HTTP Request capabilities.")
    return
end

print("🔄 Syncing profile maps with Discord Server database parameters...")

local success, response = pcall(function()
    return httpRequest({
        Url = SERVER_URL .. "/verify-user/" .. tostring(LocalPlayer.UserId),
        Method = "GET"
    })
end)

if not success or not response or response.StatusCode ~= 200 then
    LocalPlayer:Kick("❌ Security Fault: Gateway unreachable. Check backend ngrok hosting tunnel maps.")
    return
end

local authData = HttpService:JSONDecode(response.Body)

if not authData.verified then
    LocalPlayer:Kick("❌ Luarmor Lockout: You must link your Roblox account and join our official Discord server to execute this project hub!")
    return
end

-- Assign system badges dynamically based on structural database roles
local userTitle = "🛡️ Whitelisted Client"
local badgeColor = Color3.fromRGB(46, 204, 113) -- Vibrant green layout matching

if authData.isAdmin or authData.isOwner then
    userTitle = "👑 Owner & Admin Team"
    badgeColor = Color3.fromRGB(218, 165, 32) -- Pure Goldenrod accent
end

-- --------------------------------------------------------------------
-- MAIN DASHBOARD CONTROL PANEL (FLUID UI IMPLEMENTATION)
-- --------------------------------------------------------------------
local mainCard = Instance.new("Frame")
mainCard.Size = UDim2.new(0, 360, 0, 300)
mainCard.Position = UDim2.new(0.5, -180, 0.4, -150)
mainCard.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
mainCard.BorderSizePixel = 0
mainCard.Active = true
mainCard.Draggable = true
mainCard.Parent = mainGui

local cardCorners = Instance.new("UICorner")
cardCorners.CornerRadius = UDim.new(0, 12)
cardCorners.Parent = mainCard

local topAccent = Instance.new("Frame")
topAccent.Size = UDim2.new(1, 0, 0, 4)
topAccent.BackgroundColor3 = badgeColor
topAccent.BorderSizePixel = 0
topAccent.Parent = mainCard

local accentCorners = Instance.new("UICorner")
accentCorners.CornerRadius = UDim.new(0, 12)
accentCorners.Parent = topAccent

local titleHeader = Instance.new("TextLabel")
titleHeader.Size = UDim2.new(1, -30, 0, 45)
titleHeader.Position = UDim2.new(0, 15, 0, 4)
titleHeader.BackgroundTransparency = 1
titleHeader.Text = "luarmor hub"
titleHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
titleHeader.TextXAlignment = Enum.TextXAlignment.Left
titleHeader.Font = Enum.Font.GothamBold
titleHeader.TextSize = 20
titleHeader.Parent = mainCard

local statusSubtext = Instance.new("TextLabel")
statusSubtext.Size = UDim2.new(1, -30, 0, 20)
statusSubtext.Position = UDim2.new(0, 15, 0, 38)
statusSubtext.BackgroundTransparency = 1
statusSubtext.Text = "Verified Rank: " .. userTitle
statusSubtext.TextColor3 = badgeColor
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

-- Premium UI Button Factory Function
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

CreateStyledButton("⚙️ Reset Security HWID", UDim2.new(0, 15, 0, 85), mainCard, function()
    print("🔄 Hardware vector nodes synchronized clean.")
end)

CreateStyledButton("📋 Copy Session Link", UDim2.new(0, 185, 0, 85), mainCard, function()
    setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/Creammmy/AltControl/main/script.lua'))()")
end)

local espToggle = CreateStyledButton("📊 Toggle ESP: ON", UDim2.new(0, 15, 0, 135), mainCard, function() end)
espToggle.MouseButton1Click:Connect(function()
    _G.ESPEnabled = not _G.ESPEnabled
    espToggle.Text = "📊 Toggle ESP: " .. (_G.ESPEnabled and "ON" or "OFF")
    espToggle.TextColor3 = _G.ESPEnabled and Color3.fromRGB(245, 245, 250) or Color3.fromRGB(231, 76, 60)
end)

CreateStyledButton("🛑 Close Client Panel", UDim2.new(0, 185, 0, 135), mainCard, function()
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

-- ====================================================================
-- COMPONENT HOOK LOOPS (WALKSPEED, JUMPPOWER, ESP, & CHAT)
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
    BoxOutline.Color3 = badgeColor
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

local function HandleIncomingChat(msg, speaker)
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