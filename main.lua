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

U.InputBegan:Connect(function(i, chat) 
    if chat then return end 
    if i.KeyCode == Enum.KeyCode.X then reset(); X = not X; G,r,q = false,false,false 
    elseif i.KeyCode == Enum.KeyCode.G then reset(); G = not G; X,r,q = false,false,false 
    elseif i.KeyCode == Enum.KeyCode.R then reset(); r = not r; X,G,q = false,false,false 
    elseif i.KeyCode == Enum.KeyCode.Q then reset(); q = not q; X,G,r = false,false,false 
end end) 

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

        -- Левый клон
        rp.CFrame = baseLook + (rightVector * -6.5)
        if tool then tool:Activate() end
        
        -- Правый клон
        rp.CFrame = baseLook + (rightVector * 6.5)
        if tool then tool:Activate() end
        
        R.PostSimulation:Wait()
        rp.CFrame = originalCFrame
    end 
end)

P.CharacterRemoving:Connect(function()
    reset()
end)
