local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

function private.FrameXML.GhostFrame()
    Skin.UIPanelLargeSilverButton(_G.GhostFrame)
    Base.CropIcon(_G.GhostFrameContentsFrameIcon, _G.GhostFrameContentsFrame)
end
