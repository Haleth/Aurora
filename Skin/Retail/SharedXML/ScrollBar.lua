local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\ScrollBar.lua ]]
--end

do --[[ FrameXML\ScrollBar.xml ]]
    function Skin.ScrollBarTemplate(Frame)
        Skin.ScrollControllerTemplate(Frame)
    end
    function Skin.FrameTypeScrollBarButton(Button)
        Skin.FrameTypeButton(Button)
        local tex = Button:GetRegions()
        if Button.direction then
            Button:SetBackdropOption("offsets", {
                left = 2,
                right = 1,
                top = 0,
                bottom = 1,
            })

            local bg = Button:GetBackdropTexture("bg")
            tex:ClearAllPoints()
            tex:SetPoint("TOPLEFT", bg, 3, -5)
            tex:SetPoint("BOTTOMRIGHT", bg, -3, 5)
            Button._auroraTextures = {tex}

            Button:HookScript("OnShow", function()
                if Button.direction == _G.ScrollControllerMixin.Directions.Decrease then
                    Base.SetTexture(tex, "arrowUp")
                else
                    Base.SetTexture(tex, "arrowDown")
                end
            end)
        else
            Button:SetBackdropOption("offsets", {
                left = 0,
                right = -1,
                top = 0,
                bottom = 1,
            })
            tex:Hide()
        end

        Button.Enter:SetAlpha(0)
        Button.Down:SetAlpha(0)
    end
end

function private.SharedXML.ScrollBar()
    ----====####$$$$%%%%$$$$####====----
    --              ScrollBar              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
