local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ChatFrame.lua ]]
    function Hook.ChatEdit_UpdateHeader(editBox)
        local type = editBox:GetAttribute("chatType")
        if not type then
            editBox:SetBackdropBorderColor(Color.frame)
            return
        end

        local info = _G.ChatTypeInfo[type]
        if type == "CHANNEL" then
            local localID, channelName = _G.GetChannelName(_G.ChatEdit_GetChannelTarget(editBox))
            if channelName then
                info = _G.ChatTypeInfo["CHANNEL"..localID]
            end
        end

        editBox:SetBackdropBorderColor(info.r, info.g, info.b)
    end
end

do --[[ FrameXML\ChatFrame.xml ]]
    function Skin.ChatFrameEditBoxTemplate(EditBox)
        local name = EditBox:GetName()
        Base.SetBackdrop(EditBox, Color.frame, 0.3)

        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Mid"]:Hide()
        EditBox.focusLeft:SetAlpha(0)
        EditBox.focusRight:SetAlpha(0)
        EditBox.focusMid:SetAlpha(0)
        EditBox.header:SetPoint("LEFT", 10, 0)
    end
end

function private.FrameXML.ChatFrame()
    if private.disabled.chat then return end
    _G.hooksecurefunc("ChatEdit_UpdateHeader", Hook.ChatEdit_UpdateHeader)

    --[[ Scale ]]--
end
