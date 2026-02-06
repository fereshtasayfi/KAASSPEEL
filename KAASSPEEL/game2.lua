display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())

local composer = require("composer")
local scene = composer.newScene()

local saveFile = 'maxScore.txt'

local function loadMaxScore()
    local path = system.pathForFile(saveFile, system.DocumentsDirectory)
    local file = io.open(path, "r")
    if file then
        local contents = file:read("*a")
        io.close(file)
        return tonumber(contents) or 0
    end
    return 0
end

local gameActive = true
local currentScore = 0
local scoreText
local maxScoreText
local mole
local maxScore = loadMaxScore()
local a = 1/6
local d = 1/2
local H = display.contentHeight
local W = display.contentWidth

local gameTime = 30
local timeLeft = gameTime
local timeText
local countdownTimer

local moleMoveTimer

local function saveMaxScore(value)
    local path = system.pathForFile(saveFile, system.DocumentsDirectory)
    local file = io.open(path, 'w')
    if file then
        file:write(tostring(value))
        io.close(file)
    end
end

function scene:create(event)
    local sceneGroup = self.view

    local bg = display.newImageRect(sceneGroup, "fotos/content.png", display.actualContentWidth, display.actualContentHeight)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    local knop = display.newImageRect(sceneGroup, "fotos/menu.png", 75, 75)
    knop.anchorX = 1
    knop.anchorY = 0
    knop.x = W - 10
    knop.y = 10
    knop:addEventListener("tap", function()
        composer.gotoScene("menu", { effect="slideLeft", time=400 })
    end)

    scoreText = display.newText({
        parent = sceneGroup,
        text = "Score: 0",
        x = d*W,
        y = 25,
        font = native.systemFont,
        fontSize = 30
    })
    scoreText:setFillColor(1, 0.9, 0.2)
    scoreText.strokeWidth = 4
    scoreText:setStrokeColor(1,0,0)

    maxScoreText = display.newText({
        parent = sceneGroup,
        text = "Max: " .. maxScore,
        x = a*W,
        y = 25,
        font = native.systemFont,
        fontSize = 15
    })
    maxScoreText:setFillColor(1, 0.9, 0.2)

    timeText = display.newText({
        parent = sceneGroup,
        text = "Time: " .. gameTime,
        x = display.contentCenterX,
        y = 70,
        font = native.systemFontBold,
        fontSize = 36
    })
    timeText:setFillColor(1,1,0)
end

local function updateCountdown()
    timeLeft = timeLeft - 1
    timeText.text = "Time: " .. timeLeft

    if timeLeft <= 0 then
        if countdownTimer then timer.cancel(countdownTimer); countdownTimer=nil end
        if moleMoveTimer then timer.cancel(moleMoveTimer); moleMoveTimer=nil end

        composer.setVariable("currentScore", currentScore)
        composer.setVariable("maxScore", maxScore)

        composer.gotoScene("gameover", { time = 600, effect = "fade" })
    end
end

local function removeMole()
    if mole and mole.removeSelf then
        mole:removeSelf()
        mole = nil
    end
end

local function spawnMole()
    removeMole()

    if not gameActive then return end

    local x = math.random(50, display.contentWidth - 50)
    local y = math.random(120, display.contentHeight - 120)

    local sceneGroup = scene.view

    mole = display.newImageRect(sceneGroup, "fotos/kaas.png", 90, 90)
    mole.x = x
    mole.y = y

    mole:addEventListener("touch", function(event)
        if event.phase ~= "began" then return false end
        if not gameActive then return true end

        currentScore = currentScore + 1
        scoreText.text = "Score: " .. currentScore

        if currentScore > maxScore then
            maxScore = currentScore
            maxScoreText.text = "Max: " .. maxScore
            saveMaxScore(maxScore)
        end

        spawnMole()
        return true
    end)
end

local function moveMole()
    if not gameActive then return end
    if not mole then return end
    spawnMole()
end

function scene:show(event)
    if event.phase == "did" then
        currentScore = 0
        scoreText.text = "Score: 0"
        timeLeft = gameTime
        timeText.text = "Time: " .. gameTime
        gameActive = true

        spawnMole()

        if countdownTimer then timer.cancel(countdownTimer) end
        countdownTimer = timer.performWithDelay(1000, updateCountdown, gameTime)

        if moleMoveTimer then timer.cancel(moleMoveTimer) end
        moleMoveTimer = timer.performWithDelay(1500, moveMole, 0)
    end
end

function scene:hide(event)
    if event.phase == "will" then
        gameActive = false
        removeMole()

        if countdownTimer then
            timer.cancel(countdownTimer)
            countdownTimer = nil
        end

        if moleMoveTimer then
            timer.cancel(moleMoveTimer)
            moleMoveTimer = nil
        end
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
