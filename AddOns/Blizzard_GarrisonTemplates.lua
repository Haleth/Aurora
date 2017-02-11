local _, private = ...

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_GarrisonTemplates"] = function()
    --[[
        This addon is a dependancy for the GarrisonUI, which is in turn a dependancy for the OrderHallUI.
        The hooks made here will persist into both of those, greatly reducing posible duplicate code.
    ]]

    --[[ SharedTemplates ]]
    hooksecurefunc(_G.GarrisonFollowerTabMixin, "ShowFollower", function(self, followerID, followerList)
        private.debug("FollowerTabMixin:ShowFollower", self:GetParent().followerTypeID, followerID, followerList)
        if self:GetParent().followerTypeID == _G.LE_FOLLOWER_TYPE_GARRISON_7_0 then return end -- we're not skinning OrderHallUI just yet

        local followerInfo = _G.C_Garrison.GetFollowerInfo(followerID)
        private.debug("followerInfo", followerInfo and followerInfo.name)
        if not followerInfo then return end -- not sure if this is needed

        if not self.PortraitFrame.styled then
            F.ReskinGarrisonPortrait(self.PortraitFrame)
            self.PortraitFrame.styled = true
        end

        local color = _G.ITEM_QUALITY_COLORS[followerInfo.quality]
        self.PortraitFrame:SetBackdropBorderColor(color.r, color.g, color.b)
    end)

    --[[ MissionTemplates ]]
end
