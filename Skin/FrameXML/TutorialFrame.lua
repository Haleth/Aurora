local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next MAX_TUTORIAL_ALERTS

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\TutorialFrame.lua ]]
    local MAX_TUTORIAL_IMAGES = 3

    local TUTORIALFRAME_TOP_HEIGHT = 80
    local TUTORIALFRAME_MIDDLE_HEIGHT = 10
    local TUTORIALFRAME_BOTTOM_HEIGHT = 30


    local AURORA_TOP_HEIGHT = 50
    local AURORA_MIDDLE_HEIGHT = 10
    local AURORA_BOTTOM_HEIGHT = 20
    local AURORA_WIDTH = 300

    function Hook.TutorialFrame_Update(currentTutorial)
        local frameWidth, frameHeight = _G.TutorialFrame:GetSize()
        frameWidth, frameHeight = _G.Round(frameWidth), _G.Round(frameHeight) -- account for floating point errors
        if not (frameWidth == 1024 and frameHeight == 768) then
            _G.TutorialFrameBackground:Hide()

            -- Deconstruct the tileHeight from frameHeight
            local contentHeight = frameHeight - TUTORIALFRAME_TOP_HEIGHT - TUTORIALFRAME_BOTTOM_HEIGHT
            local tileHeight = contentHeight / TUTORIALFRAME_MIDDLE_HEIGHT


            -- Rebuild using our values.
            local height = AURORA_TOP_HEIGHT + (tileHeight * AURORA_MIDDLE_HEIGHT) + AURORA_BOTTOM_HEIGHT
            _G.TutorialFrame:SetSize(AURORA_WIDTH, height)
        end

        local _, _, _, topLeftX, topLeftY = _G.TutorialFrameTextScrollFrame:GetPoint(1)
        local _, _, _, bottomRightX, bottomRightY = _G.TutorialFrameTextScrollFrame:GetPoint(2)
        if topLeftX and bottomRightX then
            _G.TutorialFrameTextScrollFrame:SetPoint("TOPLEFT", topLeftX - 29, topLeftY + 48)
            _G.TutorialFrameTextScrollFrame:SetPoint("BOTTOMRIGHT", bottomRightX + 25, bottomRightY)
            _G.TutorialFrameText:SetWidth(_G.TutorialFrameTextScrollFrame:GetWidth())
        end


        for i = 1, MAX_TUTORIAL_IMAGES do
            local image = _G["TutorialFrameImage"..i]
            local point, _, _, x, y = image:GetPoint(1)
            if point then
                image:SetPoint(point, x, y + 44)
            end
        end

        for i = 1, #_G.TutorialFrame._auroraMouseTex do
            local image = _G.TutorialFrame._auroraMouseTex[i]
            local point, _, _, x, y = image:GetPoint(1)
            if point then
                image:SetPoint(point, x, y + 44)
                _G.TutorialFrameMouse:SetPoint(point, x, y + 44)
            end
        end
    end

    function Skin.TutorialFrameAlertButtonTemplate(Frame)
        local mask = Frame:CreateMaskTexture(nil, "BORDER")
        mask:SetTexture([[Interface\PetBattles\BattleBar-AbilityBadge-Neutral]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetPoint("CENTER", 3, 3)
        mask:SetSize(56, 56)
        mask:Show()
        Frame:GetNormalTexture():AddMaskTexture(mask)
        Frame:GetHighlightTexture():AddMaskTexture(mask)
    end
end

--do --[[ FrameXML\TutorialFrame.xml ]]
--end

-- /run TutorialFrame_NewTutorial(1, true)
function private.FrameXML.TutorialFrame()
    _G.hooksecurefunc("TutorialFrame_Update", Hook.TutorialFrame_Update)

    -------------------
    -- TutorialFrame --
    -------------------
    Base.SetBackdrop(_G.TutorialFrame)

    local title = _G.TutorialFrameTitle
    title:ClearAllPoints()
    title:SetPoint("TOPLEFT")
    title:SetPoint("BOTTOMRIGHT", _G.TutorialFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    title:SetJustifyH("CENTER")
    title:SetJustifyV("MIDDLE")

    -- BlizzWTF: This should use the UIPanelButtonTemplate
    Skin.UICheckButtonTemplate(_G.TutorialFrameCheckButton)

    for i = 1, MAX_TUTORIAL_ALERTS  do
        Skin.TutorialFrameAlertButtonTemplate(_G["TutorialFrameAlertButton"..i])
    end

    -----------------------------------
    -- TutorialFrameAlertButtonBadge --
    -----------------------------------
    -- Not used
end
