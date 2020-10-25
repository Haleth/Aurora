local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

local chatBubbleEvents = {
    CHAT_MSG_SAY = "chatBubbles",
    CHAT_MSG_YELL = "chatBubbles",
    CHAT_MSG_MONSTER_SAY = "chatBubbles",
    CHAT_MSG_MONSTER_YELL = "chatBubbles",

    CHAT_MSG_PARTY = "chatBubblesParty",
    CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
    CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
}

do --[[ FrameXML\Backdrop.lua ]]
    local defaultColor = "ffffffff"
    local function FindChatBubble(msg)
        local chatbubble
        local chatbubbles = _G.C_ChatBubbles.GetAllChatBubbles()
        for index = 1, #chatbubbles do
            chatbubble = chatbubbles[index]:GetChildren()

            if not chatbubble._auroraName then
                Skin.ChatBubbleTemplate(chatbubble)
            end

            if chatbubble.String:GetText() == msg then
                return chatbubble
            end
        end
    end

    function Hook.ChatBubble_SetName(chatbubble, guid, name)
        local color
        if guid ~= nil and guid ~= "" then
            local _, class = _G.GetPlayerInfoByGUID(guid)
            color = _G.CUSTOM_CLASS_COLORS[class].colorStr
        else
            color = defaultColor
        end
        chatbubble._auroraName:SetFormattedText("|c%s%s|r", color, name)
    end
    function Hook.ChatBubble_OnEvent(self, event, msg, sender, _, _, _, _, _, _, _, _, _, guid)
        if _G.GetCVarBool(chatBubbleEvents[event]) then
            self.elapsed = 0
            self.msg = msg
            self.sender = _G.Ambiguate(sender, "none") -- Only show realm if it's not yours
            self.guid = guid
            self:Show()
        end
    end
    function Hook.ChatBubble_OnUpdate(self, elapsed)
        self.elapsed = self.elapsed + elapsed
        local chatbubble = FindChatBubble(self.msg)
        if chatbubble or self.elapsed > 0.3 then
            self:Hide()
            if chatbubble then
                Hook.ChatBubble_SetName(chatbubble, self.guid, self.sender)
            end
        end
    end
end

do --[[ FrameXML\Backdrop.xml ]]
    function Skin.TooltipBackdropTemplate(Frame)
        Skin.FrameTypeFrame(Frame)
    end
    function Skin.TooltipBorderBackdropTemplate(Frame)
        Skin.FrameTypeFrame(Frame)
        Frame:SetBackdropColor(Color.frame, 0)
    end
    function Skin.ChatBubbleTemplate(Frame)
        Skin.FrameTypeFrame(Frame)
        Frame:SetScale(_G.UIParent:GetScale())

        local tail = Frame.Tail
        tail:SetColorTexture(0, 0, 0)
        tail:SetVertexOffset(1, 0, -5)
        tail:SetVertexOffset(2, 16, -5)
        tail:SetVertexOffset(3, 0, -5)
        tail:SetVertexOffset(4, 0, -5)

        local name = Frame:CreateFontString(nil, "BORDER")
        name:SetPoint("TOPLEFT", 5, 5)
        name:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", -5, -5)
        name:SetJustifyH("LEFT")
        name:SetFontObject(_G.Game12Font_o1)
        Frame._auroraName = name
    end
end

function private.SharedXML.Backdrop()
    local bubbleHook = _G.CreateFrame("Frame")
    bubbleHook:SetScript("OnEvent", Hook.ChatBubble_OnEvent)
    bubbleHook:SetScript("OnUpdate", Hook.ChatBubble_OnUpdate)
    bubbleHook:Hide()

    for event in next, chatBubbleEvents do
        bubbleHook:RegisterEvent(event)
    end
end
