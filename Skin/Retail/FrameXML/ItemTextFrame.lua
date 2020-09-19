local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
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
        end
    end
end

--do --[[ FrameXML\ItemTextFrame.xml ]]
--end

function private.FrameXML.ItemTextFrame()
    local ItemTextFrame = _G.ItemTextFrame
    ItemTextFrame:HookScript("OnEvent", Hook.ItemTextFrame_OnEvent)

    if private.isRetail then
        Skin.ButtonFrameTemplate(ItemTextFrame)

        -- BlizzWTF: The portrait in the template is not being used.
        select(6, ItemTextFrame:GetRegions()):Hide()
        _G.ItemTextFramePageBg:SetAlpha(0)
    else
        Base.SetBackdrop(ItemTextFrame)
        ItemTextFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local portrait, tl, tr, bl, br = ItemTextFrame:GetRegions()
        portrait:Hide()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()
    end

    _G.ItemTextMaterialTopLeft:SetAlpha(0)
    _G.ItemTextMaterialTopRight:SetAlpha(0)
    _G.ItemTextMaterialBotLeft:SetAlpha(0)
    _G.ItemTextMaterialBotRight:SetAlpha(0)

    if private.isClassic then
        local bg = ItemTextFrame:GetBackdropTexture("bg")
        _G.ItemTextTitleText:ClearAllPoints()
        _G.ItemTextTitleText:SetPoint("TOPLEFT", bg)
        _G.ItemTextTitleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end
    _G.ItemTextCurrentPage:SetPoint("TOP", 0, -(private.FRAME_TITLE_HEIGHT * 1.25))

    if private.isRetail then
        Skin.UIPanelStretchableArtScrollBarTemplate(_G.ItemTextScrollFrame.ScrollBar)
        _G.ItemTextScrollFrame.ScrollBar:SetPoint("TOPLEFT", _G.ItemTextScrollFrame, "TOPRIGHT", 1, -17)
        _G.ItemTextScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", _G.ItemTextScrollFrame, "BOTTOMRIGHT", 1, 17)
    else
        Skin.UIPanelScrollFrameTemplate(_G.ItemTextScrollFrame)
        _G.ItemTextScrollFrame.ScrollBar:SetPoint("TOPLEFT", _G.ItemTextScrollFrame, "TOPRIGHT", 1, -17)
        _G.ItemTextScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", _G.ItemTextScrollFrame, "BOTTOMRIGHT", 1, 17)
        _G.ItemTextScrollFrameTop:Hide()
        _G.ItemTextScrollFrameBottom:Hide()
        _G.ItemTextScrollFrameMiddle:Hide()
    end

    Skin.FrameTypeStatusBar(_G.ItemTextStatusBar)
    _G.ItemTextStatusBar:SetHeight(17)
    _G.ItemTextStatusBar:GetRegions():Hide()

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

    if private.isClassic then
        Skin.UIPanelCloseButton(_G.ItemTextCloseButton)
    end
end
