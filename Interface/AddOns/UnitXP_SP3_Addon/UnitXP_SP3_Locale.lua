-- Overlay for official UnitXP_SP3_Addon hardcoded English.
-- Locale/ holds English keys and zhCN translations.
-- This file runs after UnitXP_SP3_Addon.xml: rewrite visible XML text,
-- wrap tooltips, reassign BINDING_* display names, and translate chat lines
-- that start with "UnitXP". SavedVariables are booleans/numbers, not these strings.

if not xpsp3Frame then
	return
end

local dict = nil
if UnitXP_SP3_Locales then
	dict = UnitXP_SP3_Locales[GetLocale()] or UnitXP_SP3_Locales["enUS"]
end

local function T(s)
	if type(s) ~= "string" or not dict then
		return s
	end
	local v = dict[s]
	if type(v) == "string" then
		return v
	end
	return s
end

local function TranslatePrint(msg)
	if type(msg) ~= "string" then
		return msg
	end
	local v = dict and dict[msg]
	if type(v) == "string" then
		return v
	end
	local _, _, method = string.find(msg, '^UnitXP_SP3%.dll failed to execute "(.+)"%. You might need to update UnitXP_SP3%.dll to support this method%.$')
	if method then
		local fmt = dict and dict['UnitXP_SP3.dll failed to execute "%s". You might need to update UnitXP_SP3.dll to support this method.']
		if type(fmt) == "string" then
			return string.format(fmt, method)
		end
	end
	local _, _, built = string.find(msg, "^UnitXP Service Pack 3 is loaded%. It was built on (.+)%.$")
	if built then
		return T("UnitXP Service Pack 3 is loaded.") .. T(" It was built on ") .. built .. "."
	end
	local _, _, dbg = string.find(msg, "^UnitXP_SP3 floating combat text debug: (.+)$")
	if dbg then
		return T("UnitXP_SP3 floating combat text debug: ") .. dbg
	end
	return msg
end

local function LocalizeFontString(fs)
	if not fs or not fs.GetText or not fs.SetText then
		return
	end
	local text = fs:GetText()
	if type(text) == "string" then
		local t = T(text)
		if t ~= text then
			fs:SetText(t)
		end
	end
end

local function Walk(frame)
	if not frame then
		return
	end
	local regions = { frame:GetRegions() }
	local i, r
	for i = 1, table.getn(regions) do
		r = regions[i]
		if r and r.GetObjectType and r:GetObjectType() == "FontString" then
			LocalizeFontString(r)
		end
	end
	if frame.GetObjectType and frame.GetText and frame.SetText then
		local ot = frame:GetObjectType()
		if ot == "Button" or ot == "CheckButton" then
			LocalizeFontString(frame)
		end
	end
	local children = { frame:GetChildren() }
	for i = 1, table.getn(children) do
		Walk(children[i])
	end
end

local function HookTooltip(tt)
	if not tt or tt._unitxpLoc then
		return
	end
	tt._unitxpLoc = 1
	local origSetText = tt.SetText
	local origAddLine = tt.AddLine
	tt.SetText = function(self, text, a, b, c, d, e)
		if type(text) == "string" then
			text = T(text)
		end
		return origSetText(self, text, a, b, c, d, e)
	end
	if origAddLine then
		tt.AddLine = function(self, text, a, b, c, d)
			if type(text) == "string" then
				text = T(text)
			end
			return origAddLine(self, text, a, b, c, d)
		end
	end
end

Walk(xpsp3Frame)
HookTooltip(xpsp3tooltip)
if LibDBIconTooltip then
	HookTooltip(LibDBIconTooltip)
end

local bindKeys = {
	"BINDING_HEADER_UNITXPSP3TARGETING",
	"BINDING_NAME_UNITXPSP3NEARESTENEMY",
	"BINDING_NAME_UNITXPSP3TARGETMOSTHP",
	"BINDING_NAME_UNITXPSP3WORLDBOSS",
	"BINDING_NAME_UNITXPSP3NEXTMARKER",
	"BINDING_NAME_UNITXPSP3PREVIOUSMARKER",
	"BINDING_NAME_UNITXPSP3NEXTENEMY",
	"BINDING_NAME_UNITXPSP3PREVIOUSENEMY",
	"BINDING_NAME_UNITXPSP3NEXTMELEE",
	"BINDING_NAME_UNITXPSP3PREVIOUSMELEE",
	"BINDING_HEADER_UNITXPSP3UTILITIES",
	"BINDING_NAME_UNITXPSP3RAISECAMERA",
	"BINDING_NAME_UNITXPSP3LOWERCAMERA",
	"BINDING_NAME_UNITXPSP3LEFTCAMERA",
	"BINDING_NAME_UNITXPSP3RIGHTCAMERA",
	"BINDING_NAME_UNITXPSP3RESETCAMERA",
	"BINDING_NAME_UNITXPSP3TOGGLEMODERNNAMEPLATEDISTANCE",
	"BINDING_NAME_UNITXPSP3TOGGLEPRIORITIZETARGETNAMEPLATE",
	"BINDING_NAME_UNITXPSP3TOGGLEPRIORITIZEMARKEDNAMEPLATE",
}
local bi
for bi = 1, table.getn(bindKeys) do
	local k = bindKeys[bi]
	local v = getglobal(k)
	if type(v) == "string" then
		setglobal(k, T(v))
	end
end

if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
	local origAdd = DEFAULT_CHAT_FRAME.AddMessage
	DEFAULT_CHAT_FRAME.AddMessage = function(frame, msg, a, b, c, d)
		if type(msg) == "string" and string.sub(msg, 1, 6) == "UnitXP" then
			msg = TranslatePrint(msg)
		end
		return origAdd(frame, msg, a, b, c, d)
	end
end
