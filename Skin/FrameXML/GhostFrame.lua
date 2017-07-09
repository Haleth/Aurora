local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.GhostFrame()
    Skin.UIPanelLargeSilverButton(_G.GhostFrame)

    _G.GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)
    local iconBorder = _G.GhostFrameContentsFrame:CreateTexture(nil, "BORDER")
    iconBorder:SetPoint("TOPLEFT", _G.GhostFrameContentsFrameIcon, -1, 1)
    iconBorder:SetPoint("BOTTOMRIGHT", _G.GhostFrameContentsFrameIcon, 1, -1)
    iconBorder:SetColorTexture(0, 0, 0)
end
