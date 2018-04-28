local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\QuestPOI.lua ]]
    function Hook.QuestPOI_GetButton(parent, questID, style, index)
        local poiButton
        if style == "numeric" then
            poiButton = parent.poiTable.numeric[index]
            if not poiButton._auroraSkinned then
                Skin.QuestPOINumericTemplate(poiButton)
            end
        else
            for _, button in next, parent.poiTable.completed do
                if button.questID == questID then
                    poiButton = button
                    break
                end
            end
            if not poiButton._auroraSkinned then
                Skin.QuestPOICompletedTemplate(poiButton)
            end
        end
    end
end

do --[[ FrameXML\QuestPOI.xml ]]
    function Skin.QuestPOINumericTemplate(Button)
        --[[ Scale ]]--
        Button:SetSize(20, 20)
        Button.Number:SetSize(32, 32)
        Button.NormalTexture:SetSize(32, 32)
        Button.HighlightTexture:SetSize(32, 32)
        Button.PushedTexture:SetSize(32, 32)
    end
    function Skin.QuestPOICompletedTemplate(Button)
        --[[ Scale ]]--
        Button:SetSize(20, 20)
        Button.FullHighlightTexture:SetSize(32, 32)
        Button.NormalTexture:SetSize(32, 32)
        Button.PushedTexture:SetSize(32, 32)
    end
end

function private.FrameXML.QuestPOI()
    _G.hooksecurefunc("QuestPOI_GetButton", Hook.QuestPOI_GetButton)
end
