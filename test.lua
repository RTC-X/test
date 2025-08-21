-- Aether External Executor - Functionality Test Script
-- Tests all currently implemented functions

print("=== AETHER EXTERNAL EXECUTOR TEST SCRIPT ===")
print("Testing all implemented functions...")
print("")

-- Error tracking
local function testFunction(name, func)
    local success, result = pcall(func)
    if success then
        return true, result
    else
        return false, result
    end
end

local failedTests = {}
local passedTests = {}

-- Test 1: Basic Instance Navigation
print("1. Testing Instance Navigation:")
local gameInstance = game
print("   Game instance address: " .. tostring(gameInstance.addr))

local workspaceInstance = workspace
print("   Workspace instance address: " .. tostring(workspaceInstance.addr))

-- Test 2: Instance Properties
print("")
print("2. Testing Instance Properties:")
print("   Game Name: " .. gameInstance.Name)
print("   Game ClassName: " .. gameInstance.ClassName)
print("   Workspace Name: " .. workspaceInstance.Name)
print("   Workspace ClassName: " .. workspaceInstance.ClassName)

-- Test 3: Instance Finding
print("")
print("3. Testing Instance Finding:")
local children = workspaceInstance:GetChildren()
print("   Workspace children count: " .. #children)

-- Find a part to test with
local testPart = nil
for i, child in ipairs(children) do
    if child.ClassName == "Part" then
        testPart = child
        break
    end
end

if testPart then
    print("   Found test part: " .. testPart.Name)
    print("   Part class: " .. testPart.ClassName)
    
    -- Test 4: Position Functions
    print("")
    print("4. Testing Position Functions:")
     
     local success, position = testFunction("GetPosition", function() return testPart:GetPosition() end)
     if success then
         print("   Part position: " .. position.x .. ", " .. position.y .. ", " .. position.z)
         table.insert(passedTests, "GetPosition")
     else
         print("   GetPosition ERROR: " .. position)
         table.insert(failedTests, {name = "GetPosition", error = position})
     end
     
     local success2, velocity = testFunction("GetVelocity", function() return testPart:GetVelocity() end)
     if success2 then
         print("   Part velocity: " .. velocity.x .. ", " .. velocity.y .. ", " .. velocity.z)
         table.insert(passedTests, "GetVelocity")
     else
         print("   GetVelocity ERROR: " .. velocity)
         table.insert(failedTests, {name = "GetVelocity", error = velocity})
     end
    
else
    print("   No Part found in workspace for testing")
end

-- Test 5: Service System
print("")
print("5. Testing Service System:")
local playersService = gameInstance:GetService("Players")
if playersService and playersService.addr ~= 0 then
    print("   Players service found: " .. playersService.Name)
    
    -- Test 6: Player Functions (if players exist)
    local players = playersService:GetChildren()
    print("   Players count: " .. #players)
    
    for i, player in ipairs(players) do
        if player.ClassName == "Player" then
            print("   Player: " .. player.Name)
            
            -- Test player properties
            local character = player:FindFirstChild("Character")
            if character then
                print("     Character found: " .. character.Name)
                
                -- Test health functions
                local humanoid = character:FindFirstChild("Humanoid")
                 if humanoid then
                     print("     Humanoid found: " .. humanoid.Name)
                     
                     -- Test FOV function on camera
                     local camera = workspace:FindFirstChild("Camera")
                     if camera then
                         local success, fov = testFunction("GetFOV", function() return camera:GetFOV() end)
                         if success then
                             print("     Camera FOV: " .. fov)
                             table.insert(passedTests, "GetFOV")
                         else
                             print("     GetFOV ERROR: " .. fov)
                             table.insert(failedTests, {name = "GetFOV", error = fov})
                         end
                     else
                         print("     Camera not found for FOV test")
                         table.insert(failedTests, {name = "GetFOV", error = "Camera not found"})
                     end
                 end
            end
        end
    end
else
    print("   Players service not found or empty")
end

-- Test 7: Inheritance System
print("")
print("7. Testing Inheritance System:")
if testPart then
    print("   Is Part a BasePart? " .. tostring(testPart:IsA("BasePart")))
    print("   Is Part a PVInstance? " .. tostring(testPart:IsA("PVInstance")))
    print("   Is Part an Instance? " .. tostring(testPart:IsA("Instance")))
    print("   Is Part a Player? " .. tostring(testPart:IsA("Player")))
end

-- Test 8: Descendants and Ancestors
print("")
print("8. Testing Descendants and Ancestors:")
if testPart then
    local descendants = testPart:GetDescendants()
    print("   Part descendants count: " .. #descendants)
    
    local ancestors = testPart:GetAncestors()
    print("   Part ancestors count: " .. #ancestors)
    
    for i, ancestor in ipairs(ancestors) do
        print("     Ancestor " .. i .. ": " .. ancestor.Name .. " (" .. ancestor.ClassName .. ")")
    end
end

-- Test 9: Find Functions
print("")
print("9. Testing Find Functions:")
if workspaceInstance then
    local foundPart = workspaceInstance:FindFirstChild("Part")
    if foundPart then
        print("   Found part by name: " .. foundPart.Name)
    end
    
    local foundPartByClass = workspaceInstance:FindFirstChildOfClass("Part")
    if foundPartByClass then
        print("   Found part by class: " .. foundPartByClass.Name)
    end
    
    local foundBasePart = workspaceInstance:FindFirstChildWhichIsA("BasePart")
    if foundBasePart then
        print("   Found BasePart by inheritance: " .. foundBasePart.Name)
    end
end

-- Test 10: Vector3 Operations
print("")
print("10. Testing Vector3 Operations:")
if testPart then
    local pos = testPart:GetPosition()
    local vel = testPart:GetVelocity()
    
         print("   Position vector: x=" .. pos.x .. ", y=" .. pos.y .. ", z=" .. pos.z)
     print("   Velocity vector: x=" .. vel.x .. ", y=" .. vel.y .. ", z=" .. vel.z)
     
     -- Test Vector3 constructor
     local success, testVector = testFunction("Vector3 Constructor", function() return Vector3(1.5, 2.5, 3.5) end)
     if success then
         print("   Test Vector3: x=" .. testVector.x .. ", y=" .. testVector.y .. ", z=" .. testVector.z)
         table.insert(passedTests, "Vector3 Constructor")
     else
         print("   Vector3 Constructor ERROR: " .. testVector)
         table.insert(failedTests, {name = "Vector3 Constructor", error = testVector})
     end
end

-- Test 11: Error Handling
print("")
print("11. Testing Error Handling:")
local invalidInstance = Instance(0) -- Invalid address
print("   Invalid instance name: " .. invalidInstance.Name)
print("   Invalid instance class: " .. invalidInstance.ClassName)

local invalidChildren = invalidInstance:GetChildren()
print("   Invalid instance children count: " .. #invalidChildren)

-- Test 12: Utility Functions
print("")
print("12. Testing Utility Functions:")
print("   Executor name: " .. getexternalname())
print("   Executor identification: " .. identifyexternal())

local testFunction = loadstring("return 'Hello from loadstring!'")
if testFunction then
    local result = testFunction()
    print("   Loadstring result: " .. result)
end

-- Test 13: Global Environment
print("")
print("13. Testing Global Environment:")
local genv = getgenv()
print("   Global environment type: " .. type(genv))
print("   Game in global env: " .. tostring(genv.game ~= nil))
print("   Workspace in global env: " .. tostring(genv.workspace ~= nil))

print("")
print("=== TEST RESULTS SUMMARY ===")
print("")

-- Count results
local passedCount = #passedTests
local failedCount = #failedTests
local totalTests = passedCount + failedCount

print(" TEST STATISTICS:")
print("   Total tests: " .. totalTests)
print("   Passed: " .. passedCount .. " ")
print("   Failed: " .. failedCount .. " ")
print("   Success rate: " .. math.floor((passedCount / totalTests) * 100) .. "%")
print("")

if #passedTests > 0 then
    print(" PASSED TESTS:")
    for i, testName in ipairs(passedTests) do
        print("   " .. i .. ". " .. testName)
    end
    print("")
end

if #failedTests > 0 then
    print(" FAILED TESTS:")
    for i, test in ipairs(failedTests) do
        print("   " .. i .. ". " .. test.name .. " - ERROR: " .. test.error)
    end
    print("")
end

print("=== TEST COMPLETED ===")
print("Check the detailed results above for more information.")

