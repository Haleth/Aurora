local _, private = ...

local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

local F, C = {}, {}
Aurora[1] = F
Aurora[2] = C

C.classcolours = _G.CUSTOM_CLASS_COLORS
C.backdrop = private.backdrop

F.CreateBD = function(frame, alpha)
    local r, g, b, a
    if alpha then
        r, g, b = private.frameColor:GetRGB()
        a = alpha
    end

    Base.SetBackdrop(frame, r, g, b, a)
end

F.ReskinClose = function(f, a1, p, a2, x, y)
    f:SetDisabledTexture(C.media.backdrop) -- some frames that use this don't have a disabled texture
    Skin.UIPanelCloseButton(f)

    if not a1 then
        f:SetPoint("TOPRIGHT", -6, -6)
    else
        f:ClearAllPoints()
        f:SetPoint(a1, p, a2, x, y)
    end
end

