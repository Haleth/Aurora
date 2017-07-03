local ADDON_NAME, private = ...

-- [[ Lua Globals ]]
local select = _G.select
local next = _G.next

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local Aurora = private.Aurora

-- for custom APIs (see docs online)
local LATEST_API_VERSION = "7.0"

-- see F.AddPlugin
local AURORA_LOADED = false
local AuroraConfig

local F, C = _G.unpack(Aurora)

-- [[ Constants and settings ]]

C.classicons = { -- adjusted for borderless icons
	["WARRIOR"]     = {0.01953125, 0.234375, 0.01953125, 0.234375},
	["MAGE"]        = {0.26953125, 0.48046875, 0.01953125, 0.234375},
	["ROGUE"]       = {0.515625, 0.7265625, 0.01953125, 0.234375},
	["DRUID"]       = {0.76171875, 0.97265625, 0.01953125, 0.234375},
	["HUNTER"]      = {0.01953125, 0.234375, 0.26953125, 0.484375},
	["SHAMAN"]      = {0.26953125, 0.48046875, 0.26953125, 0.484375},
	["PRIEST"]      = {0.515625, 0.7265625, 0.26953125, 0.484375},
	["WARLOCK"]     = {0.76171875, 0.97265625, 0.26953125, 0.484375},
	["PALADIN"]     = {0.01953125, 0.234375, 0.51953125, 0.734375},
	["DEATHKNIGHT"] = {0.26953125, 0.48046875, 0.51953125, 0.734375},
	["MONK"]        = {0.515625, 0.7265625, 0.51953125, 0.734375},
	["DEMONHUNTER"] = {0.76171875, 0.97265625, 0.51953125, 0.734375},
}

C.media = {
	["arrowUp"] = "Interface\\AddOns\\Aurora\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\Aurora\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\Aurora\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\Aurora\\media\\arrow-right-active",
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["checked"] = "Interface\\AddOns\\Aurora\\media\\CheckButtonHilight",
	["font"] = "Interface\\AddOns\\Aurora\\media\\font.ttf",
	["gradient"] = "Interface\\AddOns\\Aurora\\media\\gradient",
	["roleIcons"] = "Interface\\Addons\\Aurora\\media\\UI-LFG-ICON-ROLES",
}

C.defaults = {
	["acknowledgedSplashScreen"] = false,

	["alpha"] = 0.5,
	["bags"] = true,
	["buttonGradientColour"] = {.3, .3, .3, .3},
	["buttonSolidColour"] = {.2, .2, .2, 1},
	["useButtonGradientColour"] = true,
	["chatBubbles"] = true,
		["chatBubbleNames"] = true,
	["enableFont"] = true,
	["loot"] = true,
	["useCustomColour"] = false,
		["customColour"] = {r = 1, g = 1, b = 1},
    ["customClassColors"] = false,
	["tooltips"] = true,
}

C.backdrop = {
	bgFile = C.media.backdrop,
	edgeFile = C.media.backdrop,
	edgeSize = 1,
}

C.frames = {}

-- [[ Cached variables ]]

local useButtonGradientColour
local _, class = _G.UnitClass("player")
local red, green, blue

-- [[ Functions ]]

F.dummy = function() end

F.CreateBD = function(f, a)
	f:SetBackdrop(C.backdrop)
	f:SetBackdropColor(0, 0, 0, a or AuroraConfig.alpha)
	f:SetBackdropBorderColor(0, 0, 0)
	if not a then _G.tinsert(C.frames, f) end
end

F.CreateBG = function(frame)
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", frame, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

-- we assign these after loading variables for caching
-- otherwise we call an extra _G.unpack() every time
local buttonR, buttonG, buttonB, buttonA

F.CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(useButtonGradientColour and C.media.gradient or C.media.backdrop)
	tex:SetVertexColor(buttonR, buttonG, buttonB, buttonA)

	return tex
end

local function colourButton(f)
	if not f:IsEnabled() then return end

	if useButtonGradientColour then
		f:SetBackdropColor(red, green, blue, .3)
	else
		f._auroraTex:SetVertexColor(red / 4, green / 4, blue / 4)
	end

	f:SetBackdropBorderColor(red, green, blue)
end

local function clearButton(f)
	if useButtonGradientColour then
		f:SetBackdropColor(0, 0, 0, 0)
	else
		f._auroraTex:SetVertexColor(buttonR, buttonG, buttonB, buttonA)
	end

	f:SetBackdropBorderColor(0, 0, 0)
end

F.Reskin = function(f, noHighlight)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	F.CreateBD(f, .0)

	f._auroraTex = F.CreateGradient(f)

	if not noHighlight then
		f:HookScript("OnEnter", colourButton)
		f:HookScript("OnLeave", clearButton)
	end
end

F.ReskinTab = function(f, numTabs)
	if numTabs then
		for i = 1, numTabs do
			for j = 1, 6 do
				select(j, _G[f..i]:GetRegions()):Hide()
				select(j, _G[f..i]:GetRegions()).Show = F.dummy
			end
		end
	else
		f:DisableDrawLayer("BACKGROUND")

		local bg = CreateFrame("Frame", nil, f)
		bg:SetPoint("TOPLEFT", 8, -3)
		bg:SetPoint("BOTTOMRIGHT", -8, 0)
		bg:SetFrameLevel(f:GetFrameLevel()-1)
		F.CreateBD(bg)

		f:SetHighlightTexture(C.media.backdrop)
		local hl = f:GetHighlightTexture()
		hl:SetPoint("TOPLEFT", 9, -4)
		hl:SetPoint("BOTTOMRIGHT", -9, 1)
		hl:SetVertexColor(red, green, blue, .25)
	end
end

F.ReskinScroll = function(f, parent)
	local frame = f:GetName()

	local track = (f.trackBG or f.Background) or (_G[frame.."Track"] or _G[frame.."BG"])
	if track then track:Hide() end
	local top = (f.ScrollBarTop or f.Top) or _G[frame.."Top"]
	if top then top:Hide() end
	local middle = (f.ScrollBarMiddle or f.Middle) or _G[frame.."Middle"]
	if middle then middle:Hide() end
	local bottom = (f.ScrollBarBottom or f.Bottom) or _G[frame.."Bottom"]
	if bottom then bottom:Hide() end

	local bu = (f.ThumbTexture or f.thumbTexture) or _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	F.CreateBD(bu.bg, 0)

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", bu.bg, 1, -1)
	tex:SetPoint("BOTTOMRIGHT", bu.bg, -1, 1)

	local up = (f.ScrollUpButton or f.UpButton) or _G[(frame or parent).."ScrollUpButton"]
	local down = (f.ScrollDownButton or f.DownButton) or _G[(frame or parent).."ScrollDownButton"]

	F.ReskinArrow(up, "Up")
	F.ReskinArrow(down, "Down")
	up:SetSize(17, 17)
	down:SetSize(17, 17)
