local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_Soulbinds.lua ]]
--end

do --[[ AddOns\Blizzard_Soulbinds.xml ]]
    do --[[ Blizzard_SoulbindsConduitList.lua ]]
        function Skin.ConduitListSectionTemplate(Frame)
            Skin.FrameTypeButton(Frame.CategoryButton)
            local bg1, bg2 = Frame.CategoryButton.Container:GetRegions()
            bg1:SetAlpha(0)
            bg2:SetAlpha(0)
        end
        function Skin.ConduitListTemplate(Frame)
            --Skin.ScrollBarTemplate(Frame.ScrollBar)
            Frame.ScrollBar.Track:Hide()
            Skin.FrameTypeScrollBarButton(Frame.ScrollBar.Decrease)
            Skin.FrameTypeScrollBarButton(Frame.ScrollBar.Increase)
            Skin.FrameTypeScrollBarButton(Frame.ScrollBar.Thumb)

            --Skin.ScrollBoxTemplate(Frame.ScrollBox)
            for i = 1, #Frame.ScrollBox.ScrollTarget.Lists do
                Skin.ConduitListSectionTemplate(Frame.ScrollBox.ScrollTarget.Lists[i])
            end
            local _, strataFrame = Frame.ScrollBox:GetChildren()
            strataFrame:Hide()
        end
    end

end

function private.AddOns.Blizzard_Soulbinds()
    ----====####$$$$%%%%$$$$####====----
    --     Blizzard_SoulbindsUtil     --
    ----====####$$$$%%%%$$$$####====----


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


    ----====####$$$$%%%%%$$$$####====----
    --  Blizzard_SoulbindsConduitList  --
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

    local scrollBG = select("9", SoulbindViewer:GetRegions())
    scrollBG:Hide()

    SoulbindViewer.Border:Hide()
    Skin.UIPanelCloseButton(SoulbindViewer.CloseButton)
    --Skin.SoulbindSelectGroupTemplate(SoulbindViewer.SelectGroup)
    --Skin.SoulbindTreeTemplate(SoulbindViewer.Tree)
    Skin.ConduitListTemplate(SoulbindViewer.ConduitList)
    Skin.UIPanelButtonTemplate(SoulbindViewer.ActivateSoulbindButton)
    Skin.UIPanelButtonTemplate(SoulbindViewer.CommitConduitsButton)
    --Skin.SoulbindsUndoButtonTemplate(SoulbindViewer.ResetConduitsButton)


    ----====####$$$$%%%%$$$$####====----
    --       Blizzard_Soulbinds       --
    ----====####$$$$%%%%$$$$####====----
end
