local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ SharedXML\AddonList.lua ]]
    function Hook.AddonListCharacterDropDownButton_OnClick(self)
        for i = 1, 2 do
            local buttonName = "DropDownList1Button"..i
            local button = _G[buttonName]
            local checkBox = button._auroraCheckBox
            local check = checkBox.check

            checkBox:SetSize(8, 8)
            checkBox:SetPoint("LEFT", 4, 0)
            check:SetTexture([[Interface\Buttons\WHITE8x8]])
            check:SetSize(6, 6)
            check:SetAlpha(0.6)

            local checked = _G["DropDownList1Button"..i].checked
            if checked then
                check:Show()
            else
                check:Hide()
            end

            _G[buttonName.."UnCheck"]:Hide()
        end
    end
end

do --[[ SharedXML\AddonList.xml ]]
    function Skin.AddonListEntryTemplate(Button)
        local name = Button:GetName()

        Skin.UICheckButtonTemplate(_G[name.."Enabled"]) -- BlizzWTF: Doesn't use a template, but it should
        Skin.UIPanelButtonTemplate(Button.LoadAddonButton)
    end
end

function private.SharedXML.AddonList()
    local AddonList = _G.AddonList
    Skin.ButtonFrameTemplate(AddonList)
    Skin.UICheckButtonTemplate(_G.AddonListForceLoad) -- BlizzWTF: Doesn't use a template, but it should

    Skin.MagicButtonTemplate(AddonList.CancelButton)
    Skin.MagicButtonTemplate(AddonList.OkayButton)
    Skin.MagicButtonTemplate(AddonList.EnableAllButton)
    Skin.MagicButtonTemplate(AddonList.DisableAllButton)
    Skin.MagicButtonTemplate(AddonList.CancelButton)

    for i = 1, _G.MAX_ADDONS_DISPLAYED do
        Skin.AddonListEntryTemplate(_G["AddonListEntry"..i])
    end

    Skin.UIDropDownMenuTemplate(_G.AddonCharacterDropDown)
    _G.AddonCharacterDropDown.Button:HookScript("OnClick", Hook.AddonListCharacterDropDownButton_OnClick)
end
