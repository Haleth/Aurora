local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\ClassTrainerFrameTemplates.lua ]]
--end

do --[[ FrameXML\ClassTrainerFrameTemplates.xml ]]
    function Skin.ClassTrainerSkillButtonTemplate(Button)
        Skin.ExpandOrCollapse(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 307,
            top = 0,
            bottom = 3,
        })
    end
    function Skin.ClassTrainerDetailScrollFrameTemplate(ScrollFrame)
        Skin.UIPanelScrollFrameTemplate(ScrollFrame)
        local name = ScrollFrame:GetName()
        _G[name.."Top"]:SetAlpha(0)
        _G[name.."Bottom"]:SetAlpha(0)
    end
    function Skin.ClassTrainerListScrollFrameTemplate(ScrollFrame)
        Skin.FauxScrollFrameTemplate(ScrollFrame)
        local top, bottom = ScrollFrame:GetRegions()
        top:Hide()
        bottom:Hide()
    end
end

function private.FrameXML.ClassTrainerFrameTemplates()
    ----====####$$$$%%%%$$$$####====----
    --              ClassTrainerFrameTemplates              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
