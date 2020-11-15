local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select

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

    function Hook.NPCFriendshipStatusBar_Update(frame, factionID)
        local statusBar = _G.NPCFriendshipStatusBar
        local id = statusBar.friendshipFactionID
        if id and id > 0 then
            statusBar:SetPoint("TOPLEFT", 60, -41)
            _G.GossipGreetingScrollFrame:SetPoint("TOPLEFT", _G.GossipFrame, 4, -(private.FRAME_TITLE_HEIGHT + 45))
        else
            _G.GossipGreetingScrollFrame:SetPoint("TOPLEFT", _G.GossipFrame, 4, -(private.FRAME_TITLE_HEIGHT + 5))
        end
    end

    function Hook.GossipFrameOptionsUpdate()
        local gossipOptions = _G.C_GossipInfo.GetOptions()
        if #gossipOptions == 0 then return end
        private.debug("GossipFrameOptionsUpdate", #gossipOptions)

        for button in _G.GossipFrame.titleButtonPool:EnumerateActive() do
            if button.type == "Gossip" then
                local gossipText = gossipOptions[button:GetID()].name
                local color = gossipText:match("|c(%x+)%(")
                if color then
                    -- TODO: This was used for BfA war campaign related gossip options, not sure if still is
                    _G.print("GossipFrameOptionsUpdate", button:GetID(), ("|"):split(gossipText))
                    button:SetText(gossipText:gsub("|c(%x+)", "|cFF8888FF"))
                end
            end
        end
    end
end

do --[[ FrameXML\GossipFrame.xml ]]
    function Skin.GossipFramePanelTemplate(Frame)
        Frame:SetPoint("BOTTOMRIGHT")

        local name = Frame:GetName()
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
    _G.hooksecurefunc("NPCFriendshipStatusBar_Update", Hook.NPCFriendshipStatusBar_Update)

    -----------------
    -- GossipFrame --
    -----------------
    local GossipFrame = _G.GossipFrame
    Skin.ButtonFrameTemplate(GossipFrame)
    Util.Mixin(GossipFrame.titleButtonPool, Hook.ObjectPoolMixin)

    if private.isBeta then
        GossipFrame.Background:Hide()
    else
        -- BlizzWTF: This texture doesn't have a handle because the name it's been given already exists via the template
        select(7, GossipFrame:GetRegions()):Hide() -- GossipFrameBg
    end


    local bg = GossipFrame.NineSlice:GetBackdropTexture("bg")
    -- BlizzWTF: This should use the title text included in the template
    _G.GossipFrameNpcNameText:SetAllPoints(GossipFrame.TitleText)

    Skin.GossipFramePanelTemplate(_G.GossipFrameGreetingPanel)
    Skin.UIPanelButtonTemplate(_G.GossipFrameGreetingGoodbyeButton)
    _G.GossipFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", -4, 4)

    Skin.UIPanelScrollFrameTemplate(_G.GossipGreetingScrollFrame)
    _G.GossipGreetingScrollFrame:SetPoint("TOPLEFT", bg, 4, -(private.FRAME_TITLE_HEIGHT + 5))
    _G.GossipGreetingScrollFrame:SetPoint("BOTTOMRIGHT", bg, -23, 30)

    _G.GossipGreetingScrollFrameTop:Hide()
    _G.GossipGreetingScrollFrameBottom:Hide()
    _G.GossipGreetingScrollFrameMiddle:Hide()

    ----------------------------
    -- NPCFriendshipStatusBar --
    ----------------------------
    local NPCFriendshipStatusBar = _G.NPCFriendshipStatusBar
    Skin.FrameTypeStatusBar(NPCFriendshipStatusBar)
    NPCFriendshipStatusBar:GetRegions():Hide()
    NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -20, 7)
    for i = 1, 4 do
        local notch = _G["NPCFriendshipStatusBarNotch"..i]
        notch:SetColorTexture(Color.button:GetRGB())
        notch:SetSize(1, 16)
    end

    local barFillBG = _G.select(7, NPCFriendshipStatusBar:GetRegions())
    barFillBG:Hide()
end
