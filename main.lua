local P, R, U = game.Players.LocalPlayer, game:GetService("RunService"), game:GetService("UserInputService") 
local X, G, r, q = false, false, false, false 
local a, sa = 0, 0 
local fakeAnchor = nil

-- Создаем всплывающее уведомление в правом углу экрана
task.spawn(function()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Universal Desync",
            Text = "Loaded! Get TPTool from Infinity Yield for clones.",
            Duration = 7
        })
    end)
end)

local function reset() 
    local c = P.Character
    if fakeAnchor then fakeAnchor:Destroy(); fakeAnchor = nil end
    if c then 
        local rp = c:FindFirstChild("HumanoidRootPart") 
        local hum = c:FindFirstChildOfClass("Humanoid")
        if rp then rp.Anchored = false end
        if hum then hum.AutoRotate = true end 
        workspace.CurrentCamera.CameraSubject = c:FindFirstChildOfClass("Humanoid")
        
        local tool = c:FindFirstChild("TPTool")
        if tool then tool.Parent = P.Backpack end
    end 
end 

-- СОЗДАНИЕ ГУИ В PLAYERGUI (Безопасно для ПК и мобильных экзекуторов)
local PlayerGui = P:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("UniversalDesyncGUI") then
    PlayerGui.UniversalDesyncGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalDesyncGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 100, 0, 280) -- Уменьшили высоту до 280 пикселей
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true 
frame.Parent = screenGui

-- Скругление углов для GUI
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Desync"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

local buttons = {
    {Name = "Mode X", Key = "X"},
    {Name = "Mode G", Key = "G"},
    {Name = "Mode R", Key = "R"},
    {Name = "Mode Q", Key = "Q"}
}

local activeButtons = {}

local function updateButtonVisuals()
    if activeButtons["X"] then activeButtons["X"].BackgroundColor3 = X and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40) end
    if activeButtons["G"] then activeButtons["G"].BackgroundColor3 = G and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40) end
    if activeButtons["R"] then activeButtons["R"].BackgroundColor3 = r and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40) end
    if activeButtons["Q"] then activeButtons["Q"].BackgroundColor3 = q and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40) end
end

local function toggleMode(mode)
    reset()
    if mode == "X" then X = not X; G,r,q = false,false,false
    elseif mode == "G" then G = not G; X,r,q = false,false,false
    elseif mode == "R" then r = not r; X,G,q = false,false,false
    elseif mode == "Q" then q = not q; X,G,r = false,false,false
    end
    updateButtonVisuals()
end

-- Создаем кнопки на панели (сделали отступ чуть плотнее)
for i, btnData in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 38) -- Слегка уменьшили высоту кнопок для компактности
    btn.Position = UDim2.new(0.5, -40, 0, 32 + (i - 1) * 44) -- Уплотнили шаги позиций
    btn.Text = btnData.Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    activeButtons[btnData.Key] = btn
    
    btn.MouseButton1Click:Connect(function()
        toggleMode(btnData.Key)
    end)
end

-- Кнопка сброса (Reset / Turn off)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 80, 0, 30)
closeBtn.Position = UDim2.new(0.5, -40, 0, 208) -- Сместили выше под плотное расположение
closeBtn.Text = "Reset"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    X, G, r, q = false, false, false, false
    reset()
    updateButtonVisuals()
end)

-- Увеличенная кнопка "Open" в углу экрана (100x50 пикселей)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 100, 0, 50)
openBtn.Position = UDim2.new(0, 15, 0, 15)
openBtn.Text = "Open"
openBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextSize = 16 
openBtn.BorderSizePixel = 0
openBtn.Visible = false
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = openBtn

-- Кнопка "Hide" внутри панели
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 80, 0, 30)
hideBtn.Position = UDim2.new(0.5, -40, 0, 242) -- Сместили в самый низ уменьшенного фрейма
hideBtn.Text = "Hide"
hideBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
hideBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.TextSize = 14
hideBtn.BorderSizePixel = 0
hideBtn.Parent = frame

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 5)
hideCorner.Parent = hideBtn

hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    openBtn.Visible = false
end)

