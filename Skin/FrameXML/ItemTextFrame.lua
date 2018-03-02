local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ItemTextFrame.lua ]]
    function Hook.ItemTextFrame_OnEvent(self, event, ...)
        if event == "ITEM_TEXT_BEGIN" then
            if _G.ItemTextGetMaterial() == "ParchmentLarge" then
                _G.ItemTextPageText:SetTextColor("P", Color.grayLight:GetRGB())
                _G.ItemTextPageText:SetTextColor("H1", Color.white:GetRGB())
                _G.ItemTextPageText:SetTextColor("H2", Color.white:GetRGB())
                _G.ItemTextPageText:SetTextColor("H3", Color.white:GetRGB())
            else
                -- Legacy behavior - ignore the title color
                _G.ItemTextPageText:SetTextColor("P", Color.grayLight:GetRGB())
                _G.ItemTextPageText:SetTextColor("H1", Color.grayLight:GetRGB())
                _G.ItemTextPageText:SetTextColor("H2", Color.grayLight:GetRGB())
                _G.ItemTextPageText:SetTextColor("H3", Color.grayLight:GetRGB())
            end
        elseif event == "ITEM_TEXT_READY" then
            local page = _G.ItemTextGetPage()
            local hasNext = _G.ItemTextHasNextPage()

            _G.ItemTextScrollFrame:ClearAllPoints()
            if (page > 1) or hasNext then
                _G.ItemTextScrollFrame:SetPoint("TOPLEFT", _G.ItemTextFrame, 4, -(private.FRAME_TITLE_HEIGHT * 2 + 4))
                _G.ItemTextScrollFrame:SetPoint("BOTTOMRIGHT", _G.ItemTextFrame, -23, 4)
            else
                _G.ItemTextScrollFrame:SetPoint("TOPLEFT", _G.ItemTextFrame, 4, -(private.FRAME_TITLE_HEIGHT + 4))
                _G.ItemTextScrollFrame:SetPoint("BOTTOMRIGHT", _G.ItemTextFrame, -23, 4)
            end
            Scale.RawSetSize(_G.ItemTextPageText, _G.ItemTextScrollFrame:GetSize())
        end
    end
end

function private.FrameXML.ItemTextFrame()
    _G.ItemTextFrame:HookScript("OnEvent", Hook.ItemTextFrame_OnEvent)

    Skin.ButtonFrameTemplate(_G.ItemTextFrame)

    -- BlizzWTF: The prtrait in the template is not being used.
    _G.select(18, _G.ItemTextFrame:GetRegions()):Hide()
    _G.ItemTextFramePageBg:SetAlpha(0)

    _G.ItemTextMaterialTopLeft:SetAlpha(0)
    _G.ItemTextMaterialTopRight:SetAlpha(0)
    _G.ItemTextMaterialBotLeft:SetAlpha(0)
    _G.ItemTextMaterialBotRight:SetAlpha(0)

    _G.ItemTextCurrentPage:SetPoint("TOP", 0, -(private.FRAME_TITLE_HEIGHT * 1.25))

    Skin.UIPanelStretchableArtScrollBarTemplate(_G.ItemTextScrollFrame.ScrollBar)
    _G.ItemTextScrollFrame.ScrollBar:SetPoint("TOPLEFT", _G.ItemTextScrollFrame, "TOPRIGHT", 1, -17)
    _G.ItemTextScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", _G.ItemTextScrollFrame, "BOTTOMRIGHT", 1, 17)

    _G.ItemTextStatusBar:SetHeight(17)
    Base.SetTexture(_G.ItemTextStatusBar:GetStatusBarTexture(), "gradientUp")
    local statusBG = _G.ItemTextStatusBar:GetRegions()
    statusBG:SetColorTexture(Color.frame:GetRGB())
    statusBG:SetDrawLayer("BACKGROUND", -3)
    statusBG:ClearAllPoints()
    statusBG:SetPoint("TOPLEFT")
    statusBG:SetPoint("BOTTOMRIGHT")


    for i, delta in _G.next, {"PrevPageButton", "NextPageButton"} do
        local button = _G["ItemText"..delta]
        button:ClearAllPoints()
        if i == 1 then
            Skin.NavButtonPrevious(button)
            button:SetPoint("TOPLEFT", 32, -(private.FRAME_TITLE_HEIGHT * 1.2))
            button:GetRegions():SetPoint("LEFT", button, "RIGHT", 3, 0)
        else
            Skin.NavButtonNext(button)
            button:SetPoint("TOPRIGHT", -32, -(private.FRAME_TITLE_HEIGHT * 1.2))
            button:GetRegions():SetPoint("RIGHT", button, "LEFT", -3, 0)
        end
    end
end
