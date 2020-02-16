local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\FloatingChatFrame.lua ]]
    function Hook.FCF_SetWindowColor(frame, r, g, b, doNotSave)
        frame:SetBackdropColor(r, g, b)
        frame:SetBackdropBorderColor(r, g, b)

        frame.buttonFrame:SetBackdropColor(r, g, b)
        frame.buttonFrame:SetBackdropBorderColor(r, g, b)
    end
    function Hook.FCF_SetButtonSide(chatFrame, buttonSide, forceUpdate)
        if buttonSide == "left" then
            chatFrame.buttonFrame:SetPoint("TOPRIGHT", chatFrame.Background, "TOPLEFT", 0, 0)
            chatFrame.buttonFrame:SetPoint("BOTTOMRIGHT", chatFrame.Background, "BOTTOMLEFT", 0, 0)
        elseif buttonSide == "right" then
            chatFrame.buttonFrame:SetPoint("TOPLEFT", chatFrame.Background, "TOPRIGHT", 0, 0)
            chatFrame.buttonFrame:SetPoint("BOTTOMLEFT", chatFrame.Background, "BOTTOMRIGHT", 0, 0)
        end
    end
    function Hook.FCF_CreateMinimizedFrame(chatFrame)
        local minFrame = _G[chatFrame:GetName().."Minimized"]
        Skin.FloatingChatFrameMinimizedTemplate(minFrame)
    end
end

do --[[ FrameXML\FloatingChatFrame.xml ]]
    function Skin.FloatingBorderedFrame(Frame)
        local bg, tl, bl, tr, br, l, r, b, t = Frame:GetRegions()
        Base.CreateBackdrop(Frame, private.backdrop, {
            bg = bg,

            l = l,
            r = r,
            t = t,
            b = b,

            tl = tl,
            tr = tr,
            bl = bl,
            br = br,

            borderLayer = "BACKGROUND",
            borderSublevel = -7,
        })
        Base.SetBackdrop(Frame, Color.frame, 0.3)
    end
    function Skin.ChatTabArtTemplate(Button)
        Button.leftTexture:SetAlpha(0)
        Button.middleTexture:SetAlpha(0)
        Button.rightTexture:SetAlpha(0)

        Button.leftSelectedTexture:SetAlpha(0)
        Button.middleSelectedTexture:SetAlpha(0)
        Button.rightSelectedTexture:SetAlpha(0)

        Button.leftHighlightTexture:SetAlpha(0)
        Button.middleHighlightTexture:SetAlpha(0)
        Button.rightHighlightTexture:SetAlpha(0)
    end
    function Skin.ChatTabTemplate(Button)
        Skin.ChatTabArtTemplate(Button)
        Button:SetHighlightFontObject("GameFontHighlightSmall")
    end
    function Skin.FloatingChatFrameTemplate(ScrollingMessageFrame)
        Skin.FloatingBorderedFrame(ScrollingMessageFrame)
        local buttonFrame = ScrollingMessageFrame.buttonFrame

        if private.isRetail then
            Skin.FloatingBorderedFrame(ScrollingMessageFrame.buttonFrame)

            local minimizeButton = buttonFrame.minimizeButton
            Skin.ChatFrameButton(minimizeButton)
            local bg = minimizeButton:GetBackdropTexture("bg")
            minimizeButton:SetPoint("TOP", buttonFrame, 0, -3)
            local line = minimizeButton:CreateTexture(nil, "ARTWORK")
            line:SetPoint("TOPLEFT", bg, "BOTTOMLEFT", 3, 6)
            line:SetPoint("BOTTOMRIGHT", bg, -3, 3)
            line:SetColorTexture(1, 1, 1)

            local bottomButton = ScrollingMessageFrame.ScrollToBottomButton
            bottomButton:SetPoint("BOTTOMRIGHT", ScrollingMessageFrame.ResizeButton, "TOPRIGHT", -5, 0)
            Skin.ChatFrameButton(bottomButton)
            bg = bottomButton:GetBackdropTexture("bg")
            local arrow = bottomButton:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 3, -3)
            arrow:SetPoint("BOTTOMRIGHT", bg, -3, 5)
            Base.SetTexture(arrow, "arrowDown")

            local bottom = bottomButton:CreateTexture(nil, "ARTWORK")
            bottom:SetPoint("TOPLEFT", bg, "BOTTOMLEFT", 3, 5)
            bottom:SetPoint("BOTTOMRIGHT", bg, -3, 3)
            bottom:SetColorTexture(1, 1, 1)

            Skin.ScrollBarThumb(ScrollingMessageFrame.ScrollBar.ThumbTexture)
        else
            Skin.ChatFrameButton(buttonFrame.downButton)
            local bg = buttonFrame.downButton:GetBackdropTexture("bg")
            local arrow = buttonFrame.downButton:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 5, -8)
            arrow:SetPoint("BOTTOMRIGHT", bg, -5, 8)
            Base.SetTexture(arrow, "arrowDown")

            Skin.ChatFrameButton(buttonFrame.upButton)
            bg = buttonFrame.upButton:GetBackdropTexture("bg")
            arrow = buttonFrame.upButton:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 5, -8)
            arrow:SetPoint("BOTTOMRIGHT", bg, -5, 8)
            Base.SetTexture(arrow, "arrowUp")


            local minimizeButton = buttonFrame.minimizeButton
            Skin.ChatFrameButton(minimizeButton)
            minimizeButton:SetPoint("TOP", ScrollingMessageFrame.buttonFrame, 0, -3)
            local line = minimizeButton:CreateTexture(nil, "ARTWORK")
            line:SetPoint("TOPLEFT", minimizeButton, "BOTTOMLEFT", 3, 6)
            line:SetPoint("BOTTOMRIGHT", -3, 3)
            line:SetColorTexture(1, 1, 1)

            local bottomButton = buttonFrame.bottomButton
            Skin.ChatFrameButton(bottomButton)
            bg = bottomButton:GetBackdropTexture("bg")
            arrow = bottomButton:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 5, -7)
            arrow:SetPoint("BOTTOMRIGHT", bg, -5, 9)
            Base.SetTexture(arrow, "arrowDown")

            local bottom = bottomButton:CreateTexture(nil, "ARTWORK")
            bottom:SetPoint("TOPLEFT", bg, "BOTTOMLEFT", 5, 9)
            bottom:SetPoint("BOTTOMRIGHT", bg, -5, 7)
            bottom:SetColorTexture(1, 1, 1)
        end

        Hook.FCF_SetButtonSide(ScrollingMessageFrame, _G.FCF_GetButtonSide(ScrollingMessageFrame))
        _G.FloatingChatFrame_UpdateBackgroundAnchors(ScrollingMessageFrame)

        Skin.ChatFrameEditBoxTemplate(ScrollingMessageFrame.editBox)
        ScrollingMessageFrame.editBox:SetPoint("TOPLEFT", ScrollingMessageFrame, "BOTTOMLEFT", 0, -5)
        ScrollingMessageFrame.editBox:SetPoint("RIGHT", ScrollingMessageFrame.ScrollBar)
    end
    function Skin.FloatingChatFrameMinimizedTemplate(Button)
        Button:SetSize(172, 23)
        Button.leftTexture:Hide()
        Button.rightTexture:Hide()
        Button.middleTexture:Hide()
        Button.leftHighlightTexture:Hide()
        Button.rightHighlightTexture:Hide()
        Button.middleHighlightTexture:Hide()

        Base.SetBackdrop(Button)
        Base.SetHighlight(Button, "backdrop")

        local MaximizeButton = _G[Button:GetName().."MaximizeButton"]
        MaximizeButton:SetSize(17, 17)
        Skin.ChatFrameButton(MaximizeButton)
        local box1 = MaximizeButton:CreateTexture(nil, "ARTWORK", nil, 0)
        box1:SetPoint("TOPLEFT", 6, -3)
        box1:SetPoint("BOTTOMRIGHT", -3, 6)
        box1:SetColorTexture(Color.gray:GetRGB())

        local box2 = MaximizeButton:CreateTexture(nil, "ARTWORK", nil, 2)
        box2:SetPoint("TOPLEFT", 3, -6)
        box2:SetPoint("BOTTOMRIGHT", -6, 3)
        box2:SetColorTexture(Color.white:GetRGB())
    end

    function Skin.ChatFrameButton(Button, texture)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })


        if texture then
            local bg = Button:GetBackdropTexture("bg")
            local icon = Button:CreateTexture(nil, "ARTWORK")
            icon:SetPoint("TOPLEFT", bg, 3, -3)
            icon:SetPoint("BOTTOMRIGHT", bg, -3, 3)
            icon:SetTexture(texture)
        end
    end
