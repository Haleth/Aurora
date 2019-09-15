local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

-- TODO: Added Pet Paperdoll panel and stats. Added Honor panel. Added Skill panel.

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\SkillFrame.lua ]]
--end

do --[[ FrameXML\SkillFrame.xml ]]
	function Skin.SkillStatusBarTemplate(Frame)
        Base.SetBackdrop(Frame, Color.button)
	end
end

function private.FrameXML.SkillFrame()
    _G.SkillFrame:DisableDrawLayer("BORDER")
    _G.SkillFrame:DisableDrawLayer("ARTWORK")
    _G.SkillFrameCancelButton:Hide()

    Skin.UIPanelScrollFrameTemplate(_G.SkillListScrollFrame)
    _G.SkillListScrollFrame:DisableDrawLayer("ARTWORK")

    Skin.UIPanelScrollFrameTemplate(_G.SkillDetailScrollFrame)
    _G.SkillDetailScrollFrame:DisableDrawLayer("ARTWORK")

    ------------------------------
    --     SkillRankFrames      --
    ------------------------------
    for index = 1, _G.SKILLS_TO_DISPLAY do
        local skillRank = _G["SkillRankFrame"..index]
		Skin.SkillStatusBarTemplate(skillRank)
    end
end