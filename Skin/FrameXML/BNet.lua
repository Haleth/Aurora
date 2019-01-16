local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\BNet.lua ]]
--end

--do --[[ FrameXML\BNet.xml ]]
--end

function private.FrameXML.BNet()
    ------------------
    -- BNToastFrame --
    ------------------
    Skin.SocialToastTemplate(_G.BNToastFrame)


    --------------------
    -- TimeAlertFrame --
    --------------------
    Skin.SocialToastTemplate(_G.TimeAlertFrame)
end
