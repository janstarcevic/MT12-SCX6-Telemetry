-- scx6_spicy_dash.lua
-- Jazzed-up MT-12 dashboard with Avg Cell Voltage Center Stage + Gradient Battery Messages

local modelName      = "SCX6"
local packVoltSensor = "Batt"
local CALIBRATION_OFFSET = 0.00 -- adjust as you did in the sensor menu, or set to 0 if already offset
local capacity_mAh   = 10400
local avgCurrentA    = 8
local maxRunMin      = (capacity_mAh / 1000) / avgCurrentA * 60

local SW, SH = 128, 64

local function detectCells(volts)
  local best_cells = 1
  local best_score = 999
  for cells = 2, 6 do
    local perCell = volts / cells
    if perCell >= 3.0 and perCell <= 4.25 then
      -- As soon as we find the first fit, return it (lowest valid S count)
      return cells
    end
  end
  return 1 -- fallback if nothing fits
end

local function pct(v, lo, hi)
  local p = (v - lo) / (hi - lo) * 100
  if p < 0 then p = 0 elseif p > 100 then p = 100 end
  return p
end

-- Fat battery bar, still available for visual reference
local function drawFatBatteryBar(volts, cells)
  local full  = cells * 4.2
  local empty = cells * 3.5
  local p     = pct(volts, empty, full)

  local barW = 68
  local barH = 28
  local barX = 0
  local barY = 10

  lcd.drawRectangle(barX, barY, barW, barH)

  local fillW = math.floor(barW * p / 100)
  if fillW > 1 then
    lcd.drawFilledRectangle(barX + 1, barY + 1, fillW - 2, barH - 2)
  end

  local percentText = string.format("%d%%", p)
  local textX = barX + math.floor((barW - 18) / 2)
  local textY = barY + 7
  lcd.drawText(textX, textY, percentText, INVERS)
end

local function drawAvgCellVoltage(volts, cells)
  local avgCell = volts / cells
  local boxW, boxH = 54, 28
  local boxX = 128 - boxW - 0   -- 128 = screen width, right aligned
  local boxY = 10               -- just below the top line and header

  lcd.drawFilledRectangle(boxX, boxY, boxW, boxH)
  lcd.drawText(boxX + 6, boxY + 2, "AVG CELL", SMLSIZE + INVERS)
  lcd.drawText(boxX + 6, boxY + 10, string.format("%.2fV", avgCell), DBLSIZE + INVERS)
end

local function drawRuntime(volts, cells)
  local soc  = pct(volts / cells, 3.4, 4.2) / 100
  local left = maxRunMin * soc
  if left < 0 then left = 0 end

  local yBase = 45
  lcd.drawText(2, yBase, "Time: " .. math.floor(left) .. " min")
  lcd.drawText(2, yBase + 10, "Pack: " .. string.format("%.2fV", volts))
end

local function drawDriveMode()
  local sa = getValue("sa") or 0
  local label = "DRIVE"
  if sa < -512 then
    label = "SLOW"
  elseif sa > 512 then
    label = "FAST"
  end

  local boxX, boxY, boxW, boxH = SW - 54, SH - 20, 54, 20
  lcd.drawFilledRectangle(boxX, boxY, boxW, boxH)
  lcd.drawText(boxX + 2, boxY + 2, label, INVERS + DBLSIZE)
end

local function drawClock()
  local dt = getDateTime()
  local hh = string.format("%02d", dt.hour)
  local mm = string.format("%02d", dt.min)
  if math.floor(getTime()/100) % 2 == 0 then hh = hh .. ":" end
  lcd.drawText(SW - 25, 0, hh, SMLSIZE)
  lcd.drawText(SW - 13, 0, mm, SMLSIZE)
end

-- Voltage Message Gradient
local function drawVoltageMessage(volts, cells)
  local avgCell = volts / cells
  local msg = ""
  local style = DBLSIZE + INVERS

  if avgCell >= 4.0 then
    msg = "FULL"
    style = DBLSIZE + INVERS
    elseif avgCell >= 3.8 then
    msg = "LOTS"
    style = DBLSIZE + INVERS
  elseif avgCell >= 3.7 then
    msg = "HALF"
    style = DBLSIZE + INVERS
  elseif avgCell >= 3.6 then
    msg = "LOW"
    style = DBLSIZE + INVERS
  elseif avgCell >= 3.5 then
    msg = "SWAP"
    -- Blinking: flashes every ~1 sec
    if getTime() % 64 < 32 then
      style = DBLSIZE + BLINK + INVERS
    else
      style = DBLSIZE + INVERS
    end
  else
    msg = "OFF"
    -- Blinking: flashes every ~0.5 sec
    if getTime() % 32 < 16 then
      style = DBLSIZE + BLINK + INVERS
    else
      style = DBLSIZE + INVERS
    end
  end
  -- Draw message centered under main bar
  lcd.drawText(12, 16, msg, style)
end

-- Main run function
local function run()
  lcd.clear()

  -- Use calibrated voltage for all calculations
  local rawVolts = getValue(packVoltSensor) or 0
  local volts = rawVolts + CALIBRATION_OFFSET
  local cells = detectCells(volts)
  local info = model.getInfo()
  modelName = (info and info.name) or modelName

  -- Show model and cell count on top left (e.g., "SCX6  3S")
if cells == 1 then
  lcd.drawText(2, 0, modelName .. " needs power", SMLSIZE)
else
  lcd.drawText(2, 0, modelName .. " on " .. cells .. "S", SMLSIZE)
end

  -- Draw line under header
  lcd.drawLine(0, 7, SW, 7, SOLID, 0)

  -- Fat battery bar
  drawFatBatteryBar(volts, cells)

  -- Voltage status message (gradient & blinking)
  drawVoltageMessage(volts, cells)

  -- The rest of your display
  drawAvgCellVoltage(volts, cells)
  drawRuntime(volts, cells)
  drawDriveMode()
  drawClock()
  return 0
end

return { run = run }