local _G = _G

-- Add quality colour for Poor items
_G.LE_ITEM_QUALITY_COMMON = -1
_G.BAG_ITEM_QUALITY_COLORS[_G.LE_ITEM_QUALITY_POOR] = { r = 0.61, g = 0.61, b = 0.61}
-- Change Common from grey to black
_G.BAG_ITEM_QUALITY_COLORS[_G.LE_ITEM_QUALITY_COMMON] = { r = 0, g = 0, b = 0}
_G.BAG_ITEM_QUALITY_COLORS[1] = { r = 0, g = 0, b = 0}

-- Quest gossip text
_G.NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
_G.TRIVIAL_QUEST_DISPLAY = _G.gsub(_G.TRIVIAL_QUEST_DISPLAY, "000000", "ffffff")
_G.IGNORED_QUEST_DISPLAY = _G.gsub(_G.IGNORED_QUEST_DISPLAY, "000000", "ffffff")
