local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook

do --[[ FrameXML\CompactUnitFrame.lua ]]
    function Hook.CompactUnitFrame_UpdateHealthColor(frame)
        if frame:IsForbidden() then return end

        if _G.UnitIsConnected(frame.unit) then
            local opts = frame.optionTable
            if not opts.healthBarColorOverride then
                local _, classToken = _G.UnitClass(frame.unit)
                local classColor = classToken and _G.CUSTOM_CLASS_COLORS[classToken]
                local treatAsPlayer = private.isRetail and _G.UnitTreatAsPlayerForDisplay(frame.unit) or nil
                if (frame.optionTable.allowClassColorsForNPCs or _G.UnitIsPlayer(frame.unit) or treatAsPlayer) and classColor and frame.optionTable.useClassColors then
                    frame.healthBar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
                    if frame.optionTable.colorHealthWithExtendedColors then
                        frame.selectionHighlight:SetVertexColor(classColor.r, classColor.g, classColor.b)
                    end
                end
            end
        end
    end
end

--do --[[ FrameXML\CompactUnitFrame.xml ]]
--end

function private.FrameXML.CompactUnitFrame()
    _G.hooksecurefunc("CompactUnitFrame_UpdateHealthColor", Hook.CompactUnitFrame_UpdateHealthColor)
end
