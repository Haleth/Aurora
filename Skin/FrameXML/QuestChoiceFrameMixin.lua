local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook

do --[[ FrameXML\QuestChoiceFrameMixin.lua ]]
    function Hook.QuestChoiceFrameMixin_ShowRewards(self, numOptions)
        for i = 1, numOptions do
            local _, _, description = _G.GetQuestChoiceOptionInfo(i)
            local option = self.Options[i]

            -- BlizzWTF: This widget is for some reason creating a new FontString region every time SetText is called.
            option.OptionText:SetWidth(option.OptionText:GetWidth())
            option.OptionText:SetText(description)
        end
    end
end

function private.FrameXML.QuestChoiceFrameMixin()
    if not private.isPatch then return end
    _G.hooksecurefunc(_G.QuestChoiceFrameMixin, "ShowRewards", Hook.QuestChoiceFrameMixin_ShowRewards)
end
