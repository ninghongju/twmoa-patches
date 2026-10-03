-- Overlay for official SuperAPI hardcoded English.
-- Locale/ holds AceLocale keys (enUS) and translations (zhCN).
-- This file runs after SuperAPIOptions.lua: it rewrites cmdtable name/desc/validate
-- for display, and wraps get/set so saved values stay the official English strings.

if not SuperAPI or not SuperAPI.cmdtable then
	return
end

local L = AceLibrary("AceLocale-2.2"):new("SuperAPI")

local function T(s)
	if type(s) ~= "string" then
		return s
	end
	if L:HasTranslation(s) then
		return L[s]
	end
	return s
end

local function ToEnglish(s)
	if type(s) ~= "string" then
		return s
	end
	if L:HasReverseTranslation(s) then
		return L:GetReverseTranslation(s)
	end
	return s
end

local function LocalizeList(list)
	local out = {}
	local changed = nil
	local n = table.getn(list)
	local k, v, dst
	if n > 0 then
		for k = 1, n do
			v = list[k]
			dst = T(v)
			out[k] = dst
			if dst ~= v then
				changed = true
			end
		end
		return out, changed
	end
	for k, v in pairs(list) do
		dst = T(v)
		out[k] = dst
		if dst ~= v then
			changed = true
		end
	end
	return out, changed
end

local function Walk(node)
	if type(node) ~= "table" then
		return
	end
	if type(node.name) == "string" then
		node.name = T(node.name)
	end
	if type(node.desc) == "string" then
		node.desc = T(node.desc)
	end
	if type(node.validate) == "table" then
		local localized, changed = LocalizeList(node.validate)
		if changed then
			local origGet = node.get
			local origSet = node.set
			node.validate = localized
			if origGet then
				node.get = function()
					return T(ToEnglish(origGet()))
				end
			end
			if origSet then
				node.set = function(v)
					return origSet(ToEnglish(v))
				end
			end
		end
	end
	if type(node.args) == "table" then
		local k, child
		for k, child in pairs(node.args) do
			Walk(child)
		end
	end
end

Walk(SuperAPI.cmdtable)

-- If official SuperAPI.lua is dropped in unchanged, still localize OnEnable strings.
local origEnable = SuperAPI.OnEnable
if origEnable then
	function SuperAPI:OnEnable()
		local cf = DEFAULT_CHAT_FRAME
		local origAdd = cf.AddMessage
		cf.AddMessage = function(frame, msg, a, b, c, d)
			if type(msg) == "string" and L:HasTranslation(msg) then
				msg = L[msg]
			end
			return origAdd(frame, msg, a, b, c, d)
		end
		origEnable(self)
		cf.AddMessage = origAdd
		MACROFRAME_CHAR_LIMIT = T("%d/511 Characters Used")
		OPTION_TOOLTIP_PARTY_CHAT_BUBBLES = T("Shows whisper, party, raid, and battleground chat text in speech bubbles above characters' heads.")
		PARTY_CHAT_BUBBLES_TEXT = T("Show Whisper and Group Chat Bubbles")
	end
end
