local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook

function private.FrameXML.UIOptions()
    if private.isPatch then return end
    _G.hooksecurefunc("VideoOptionsDropDownMenu_AddButton", Hook.UIDropDownMenu_AddButton)
    _G.hooksecurefunc("VideoOptionsDropDownMenu_DisableDropDown", Hook.UIDropDownMenu_DisableDropDown)
    _G.hooksecurefunc("VideoOptionsDropDownMenu_EnableDropDown", Hook.UIDropDownMenu_EnableDropDown)
end
