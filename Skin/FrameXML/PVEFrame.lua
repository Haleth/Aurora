local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\PVEFrame.lua ]]
    function Hook.GroupFinderFrame_SelectGroupButton(index)
        for i = 1, 4 do
            local button = _G.GroupFinderFrame["groupButton"..i]
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
        Skin.FrameTypeButton(Button)

        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", Button.icon, 0, 1)
        bg:SetPoint("BOTTOM", Button.icon, 0, -1)
        bg:SetPoint("RIGHT")

        Button.bg:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.bg:SetAllPoints(bg)
        Button.bg:Hide()

        Button.ring:Hide()
        Base.CropIcon(Button.icon)
    end
end

function private.FrameXML.PVEFrame()
    _G.hooksecurefunc("GroupFinderFrame_SelectGroupButton", Hook.GroupFinderFrame_SelectGroupButton)

    local PVEFrame = _G.PVEFrame
    Skin.PortraitFrameTemplate(PVEFrame)

    _G.PVEFrameBlueBg:SetAlpha(0)
    _G.PVEFrameTLCorner:SetAlpha(0)
    _G.PVEFrameTRCorner:SetAlpha(0)
    _G.PVEFrameBRCorner:SetAlpha(0)
    _G.PVEFrameBLCorner:SetAlpha(0)
    _G.PVEFrameLLVert:SetAlpha(0)
    _G.PVEFrameRLVert:SetAlpha(0)
    _G.PVEFrameBottomLine:SetAlpha(0)
    _G.PVEFrameTopLine:SetAlpha(0)
    _G.PVEFrameTopFiligree:SetAlpha(0)
    _G.PVEFrameBottomFiligree:SetAlpha(0)

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

    _G.LFGListPVEStub:SetWidth(339)
    PVEFrame.shadows:SetAlpha(0)
end
