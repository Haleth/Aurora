local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_ChromieTimeUI.lua ]]
    Hook.ChromieTimeExpansionButtonMixin = {}
    function Hook.ChromieTimeExpansionButtonMixin:ClearSelection()
        self:SetNormalTexture("")
        self:UnlockHighlight()
    end
    function Hook.ChromieTimeExpansionButtonMixin:OnClick()
        self:SetNormalTexture("")
        self:LockHighlight()
    end
end

do --[[ AddOns\Blizzard_ChromieTimeUI.xml ]]
    function Skin.ChromieTimeExpansionButtonTemplate(Button)
        Button:HookScript("OnClick", Hook.ChromieTimeExpansionButtonMixin.OnClick)
        Util.Mixin(Button, Hook.ChromieTimeExpansionButtonMixin)

        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 8,
            right = 8,
            top = 8,
            bottom = 8,
        })
        Button.Background:SetTexCoord(0.01602564102564, 0.98397435897436, 0.02890173410405, 0.97109826589595)
    end
end

function private.AddOns.Blizzard_ChromieTimeUI()
    local ChromieTimeFrame = _G.ChromieTimeFrame
    Skin.NineSlicePanelTemplate(ChromieTimeFrame.NineSlice)
    ChromieTimeFrame.NineSlice:SetFrameLevel(1)
    ChromieTimeFrame.Background.BackgroundTile:Hide()

    ChromieTimeFrame.Title.Left:Hide()
    ChromieTimeFrame.Title.Right:Hide()
    ChromieTimeFrame.Title.Middle:Hide()

    Skin.UIPanelCloseButton(ChromieTimeFrame.CloseButton)
    ChromieTimeFrame.CloseButton.Border:Hide()
    Skin.UIPanelButtonTemplate(ChromieTimeFrame.SelectButton)

    -- unitframeicon-chromietime
    local selectedXpac = ChromieTimeFrame.CurrentlySelectedExpansionInfoFrame
    selectedXpac.Background:SetAtlas("unitframeicon-chromietime", true)
    selectedXpac.Background:ClearAllPoints()
    selectedXpac.Background:SetPoint("BOTTOMLEFT", ChromieTimeFrame, 30, 30)
    selectedXpac.Background:SetSize(58 * 3, 62 * 3)
    selectedXpac.Background:SetDesaturated(true)
    selectedXpac.Background:SetBlendMode("ADD")
    selectedXpac.Background:SetAlpha(0.2)

    selectedXpac.PortraitBorder:Hide()
    selectedXpac.Portrait:SetTexCoord(0.01022494887526, 0.98977505112474, 0.01968503937008, 0.98031496062992)
    selectedXpac.Name:SetTextColor(Color.white:GetRGB())
    selectedXpac.Description:SetTextColor(Color.grayLight:GetRGB())
end
