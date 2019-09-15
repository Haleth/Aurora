local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin, Util = Aurora.Base, Aurora.Skin, Aurora.Util

--do --[[ AddOns\Blizzard_CraftUI\Blizzard_CraftUI.lua ]]
--end

do --[[ AddOns\Blizzard_CraftUI\Blizzard_CraftUI.xml ]]
	function Skin.CraftButtonTemplate(Button)
		Skin.ClassTrainerSkillButtonTemplate(Button)
	end
	function Skin.CraftItemTemplate(Button)
		Skin.QuestItemTemplate(Button)
	end
end

function private.AddOns.Blizzard_CraftUI()
	local CraftFrame = _G.CraftFrame
	Base.SetBackdrop(CraftFrame)
	Skin.UIPanelCloseButton(_G.CraftFrameCloseButton)
    _G.CraftFrameCloseButton:SetPoint("TOPRIGHT", 4, 5)
	_G.CraftFramePortrait:SetAlpha(0)
	for i = 2, 5 do
		select(i, CraftFrame:GetRegions()):Hide()
	end
	for i = 7, 10 do
		select(i, CraftFrame:GetRegions()):Hide()
	end
    Skin.UIPanelButtonTemplate(_G.CraftCancelButton)
    Skin.UIPanelButtonTemplate(_G.CraftCreateButton)
    Util.PositionRelative("BOTTOMRIGHT", CraftFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        _G.CraftCancelButton,
        _G.CraftCreateButton,
    })
	_G.CraftSkillBorderLeft:Hide()
	_G.CraftSkillBorderRight:Hide()
	Skin.ClassTrainerDetailScrollFrameTemplate(_G.CraftListScrollFrame)
	Skin.ClassTrainerDetailScrollFrameTemplate(_G.CraftDetailScrollFrame)
	for i = 1, 8 do
		Skin.CraftButtonTemplate(_G["Craft"..i])
		Skin.CraftItemTemplate(_G["CraftReagent"..i])
	end
end
