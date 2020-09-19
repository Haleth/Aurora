local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\PVPHelper.lua ]]
    function Hook.PVPReadyDialog_Display(self, index, displayName, isRated, queueType, gameType, role)
        Base.SetTexture(self.roleIcon.texture, "icon"..role)
    end
end

--do --[[ FrameXML\PVPHelper.xml ]]
--end

function private.FrameXML.PVPHelper()
    _G.hooksecurefunc("PVPReadyDialog_Display", Hook.PVPReadyDialog_Display)

    --[[ PVPFramePopup ]]--

    --[[ PVPRoleCheckPopup ]]--

    --[[ PVPReadyDialog ]]--
    local PVPReadyDialog = _G.PVPReadyDialog
    Skin.DialogBorderTemplate(PVPReadyDialog.Border)

    PVPReadyDialog.background:SetAlpha(0.75)
    PVPReadyDialog.background:ClearAllPoints()
    PVPReadyDialog.background:SetPoint("TOPLEFT")
    PVPReadyDialog.background:SetPoint("BOTTOMRIGHT", 0, 68)

    PVPReadyDialog.filigree:Hide()
    PVPReadyDialog.bottomArt:Hide()

    Skin.MinimizeButton(_G.PVPReadyDialogCloseButton)
    Skin.UIPanelButtonTemplate(PVPReadyDialog.enterButton)
    Skin.UIPanelButtonTemplate(PVPReadyDialog.leaveButton)

    PVPReadyDialog.roleIcon:SetSize(64, 64)
end
