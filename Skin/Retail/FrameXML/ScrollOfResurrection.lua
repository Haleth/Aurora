local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F = _G.unpack(Aurora)

function private.FrameXML.ScrollOfResurrection()
    local ScrollOfResurrectionSelectionFrame = _G.ScrollOfResurrectionSelectionFrame
    if private.isRetail then
        Skin.DialogBorderTemplate(ScrollOfResurrectionSelectionFrame.Border)
    else
        Skin.DialogBorderTemplate(ScrollOfResurrectionSelectionFrame)
    end
    F.ReskinInput(ScrollOfResurrectionSelectionFrame.targetEditBox)

    F.CreateBD(ScrollOfResurrectionSelectionFrame.list, .25)
    F.ReskinScroll(ScrollOfResurrectionSelectionFrame.list.scrollFrame.scrollBar)

    F.Reskin(_G.ScrollOfResurrectionSelectionFrameAcceptButton)
    F.Reskin(_G.ScrollOfResurrectionSelectionFrameCancelButton)

    local ScrollOfResurrectionFrame = _G.ScrollOfResurrectionFrame
    if private.isRetail then
        Skin.DialogBorderTemplate(ScrollOfResurrectionFrame.Border)
    else
        Skin.DialogBorderTemplate(ScrollOfResurrectionFrame)
    end
    F.ReskinInput(ScrollOfResurrectionFrame.targetEditBox)
    for i = 1, 9 do
        select(i, ScrollOfResurrectionFrame.noteFrame:GetRegions()):Hide()
    end
    F.Reskin(_G.ScrollOfResurrectionFrameAcceptButton)
    F.Reskin(_G.ScrollOfResurrectionFrameCancelButton)
end
