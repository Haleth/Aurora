local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F = _G.unpack(Aurora)

function private.AddOns.Blizzard_GMSurveyUI()
    F.SetBD(_G.GMSurveyFrame, 0, 0, -32, 4)
    F.CreateBD(_G.GMSurveyCommentFrame, .25)
    for i = 1, 11 do
        F.CreateBD(_G["GMSurveyQuestion"..i], .25)
        for j = 0, 5 do
            F.ReskinRadio(_G["GMSurveyQuestion"..i.."RadioButton"..j])
        end
    end

    for i = 1, 12 do
        _G.select(i, _G.GMSurveyFrame:GetRegions()):Hide()
    end
    if private.isRetail then
        Skin.DialogHeaderTemplate(_G.GMSurveyFrame.Header)
    else
        _G.GMSurveyHeaderLeft:Hide()
        _G.GMSurveyHeaderRight:Hide()
        _G.GMSurveyHeaderCenter:Hide()
        _G.GMSurveyHeaderText:ClearAllPoints()
        _G.GMSurveyHeaderText:SetPoint("TOPLEFT")
        _G.GMSurveyHeaderText:SetPoint("BOTTOMRIGHT", _G.GMSurveyFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end

    _G.GMSurveyScrollFrameTop:SetAlpha(0)
    _G.GMSurveyScrollFrameMiddle:SetAlpha(0)
    _G.GMSurveyScrollFrameBottom:SetAlpha(0)
    F.Reskin(_G.GMSurveySubmitButton)
    F.Reskin(_G.GMSurveyCancelButton)
    F.ReskinClose(_G.GMSurveyCloseButton, "TOPRIGHT", _G.GMSurveyFrame, "TOPRIGHT", -36, -4)
    F.ReskinScroll(_G.GMSurveyScrollFrameScrollBar)
end
