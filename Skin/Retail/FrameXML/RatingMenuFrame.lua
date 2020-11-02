local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\RatingMenuFrame.lua ]]
--end

--do --[[ FrameXML\RatingMenuFrame.xml ]]
--end

function private.FrameXML.RatingMenuFrame()
    local RatingMenuFrame = _G.RatingMenuFrame
    Skin.DialogBorderTemplate(RatingMenuFrame.Border)
    Skin.DialogHeaderTemplate(RatingMenuFrame.Header)
    Skin.OptionsButtonTemplate(_G.RatingMenuButtonOkay)
end
