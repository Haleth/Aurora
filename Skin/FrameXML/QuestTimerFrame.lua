local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base

--do --[[ FrameXML\QuestTimerFrame.lua ]]
--end

--do --[[ FrameXML\QuestTimerFrame.xml ]]
--end

function private.FrameXML.QuestTimerFrame()
    local QuestTimerFrame = _G.QuestTimerFrame
    Base.SetBackdrop(QuestTimerFrame)
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
