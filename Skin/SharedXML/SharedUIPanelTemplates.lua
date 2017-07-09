local _, private = ...

-- [[ Lua Globals ]]
local next, tinsert = _G.next, _G.tinsert

-- [[ Core ]]
local Aurora = private.Aurora
local F = _G.unpack(Aurora)
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ SharedXML\SharedUIPanelTemplates.lua ]]
    function Hook.PanelTemplates_DeselectTab(tab)
        local text = tab.Text or _G[tab:GetName().."Text"]
        text:SetPoint("CENTER", tab, "CENTER")
    end
    function Hook.PanelTemplates_SelectTab(tab)
        local text = tab.Text or _G[tab:GetName().."Text"]
        text:SetPoint("CENTER", tab, "CENTER")
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.xml ]]
    function Skin.UIPanelCloseButton(button)
        local size = private.is730 and 16.5 or 17
        button:SetSize(size, size)
        button:SetNormalTexture("")
        button:SetHighlightTexture("")
        button:SetPushedTexture("")

        local dis = button:GetDisabledTexture()
        dis:SetColorTexture(0, 0, 0, .4)
        dis:SetDrawLayer("OVERLAY")
        dis:SetAllPoints()

        F.CreateBD(button, 0)
        F.CreateGradient(button)

        button._auroraHighlight = {}

        local lineOfs = private.is730 and 4 or 2.5
        for i = 1, 2 do
            local line = button:CreateLine()
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(private.is730 and 0.7 or 0.5)
            if i == 1 then
                line:SetStartPoint("TOPLEFT", lineOfs, -lineOfs)
                line:SetEndPoint("BOTTOMRIGHT", -lineOfs, lineOfs)
            else
                line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
                line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
            end
            _G.tinsert(button._auroraHighlight, line)
        end

        Aurora.SetHighlight(button, "color")
    end
    function Skin.PortraitFrameTemplate(frame, noCloseButton)
        local name = frame:GetName()

        frame.Bg:Hide()
        _G[name.."TitleBg"]:Hide()
        frame.portrait:SetAlpha(0)
        frame.portraitFrame:SetTexture("")
        _G[name.."TopRightCorner"]:Hide()
        frame.topLeftCorner:Hide()
        frame.topBorderBar:SetTexture("")

        local titleText = frame.TitleText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT")
        titleText:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -23)

        frame.TopTileStreaks:SetTexture("")
        _G[name.."BotLeftCorner"]:Hide()
        _G[name.."BotRightCorner"]:Hide()
        _G[name.."BottomBorder"]:Hide()
        frame.leftBorderBar:Hide()
        _G[name.."RightBorder"]:Hide()

        F.CreateBD(frame)
        if not noCloseButton then
            Skin.UIPanelCloseButton(frame.CloseButton)
            frame.CloseButton:SetPoint("TOPRIGHT", -3, -3)
        end
    end
    function Skin.InsetFrameTemplate(frame)
        frame.Bg:Hide()

        frame.InsetBorderTopLeft:Hide()
        frame.InsetBorderTopRight:Hide()

        frame.InsetBorderBottomLeft:Hide()
        frame.InsetBorderBottomRight:Hide()

        frame.InsetBorderTop:Hide()
        frame.InsetBorderBottom:Hide()
        frame.InsetBorderLeft:Hide()
        frame.InsetBorderRight:Hide()
    end
    function Skin.ButtonFrameTemplate(frame)
        Skin.PortraitFrameTemplate(frame)
        local name = frame:GetName()

        _G[name.."BtnCornerLeft"]:SetTexture("")
        _G[name.."BtnCornerRight"]:SetTexture("")
        _G[name.."ButtonBottomBorder"]:SetTexture("")
        Skin.InsetFrameTemplate(frame.Inset)
    end
    function Skin.MaximizeMinimizeButtonFrameTemplate(frame)
        for _, name in next, {"MaximizeButton", "MinimizeButton"} do
            local button = frame[name]
            button:SetSize(17, 17)
            button:ClearAllPoints()
            button:SetPoint("CENTER")
            F.Reskin(button)

            button._auroraHighlight = {}

            local lineOfs = 4
            local line = button:CreateLine()
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(0.5)
            line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
            line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
            tinsert(button._auroraHighlight, line)

            local hline = button:CreateTexture()
            hline:SetColorTexture(1, 1, 1)
            hline:SetSize(7, 1)
            tinsert(button._auroraHighlight, hline)

            local vline = button:CreateTexture()
            vline:SetColorTexture(1, 1, 1)
            vline:SetSize(1, 7)
            tinsert(button._auroraHighlight, vline)

            if name == "MaximizeButton" then
                hline:SetPoint("TOP", 1, -4)
                vline:SetPoint("RIGHT", -4, 1)
            else
                hline:SetPoint("BOTTOM", -1, 4)
                vline:SetPoint("LEFT", 4, -1)
            end

            Aurora.SetHighlight(button, "color")
        end
    end
end

function private.SharedXML.SharedUIPanelTemplates()
    _G.hooksecurefunc("PanelTemplates_DeselectTab", Hook.PanelTemplates_DeselectTab)
    _G.hooksecurefunc("PanelTemplates_SelectTab", Hook.PanelTemplates_SelectTab)
end