end

function private.FrameXML.FloatingChatFrame()
    if private.disabled.chat then return end

    _G.hooksecurefunc("FCF_SetWindowColor", Hook.FCF_SetWindowColor)
    _G.hooksecurefunc("FCF_SetButtonSide", Hook.FCF_SetButtonSide)
    _G.hooksecurefunc("FCF_CreateMinimizedFrame", Hook.FCF_CreateMinimizedFrame)

    for i = 1, 10 do
        local name = "ChatFrame"..i
        Skin.ChatTabTemplate(_G[name.."Tab"])
        Skin.FloatingChatFrameTemplate(_G[name])
    end

    Skin.ChatFrameButton(_G.ChatFrameMenuButton, [[Interface\GossipFrame\ChatBubbleGossipIcon]])
    Skin.VoiceToggleButtonTemplate(_G.ChatFrameChannelButton)
    if private.isRetail then
        _G.ChatFrameChannelButton:SetPoint("TOP", _G.ChatFrame1ButtonFrame, 0, -3)
        Skin.ToggleVoiceDeafenButtonTemplate(_G.ChatFrameToggleVoiceDeafenButton)
        Skin.ToggleVoiceMuteButtonTemplate(_G.ChatFrameToggleVoiceMuteButton)
    end

    Skin.UIMenuTemplate(_G.ChatMenu)
    Skin.UIMenuTemplate(_G.EmoteMenu)
    Skin.UIMenuTemplate(_G.LanguageMenu)
    Skin.UIMenuTemplate(_G.VoiceMacroMenu)
end
