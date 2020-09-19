local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals min

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_RaidUI.lua ]]
    function Hook.RaidGroupFrame_Update()
        if not _G.IsInRaid() then return end

        local button, subframes
        for i = 1, _G.MAX_RAID_MEMBERS do
            button = _G["RaidGroupButton"..i]
            if button:IsShown() then
                subframes = button.subframes
                local _, _, _, _, className, classToken, _, online, dead = _G.GetRaidRosterInfo(i)
                if (online and not dead) and className then
                    local color = _G.CUSTOM_CLASS_COLORS[classToken]
                    subframes.name:SetTextColor(color.r, color.g, color.b)
                    subframes.level:SetTextColor(color.r, color.g, color.b)
                    if private.isRetail then
                        subframes.class:SetTextColor(color.r, color.g, color.b)
                    else
                        subframes.class.text:SetTextColor(color.r, color.g, color.b)
                    end
                end
            end
        end
    end
end

do --[[ AddOns\Blizzard_RaidUI.xml ]]
    function Skin.RaidGroupButtonTemplate(Button)
        Skin.FrameTypeButton(Button, function(self)
            self:SetBackdropBorderColor(_G.CUSTOM_CLASS_COLORS[self.class])
        end)
    end
    function Skin.RaidGroupSlotTemplate(Button)
        Button:SetHighlightTexture("")
        Base.SetBackdrop(Button, Color.button, 0)
        Button:SetBackdropBorderColor(Color.button, 0)

        Button:HookScript("OnEnter", function(self)
            self:SetBackdropBorderColor(Color.button, 1)
        end)
        Button:HookScript("OnLeave", function(self)
            self:SetBackdropBorderColor(Color.button, 0)
        end)
    end
    function Skin.RaidGroupTemplate(Frame)
        Frame:GetRegions():Hide()

        Base.SetBackdrop(Frame, Color.frame)
        Frame:SetBackdropBorderColor(Color.button)

        local name = Frame:GetName()
        _G[name.."Label"]:SetPoint("TOP", 0, 12)
        Skin.RaidGroupSlotTemplate(_G[name.."Slot1"])
        Skin.RaidGroupSlotTemplate(_G[name.."Slot2"])
        Skin.RaidGroupSlotTemplate(_G[name.."Slot3"])
        Skin.RaidGroupSlotTemplate(_G[name.."Slot4"])
        Skin.RaidGroupSlotTemplate(_G[name.."Slot5"])
    end
end

function private.AddOns.Blizzard_RaidUI()
    _G.hooksecurefunc("RaidGroupFrame_Update", Hook.RaidGroupFrame_Update)

    _G.RaidGroup1:SetPoint("TOPLEFT", 5, -58)
    _G.RaidGroup2:SetPoint("LEFT", _G.RaidGroup1, "RIGHT", 4, 0)
    for groupID = 1, _G.NUM_RAID_GROUPS do
        Skin.RaidGroupTemplate(_G["RaidGroup"..groupID])
    end

    for memberID = 1, _G.MAX_RAID_MEMBERS do
        Skin.RaidGroupButtonTemplate(_G["RaidGroupButton"..memberID])
    end
end
