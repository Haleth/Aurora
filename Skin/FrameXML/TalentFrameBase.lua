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
                        button.knownSelection:SetColorTexture(_G.ITEM_QUALITY_COLORS[_G.LE_ITEM_QUALITY_LEGENDARY]:GetRGB())
                    elseif selected then
                        button.knownSelection:SetColorTexture(Color.highlight:GetRGB())
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
        else
            self.Texture:Show()
        end

        if slotInfo.enabled then
            self._auroraBG:SetColorTexture(Color.black:GetRGB())
            self.Texture:SetDesaturated(false)
        else
            self._auroraBG:SetColorTexture(Color.gray:GetRGB())
            self.Texture:SetDesaturated(true)
        end
    end
end

function private.FrameXML.TalentFrameBase()
    _G.hooksecurefunc("TalentFrame_Update", Hook.TalentFrame_Update)
    if private.isPatch then
        _G.hooksecurefunc(_G.PvpTalentSlotMixin, "Update", Hook.PvpTalentSlotMixin_Update)
    end
end
