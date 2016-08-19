local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	local RecruitAFriendFrame = _G.RecruitAFriendFrame
	local RecruitAFriendSentFrame = _G.RecruitAFriendSentFrame

	RecruitAFriendFrame.NoteFrame:DisableDrawLayer("BACKGROUND")

	F.CreateBD(RecruitAFriendFrame)
	F.ReskinClose(_G.RecruitAFriendFrameCloseButton)
	F.Reskin(RecruitAFriendFrame.SendButton)
	F.ReskinInput(_G.RecruitAFriendNameEditBox)

	F.CreateBDFrame(RecruitAFriendFrame.NoteFrame, .25)

	F.CreateBD(RecruitAFriendSentFrame)
	F.Reskin(RecruitAFriendSentFrame.OKButton)
	F.ReskinClose(_G.RecruitAFriendSentFrameCloseButton)
end)
