local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    local bg = display.newImageRect(sceneGroup, "fotos/bg.png", display.actualContentWidth, display.actualContentHeight)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    local titleRect = display.newRoundedRect(
        sceneGroup,
        display.contentCenterX,
        display.contentCenterY - 100,
        150,
        60,
        15
    )
    titleRect:setFillColor(1,1,1,0.5)
    local title = display.newText(
        sceneGroup,
        "MENU",
        display.contentCenterX,
        display.contentCenterY - 100,
        native.systemFontBold,
        40
    )
    title:setFillColor(0,0,0)
    
    local btnRect = display.newRoundedRect(
        sceneGroup,
        display.contentCenterX,
        display.contentCenterY,
        225,
        40,
        15
    )
    btnRect:setFillColor(1,1,1,0.5)


    local startBtn = display.newText(
        sceneGroup,
        "Cheese clicker",
        display.contentCenterX,
        display.contentCenterY,
        native.systemFont,
        30
    )
    startBtn:setFillColor(0,0,0)

    startBtn:addEventListener("tap", function()
        composer.gotoScene("game", { effect="slideLeft", time=400 })
    end)

    local btnRect2 = display.newRoundedRect(
        sceneGroup,
        display.contentCenterX,
        display.contentCenterY + 60,
        225,
        40,
        15
    )
    btnRect2:setFillColor(1,1,1,0.5)

    local startBtn2 = display.newText(
        sceneGroup,
        "Whack a cheese",
        display.contentCenterX,
        display.contentCenterY + 60,
        native.systemFont,
        30
    )
    startBtn2:setFillColor(0,0,0)
    startBtn2:addEventListener("tap", function()
        composer.gotoScene("game2", { effect="slideLeft", time=400 })
    end)

    local btnRect3 = display.newRoundedRect(
        sceneGroup,
        display.contentCenterX,
        display.contentCenterY + 120,
        175,
        40,
        15
    )
    btnRect3:setFillColor(1,1,1,0.5)

    local startBtn3 = display.newText(
        sceneGroup,
        "Rat runner",
        display.contentCenterX,
        display.contentCenterY + 120,
        native.systemFont,
        30
    )
    startBtn3:setFillColor(0,0,0)
    startBtn3:addEventListener("tap", function()
        composer.gotoScene("game3", { effect="slideLeft", time=400 })
    end)

    local btnRect4 = display.newRoundedRect(
        sceneGroup,
        display.contentCenterX,
        display.contentCenterY + 180,
        150,
        40,
        15
    )
    btnRect4:setFillColor(1,1,1,0.5)

    local startBtn4 = display.newText(
        sceneGroup,
        "Credit",
        display.contentCenterX,
        display.contentCenterY + 180,
        native.systemFont,
        30
    )
    startBtn4:setFillColor(0,0,0)
    startBtn4:addEventListener("tap", function()
        composer.gotoScene("credits", { effect="slideLeft", time=400 })
    end)
end

scene:addEventListener("create", scene)
return scene
