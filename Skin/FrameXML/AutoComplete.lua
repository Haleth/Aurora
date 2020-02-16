local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\AutoComplete.lua ]]
--end

do --[[ FrameXML\AutoComplete.xml ]]
    function Skin.AutoCompleteButtonTemplate(Button)
        local highlight = Button:GetHighlightTexture()
        highlight:ClearAllPoints()
        highlight:SetPoint("LEFT", _G.AutoCompleteBox, 1, 0)
        highlight:SetPoint("RIGHT", _G.AutoCompleteBox, -1, 0)
        highlight:SetPoint("TOP", 0, 0)
        highlight:SetPoint("BOTTOM", 0, 0)
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, .2)
    end
end

function private.FrameXML.AutoComplete()
    local AutoCompleteBox = _G.AutoCompleteBox
    Base.SetBackdrop(AutoCompleteBox)

    Skin.AutoCompleteButtonTemplate(_G.AutoCompleteButton1)
    Skin.AutoCompleteButtonTemplate(_G.AutoCompleteButton2)
    Skin.AutoCompleteButtonTemplate(_G.AutoCompleteButton3)
    Skin.AutoCompleteButtonTemplate(_G.AutoCompleteButton4)
    Skin.AutoCompleteButtonTemplate(_G.AutoCompleteButton5)
end
