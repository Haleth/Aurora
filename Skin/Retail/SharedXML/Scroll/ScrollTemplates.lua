local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\ScrollTemplates.lua ]]
--end

do --[[ FrameXML\ScrollTemplates.xml ]]
    function Skin.WowScrollBoxList(Frame)
        Skin.ScrollBoxBaseTemplate(Frame)
    end
    function Skin.VerticalScrollBarTemplate(Frame)
        Skin.ScrollBarBaseTemplate(Frame)
    end
    function Skin.WowScrollBarStepperButtonScripts(Frame)
        Skin.FrameTypeButton(Frame)
        Frame.Texture:Hide()
        Frame.Overlay:SetAlpha(0)

        local bg = Frame:GetBackdropTexture("bg")
        local arrow = Frame:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", bg, 3, -5)
        arrow:SetPoint("BOTTOMRIGHT", bg, -3, 5)
        if Frame.direction < 0 then
            Base.SetTexture(arrow, "arrowUp")
        else
            Base.SetTexture(arrow, "arrowDown")
        end
        Frame._auroraTextures = {arrow}
    end
    function Skin.WowScrollBarThumbButtonScripts(Frame)
        Skin.FrameTypeButton(Frame)
        Frame.Begin:Hide()
        Frame.End:Hide()
        Frame.Middle:Hide()
    end

    function Skin.WowTrimScrollBar(Frame)
        Skin.VerticalScrollBarTemplate(Frame)

        local tex = Frame:GetRegions()
        tex:SetPoint("TOPLEFT", 0, 3)
        tex:SetPoint("BOTTOMRIGHT", 0, 0)

        Frame.Background.Begin:Hide()
        Frame.Background.End:Hide()
        Frame.Background.Middle:Hide()

        Frame.Track:SetPoint("TOPLEFT", 4, -17)
        Frame.Track:SetPoint("BOTTOMRIGHT", -4, 20)
        Skin.WowScrollBarThumbButtonScripts(Frame.Track.Thumb)

        Skin.WowScrollBarStepperButtonScripts(Frame.Back)
        Frame.Back:SetPoint("TOPLEFT", 4, 1)
        Skin.WowScrollBarStepperButtonScripts(Frame.Forward)
        Frame.Forward:SetPoint("BOTTOMLEFT", 4, 2)
    end
end

function private.SharedXML.ScrollTemplates()
end
