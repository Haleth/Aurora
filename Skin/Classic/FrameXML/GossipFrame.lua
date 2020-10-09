local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
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
    local gossipDataPerOption = 2
    function Hook.GossipFrameOptionsUpdate(...)
        local numGossipOptions = _G.select("#", ...)
        local buttonIndex = _G.GossipFrame.buttonIndex - (numGossipOptions / gossipDataPerOption)
        for i = 1, numGossipOptions, gossipDataPerOption do
            local gossipText = _G.select(i, ...)
            local button = _G["GossipTitleButton" .. buttonIndex]
            local color = gossipText:match("|c(%x+)%(")
            if color then
                -- This is for BfA war campaign related gossip options
                -- Alliance: FF0000FF
                private.debug("GossipFrameOptionsUpdate", button:GetID(), color, ("|"):split(gossipText))
                button:SetText(gossipText:gsub("|c(%x+)", "|cFF8888FF"))
            end
            buttonIndex = buttonIndex + 1
        end
    end
end

do --[[ FrameXML\GossipFrame.xml ]]
    function Skin.GossipFramePanelTemplate(Frame)
        local bg = Frame:GetParent():GetBackdropTexture("bg")
        Frame:SetAllPoints(bg)

        local top, bottom, left, right = Frame:GetRegions()
        top:Hide()
        bottom:Hide()
        left:Hide()
        right:Hide()

        local name = Frame:GetName()
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
    _G.hooksecurefunc("GossipFrameOptionsUpdate", Hook.GossipFrameOptionsUpdate)
    _G.hooksecurefunc("GossipFrameAvailableQuestsUpdate", Hook.GossipFrameAvailableQuestsUpdate)
    _G.hooksecurefunc("GossipFrameActiveQuestsUpdate", Hook.GossipFrameActiveQuestsUpdate)

    -----------------
    -- GossipFrame --
    -----------------
    local GossipFrame = _G.GossipFrame
    Skin.FrameTypeFrame(GossipFrame)
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

    Skin.GossipFramePanelTemplate(_G.GossipFrameGreetingPanel)
    select(9, _G.GossipFrameGreetingPanel:GetRegions()):Hide() -- patch
    Skin.UIPanelButtonTemplate(_G.GossipFrameGreetingGoodbyeButton)
    _G.GossipFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", -4, 4)

    Skin.UIPanelScrollFrameTemplate(_G.GossipGreetingScrollFrame)
    _G.GossipGreetingScrollFrame:SetPoint("TOPLEFT", bg, 4, -(private.FRAME_TITLE_HEIGHT + 5))
    _G.GossipGreetingScrollFrame:SetPoint("BOTTOMRIGHT", bg, -23, 30)

    _G.GossipGreetingScrollFrameTop:Hide()
    _G.GossipGreetingScrollFrameBottom:Hide()
    _G.GossipGreetingScrollFrameMiddle:Hide()

    for i = 1, _G.NUMGOSSIPBUTTONS do
        Skin.GossipTitleButtonTemplate(_G["GossipTitleButton"..i])
    end
end
