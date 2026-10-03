--[[
    ELYX Hub — No Admin Finder (MMV)
    Loading 1-5 → UI → Join No Admin (real teleport + re-hop if admin found)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GroupService = game:GetService("GroupService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

-- Optional: MMV / staff group IDs (add more if you know them)
local STAFF_GROUP_IDS = {
    -- example: 35036162,
}

-- Optional: known admin usernames (case-insensitive)
local KNOWN_ADMINS = {
    -- "AdminNameHere",
}

pcall(function()
    local function wipe(parent)
        if parent and parent:FindFirstChild("ElyxNoAdminFinder") then
            parent.ElyxNoAdminFinder:Destroy()
        end
    end
    wipe(CoreGui)
    wipe(LocalPlayer:FindFirstChild("PlayerGui"))
    if gethui then wipe(gethui()) end
end)

local function getParent()
    local ok, h = pcall(function() return gethui and gethui() end)
    if ok and h then return h end
    local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 3)
    if pg then return pg end
    return CoreGui
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ElyxNoAdminFinder"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = getParent()

-- ========== LOADING 1-5 ==========
local Loading = Instance.new("Frame")
Loading.Size = UDim2.new(1, 0, 1, 0)
Loading.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
Loading.BorderSizePixel = 0
Loading.Parent = ScreenGui

local LTitle = Instance.new("TextLabel")
LTitle.Size = UDim2.new(1, 0, 0, 36)
LTitle.Position = UDim2.new(0, 0, 0.38, 0)
LTitle.BackgroundTransparency = 1
LTitle.Text = "ELYX Hub"
LTitle.TextColor3 = Color3.fromRGB(190, 170, 255)
LTitle.TextSize = 28
LTitle.Font = Enum.Font.GothamBold
LTitle.Parent = Loading

local LSub = Instance.new("TextLabel")
LSub.Size = UDim2.new(1, 0, 0, 22)
LSub.Position = UDim2.new(0, 0, 0.44, 0)
LSub.BackgroundTransparency = 1
LSub.Text = "No Admin Finder · MMV"
LSub.TextColor3 = Color3.fromRGB(150, 140, 190)
LSub.TextSize = 14
LSub.Font = Enum.Font.Gotham
LSub.Parent = Loading

local LCount = Instance.new("TextLabel")
LCount.Size = UDim2.new(1, 0, 0, 50)
LCount.Position = UDim2.new(0, 0, 0.52, 0)
LCount.BackgroundTransparency = 1
LCount.Text = "1"
LCount.TextColor3 = Color3.fromRGB(160, 130, 255)
LCount.TextSize = 44
LCount.Font = Enum.Font.GothamBold
LCount.Parent = Loading

for i = 1, 5 do
    LCount.Text = tostring(i)
    task.wait(0.4)
end

task.wait(0.3)
Loading:Destroy()

-- ========== MAIN UI ==========
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 210)
Main.Position = UDim2.new(0.5, -160, 0.5, -105)
Main.BackgroundColor3 = Color3.fromRGB(16, 12, 26)
Main.BackgroundTransparency = 0.12
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(120, 80, 220)
stroke.Thickness = 1.4
stroke.Transparency = 0.25

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -16, 0, 36)
Title.Position = UDim2.new(0, 8, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "ELYX Hub · No Admin Finder"
Title.TextColor3 = Color3.fromRGB(210, 195, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 40)
Status.Position = UDim2.new(0, 10, 0, 48)
Status.BackgroundTransparency = 1
Status.Text = "Ready — press Join No Admin"
Status.TextColor3 = Color3.fromRGB(170, 160, 210)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextWrapped = true
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.TextYAlignment = Enum.TextYAlignment.Top
Status.Parent = Main

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(1, -24, 0, 40)
JoinBtn.Position = UDim2.new(0, 12, 0, 100)
JoinBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 175)
JoinBtn.Text = "Join No Admin"
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.TextSize = 15
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.Parent = Main
Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 9)

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0.48, -8, 0, 32)
StopBtn.Position = UDim2.new(0, 12, 0, 152)
StopBtn.BackgroundColor3 = Color3.fromRGB(120, 45, 55)
StopBtn.Text = "Stop"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.TextSize = 13
StopBtn.Font = Enum.Font.GothamBold
StopBtn.Parent = Main
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.48, -8, 0, 32)
CloseBtn.Position = UDim2.new(0.52, 0, 0, 152)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
CloseBtn.Text = "Close"
CloseBtn.TextColor3 = Color3.fromRGB(220, 210, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

local running = false
local visited = {}

local function isAdminPlayer(plr)
    if not plr or plr == LocalPlayer then return false end
    local nameL = string.lower(plr.Name)
    local displayL = string.lower(plr.DisplayName or "")
    for _, n in ipairs(KNOWN_ADMINS) do
        local t = string.lower(n)
        if nameL == t or displayL == t then return true end
    end
    for _, gid in ipairs(STAFF_GROUP_IDS) do
        local ok, rank = pcall(function()
            return plr:GetRankInGroup(gid)
        end)
        if ok and type(rank) == "number" and rank >= 10 then
            return true
        end
    end
    -- Heuristic: admin tools / tags often named Admin
    local char = plr.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            local n = string.lower(item.Name)
            if n:find("admin") or n:find("moderator") or n:find("staff") then
                return true
            end
        end
    end
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            local n = string.lower(item.Name)
            if n:find("admin") or n:find("moderator") then
                return true
            end
        end
    end
    return false
end

local function serverHasAdmin()
    for _, plr in ipairs(Players:GetPlayers()) do
        if isAdminPlayer(plr) then
            return true, plr.Name
        end
    end
    return false, nil
end

local function fetchServers(cursor)
    if not requestFunc then return nil end
    local url = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
        game.PlaceId
    )
    if cursor then
        url = url .. "&cursor=" .. tostring(cursor)
    end
    local ok, res = pcall(function()
        return requestFunc({ Url = url, Method = "GET" })
    end)
    if not ok or not res or not res.Body then return nil end
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(res.Body)
    end)
    if not ok2 then return nil end
    return data
