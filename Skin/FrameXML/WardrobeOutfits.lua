local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\WardrobeOutfits.lua
end ]]

do --[[ FrameXML\WardrobeOutfits.xml ]]
    function Skin.WardrobeOutfitDropDownTemplate(Frame)
        Skin.UIDropDownMenuTemplate(Frame)
        Skin.UIPanelButtonTemplate(Frame.SaveButton)
    end
end

function private.FrameXML.WardrobeOutfits()
    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