end

F.ReskinDropDown = function(f, borderless)
	local frame = f:GetName()

	local button = f.Button or _G[frame.."Button"]
	F.ReskinArrow(button, "Down")
	button:ClearAllPoints()

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", 1, 0)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg, 0)

	local gradient = F.CreateGradient(f)
	gradient:SetPoint("TOPLEFT", bg, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bg, -1, 1)

	if borderless then
		button:SetPoint("TOPRIGHT", 0, -6)
		bg:SetPoint("TOPLEFT", 0, -6)
	else
		local left = _G[frame.."Left"]
		local middle = _G[frame.."Middle"]
		local right = _G[frame.."Right"]

		left:SetAlpha(0)
		middle:SetAlpha(0)
		right:SetAlpha(0)

		button:SetPoint("TOPRIGHT", right, -19, -21)
		bg:SetPoint("TOPLEFT", 20, -4)
	end
end

local function colourClose(f)
	if f:IsEnabled() then
		for _, pixel in next, f.pixels do
			pixel:SetColorTexture(red, green, blue)
		end
	end
end

local function clearClose(f)
	for _, pixel in next, f.pixels do
		pixel:SetColorTexture(1, 1, 1)
	end
end

F.ReskinClose = function(f, a1, p, a2, x, y)
	f:SetSize(17, 17)

	if not a1 then
		f:SetPoint("TOPRIGHT", -6, -6)
	else
		f:ClearAllPoints()
		f:SetPoint(a1, p, a2, x, y)
	end

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	F.CreateBD(f, 0)

	F.CreateGradient(f)

	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	f.pixels = {}

	local lineOfs = 2.5
	for i = 1, 2 do
		local line = f:CreateLine()
		line:SetColorTexture(1, 1, 1)
		line:SetThickness(0.5)
		if i == 1 then
			line:SetStartPoint("TOPLEFT", lineOfs, -lineOfs)
			line:SetEndPoint("BOTTOMRIGHT", -lineOfs, lineOfs)
		else
			line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
			line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
		end
		_G.tinsert(f.pixels, line)
	end

	f:HookScript("OnEnter", colourClose)
	f:HookScript("OnLeave", clearClose)
end

F.ReskinInput = function(f, height, width)
	local frame = f:GetName()

	local left = f.Left or _G[frame.."Left"]
	local middle = f.Middle or _G[frame.."Middle"] or _G[frame.."Mid"]
	local right = f.Right or _G[frame.."Right"]

	left:Hide()
	middle:Hide()
	right:Hide()

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local gradient = F.CreateGradient(f)
	gradient:SetPoint("TOPLEFT", bd, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bd, -1, 1)

	if height then f:SetHeight(height) end
	if width then f:SetWidth(width) end
end

local money = {"gold", "silver", "copper"}
F.ReskinMoneyInput = function(f)
	for i = 1, #money do
		local input = f[money[i]]
		F.ReskinInput(input)
		if i > 1 then
			input:SetPoint("LEFT", f[money[i - 1]], "RIGHT", 6, 0)
			input:SetWidth(35)
			input.texture:SetPoint("RIGHT", -4, 0)
		end
	end
end

local function colourArrow(f)
	if f:IsEnabled() then
		f._auroraArrow:SetVertexColor(red, green, blue)
	end
end

local function clearArrow(f)
	f._auroraArrow:SetVertexColor(1, 1, 1)
end

F.colourArrow = colourArrow
F.clearArrow = clearArrow

F.CreateArrow = function(f, direction)
	local tex = f:CreateTexture(nil, "ARTWORK", nil, 7)
	tex:SetTexture(C.media["arrow"..direction])
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	f._auroraArrow = tex

	f:HookScript("OnEnter", colourArrow)
	f:HookScript("OnLeave", clearArrow)
end
F.ReskinArrow = function(f, direction)
	f:SetSize(18, 18)
	F.Reskin(f, true)

	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	F.CreateArrow(f, direction)
end

