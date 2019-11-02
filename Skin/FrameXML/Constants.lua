local _, private = ...
local Color = private.Aurora.Color

private.NORMAL_QUEST_DISPLAY = _G.NORMAL_QUEST_DISPLAY:gsub("ff000000", Color.white.colorStr)
private.TRIVIAL_QUEST_DISPLAY = _G.TRIVIAL_QUEST_DISPLAY:gsub("ff000000", Color.grayLight.colorStr)
private.IGNORED_QUEST_DISPLAY = _G.IGNORED_QUEST_DISPLAY:gsub("ff000000", Color.grayLight.colorStr)

private.FRAME_TITLE_HEIGHT = 27

private.AZERITE_COLORS = {
    Color.Create(0.3765, 0.8157, 0.9098),
    Color.Create(0.7098, 0.5019, 0.1725),
}

--function private.FrameXML.Constants()
--end
