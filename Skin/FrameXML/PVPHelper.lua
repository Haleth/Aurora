local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\PVPHelper.lua ]]
    function Hook.PVPReadyDialog_Display(self, index, displayName, isRated, queueType, gameType, role)
        Base.SetTexture(self.roleIcon.texture, "role"..role)
    end
end

function private.FrameXML.PVPHelper()
    _G.hooksecurefunc("PVPReadyDialog_Display", Hook.PVPReadyDialog_Display)

    --[[ PVPFramePopup ]]--

    --[[ PVPRoleCheckPopup ]]--

    --[[ PVPReadyDialog ]]--
    local PVPReadyDialog = _G.PVPReadyDialog
    Base.SetBackdrop(PVPReadyDialog)

    PVPReadyDialog.background:SetAlpha(0.75)
    PVPReadyDialog.background:ClearAllPoints()
    PVPReadyDialog.background:SetPoint("TOPLEFT")
    PVPReadyDialog.background:SetPoint("BOTTOMRIGHT", 0, 68)

    PVPReadyDialog.filigree:Hide()
    PVPReadyDialog.bottomArt:Hide()

    do -- CloseButton
        local close = _G.PVPReadyDialogCloseButton
        Base.SetBackdrop(close, Color.button)
        local bg = close:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 3, -10)
        bg:SetPoint("BOTTOMRIGHT", -11, 4)

        close:SetNormalTexture("")
        close:SetHighlightTexture("")
        close:SetPushedTexture("")

        close._auroraHighlight = {}
        local hline = close:CreateTexture()
        hline:SetColorTexture(1, 1, 1)
        hline:SetHeight(1)
        hline:SetPoint("BOTTOMLEFT", 4, 4)
        hline:SetPoint("BOTTOMRIGHT", -4, 4)
        _G.tinsert(close._auroraHighlight, hline)
        Base.SetHighlight(close, "color")
    end

    Skin.UIPanelButtonTemplate(PVPReadyDialog.enterButton)
    Skin.UIPanelButtonTemplate(PVPReadyDialog.leaveButton)

    PVPReadyDialog.roleIcon:SetSize(64, 64)
end
