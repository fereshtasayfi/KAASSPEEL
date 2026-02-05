display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())

local composer = require("composer")
local scene = composer.newScene()

local physics = require("physics")
physics.start()
--de val van kaas en bom
physics.setGravity(0, 18)

display.setStatusBar(display.HiddenStatusBar)

local W, H = display.contentWidth, display.contentHeight
local cx = display.contentCenterX

local worldGroup = display.newGroup()
local uiGroup = display.newGroup()
-- Score
local score = 0
local scoreText = display.newText({
  text = "Kazen: " .. score,
  x = cx,
  y = 20,
  font = native.systemFontBold,
  fontSize = 25
})

local function updateScore(delta)
  score = score + delta
  scoreText.text = "Kazen: " .. score
end

uiGroup:insert(scoreText)

--grond
local groundH = 80
local ground = display.newRect(worldGroup, cx, H - groundH/2, W, groundH)
ground.alpha = 0.1
ground.myName = "ground"
physics.addBody(ground, "static", { friction = 1.0, bounce = 0.0 })

local knop = display.newImageRect(uiGroup, 'fotos/menuW.png', 75,75)
knop.anchorX = 1
knop.anchorY = 0
knop.x = W
knop.y = -50
local function goToMenu()
  composer.gotoScene("menu", { effect="slideLeft", time=400 })
end                  
knop:addEventListener("tap", goToMenu)

--speler
local rat
local function makeRat()
  local ok = pcall(function()
    rat = display.newImageRect(worldGroup, "fotos/rat.png", 60, 60) 
  end)

  rat.x, rat.y = cx, H - groundH - 20
  rat.myName = "rat"
  physics.addBody(rat, "kinematic", { radius = 30, isSensor = true })
end
makeRat()

--beweging
local moveDir = 0        
local moveSpeed = 520

local function onKey(event)

  local k = event.keyName
  local p = event.phase

  if p == "down" then
    if k == "left" then
      moveDir = -1
      return true
    elseif k == "right" then
      moveDir = 1
      return true
    end
  elseif p == "up" then
    if k == "left" and moveDir == -1 then
      moveDir = 0
      return true
    elseif k == "right" and moveDir == 1 then
      moveDir = 0
      return true
    end
  end

  return false
end
Runtime:addEventListener("key", onKey)

--kaas en bom
local function spawnFalling(kind)
  local obj

  if kind == "kaas" then
    local ok = pcall(function()
      obj = display.newImageRect(worldGroup, "fotos/kaas.png", 55, 55)
    end)
    if not ok or not obj then
      obj = display.newCircle(worldGroup, 0, 0, 22)
      obj:setFillColor(1, 0.9, 0.2)
    end
    obj.myName = "kaas"
    physics.addBody(obj, "dynamic", { radius = 22, bounce = 0.1 })
  else
    local ok = pcall(function()
      obj = display.newImageRect(worldGroup, "fotos/trap.png", 60, 60)
    end)
    if not ok or not obj then
      obj = display.newRect(worldGroup, 0, 0, 55, 40)
      obj:setFillColor(0.3, 0.3, 0.3)
    end
    obj.myName = "trap"
    physics.addBody(obj, "dynamic", { box = { halfWidth = 27, halfHeight = 20 }, bounce = 0.0 })
  end

  obj.x = math.random(40, W - 40)
  obj.y = -60
  obj.isBullet = true
  obj.linearDamping = 0.2
  obj.angularVelocity = math.random(-90, 90)

  return obj
end

local function spawnLoop()
  if math.random() < 0.7 then
    spawnFalling("kaas")
  else
    spawnFalling("trap")
  end
end
local spawnTimer = timer.performWithDelay(650, spawnLoop, 0)

local function safeRemove(o)
  if o and o.removeSelf and o.parent then
    display.remove(o)
  end
end
--rat
local function onGlobalCollision(event)
  if event.phase ~= "began" then return end

  local a, b = event.object1, event.object2
  if not a or not b then return end


  if a.myName == "rat" and (b.myName == "kaas" or b.myName == "trap") then
    if b.myName == "kaas" then updateScore(1) else updateScore(-1) end
    safeRemove(b)
    return
  elseif b.myName == "rat" and (a.myName == "kaas" or a.myName == "trap") then
    if a.myName == "kaas" then updateScore(1) else updateScore(-1) end
    safeRemove(a)
    return
  end


  if a.myName == "ground" and (b.myName == "kaas" or b.myName == "trap") then
    safeRemove(b)
    return
  elseif b.myName == "ground" and (a.myName == "kaas" or a.myName == "trap") then
    safeRemove(a)
    return
  end
end
Runtime:addEventListener("collision", onGlobalCollision)


local prevTime = system.getTimer()
local function onEnterFrame()
  local t = system.getTimer()
  local dt = (t - prevTime) / 1000
  prevTime = t

  if rat and rat.x then
    rat.x = rat.x + moveDir * moveSpeed * dt

    local minX = 35
    local maxX = W - 35
    if rat.x < minX then rat.x = minX end
    if rat.x > maxX then rat.x = maxX end
  end
end

Runtime:addEventListener("enterFrame", onEnterFrame)




return scene