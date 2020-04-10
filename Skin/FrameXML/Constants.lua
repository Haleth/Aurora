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

local Enum = {}
Enum.ItemQuality = {
    Poor = _G.LE_ITEM_QUALITY_POOR or _G.Enum.ItemQuality.Poor,
    Standard = _G.LE_ITEM_QUALITY_COMMON or _G.Enum.ItemQuality.Standard,
    Good = _G.LE_ITEM_QUALITY_UNCOMMON or _G.Enum.ItemQuality.Good,
    Superior = _G.LE_ITEM_QUALITY_RARE or _G.Enum.ItemQuality.Superior,
    Epic = _G.LE_ITEM_QUALITY_EPIC or _G.Enum.ItemQuality.Epic,
    Legendary = _G.LE_ITEM_QUALITY_LEGENDARY or _G.Enum.ItemQuality.Legendary,
    Artifact = _G.LE_ITEM_QUALITY_ARTIFACT or _G.Enum.ItemQuality.Artifact,
    Heirloom = _G.LE_ITEM_QUALITY_HEIRLOOM or _G.Enum.ItemQuality.Heirloom,
    WoWToken = _G.LE_ITEM_QUALITY_WOW_TOKEN or _G.Enum.ItemQuality.WoWToken,
}
private.Enum = Enum

--function private.FrameXML.Constants()
--end
