local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook

function private.FrameXML.UIOptions()
    _G.hooksecurefunc("VideoOptionsDropDownMenu_AddButton", Hook.UIDropDownMenu_AddButton)
end
