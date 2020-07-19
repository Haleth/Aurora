local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\GossipFrame.lua ]]
    if private.isRetail then
        Hook.GossipTitleButtonMixin = {}
        function Hook.GossipTitleButtonMixin:UpdateTitleForQuest(questID, titleText, isIgnored, isTrivial)
            if isIgnored then
                self:SetFormattedText(private.IGNORED_QUEST_DISPLAY, titleText)
            elseif isTrivial then
                self:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, titleText)
            else
                self:SetFormattedText(private.NORMAL_QUEST_DISPLAY, titleText)
            end
        end
    else
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

    if private.isPatch then
        function Hook.GossipFrameOptionsUpdate()
            local gossipOptions = _G.C_GossipInfo.GetOptions()
            for button in _G.GossipFrame.titleButtonPool:EnumerateActive() do
                local gossipText = gossipOptions[button:GetID()].name
                local color = gossipText:match("|c(%x+)%(")
                if color then
                    --print("GossipFrameOptionsUpdate Found gossip color")
                    button:SetText(gossipText:gsub("|c(%x+)", "|cFF8888FF"))
                end
            end
        end
    else
        local gossipDataPerOption = 2
        function Hook.GossipFrameOptionsUpdate(...)
            local numGossipOptions = _G.select("#", ...)
            local buttonIndex = _G.GossipFrame.buttonIndex - (numGossipOptions / gossipDataPerOption)
            for i = 1, numGossipOptions, gossipDataPerOption do
                local gossipText = _G.select(i, ...)
                local titleButton = _G["GossipTitleButton" .. buttonIndex]
                local color = gossipText:match("|c(%x+)%(")
                if color then
                    private.debug("GossipFrameOptionsUpdate", color)
                    titleButton:SetText(gossipText:gsub("|c(%x+)", "|cFF8888FF"))
                end
                buttonIndex = buttonIndex + 1
            end
        end
    end

end

do --[[ FrameXML\GossipFrame.xml ]]
    function Skin.GossipFramePanelTemplate(Frame)
        if private.isRetail then
            Frame:SetPoint("BOTTOMRIGHT")
        else
            local bg = Frame:GetParent():GetBackdropTexture("bg")
            Frame:SetAllPoints(bg)

            local top, bottom, left, right = Frame:GetRegions()
            top:Hide()
            bottom:Hide()
            left:Hide()
            right:Hide()
        end

        local name = Frame:GetName()
        _G[name.."MaterialTopLeft"]:SetAlpha(0)
        _G[name.."MaterialTopRight"]:SetAlpha(0)
        _G[name.."MaterialBotLeft"]:SetAlpha(0)
        _G[name.."MaterialBotRight"]:SetAlpha(0)
    end
    function Skin.GossipTitleButtonTemplate(Button)
        if private.isRetail then
            Util.Mixin(Button, Hook.GossipTitleButtonMixin)
        end

        local highlight = Button:GetHighlightTexture()
        local r, g, b = Color.highlight:GetRGB()
        highlight:SetColorTexture(r, g, b, 0.2)
    end
end

function private.FrameXML.GossipFrame()
    _G.hooksecurefunc("GossipFrameOptionsUpdate", Hook.GossipFrameOptionsUpdate)

    -----------------
    -- GossipFrame --
    -----------------
    local GossipFrame = _G.GossipFrame
    if private.isRetail then
        Skin.ButtonFrameTemplate(GossipFrame)

        -- BlizzWTF: This texture doesn't have a handle because the name it's been given already exists via the template
        select(7, GossipFrame:GetRegions()):Hide() -- GossipFrameBg

        -- BlizzWTF: This should use the title text included in the template
        _G.GossipFrameNpcNameText:SetAllPoints(GossipFrame.TitleText)
    else
        _G.hooksecurefunc("GossipFrameAvailableQuestsUpdate", Hook.GossipFrameAvailableQuestsUpdate)
        _G.hooksecurefunc("GossipFrameActiveQuestsUpdate", Hook.GossipFrameActiveQuestsUpdate)

        Base.SetBackdrop(GossipFrame)
        GossipFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local bg = GossipFrame:GetBackdropTexture("bg")
        _G.GossipFramePortrait:Hide()
        _G.GossipFrameNpcNameText:ClearAllPoints()
        _G.GossipFrameNpcNameText:SetPoint("TOPLEFT", bg)
        _G.GossipFrameNpcNameText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Skin.UIPanelCloseButton(_G.GossipFrameCloseButton)
    end

    Skin.GossipFramePanelTemplate(_G.GossipFrameGreetingPanel)
    if private.isClassic then
        select(9, _G.GossipFrameGreetingPanel:GetRegions()):Hide() -- patch
    end
    Skin.UIPanelButtonTemplate(_G.GossipFrameGreetingGoodbyeButton)
    _G.GossipFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", -4, 4)

    Skin.UIPanelScrollFrameTemplate(_G.GossipGreetingScrollFrame)
    if private.isRetail then
        _G.GossipGreetingScrollFrame:SetPoint("TOPLEFT", GossipFrame, 4, -(private.FRAME_TITLE_HEIGHT + 4))
        _G.GossipGreetingScrollFrame:SetPoint("BOTTOMRIGHT", GossipFrame, -23, 30)
    else
        local bg = GossipFrame:GetBackdropTexture("bg")
        _G.GossipGreetingScrollFrame:SetPoint("TOPLEFT", bg, 4, -(private.FRAME_TITLE_HEIGHT + 5))
        _G.GossipGreetingScrollFrame:SetPoint("BOTTOMRIGHT", bg, -23, 30)
    end

    _G.GossipGreetingScrollFrameTop:Hide()
    _G.GossipGreetingScrollFrameBottom:Hide()
    _G.GossipGreetingScrollFrameMiddle:Hide()

    if not private.isPatch then
        for i = 1, _G.NUMGOSSIPBUTTONS do
            Skin.GossipTitleButtonTemplate(_G["GossipTitleButton"..i])
        end
    end

    ----------------------------
    -- NPCFriendshipStatusBar --
    ----------------------------
    if private.isRetail then
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
end
