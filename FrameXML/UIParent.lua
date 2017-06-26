local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.UIParent()
    function private.SkinIconArray(baseName, rowSize, numRows)
        for i = 1, rowSize * numRows do
            local bu = _G[baseName..i]
            bu:SetCheckedTexture(C.media.checked)
            _G.select(2, bu:GetRegions()):Hide()

            F.ReskinIcon(_G[baseName..i.."Icon"])
        end
    end
    _G.hooksecurefunc("BuildIconArray", function(parent, baseName, template, rowSize, numRows, onButtonCreated)
        -- This is used to create icons for the GuildBankPopupFrame, MacroPopupFrame, and GearManagerDialogPopup
        private.SkinIconArray(baseName, rowSize, numRows)
    end)

    -- Blizzard doesn't create the chat bubbles in lua, so we're calling it here
    if private.FrameXML.ChatBubbles then
        private.FrameXML.ChatBubbles()
    end
end
