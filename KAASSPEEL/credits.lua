display.setStatusBar(display.HiddenStatusBar)

local composer = require("composer")
local scene = composer.newScene()

local W, H = display.contentWidth, display.contentHeight
local cx, cy = display.contentCenterX, display.contentCenterY

local function makeLine(group, txt, y, size, bold)
  local t = display.newText({
    parent = group,
    text = txt,
    x = cx,
    y = y,
    width = W - 60,
    font = bold and native.systemFontBold or native.systemFont,
    fontSize = size or 18,
    align = "center"
  })
  return t
end

function scene:create(event)
  local g = self.view

  local bg = display.newRect(g, cx, cy, W, H)
  bg:setFillColor(0.05, 0.05, 0.07)

  makeLine(g, "CREDITS", 60, 26, true)

  local y = 110
  makeLine(g, "Gemaakt door", y, 18, true); y = y + 30
  makeLine(g, "Fereshta Sayfi — Developer", y, 17); y = y + 24
  makeLine(g, "Bohdan Hybok — Developer", y, 17); y = y + 35

  makeLine(g, "Code:", y, 18, true); y = y + 26
  makeLine(g, "Fereshta & Bohdan", y, 17); y = y + 32

  makeLine(g, "Design:", y, 18, true); y = y + 26
  makeLine(g, "Fereshta & Bohdan", y, 17); y = y + 32

  makeLine(g, "Teksten:", y, 18, true); y = y + 26
  makeLine(g, "Fereshta & Bohdan", y, 17); y = y + 32

  makeLine(g, "Sound:", y, 18, true); y = y + 26
  makeLine(g, "pixabay.com", y, 16); y = y + 50

  local backBtn = display.newRoundedRect(g, cx, H - 35, 220, 44, 12)
  backBtn:setFillColor(0.15, 0.15, 0.2)

  makeLine(g, "Terug naar menu", H - 35, 18, true)

  backBtn:addEventListener("tap", function()
    composer.gotoScene("menu", { effect="slideRight", time=350 })
  end)
end

scene:addEventListener("create", scene)
return scene
