local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals floor

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\PVPHonorSystem.lua ]]
    function Hook.PVPHonorXPBar_Update(self)
        self.Bar.Spark:Hide()

        if self.rewardInfo and not self.rewardInfo.texCoords then
            Base.CropIcon(self.NextAvailable.Icon)
        end
    end
end

do --[[ FrameXML\PVPHonorSystem.xml ]]
    function Skin.PVPHonorSystemLargeXPBar(Frame)
        Frame:HookScript("OnEvent", Hook.PVPHonorXPBar_Update)
        Frame:HookScript("OnShow", Hook.PVPHonorXPBar_Update)

        Frame.Frame:Hide()

        local bar = Frame.Bar
        Skin.FrameTypeStatusBar(bar)
        bar.Background:Hide()
        Util.PositionBarTicks(bar, 5)

        Frame.NextAvailable.Frame:SetAlpha(0)
        Base.CropIcon(Frame.NextAvailable.Icon, Frame.NextAvailable)
    end
end

function private.FrameXML.PVPHonorSystem()
    _G.hooksecurefunc("PVPHonorXPBar_Update", Hook.PVPHonorXPBar_Update)
end
