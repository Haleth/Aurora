local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals unpack select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\QuestLogFrame.lua ]]
    for i = 1, 10 do
        _G.hooksecurefunc(_G["QuestLogObjective"..i], "SetTextColor", function(self, r, g, b)
            if r == 0 then
                self:SetTextColor(.9, .9, .9)
            elseif r == .2 then
                self:SetTextColor(1, 1, 1)
            end
        end)
    end
end

do --[[ FrameXML\QuestLogFrame.xml ]]
    function Skin.QuestLogTitleButtonTemplate(Frame)
        if Frame.isHeader then
            Skin.ExpandOrCollapse(Frame)
        end
    end
end

function private.FrameXML.QuestLogFrame()
	local QuestLogFrame = _G.QuestLogFrame
    -- BlizzWTF: Portrait has no name / key
    for i = 2, 6 do
        select(i, QuestLogFrame:GetRegions()):Hide()
    end
    Base.SetBackdrop(QuestLogFrame)
    Skin.UIPanelCloseButton(_G.QuestLogFrameCloseButton)
    _G.QuestLogFrameCloseButton:SetPoint("TOPRIGHT", QuestLogFrame, "TOPRIGHT", 4, 5)

    Skin.UIPanelButtonTemplate(_G.QuestLogFrameAbandonButton)
    Skin.UIPanelButtonTemplate(_G.QuestFramePushQuestButton)
    Skin.UIPanelButtonTemplate(_G.QuestFrameExitButton)

    Util.PositionRelative("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 15, 15, 5, "Right", {
        _G.QuestLogFrameAbandonButton,
        _G.QuestFramePushQuestButton,
        _G.QuestFrameExitButton,
    })

    Skin.UIPanelScrollFrameTemplate(_G.QuestLogListScrollFrame)
    Skin.UIPanelScrollFrameTemplate(_G.QuestLogDetailScrollFrame)
    -- TODO: Skin Expands, use hook?
    --for i = 1, 6 do
    --    Skin.QuestLogTitleButtonTemplate(_G["QuestLogTitle"..i])
    --end
end