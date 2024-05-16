local CachedMarkups = {}

local ToDraw = {}
local DrawTime = 0
local DrawY = 0

local function DrawSplitMessage()
	local curtime = CurTime()

	if curtime > DrawTime then
		hook.Remove("HUDPaint", "DrawSplitMessage")
		DrawTime = nil
		return
	end

	local dh = DrawY

	for i, marked in ipairs(ToDraw) do
		local delta = DrawTime - curtime

		local th = marked.totalHeight
		local tw = marked.totalWidth

		if delta > 3.5 then
			delta = delta - 3.5
			delta = 0.5 - delta

			local halfw = tw * 0.5

			marked:Draw(w * (1 - delta) - halfw, dh)
			marked:Draw(w * delta - halfw, dh)
		else
			local mid = w * 0.5 - tw * 0.5

			marked:Draw(mid, dh)
			marked:Draw(mid + math.random(-1, 1), dh + math.random(-1, 1))
		end

		dh = dh + th
	end
end

function GM:SplitMessage(y, ...)
	local Cached = true
	local arg = {...}

	for i=1, #arg do
		local str = arg[i]
		if not CachedMarkups[str] then
			CachedMarkups[str] = markup.Parse(str)
		end
	end

	ToDraw = {}

	DrawTime = CurTime() + 4
	DrawY = y

	for i=1, #arg do
		table.insert(ToDraw, CachedMarkups[ arg[i] ])
	end

	hook.Add("HUDPaint", "DrawSplitMessage", DrawSplitMessage)
end
