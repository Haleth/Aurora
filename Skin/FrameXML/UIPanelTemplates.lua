local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local F = _G.unpack(Aurora)
local Skin = Aurora.Skin

function private.FrameXML.UIPanelTemplates()
    function Skin.TranslucentFrameTemplate(frame)
        for i = 1, 9 do
            _G.select(i, frame:GetRegions()):Hide()
        end
        F.CreateBD(frame)
    end
end
