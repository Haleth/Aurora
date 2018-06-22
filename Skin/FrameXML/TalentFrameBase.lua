local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook
local Color = Aurora.Color

do --[[ FrameXML\TalentFrameBase.lua ]]
    function Hook.TalentFrame_Update(TalentFrame, talentUnit)
        for tier = 1, _G.MAX_TALENT_TIERS do
            local talentRow = TalentFrame["tier"..tier]
            for column = 1, _G.NUM_TALENT_COLUMNS do
                local button = talentRow["talent"..column]
                local _, _, _, selected, _, _, _, _, _, _, grantedByAura = _G.GetTalentInfo(tier, column, TalentFrame.talentGroup, TalentFrame.inspect, talentUnit)

                if button.knownSelection then
                    if grantedByAura then
                        local color = _G.ITEM_QUALITY_COLORS[_G.LE_ITEM_QUALITY_LEGENDARY]
                        button.knownSelection:SetColorTexture(color.r, color.g, color.b, 0.5)
                    elseif selected then
                        button.knownSelection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, 0.5)
                    end
                end

                if TalentFrame.inspect then
                    if grantedByAura then
                        local color = _G.ITEM_QUALITY_COLORS[_G.LE_ITEM_QUALITY_LEGENDARY]
                        button._auroraIconBG:SetColorTexture(color.r, color.g, color.b)
                    elseif selected then
                        local _, class = _G.UnitClass(talentUnit)
                        local color = _G.CUSTOM_CLASS_COLORS[class]
                        button._auroraIconBG:SetColorTexture(color:GetRGB())
                    else
                        button._auroraIconBG:SetColorTexture(Color.black:GetRGB())
                    end
                end
            end
        end
    end
    function Hook.PvpTalentSlotMixin_Update(self)
        if not self._auroraBG then return end
        local slotInfo = _G.C_SpecializationInfo.GetPvpTalentSlotInfo(self.slotIndex)

        local selectedTalentID = self.predictedSetting:Get()
        if selectedTalentID then
            local _, _, texture = _G.GetPvpTalentInfoByID(selectedTalentID)
            self.Texture:SetTexture(texture)
            self.Texture:SetTexCoord(.08, .92, .08, .92)
        else
            self.Texture:SetTexCoord(.18, .85, .18, .85)
        end

        if slotInfo.enabled then
            self._auroraBG:SetColorTexture(Color.black:GetRGB())
            self.Texture:SetDesaturated(false)
        else
            self._auroraBG:SetColorTexture(Color.gray:GetRGB())
        end
    end
end

function private.FrameXML.TalentFrameBase()
    _G.hooksecurefunc("TalentFrame_Update", Hook.TalentFrame_Update)
    if private.isPatch then
        _G.hooksecurefunc(_G.PvpTalentSlotMixin, "Update", Hook.PvpTalentSlotMixin_Update)
    end
end
