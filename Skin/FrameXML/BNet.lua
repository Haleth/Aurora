local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

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
