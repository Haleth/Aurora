local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals floor

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\PetPaperDollFrame.lua ]]
    function Hook.PetTab_Update(self)
        _G.CharacterFrameTab3:ClearAllPoints()
        if _G.HasPetUI() then
            _G.CharacterFrameTab3:SetPoint("TOPLEFT", "CharacterFrameTab2", "TOPRIGHT", 1, 0);
        else
            _G.CharacterFrameTab3:SetPoint("TOPLEFT", "CharacterFrameTab1", "TOPRIGHT", 1, 0);
        end
    end
end

--do --[[ FrameXML\PetPaperDollFrame.xml ]]
--end

function private.FrameXML.PetPaperDollFrame()
    _G.hooksecurefunc("PetTab_Update", Hook.PetTab_Update)

    local PetPaperDollFrame = _G.PetPaperDollFrame
    local TopLeft, TopRight, BotLeft, BotRight = PetPaperDollFrame:GetRegions()
    TopLeft:Hide()
    TopRight:Hide()
    BotLeft:Hide()
    BotRight:Hide()

    _G.PetNameText:SetAllPoints(_G.CharacterNameText)

    Skin.FrameTypeStatusBar(_G.PetPaperDollFrameExpBar)
    local left, right = _G.PetPaperDollFrameExpBar:GetRegions()
    left:Hide()
    right:Hide()
    Util.PositionBarTicks(_G.PetPaperDollFrameExpBar, 6)

    Skin.NavButtonNext(_G.PetModelFrameRotateRightButton)
    Skin.NavButtonPrevious(_G.PetModelFrameRotateLeftButton)

    Skin.UIPanelButtonTemplate(_G.PetPaperDollCloseButton)

    left, right = _G.PetAttributesFrame:GetRegions()
    left:Hide()
    right:Hide()

    -- Resists
    local resists = {
        {icon = [[Interface\Icons\Spell_Arcane_StarFire]]},
        {icon = [[Interface\Icons\INV_SummerFest_FireSpirit]]},
        {icon = [[Interface\Icons\Spell_Nature_ResistNature]]},
        {icon = [[Interface\Icons\Spell_Frost_FreezingBreath]]},
        {icon = [[Interface\Icons\Spell_Shadow_Twilight]]},
    }
    for i = 1, #resists do
        local frame = _G["PetMagicResFrame"..i]
        Skin.MagicResistanceFrameTemplate(frame)
        frame._icon:SetTexture(resists[i].icon)

        frame:ClearAllPoints()
        if i == 1 then
            frame:SetPoint("TOPRIGHT", -5, -5)
        else
            frame:SetPoint("TOPRIGHT", _G["PetMagicResFrame"..i - 1], "BOTTOMRIGHT", 0, -6)
        end
    end
end
