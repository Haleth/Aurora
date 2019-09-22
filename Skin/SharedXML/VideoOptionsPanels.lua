local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\VideoOptionsPanels.lua ]]
--end

do --[[ FrameXML\VideoOptionsPanels.xml ]]
    function Skin.VideoOptionsDropDownMenuTemplate(Frame)
        Skin.UIDropDownMenuTemplate(Frame)
    end
    function Skin.RaidVideoOptionsDropDownMenuTemplate(Frame)
        Skin.VideoOptionsDropDownMenuTemplate(Frame)
    end
    function Skin.VideoOptionsSliderTemplate(Slider)
        Skin.OptionsSliderTemplate(Slider)
    end
    function Skin.RaidVideoOptionsSliderTemplate(Slider)
        Skin.VideoOptionsSliderTemplate(Slider)
    end
    function Skin.VideoOptionsSmallCheckButtonTemplate(CheckButton)
        Skin.OptionsSmallCheckButtonTemplate(CheckButton)
    end
    function Skin.RaidVideoOptionsSmallCheckButtonTemplate(Frame)
        Skin.VideoOptionsSmallCheckButtonTemplate(Frame)
    end
    function Skin.AdvancedVideoOptionsDropDownMenuTemplate(Frame)
        Skin.VideoOptionsDropDownMenuTemplate(Frame)
    end
end

function private.SharedXML.VideoOptionsPanels()
    -------------
    -- Display --
    -------------
    Base.SetBackdrop(_G.Display_, Color.frame)

    -- Column A
    Skin.VideoOptionsDropDownMenuTemplate(_G.Display_DisplayModeDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.Display_ResolutionDropDown)
    Skin.VideoOptionsSliderTemplate(_G.Display_RenderScaleSlider)

    -- Column B
    Skin.VideoOptionsDropDownMenuTemplate(_G.Display_PrimaryMonitorDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.Display_AntiAliasingDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.Display_VerticalSyncDropDown)

    -- Outside the box
    Skin.VideoOptionsSmallCheckButtonTemplate(_G.Display_RaidSettingsEnabledCheckBox)

    --------------
    -- Graphics --
    --------------
    Base.SetBackdrop(_G.Graphics_, Color.frame)

    Skin.VideoOptionsSliderTemplate(_G.Graphics_Quality)

    -- Textures
    Skin.VideoOptionsDropDownMenuTemplate(_G.Graphics_TextureResolutionDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.Graphics_FilteringDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.Graphics_ProjectedTexturesDropDown)

    -- Environment
    Skin.VideoOptionsSliderTemplate(_G.Graphics_EnvironmentalDetailSlider)
    Skin.VideoOptionsSliderTemplate(_G.Graphics_GroundClutterSlider)

    -- Effects
    Skin.VideoOptionsDropDownMenuTemplate(_G.Graphics_ShadowsDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.Graphics_LiquidDetailDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.Graphics_SunshaftsDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.Graphics_ParticleDensityDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.Graphics_SSAODropDown)

    ----------------
    -- Raid Panel --
    ----------------
    Base.SetBackdrop(_G.RaidGraphics_, Color.frame)

    Skin.VideoOptionsSliderTemplate(_G.RaidGraphics_Quality)

    -- Textures
    Skin.VideoOptionsDropDownMenuTemplate(_G.RaidGraphics_TextureResolutionDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.RaidGraphics_FilteringDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.RaidGraphics_ProjectedTexturesDropDown)

    -- Environment
    Skin.VideoOptionsSliderTemplate(_G.RaidGraphics_EnvironmentalDetailSlider)
    Skin.VideoOptionsSliderTemplate(_G.RaidGraphics_GroundClutterSlider)

    -- Effects
    Skin.VideoOptionsDropDownMenuTemplate(_G.RaidGraphics_ShadowsDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.RaidGraphics_LiquidDetailDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.RaidGraphics_SunshaftsDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.RaidGraphics_ParticleDensityDropDown)
    Skin.VideoOptionsDropDownMenuTemplate(_G.RaidGraphics_SSAODropDown)


    Skin.TabButtonTemplate(_G.GraphicsButton)
    Skin.TabButtonTemplate(_G.RaidButton)

    --------------------
    -- Advanced Panel --
    --------------------
    -- Column A
    Skin.AdvancedVideoOptionsDropDownMenuTemplate(_G.Advanced_BufferingDropDown)
    Skin.AdvancedVideoOptionsDropDownMenuTemplate(_G.Advanced_LagDropDown)
    Skin.AdvancedVideoOptionsDropDownMenuTemplate(_G.Advanced_MultisampleAntiAliasingDropDown)
    Skin.AdvancedVideoOptionsDropDownMenuTemplate(_G.Advanced_MultisampleAlphaTest)
    Skin.AdvancedVideoOptionsDropDownMenuTemplate(_G.Advanced_PostProcessAntiAliasingDropDown)
    Skin.AdvancedVideoOptionsDropDownMenuTemplate(_G.Advanced_ResampleQualityDropDown)
    Skin.AdvancedVideoOptionsDropDownMenuTemplate(_G.Advanced_AdapterDropDown)

    Skin.VideoOptionsSliderTemplate(_G.Advanced_UIScaleSlider)
    Skin.VideoOptionsSmallCheckButtonTemplate(_G.Advanced_UseUIScale)

    -- Column B
    Skin.VideoOptionsSliderTemplate(_G.Advanced_MaxFPSSlider)
    Skin.VideoOptionsSmallCheckButtonTemplate(_G.Advanced_MaxFPSCheckBox)
    Skin.VideoOptionsSliderTemplate(_G.Advanced_MaxFPSBKSlider)
    Skin.VideoOptionsSmallCheckButtonTemplate(_G.Advanced_MaxFPSBKCheckBox)
    Skin.VideoOptionsSliderTemplate(_G.Advanced_ContrastSlider)
    Skin.VideoOptionsSliderTemplate(_G.Advanced_BrightnessSlider)
    Skin.VideoOptionsSliderTemplate(_G.Advanced_GammaSlider)

    -------------------
    -- Network Panel --
    -------------------
    Skin.OptionsCheckButtonTemplate(_G.NetworkOptionsPanelOptimizeSpeed)
    Skin.OptionsCheckButtonTemplate(_G.NetworkOptionsPanelUseIPv6)
    Skin.OptionsCheckButtonTemplate(_G.NetworkOptionsPanelAdvancedCombatLogging)

    ---------------
    -- Languages --
    ---------------
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsLanguagesPanelLocaleDropDown)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsLanguagesPanelAudioLocaleDropDown)
end
