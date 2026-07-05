-- ====================================================================
-- MSPAINT MAIN HUB ENVIRONMENT SOURCE WITH EXPANDED ALT CONTROL
-- ====================================================================
print("🚀 mspaint core hub environment initializing successfully...")

-- Basic Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- CONFIGURATION SETTINGS
-- ====================================================================
local MAIN_ACCOUNT_NAME = "CreammmyKeyboardTes" -- Main account that controls the alts

-- Configuration Toggles
_G.WalkSpeedValue = 16
_G.JumpPowerValue = 50
_G.ESPEnabled = true

local Dancing = false
local DanceConnection = nil

-- ====================================================================
-- 1. VISUAL CONFIRMATION UI NOTIFICATION
-- ====================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "mspaint_NotificationHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 70)
mainFrame.Position = UDim2.new(0.5, -140, 0, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(0, 5, 1, 0)
accentBar.Position = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(218, 165, 32)
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 15, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "mspaint hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 15, 0, 32)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Execution verified. Welcome back!"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.Parent = mainFrame

mainFrame:TweenPosition(UDim2.new(0.5, -140, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)

task.spawn(function()
    task.wait(4)
    local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -140, 0, -100)})
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- ====================================================================
-- 2. WALKSPEED & JUMP POWER MODIFIERS
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

-- ====================================================================
-- 3. BOX ESP SYSTEM WITH TEXT LABELS
-- ====================================================================
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
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 14

    local function ApplyESP(character)
        if not _G.ESPEnabled then return end
        local root = character:WaitForChild("HumanoidRootPart", 5)
        if root then
            BoxOutline.Adornee = root
            BoxOutline.Parent = CoreGui
            Billboard.Adornee = root
            Billboard.Parent = CoreGui
        end
    end

    if player.Character then ApplyESP(player.Character) end
    player.CharacterAdded:Connect(ApplyESP)

    player.CharacterRemoving:Connect(function()
        BoxOutline.Adornee = nil
        Billboard.Adornee = nil
    end)
end

for _, player in ipairs(Players:GetPlayers()) do CreateESP(player) end
Players.PlayerAdded:Connect(CreateESP)

-- ====================================================================
-- 4. ALT CONTROL CHAT MONITOR VECTOR LAYER
-- ====================================================================
local function HandleIncomingChat(msg, speaker)
    if speaker.Name ~= MAIN_ACCOUNT_NAME then return end
    
    local args = string.split(msg, " ") 
    local command = string.lower(args[1])

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- ;bring command
    if command == ";bring" then
        local mainPlayer = Players:FindFirstChild(MAIN_ACCOUNT_NAME)
        if mainPlayer and mainPlayer.Character and mainPlayer.Character:FindFirstChild("HumanoidRootPart") and rootPart then
            rootPart.CFrame = mainPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            print("⚡ Alt Control: Teleported to main account.")
        end
    end

    -- ;speed [Value] command
    if command == ";speed" and args[2] then
        local speedNum = tonumber(args[2])
        if speedNum then
            _G.WalkSpeedValue = speedNum
            print("⚡ Alt Control: Local WalkSpeed set to " .. speedNum)
        end
    end

    -- ;jump [Optional Value] command
    if command == ";jump" then
        if args[2] and tonumber(args[2]) then
            _G.JumpPowerValue = tonumber(args[2])
            print("⚡ Alt Control: Local JumpPower threshold set to " .. args[2])
        elseif humanoid then
            humanoid.Jump = true
            print("⚡ Alt Control: Jump action triggered.")
        end
    end

    -- ;sit command
    if command == ";sit" and humanoid then
        humanoid.Sit = true
        print("⚡ Alt Control: Forced player into seated state.")
    end

    -- ;freeze command
    if command == ";freeze" and rootPart then
        rootPart.Anchored = true
        print("⚡ Alt Control: Alt position locked (Anchored).")
    end

    -- ;unfreeze command
    if command == ";unfreeze" and rootPart then
        rootPart.Anchored = false
        print("⚡ Alt Control: Alt position unlocked.")
    end

    -- ;dance command 
    if command == ";dance" and rootPart then
        if not Dancing then
            Dancing = true
            DanceConnection = RunService.Heartbeat:Connect(function()
                if rootPart and Dancing then
                    rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
                end
            end)
            print("⚡ Alt Control: Started custom spin loop.")
        end
    end

    -- ;undance command
    if command == ";undance" then
        if Dancing then
            Dancing = false
            if DanceConnection then
                DanceConnection:Disconnect()
                DanceConnection = nil
            end
            print("⚡ Alt Control: Custom spin loop stopped.")
        end
    end

    -- ;say [Message] command (Upgraded Hybrid Messaging Routing)
    if command == ";say" and #args > 1 then
        table.remove(args, 1)
        local repeatMessage = table.concat(args, " ")
        
        -- Route 1: Try Modern TextChatService Layout Engine (New Chat)
        if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local textChannels = TextChatService:FindFirstChild("TextChannels")
            local targetChannel = textChannels and (textChannels:FindFirstChild("RBXGeneral") or textChannels:FindFirstChild("RBXSystem"))
            
            if targetChannel then
                targetChannel:SendAsync(repeatMessage)
            else
                -- Fallback fallback: Try processing directly through the primary chat input configuration space
                local textInputBar = TextChatService:FindFirstChild("ChatInputBarConfiguration")
                if textInputBar and textInputBar.TargetTextChannel then
                    textInputBar.TargetTextChannel:SendAsync(repeatMessage)
                end
            end
        end
        
        -- Route 2: Try Legacy DefaultChatSystem Remote Handshake Matrix (Old Chat)
        local legacyChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if legacyChat and legacyChat:FindFirstChild("SayMessageRequest") then
            legacyChat.SayMessageRequest:FireServer(repeatMessage, "All")
        end
        
        print("⚡ Alt Control: Dispatched text string packet across hybrid channels.")
    end
end

-- Hook listeners dynamically into the engine's message distribution networks
if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(textMessage)
        if textMessage.TextSource then
            local speaker = Players:GetPlayerByUserId(textMessage.TextSource.UserId)
            if speaker then
                HandleIncomingChat(textMessage.Text, speaker)
            end
        end
    end)
else
    -- Fallback listener for classical server layouts
    for _, player in ipairs(Players:GetPlayers()) do
        player.Chatted:Connect(function(msg) HandleIncomingChat(msg, player) end)
    end
    Players.PlayerAdded:Connect(function(player)
        player.Chatted:Connect(function(msg) HandleIncomingChat(msg, player) end)
    end)
end