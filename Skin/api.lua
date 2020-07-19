local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next assert type pcall tinsert math error select wipe

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Color = Aurora.Color

Aurora.classIcons = { -- adjusted for borderless icons
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

--[[ Base:header
These are most basic skinning functions and are the foundation of every skin in Aurora.
--]]

--[[ Base.AddSkin(_addonName, func_)
Allows an external addon to add a skinning function for the specified
AddOn. `func` will run when the `ADDON_LOADED` event is triggered for
addonName.

**Args:**
* `addonName` - the name of the AddOn to be skinned _(string)_
* `func`      - used to skin the AddOn _(function)_
--]]
function Base.AddSkin(addonName, func)
    assert(not private.AddOns[addonName], addonName .. " already has a registered skin." )
    private.AddOns[addonName] = func

    if _G.IsAddOnLoaded(addonName) then
        func()
    end
end


--[[ Base.GetAddonSkins()
Returns a list of all non-Blizzard AddOn skins.

**Returns:**
* `skinList` - an indexed list of addon names _(table)_
--]]
function Base.GetAddonSkins()
    local skinList = {}
    for name in next, private.AddOns do
        if not name:find("Blizzard") then
            tinsert(skinList, name)
        end
    end
    return skinList
end


--[[ Base.CropIcon(_texture[, parent]_)
Sets texture coordinates to just inside a square icon's built-in border.
If the optional second argument is provided, an other texture will be
created at a black background for the icon.

**Args:**
* `texture` - the texture to be cropped _(Texture)_
* `parent`  - _optional_ a frame that can create a texture _(Frame)_

**Returns:**
* `iconBorder` - _optional_ a black texture behind the icon to act as a border _(Texture)_
--]]
function Base.CropIcon(texture, parent)
    texture:SetTexCoord(.08, .92, .08, .92)
    if parent then
        local layer, subLevel = texture:GetDrawLayer()
        local iconBorder = parent:CreateTexture(nil, layer, nil, subLevel - 1)
        iconBorder:SetPoint("TOPLEFT", texture, -1, 1)
        iconBorder:SetPoint("BOTTOMRIGHT", texture, 1, -1)
        iconBorder:SetColorTexture(0, 0, 0)
        return iconBorder
    end
end

function Base.SetFont(fontObj, fontPath, fontSize, fontStyle, fontColor, shadowColor, shadowX, shadowY)
    if _G.type(fontObj) == "string" then fontObj = _G[fontObj] end
    if not fontObj then return end

    if fontPath and not private.disabled.fonts then
        fontObj:SetFont(fontPath, fontSize, fontStyle)
    end

    if fontColor then
        fontObj:SetTextColor(fontColor.r, fontColor.g, fontColor.b)
    end

    if shadowColor then
        fontObj:SetShadowColor(shadowColor.r, shadowColor.g, shadowColor.b, 0.5)
    end

    if shadowX and shadowY then
        fontObj:SetShadowOffset(shadowX, shadowY)
    end
end

do -- Base.SetHighlight
    --[[
    local tempColor = {}
    local function GetColorTexture(string)
        _G.wipe(tempColor)
        string = string:gsub("Color%-", "")

        local prevChar, val
        string:gsub("(%x)", function(char)
            if prevChar then
                val = _G.tonumber(prevChar..char, 16) / 255 -- convert hex to perc decimal
                _G.tinsert(tempColor, val - (val % 0.01)) -- round val to two decimal places
                prevChar = nil
            elseif char == "0" then
                _G.tinsert(tempColor, 0)
            else
                prevChar = char
            end
        end)

        return tempColor[1], tempColor[2], tempColor[3], tempColor[4]
    end
    ]]

    local function GetReturnColor(button, isBackdrop)
        if isBackdrop then
            local bdFrame = button._auroraBDFrame or button
            if bdFrame.GetButtonColor then
                local enabled, disabled = bdFrame:GetButtonColor()
                if bdFrame:IsEnabled() then
                    return enabled
                else
                    return disabled
                end
            else
                local _, _, _, a = bdFrame:GetBackdropColor()
                local r, g, b = bdFrame:GetBackdropBorderColor()
                return Color.Create(r, g, b, a)
            end
        else
            return Color.Create(button._auroraHighlight[1]:GetVertexColor())
        end
    end
    local function ShowHighlight(button)
        if button:IsEnabled() then
            if not button._isHighlightLocked then
                return not button._isHighlighted
            end
        end

        return button._isHighlightLocked
    end
    local function OnEnter(button, isBackdrop)
        local highlight = Color.highlight
        if button.IsEnabled and not button:IsEnabled() then
            highlight = highlight:Lightness(-0.3)
        end

        if isBackdrop then
            local alpha = button._returnColor.a or highlight.a
            Base.SetBackdropColor(button._auroraBDFrame or button, highlight, alpha)
        else
            for _, texture in next, button._auroraHighlight do
                texture:SetVertexColor(Color.highlight:GetRGBA())
            end
        end
    end
    local function OnLeave(button, isBackdrop)
        if isBackdrop then
            Base.SetBackdropColor(button._auroraBDFrame or button, button._returnColor)
        else
            for _, texture in next, button._auroraHighlight do
                texture:SetVertexColor(button._returnColor:GetRGBA())
            end
        end
    end
    function Base.SetHighlight(button, highlightType, onenter, onleave)
        local isBackdrop = highlightType == "backdrop"
        button._returnColor = GetReturnColor(button, isBackdrop)

        local function enter(self)
            if ShowHighlight(button) and not button._isHighlighted then
                button._returnColor = GetReturnColor(self, isBackdrop);
                (onenter or OnEnter)(self, isBackdrop)
                button._isHighlighted = true
            end
        end
        button:HookScript("OnEnter", enter)

        local function leave(self)
            if not ShowHighlight(button) and button._isHighlighted then
                (onleave or OnLeave)(self, isBackdrop)
                button._isHighlighted = false
            end
        end
        button:HookScript("OnLeave", leave)

        if button.LockHighlight then
            _G.hooksecurefunc(button, "LockHighlight", function(self, ...)
                button._isHighlightLocked = true
                enter(self)
            end)
            _G.hooksecurefunc(button, "UnlockHighlight", function(self, ...)
                button._isHighlightLocked = nil
                leave(self)
            end)
        end
    end
end

do -- Base.SetTexture
    local snapshots = {}

    function Base.IsTextureRegistered(textureName)
        return not not snapshots[textureName]
    end

    function Base.SetTexture(texture, textureName)
        _G.assert(type(texture) == "table" and texture.GetObjectType, "texture widget expected, got "..type(texture))
        _G.assert(texture:GetObjectType() == "Texture", "texture widget expected, got "..texture:GetObjectType())

        local snapshot = snapshots[textureName]
        _G.assert(snapshot, textureName .. " is not a registered texture.")

        snapshot(texture:GetParent(), texture)
    end

    function Base.RegisterTexture(textureName, createFunc)
        _G.assert(not snapshots[textureName], textureName .. " is already registered.")
        private.debug("RegisterTexture", textureName)
        snapshots[textureName] = createFunc
    end
end
