local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_LandingSoulbinds.lua ]]
    function Hook.LandingSoulbind_Create(parent)
        local SoulbindPanel = select(parent:GetNumChildren(), parent:GetChildren())
        Skin.LandingPageSoulbindPanelTemplate(SoulbindPanel)
    end
end

do --[[ AddOns\Blizzard_LandingSoulbinds.xml ]]
    function Skin.LandingPageSoulbindButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
    end
    function Skin.LandingPageSoulbindPanelTemplate(Frame)
        local divider = Frame:GetRegions()
        divider:SetColorTexture(1, 1, 1, 0.2)
        divider:SetSize(261, 1)
        divider:SetPoint("TOPLEFT", 50, 0)
        --Skin.LandingPageSoulbindButtonTemplate(Frame.SoulbindButton)
    end
end

function private.AddOns.Blizzard_LandingSoulbinds()
    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_LandingSoulbindButton --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --  Blizzard_LandingSoulbindPanel  --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc(_G.LandingSoulbind, "Create", Hook.LandingSoulbind_Create)
end
