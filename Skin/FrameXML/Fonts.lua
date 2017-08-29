local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local _, C = _G.unpack(Aurora)
local Base = Aurora.Base

function private.FrameXML.Fonts()
    if _G.AuroraConfig.enableFont then
        if _G.LOCALE_koKR then
            C.media.font = [[Fonts/2002.ttf]]
        elseif _G.LOCALE_zhCN then
            C.media.font = [[Fonts/ARKai_T.ttf]]
        elseif _G.LOCALE_zhTW then
            C.media.font = [[Fonts/blei00d.ttf]]
        end

        -- Regular text: replaces FRIZQT__.TTF
        local NORMAL = C.media.normalFont or C.media.font

        -- Chat Font: replaces ARIALN.TTF
        local CHAT   = C.media.chatFont or C.media.font

        -- Crit Font: replaces skurri.ttf
        local CRIT   = C.media.critFont or C.media.font

        -- Header Font: replaces MORPHEUS.ttf
        local HEADER = C.media.headerFont or C.media.font


        _G.STANDARD_TEXT_FONT = NORMAL
        _G.UNIT_NAME_FONT = NORMAL
        _G.NAMEPLATE_FONT = NORMAL
        _G.DAMAGE_TEXT_FONT = NORMAL


        -- FrameXML\Fonts.xml
        Base.SetFont("SystemFont_Outline_Small",       NORMAL, 10, "OUTLINE")
        Base.SetFont("SystemFont_Outline",             NORMAL, 13, "OUTLINE")
        Base.SetFont("SystemFont_InverseShadow_Small", NORMAL, 10, nil, nil, {0.4, 0.4, 0.4, 0.75}, 1, -1)
        Base.SetFont("SystemFont_Huge1",               NORMAL, 20)
        Base.SetFont("SystemFont_Huge1_Outline",       NORMAL, 20, "OUTLINE")
        Base.SetFont("SystemFont_OutlineThick_Huge2",  NORMAL, 22, "THICKOUTLINE")
        Base.SetFont("SystemFont_OutlineThick_Huge4",  NORMAL, 26, "THICKOUTLINE")
        Base.SetFont("SystemFont_OutlineThick_WTF",    NORMAL, 32, "THICKOUTLINE")

        Base.SetFont("NumberFont_GameNormal",            NORMAL, 10, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("NumberFont_OutlineThick_Mono_Small", CHAT, 12, "THICKOUTLINE, MONOCHROME")
        Base.SetFont("NumberFont_Normal_Med",              CHAT, 14)
        Base.SetFont("NumberFont_Outline_Med",             CHAT, 14, "OUTLINE")
        Base.SetFont("NumberFont_Outline_Large",           CHAT, 16, "OUTLINE")
        Base.SetFont("NumberFont_Outline_Huge",            CRIT, 30, "OUTLINE")

        Base.SetFont("Fancy22Font",                  HEADER, 22)
        Base.SetFont("QuestFont_Outline_Huge",       HEADER, 18, "OUTLINE")
        Base.SetFont("QuestFont_Super_Huge",         HEADER, 24, nil, {1, 0.82, 0})
        Base.SetFont("QuestFont_Super_Huge_Outline", HEADER, 24, "OUTLINE", {1, 0.82, 0})
        Base.SetFont("SplashHeaderFont",             HEADER, 24, nil, {1, 0.82, 0}, {0, 0, 0}, 1, -2)

        Base.SetFont("Game11Font", NORMAL, 11)
        Base.SetFont("Game12Font", NORMAL, 12)
        Base.SetFont("Game13Font", NORMAL, 13)
        Base.SetFont("Game13FontShadow", NORMAL, 13, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("Game15Font", NORMAL, 15)
        Base.SetFont("Game18Font", NORMAL, 18)
        Base.SetFont("Game20Font", NORMAL, 20)
        Base.SetFont("Game24Font", NORMAL, 24)
        Base.SetFont("Game27Font", NORMAL, 27)
        Base.SetFont("Game30Font", NORMAL, 30)
        Base.SetFont("Game32Font", NORMAL, 32)
        Base.SetFont("Game36Font", NORMAL, 36)
        Base.SetFont("Game48Font", NORMAL, 48)
        Base.SetFont("Game48FontShadow", NORMAL, 48, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("Game60Font", NORMAL, 60)
        Base.SetFont("Game72Font", NORMAL, 72)

        Base.SetFont("Game11Font_ol", NORMAL, 11, "OUTLINE")
        Base.SetFont("Game12Font_ol", NORMAL, 12, "OUTLINE")
        Base.SetFont("Game13Font_ol", NORMAL, 13, "OUTLINE")
        Base.SetFont("Game15Font_ol", NORMAL, 15, "OUTLINE")

        Base.SetFont("QuestFont_Enormous",     HEADER, 30, nil, {1, 0.82, 0})
        Base.SetFont("DestinyFontLarge",       HEADER, 18, nil, {0.1, 0.1, 0.1})
        Base.SetFont("CoreAbilityFont",        HEADER, 32, nil, {0.1, 0.1, 0.1})
        Base.SetFont("DestinyFontHuge",        HEADER, 32, nil, {0.1, 0.1, 0.1})
        Base.SetFont("QuestFont_Shadow_Small", HEADER, 14, nil, nil, {0.49, 0.35, 0.05}, 1, -1)

        Base.SetFont("MailFont_Large",    HEADER, 15)
        Base.SetFont("SpellFont_Small",   NORMAL, 10)
        Base.SetFont("InvoiceFont_Med",   NORMAL, 12)
        Base.SetFont("InvoiceFont_Small", NORMAL, 10)
        Base.SetFont("Tooltip_Med",       NORMAL, 12)
        Base.SetFont("Tooltip_Small",     NORMAL, 10)

        Base.SetFont("AchievementFont_Small", NORMAL, 12)
        Base.SetFont("ReputationDetailFont",  NORMAL, 10, nil, {1, 1, 1}, {0, 0, 0}, 1, -1)
        Base.SetFont("FriendsFont_Normal",    NORMAL, 12, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("FriendsFont_Small",     NORMAL, 10, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("FriendsFont_Large",     NORMAL, 14, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("FriendsFont_UserText",  NORMAL, 11, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("GameFont_Gigantic",     NORMAL, 32, nil, {1, 0.82, 0}, {0, 0, 0}, 1, -1)

        Base.SetFont("ChatBubbleFont", NORMAL, 13)
        Base.SetFont("Fancy16Font",    HEADER, 16)
        Base.SetFont("Fancy18Font",    HEADER, 18)
        Base.SetFont("Fancy20Font",    HEADER, 20)
        Base.SetFont("Fancy24Font",    HEADER, 24)
        Base.SetFont("Fancy27Font",    HEADER, 27)
        Base.SetFont("Fancy30Font",    HEADER, 30)
        Base.SetFont("Fancy32Font",    HEADER, 32)
        Base.SetFont("Fancy48Font",    HEADER, 48)

        Base.SetFont("SystemFont_NamePlateFixed",      NORMAL, 14)
        Base.SetFont("SystemFont_LargeNamePlateFixed", NORMAL, 20)
        Base.SetFont("SystemFont_NamePlate",           NORMAL, 9)
        Base.SetFont("SystemFont_LargeNamePlate",      NORMAL, 12)
        Base.SetFont("SystemFont_NamePlateCastBar",    NORMAL, 10)

        -- FrameXML\FontStyles.xml

        -- SharedXML\SharedFonts.xml
        Base.SetFont("SystemFont_Tiny2",                NORMAL, 8)
        Base.SetFont("SystemFont_Tiny",                 NORMAL, 9)
        Base.SetFont("SystemFont_Shadow_Small",         NORMAL, 10, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Small",                NORMAL, 10)
        Base.SetFont("SystemFont_Small2",               NORMAL, 11)
        Base.SetFont("SystemFont_Shadow_Small2",        NORMAL, 11, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Shadow_Med1_Outline",  NORMAL, 12, "OUTLINE", nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Shadow_Med1",          NORMAL, 12, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Med2",                 NORMAL, 13)
        Base.SetFont("SystemFont_Med3",                 NORMAL, 14)
        Base.SetFont("SystemFont_Shadow_Med3",          NORMAL, 14, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("QuestFont_Large",                 HEADER, 15)
        Base.SetFont("QuestFont_Huge",                  HEADER, 18)
        Base.SetFont("SystemFont_Large",                NORMAL, 16)
        Base.SetFont("SystemFont_Shadow_Large_Outline", NORMAL, 16, "OUTLINE", nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Shadow_Med2",          NORMAL, 14, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Shadow_Large",         NORMAL, 16, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Shadow_Large2",        NORMAL, 18, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Shadow_Huge1",         NORMAL, 20, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Huge2",                NORMAL, 24)
        Base.SetFont("SystemFont_Shadow_Huge2",         NORMAL, 24, "OUTLINE", nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Shadow_Huge3",         NORMAL, 25, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Shadow_Outline_Huge3", NORMAL, 25, "OUTLINE", nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_World",                NORMAL, 64, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_World_ThickOutline",   NORMAL, 64, "THICKOUTLINE", nil, {0, 0, 0}, 1, -1)
        Base.SetFont("SystemFont_Shadow_Outline_Huge2", NORMAL, 22, "OUTLINE", nil, {0, 0, 0}, 2, -2)
        Base.SetFont("SystemFont_Med1",                 NORMAL, 12)
        Base.SetFont("SystemFont_WTF2",                 NORMAL, 36)
        Base.SetFont("SystemFont_Outline_WTF2",         NORMAL, 36, "OUTLINE")
        Base.SetFont("GameTooltipHeader",               NORMAL, 14)
        Base.SetFont("System_IME",                      NORMAL, 16)
        Base.SetFont("NumberFont_Shadow_Small",         CHAT, 12, nil, nil, {0, 0, 0}, 1, -1)
        Base.SetFont("NumberFont_Shadow_Med",           CHAT, 14, nil, nil, {0, 0, 0}, 1, -1)

        -- This uses GameFontNormal, which inherits from SystemFont_Shadow_Med1,
        -- but for some reason the above changes do not propagate to it.
        Base.SetFont(_G.WorldMapFrame.NavBar.home.text, NORMAL, 12, nil, {1, 0.82, 0}, {0, 0, 0}, 1, -1)
    end

    _G.QuestFont:SetTextColor(1, 1, 1)
    _G.GameFontBlackMedium:SetTextColor(1, 1, 1)
    _G.MailFont_Large:SetTextColor(1, 1, 1)
    _G.MailFont_Large:SetShadowColor(0, 0, 0)
    _G.MailFont_Large:SetShadowOffset(1, -1)
    _G.AvailableServicesText:SetTextColor(1, 1, 1)
    _G.AvailableServicesText:SetShadowColor(0, 0, 0)
    _G.CoreAbilityFont:SetTextColor(1, 1, 1)
end
