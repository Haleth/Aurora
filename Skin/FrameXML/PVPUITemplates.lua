local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\PVPUITemplates.lua ]]
--end

do --[[ FrameXML\PVPUITemplates.xml ]]
    function Skin.PVPConquestRewardButton(Button)
        Button.Ring:Hide()
        Base.CropIcon(Button.Icon, Button)
        Button.CircleMask:Hide()
    end
    function Skin.PVPHonorRewardTemplate(Button)
        Base.CropIcon(Button.RewardIcon, Button)
        Button.IconCover:SetAllPoints(Button.RewardIcon)
        Button.CircleMask:Hide()
        Button.RingBorder:Hide()
    end
    function Skin.PVPRatedTierTemplate(Frame)
    end
end

function private.FrameXML.PVPUITemplates()
    ----====####$$$$%%%%$$$$####====----
    --         PVPUITemplates         --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
