local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

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
    function Skin.QuestPOINumericTemplate(button)
        --[[ Scale ]]--
        button:SetSize(20, 20)
        button.Number:SetSize(32, 32)
        button.NormalTexture:SetSize(32, 32)
        button.HighlightTexture:SetSize(32, 32)
        button.PushedTexture:SetSize(32, 32)
    end
    function Skin.QuestPOICompletedTemplate(button)
        --[[ Scale ]]--
        button:SetSize(20, 20)
        button.FullHighlightTexture:SetSize(32, 32)
        button.NormalTexture:SetSize(32, 32)
        button.PushedTexture:SetSize(32, 32)
    end
end

function private.FrameXML.QuestPOI()
    _G.hooksecurefunc("QuestPOI_GetButton", Hook.QuestPOI_GetButton)
end
