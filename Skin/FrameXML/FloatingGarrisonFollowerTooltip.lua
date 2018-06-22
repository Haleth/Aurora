local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\FloatingGarrisonFollowerTooltip.lua ]]
    function Hook.GarrisonFollowerAbilityTooltipTemplate_SetAbility(tooltipFrame, garrFollowerAbilityID, followerTypeID)
        if tooltipFrame.CounterIcon then
            tooltipFrame._auroraCounterIconBG:SetShown(tooltipFrame.CounterIcon:IsShown())
        end
    end
    function Hook.GarrisonFollowerTooltipTemplate_SetGarrisonFollower(tooltipFrame, data, xpWidth)
        for i = 1, #tooltipFrame.Abilities do
            local Ability = tooltipFrame.Abilities[i]
            if not Ability._auroraSkinned then
                Skin.GarrisonFollowerAbilityTemplate(Ability)
                Ability._auroraSkinned = true
            end
        end

        for i = 1, #tooltipFrame.Traits do
            local Trait = tooltipFrame.Traits[i]
            if not Trait._auroraSkinned then
                Skin.GarrisonFollowerAbilityTemplate(Trait)
                Trait._auroraSkinned = true
            end
        end
    end
end

do --[[ FrameXML\FloatingGarrisonFollowerTooltip.xml ]]
    function Skin.GarrisonFollowerTooltipContentsTemplate(Frame)
        Frame.Class:SetPoint("TOPRIGHT", -2, -2)
        Frame.XPBarBackground:SetPoint("TOPLEFT", Frame.PortraitFrame, "BOTTOMRIGHT", 0, -2)

        Frame.Name:SetPoint("TOPLEFT", Frame.PortraitFrame, "TOPRIGHT", 4, -4)
        Frame.ClassSpecName:SetPoint("TOPLEFT", Frame.Name, "BOTTOMLEFT", 0, -15)
        Frame.ILevel:SetPoint("TOPLEFT", Frame.ClassSpecName, "BOTTOMLEFT", 0, -15)
        Frame.Quality:ClearAllPoints()
        Frame.Quality:SetPoint("TOP", Frame.PortraitFrame, "BOTTOM", 0, -2)
        Frame.Quality:SetJustifyH("CENTER")

        Frame.XPBar:SetPoint("TOPLEFT", Frame.XPBarBackground)

        Skin.GarrisonFollowerPortraitTemplate(Frame.PortraitFrame)
        Frame.PortraitFrame:SetPoint("TOPLEFT", 4, -4)
    end
    function Skin.GarrisonFollowerTooltipTemplate(Frame)
        Skin.GarrisonFollowerTooltipContentsTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)
    end
    function Skin.GarrisonShipyardFollowerTooltipTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)

        Frame.XPBarBackground:SetPoint("TOPLEFT", Frame, "BOTTOMRIGHT", 0, -2)

        Frame.Name:SetPoint("TOPLEFT", Frame, "TOPRIGHT", 4, -4)
        Frame.ClassSpecName:SetPoint("TOPLEFT", Frame.Name, "BOTTOMLEFT", 0, -15)
        Frame.Quality:ClearAllPoints()
        Frame.Quality:SetPoint("TOP", Frame, "BOTTOM", 0, -2)
        Frame.Quality:SetJustifyH("CENTER")

        Frame.XPBar:SetPoint("TOPLEFT", Frame.XPBarBackground)
    end
    function Skin.GarrisonFollowerAbilityTemplate(Frame)
        Base.CropIcon(Frame.Icon, Frame)
        Skin.PositionGarrisonAbiltyBorder(Frame.Border, Frame.Icon)
    end
    function Skin.GarrisonFollowerAbilityTooltipTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)

        Base.CropIcon(Frame.Icon, Frame)
        Frame._auroraCounterIconBG = Base.CropIcon(Frame.CounterIcon, Frame)
        Skin.PositionGarrisonAbiltyBorder(Frame.CounterIconBorder, Frame.CounterIcon)
    end
    function Skin.GarrisonFollowerAbilityWithoutCountersTooltipTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)

        Base.CropIcon(Frame.Icon, Frame)
        Skin.PositionGarrisonAbiltyBorder(Frame.AbilityBorder, Frame.Icon)
    end
    function Skin.GarrisonFollowerMissionAbilityWithoutCountersTooltipTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)

        Base.CropIcon(Frame.Icon, Frame)
        Skin.PositionGarrisonAbiltyBorder(Frame.AbilityBorder, Frame.Icon)
    end
end

function private.FrameXML.FloatingGarrisonFollowerTooltip()
    if private.disabled.tooltips then return end

    ----====####$$$$%%%%%$$$$####====----
    -- FloatingGarrisonFollowerTooltip --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc("GarrisonFollowerAbilityTooltipTemplate_SetAbility", Hook.GarrisonFollowerAbilityTooltipTemplate_SetAbility)
    _G.hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", Hook.GarrisonFollowerTooltipTemplate_SetGarrisonFollower)

    local floatingTooltips = {
        ["GarrisonFollowerTooltipTemplate"] = _G.FloatingGarrisonFollowerTooltip,
        ["GarrisonShipyardFollowerTooltipTemplate"] = _G.FloatingGarrisonShipyardFollowerTooltip,
        ["GarrisonFollowerAbilityTooltipTemplate"] = _G.FloatingGarrisonFollowerAbilityTooltip,
        ["TooltipBorderedFrameTemplate"] = _G.FloatingGarrisonMissionTooltip,
    }

    for template, frame in next, floatingTooltips do
        Skin[template](frame)
        Skin.UIPanelCloseButton(frame.CloseButton)
        frame.CloseButton:SetPoint("TOPRIGHT", -3, -3)
    end

    ----====####$$$$%%%%%$$$$####====----
    --     GarrisonFollowerTooltip     --
    ----====####$$$$%%%%%$$$$####====----
    Skin.GarrisonFollowerTooltipTemplate(_G.GarrisonFollowerTooltip)
    Skin.GarrisonFollowerAbilityTooltipTemplate(_G.GarrisonFollowerAbilityTooltip)
    Skin.GarrisonFollowerAbilityWithoutCountersTooltipTemplate(_G.GarrisonFollowerAbilityWithoutCountersTooltip)
    Skin.GarrisonFollowerMissionAbilityWithoutCountersTooltipTemplate(_G.GarrisonFollowerMissionAbilityWithoutCountersTooltip)
    Skin.GarrisonShipyardFollowerTooltipTemplate(_G.GarrisonShipyardFollowerTooltip)
end
