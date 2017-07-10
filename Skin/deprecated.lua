local _, private = ...

local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

local F, C = {}, {}
Aurora[1] = F
Aurora[2] = C

C.classcolours = _G.CUSTOM_CLASS_COLORS
C.backdrop = private.backdrop

F.CreateBD = function(frame, alpha)
    local r, g, b, a = private.frameColor:GetRGBA()
    if alpha then
        a = alpha
    else
        _G.tinsert(C.frames, frame)
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

