local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\PVEFrame.lua ]]
    function Hook.GroupFinderFrame_SelectGroupButton(index)
        local self = _G.GroupFinderFrame
        for i = 1, 4 do
            local button = self["groupButton"..i]
            if i == index then
                button.bg:Show()
            else
                button.bg:Hide()
            end
        end
    end
end

do --[[ FrameXML\PVEFrame.xml ]]
    function Skin.GroupFinderGroupButtonTemplate(Button)
        Base.SetBackdrop(Button, Color.button)
        Button:SetBackdropBorderColor(Color.frame, 1)
        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", Button.icon, "TOPRIGHT", 0, 1)
        bg:SetPoint("BOTTOM", Button.icon, 0, -1)
        bg:SetPoint("RIGHT")

        Button.bg:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.bg:SetAllPoints(bg)
        Button.bg:Hide()
        Button.ring:Hide()
        Base.CropIcon(Button.icon, Button)

        local highlight = Button:GetHighlightTexture()
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        highlight:SetAllPoints(bg)
    end
end

function private.FrameXML.PVEFrame()
    _G.hooksecurefunc("GroupFinderFrame_SelectGroupButton", Hook.GroupFinderFrame_SelectGroupButton)

    local PVEFrame = _G.PVEFrame
    Skin.PortraitFrameTemplate(PVEFrame)

    _G.PVEFrameBlueBg:Hide()
    _G.PVEFrameTLCorner:Hide()
    _G.PVEFrameTRCorner:Hide()
    _G.PVEFrameBRCorner:Hide()
    _G.PVEFrameBLCorner:Hide()
    _G.PVEFrameLLVert:Hide()
    _G.PVEFrameRLVert:Hide()
    _G.PVEFrameBottomLine:Hide()
    _G.PVEFrameTopLine:Hide()
    _G.PVEFrameTopFiligree:Hide()
    _G.PVEFrameBottomFiligree:Hide()

    Skin.InsetFrameTemplate(PVEFrame.Inset)
    Skin.CharacterFrameTabButtonTemplate(PVEFrame.tab1)
    Skin.CharacterFrameTabButtonTemplate(PVEFrame.tab2)
    Skin.CharacterFrameTabButtonTemplate(PVEFrame.tab3)
    Util.PositionRelative("TOPLEFT", PVEFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        PVEFrame.tab1,
        PVEFrame.tab2,
        PVEFrame.tab3,
    })

    local GroupFinderFrame = _G.GroupFinderFrame
    Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton1)
    Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton2)
    GroupFinderFrame.groupButton2:SetPoint("LEFT", GroupFinderFrame.groupButton1)
    Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton3)
    GroupFinderFrame.groupButton3:SetPoint("LEFT", GroupFinderFrame.groupButton2)
    Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton4)
    GroupFinderFrame.groupButton4:SetPoint("LEFT", GroupFinderFrame.groupButton3)
    GroupFinderFrame.groupButton1.icon:SetTexture([[Interface\Icons\INV_Helmet_08]])
    GroupFinderFrame.groupButton2.icon:SetTexture([[Interface\Icons\Icon_Scenarios]])
    GroupFinderFrame.groupButton3.icon:SetTexture([[Interface\Icons\INV_Helmet_06]])
    GroupFinderFrame.groupButton4.icon:SetTexture([[Interface\Icons\Achievement_General_StayClassy]])

    PVEFrame.shadows:Hide()


    -------------
    -- Section --
    -------------
end
