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
local skinList
function Base.AddSkin(addonName, func)
    assert(not private.AddOns[addonName], addonName .. " already has a registered skin." )

    private.AddOns[addonName] = func
    if skinList then
        tinsert(skinList, addonName)
    end
end

--[[ Base.GetSkinList()
Returns a list of all non-Blizzard AddOn skins.

**Returns:**
* `skinList` - an indexed list of addon names _(table)_
--]]
function Base.GetSkinList()
    if not skinList then
        skinList = {}
        for name in next, private.AddOns do
            if not name:find("Blizzard") then
                tinsert(skinList, name)
            end
        end
    end
    return _G.CopyTable(skinList)
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

do -- Base.SetBackdrop
    local backdrop = {
        -- Blizzard options
        bgFile = private.textures.plain,
        tile = true,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
        },
        edgeFile = private.textures.plain,
        edgeSize = 1,

        -- Custom options
        offsets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
        },
    }
    private.backdrop = backdrop

    local function GetRGBA(red, green, blue, alpha)
        local a
        if type(red) == "table" then
            a = green
            red, green, blue, alpha = red:GetRGBA()
        end
        return red, green, blue, a or alpha
    end
    local function CopyBackdrop(bdOptions)
        return {
            bgFile = bdOptions.bgFile,
            tile = bdOptions.tile,
            insets = {
                left = bdOptions.insets.left,
                right = bdOptions.insets.right,
                top = bdOptions.insets.top,
                bottom = bdOptions.insets.bottom,
            },
            edgeFile = bdOptions.edgeFile,
            edgeSize = bdOptions.edgeSize,

            offsets = {
                left = bdOptions.offsets.left,
                right = bdOptions.offsets.right,
                top = bdOptions.offsets.top,
                bottom = bdOptions.offsets.bottom,
            },
        }
    end

    local bgTextures = {
        bg = true,

        l = true,
        r = true,
        t = true,
        b = true,

        tl = true,
        tr = true,
        bl = true,
        br = true,
    }
    local sides = {
        l = {l=0, r=0.125, t=0, b=1, tileV = true},
        r = {l=0.125, r=0.25, t=0, b=1, tileV = true},
        t = {l=0.25, r=0.375, t=0, b=1, tileH = true},
        b = {l=0.375, r=0.5, t=0, b=1, tileH = true},
    }
    local corners = {
        tl = {l=0.5, r=0.625, t=0, b=1, point = "TOPLEFT"},
        tr = {l=0.625, r=0.75, t=0, b=1, point = "TOPRIGHT"},
        bl = {l=0.75, r=0.875, t=0, b=1, point = "BOTTOMLEFT"},
        br = {l=0.875, r=1, t=0, b=1, point = "BOTTOMRIGHT"},
    }

    local old_SetBackdrop = _G.getmetatable(_G.UIParent).__index.SetBackdrop
    local BackdropMixin = {}

    -- Blizzard methods
    function BackdropMixin.SetBackdrop(frame, options, textures)
        if frame.settingBD then return end
        frame.settingBD = true
        old_SetBackdrop(frame, nil)
        if options then
            if not frame._auroraBackdrop then
                local bd = textures or {}
                bd.borderLayer = textures and textures.borderLayer or "BACKGROUND"
                bd.borderSublevel = textures and textures.borderSublevel or -7

                for name in next, bgTextures do
                    if bd[name] then
                        bd[name]:ClearAllPoints()
                        if name == "bg" then
                            bd[name]:SetDrawLayer("BACKGROUND", -8)
                        else
                            bd[name]:SetDrawLayer(bd.borderLayer, bd.borderSublevel)
                        end
                    else
                        if name == "bg" then
                            bd[name] = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
                        else
                            bd[name] = frame:CreateTexture(nil, bd.borderLayer, nil, bd.borderSublevel)
                        end
                    end

                    bd[name]:SetTexelSnappingBias(0.0)
                    bd[name]:SetSnapToPixelGrid(false)
                end

                frame._auroraBackdrop = bd
            end
            local bd = frame._auroraBackdrop
            options = bd.options or options

            --[[ The tile size is fixed at the original texture size, so this option is DOA.
            if options.tileSize then
                bd.bg:SetSize(options.tileSize, options.tileSize)
            end]]
            bd.bg:Show()
            options.bgFile = options.bgFile or backdrop.bgFile
            if options.tile == nil then
                options.tile = backdrop.tile
            end

            if Base.IsTextureRegistered(options.bgFile) then
                Base.SetTexture(bd.bg, options.bgFile)
                if bd.bgRed then
                    bd.bg:SetVertexColor(bd.bgRed, bd.bgGreen, bd.bgBlue, bd.bgAlpha)
                end
            else
                bd.bg:SetTexture(options.bgFile, options.tile, options.tile)
                bd.bg:SetHorizTile(options.tile)
                bd.bg:SetVertTile(options.tile)
            end

            options.insets = options.insets or backdrop.insets
            options.offsets = options.offsets or backdrop.offsets

            local insets = options.insets
            local offsets = options.offsets
            if insets then
                bd.bg:SetPoint("TOPLEFT", frame, (insets.left + offsets.left), -(insets.top + offsets.top))
                bd.bg:SetPoint("BOTTOMRIGHT", frame, -(insets.right + offsets.right), (insets.bottom + offsets.bottom))
            end


            options.edgeFile = options.edgeFile or backdrop.edgeFile
            for side, info in next, sides do
                bd[side]:Show()
                bd[side]:SetTexture(options.edgeFile)
                if info.tileH then
                    bd[side]:SetTexCoord(info.l, info.b, info.r, info.b, info.l, info.t, info.r, info.t)
                else
                    bd[side]:SetTexCoord(info.l, info.r, info.t, info.b)
                end
            end

            for corner, info in next, corners do
                bd[corner]:Show()
                bd[corner]:SetTexture(options.edgeFile)
                bd[corner]:SetTexCoord(info.l, info.r, info.t, info.b)
            end

            bd.l:SetPoint("TOPLEFT", bd.tl, "BOTTOMLEFT")
            bd.l:SetPoint("BOTTOMRIGHT", bd.bl, "TOPRIGHT")

            bd.r:SetPoint("TOPLEFT", bd.tr, "BOTTOMLEFT")
            bd.r:SetPoint("BOTTOMRIGHT", bd.br, "TOPRIGHT")

            bd.t:SetPoint("TOPLEFT", bd.tl, "TOPRIGHT")
            bd.t:SetPoint("BOTTOMRIGHT", bd.tr, "BOTTOMLEFT")

            bd.b:SetPoint("TOPLEFT", bd.bl, "TOPRIGHT")
            bd.b:SetPoint("BOTTOMRIGHT", bd.br, "BOTTOMLEFT")

            options.edgeSize = options.edgeSize or backdrop.edgeSize
            for corner, info in next, corners do
                bd[corner]:SetSize(options.edgeSize, options.edgeSize)
                if insets then
                    if info.point == "TOPLEFT" then
                        bd[corner]:SetPoint(info.point, bd.bg, -insets.left, insets.top)
                    elseif info.point == "TOPRIGHT" then
                        bd[corner]:SetPoint(info.point, bd.bg, insets.right, insets.top)
                    elseif info.point == "BOTTOMLEFT" then
                        bd[corner]:SetPoint(info.point, bd.bg, -insets.left, -insets.bottom)
                    elseif info.point == "BOTTOMRIGHT" then
                        bd[corner]:SetPoint(info.point, bd.bg, insets.left, -insets.bottom)
                    end
                else
                    bd[corner]:SetPoint(info.point, bd.bg)
                end
            end

            bd.options = CopyBackdrop(options)
        else
            if frame._auroraBackdrop then
                local bd = frame._auroraBackdrop
                bd.bg:Hide()
                for side, info in next, sides do
                    bd[side]:Hide()
                end

                for corner, info in next, corners do
                    bd[corner]:Hide()
                end
            end
        end
        frame.settingBD = nil
    end
    function BackdropMixin.GetBackdrop(frame)
        if frame._auroraBackdrop then
            local options = frame._auroraBackdrop.options
            return CopyBackdrop(options)
        end
    end
    function BackdropMixin.SetBackdropColor(frame, red, green, blue, alpha)
        if frame._auroraBackdrop then
            red, green, blue, alpha = GetRGBA(red, green, blue, alpha)

            local bd = frame._auroraBackdrop
            bd.bgRed = red
            bd.bgGreen = green
            bd.bgBlue = blue
            bd.bgAlpha = alpha

            bd.bg:SetVertexColor(red, green, blue, alpha)
        end
    end
    function BackdropMixin.GetBackdropColor(frame)
        if frame._auroraBackdrop then
            local bd = frame._auroraBackdrop
            return bd.bgRed, bd.bgGreen, bd.bgBlue, bd.bgAlpha
        end
    end
    function BackdropMixin.SetBackdropBorderColor(frame, red, green, blue, alpha)
        if frame._auroraBackdrop then
            red, green, blue, alpha = GetRGBA(red, green, blue, alpha)

            local bd = frame._auroraBackdrop
            bd.borderRed = red
            bd.borderGreen = green
            bd.borderBlue = blue
            bd.borderAlpha = alpha

            local tex = bd.t:GetTexture()
            if tex then
                for side, info in next, sides do
                    bd[side]:SetVertexColor(red, green, blue, alpha)
                end

                for corner, info in next, corners do
                    bd[corner]:SetVertexColor(red, green, blue, alpha)
                end
            else
                private.debug("SetBackdropBorderColor no texture", frame:GetName(), tex)
            end
        end
    end
    function BackdropMixin.GetBackdropBorderColor(frame)
        if frame._auroraBackdrop then
            local bd = frame._auroraBackdrop
            return bd.borderRed, bd.borderGreen, bd.borderBlue, bd.borderAlpha
        end
    end

    -- Custom Methods
    function BackdropMixin.SetBackdropBorderLayer(frame, layer, sublevel)
        local bd = frame._auroraBackdrop
        bd.l:SetDrawLayer(layer, sublevel)
        bd.r:SetDrawLayer(layer, sublevel)
        bd.t:SetDrawLayer(layer, sublevel)
        bd.b:SetDrawLayer(layer, sublevel)

        bd.tl:SetDrawLayer(layer, sublevel)
        bd.tr:SetDrawLayer(layer, sublevel)
        bd.bl:SetDrawLayer(layer, sublevel)
        bd.br:SetDrawLayer(layer, sublevel)

        bd.borderLayer = layer
        bd.borderSublevel = sublevel
    end
    function BackdropMixin.GetBackdropBorderLayer(frame)
        if frame._auroraBackdrop then
            return frame._auroraBackdrop.borderLayer, frame._auroraBackdrop.borderSublevel
        end
    end
    function BackdropMixin.GetBackdropTexture(frame, texture)
        if frame._auroraBackdrop then
            return frame._auroraBackdrop[texture]
        end
    end
    function BackdropMixin.SetBackdropOption(frame, optionKey, optionValue)
        if frame._auroraBackdrop then
            local options = frame._auroraBackdrop.options
            if options[optionKey] ~= optionValue then
                options[optionKey] = optionValue
                frame:SetBackdrop(options)
            end
        end
    end
    function BackdropMixin.GetBackdropOption(frame, optionKey)
        if frame._auroraBackdrop then
            local options = frame._auroraBackdrop.options
            return options[optionKey]
        end
    end

    function Base.CreateBackdrop(frame, options, textures)
        for name, func in next, BackdropMixin do
            frame[name] = func
        end

        frame:SetBackdrop(options, textures)
    end

    function Base.SetBackdrop(frame, color, alpha)
        Base.CreateBackdrop(frame, backdrop)
        Base.SetBackdropColor(frame, color, alpha)
    end
    function Base.SetBackdropColor(frame, color, alpha)
        if not color then color = Color.frame end
        if type(color) ~= "table" then error("`color` must be a Color object. See Color.Create") end

        frame:SetBackdropColor(Color.Lightness(color, -0.3), alpha or color.a)
        frame:SetBackdropBorderColor(color, 1)
    end
end

function Base.SetFont(fontObj, fontPath, fontSize, fontStyle, fontColor, shadowColor, shadowX, shadowY)
    if _G.type(fontObj) == "string" then fontObj = _G[fontObj] end
    if not fontObj then return end

    if fontPath then
        if private.disabled.fonts then
            fontPath = fontObj:GetFont()
        end

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