end

local function pickServer()
    local cursor = nil
    local candidates = {}
    for _ = 1, 6 do
        local data = fetchServers(cursor)
        if not data or not data.data then break end
        for _, s in ipairs(data.data) do
            if s.id and not visited[s.id] and s.playing and s.maxPlayers
                and s.playing < s.maxPlayers and s.playing >= 1 then
                table.insert(candidates, s)
            end
        end
        cursor = data.nextPageCursor
        if not cursor then break end
        task.wait(0.15)
    end
    table.sort(candidates, function(a, b)
        return (a.playing or 99) < (b.playing or 99)
    end)
    return candidates[1]
end

local function doJoin()
    if running then return end
    if not requestFunc then
        Status.Text = "Error: no HTTP (need executor with request)"
        return
    end
    running = true
    JoinBtn.Text = "Searching..."
    Status.Text = "Looking for public server..."

    task.spawn(function()
        while running do
            local server = pickServer()
            if not server then
                Status.Text = "No free server found. Retrying..."
                task.wait(1.5)
            else
                visited[server.id] = true
                Status.Text = string.format(
                    "Joining server (%d/%d players)...",
                    server.playing or 0,
                    server.maxPlayers or 0
                )
                JoinBtn.Text = "Teleporting..."
                local ok = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                end)
                if not ok then
                    Status.Text = "Teleport failed — trying another..."
                    task.wait(1)
                else
                    -- Teleport started; script will end on this client when leave
                    Status.Text = "Teleport sent. If still here, retry."
                    task.wait(8)
                    if running then
                        Status.Text = "Still here — next server..."
                    end
                end
            end
            task.wait(0.5)
        end
        JoinBtn.Text = "Join No Admin"
    end)
end

-- After join: check admins and auto re-hop
task.spawn(function()
    task.wait(3)
    if not running and #Players:GetPlayers() > 1 then
        local has, name = serverHasAdmin()
        if has then
            Status.Text = "Admin found: " .. tostring(name) .. " — hopping..."
            running = false
            task.wait(0.8)
            doJoin()
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    task.wait(1)
    if isAdminPlayer(plr) then
        Status.Text = "Admin joined: " .. plr.Name .. " — hop?"
        -- optional auto hop:
        -- if not running then doJoin() end
    end
end)

JoinBtn.MouseButton1Click:Connect(function()
    if running then return end
    doJoin()
end)

StopBtn.MouseButton1Click:Connect(function()
    running = false
    JoinBtn.Text = "Join No Admin"
    Status.Text = "Stopped."
end)

CloseBtn.MouseButton1Click:Connect(function()
    running = false
    ScreenGui:Destroy()
end)

-- Drag
do
    local dragging, start, pos
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = i.Position
            pos = Main.Position
        end
    end)
    Main.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            Main.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELYX No Admin Finder",
        Text = "Ready — MMV",
        Duration = 4,
    })
end)

print("[ELYX Hub] No Admin Finder MMV loaded")
