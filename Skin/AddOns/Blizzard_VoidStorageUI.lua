local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select pairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--do --[[ AddOns\Blizzard_VoidStorageUI.lua ]]
--end

do --[[ AddOns\Blizzard_VoidStorageUI.xml ]]
    function Skin.VoidStorageItemButtonTemplate(Button)
        local name = Button:GetName()

        local bg = _G[name.."Bg"]
        bg:SetTexCoord(0.671875, 0.736328125, 0.009765625, 0.07421875)
        Base.CreateBackdrop(Button, {
            edgeSize = 1,
            bgFile = [[Interface\VoidStorage\VoidStorage]],
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }, {bg = bg})
        Button._auroraIconBorder = Button

        Base.CropIcon(Button.icon)
        Button.icon:SetPoint("TOPLEFT", 1, -1)
        Button.icon:SetPoint("BOTTOMRIGHT", -1, 1)

        Base.CropIcon(Button:GetPushedTexture())
        Base.CropIcon(Button:GetHighlightTexture())
    end
    function Skin.VoidStorageTabTemplate(CheckButton)
        Skin.SideTabTemplate(CheckButton)
    end
    function Skin.VoidStorageInsetFrameTemplate(Frame)
        Skin.InsetFrameTemplate(Frame)
        select(2, Frame:GetRegions()):Hide()
    end
end

function private.AddOns.Blizzard_VoidStorageUI()
    local VOID_DEPOSIT_MAX = 9
    local VOID_WITHDRAW_MAX = 9
    local VOID_STORAGE_MAX = 80

    local VoidStorageFrame = _G.VoidStorageFrame
    _G.VoidStorageFrameMarbleBg:Hide()
    select(2, VoidStorageFrame:GetRegions()):Hide()
    _G.VoidStorageFrameLines:SetParent(_G.VoidStorageBorderFrame)
    _G.VoidStorageFrameLines:SetAllPoints()

    ------------------
    -- ContentFrame --
    ------------------
    Skin.VoidStorageInsetFrameTemplate(_G.VoidStorageDepositFrame)
    local arrowDeposit = select(4, _G.VoidStorageDepositFrame:GetRegions())
    arrowDeposit:SetSize(20, 40)
    arrowDeposit:SetVertexColor(Color.violet:GetRGB())
    Base.SetTexture(arrowDeposit, "arrowRight")
    for i = 1, VOID_DEPOSIT_MAX do
        Skin.VoidStorageItemButtonTemplate(_G["VoidStorageDepositButton"..i])
    end

    Skin.VoidStorageInsetFrameTemplate(_G.VoidStorageWithdrawFrame)
    local arrowWithdraw = select(4, _G.VoidStorageWithdrawFrame:GetRegions())
    arrowWithdraw:SetSize(20, 40)
    Base.SetTexture(arrowWithdraw, "arrowLeft")
    arrowWithdraw:SetVertexColor(Color.violet:GetRGB())
    for i = 1, VOID_WITHDRAW_MAX do
        Skin.VoidStorageItemButtonTemplate(_G["VoidStorageWithdrawButton"..i])
    end

    Skin.VoidStorageInsetFrameTemplate(_G.VoidStorageStorageFrame)
    _G.VoidStorageStorageFrameLine1:Hide()
    _G.VoidStorageStorageFrameLine2:Hide()
    _G.VoidStorageStorageFrameLine3:Hide()
    _G.VoidStorageStorageFrameLine4:Hide()
    for i = 1, VOID_STORAGE_MAX do
        Skin.VoidStorageItemButtonTemplate(_G["VoidStorageStorageButton"..i])
    end

    Skin.VoidStorageInsetFrameTemplate(_G.VoidStorageCostFrame)
    Skin.UIPanelButtonTemplate(_G.VoidStorageTransferButton)

    -----------------
    -- BorderFrame --
    -----------------
    Skin.BasicFrameTemplate(_G.VoidStorageBorderFrame)
    _G.VoidStorageBorderFrameCornerTL:Hide()
    _G.VoidStorageBorderFrameCornerTR:Hide()
    _G.VoidStorageBorderFrameCornerBL:Hide()
    _G.VoidStorageBorderFrameCornerBR:Hide()

    _G.VoidStorageBorderFrameLeftEdge:Hide()
    _G.VoidStorageBorderFrameRightEdge:Hide()
    _G.VoidStorageBorderFrameBottomEdge:Hide()
    _G.VoidStorageBorderFrameTopEdge:Hide()
    _G.VoidStorageBorderFrameHeader:Hide()

    Skin.VoidStorageTabTemplate(VoidStorageFrame.Page1)
    Skin.VoidStorageTabTemplate(VoidStorageFrame.Page2)
    Util.PositionRelative("TOPLEFT", VoidStorageFrame, "TOPRIGHT", 2, -40, 5, "Down", {
        VoidStorageFrame.Page1,
        VoidStorageFrame.Page2,
    })

    _G.VoidStorageBorderFrameMouseBlockFrame:ClearAllPoints()
    _G.VoidStorageBorderFrameMouseBlockFrame:SetAllPoints()
    _G.VoidStorageBorderFrame.Bg:ClearAllPoints()
    _G.VoidStorageBorderFrame.Bg:SetAllPoints()

    select(2, _G.VoidStoragePurchaseFrame:GetRegions()):Hide()
    Base.CreateBackdrop(_G.VoidStoragePurchaseFrame, private.backdrop, {
        tl = _G.VoidStoragePurchaseFrameCornerTL,
        tr = _G.VoidStoragePurchaseFrameCornerTR,
        bl = _G.VoidStoragePurchaseFrameCornerBL,
        br = _G.VoidStoragePurchaseFrameCornerBR,

        t = _G.VoidStoragePurchaseFrameTopEdge,
        b = _G.VoidStoragePurchaseFrameBottomEdge,
        l = _G.VoidStoragePurchaseFrameLeftEdge,
        r = _G.VoidStoragePurchaseFrameRightEdge,

        bg = _G.VoidStoragePurchaseFrameMarbleBg,
    })
    Base.SetBackdrop(_G.VoidStoragePurchaseFrame)

    Skin.UIPanelButtonTemplate(_G.VoidStoragePurchaseButton)
    if not private.isPatch then
        Skin.GlowBoxTemplate(_G.VoidStorageHelpBox)
        Skin.GlowBoxArrowTemplate(_G.VoidStorageHelpBoxArrow)
        Skin.UIPanelButtonTemplate(_G.VoidStorageHelpBoxButton)
    end

    Skin.BagSearchBoxTemplate(_G.VoidItemSearchBox)
end
