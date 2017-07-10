local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.ChatBubbles()
    if not _G.AuroraConfig.chatBubbles then return end

    local tailSize = 16
    local function styleBubble(frame)
        local font
        for i = 1, frame:GetNumRegions() do
            local region = _G.select(i, frame:GetRegions())
            if region:GetObjectType() == "Texture" then
                region:SetTexture(nil)
            elseif region:GetObjectType() == "FontString" then
                font = region:GetFontObject()
                frame._auroraText = region
            end
        end

        F.CreateBD(frame)
        frame:SetScale(_G.UIParent:GetScale())

        local tail = frame:CreateTexture(nil, "BORDER")
        tail:SetPoint("TOP", frame, "BOTTOM", -(tailSize / 2), 0) -- places tail about where the old one was
        tail:SetSize(tailSize, tailSize)
        tail:SetColorTexture(0, 0, 0)
        tail:SetVertexOffset(2, tailSize, 0)
        frame._auroraTail = tail

        local name = frame:CreateFontString(nil, "BORDER")
        name:SetPoint("TOPLEFT", 5, 5)
        name:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -5, -5)
        name:SetJustifyH("LEFT")
        name:SetFontObject(font)
        frame._auroraName = name

        frame:HookScript("OnHide", function() frame._auroraUsing = false end)
    end

    local defaultColor = "ffffffff"
    local function UpdateChatBubble(frame, guid, name)
        if not frame._auroraName then styleBubble(frame) end

        if _G.AuroraConfig.chatBubbleNames then
            local color
            if guid ~= nil and guid ~= "" then
                local _, class = _G.GetPlayerInfoByGUID(guid)
                color = _G.CUSTOM_CLASS_COLORS[class].colorStr
            else
                color = defaultColor
            end
            frame._auroraName:SetFormattedText("|c%s%s|r", color, name)
        end
    end

    local frameCache = {}
    local function FindChatBubble(msg)
        for frame, text in next, frameCache do
            if text:GetText() == msg then
                return frame
            end
        end

        for index = 1, _G.WorldFrame:GetNumChildren() do
            local frame = _G.select(index, _G.WorldFrame:GetChildren())
            if frame:IsForbidden() then return end
            if not frame:GetName() and not frame._auroraUsing then
                for i = 1, _G.select("#", frame:GetRegions()) do
                    local region = _G.select(i, frame:GetRegions())
                    if region:GetObjectType() == "FontString" and region:GetText() == msg then
                        frameCache[frame] = region
                        return frame
                    end
                end
            end
        end
    end

    local events = {
        CHAT_MSG_SAY = "chatBubbles",
        CHAT_MSG_YELL = "chatBubbles",
        CHAT_MSG_MONSTER_SAY = "chatBubbles",
        CHAT_MSG_MONSTER_YELL = "chatBubbles",

        CHAT_MSG_PARTY = "chatBubblesParty",
        CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
        CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
    }
    local bubbleHook = _G.CreateFrame("Frame")
    bubbleHook:SetScript("OnEvent", function(self, event, msg, sender, _, _, _, _, _, _, _, _, _, guid)
        if _G.GetCVarBool(events[event]) then
            self.elapsed = 0
            self.msg = msg
            self.sender = _G.Ambiguate(sender, "none") -- Only show realm if it's not yours
            self.guid = guid
            self:Show()
        end
    end)
    bubbleHook:SetScript("OnUpdate", function(self, elapsed)
        self.elapsed = self.elapsed + elapsed
        local frame = FindChatBubble(self.msg)
        if frame or self.elapsed > 0.3 then
            self:Hide()
            if frame then UpdateChatBubble(frame, self.guid, self.sender) end
        end
    end)
    bubbleHook:Hide()
    for event in next, events do
        bubbleHook:RegisterEvent(event)
    end
end