F.ReskinCheck = function(f, isTriState)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(C.media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(red, green, blue, .2)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", 5, -5)
	tex:SetPoint("BOTTOMRIGHT", -5, 5)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(red, green, blue)

	if isTriState then
		function f:SetTriState(state)
			if ( not state or state == 0 ) then
				-- nil or 0 means not checked
				self:SetChecked(false)
			else
				ch:SetDesaturated(true)
				self:SetChecked(true)
				if ( state == 2 ) then
					-- 2 is a normal check
					ch:SetVertexColor(red, green, blue)
				else
					-- 1 is a dark check
					ch:SetVertexColor(red * 0.5, green * 0.5, blue * 0.5)
				end
			end
		end
	end
end

local function colourRadio(f)
	f.bd:SetBackdropBorderColor(red, green, blue)
end

local function clearRadio(f)
	f.bd:SetBackdropBorderColor(0, 0, 0)
end

F.ReskinRadio = function(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetCheckedTexture(C.media.backdrop)

	local ch = f:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(red, green, blue, .6)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 3, -3)
	bd:SetPoint("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)
	f.bd = bd

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", 4, -4)
	tex:SetPoint("BOTTOMRIGHT", -4, 4)

	f:HookScript("OnEnter", colourRadio)
	f:HookScript("OnLeave", clearRadio)
end

F.ReskinSlider = function(f, isVert)
	f:SetBackdrop(nil)
	f.SetBackdrop = F.dummy

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 14, -2)
	bd:SetPoint("BOTTOMRIGHT", -15, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	F.CreateGradient(bd)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	if isVert then
		slider:SetTexCoord(1,0, 0,0, 1,1, 0,1)
	end
	slider:SetBlendMode("ADD")
end

local function colourExpandOrCollapse(f)
	if f:IsEnabled() then
		f._auroraBG.plus:SetVertexColor(red, green, blue)
		f._auroraBG.minus:SetVertexColor(red, green, blue)
	end
end

local function clearExpandOrCollapse(f)
	f._auroraBG.plus:SetVertexColor(1, 1, 1)
	f._auroraBG.minus:SetVertexColor(1, 1, 1)
end

F.colourExpandOrCollapse = colourExpandOrCollapse
F.clearExpandOrCollapse = clearExpandOrCollapse

local function Hook_SetNormalTexture(self, texture)
	if self.settingTexture then return end
	self.settingTexture = true
	self:SetNormalTexture("")

	if texture and texture ~= "" then
		if texture:find("Plus") then
			self._auroraBG.plus:Show()
		elseif texture:find("Minus") then
			self._auroraBG.plus:Hide()
		end
		self._auroraBG:Show()
	else
		self._auroraBG:Hide()
	end
	self.settingTexture = nil
end

F.ReskinExpandOrCollapse = function(f)
	f:SetHighlightTexture("")
	f:SetPushedTexture("")

	local bg = CreateFrame("Frame", nil, f)
	F.CreateBD(bg, .0)
	F.CreateGradient(bg)
	bg:SetSize(13, 13)
	bg:SetPoint("TOPLEFT", f:GetNormalTexture(), 0, -2)
	f._auroraBG = bg

	_G.hooksecurefunc(f, "SetNormalTexture", Hook_SetNormalTexture)

	bg.minus = bg:CreateTexture(nil, "OVERLAY")
	bg.minus:SetSize(7, 1)
	bg.minus:SetPoint("CENTER")
	bg.minus:SetTexture(C.media.backdrop)
	bg.minus:SetVertexColor(1, 1, 1)

	bg.plus = bg:CreateTexture(nil, "OVERLAY")
	bg.plus:SetSize(1, 7)
	bg.plus:SetPoint("CENTER")
	bg.plus:SetTexture(C.media.backdrop)
	bg.plus:SetVertexColor(1, 1, 1)

	f:HookScript("OnEnter", colourExpandOrCollapse)
	f:HookScript("OnLeave", clearExpandOrCollapse)
end

F.SetBD = function(f, x, y, x2, y2)
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg)
end

F.ReskinPortraitFrame = function(f, isButtonFrame)
	local name = f:GetName()

	f.Bg:SetAlpha(0)
	_G[name.."TitleBg"]:SetAlpha(0)
	f.portrait:SetAlpha(0)
	_G[name.."PortraitFrame"]:SetAlpha(0)
	_G[name.."TopRightCorner"]:SetAlpha(0)
	f.topLeftCorner:SetAlpha(0)
	f.topBorderBar:SetAlpha(0)
	f.TopTileStreaks:SetTexture("")
	_G[name.."BotLeftCorner"]:SetAlpha(0)
	_G[name.."BotRightCorner"]:SetAlpha(0)
	_G[name.."BottomBorder"]:SetAlpha(0)
	_G[name.."LeftBorder"]:SetAlpha(0)
	_G[name.."RightBorder"]:SetAlpha(0)

	F.ReskinClose(f.CloseButton)
	f.portrait.Show = F.dummy

	if isButtonFrame then
		_G[name.."BtnCornerLeft"]:SetTexture("")
		_G[name.."BtnCornerRight"]:SetTexture("")
		_G[name.."ButtonBottomBorder"]:SetTexture("")

		f.Inset.Bg:SetAlpha(0)
		f.Inset:DisableDrawLayer("BORDER")
	end

	F.CreateBD(f)
end

F.CreateBDFrame = function(f, a, left, right, top, bottom)
	local frame
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	else
		frame = f
	end

	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", f, left or -1, top or 1)
	bg:SetPoint("BOTTOMRIGHT", f, right or 1, bottom or -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	F.CreateBD(bg, a or .5)

	return bg
end

F.ReskinColourSwatch = function(f)
	local name = f:GetName()

	local bg = _G[name.."SwatchBg"]

	f:SetNormalTexture(C.media.backdrop)
	local nt = f:GetNormalTexture()

	nt:SetPoint("TOPLEFT", 3, -3)
	nt:SetPoint("BOTTOMRIGHT", -3, 3)

	bg:SetColorTexture(0, 0, 0)
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
end

F.ReskinStretchButton = function(f)
	f.TopLeft:Hide()
	f.TopRight:Hide()
	f.BottomLeft:Hide()
	f.BottomRight:Hide()
	f.TopMiddle:Hide()
	f.MiddleLeft:Hide()
	f.MiddleRight:Hide()
	f.BottomMiddle:Hide()
	f.MiddleMiddle:Hide()

	F.Reskin(f)
end

F.ReskinFilterButton = function(f, direction)
	F.ReskinStretchButton(f)

	direction = direction or "Right"
	f.Icon:SetTexture(C.media["arrow"..direction])

	f.Icon:SetPoint("RIGHT", f, "RIGHT", -5, 0)
	f.Icon:SetSize(8, 8)
end

F.ReskinNavBar = function(f)
	local overflowButton = f.overflowButton

	f:GetRegions():Hide()
	f:DisableDrawLayer("BORDER")
	f.overlay:Hide()
	f.homeButton:GetRegions():Hide()

	F.Reskin(f.homeButton)
	F.Reskin(overflowButton, true)
	F.CreateArrow(overflowButton, "Left")
end

F.ReskinGarrisonPortrait = function(portrait, isTroop)
	portrait:SetSize(portrait.Portrait:GetSize())
	F.CreateBD(portrait, 1)

	portrait.Portrait:ClearAllPoints()
	portrait.Portrait:SetPoint("TOPLEFT")

	portrait.PortraitRing:Hide()
	portrait.PortraitRingQuality:SetTexture("")
	portrait.PortraitRingCover:SetTexture("")
	portrait.LevelBorder:SetAlpha(0)

	if not isTroop then
		local lvlBG = portrait:CreateTexture(nil, "BORDER")
		lvlBG:SetColorTexture(0, 0, 0, 0.5)
		lvlBG:SetPoint("TOPLEFT", portrait, "BOTTOMLEFT", 1, 12)
		lvlBG:SetPoint("BOTTOMRIGHT", portrait, -1, 1)

		local level = portrait.Level
		level:ClearAllPoints()
		level:SetPoint("CENTER", lvlBG)
	end
end

F.ReskinIcon = function(icon)
	icon:SetTexCoord(.08, .92, .08, .92)
	return F.CreateBDFrame(icon)
end

local getBackdrop = function()
	return C.backdrop
end
local getBackdropColor = function()
	return 0, 0, 0, .6
end
local getBackdropBorderColor = function()
	return 0, 0, 0
end
F.ReskinTooltip = function(f)
	f:SetBackdrop(nil)

	local bg
	if f.BackdropFrame then
		bg = f.BackdropFrame
	else
		bg = _G.CreateFrame("Frame", nil, f)
		bg:SetFrameLevel(f:GetFrameLevel()-1)
	end
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("BOTTOMRIGHT")
	F.CreateBD(bg, .6)

	f.GetBackdrop = getBackdrop
	f.GetBackdropColor = getBackdropColor
	f.GetBackdropBorderColor = getBackdropBorderColor
end

F.ReskinItemFrame = function(frame)
	local icon = frame.Icon
	frame._auroraBG = F.ReskinIcon(icon)

	local nameFrame = frame.NameFrame
	nameFrame:SetAlpha(0)

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOP", icon, 0, 1)
	bg:SetPoint("BOTTOM", icon, 0, -1)
	bg:SetPoint("LEFT", icon, "RIGHT", 2, 0)
	bg:SetPoint("RIGHT", nameFrame, -4, 0)
	F.CreateBD(bg, .2)
	frame._auroraNameBG = bg
end

-- [[ Variable and module handling ]]

C.themes = {}
C.themes["Aurora"] = {}

-- use of this function ensures that Aurora and custom style (if used) are properly initialised
-- prior to loading third party plugins
F.AddPlugin = function(func)
	if AURORA_LOADED then
		func()
	else
		_G.tinsert(C.themes["Aurora"], func)
	end
end

-- [[ Initialize addon ]]

local SetSkin = CreateFrame("Frame", nil, _G.UIParent)
SetSkin:RegisterEvent("ADDON_LOADED")
SetSkin:SetScript("OnEvent", function(self, event, addon)
	if addon == ADDON_NAME then
		-- [[ Load Variables ]]
		_G.AuroraConfig = _G.AuroraConfig or {}
		AuroraConfig = _G.AuroraConfig

		-- remove deprecated or corrupt variables
		for key, value in next, AuroraConfig do
			if C.defaults[key] == nil then
				AuroraConfig[key] = nil
			end
		end

		-- load or init variables
		for key, value in next, C.defaults do
			if AuroraConfig[key] == nil then
				if _G.type(value) == "table" then
					AuroraConfig[key] = {}
					for k, v in next, value do
						AuroraConfig[key][k] = value[k]
					end
				else
					AuroraConfig[key] = value
				end
			end
		end

		-- [[ Custom style support ]]
		local customStyle = _G.AURORA_CUSTOM_STYLE
		if customStyle and customStyle.apiVersion ~= nil and customStyle.apiVersion == LATEST_API_VERSION then
			local protectedFunctions = {
				["AddPlugin"] = true,
			}

			-- override settings
			if customStyle.defaults then
				for setting, value in next, customStyle.defaults do
					AuroraConfig[setting] = value
				end
			end

			-- replace functions
			if customStyle.functions then
				for funcName, func in next, customStyle.functions do
					if F[funcName] and not protectedFunctions[funcName] then
						F[funcName] = func
					end
				end
			end
		end

        -- setup class colours
        if not AuroraConfig.customClassColors then
            local customClassColors = {}
            private.classColorsReset(customClassColors)
            AuroraConfig.customClassColors = customClassColors
        end

        function private.classColorsInit()
            local classColors = customStyle.classcolors or AuroraConfig.customClassColors
            for classToken, color in next, classColors do
                _G.CUSTOM_CLASS_COLORS[classToken] = {
                    r = color.r,
                    g = color.g,
                    b = color.b,
                    colorStr = ("ff%02x%02x%02x"):format(color.r * 255, color.g * 255, color.b * 255)
                }
            end

            if AuroraConfig.useCustomColour then
                red, green, blue = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b
            else
                red, green, blue = _G.CUSTOM_CLASS_COLORS[class].r, _G.CUSTOM_CLASS_COLORS[class].g, _G.CUSTOM_CLASS_COLORS[class].b
            end
            -- for modules
            C.r, C.g, C.b = red, green, blue
        end
        function private.classColorsHaveChanged()
            for i = 1, #_G.CLASS_SORT_ORDER do
                local classToken = _G.CLASS_SORT_ORDER[i]
                local color = _G.CUSTOM_CLASS_COLORS[classToken]
                local cache = AuroraConfig.customClassColors[classToken]

                if cache.r ~= color.r or cache.g ~= color.g or cache.b ~= color.b then
                    --print("Change found in", classToken)
                    color.r = cache.r
                    color.g = cache.g
                    color.b = cache.b
                    color.colorStr = cache.colorStr

                    return true
                end
            end
        end

		useButtonGradientColour = AuroraConfig.useButtonGradientColour

		if useButtonGradientColour then
			buttonR, buttonG, buttonB, buttonA = _G.unpack(AuroraConfig.buttonGradientColour)
		else
			buttonR, buttonG, buttonB, buttonA = _G.unpack(AuroraConfig.buttonSolidColour)
		end

		-- [[ Splash screen for first time users ]]

		if not AuroraConfig.acknowledgedSplashScreen then
			_G.AuroraSplashScreen:Show()
		end

		-- [[ Load FrameXML ]]
		for i = 1, #private.FrameXML do
			local file, isShared = _G.strsplit(".", private.FrameXML[i])
			local fileList = private.FrameXML
			if isShared then
				file = isShared
				fileList = private.SharedXML
			end
			if fileList[file] then
				fileList[file]()
			end
		end

		-- from this point, plugins added with F.AddPlugin are executed directly instead of cached
		AURORA_LOADED = true
	end

	-- [[ Load modules ]]

	-- check if the addon loaded is supported by Aurora, and if it is, execute its module
	local addonModule = private.AddOns[addon] or C.themes[addon]
	if addonModule then
		if _G.type(addonModule) == "function" then
			addonModule()
		else
			for _, moduleFunc in next, addonModule do
				moduleFunc()
			end
		end
	end

	-- all this should be moved out of the main file when I have time
	if addon == "Aurora" then

		--[[ Dropdown lists ]]

		hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
			for i = 1, _G.UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G["DropDownList"..i.."MenuBackdrop"]
				local backdrop = _G["DropDownList"..i.."Backdrop"]
				if not backdrop.reskinned then
					F.CreateBD(menu)
					F.CreateBD(backdrop)
					backdrop.reskinned = true
				end
			end
		end)

		local createBackdrop = function(parent, texture)
			local bg = parent:CreateTexture(nil, "BACKGROUND")
			bg:SetColorTexture(0, 0, 0, .5)
			bg:SetPoint("CENTER", texture)
			bg:SetSize(12, 12)
			parent.bg = bg

			local left = parent:CreateTexture(nil, "BACKGROUND")
			left:SetWidth(1)
			left:SetColorTexture(0, 0, 0)
			left:SetPoint("TOPLEFT", bg)
			left:SetPoint("BOTTOMLEFT", bg)
			parent.left = left

			local right = parent:CreateTexture(nil, "BACKGROUND")
			right:SetWidth(1)
			right:SetColorTexture(0, 0, 0)
			right:SetPoint("TOPRIGHT", bg)
			right:SetPoint("BOTTOMRIGHT", bg)
			parent.right = right

			local top = parent:CreateTexture(nil, "BACKGROUND")
			top:SetHeight(1)
			top:SetColorTexture(0, 0, 0)
			top:SetPoint("TOPLEFT", bg)
			top:SetPoint("TOPRIGHT", bg)
			parent.top = top

			local bottom = parent:CreateTexture(nil, "BACKGROUND")
			bottom:SetHeight(1)
			bottom:SetColorTexture(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", bg)
			bottom:SetPoint("BOTTOMRIGHT", bg)
			parent.bottom = bottom
		end

		local toggleBackdrop = function(bu, show)
			if show then
				bu.bg:Show()
				bu.left:Show()
				bu.right:Show()
				bu.top:Show()
				bu.bottom:Show()
			else
				bu.bg:Hide()
				bu.left:Hide()
				bu.right:Hide()
				bu.top:Hide()
				bu.bottom:Hide()
			end
		end

		hooksecurefunc("ToggleDropDownMenu", function(level, _, dropDownFrame, anchorName)
			if not level then level = 1 end

			local uiScale = _G.UIParent:GetScale()

			local listFrame = _G["DropDownList"..level]

			if level == 1 then
				if not anchorName then
					local xOffset = dropDownFrame.xOffset and dropDownFrame.xOffset or 16
					local yOffset = dropDownFrame.yOffset and dropDownFrame.yOffset or 9
					local point = dropDownFrame.point and dropDownFrame.point or "TOPLEFT"
					local relativeTo = dropDownFrame.relativeTo and dropDownFrame.relativeTo or dropDownFrame
					local relativePoint = dropDownFrame.relativePoint and dropDownFrame.relativePoint or "BOTTOMLEFT"

					listFrame:ClearAllPoints()
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)

					-- make sure it doesn't go off the screen
					local offLeft = listFrame:GetLeft()/uiScale
					local offRight = (_G.GetScreenWidth() - listFrame:GetRight())/uiScale
					local offTop = (_G.GetScreenHeight() - listFrame:GetTop())/uiScale
					local offBottom = listFrame:GetBottom()/uiScale

					local xAddOffset, yAddOffset = 0, 0
					if offLeft < 0 then
						xAddOffset = -offLeft
					elseif offRight < 0 then
						xAddOffset = offRight
					end

					if offTop < 0 then
						yAddOffset = offTop
					elseif offBottom < 0 then
						yAddOffset = -offBottom
					end
					listFrame:ClearAllPoints()
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset)
				elseif anchorName ~= "cursor" then
					-- this part might be a bit unreliable
					local _, _, relPoint, xOff, yOff = listFrame:GetPoint()
					if relPoint == "BOTTOMLEFT" and xOff == 0 and _G.floor(yOff) == 5 then
						listFrame:SetPoint("TOPLEFT", anchorName, "BOTTOMLEFT", 16, 9)
					end
				end
			else
				local point, anchor, relPoint, _, y = listFrame:GetPoint()
				if point:find("RIGHT") then
					listFrame:SetPoint(point, anchor, relPoint, -14, y)
				else
					listFrame:SetPoint(point, anchor, relPoint, 9, y)
				end
			end

			for j = 1, _G.UIDROPDOWNMENU_MAXBUTTONS do
				local bu = _G["DropDownList"..level.."Button"..j]
				local _, _, _, x = bu:GetPoint()
				if bu:IsShown() and x then
					local hl = _G["DropDownList"..level.."Button"..j.."Highlight"]
					local check = _G["DropDownList"..level.."Button"..j.."Check"]

					hl:SetPoint("TOPLEFT", -x + 1, 0)
					hl:SetPoint("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - 1, 0)

					if not bu.bg then
						createBackdrop(bu, check)
						hl:SetColorTexture(red, green, blue, .2)
						_G["DropDownList"..level.."Button"..j.."UnCheck"]:SetTexture("")

						local arrow = _G["DropDownList"..level.."Button"..j.."ExpandArrow"]
						arrow:SetNormalTexture(C.media.arrowRight)
						arrow:SetSize(8, 8)
					end

					if not bu.notCheckable then
						toggleBackdrop(bu, true)

						-- only reliable way to see if button is radio or or check...
						local _, co = check:GetTexCoord()

						if co == 0 then
							check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
							check:SetVertexColor(red, green, blue, 1)
							check:SetSize(20, 20)
							check:SetDesaturated(true)
						else
							check:SetTexture(C.media.backdrop)
							check:SetVertexColor(red, green, blue, .6)
							check:SetSize(10, 10)
							check:SetDesaturated(false)
						end

						check:SetTexCoord(0, 1, 0, 1)
					else
						toggleBackdrop(bu, false)
					end
				end
			end
		end)

		hooksecurefunc("UIDropDownMenu_SetIconImage", function(icon, texture)
			if texture:find("Divider") then
				icon:SetColorTexture(1, 1, 1, .2)
				icon:SetHeight(1)
			end
		end)

		-- Tab text position

		hooksecurefunc("PanelTemplates_DeselectTab", function(tab)
			local text = tab.Text or _G[tab:GetName().."Text"]
			text:SetPoint("CENTER", tab, "CENTER")
		end)

		hooksecurefunc("PanelTemplates_SelectTab", function(tab)
			local text = tab.Text or _G[tab:GetName().."Text"]
			text:SetPoint("CENTER", tab, "CENTER")
		end)

		-- [[ Custom skins ]]

		-- Pet stuff

		if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" or class == "WARLOCK" then
			if class == "HUNTER" then
				local PetStableFrame = _G.PetStableFrame
				PetStableFrame.BottomInset:DisableDrawLayer("BACKGROUND")
				PetStableFrame.BottomInset:DisableDrawLayer("BORDER")
				PetStableFrame.LeftInset:DisableDrawLayer("BACKGROUND")
				PetStableFrame.LeftInset:DisableDrawLayer("BORDER")
				_G.PetStableModelShadow:Hide()
				_G.PetStableModelRotateLeftButton:Hide()
				_G.PetStableModelRotateRightButton:Hide()
				_G.PetStableFrameModelBg:Hide()
				_G.PetStablePrevPageButtonIcon:SetTexture("")
				_G.PetStableNextPageButtonIcon:SetTexture("")

				F.ReskinPortraitFrame(PetStableFrame, true)
				F.ReskinArrow(_G.PetStablePrevPageButton, "Left")
				F.ReskinArrow(_G.PetStableNextPageButton, "Right")

				_G.PetStableSelectedPetIcon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(_G.PetStableSelectedPetIcon)

				for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
					local bu = _G["PetStableActivePet"..i]

					bu.Background:Hide()
					bu.Border:Hide()

					bu:SetNormalTexture("")
					bu.Checked:SetTexture(C.media.checked)

					_G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
					F.CreateBD(bu, .25)
				end

				for i = 1, _G.NUM_PET_STABLE_SLOTS do
					local bu = _G["PetStableStabledPet"..i]
					local bd = CreateFrame("Frame", nil, bu)
					bd:SetPoint("TOPLEFT", -1, 1)
					bd:SetPoint("BOTTOMRIGHT", 1, -1)
					F.CreateBD(bd, .25)
					bu:SetNormalTexture("")
					bu:DisableDrawLayer("BACKGROUND")
					_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end

		-- Ghost frame

		_G.GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)

		local GhostBD = CreateFrame("Frame", nil, _G.GhostFrameContentsFrame)
		GhostBD:SetPoint("TOPLEFT", _G.GhostFrameContentsFrameIcon, -1, 1)
		GhostBD:SetPoint("BOTTOMRIGHT", _G.GhostFrameContentsFrameIcon, 1, -1)
		F.CreateBD(GhostBD, 0)

		-- Currency frame

		_G.TokenFramePopupCorner:Hide()
		_G.TokenFramePopup:SetPoint("TOPLEFT", _G.TokenFrame, "TOPRIGHT", 1, -28)
		F.CreateBD(_G.TokenFramePopup)
		F.ReskinClose(_G.TokenFramePopupCloseButton)
		F.ReskinCheck(_G.TokenFramePopupInactiveCheckBox)
		F.ReskinCheck(_G.TokenFramePopupBackpackCheckBox)

		local function updateButtons()
			local buttons = _G.TokenFrameContainer.buttons

			if not buttons then return end

			for i = 1, #buttons do
				local bu = buttons[i]

				if not bu.styled then
					bu.highlight:SetPoint("TOPLEFT", 1, 0)
					bu.highlight:SetPoint("BOTTOMRIGHT", -1, 0)
					bu.highlight.SetPoint = F.dummy
					bu.highlight:SetColorTexture(red, green, blue, .2)
					bu.highlight.SetTexture = F.dummy

					bu.expandIcon:SetTexture("")

					local minus = bu:CreateTexture(nil, "OVERLAY")
					minus:SetSize(7, 1)
					minus:SetPoint("LEFT", 8, 0)
					minus:SetTexture(C.media.backdrop)
					minus:SetVertexColor(1, 1, 1)
					minus:Hide()
					bu.minus = minus

					local plus = bu:CreateTexture(nil, "OVERLAY")
					plus:SetSize(1, 7)
					plus:SetPoint("LEFT", 11, 0)
					plus:SetTexture(C.media.backdrop)
					plus:SetVertexColor(1, 1, 1)
					plus:Hide()
					bu.plus = plus

					bu.categoryMiddle:SetAlpha(0)
					bu.categoryLeft:SetAlpha(0)
					bu.categoryRight:SetAlpha(0)

					bu.icon:SetTexCoord(.08, .92, .08, .92)
					bu.bg = F.CreateBG(bu.icon)

					bu.styled = true
				end

				if bu.isHeader then
					bu.bg:Hide()
					bu.minus:Show()
					bu.plus:SetShown(not bu.isExpanded)
				else
					bu.bg:Show()
					bu.plus:Hide()
					bu.minus:Hide()
				end
			end
		end

		_G.TokenFrame:HookScript("OnShow", updateButtons)
		hooksecurefunc("TokenFrame_Update", updateButtons)
		hooksecurefunc(_G.TokenFrameContainer, "update", updateButtons)

		F.ReskinScroll(_G.TokenFrameContainerScrollBar)

		-- Reputation frame

		_G.ReputationDetailCorner:Hide()
		_G.ReputationDetailDivider:Hide()
		_G.ReputationListScrollFrame:GetRegions():Hide()
		select(2, _G.ReputationListScrollFrame:GetRegions()):Hide()

		_G.ReputationDetailFrame:SetPoint("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 1, -28)

		local function UpdateFactionSkins()
			for i = 1, _G.GetNumFactions() do
				local statusbar = _G["ReputationBar"..i.."ReputationBar"]

				if statusbar then
					statusbar:SetStatusBarTexture(C.media.backdrop)

					if not statusbar.reskinned then
						F.CreateBD(statusbar, .25)
						statusbar.reskinned = true
					end

					_G["ReputationBar"..i.."Background"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				end
			end
		end

		_G.ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
		_G.ReputationFrame:HookScript("OnEvent", UpdateFactionSkins)

		for i = 1, _G.NUM_FACTIONS_DISPLAYED do
			local bu = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
			F.ReskinExpandOrCollapse(bu)
		end

		F.CreateBD(_G.ReputationDetailFrame)
		F.ReskinClose(_G.ReputationDetailCloseButton)
		F.ReskinCheck(_G.ReputationDetailAtWarCheckBox)
		F.ReskinCheck(_G.ReputationDetailInactiveCheckBox)
		F.ReskinCheck(_G.ReputationDetailMainScreenCheckBox)
		F.ReskinCheck(_G.ReputationDetailLFGBonusReputationCheckBox)
		F.ReskinScroll(_G.ReputationListScrollFrameScrollBar)

		select(3, _G.ReputationDetailFrame:GetRegions()):Hide()

		-- Battlenet toast frame

		F.CreateBD(_G.BNToastFrame)
		F.CreateBD(_G.BNToastFrame.TooltipFrame)
		_G.BNToastFrameCloseButton:SetAlpha(0)

		-- Gossip Frame

		_G.GossipGreetingScrollFrameTop:Hide()
		_G.GossipGreetingScrollFrameBottom:Hide()
		_G.GossipGreetingScrollFrameMiddle:Hide()
		select(19, _G.GossipFrame:GetRegions()):Hide()

		_G.GossipGreetingText:SetTextColor(1, 1, 1)

		_G.NPCFriendshipStatusBar:GetRegions():Hide()
		_G.NPCFriendshipStatusBarNotch1:SetColorTexture(0, 0, 0)
		_G.NPCFriendshipStatusBarNotch1:SetSize(1, 16)
		_G.NPCFriendshipStatusBarNotch2:SetColorTexture(0, 0, 0)
		_G.NPCFriendshipStatusBarNotch2:SetSize(1, 16)
		_G.NPCFriendshipStatusBarNotch3:SetColorTexture(0, 0, 0)
		_G.NPCFriendshipStatusBarNotch3:SetSize(1, 16)
		_G.NPCFriendshipStatusBarNotch4:SetColorTexture(0, 0, 0)
		_G.NPCFriendshipStatusBarNotch4:SetSize(1, 16)
		select(7, _G.NPCFriendshipStatusBar:GetRegions()):Hide()

		_G.NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
		F.CreateBDFrame(_G.NPCFriendshipStatusBar, .25)

		F.ReskinPortraitFrame(_G.GossipFrame, true)
		F.Reskin(_G.GossipFrameGreetingGoodbyeButton)
		F.ReskinScroll(_G.GossipGreetingScrollFrameScrollBar)
		hooksecurefunc("GossipFrameAvailableQuestsUpdate", function(...)
			local numAvailQuestsData = select("#", ...)
			local buttonIndex = (_G.GossipFrame.buttonIndex - 1) - (numAvailQuestsData / 7)
			for i = 1, numAvailQuestsData, 7 do
				local titleText, _, isTrivial = select(i, ...)
				local titleButton = _G["GossipTitleButton" .. buttonIndex]
				if isTrivial then
					titleButton:SetFormattedText(_G.AURORA_TRIVIAL_QUEST_DISPLAY, titleText);
				else
					titleButton:SetFormattedText(_G.AURORA_NORMAL_QUEST_DISPLAY, titleText);
				end
				buttonIndex = buttonIndex + 1
			end
		end)
		hooksecurefunc("GossipFrameActiveQuestsUpdate", function(...)
			local numActiveQuestsData = select("#", ...)
			local buttonIndex = (_G.GossipFrame.buttonIndex - 1) - (numActiveQuestsData / 6)
			for i = 1, numActiveQuestsData, 6 do
				local titleText, _, isTrivial = select(i, ...)
				local titleButton = _G["GossipTitleButton" .. buttonIndex]
				if isTrivial then
					titleButton:SetFormattedText(_G.AURORA_TRIVIAL_QUEST_DISPLAY, titleText);
				else
					titleButton:SetFormattedText(_G.AURORA_NORMAL_QUEST_DISPLAY, titleText);
				end
				buttonIndex = buttonIndex + 1
			end
		end)

		-- Tutorial Frame

		F.CreateBD(_G.TutorialFrame)

		_G.TutorialFrameBackground:Hide()
		_G.TutorialFrameBackground.Show = F.dummy
		_G.TutorialFrame:DisableDrawLayer("BORDER")

		local tutOkay = _G.TutorialFrameOkayButton
		local tutPrev = _G.TutorialFramePrevButton
		local tutNext = _G.TutorialFrameNextButton
		F.Reskin(tutOkay, true)
		F.ReskinClose(_G.TutorialFrameCloseButton)
		F.ReskinArrow(tutPrev, "Left")
		F.ReskinArrow(tutNext, "Right")

		tutOkay:ClearAllPoints()
		tutOkay:SetPoint("BOTTOMLEFT", tutNext, "BOTTOMRIGHT", 10, 0)

		-- because gradient alpha and OnUpdate doesn't work for some reason...

		if select(14, tutOkay:GetRegions()) then
			select(14, tutOkay:GetRegions()):Hide()
			select(15, tutPrev:GetRegions()):Hide()
			select(15, tutNext:GetRegions()):Hide()
			select(14, _G.TutorialFrameCloseButton:GetRegions()):Hide()
		end
		tutPrev:SetScript("OnEnter", nil)
		tutNext:SetScript("OnEnter", nil)
		tutOkay:SetBackdropColor(0, 0, 0, .25)
		tutPrev:SetBackdropColor(0, 0, 0, .25)
		tutNext:SetBackdropColor(0, 0, 0, .25)

		-- Guild registrar frame

		_G.GuildRegistrarFrameTop:Hide()
		_G.GuildRegistrarFrameBottom:Hide()
		_G.GuildRegistrarFrameMiddle:Hide()
		select(19, _G.GuildRegistrarFrame:GetRegions()):Hide()

		_G.GuildRegistrarFrameEditBox:SetHeight(20)

		F.ReskinPortraitFrame(_G.GuildRegistrarFrame, true)
		F.CreateBD(_G.GuildRegistrarFrameEditBox, .25)
		F.Reskin(_G.GuildRegistrarFrameGoodbyeButton)
		F.Reskin(_G.GuildRegistrarFramePurchaseButton)
		F.Reskin(_G.GuildRegistrarFrameCancelButton)

		--[[ Item text ]]

		select(18, _G.ItemTextFrame:GetRegions()):Hide()
		_G.ItemTextFramePageBg:SetAlpha(0)
		_G.ItemTextPrevPageButton:GetRegions():Hide()
		_G.ItemTextNextPageButton:GetRegions():Hide()
		_G.ItemTextMaterialTopLeft:SetAlpha(0)
		_G.ItemTextMaterialTopRight:SetAlpha(0)
		_G.ItemTextMaterialBotLeft:SetAlpha(0)
		_G.ItemTextMaterialBotRight:SetAlpha(0)

		F.ReskinPortraitFrame(_G.ItemTextFrame, true)
		F.ReskinScroll(_G.ItemTextScrollFrameScrollBar)
		F.ReskinArrow(_G.ItemTextPrevPageButton, "Left")
		F.ReskinArrow(_G.ItemTextNextPageButton, "Right")

		-- Petition frame

		select(18, _G.PetitionFrame:GetRegions()):Hide()
		select(19, _G.PetitionFrame:GetRegions()):Hide()
		select(23, _G.PetitionFrame:GetRegions()):Hide()
		select(24, _G.PetitionFrame:GetRegions()):Hide()
		_G.PetitionFrameTop:Hide()
		_G.PetitionFrameBottom:Hide()
		_G.PetitionFrameMiddle:Hide()

		F.ReskinPortraitFrame(_G.PetitionFrame, true)
		F.Reskin(_G.PetitionFrameSignButton)
		F.Reskin(_G.PetitionFrameRequestButton)
		F.Reskin(_G.PetitionFrameRenameButton)
		F.Reskin(_G.PetitionFrameCancelButton)

		-- Micro button alerts

		local microButtons = {_G.TalentMicroButtonAlert, _G.CollectionsMicroButtonAlert}
			for _, button in next, microButtons do
			button:DisableDrawLayer("BACKGROUND")
			button:DisableDrawLayer("BORDER")
			button.Arrow:Hide()

			F.SetBD(button)
			F.ReskinClose(button.CloseButton)
		end

		-- Cinematic popup

		_G.CinematicFrameCloseDialog:HookScript("OnShow", function(cinemaFrame)
			cinemaFrame:SetScale(_G.UIParent:GetScale())
		end)

		F.CreateBD(_G.CinematicFrameCloseDialog)
		F.Reskin(_G.CinematicFrameCloseDialogConfirmButton)
		F.Reskin(_G.CinematicFrameCloseDialogResumeButton)

		-- Bonus roll

		local BonusRollFrame = _G.BonusRollFrame
		BonusRollFrame.Background:SetAlpha(0)
		BonusRollFrame.IconBorder:Hide()
		BonusRollFrame.BlackBackgroundHoist.Background:Hide()

		BonusRollFrame.PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(BonusRollFrame.PromptFrame.Icon)

		BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(C.media.backdrop)

		F.CreateBD(BonusRollFrame)
		F.CreateBDFrame(BonusRollFrame.PromptFrame.Timer, .25)

		-- Level up display

		_G.LevelUpDisplaySide:HookScript("OnShow", function(lvlUp)
			for i = 1, #lvlUp.unlockList do
				local f = _G["LevelUpDisplaySideUnlockFrame"..i]

				if not f.restyled then
					f.icon:SetTexCoord(.08, .92, .08, .92)
					F.CreateBG(f.icon)
				end
			end
		end)

		-- Movie Frame

		local MovieFrame = _G.MovieFrame
		MovieFrame.CloseDialog:HookScript("OnShow", function(mov)
			mov:SetScale(_G.UIParent:GetScale())
		end)

		F.CreateBD(MovieFrame.CloseDialog)
		F.Reskin(MovieFrame.CloseDialog.ConfirmButton)
		F.Reskin(MovieFrame.CloseDialog.ResumeButton)

		-- Pet battle queue popup

		local PetBattleQueueReadyFrame = _G.PetBattleQueueReadyFrame
		F.CreateBD(PetBattleQueueReadyFrame)
		F.CreateBG(PetBattleQueueReadyFrame.Art)
		F.Reskin(PetBattleQueueReadyFrame.AcceptButton)
		F.Reskin(PetBattleQueueReadyFrame.DeclineButton)

		-- PVP Ready Dialog

		local PVPReadyDialog = _G.PVPReadyDialog
		PVPReadyDialog.background:Hide()
		PVPReadyDialog.bottomArt:Hide()
		PVPReadyDialog.filigree:Hide()

		PVPReadyDialog.roleIcon.texture:SetTexture(C.media.roleIcons)

		do
			local left = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
			left:SetWidth(1)
			left:SetTexture(C.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", 9, -7)
			left:SetPoint("BOTTOMLEFT", 9, 10)

			local right = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
			right:SetWidth(1)
			right:SetTexture(C.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", -8, -7)
			right:SetPoint("BOTTOMRIGHT", -8, 10)

			local top = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
			top:SetHeight(1)
			top:SetTexture(C.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", 9, -7)
			top:SetPoint("TOPRIGHT", -8, -7)

			local bottom = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
			bottom:SetHeight(1)
			bottom:SetTexture(C.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", 9, 10)
			bottom:SetPoint("BOTTOMRIGHT", -8, 10)
		end

		F.CreateBD(PVPReadyDialog)
		PVPReadyDialog.SetBackdrop = F.dummy

		F.Reskin(PVPReadyDialog.enterButton)
		F.Reskin(PVPReadyDialog.leaveButton)
		F.ReskinClose(_G.PVPReadyDialogCloseButton)

		-- [[ Hide regions ]]

		_G.GhostFrameLeft:Hide()
		_G.GhostFrameRight:Hide()
		_G.GhostFrameMiddle:Hide()
		for i = 3, 6 do
			select(i, _G.GhostFrame:GetRegions()):Hide()
		end

		-- [[ Text colour functions ]]
		_G.GameFontBlackMedium:SetTextColor(1, 1, 1)
		_G.QuestFont:SetTextColor(1, 1, 1)
		_G.MailFont_Large:SetTextColor(1, 1, 1)
		_G.MailFont_Large:SetShadowColor(0, 0, 0)
		_G.MailFont_Large:SetShadowOffset(1, -1)
		_G.AvailableServicesText:SetTextColor(1, 1, 1)
		_G.AvailableServicesText:SetShadowColor(0, 0, 0)
		_G.PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
		_G.PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
		_G.PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
		_G.PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
		_G.PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
		_G.PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
		_G.ItemTextPageText:SetTextColor(1, 1, 1)
		_G.ItemTextPageText.SetTextColor = F.dummy
		_G.CoreAbilityFont:SetTextColor(1, 1, 1)

		-- [[ Change positions ]]

		_G.TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", _G.TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

		-- [[ Buttons ]]

		local buttons = {"GhostFrame"}
		for i = 1, #buttons do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				F.Reskin(reskinbutton)
			else
				_G.print("Aurora: "..buttons[i].." was not found.")
			end
		end

		F.ReskinClose(_G.ItemRefCloseButton)
	end
end)
