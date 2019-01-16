local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_ItemSocketingUI.lua ]]
    local GEM_TYPE_INFO = {
        Yellow = {
            left = 0.01953125, right = 0.1484375, top = 0.66015625, bottom = 0.7890625,
            color = Color.yellow,
        },
        Red = {
            left = 0.1953125, right = 0.32421875, top = 0.66015625, bottom = 0.7890625,
            color = Color.red,
        },
        Blue = {
            left = 0.37109375, right = 0.5, top = 0.66015625, bottom = 0.7890625,
            color = Color.blue,
        },
        Meta = {
            left = 0.22265625, right = 0.34765625, top = 0.44140625, bottom = 0.56640625,
            color = Color.grayLight,
        },
        Hydraulic = {
            left = 0.09375, right = 0.609375, top = 0.509765625, bottom = 0.57421875,
            color = Color.grayDark,
        },
        Cogwheel = {
            left = 0.09375, right = 0.609375, top = 0.421875, bottom = 0.486328125,
            color = Color.yellow,
        },
        Prismatic = {
            left = 0.09375, right = 0.609375, top = 0.7734375, bottom = 0.837890625,
            color = Color.white,
        },
    }

    function Hook.ItemSocketingFrame_Update()
        local socket, socketName
        local gemBorder

        for i = 1, _G.MAX_NUM_SOCKETS do
            socketName = "ItemSocketingSocket"..i
            socket = _G[socketName]

            local gemInfo = GEM_TYPE_INFO[_G.GetSocketTypes(i)]
            --Util.TableInspect(gemInfo)
            gemBorder = _G[socketName.."Background"]
            gemBorder:SetTexCoord(gemInfo.left, gemInfo.right, gemInfo.top, gemInfo.bottom)
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
        }, {bg = _G[name.."Background"]})

        Base.CropIcon(Button.icon)
        Button.icon:ClearAllPoints()
        Button.icon:SetPoint("TOPLEFT", 1, -1)
        Button.icon:SetPoint("BOTTOMRIGHT", -1, 1)

        local shine = _G[name.."Shine"]
        shine:ClearAllPoints()
        shine:SetAllPoints(Button.icon)

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
