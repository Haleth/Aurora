local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_MawBuffs.lua ]]
    Hook.MawBuffsListMixin = {}
    function Hook.MawBuffsListMixin:OnShow()
        self.button:SetPushedTexture("")
        self.button:SetHighlightTexture("")
        self.button:SetWidth(253)
        self.button:SetButtonState("NORMAL");
        self.button:SetPushedTextOffset(1.25, -1)
        self.button:SetButtonState("PUSHED", true);
    end
    function Hook.MawBuffsListMixin:OnHide()
        self.button:SetPushedTexture("")
        self.button:SetHighlightTexture("")
    end
end

do --[[ AddOns\Blizzard_MawBuffs.xml ]]
    local color = private.COVENANT_COLORS.Maw
    function Skin.MawBuffsList(Frame)
        Frame:HookScript("OnShow", Hook.MawBuffsListMixin.OnShow)
        Frame:HookScript("OnHide", Hook.MawBuffsListMixin.OnHide)

        Base.SetBackdrop(Frame, color)
        Frame:SetBackdropOptions({
            bgFile = "gradientUp",
            offsets = {
                left = 5,
                right = 5,
                top = 12,
                bottom = 12,
            }
        })

        Frame.TopBG:SetAlpha(0)
        Frame.BottomBG:SetAlpha(0)
        Frame.MiddleBG:SetAlpha(0)
    end
    function Skin.MawBuffsContainer(Button)
        Skin.FrameTypeButton(Button)
        Button:SetButtonColor(color)
        Button:SetBackdropOptions({
            bgFile = "gradientUp",
            offsets = {
                left = 13,
                right = 3,
                top = 11,
                bottom = 11,
            }
        })

        Skin.MawBuffsList(Button.List)
    end
end

function private.AddOns.Blizzard_MawBuffs()
    ----====####$$$$%%%%$$$$####====----
    --              File              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
