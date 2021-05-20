local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_NewPlayerExperienceGuide.lua ]]
--end

--do --[[ AddOns\Blizzard_NewPlayerExperienceGuide.xml ]]
--end

function private.AddOns.Blizzard_NewPlayerExperienceGuide()
    ----====####$$$$%%%%$$$$####====----
    --       GuideCriteriaFrame       --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --           GuideFrame           --
    ----====####$$$$%%%%$$$$####====----
    local GuideFrame = _G.GuideFrame
    Skin.PortraitFrameTemplate(GuideFrame)
    GuideFrame.Background:Hide()
    GuideFrame.Title:SetTextColor(private.PAPER_FRAME_TITLE_COLOR:GetRGB())

    local ScrollFrame = GuideFrame.ScrollFrame
    ScrollFrame.Child.Text:SetTextColor(private.PAPER_FRAME_TITLE_COLOR:GetRGB())
    Skin.UIPanelButtonTemplate(ScrollFrame.ConfirmationButton)
    Skin.MinimalScrollBarWithBorderTemplate(ScrollFrame.ScrollBar)
end
