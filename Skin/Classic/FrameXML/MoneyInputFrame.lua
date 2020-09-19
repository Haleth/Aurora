local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\MoneyInputFrame.lua ]]
--end

do --[[ FrameXML\MoneyInputFrame.xml ]]
    local money = {"gold", "silver", "copper"}
    function Skin.MoneyInputFrameTemplate(Frame)
        for i = 1, #money do
            local EditBox = Frame[money[i]]
            Skin.FrameTypeEditBox(EditBox)
            EditBox:SetBackdropOption("offsets", {
                left = -5,
                right = 15,
                top = 0,
                bottom = 0,
            })

            if private.isRetail then
                EditBox.left:Hide()
                _G[EditBox:GetName().."Middle"]:Hide()
                EditBox.right:Hide()
            else
                local name = EditBox:GetName()
                _G[name.."Left"]:Hide()
                _G[name.."Middle"]:Hide()
                _G[name.."Right"]:Hide()
            end

            local bg = EditBox:GetBackdropTexture("bg")
            EditBox.texture:ClearAllPoints()
            EditBox.texture:SetPoint("LEFT", bg, "RIGHT", 2, 0)

            if i > 1 then
                EditBox:SetPoint("LEFT", Frame[money[i - 1]], "RIGHT", 6, 0)
                EditBox:SetSize(35, 20)
            else
                EditBox:SetSize(70, 20)
            end
        end
    end
    function Skin.LargeMoneyInputBoxTemplate(Frame)
        Skin.LargeInputBoxTemplate(Frame)
    end
    function Skin.LargeMoneyInputFrameTemplate(Frame)
        Skin.LargeMoneyInputBoxTemplate(Frame.CopperBox)
        Skin.LargeMoneyInputBoxTemplate(Frame.SilverBox)
        Skin.LargeMoneyInputBoxTemplate(Frame.GoldBox)
    end
end

--function private.FrameXML.MoneyInputFrame()
--end
