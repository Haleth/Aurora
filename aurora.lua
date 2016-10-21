local ADDON_NAME, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select, tostring, pairs = _G.select, _G.tostring, _G.pairs

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]

-- for custom APIs (see docs online)
local LATEST_API_VERSION = "6.0"

-- see F.AddPlugin
local AURORA_LOADED = false
local AuroraConfig
_G.Aurora = {
	{}, -- F, functions
	{}, -- C, constants/config
}
private.Aurora = _G.Aurora

local debug do
	if _G.LibStub then
		local debugger
		local LTD = _G.LibStub((_G.RealUI and "RealUI_" or "").."LibTextDump-1.0", true)
		function debug(...)
			if not debugger then
				if LTD then
					debugger = LTD:New(ADDON_NAME .." Debug Output", 640, 480)
					private.debugger = debugger
				else
					return
				end
			end
			local time = _G.date("%H:%M:%S")
			local text = ("[%s]"):format(time)
			for i = 1, select("#", ...) do
				local arg = select(i, ...)
				text = text .. "     " .. tostring(arg)
			end
			debugger:AddLine(text)
		end
	else
		debug = function() end
	end
	private.debug = debug
end

local F, C = _G.unpack(private.Aurora)

-- [[ Constants and settings ]]

C.classcolours = {
	["HUNTER"] = { r = 0.58, g = 0.86, b = 0.49 },
	["WARLOCK"] = { r = 0.6, g = 0.47, b = 0.85 },
	["PALADIN"] = { r = 1, g = 0.22, b = 0.52 },
	["PRIEST"] = { r = 0.8, g = 0.87, b = .9 },
	["MAGE"] = { r = 0, g = 0.76, b = 1 },
	["MONK"] = {r = 0.0, g = 1.00 , b = 0.59},
	["ROGUE"] = { r = 1, g = 0.91, b = 0.2 },
	["DRUID"] = { r = 1, g = 0.49, b = 0.04 },
	["SHAMAN"] = { r = 0, g = 0.6, b = 0.6 };
	["WARRIOR"] = { r = 0.9, g = 0.65, b = 0.45 },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
	["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79 },
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
	["enableFont"] = true,
	["loot"] = true,
	["useCustomColour"] = false,
		["customColour"] = {r = 1, g = 1, b = 1},
	["tooltips"] = true,
}

C.frames = {}

C.TOC = select(4, _G.GetBuildInfo())
C.is71 = _G.GetBuildInfo() == "7.1.0"

-- [[ Cached variables ]]

local useButtonGradientColour

-- [[ Functions ]]

local classDisplayName, class = _G.UnitClass("player")

if _G.CUSTOM_CLASS_COLORS then
	C.classcolours = _G.CUSTOM_CLASS_COLORS
end

-- [[ Variable and module handling ]]

C.themes = {}
C.themes["Aurora"] = {}

-- use of this function ensures that Aurora and custom style (if used) are properly initialised
-- prior to loading third party plugins
F.AddPlugin = function(func, name)
	if name and name ~= "Aurora" then
		C.themes[name] = func
	else
		_G.tinsert(C.themes["Aurora"], func)
	end
	if AURORA_LOADED and IsAddOnLoaded(name) then loadAddon(name) end
end

-- check if the addon is supported by Aurora, and if it is, execute its module
-- this should never be called before Aurora is loaded because it just execute immediately
local function loadAddon(addon)
	local addonModule = C.themes[addon]
	if addonModule then
		if _G.type(addonModule) == "function" then
			addonModule()
		else
			for _, moduleFunc in pairs(addonModule) do
				if _G.type(moduleFunc) == "function" then
					moduleFunc()
				end
			end
		end
	end
end

-- [[ Initialize addon ]]

local Skin = CreateFrame("Frame", nil, _G.UIParent)
Skin:RegisterEvent("ADDON_LOADED")
Skin:RegisterEvent("VARIABLES_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == ADDON_NAME then
		-- [[ Load Variables ]]
		_G.AuroraConfig = _G.AuroraConfig or {}
		AuroraConfig = _G.AuroraConfig

		-- remove deprecated or corrupt variables
		for key, value in pairs(AuroraConfig) do
			if C.defaults[key] == nil then
				AuroraConfig[key] = nil
			end
		end

		-- load or init variables
		for key, value in pairs(C.defaults) do
			if AuroraConfig[key] == nil then
				if _G.type(value) == "table" then
					AuroraConfig[key] = {}
					for k, v in pairs(value) do
						AuroraConfig[key][k] = value[k]
					end
				else
					AuroraConfig[key] = value
				end
			end
		end

		useButtonGradientColour = AuroraConfig.useButtonGradientColour

		-- [[ Custom style support ]]

		local shouldSkipSplashScreen = false

		local customStyle = _G.AURORA_CUSTOM_STYLE

		if customStyle and customStyle.apiVersion ~= nil and customStyle.apiVersion == LATEST_API_VERSION then
			local protectedFunctions = {
				["AddPlugin"] = true,
			}

			-- replace functions
			if customStyle.functions then
				for funcName, func in pairs(customStyle.functions) do
					if F[funcName] and not protectedFunctions[funcName] then
						F[funcName] = func
					end
				end
			end

			-- replace class colours
			if customStyle.classcolors then
				C.classcolours = customStyle.classcolors
			end

			-- replace colour scheme
			local highlightColour = customStyle.highlightColor
			if highlightColour then
				C.r, C.g, C.b = highlightColour.r, highlightColour.g, highlightColour.b
			end

			-- skip splash screen if requested
			if customStyle.skipSplashScreen then
				shouldSkipSplashScreen = true
			end
		end

		if useButtonGradientColour then
			C.buttonR, C.buttonG, C.buttonB, C.buttonA = _G.unpack(AuroraConfig.buttonGradientColour)
		else
			C.buttonR, C.buttonG, C.buttonB, C.buttonA = _G.unpack(AuroraConfig.buttonSolidColour)
		end

		if AuroraConfig.useCustomColour then
			C.r, C.g, C.b = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b
		else
			C.r, C.g, C.b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b
		end

		-- [[ Splash screen for first time users ]]

		if not AuroraConfig.acknowledgedSplashScreen then
			if shouldSkipSplashScreen then
				AuroraConfig.acknowledgedSplashScreen = true
			else
				_G.AuroraSplashScreen:Show()
			end
		end

		-- Load addons if they loaded before this
		for idx = 1, GetNumAddOns() do
			if IsAddOnLoaded(idx) then
				local addon = GetAddOnInfo(idx)
				loadAddon(addon)
			end
		end

		-- from this point, plugins added with F.AddPlugin are executed directly instead of cached
		AURORA_LOADED = true
		return
	end

	-- [[ Load modules ]]

	if event == "ADDON_LOADED" then
		loadAddon(addon)
	elseif event == "VARIABLES_LOADED" then
		private.ApplySkin()
	end
end)
