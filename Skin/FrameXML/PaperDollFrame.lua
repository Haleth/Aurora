local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\PaperDollFrame.lua ]]
    do --[[ PaperDollFrame.lua ]]
        function Hook.PaperDollFrame_SetLevel()
            _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL, _G.UnitLevel("player"), _G.UnitRace("player"), _G.UnitClass("player"));
            _G.CharacterLevelText:SetPoint("CENTER", _G.CharacterFrame.TitleText, "BOTTOM", 0, -4)
        end
    end
end

do --[[ FrameXML\PaperDollFrame.xml ]]
    do --[[ PaperDollFrame.xml ]]
        function Skin.PaperDollItemSlotButtonTemplate(ItemButton)
            Skin.FrameTypeItemButton(ItemButton)
        end
        function Skin.PlayerTitleButtonTemplate(Button)
            Button.BgTop:SetTexture("")
            Button.BgBottom:SetTexture("")
            Button.BgMiddle:SetTexture("")

            Button.SelectedBar:SetColorTexture(1, 1, 0, 0.3)
            Button:GetHighlightTexture():SetColorTexture(0, 0, 1, 0.2)
        end
        function Skin.GearSetButtonTemplate(Button)
            Button.BgTop:SetTexture("")
            Button.BgBottom:SetTexture("")
            Button.BgMiddle:SetTexture("")

            Button.HighlightBar:SetColorTexture(0, 0, 1, 0.3)
            Button.SelectedBar:SetColorTexture(1, 1, 0, 0.3)

            Base.CropIcon(Button.icon, Button)
        end
        function Skin.GearSetPopupButtonTemplate(CheckButton)
            Skin.SimplePopupButtonTemplate(CheckButton)
            Base.CropIcon(_G[CheckButton:GetName().."Icon"])
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
        function Skin.PaperDollSidebarTabTemplate(Button)
            Button.TabBg:SetAlpha(0)
            Button.Hider:SetTexture("")

            Button.Icon:ClearAllPoints()
            Button.Icon:SetPoint("TOPLEFT", 1, -1)
            Button.Icon:SetPoint("BOTTOMRIGHT", -1, 1)

            Button.Highlight:SetTexture("")

            Base.SetBackdrop(Button, Color.button)
            Base.SetHighlight(Button, "backdrop")
        end
        function Skin.StatFrameTemplate(Frame)
        end
    end
end

function private.FrameXML.PaperDollFrame()
    _G.hooksecurefunc("PaperDollFrame_SetLevel", Hook.PaperDollFrame_SetLevel)
    local PaperDollFrame = _G.PaperDollFrame

    -- Hide BG
    for i = 1, 4 do
        select(i, PaperDollFrame:GetRegions()):Hide()
    end

    local CharacterFrame = _G.CharacterFrame

    local CharacterAttributesFrame = _G.CharacterAttributesFrame
    CharacterAttributesFrame:ClearAllPoints()
    CharacterAttributesFrame:SetPoint("BOTTOM", PaperDollFrame, "BOTTOM", 0, 61)
    for i = 1, CharacterAttributesFrame:GetNumRegions() do
        select(i, CharacterAttributesFrame:GetRegions()):Hide()
    end
    Base.SetBackdrop(CharacterAttributesFrame)

    local CharacterModelFrame = _G.CharacterModelFrame

    _G.CharacterResistanceFrame:SetPoint("TOPRIGHT", CharacterModelFrame, "TOPRIGHT", 0, 0)

    CharacterModelFrame:SetPoint("TOPLEFT", CharacterFrame, 45, -51)
    CharacterModelFrame:SetPoint("BOTTOMRIGHT", CharacterFrame, -45, 51 + CharacterAttributesFrame:GetHeight())

    local classBG = PaperDollFrame:CreateTexture(nil, "BORDER")
    classBG:SetAtlas("dressingroom-background-"..private.charClass.token)
    classBG:SetPoint("TOPLEFT", _G.CharacterModelFrame)
    classBG:SetPoint("BOTTOMRIGHT", _G.CharacterModelFrame)
    classBG:SetAlpha(0.5)

    Skin.RotateOrbitCameraRightButtonTemplate(_G.CharacterModelFrameRotateLeftButton)
    Skin.RotateOrbitCameraLeftButtonTemplate(_G.CharacterModelFrameRotateRightButton)

    local EquipmentSlots = {
        "CharacterHeadSlot", "CharacterNeckSlot", "CharacterShoulderSlot", "CharacterBackSlot", "CharacterChestSlot", "CharacterShirtSlot", "CharacterTabardSlot", "CharacterWristSlot",
        "CharacterHandsSlot", "CharacterWaistSlot", "CharacterLegsSlot", "CharacterFeetSlot", "CharacterFinger0Slot", "CharacterFinger1Slot", "CharacterTrinket0Slot", "CharacterTrinket1Slot",
        "CharacterMainHandSlot", "CharacterSecondaryHandSlot", "CharacterRangedSlot"
    }

    _G.CharacterHeadSlot:ClearAllPoints()
    _G.CharacterHeadSlot:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 4, -51)
    _G.CharacterHandsSlot:ClearAllPoints()
    _G.CharacterHandsSlot:SetPoint("TOPRIGHT", CharacterFrame, "TOPRIGHT", -4, -51)
    _G.CharacterMainHandSlot:ClearAllPoints()
    _G.CharacterMainHandSlot:SetPoint("BOTTOMLEFT", 130, 8)

    for i = 1, #EquipmentSlots do
        Skin.PaperDollItemSlotButtonTemplate(_G[EquipmentSlots[i]])
    end

    Skin.AltItemButton(_G.CharacterAmmoSlot)
    _G.CharacterAmmoSlot:DisableDrawLayer("BACKGROUND")
    _G.CharacterAmmoSlot.Count:SetPoint("BOTTOMRIGHT", -2, 2)
end
