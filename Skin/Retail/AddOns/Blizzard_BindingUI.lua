local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--[[ do AddOns\Blizzard_BindingUI.lua
end ]]

do --[[ AddOns\Blizzard_BindingUI.xml ]]
    function Skin.KeyBindingFrameBindingButtonTemplate(Button)
        Skin.UIMenuButtonStretchTemplate(Button)
    end
    function Skin.KeyBindingFrameBindingTemplate(Frame)
        Skin.KeyBindingFrameBindingButtonTemplate(Frame.key1Button)
        Skin.KeyBindingFrameBindingButtonTemplate(Frame.key2Button)
    end
end

function private.AddOns.Blizzard_BindingUI()
    local KeyBindingFrame = _G.KeyBindingFrame

    if private.isRetail then
        Skin.DialogBorderTemplate(KeyBindingFrame.BG)
        Skin.DialogHeaderTemplate(KeyBindingFrame.Header)
    else
        Skin.DialogBorderTemplate(KeyBindingFrame)

        local header = KeyBindingFrame.header
        header:SetAlpha(0)
        header:GetRegions():Hide()
        header.text:SetParent(KeyBindingFrame)
        header.text:ClearAllPoints()
        header.text:SetPoint("TOPLEFT")
        header.text:SetPoint("BOTTOMRIGHT", KeyBindingFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end

    Skin.UICheckButtonTemplate(KeyBindingFrame.characterSpecificButton)
    Skin.UIPanelButtonTemplate(KeyBindingFrame.unbindButton)
    Skin.UIPanelButtonTemplate(KeyBindingFrame.okayButton)
    Skin.UIPanelButtonTemplate(KeyBindingFrame.cancelButton)
    Util.PositionRelative("BOTTOMRIGHT", KeyBindingFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        KeyBindingFrame.cancelButton,
        KeyBindingFrame.okayButton,
        KeyBindingFrame.unbindButton
    })

    Skin.UIPanelButtonTemplate(KeyBindingFrame.defaultsButton)
    KeyBindingFrame.defaultsButton:SetPoint("BOTTOMLEFT", 15, 15)

    Base.SetBackdrop(KeyBindingFrame.bindingsContainer, Color.frame)
    Skin.OptionsFrameListTemplate(KeyBindingFrame.categoryList)
    Skin.FauxScrollFrameTemplate(KeyBindingFrame.scrollFrame)
    KeyBindingFrame.scrollFrame.scrollBorderTop:Hide()
    KeyBindingFrame.scrollFrame.scrollBorderBottom:Hide()
    KeyBindingFrame.scrollFrame.scrollBorderMiddle:Hide()
    KeyBindingFrame.scrollFrame.scrollFrameScrollBarBackground:Hide()


    for i = 1, _G.KEY_BINDINGS_DISPLAYED do
        Skin.KeyBindingFrameBindingTemplate(KeyBindingFrame.keyBindingRows[i])
    end
end
