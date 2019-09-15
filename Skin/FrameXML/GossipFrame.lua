local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\GossipFrame.lua ]]
    local availDataPerQuest, activeDataPerQuest = 7, 6
    function Hook.GossipFrameAvailableQuestsUpdate(...)
        local numAvailQuestsData = _G.select("#", ...)
        local buttonIndex = (_G.GossipFrame.buttonIndex - 1) - (numAvailQuestsData / availDataPerQuest)
        for i = 1, numAvailQuestsData, availDataPerQuest do
            local titleText, _, isTrivial = _G.select(i, ...)
            local titleButton = _G["GossipTitleButton" .. buttonIndex]
            if isTrivial then
                titleButton:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, titleText)
            else
                titleButton:SetFormattedText(private.NORMAL_QUEST_DISPLAY, titleText)
            end
            buttonIndex = buttonIndex + 1
        end
    end
    function Hook.GossipFrameActiveQuestsUpdate(...)
        local numActiveQuestsData = _G.select("#", ...)
        local buttonIndex = (_G.GossipFrame.buttonIndex - 1) - (numActiveQuestsData / activeDataPerQuest)
        for i = 1, numActiveQuestsData, activeDataPerQuest do
            local titleText, _, isTrivial = _G.select(i, ...)
            local titleButton = _G["GossipTitleButton" .. buttonIndex]
            if isTrivial then
                titleButton:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, titleText)
            else
                titleButton:SetFormattedText(private.NORMAL_QUEST_DISPLAY, titleText)
            end
            buttonIndex = buttonIndex + 1
        end
    end
end

do --[[ FrameXML\GossipFrame.xml ]]
    function Skin.GossipFramePanelTemplate(Frame)
        local name = Frame:GetName()
        Frame:SetPoint("BOTTOMRIGHT")

        _G[name.."MaterialTopLeft"]:SetAlpha(0)
        _G[name.."MaterialTopRight"]:SetAlpha(0)
        _G[name.."MaterialBotLeft"]:SetAlpha(0)
        _G[name.."MaterialBotRight"]:SetAlpha(0)
    end
    function Skin.GossipTitleButtonTemplate(Button)
        local highlight = Button:GetHighlightTexture()
        local r, g, b = Color.highlight:GetRGB()
        highlight:SetColorTexture(r, g, b, 0.2)
    end
end

function private.FrameXML.GossipFrame()
    _G.hooksecurefunc("GossipFrameAvailableQuestsUpdate", Hook.GossipFrameAvailableQuestsUpdate)
    _G.hooksecurefunc("GossipFrameActiveQuestsUpdate", Hook.GossipFrameActiveQuestsUpdate)

    -----------------
    -- GossipFrame --
    -----------------
    _G.GossipFramePortrait:SetAlpha(0)
    for i = 1, 4 do
        select(i, _G.GossipFrameGreetingPanel:GetRegions()):Hide()
    end
    select(9, _G.GossipFrameGreetingPanel:GetRegions()):Hide()
    Base.SetBackdrop(_G.GossipFrame)
    Skin.UIPanelCloseButton(_G.GossipFrameCloseButton)
    _G.GossipFrameCloseButton:SetPoint("TOPRIGHT", 4, 4)

    --_G.GossipFrameNpcNameText:SetAllPoints(_G.GossipFrame.TitleText)

    Skin.GossipFramePanelTemplate(_G.GossipFrameGreetingPanel)
    Skin.UIPanelButtonTemplate(_G.GossipFrameGreetingGoodbyeButton)
    _G.GossipFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", -4, 4)

    Skin.UIPanelScrollFrameTemplate(_G.GossipGreetingScrollFrame)
    _G.GossipGreetingScrollFrame:SetPoint("TOPLEFT", _G.GossipFrame, 4, -(private.FRAME_TITLE_HEIGHT + 4))
    _G.GossipGreetingScrollFrame:SetPoint("BOTTOMRIGHT", _G.GossipFrame, -23, 30)

    _G.GossipGreetingScrollFrameTop:Hide()
    _G.GossipGreetingScrollFrameBottom:Hide()
    _G.GossipGreetingScrollFrameMiddle:Hide()

    for i = 1, _G.NUMGOSSIPBUTTONS do
        Skin.GossipTitleButtonTemplate(_G["GossipTitleButton"..i])
    end

    ----------------------------
    -- NPCFriendshipStatusBar --
    ----------------------------
    _G.NPCFriendshipStatusBar:GetRegions():Hide()
    _G.NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -20, 7)
    for i = 1, 4 do
        local notch = _G["NPCFriendshipStatusBarNotch"..i]
        notch:SetColorTexture(0, 0, 0)
        notch:SetSize(1, 16)
    end

    local bg = _G.select(7, _G.NPCFriendshipStatusBar:GetRegions())
    bg:SetPoint("TOPLEFT", -1, 1)
    bg:SetPoint("BOTTOMRIGHT", 1, -1)
end
