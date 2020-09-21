local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
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
    local function UpdateChatBubble(chatbubble, guid, name)
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
            UpdateChatBubble(chatbubble, self.guid, self.sender)
        end
    end
end

do --[[ FrameXML\Backdrop.xml ]]
    Skin.TooltipBackdropTemplate = Base.SetBackdrop
    function Skin.TooltipBorderBackdropTemplate(Frame)
        Base.SetBackdrop(Frame)
        Frame:SetBackdropColor(Color.frame, 0)
    end
    function Skin.ChatBubbleTemplate(Frame)
        Base.SetBackdrop(Frame)
        Frame:SetScale(_G.UIParent:GetScale())

        local tail = Frame.Tail
        tail:SetColorTexture(0, 0, 0)
        if private.isPatch then
            tail:SetVertexOffset(1, 0, -5)
            tail:SetVertexOffset(2, 16, -5)
            tail:SetVertexOffset(3, 0, -5)
            tail:SetVertexOffset(4, 0, -5)
        else
            tail:SetVertexOffset(1, 0, -3)
            tail:SetVertexOffset(2, 16, -3)
            tail:SetVertexOffset(3, 0, -3)
            tail:SetVertexOffset(4, 0, -3)
        end

        local name = Frame:CreateFontString(nil, "BORDER")
        name:SetPoint("TOPLEFT", 5, 5)
        name:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", -5, -5)
        name:SetJustifyH("LEFT")
        name:SetFontObject(Frame.String:GetFontObject())
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
