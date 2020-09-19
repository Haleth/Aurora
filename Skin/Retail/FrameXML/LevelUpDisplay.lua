local _, private = ...
if private.isClassic then return end

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\LevelUpDisplay.lua ]]
    function Hook.LevelUpDisplaySide_OnShow(self)
        local prev
        for i = 1, #self.unlockList do
            local frame = _G["LevelUpDisplaySideUnlockFrame"..i]

            if not frame._auroraSkinned then
                Skin.LevelUpSkillTemplate(frame)
                if prev then
                    frame:SetPoint("TOP", prev, "BOTTOM", 0, -5)
                end
                frame._auroraSkinned = true
            end
            prev = frame
        end
    end
    function Hook.BossBanner_ConfigureLootFrame(lootFrame, data)
        lootFrame.PlayerName:SetTextColor(_G.CUSTOM_CLASS_COLORS[data.className]:GetRGB())
    end
end

do --[[ FrameXML\LevelUpDisplay.xml ]]
    function Skin.LevelUpSkillTemplate(Frame)
        Base.CropIcon(Frame.icon, Frame)
    end
end

function private.FrameXML.LevelUpDisplay()
    _G.LevelUpDisplaySide:HookScript("OnShow", Hook.LevelUpDisplaySide_OnShow)
    _G.hooksecurefunc("BossBanner_ConfigureLootFrame", Hook.BossBanner_ConfigureLootFrame)

    _G.LevelUpDisplaySideUnlockFrame1:SetPoint("TOP", _G.LevelUpDisplaySide.goldBG, "BOTTOM", 0, -10)
end
