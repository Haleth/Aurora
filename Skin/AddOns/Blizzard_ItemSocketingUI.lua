local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_ItemSocketingUI.lua ]]
    local defaultCoords = {0.11627906976744, 0.88372093023256, 0.11627906976744, 0.88372093023256}
    local GEM_TYPE_INFO = {
        Yellow = {
            coords = defaultCoords,
            color = Color.yellow,
        },
        Red = {
            coords = defaultCoords,
            color = Color.red,
        },
        Blue = {
            coords = defaultCoords,
            color = Color.blue,
        },
        Meta = {
            coords = {0.18965517241379, 0.77586206896552, 0.16981132075472, 0.81132075471698},
            color = Color.grayLight,
        },
        Hydraulic = {
            coords = defaultCoords,
            color = Color.grayDark,
        },
        Cogwheel = {
            coords = defaultCoords,
            color = Color.yellow,
        },
        Prismatic = {
            coords = defaultCoords,
            color = Color.white,
        },
        PunchcardRed = {
            coords = defaultCoords,
            color = Color.red,
        },
        PunchcardYellow = {
            coords = defaultCoords,
            color = Color.yellow,
        },
        PunchcardBlue = {
            coords = defaultCoords,
            color = Color.blue,
        },
    }

    function Hook.ItemSocketingFrame_Update()
        for i, socket in ipairs(_G.ItemSocketingFrame.Sockets) do
            local gemInfo = GEM_TYPE_INFO[_G.GetSocketTypes(i)]
            socket.Background:SetTexCoord(gemInfo.coords[1], gemInfo.coords[2], gemInfo.coords[3], gemInfo.coords[4])
            socket:SetBackdropBorderColor(gemInfo.color, 1)
        end

        local num = _G.GetNumSockets()
        if num == 3 then
            _G.ItemSocketingSocket1:SetPoint("BOTTOM", _G.ItemSocketingFrame, "BOTTOM", -80, 39)
        elseif num == 2 then
            _G.ItemSocketingSocket1:SetPoint("BOTTOM", _G.ItemSocketingFrame, "BOTTOM", -40, 39)
        else
            _G.ItemSocketingSocket1:SetPoint("BOTTOM", _G.ItemSocketingFrame, "BOTTOM", 0, 39)
        end
    end
end

do --[[ AddOns\Blizzard_ItemSocketingUI.xml ]]
    function Skin.ItemSocketingSocketButtonTemplate(Button)
        local name = Button:GetName()
        _G[name.."Left"]:SetAlpha(0)
        _G[name.."Right"]:SetAlpha(0)
        select(2, Button:GetRegions()):Hide() -- drop shadow

        Base.CreateBackdrop(Button, {
            edgeSize = 1,
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }, {bg = Button.Background})

        Base.CropIcon(Button.icon)
        Button.icon:ClearAllPoints()
        Button.icon:SetPoint("TOPLEFT", 1, -1)
        Button.icon:SetPoint("BOTTOMRIGHT", -1, 1)

        local shine = _G[name.."Shine"]
        shine:ClearAllPoints()
        shine:SetAllPoints(Button.icon)

        local BracketFrame = Button.BracketFrame
        BracketFrame:ClearAllPoints()
        BracketFrame:SetPoint("TOPLEFT", -4, 4)
        BracketFrame:SetPoint("BOTTOMRIGHT", 4, -4)

        BracketFrame.ClosedBracket:SetAllPoints()
        BracketFrame.OpenBracket:SetAllPoints()

        Base.CropIcon(Button:GetPushedTexture())
        Base.CropIcon(Button:GetHighlightTexture())
    end
end

function private.AddOns.Blizzard_ItemSocketingUI()
    _G.hooksecurefunc("ItemSocketingFrame_Update", Hook.ItemSocketingFrame_Update)
    local ItemSocketingFrame = _G.ItemSocketingFrame

    Skin.ButtonFrameTemplate(ItemSocketingFrame)
    do -- Hide textures
        ItemSocketingFrame["ParchmentFrame-Top"]:Hide()
        ItemSocketingFrame["ParchmentFrame-Bottom"]:Hide()
        ItemSocketingFrame["ParchmentFrame-Left"]:Hide()
        ItemSocketingFrame["ParchmentFrame-Right"]:Hide()

        ItemSocketingFrame["SocketFrame-Left"]:Hide()
        ItemSocketingFrame["SocketFrame-Right"]:Hide()

        ItemSocketingFrame["ButtonFrame-Left"]:Hide()
        ItemSocketingFrame["ButtonFrame-Right"]:Hide()
        ItemSocketingFrame["ButtonBorder-Mid"]:Hide()

        ItemSocketingFrame["GoldBorder-BottomRight"]:Hide()
        ItemSocketingFrame["GoldBorder-BottomLeft"]:Hide()
        ItemSocketingFrame["GoldBorder-TopRight"]:Hide()
        ItemSocketingFrame["GoldBorder-TopLeft"]:Hide()
        ItemSocketingFrame["GoldBorder-Left"]:Hide()
        ItemSocketingFrame["GoldBorder-Right"]:Hide()
        ItemSocketingFrame["GoldBorder-Top"]:Hide()
        ItemSocketingFrame["GoldBorder-Bottom"]:Hide()

        ItemSocketingFrame.BackgroundColor:Hide()
        ItemSocketingFrame.BackgroundHighlight:Hide()

        ItemSocketingFrame["BorderShadow-TopLeftCorner"]:Hide()
        ItemSocketingFrame["BorderShadow-TopRightCorner"]:Hide()
        ItemSocketingFrame["BorderShadow-BottomLeftCorner"]:Hide()
        ItemSocketingFrame["BorderShadow-BottomRightCorner"]:Hide()
        ItemSocketingFrame["BorderShadow-Top"]:Hide()
        ItemSocketingFrame["BorderShadow-Left"]:Hide()
        ItemSocketingFrame["BorderShadow-Bottom"]:Hide()
        ItemSocketingFrame["BorderShadow-Right"]:Hide()

        ItemSocketingFrame.BottomLeftNub:Hide()
        ItemSocketingFrame.BottomRightNub:Hide()
        ItemSocketingFrame.MiddleLeftNub:Hide()
        ItemSocketingFrame.MiddleRightNub:Hide()
        ItemSocketingFrame.TopLeftNub:Hide()
        ItemSocketingFrame.TopRightNub:Hide()
    end

    Skin.UIPanelScrollFrameTemplate(_G.ItemSocketingScrollFrame)
    _G.ItemSocketingScrollFrameBottom:SetAlpha(0)
    _G.ItemSocketingScrollFrameTop:SetAlpha(0)
    _G.ItemSocketingScrollFrameMiddle:SetAlpha(0)

    Skin.ItemSocketingSocketButtonTemplate(_G.ItemSocketingSocket1)
    Skin.ItemSocketingSocketButtonTemplate(_G.ItemSocketingSocket2)
    Skin.ItemSocketingSocketButtonTemplate(_G.ItemSocketingSocket3)
    Skin.UIPanelButtonTemplate(_G.ItemSocketingSocketButton) -- BlizzWTF: this doesn't use the template, but it should
end
