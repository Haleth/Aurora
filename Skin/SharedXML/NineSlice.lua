local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook = Aurora.Hook
local Color, Util = Aurora.Color, Aurora.Util

do --[[ SharedXML\NineSlice.lua ]]
    local nineSliceSetup =    {
        "TopLeftCorner",
        "TopRightCorner",
        "BottomLeftCorner",
        "BottomRightCorner",
        "TopEdge",
        "BottomEdge",
        "LeftEdge",
        "RightEdge",
        "Center",
    }

    local function BasicSkin(Frame)
        Base.CreateBackdrop(Frame, private.backdrop, {
            tl = Frame.TopLeftCorner,
            tr = Frame.TopRightCorner,
            bl = Frame.BottomLeftCorner,
            br = Frame.BottomRightCorner,

            t = Frame.TopEdge,
            b = Frame.BottomEdge,
            l = Frame.LeftEdge,
            r = Frame.RightEdge,

            bg = Frame.Center,
        })
        Base.SetBackdrop(Frame)
    end

    local layouts = {
        SimplePanelTemplate = BasicSkin,
        PortraitFrameTemplate = BasicSkin,
        PortraitFrameTemplateMinimizable = BasicSkin,
        ButtonFrameTemplateNoPortrait = BasicSkin,
        ButtonFrameTemplateNoPortraitMinimizable = BasicSkin,
        InsetFrameTemplate = function(Frame)
            Base.CreateBackdrop(Frame, private.backdrop, {
                tl = Frame.TopLeftCorner,
                tr = Frame.TopRightCorner,
                bl = Frame.BottomLeftCorner,
                br = Frame.BottomRightCorner,

                t = Frame.TopEdge,
                b = Frame.BottomEdge,
                l = Frame.LeftEdge,
                r = Frame.RightEdge,

                bg = Frame.Center,
            })

            Frame:SetBackdropColor(Color.frame, 0)
            Frame:SetBackdropBorderColor(Color.frame, 0)
        end,
        BFAMissionHorde = BasicSkin,
        BFAMissionAlliance = BasicSkin,
        BFAMissionNeutral = BasicSkin,
        Dialog = BasicSkin,

        -- Blizzard_OrderHallUI
        BFAOrderTalentHorde = BasicSkin,
        BFAOrderTalentAlliance = BasicSkin,

        -- Blizzard_PartyPoseUI
        PartyPoseFrameTemplate = BasicSkin,
        PartyPoseKit = BasicSkin,

        -- Blizzard_WarboardUI
        WarboardTextureKit = BasicSkin,
        WarboardTextureKit_FourCorners = BasicSkin,
    }

    local layoutMap = {}
    for layoutName in next, layouts do
        local layout = _G.NineSliceUtil.GetLayout(layoutName)
        if layout then
            layoutMap[layout] = layoutName
        end
    end

    local function GetNineSlicePiece(container, pieceName)
        if container.GetNineSlicePiece then
            return container:GetNineSlicePiece(pieceName)
        end

        return container[pieceName]
    end

    Hook.NineSliceUtil = {}
    function Hook.NineSliceUtil.ApplyLayout(container, userLayout, textureKit)
        if not container._auroraNineSlice then return end

        local layoutName = layoutMap[userLayout]
        if layouts[layoutName] then
            layouts[layoutName](container)
        else
            if not container._auroraBackdrop then return end
            container:SetBackdrop(private.backdrop)
            for i = 1, #nineSliceSetup do
                local piece = GetNineSlicePiece(container, nineSliceSetup[i])
                if piece then
                    piece:SetTexture("")
                end
            end
        end
    end
    function Hook.NineSliceUtil.ApplyLayoutByName(container, userLayoutName, textureKit)
        if not container.GetFrameLayoutType then
            if layouts[userLayoutName] then
                layouts[userLayoutName](container)
            end
        end
    end
    function Hook.NineSliceUtil.AddLayout(layoutName, layout)
        layoutMap[layout] = layoutName
    end
end

function private.SharedXML.NineSlice()
    Util.Mixin(_G.NineSliceUtil, Hook.NineSliceUtil)
end
