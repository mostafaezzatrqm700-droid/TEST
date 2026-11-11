-- UNKNOWN Diagnostic Loader
-- Shows compile/startup errors in a visible window before the main script can fail silently.

local SOURCE_URL = "https://raw.githubusercontent.com/mostafaezzatrqm700-droid/TEST/main/UNKNOWN%20test.lua"

local function showDiagnostic(title, message)
    local parent
    pcall(function()
        if type(gethui) == "function" then
            parent = gethui()
        end
    end)
    if not parent then
        pcall(function()
            parent = game:GetService("CoreGui")
        end)
    end
    if not parent then
        pcall(function()
            parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        end)
    end
    if not parent then
        warn("[UNKNOWN DIAGNOSTIC] " .. tostring(title) .. ": " .. tostring(message))
        return
    end

    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "UNKNOWN_DIAGNOSTIC_WINDOW"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 1000000
        gui.Parent = parent

        local frame = Instance.new("Frame")
        frame.Name = "Panel"
        frame.Size = UDim2.new(0, 420, 0, 230)
        frame.Position = UDim2.new(0.5, -210, 0.5, -115)
        frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        frame.BorderSizePixel = 0
        frame.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(190, 55, 65)
        stroke.Thickness = 1.5
        stroke.Parent = frame

        local heading = Instance.new("TextLabel")
        heading.Size = UDim2.new(1, -48, 0, 38)
        heading.Position = UDim2.new(0, 14, 0, 5)
        heading.BackgroundTransparency = 1
        heading.Font = Enum.Font.GothamBold
        heading.Text = tostring(title)
        heading.TextColor3 = Color3.fromRGB(255, 100, 110)
        heading.TextSize = 16
        heading.TextXAlignment = Enum.TextXAlignment.Left
        heading.Parent = frame

        local close = Instance.new("TextButton")
        close.Size = UDim2.new(0, 30, 0, 30)
        close.Position = UDim2.new(1, -36, 0, 8)
        close.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        close.Text = "X"
        close.TextColor3 = Color3.new(1, 1, 1)
        close.Font = Enum.Font.GothamBold
        close.TextSize = 14
        close.Parent = frame
        Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
        close.MouseButton1Click:Connect(function()
            gui:Destroy()
        end)

        local body = Instance.new("TextLabel")
        body.Size = UDim2.new(1, -28, 1, -58)
        body.Position = UDim2.new(0, 14, 0, 48)
        body.BackgroundColor3 = Color3.fromRGB(27, 27, 33)
        body.BorderSizePixel = 0
        body.Font = Enum.Font.Code
        body.Text = tostring(message)
        body.TextColor3 = Color3.fromRGB(235, 235, 240)
        body.TextSize = 12
        body.TextWrapped = true
        body.TextXAlignment = Enum.TextXAlignment.Left
        body.TextYAlignment = Enum.TextYAlignment.Top
        body.Parent = frame
        Instance.new("UICorner", body).CornerRadius = UDim.new(0, 6)

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.Parent = body
    end)
end

local fetched, source = pcall(function()
    return game:HttpGet(SOURCE_URL)
end)

if not fetched or type(source) ~= "string" or #source == 0 then
    showDiagnostic("UNKNOWN - DOWNLOAD ERROR", "Could not download the main script.\n\n" .. tostring(source))
    return
end

if type(loadstring) ~= "function" then
    showDiagnostic("UNKNOWN - LOADSTRING UNAVAILABLE", "This executor does not expose loadstring().")
    return
end

local compiled, chunkOrError = pcall(loadstring, source)
if not compiled or type(chunkOrError) ~= "function" then
    showDiagnostic("UNKNOWN - COMPILE ERROR", tostring(chunkOrError))
    return
end

local ran, runtimeError = pcall(chunkOrError)
if not ran then
    showDiagnostic("UNKNOWN - STARTUP ERROR", tostring(runtimeError))
    return
end

showDiagnostic("UNKNOWN - LOADER STATUS", "The main script returned without an immediate startup error. If its window is still missing, the failure may be occurring in a task that runs asynchronously.")
