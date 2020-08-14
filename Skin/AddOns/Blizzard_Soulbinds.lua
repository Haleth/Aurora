local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_Soulbinds.lua ]]
--end

--do --[[ AddOns\Blizzard_Soulbinds.xml ]]
--end

function private.AddOns.Blizzard_Soulbinds()
    ----====####$$$$%%%%%$$$$####====----
    --   Blizzard_SoulbindsTemplates   --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_SoulbindsSelectButton --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    --  Blizzard_SoulbindsSelectGroup  --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    --    Blizzard_SoulbindsConduit    --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --     Blizzard_SoulbindsNode     --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --   Blizzard_SoulbindsNodeLink   --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --     Blizzard_SoulbindsTree     --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_SoulbindsViewer    --
    ----====####$$$$%%%%$$$$####====----
    local SoulbindViewer = _G.SoulbindViewer
    Base.SetBackdrop(SoulbindViewer)
    SoulbindViewer.Background:Hide()
    SoulbindViewer.Background2:Hide()

    SoulbindViewer.ShadowTop:Hide()
    SoulbindViewer.ShadowBottom:Hide()
    SoulbindViewer.ShadowLeft:Hide()
    SoulbindViewer.ShadowRight:Hide()

    Skin.UIPanelCloseButton(SoulbindViewer.CloseButton)
    --Skin.SoulbindSelectGroupTemplate(SoulbindViewer.SelectGroup)
    --Skin.SoulbindTreeTemplate(SoulbindViewer.Tree)
    Skin.UIPanelButtonTemplate(SoulbindViewer.ActivateButton)
    --Skin.SoulbindsUndoButtonTemplate(SoulbindViewer.ResetButton)


    ----====####$$$$%%%%$$$$####====----
    --       Blizzard_Soulbinds       --
    ----====####$$$$%%%%$$$$####====----
end
