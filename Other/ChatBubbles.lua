local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local _, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	if not _G.AuroraConfig.chatBubbles then return end

	local bubbleHook = _G.CreateFrame("Frame")

	local function styleBubble(frame)
		local scale = _G.UIParent:GetScale()

		for i = 1, frame:GetNumRegions() do
			local region = _G.select(i, frame:GetRegions())
			if region:GetObjectType() == "Texture" then
				region:SetTexture(nil)
			elseif region:GetObjectType() == "FontString" then
				region:SetFont(C.media.font, 13)
				region:SetShadowOffset(scale, -scale)
			end
		end

		frame:SetBackdrop({
			bgFile = C.media.backdrop,
			edgeFile = C.media.backdrop,
			edgeSize = scale,
		})
		frame:SetBackdropColor(0, 0, 0, _G.AuroraConfig.alpha)
		frame:SetBackdropBorderColor(0, 0, 0)
	end

	local function isChatBubble(frame)
		if frame:GetName() then return end
		local region = frame:GetRegions()
		if region and region:IsObjectType("Texture") then
			return region:GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
		end
	end

	local last = 0
	local numKids = 0

	bubbleHook:SetScript("OnUpdate", function(self, elapsed)
		last = last + elapsed
		if last > .1 then
			last = 0
			local newNumKids = _G.WorldFrame:GetNumChildren()
			if newNumKids ~= numKids then
				for i=numKids + 1, newNumKids do
					local frame = _G.select(i, _G.WorldFrame:GetChildren())

					if isChatBubble(frame) then
						styleBubble(frame)
					end
				end
				numKids = newNumKids
			end
		end
	end)
end)