updateButtonVisuals()

U.InputBegan:Connect(function(i, chat) 
    if chat then return end 
    if i.KeyCode == Enum.KeyCode.X then toggleMode("X")
    elseif i.KeyCode == Enum.KeyCode.G then toggleMode("G")
    elseif i.KeyCode == Enum.KeyCode.R then toggleMode("R")
    elseif i.KeyCode == Enum.KeyCode.Q then toggleMode("Q")
    end 
end) 

if getgenv().NDSEgor then getgenv().NDSEgor:Disconnect() end 

getgenv().NDSEgor = R.Heartbeat:Connect(function() 
    local c = P.Character; 
    local rp = c and c:FindFirstChild("HumanoidRootPart") 
    local hum = c and c:FindFirstChildOfClass("Humanoid"); 
    if not rp or not hum then return end 

    if not X and not G and not r and not q then reset(); return end 

    local tool = c:FindFirstChild("TPTool") or P.Backpack:FindFirstChild("TPTool")
    if tool and tool.Parent ~= c then tool.Parent = c end

    if (r or q or G or X) and not fakeAnchor then
        fakeAnchor = Instance.new("Part")
        fakeAnchor.Size = Vector3.new(1, 1, 1)
        fakeAnchor.Transparency = 1
        fakeAnchor.CanCollide = false
        fakeAnchor.Anchored = true
        fakeAnchor.CFrame = rp.CFrame
        fakeAnchor.Parent = workspace
        workspace.CurrentCamera.CameraSubject = fakeAnchor
    end

    if fakeAnchor then
        fakeAnchor.CFrame = fakeAnchor.CFrame:Lerp(rp.CFrame, 0.1)
    end

    local originalCFrame = rp.CFrame

    if r or q then 
        hum.AutoRotate = true
        local currentPos = rp.Position

        for k = 1, 3 do
            local phaseOffset = (k - 1) * (math.pi * 2 / 3)
            local nextPos = currentPos

            if q then 
                sa = sa + 0.15; 
                local arc = math.sin(sa + phaseOffset) * (math.pi / 2) 
                local x, z = math.sin(arc) * 7.5, -math.cos(arc) * 7.2
                nextPos = currentPos + Vector3.new(x, 0, z)
            elseif r then 
                a = a + 0.15; 
                local x, z = math.cos(a + phaseOffset) * 7.2, math.sin(a + phaseOffset) * 7.2
                nextPos = currentPos + Vector3.new(x, 0, z)
            end 

            rp.CFrame = CFrame.lookAt(nextPos, Vector3.new(currentPos.X, nextPos.Y, currentPos.Z))
            if tool then tool:Activate() end
        end
        
        R.PostSimulation:Wait()
        rp.CFrame = originalCFrame

    elseif G then 
        hum.AutoRotate = false
        local camFrame = workspace.CurrentCamera.CFrame
        
        local shakeX = camFrame.RightVector * math.sin(tick() * 999) * 4.5
        local shakeY = camFrame.UpVector * math.cos(tick() * 777) * 4.5
        local lookPos = rp.Position + camFrame.LookVector
        
        rp.CFrame = CFrame.lookAt(rp.Position, Vector3.new(lookPos.X, rp.Position.Y, lookPos.Z)) + shakeX + shakeY
        if tool then tool:Activate() end
        
        R.PostSimulation:Wait()
        rp.CFrame = originalCFrame

    elseif X then 
        hum.AutoRotate = false
        local camFrame = workspace.CurrentCamera.CFrame
        local rightVector = camFrame.RightVector
        local lookPos = rp.Position + camFrame.LookVector
        local baseLook = CFrame.lookAt(rp.Position, Vector3.new(lookPos.X, rp.Position.Y, lookPos.Z))

        local sideOffset = math.sin(tick() * 1200) * 6.5
        
        rp.CFrame = baseLook + (rightVector * sideOffset)
        if tool then tool:Activate() end
        
        R.PostSimulation:Wait()
        rp.CFrame = originalCFrame
    end 
end)

P.CharacterRemoving:Connect(function()
    reset()
end)
