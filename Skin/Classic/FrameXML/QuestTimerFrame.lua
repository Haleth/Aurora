local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\QuestTimerFrame.lua ]]
--end

--do --[[ FrameXML\QuestTimerFrame.xml ]]
--end

function private.FrameXML.QuestTimerFrame()
    local QuestTimerFrame = _G.QuestTimerFrame
    Skin.FrameTypeFrame(QuestTimerFrame)
    QuestTimerFrame:SetBackdropOption("offsets", {
        left = 5,
        right = 5,
        top = 0,
        bottom = 0,
    })

    local bg = QuestTimerFrame:GetBackdropTexture("bg")
    local header, text = QuestTimerFrame:GetRegions()
    header:Hide()
    text:ClearAllPoints()
    text:SetPoint("TOPLEFT", bg)
    text:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
end
