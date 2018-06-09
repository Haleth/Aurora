local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--[[do  FrameXML\FloatingChatFrame.lua
end ]]

do --[[ FrameXML\FloatingChatFrame.xml ]]
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
end

function private.FrameXML.FloatingChatFrame()
    Base.SetBackdrop(_G.ChatMenu)
    Base.SetBackdrop(_G.EmoteMenu)
    Base.SetBackdrop(_G.LanguageMenu)
    Base.SetBackdrop(_G.VoiceMacroMenu)
end
