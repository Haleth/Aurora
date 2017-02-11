local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_RaidUI"] = function()
    local function onEnter(self)
        if self.class then
            self:SetBackdropBorderColor(C.classcolours[self.class].r, C.classcolours[self.class].g, C.classcolours[self.class].b)
        else
            self:SetBackdropBorderColor(0.5, 0.5, 0.5)
        end
    end
    local function onLeave(self)
        self:SetBackdropBorderColor(0, 0, 0)
    end

    for grpNum = 1, 8 do
        local name = "RaidGroup"..grpNum
        local group = _G[name]
        group:GetRegions():Hide()
        for slotNum = 1, 5 do
            local slot = _G[name.."Slot"..slotNum]
            slot:SetHighlightTexture("")
            F.CreateBD(slot, 0.5)

            slot:HookScript("OnEnter", onEnter)
            slot:HookScript("OnLeave", onLeave)
        end
    end
    for btnNum = 1, 40 do
        local name = "RaidGroupButton"..btnNum
        local btn = _G[name]
        F.Reskin(btn, true)

        btn:HookScript("OnEnter", onEnter)
        btn:HookScript("OnLeave", onLeave)
        --raidButtons[btnNum] = btn
    end
end
