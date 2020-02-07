local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals type next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ChatFrame.lua ]]
    function Hook.ChatEdit_UpdateHeader(editBox)
        local chatType = editBox:GetAttribute("chatType")
        if not chatType then
            editBox:SetBackdropBorderColor(Color.frame)
            return
        end

        local info = _G.ChatTypeInfo[chatType]
        if chatType == "CHANNEL" then
            local localID, channelName = _G.GetChannelName(_G.ChatEdit_GetChannelTarget(editBox))
            if channelName then
                info = _G.ChatTypeInfo["CHANNEL"..localID]
            end
        end

        editBox:SetBackdropBorderColor(info.r, info.g, info.b)
    end

    function Hook.GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
        local chatType = event:sub(10)
        if ( chatType:sub(1, 7) == "WHISPER" ) then
            chatType = "WHISPER"
        end
        if ( chatType:sub(1, 7) == "CHANNEL" ) then
            chatType = "CHANNEL"..arg8
        end

        --ambiguate guild chat names
        if (chatType == "GUILD") then
            arg2 = _G.Ambiguate(arg2, "guild")
        else
            arg2 = _G.Ambiguate(arg2, "none")
        end

        local info = _G.ChatTypeInfo[chatType]
        if arg12 and info and _G.Chat_ShouldColorChatByClass(info) then
            local _, classToken = _G.GetPlayerInfoByGUID(arg12)

            if classToken then
                local color = _G.CUSTOM_CLASS_COLORS[classToken]
                if color then
                    return ("|c%s%s|r"):format(color.colorStr, arg2)
                end
            end
        end

        return arg2
    end
end

do --[[ FrameXML\ChatFrame.xml ]]
    function Skin.ChatFrameEditBoxTemplate(EditBox)
        Skin.FrameTypeEditBox(EditBox)

        local name = EditBox:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Mid"]:Hide()
        if private.isRetail then
            EditBox.focusLeft:SetAlpha(0)
            EditBox.focusRight:SetAlpha(0)
            EditBox.focusMid:SetAlpha(0)
        end
        EditBox.header:SetPoint("LEFT", 10, 0)
    end
end

function private.FrameXML.ChatFrame()
    if private.disabled.chat then return end
    _G.hooksecurefunc("ChatEdit_UpdateHeader", Hook.ChatEdit_UpdateHeader)

    _G.GetColoredName = Hook.GetColoredName

    --[[
    local AddMessage = {}
    local function FixClassColors(frame, message, ...) -- 3174
        if type(message) == "string" and message:find("|cff") then -- type check required for shitty addons that pass nil or non-string values
            for classToken, classColor in next, _G.RAID_CLASS_COLORS do
                local color = _G.CUSTOM_CLASS_COLORS[classToken]
                message = color and message:gsub(classColor.colorStr, color.colorStr) or message -- color check required for Warmup, maybe others
            end
        end
        return AddMessage[frame](frame, message, ...)
    end

    for i = 1, _G.NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame"..i]
        AddMessage[frame] = frame.AddMessage
        frame.AddMessage = FixClassColors
    end
    ]]
end
