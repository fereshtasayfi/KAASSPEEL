display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())

local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")

local W,H = display.contentWidth, display.contentHeight
local cx = display.contentCenterX

local worldGroup, uiGroup
local rat, ground, scoreText, spawnTimer, knop
local score = 0
local moveDir, moveSpeed = 0, 520
local prevTime = 0

local function safeRemove(o)
  if o and o.removeSelf and o.parent then display.remove(o) end
end

local function updateScore(d)
  score = score + d
  if scoreText then scoreText.text = "Kazen: " .. score end
end

local function onKey(e)
  if e.phase == "down" then
    if e.keyName == "left" then moveDir = -1 return true end
    if e.keyName == "right" then moveDir = 1 return true end
  elseif e.phase == "up" then
    if e.keyName == "left" and moveDir == -1 then moveDir = 0 return true end
    if e.keyName == "right" and moveDir == 1 then moveDir = 0 return true end
  end
  return false
end

local function onEnterFrame()
  local t = system.getTimer()
  local dt = (t - prevTime) / 1000
  prevTime = t
  if rat then
    rat.x = rat.x + moveDir * moveSpeed * dt
    if rat.x < 35 then rat.x = 35 end
    if rat.x > W-35 then rat.x = W-35 end
  end
end

local function onCollision(e)
  if e.phase ~= "began" then return end
  local a,b = e.object1, e.object2
  if not a or not b then return end

  local function hitRat(obj)
    if obj.myName == "kaas" then updateScore(1) else updateScore(-1) end
    safeRemove(obj)
  end

  if a.myName == "rat" and (b.myName=="kaas" or b.myName=="trap") then hitRat(b) return end
  if b.myName == "rat" and (a.myName=="kaas" or a.myName=="trap") then hitRat(a) return end
  if a.myName == "ground" and (b.myName=="kaas" or b.myName=="trap") then safeRemove(b) return end
  if b.myName == "ground" and (a.myName=="kaas" or a.myName=="trap") then safeRemove(a) return end
end

local function spawn(kind)
  local obj, ok

  if kind == "kaas" then
    ok = pcall(function() obj = display.newImageRect(worldGroup, "fotos/kaas.png", 55, 55) end)
    if (not ok) or (not obj) then obj = display.newCircle(worldGroup,0,0,22) end
    obj.myName="kaas"
    physics.addBody(obj,"dynamic",{radius=22,bounce=0.1})
  else
    ok = pcall(function() obj = display.newImageRect(worldGroup, "fotos/trap.png", 60, 60) end)
    if (not ok) or (not obj) then obj = display.newRect(worldGroup,0,0,55,40) end
    obj.myName="trap"
    physics.addBody(obj,"dynamic",{box={halfWidth=27,halfHeight=20},bounce=0})
  end

  obj.x = math.random(40, W-40)
  obj.y = -60
  obj.isBullet = true
  obj.angularVelocity = math.random(-90,90)
end

local function spawnLoop()
  if math.random() < 0.7 then spawn("kaas") else spawn("trap") end
end

function scene:create(event)
  local g = self.view

  physics.start()
  physics.setGravity(0,18)

  worldGroup = display.newGroup()
  uiGroup = display.newGroup()
  g:insert(worldGroup); g:insert(uiGroup)

  score = 0
  scoreText = display.newText({text="Kazen: 0", x=cx, y=20, font=native.systemFontBold, fontSize=25})
  uiGroup:insert(scoreText)

  ground = display.newRect(worldGroup, cx, H-40, W, 80)
  ground.alpha=0.1
  ground.myName="ground"
  physics.addBody(ground,"static",{friction=1,bounce=0})

  knop = display.newImageRect(uiGroup, "fotos/menuW.png", 75, 75)
  knop.anchorX,knop.anchorY = 1,0
  knop.x,knop.y = W-10, 10
  knop:addEventListener("tap", function()
    composer.gotoScene("menu",{effect="slideLeft",time=400})
  end)

  local okR = pcall(function() rat = display.newImageRect(worldGroup,"fotos/rat.png",60,60) end)
  if (not okR) or (not rat) then rat = display.newCircle(worldGroup,0,0,30) end
  rat.x, rat.y = cx, H-80-20
  rat.myName="rat"
  physics.addBody(rat,"kinematic",{radius=30,isSensor=true})

  prevTime = system.getTimer()
end

function scene:show(e)
  if e.phase=="did" then
    physics.start()
    physics.setGravity(0,18)
    moveDir = 0
    prevTime = system.getTimer()

    Runtime:addEventListener("key", onKey)
    Runtime:addEventListener("enterFrame", onEnterFrame)
    Runtime:addEventListener("collision", onCollision)
    spawnTimer = timer.performWithDelay(650, spawnLoop, 0)
  end
end

function scene:hide(e)
  if e.phase=="will" then
    Runtime:removeEventListener("key", onKey)
    Runtime:removeEventListener("enterFrame", onEnterFrame)
    Runtime:removeEventListener("collision", onCollision)
    if spawnTimer then timer.cancel(spawnTimer); spawnTimer=nil end
    physics.pause()
  end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
