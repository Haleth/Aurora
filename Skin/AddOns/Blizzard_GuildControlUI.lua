local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_GuildControlUI.lua ]]
    local skinnedRanks = 1
    function Hook.GuildControlUI_RankOrder_Update(self)
        local prefix = self:GetName().."Rank"
        for i = skinnedRanks + 1, _G.GuildControlGetNumRanks() do
            Skin.RankChangeTemplate(_G[prefix..i])
            skinnedRanks = skinnedRanks + 1
        end
    end
    local skinnedPerms = 0
    function Hook.GuildControlUI_BankTabPermissions_Update(self)
        local numTabs = _G.GetNumGuildBankTabs()
        if numTabs < _G.MAX_BUY_GUILDBANK_TABS then
            numTabs = numTabs + 1;
        end

        for i = skinnedPerms + 1, numTabs do
            Skin.BankTabPermissionTemplate(_G["GuildControlBankTab"..i])
            skinnedPerms = skinnedPerms + 1
        end
    end
end

do --[[ AddOns\Blizzard_GuildControlUI.xml ]]
    function Skin.RankChangeTemplate(Frame)
        Skin.InputBoxTemplate(Frame.nameBox)
        Skin.UIPanelSquareButton(Frame.deleteButton)
        Skin.UIPanelSquareButton(Frame.downButton)
        Skin.UIPanelSquareButton(Frame.upButton)
    end
    Skin.GuildPermissionCheckBoxTemplate = Skin.UICheckButtonTemplate
    function Skin.BankTabPermissionTemplate(Frame)
        Base.CropIcon(Frame.owned.tabIcon, Frame.owned)
        Skin.GuildPermissionCheckBoxTemplate(Frame.owned.viewCB)
        Skin.GuildPermissionCheckBoxTemplate(Frame.owned.depositCB)
        Skin.GuildPermissionCheckBoxTemplate(Frame.owned.infoCB)
        Skin.InputBoxTemplate(Frame.owned.editBox)

        --Skin.SmallMoneyFrameTemplate(Frame.buy.money)
        Skin.UIPanelButtonTemplate(Frame.buy.button)
        Frame.buy.button:SetPoint("LEFT", Frame.buy.money, "RIGHT", -4.4, 0)
   end
end

function private.AddOns.Blizzard_GuildControlUI()
    _G.hooksecurefunc("GuildControlUI_RankOrder_Update", Hook.GuildControlUI_RankOrder_Update)
    _G.hooksecurefunc("GuildControlUI_BankTabPermissions_Update", Hook.GuildControlUI_BankTabPermissions_Update)

    Skin.TranslucentFrameTemplate(_G.GuildControlUI)
    _G.GuildControlUITopBg:Hide()
    Skin.HorizontalBarTemplate(_G.GuildControlUIHbar)
    Skin.UIPanelCloseButton(_G.GuildControlUICloseButton)
    Skin.UIDropDownMenuTemplate(_G.GuildControlUI.dropdown)

    Skin.RankChangeTemplate(_G.GuildControlUIRankOrderFrameRank1)
    Skin.UIPanelButtonTemplate(_G.GuildControlUIRankOrderFrame.newButton)
    Skin.UIPanelButtonTemplate(_G.GuildControlUIRankOrderFrame.dupButton)

    Skin.UIDropDownMenuTemplate(_G.GuildControlUI.bankTabFrame.dropdown)
    Skin.InsetFrameTemplate2(_G.GuildControlUI.bankTabFrame.inset)
    Skin.UIPanelScrollFrameTemplate2(_G.GuildControlUI.bankTabFrame.inset.scrollFrame)

    Skin.UIDropDownMenuTemplate(_G.GuildControlUI.rankPermFrame.dropdown)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUI.rankPermFrame.OfficerCheckbox)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUI.rankPermFrame.InviteCheckbox)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUIRankSettingsFrameCheckbox7)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUIRankSettingsFrameCheckbox6)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUIRankSettingsFrameCheckbox8)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUIRankSettingsFrameCheckbox2)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUIRankSettingsFrameCheckbox15)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUIRankSettingsFrameCheckbox19)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUIRankSettingsFrameCheckbox16)
    Skin.InputBoxTemplate(_G.GuildControlUI.rankPermFrame.goldBox)
    Skin.GuildPermissionCheckBoxTemplate(_G.GuildControlUIRankSettingsFrameCheckbox18)
end
