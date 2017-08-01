local _, private = ...

private.PORTRAIT_TITLE_HEIGHT = 23

function private.FrameXML.Constants()
    -- Quest gossip text
    _G.AURORA_NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
    _G.AURORA_TRIVIAL_QUEST_DISPLAY = _G.TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")
end
