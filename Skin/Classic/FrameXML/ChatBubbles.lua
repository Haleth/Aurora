local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

local chatBubbleEvents = {
    CHAT_MSG_SAY = "chatBubbles",
    CHAT_MSG_YELL = "chatBubbles",
    CHAT_MSG_MONSTER_SAY = "chatBubbles",
    CHAT_MSG_MONSTER_YELL = "chatBubbles",

    CHAT_MSG_PARTY = "chatBubblesParty",
    CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
    CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
}

do --[[ FrameXML\ChatBubbles.lua ]]
    local defaultColor = "ffffffff"
    local function FindChatBubble(msg)
        local chatbubble
        local chatbubbles = _G.C_ChatBubbles.GetAllChatBubbles()
        for index = 1, #chatbubbles do
            if private.isPatch then
                chatbubble = chatbubbles[index]:GetChildren()
            else
                chatbubble = chatbubbles[index]
                if not chatbubble.String then
                    for i = 1, chatbubble:GetNumRegions() do
                        local region = _G.select(i, chatbubble:GetRegions())
                        if region:GetObjectType() == "Texture" then
                            if region:GetTexture():find("Tail") then
                                chatbubble.Tail = region
                            else
                                region:SetTexture(nil)
                            end
                        elseif region:GetObjectType() == "FontString" then
                            chatbubble.String = region
                        end
                    end
                end
            end

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

do --[[ FrameXML\ChatBubbles.xml ]]
    function Skin.ChatBubbleTemplate(Frame)
        Skin.FrameTypeFrame(Frame)
        Frame:SetScale(_G.UIParent:GetScale())

        local tail = Frame.Tail
        tail:SetColorTexture(0, 0, 0)
        tail:SetVertexOffset(1, 0, -3)
        tail:SetVertexOffset(2, 16, -3)
        tail:SetVertexOffset(3, 0, -3)
        tail:SetVertexOffset(4, 0, -3)

        local name = Frame:CreateFontString(nil, "BORDER")
        name:SetPoint("TOPLEFT", 5, 5)
        name:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", -5, -5)
        name:SetJustifyH("LEFT")
        name:SetFontObject(_G.Game12Font_o1)
        Frame._auroraName = name
    end
end

function private.FrameXML.ChatBubbles()
    local bubbleHook = _G.CreateFrame("Frame")
    bubbleHook:SetScript("OnEvent", Hook.ChatBubble_OnEvent)
    bubbleHook:SetScript("OnUpdate", Hook.ChatBubble_OnUpdate)
    bubbleHook:Hide()

    for event in next, chatBubbleEvents do
        bubbleHook:RegisterEvent(event)
    end
end
