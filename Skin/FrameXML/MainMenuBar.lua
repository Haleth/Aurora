local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals floor

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\MainMenuBar.lua ]]
    function Hook.MainMenuTrackingBar_Configure(frame, isOnTop)
        local statusBar = frame.StatusBar
        statusBar:SetHeight(11)
        frame:ClearAllPoints()
        if isOnTop then
            frame:SetPoint("BOTTOM", _G.MainMenuBar, "TOP", 0, 1)
        else
            frame:SetPoint("TOP", _G.MainMenuBar)
        end
    end
end

do --[[ FrameXML\MainMenuBar.xml ]]
    function Skin.MainMenuBarWatchBarTemplate(Frame)
        local StatusBar = Frame.StatusBar
        Base.SetTexture(StatusBar:GetStatusBarTexture(), "gradientUp")
        Base.SetTexture(StatusBar.Underlay, "gradientUp")

        StatusBar.WatchBarTexture0:SetAlpha(0)
        StatusBar.WatchBarTexture1:SetAlpha(0)
        StatusBar.WatchBarTexture2:SetAlpha(0)
        StatusBar.WatchBarTexture3:SetAlpha(0)

        StatusBar.XPBarTexture0:SetAlpha(0)
        StatusBar.XPBarTexture1:SetAlpha(0)
        StatusBar.XPBarTexture2:SetAlpha(0)
        StatusBar.XPBarTexture3:SetAlpha(0)

        do -- set xp divs
            local divWidth = 1024 / 20
            local xpos = divWidth
            for i = 1, 19 do
                local texture = StatusBar:CreateTexture(nil, "ARTWORK")
                texture:SetColorTexture(0, 0, 0)
                texture:SetSize(1, 11)

                texture:SetPoint("LEFT", floor(xpos), 0)
                xpos = xpos + divWidth
            end
        end
    end
end

function private.FrameXML.MainMenuBar()
    if private.disabled.mainmenubar then return end

    _G.MicroButtonAndBagsBar.MicroBagBar:Hide()
    _G.MainMenuBarArtFrameBackground.BackgroundLarge:SetAlpha(0)
    _G.MainMenuBarArtFrameBackground.BackgroundSmall:SetAlpha(0)

    _G.MainMenuBarArtFrame.LeftEndCap:Hide()
    _G.MainMenuBarArtFrame.RightEndCap:Hide()
end
