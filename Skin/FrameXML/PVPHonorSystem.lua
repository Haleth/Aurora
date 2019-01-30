local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals floor

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

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

        local divWidth = bar:GetWidth() / 5
        local xpos = divWidth
        for i = 1, 4 do
            local texture = bar:CreateTexture(nil, "ARTWORK")
            texture:SetColorTexture(Color.button:GetRGB())
            texture:SetSize(1, 17)
            texture:SetPoint("LEFT", xpos, 0)
            xpos = xpos + divWidth
        end

        Frame.NextAvailable.Frame:SetAlpha(0)
        Base.CropIcon(Frame.NextAvailable.Icon, Frame.NextAvailable)
    end
end

function private.FrameXML.PVPHonorSystem()
    _G.hooksecurefunc("PVPHonorXPBar_Update", Hook.PVPHonorXPBar_Update)
end
