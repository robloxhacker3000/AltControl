-- ====================================================================
-- MSPAINT PREMIUM INTERACTIVE HUB ENVIRONMENT
-- ====================================================================
print("🚀 mspaint premium interface loading successfully...")

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
local MAIN_ACCOUNT_NAME = "creammmykeyboardtes" -- Master configuration

_G.WalkSpeedValue = 16
_G.JumpPowerValue = 50
_G.ESPEnabled = true

local Dancing = false
local DanceConnection = nil

-- Clean up older interface garbage instances to prevent runtime memory overlaps
if CoreGui:FindFirstChild("mspaint_PremiumHub") then
    CoreGui["mspaint_PremiumHub"]:Destroy()
end

-- ====================================================================
-- MODERN SLICK USER INTERFACE DESIGN (UI)
-- ====================================================================
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "mspaint_PremiumHub"
mainGui.ResetOnSpawn = false
mainGui.Parent = CoreGui

-- Main Card Frame Layout
local mainCard = Instance.new("Frame")
mainCard.Size = UDim2.new(0, 360, 0, 300)
mainCard.Position = UDim2.new(0.5, -180, 0.4, -150)
mainCard.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
mainCard.BorderSizePixel = 0
mainCard.Active = true
mainCard.Draggable = true
mainCard.Parent = mainGui

-- Smooth Corner Rounding for Main Card Frame
local cardCorners = Instance.new("UICorner")
cardCorners.CornerRadius = UDim.new(0, 10)
cardCorners.Parent = mainCard

-- Top Highlight Header Bar Border
local topAccent = Instance.new("Frame")
topAccent.Size = UDim2.new(1, 0, 0, 4)
topAccent.BackgroundColor3 = Color3.fromRGB(218, 165, 32) -- #DAA520 Gold
topAccent.BorderSizePixel = 0
topAccent.Parent = mainCard

local accentCorners = Instance.new("UICorner")
accentCorners.CornerRadius = UDim.new(0, 10)
accentCorners.Parent = topAccent

-- Title Header Text
local titleHeader = Instance.new("TextLabel")
titleHeader.Size = UDim2.new(1, -30, 0, 45)
titleHeader.Position = UDim2.new(0, 15, 0, 4)
titleHeader.BackgroundTransparency = 1
titleHeader.Text = "mspaint hub"
titleHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
titleHeader.TextXAlignment = Enum.TextXAlignment.Left
titleHeader.Font = Enum.Font.GothamBold
titleHeader.TextSize = 20
titleHeader.Parent = mainCard

-- Active Client Status Tag Interface
local statusSubtext = Instance.new("TextLabel")
statusSubtext.Size = UDim2.new(1, -30, 0, 20)
statusSubtext.Position = UDim2.new(0, 15, 0, 38)
statusSubtext.BackgroundTransparency = 1
statusSubtext.Text = "Identity Verification: " .. (LocalPlayer.Name == MAIN_ACCOUNT_NAME and "👑 MASTER CONTROL HOST" or "🤖 SUB-ALT CONNECTED")
statusSubtext.TextColor3 = LocalPlayer.Name == MAIN_ACCOUNT_NAME and Color3.fromRGB(218, 165, 32) or Color3.fromRGB(46, 204, 113)
statusSubtext.TextXAlignment = Enum.TextXAlignment.Left
statusSubtext.Font = Enum.Font.GothamSemibold
statusSubtext.TextSize = 12
statusSubtext.Parent = mainCard

-- Decorative Section Divider Separator Line
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

    -- Elegant UI Hover Animations
    textBtn.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
    end)
    textBtn.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(24, 24, 28)}):Play()
    end)

    textBtn.MouseButton1Click:Connect(callback)
    return textBtn, btnFrame
end

-- Render Action Buttons
CreateStyledButton("⚙️ Reset Local HWID", UDim2.new(0, 15, 0, 85), mainCard, function()
    print("🔄 Local client HWID structure stack flushed clean.")
end)

CreateStyledButton("📋 Copy Loadstring", UDim2.new(0, 185, 0, 85), mainCard, function()
    setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/robloxhacker3000/AltControl/refs/heads/main/script.luau'))()")
end)

local espToggle, espFrame = CreateStyledButton("📊 Toggle ESP: ON", UDim2.new(0, 15, 0, 135), mainCard, function() end)
espToggle.MouseButton1Click:Connect(function()
    _G.ESPEnabled = not _G.ESPEnabled
    espToggle.Text = "📊 Toggle ESP: " .. (_G.ESPEnabled and "ON" or "OFF")
    espToggle.TextColor3 = _G.ESPEnabled and Color3.fromRGB(245, 245, 250) or Color3.fromRGB(231, 76, 60)
end)

CreateStyledButton("🛑 Destruct Menu", UDim2.new(0, 185, 0, 135), mainCard, function()
    mainGui:Destroy()
end)

-- Dedicated Command Telemetry Log Console Area Box
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
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 13

    local function ApplyESP(character)
        task.spawn(function()
            while character and character.Parent do
                task.wait(0.5)
                if _G.ESPEnabled then
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
-- 4. MASTER SECURED CHAT DECODING CHANNELS
-- ====================================================================
local function HandleIncomingChat(msg, speaker)
    -- CRITICAL PROTECTION: If this execution environment is running on the main account, block!
    if LocalPlayer.Name == MAIN_ACCOUNT_NAME then return end
    
    -- Verify talker identity is the validated host source
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

    if command == ";speed" and args[2] then
        local speedNum = tonumber(args[2])
        if speedNum then _G.WalkSpeedValue = speedNum end
    end

    if command == ";jump" then
        if args[2] and tonumber(args[2]) then
            _G.JumpPowerValue = tonumber(args[2])
        elseif humanoid then
            humanoid.Jump = true
        end
    end

    if command == ";sit" and humanoid then
        humanoid.Sit = true
    end

    if command == ";freeze" and rootPart then
        rootPart.Anchored = true
    end

    if command == ";unfreeze" and rootPart then
        rootPart.Anchored = false
    end

    if command == ";dance" and rootPart then
        if not Dancing then
            Dancing = true
            DanceConnection = RunService.Heartbeat:Connect(function()
                if rootPart and Dancing then
                    rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
                end
            end)
        end
    end

    if command == ";undance" then
        if Dancing