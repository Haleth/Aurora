local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\GossipFrame.lua ]]
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
        Util.Mixin(Button, Hook.GossipTitleButtonMixin)

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
    Skin.ButtonFrameTemplate(_G.GossipFrame)

    -- BlizzWTF: This texture doesn't have a handle because the name it's been given already exists via the template
    _G.select(7, _G.GossipFrame:GetRegions()):Hide() -- GossipFrameBg

    -- BlizzWTF: This should use the title text included in the template
    _G.GossipFrameNpcNameText:SetAllPoints(_G.GossipFrame.TitleText)

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
