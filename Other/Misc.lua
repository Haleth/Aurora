local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

-- A collection of themes too small for there own file
_G.tinsert(C.themes["Aurora"], function()
    local r, g, b = C.r, C.g, C.b

    --[[ FrameXML/UIParent.lua ]]--
    function private.SkinIconArray(baseName, rowSize, numRows)
        for i = 1, rowSize * numRows do
            local bu = _G[baseName..i]
            bu:SetCheckedTexture(C.media.checked)
            select(2, bu:GetRegions()):Hide()

            F.ReskinIcon(_G[baseName..i.."Icon"])
        end
    end
    _G.hooksecurefunc("BuildIconArray", function(parent, baseName, template, rowSize, numRows, onButtonCreated)
        -- This is used to create icons for the GuildBankPopupFrame, MacroPopupFrame, and GearManagerDialogPopup
        private.SkinIconArray(baseName, rowSize, numRows)
    end)

    --[[ FrameXML/AutoComplete.lua ]]--
    F.CreateBD(_G.AutoCompleteBox)

    _G.hooksecurefunc("AutoComplete_Update", function()
        if not _G.AutoCompleteBox._skinned then
            for i = 1, 5 do
                local btn = _G["AutoCompleteButton"..i]

                local hl = btn:GetHighlightTexture()
                hl:SetPoint("TOPLEFT", 1, 0)
                hl:SetPoint("BOTTOM", 0, 0)
                hl:SetPoint("RIGHT", _G.AutoCompleteBox, -1, 0)
                hl:SetColorTexture(r, g, b, .2)
            end
            _G.AutoCompleteBox._skinned = true
        end
    end)

    --[[ FrameXML/HelpFrame.lua ]]--
    F.CreateBD(_G.TicketStatusFrameButton)
end)
