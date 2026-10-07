if getgenv().NDSEgor then getgenv().NDSEgor:Disconnect() end 
local P, R, U = game.Players.LocalPlayer, game:GetService("RunService"), game:GetService("UserInputService") 
local X, G, r, q = false, false, false, false 
local a, sa = 0, 0 
local fakeAnchor = nil

local function reset() 
    local c = P.Character
    if fakeAnchor then fakeAnchor:Destroy(); fakeAnchor = nil end
    if c then 
        local rp = c:FindFirstChild("HumanoidRootPart") 
        local hum = c:FindFirstChildOfClass("Humanoid")
        if rp then rp.Anchored = false end
        if hum then hum.AutoRotate = true end -- Возвращаем вращение по умолчанию
        workspace.CurrentCamera.CameraSubject = c:FindFirstChildOfClass("Humanoid")
    end 
end 

U.InputBegan:Connect(function(i, chat) 
    if chat then return end 
    if i.KeyCode == Enum.KeyCode.X then reset(); X = not X; G,r,q = false,false,false 
    elseif i.KeyCode == Enum.KeyCode.G then reset(); G = not G; X,r,q = false,false,false 
    elseif i.KeyCode == Enum.KeyCode.R then reset(); r = not r; X,G,q = false,false,false 
    elseif i.KeyCode == Enum.KeyCode.Q then reset(); q = not q; X,G,r = false,false,false 
end end) 

getgenv().NDSEgor = R.RenderStepped:Connect(function() 
    local c = P.Character; 
    local rp = c and c:FindFirstChild("HumanoidRootPart") 
    local hum = c and c:FindFirstChildOfClass("Humanoid"); 
    if not rp or not hum then return end 

    if not X and not G and not r and not q then reset(); return end 

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

    if r or q then 
        hum.AutoRotate = true
        local currentPos = rp.Position
        local nextPos = currentPos

        if q then 
            sa = sa + 0.38; 
            local arc = math.sin(sa) * (math.pi / 2) 
            local x, z = math.sin(arc) * 6, -math.cos(arc) * 5.8 
            nextPos = currentPos + Vector3.new(x, 0, z)
        elseif r then 
            a = a + 0.38; 
            local x, z = math.cos(a) * 5.8, math.sin(a) * 5.8 
            nextPos = currentPos + Vector3.new(x, 0, z)
        end 

        local originalCFrame = rp.CFrame
        rp.CFrame = CFrame.lookAt(nextPos, Vector3.new(currentPos.X, nextPos.Y, currentPos.Z))
        R.Heartbeat:Wait()
        rp.CFrame = originalCFrame

    elseif G then 
        -- Локально отключаем авто-поворот гуманоида, чтобы Shift Lock не клинил управление
        hum.AutoRotate = false
        
        local camFrame = workspace.CurrentCamera.CFrame
        local shakeX = camFrame.RightVector * math.sin(tick() * 720) * 1.5
        local shakeY = camFrame.UpVector * math.cos(tick() * 480) * 1.5
        
        -- Позволяем персонажу поворачиваться в сторону камеры программно
        local lookPos = rp.Position + camFrame.LookVector
        rp.CFrame = CFrame.lookAt(rp.Position, Vector3.new(lookPos.X, rp.Position.Y, lookPos.Z)) + shakeX + shakeY

    elseif X then 
        -- Полный обход блокировки Shift Lock для X
        hum.AutoRotate = false
        
        local camFrame = workspace.CurrentCamera.CFrame
        local rightVector = camFrame.RightVector
        
        -- Высчитываем вибрацию 1.0 влево-вправо относительно мыши, сохраняя поворот тела за взглядом
        local lookPos = rp.Position + camFrame.LookVector
        rp.CFrame = CFrame.lookAt(rp.Position, Vector3.new(lookPos.X, rp.Position.Y, lookPos.Z)) + (rightVector * math.sin(tick() * 250) * 1.0)
    end 
end)
