local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_TorghastLevelPicker.lua ]]
--end

do --[[ AddOns\Blizzard_TorghastLevelPicker.xml ]]
    function Skin.TorghastPagingContainerTemplate(Frame)
        Skin.NavButtonPrevious(Frame.PreviousPage)
        Skin.NavButtonNext(Frame.NextPage)
    end
end

function private.AddOns.Blizzard_TorghastLevelPicker()
    local TorghastLevelPickerFrame = _G.TorghastLevelPickerFrame

    Skin.TorghastPagingContainerTemplate(TorghastLevelPickerFrame.Pager)
    Skin.UIPanelButtonTemplate(TorghastLevelPickerFrame.OpenPortalButton)
    Skin.UIPanelCloseButton(TorghastLevelPickerFrame.CloseButton)
    TorghastLevelPickerFrame.CloseButton.CloseButtonBorder:Hide()
end
