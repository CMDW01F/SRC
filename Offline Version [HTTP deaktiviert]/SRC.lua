local scr_x, scr_y = term.getSize()
CHATBOX_SAFEMODE = nil

-- Technische Einstellungen [FORTSCHRITTLICH]
src = {
	connectToSkynet = false,
	version = "1.B.0",
	isBeta = false,
	port = 11000,
	skynetPort = "secured-communication",
	url = "https://raw.githubusercontent.com/CMDW01F/SecureRadioCom/System/Offline%20Version%20%5BHTTP%20deaktiviert%5D/SRC.lua",
	betaurl = "https://raw.githubusercontent.com/CMDW01F/SecureRadioCom/Beta/Offline%20Version%20%5BHTTP%20deaktiviert%5D%20BETA/SRC.lua",
	ignoreModem = false,
	dataDir = "/.src",
	useChatbox = false,
	disableChatboxWithRedstone = false,
}

-- Anpassbare Einstellungen
local srcSettings = {
	animDiv = 4,
	doAnimate = true,
	reverseScroll = false,
	redrawDelay = 0.1,
	useSetVisible = false,
	pageKeySpeed = 8,
	doNotif = true,
	doKrazy = false,
	useSkynet = true,
	extraNewline = true,
	acceptPictoChat = true,
	noRepeatNames = true,
}

-- Farben
palette = {
	bg = colors.black,
	txt = colors.white,
	promptbg = colors.gray,
	prompttxt = colors.white,
	scrollMeter = colors.lightGray,
	chevron = colors.black,
	title = colors.lightGray,
	titlebg = colors.gray,
}

-- UI Anpassungen
UIconf = {
	promptY = 1,
	chevron = ">",
	chatlogTop = 1,
	title = "SecureRadioCom",
	doTitle = false,
	titleY = 1,
	nameDecolor = false,
	centerTitle = true,
	prefix = "<",
	suffix = "> "
}

local mathmax, mathmin, mathrandom = math.max, math.min, math.random
local termblit, termwrite = term.blit, term.write
local termsetCursorPos, termgetCursorPos, termsetCursorBlink = term.setCursorPos, term.getCursorPos, term.setCursorBlink
local termsetTextColor, termsetBackgroundColor = term.setTextColor, term.setBackgroundColor
local termgetTextColor, termgetBackgroundColor = term.getTextColor, term.getBackgroundColor
local termclear, termclearLine = term.clear, term.clearLine
local tableinsert, tableremove, tableconcat = table.insert, table.remove, table.concat
local textutilsserialize, textutilsunserialize = textutils.serialize, textutils.unserialize
local stringsub, stringgsub, stringrep = string.sub, string.gsub, string.rep
local unpack = unpack

local initcolors = {
	bg = termgetBackgroundColor(),
	txt = termgetTextColor()
}

local tArg = {...}

local yourName = tArg[1]
local encKey = tArg[2]

local setEncKey = function(newKey)
	encKey = newKey
end

local saveSettings = function()
	local file = fs.open(fs.combine(src.dataDir, "settings"), "w")
	file.write(
		textutilsserialize({
			srcSettings = srcSettings,
			palette = palette,
			UIconf = UIconf,
		})
	)
	file.close()
end

local loadSettings = function()
	local contents
	if not fs.exists(fs.combine(src.dataDir, "settings")) then
		saveSettings()
	end
	local file = fs.open(fs.combine(src.dataDir, "settings"), "r")
	contents = file.readAll()
	file.close()
	local newSettings = textutilsunserialize(contents)
	if newSettings then
		for k,v in pairs(newSettings.srcSettings) do
			srcSettings[k] = v
		end
		for k,v in pairs(newSettings.palette) do
			palette[k] = v
		end
		for k,v in pairs(newSettings.UIconf) do
			UIconf[k] = v
		end
	else
		saveSettings()
	end
end

local updatesrc = function(doBeta)
	local pPath = shell.getRunningProgram()
	local h = http.get((doBeta or src.isBeta) and src.betaurl or src.url)
	if not h then
		return false, "Konnte keine Verbindung herstellen."
	else
		local content = h.readAll()
		local file = fs.open(pPath, "w")
		file.write(content)
		file.close()
		return true, "Aktualisiert!"
	end
end

local pauseRendering = true

local colors_strnames = {
	["white"] = colors.white,
	["pearl"] = colors.white,
	["silver"] = colors.white,
	["aryan"] = colors.white,
	["#f0f0f0"] = colors.white,

	["orange"] = colors.orange,
	["carrot"] = colors.orange,
	["fuhrer"] = colors.orange,
	["pumpkin"] = colors.orange,
	["#f2b233"] = colors.orange,

	["magenta"] = colors.magenta,
	["hotpink"] = colors.magenta,
	["lightpurple"] = colors.magenta,
	["light purple"] = colors.magenta,
	["#e57fd8"] = colors.magenta,

	["lightblue"] = colors.lightBlue,
	["light blue"] = colors.lightBlue,
	["skyblue"] = colors.lightBlue,
	["#99b2f2"] = colors.lightBlue,

	["yellow"] = colors.yellow,
	["piss"] = colors.yellow,
	["pee"] = colors.yellow,
	["lemon"] = colors.yellow,
	["spongebob"] = colors.yellow,
	["cowardice"] = colors.yellow,
	["#dede6c"] = colors.yellow,

	["lime"] = colors.lime,
	["lightgreen"] = colors.lime,
	["light green"] = colors.lime,
	["slime"] = colors.lime,
	["radiation"] = colors.lime,
	["#7fcc19"] = colors.lime,

	["pink"] = colors.pink,
	["lightishred"] = colors.pink,
	["lightish red"] = colors.pink,
	["communist"] = colors.pink,
	["commie"] = colors.pink,
	["patrick"] = colors.pink,
	["#f2b2cc"] = colors.pink,

	["gray"] = colors.gray,
	["grey"] = colors.gray,
	["graey"] = colors.gray,
	["gunmetal"] = colors.gray,
	["#4c4c4c"] = colors.gray,

	["lightgray"] = colors.lightGray,
	["lightgrey"] = colors.lightGray,
	["light gray"] = colors.lightGray,
	["light grey"] = colors.lightGray,
	["#999999"] = colors.lightGray,

	["cyan"] = colors.cyan,
	["seawater"] = colors.cyan,
	["brine"] = colors.cyan,
	["#4c99b2"] = colors.cyan,

	["purple"] = colors.purple,
	["purble"] = colors.purple,
	["obsidian"] = colors.purple,
	["diviner"] = colors.purple,
	["#b266e5"] = colors.purple,

	["blue"] = colors.blue,
	["blu"] = colors.blue,
	["azure"] = colors.blue,
	["sapphire"] = colors.blue,
	["lapis"] = colors.blue,
	["volnutt"] = colors.blue,
	["blueberry"] = colors.blue,
	["x"] = colors.blue,
	["megaman"] = colors.blue,
	["#3366bb"] = colors.blue,

	["brown"] = colors.brown,
	["shit"] = colors.brown,
	["dirt"] = colors.brown,
	["mud"] = colors.brown,
	["bricks"] = colors.brown,
	["#7f664c"] = colors.brown,

	["green"] = colors.green,
	["grass"] = colors.green,
	["#57a64e"] = colors.green,

	["red"] = colors.red,
	["crimson"] = colors.red,
	["vermillion"] = colors.red,
	["menstration"] = colors.red,
	["blood"] = colors.red,
	["marinara"] = colors.red,
	["zero"] = colors.red,
	["protoman"] = colors.red,
	["communism"] = colors.red,
	["#cc4c4c"] = colors.red,

	["black"] = colors.black,
	["dark"] = colors.black,
	["darkness"] = colors.black,
	["space"] = colors.black,
	["coal"] = colors.black,
	["onyx"] = colors.black,
	["#191919"] = colors.black,
}

local toblit = {
	[0] = " ",
	[1] = "0",
	[2] = "1",
	[4] = "2",
	[8] = "3",
	[16] = "4",
	[32] = "5",
	[64] = "6",
	[128] = "7",
	[256] = "8",
	[512] = "9",
	[1024] = "a",
	[2048] = "b",
	[4096] = "c",
	[8192] = "d",
	[16384] = "e",
	[32768] = "f"
}
local tocolors = {}
for k,v in pairs(toblit) do
	tocolors[v] = k
end

local codeNames = {
	["r"] = "reset",
	["{"] = "stopFormatting",
	["}"] = "startFormatting",
	["k"] = "krazy"
}

local kraziez = {
	["l"] = {
		"!",
		"l",
		"1",
		"|",
		"i",
		"I",
		":",
		";",
	},
	["m"] = {
		"M",
		"W",
		"w",
		"m",
		"X",
		"N",
		"_",
		"%",
		"@",
	},
	["all"] = {}
}

for a = 1, #kraziez["l"] do
	kraziez[kraziez["l"][a]] = kraziez["l"]
end
for k,v in pairs(kraziez) do
	for a = 1, #v do
		kraziez[kraziez[k][a]] = v
	end
end

if tonumber(_CC_VERSION or 0) >= 1.76 then
	for a = 1, 255 do
		if (a ~= 32) and (a ~= 13) and (a ~= 10) then
			kraziez["all"][#kraziez["all"]+1] = string.char(a)
		end
	end
else
	for a = 33, 126 do
		kraziez["all"][#kraziez["all"]+1] = string.char(a)
	end
end

local makeRandomString = function(length, begin, stop)
	local output = ""
	for a = 1, length do
		output = output .. string.char(math.random(begin or 1, stop or 255))
	end
	return output
end

local personalID = makeRandomString(64, 32, 128)

local explode = function(div, str, replstr, includeDiv)
	if (div == '') then
		return false
	end
	local pos, arr = 0, {}
	for st, sp in function() return string.find(str, div, pos, false) end do
		tableinsert(arr, string.sub(replstr or str, pos, st - 1 + (includeDiv and #div or 0)))
		pos = sp + 1
	end
	tableinsert(arr, string.sub(replstr or str, pos))
	return arr
end

local parseKrazy = function(c)
	if kraziez[c] then
		return kraziez[c][mathrandom(1, #kraziez[c])]
	else
		return kraziez.all[mathrandom(1, #kraziez.all)]
	end
end

local textToBlit = function(input, onlyString, initText, initBack, checkPos, useJSONformat)
	if not input then return end
	checkPos = checkPos or -1
	initText, initBack = initText or toblit[term.getTextColor()], initBack or toblit[term.getBackgroundColor()]
	tcode, bcode = "&", "~"
	local cpos, cx = 0, 0
	local skip, ignore, ex = nil, false, nil
	local text, back, nex = initText, initBack, nil

	local charOut, textOut, backOut = {}, {}, {}
	local JSONoutput = {}

	local krazy = false
	local bold = false
	local strikethrough = false
	local underline = false
	local italic = false

	local codes = {}
	codes["r"] = function(prev)
		if not ignore then
			if prev == tcode then
				text = initText
				bold = false
				strikethrough = false
				underline = false
				italic = false
			elseif prev == bcode then
				if useJSONformat then
					return 0
				else
					back = initBack
				end
			end
			krazy = false
		else
			return 0
		end
	end
	codes["k"] = function(prev)
		if not ignore then
			krazy = not krazy
		else
			return 0
		end
	end
	codes["{"] = function(prev)
		if not ignore then
			ignore = true
		else
			return 0
		end
	end
	codes["}"] = function(prev)
		if ignore then
			ignore = false
		else
			return 0
		end
	end

	if useJSONformat then
		codes["l"] = function(prev)
			bold = true
		end
		codes["m"] = function(prev)
			strikethrough = true
		end
		codes["n"] = function(prev)
			underline = true
		end
		codes["o"] = function(prev)
			italic = true
		end
	end

	local sx, str = 0
	input = stringgsub(input, "(\\)(%d%d?%d?)", function(cap, val)
		if tonumber(val) < 256 then
			cpos = cpos - #val
			return string.char(val)
		else
			return cap..val
		end
	end)

	local MCcolors = {
		["0"] = "white",
		["1"] = "gold",
		["2"] = "light_purple",
		["3"] = "aqua",
		["4"] = "yellow",
		["5"] = "green",
		["6"] = "light_purple",
		["7"] = "dark_gray",
		["8"] = "gray",
		["9"] = "dark_aqua",
		["a"] = "dark_purple",
		["b"] = "dark_blue",
		["c"] = "gold",
		["d"] = "dark_green",
		["e"] = "red",
		["f"] = "black",
	}

	for cx = 1, #input do
		str = stringsub(input,cx,cx)
		if skip then
			if tocolors[str] and not ignore then
				if skip == tcode then
					text = str == " " and initText or str
					if sx < checkPos then
						cpos = cpos - 2
					end
				elseif skip == bcode then
					back = str == " " and initBack or str
					if sx < checkPos then
						cpos = cpos - 2
					end
				end
			elseif codes[str] and not (ignore and str == "{") then
				ex = codes[str](skip) or 0
				sx = sx + ex
    				if sx < checkPos then
					cpos = cpos - ex - 2
				end
			else
				sx = sx + 1
				if useJSONformat then
					JSONoutput[sx] = {
						text = (skip..str),
						color = onlyString and "f" or MCcolors[text],
						bold = (not onlyString) and bold,
						italic = (not onlyString) and italic,
						underline = (not onlyString) and underline,
						obfuscated = (not onlyString) and krazy,
						strikethrough = (not onlyString) and strikethrough
					}
				else
					charOut[sx] = krazy and parseKrazy(prev..str) or (skip..str)
					textOut[sx] = stringrep(text,2)
					backOut[sx] = stringrep(back,2)
				end
			end
			skip = nil
		else
			if (str == tcode or str == bcode) and (codes[stringsub(input, 1+cx, 1+cx)] or tocolors[stringsub(input,1+cx,1+cx)]) then
				skip = str
			else
				sx = sx + 1
				if useJSONformat then
					JSONoutput[sx] = {
						text = str,
						color = onlyString and "f" or MCcolors[text],
						bold = (not onlyString) and bold,
						italic = (not onlyString) and italic,
						underline = (not onlyString) and underline,
						obfuscated = (not onlyString) and krazy,
						strikethrough = (not onlyString) and strikethrough
					}
				else
					charOut[sx] = krazy and parseKrazy(str) or str
					textOut[sx] = text
					backOut[sx] = back
				end
			end
		end
	end
	if useJSONformat then
		return textutils.serializeJSON(JSONoutput)
	else
		if onlyString then
			return tableconcat(charOut), (checkPos > -1) and cpos or nil
		else
--			return {tableconcat(charOut), tableconcat(textOut):gsub(" ", initText), tableconcat(backOut):gsub(" ", initBack)}, (checkPos > -1) and cpos or nil
			return {tableconcat(charOut), tableconcat(textOut), tableconcat(backOut)}, (checkPos > -1) and cpos or nil
		end
	end
end
_G.textToBlit = textToBlit

local colorRead = function(maxLength, _history)
	local output = ""
	local history, _history = {}, _history or {}
	for a = 1, #_history do
		history[a] = _history[a]
	end
	history[#history+1] = ""
	local hPos = #history
	local cx, cy = termgetCursorPos()
	local x, xscroll = 1, 1
	local ctrlDown = false
	termsetCursorBlink(true)
	local evt, key, bout, xmod, timtam
	while true do
		termsetCursorPos(cx, cy)
		bout, xmod = textToBlit(output, false, nil, nil, x)
		for a = 1, #bout do
			bout[a] = stringsub(bout[a], xscroll, xscroll + scr_x - cx)
		end
		termblit(unpack(bout))
		termwrite((" "):rep(scr_x - cx))
		termsetCursorPos(cx + x + xmod - xscroll, cy)
		evt = {os.pullEvent()}
		if evt[1] == "char" or evt[1] == "paste" then
			output = (output:sub(1, x-1)..evt[2]..output:sub(x)):sub(1, maxLength or -1)
			x = mathmin(x + #evt[2], #output+1)
		elseif evt[1] == "key" then
			key = evt[2]
			if key == keys.leftCtrl then
				ctrlDown = true
			elseif key == keys.left then
				x = mathmax(x - 1, 1)
			elseif key == keys.right then
				x = mathmin(x + 1, #output+1)
			elseif key == keys.backspace then
				if x > 1 then
					repeat
						output = output:sub(1,x-2)..output:sub(x)
						x = x - 1
					until output:sub(x-1,x-1) == " " or (not ctrlDown) or (x == 1)
				end
			elseif key == keys.delete then
				if x < #output+1 then
					repeat
						output = output:sub(1,x-1)..output:sub(x+1)
					until output:sub(x,x) == " " or (not ctrlDown) or (x == #output+1)
				end
			elseif key == keys.enter then
				termsetCursorBlink(false)
				return output
			elseif key == keys.home then
				x = 1
			elseif key == keys["end"] then
				x = #output+1
			elseif key == keys.up then
				if history[hPos-1] then
					hPos = hPos - 1
					output = history[hPos]
					x = #output+1
				end
			elseif key == keys.down then
				if history[hPos+1] then
					hPos = hPos + 1
					output = history[hPos]
					x = #output+1
				end
			end
		elseif evt[1] == "key_up" then
			if evt[2] == keys.leftCtrl then
				ctrlDown = false
			end
		end
		if hPos > 1 then
			history[hPos] = output
		end
		if x+cx-xscroll+xmod > scr_x then
			xscroll = x-(scr_x-cx)+xmod
		elseif x-xscroll+xmod < 0 then
			repeat
				xscroll = xscroll - 1
			until x-xscroll-xmod >= 0
		end
		xscroll = math.max(1, xscroll)
	end
end
_G.colorRead = colorRead

local checkValidName = function(_nayme)
	local nayme = textToBlit(_nayme,true)
	if type(nayme) ~= "string" then
		return false
	else
		return (#nayme >= 2 and #nayme <= 32 and nayme:gsub(" ","") ~= "")
	end
end

if tArg[1] == "update" then
	local res, message = updatesrc(tArg[2] == "beta")
	return print(message)
end

local prettyClearScreen = function(start, stop)
	termsetTextColor(colors.lightGray)
	termsetBackgroundColor(colors.gray)
	if _VERSION then
		for y = start or 1, stop or scr_y do
			termsetCursorPos(1,y)
			if y == (start or 1) then
				termwrite(("\135"):rep(scr_x))
			elseif y == (stop or scr_y) then
				termsetTextColor(colors.gray)
				termsetBackgroundColor(colors.lightGray)
				termwrite(("\135"):rep(scr_x))
			else
				termclearLine()
			end
		end
	else
		termclear()
	end
end

local cwrite = function(text, y)
	local cx, cy = termgetCursorPos()
	termsetCursorPos((scr_x/2) - math.ceil(#text/2), y or cy)
	return write(text)
end

local prettyCenterWrite = function(text, y)
	local words = explode(" ", text, nil, true)
	local buff = ""
	local lines = 0
	for w = 1, #words do
		if #buff + #words[w] > scr_x then
			cwrite(buff, y + lines)
			buff = ""
			lines = lines + 1
		end
		buff = buff..words[w]
	end
	cwrite(buff, y + lines)
	return lines
end

local prettyPrompt = function(prompt, y, replchar, doColor)
	local cy, cx = termgetCursorPos()
	termsetBackgroundColor(colors.gray)
	termsetTextColor(colors.white)
	local yadj = 1 + prettyCenterWrite(prompt, y or cy)
	termsetCursorPos(1, y + yadj)
	termsetBackgroundColor(colors.lightGray)
	termclearLine()
	local output
	if doColor then
		output = colorRead()
	else
		output = read(replchar)
	end
	return output
end

local fwrite = function(text)
	local b = textToBlit(text)
	return termblit(unpack(b))
end

local cfwrite = function(text, y)
	local cx, cy = termgetCursorPos()
	termsetCursorPos((scr_x/2) - math.ceil(#textToBlit(text,true)/2), y or cy)
	return fwrite(text)
end

if not checkValidName(yourName) then
	yourName = nil
end

local currentY = 2

if not (yourName and encKey) then
	prettyClearScreen()
end

if not yourName then
    cfwrite("&8~7Text = &, Hintergrund = ~", scr_y-3)
	cfwrite("&8~7&{Krazy = &k, Standard = &r", scr_y-2)
    cfwrite("&7~00~11~22~33~44~55~66&8~77&7~88~99~aa~bb~cc~dd~ee~ff", scr_y-1)
	yourName = prettyPrompt("BENUTZERNAME", currentY, nil, true)
	if not checkValidName(yourName) then
		while true do
			yourName = prettyPrompt("Versuchen sie es mit einem anderem Namen", currentY, nil, true)
			if checkValidName(yourName) then
				break
			end
		end
	end
	currentY = currentY + 3
end

if not encKey then
	setEncKey(prettyPrompt("SICHERHEITSCODE", currentY, "*"))
	currentY = currentY + 3
end

local oldePullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw

local bottomMessage = function(text)
	termsetCursorPos(1,scr_y)
	termsetTextColor(colors.gray)
	termclearLine()
	termwrite(text)
end

loadSettings()
saveSettings()

termsetBackgroundColor(colors.black)
termclear()

local getAPI = function(apiname, apipath, apiurl, doDoFile, doScroll)
	apipath = fs.combine(fs.combine(src.dataDir,"api"), apipath)
	if (not fs.exists(apipath)) then
		if doScroll then term.scroll(1) end
		bottomMessage(apiname .. " API nicht gefunden! Herunterladen...")
		local prog = http.get(apiurl)
		if not prog then
			if doScroll then term.scroll(1) end
			bottomMessage("Download fehlgeschlagen " .. apiname .. " API. Abbruch.")
			termsetCursorPos(1,1)
			return
		end
		local file = fs.open(apipath,"w")
		file.write(prog.readAll())
		file.close()
	end
	if doDoFile then
		return dofile(apipath)
	else
		os.loadAPI(apipath)
	end
	if not _ENV[fs.getName(apipath)] then
		if doScroll then term.scroll(1) end
		bottomMessage("Laden fehlgeschlagen " .. apiname .. " API. Abbruch.")
		termsetCursorPos(1,1)
		return
	else
		return _ENV[fs.getName(apipath)]
	end
end

local skynet, aes, bigfont
aes = getAPI("AES", "aes", "https://raw.githubusercontent.com/CMDW01F/API/System/System%20API/AES.lua", false, false)
if src.connectToSkynet and http.websocket then
	skynet = getAPI("Skynet", "skynet", "https://raw.githubusercontent.com/CMDW01F/API/System/Netzwerk%20API/SkyNet.lua", true, true)
end
bigfont = getAPI("BigFont", "bigfont", "https://raw.githubusercontent.com/CMDW01F/API/System/System%20API/BigFont.lua", false, true)

if encKey and skynet and src.connectToSkynet then
	bottomMessage("Verbinde mit SkyNet...")
	local success = parallel.waitForAny(
		function()
			skynet.open(src.skynetPort)
		end,
		function()
			sleep(3)
		end
	)
	if success == 2 then
		term.scroll(1)
		bottomMessage("Es konnte keine Verbindung zum SkyNet hergestellt werden.")
		skynet = nil
		sleep(0.5)
	end
end

local log = {}
local renderlog = {}
local IDlog = {}

local scroll = 0
local maxScroll = 0

local getModem = function()
	if src.ignoreModem then
		return nil
	else
		local modems = {peripheral.find("modem")}
		return modems[1]
	end
end

local getChatbox = function()
	if src.useChatbox then
		if commands then
			return {
				say = function(text)
					commands.tellraw("@a", textToBlit(text, false, "0", "f", nil, true))
				end,
				tell = function(player, text)
					commands.tellraw(player, textToBlit(text, false, "0", "f", nil, true))
				end
			}
		else
			local cb = chatbox or peripheral.find("chat_box")
			if cb then
				if cb.setName then
					cb.setName(yourName)
					return {
						say = cb.say,
						tell = cb.say
					}
				else
					return {
						say = function(text, block)
							if CHATBOX_SAFEMODE then
--								if CHATBOX_SAFEMODE ~= block then
									cb.tell(CHATBOX_SAFEMODE, text)
--								end
							else
								local players = cb.getPlayerList()
								for i = 1, #players do
									if players[i] ~= block then
										cb.tell(players[i], text)
									end
								end
							end
						end,
						tell = cb.tell
					}
				end
			else
				return nil
			end
		end
	else
		return nil
	end
end

local modem = getModem()
local chatbox = getChatbox()

if (not modem) and (not src.ignoreModem) then
	if ccemux and (not src.ignoreModem) then
		ccemux.attach("top", "wireless_modem")
		modem = getModem()
	elseif not skynet then
		error("Kein Modem verbunden.")
	end
end

if modem then modem.open(src.port) end

local modemTransmit = function(freq, repfreq, message)
	if modem then
		modem.transmit(freq, repfreq, message)
	end
end

local encrite = function(input)
	if not input then return input end
	return aes.encrypt(encKey, textutilsserialize(input))
end

local decrite = function(input)
	if not input then return input end
	return textutilsunserialize(aes.decrypt(encKey, input) or "")
end

local dab = function(func, ...)
	local x, y = termgetCursorPos()
	local b, t = termgetBackgroundColor(), termgetTextColor()
	local output = {func(...)}
	termsetCursorPos(x,y)
	termsetTextColor(t)
	termsetBackgroundColor(b)
	return unpack(output)
end

local splitStr = function(str, maxLength)
	local output = {}
	for l = 1, #str, maxLength do
		output[#output+1] = str:sub(l,l+maxLength+-1)
	end
	return output
end

local splitStrTbl = function(tbl, maxLength)
	local output, tline = {}
	for w = 1, #tbl do
		tline = splitStr(tbl[w], maxLength)
		for t = 1, #tline do
			output[#output+1] = tline[t]
		end
	end
	return output
end

local blitWrap = function(char, text, back, noWrite)
	local cWords = splitStrTbl(explode(" ",char,nil, true), scr_x)
	local tWords = splitStrTbl(explode(" ",char,text,true), scr_x)
	local bWords = splitStrTbl(explode(" ",char,back,true), scr_x)

	local ox,oy = termgetCursorPos()
	local cx,cy,ty = ox,oy,1
	local output = {}
	local length = 0
	local maxLength = 0
	for a = 1, #cWords do
		length = length + #cWords[a]
		maxLength = mathmax(maxLength, length)
		if ((cx + #cWords[a]) > scr_x) then
			cx = 1
			length = 0
			if (cy == scr_y) then
				term.scroll(1)
			end
			cy = mathmin(cy+1, scr_y)
			ty = ty + 1
		end
		if not noWrite then
			termsetCursorPos(cx,cy)
			termblit(cWords[a],tWords[a],bWords[a])
		end
		cx = cx + #cWords[a]
		output[ty] = output[ty] or {"","",""}
		output[ty][1] = output[ty][1]..cWords[a]
		output[ty][2] = output[ty][2]..tWords[a]
		output[ty][3] = output[ty][3]..bWords[a]
	end
	return output, maxLength
end

local pictochat = function(xsize, ysize)
	local output = {{},{},{}}
	local maxWidth, minMargin = 0, math.huge
	for y = 1, ysize do
		output[1][y] = {}
		output[2][y] = {}
		output[3][y] = {}
		for x = 1, xsize do
			output[1][y][x] = " "
			output[2][y][x] = " "
			output[3][y][x] = " "
		end
	end

	termsetBackgroundColor(colors.gray)
	termsetTextColor(colors.black)
	for y = 1, scr_y do
		termsetCursorPos(1, y)
		termwrite(("/"):rep(scr_x))
	end
	cwrite(" [ENTER] zum beenden. ", scr_y)
	cwrite("Tastendruck, um Zeichen zu wechseln.", scr_y-1)

	local cx, cy = math.floor((scr_x/2)-(xsize/2)), math.floor((scr_y/2)-(ysize/2))

	local allCols = "0123456789abcdef"
	local tPos, bPos = 16, 1
	local char, text, back = " ", allCols:sub(tPos,tPos), allCols:sub(bPos,bPos)

	local render = function()
		termsetTextColor(colors.white)
		termsetBackgroundColor(colors.black)
		local mx, my
		for y = 1, ysize do
			for x = 1, xsize do
				mx, my = x+cx+-1, y+cy+-1
				termsetCursorPos(mx,my)
				termblit(output[1][y][x], output[2][y][x], output[3][y][x])
			end
		end
		termsetCursorPos((scr_x/2)-5,ysize+cy+1)
		termwrite("Char = '")
		termblit(char, text, back)
		termwrite("'")
	end
	local evt, butt, mx, my
	local isShiftDown = false

	render()

	while true do
		evt = {os.pullEvent()}
		if evt[1] == "mouse_click" or evt[1] == "mouse_drag" then
			butt, mx, my = evt[2], evt[3]-cx+1, evt[4]-cy+1
			if mx >= 1 and mx <= xsize and my >= 1 and my <= ysize then
				if butt == 1 then
					output[1][my][mx] = char
					output[2][my][mx] = text
					output[3][my][mx] = back
				elseif butt == 2 then
					output[1][my][mx] = " "
					output[2][my][mx] = " "
					output[3][my][mx] = " "
				end
				render()
			end
		elseif evt[1] == "mouse_scroll" then
			local oldTpos, oldBpos = tPos, bPos
			if isShiftDown then
				tPos = mathmax(1, mathmin(16, tPos + evt[2]))
			else
				bPos = mathmax(1, mathmin(16, bPos + evt[2]))
			end
			text, back = stringsub(allCols,tPos,tPos), stringsub(allCols,bPos,bPos)
			if oldTpos ~= tPos or oldBpos ~= bPos then
				render()
			end
		elseif evt[1] == "key" then
			if evt[2] == keys.enter then
				for y = 1, ysize do
					output[1][y] = table.concat(output[1][y])
					output[2][y] = table.concat(output[2][y])
					output[3][y] = table.concat(output[3][y])
					maxWidth  = math.max(maxWidth,  #stringgsub(output[3][y], " +$", ""))
					minMargin = math.min(minMargin, output[3][y]:find("[^ ]") or math.huge)
				end
				local croppedOutput = {}
				local touched = false
				local crY = 0
				for a = 1, ysize do
					if output[1][1] == (" "):rep(xsize) and output[3][1] == (" "):rep(xsize) then
						tableremove(output[1],1)
						tableremove(output[2],1)
						tableremove(output[3],1)
					else
						for y = #output[1], 1, -1 do
							if output[1][y] == (" "):rep(xsize) and output[3][y] == (" "):rep(xsize) then
								tableremove(output[1],y)
								tableremove(output[2],y)
								tableremove(output[3],y)
							else
								break
							end
						end
						break
					end
				end
				for y = 1, #output[1] do
					output[1][y] = output[1][y]:sub(minMargin, maxWidth)
					output[2][y] = output[2][y]:sub(minMargin, maxWidth)
					output[3][y] = output[3][y]:sub(minMargin, maxWidth)
				end
				return output
			elseif evt[2] == keys.leftShift then
				isShiftDown = true
			elseif evt[2] == keys.left or evt[2] == keys.right then
				local oldTpos, oldBpos = tPos, bPos
				if isShiftDown then
					tPos = mathmax(1, mathmin(16, tPos + (evt[2] == keys.right and 1 or -1)))
				else
					bPos = mathmax(1, mathmin(16, bPos + (evt[2] == keys.right and 1 or -1)))
				end
				text, back = allCols:sub(tPos,tPos), allCols:sub(bPos,bPos)
				if oldTpos ~= tPos or oldBpos ~= bPos then
					render()
				end
			end
		elseif evt[1] == "key_up" then
			if evt[2] == keys.leftShift then
				isShiftDown = false
			end
		elseif evt[1] == "char" then
			if char ~= evt[2] then
				char = evt[2]
				render()
			end
		end
	end
end

local notif = {}
notif.alpha = 248
notif.height = 10
notif.width = 6
notif.time = 40
notif.wrapX = 350
notif.maxNotifs = 15
local nList = {}
local colorTranslate = {
	[" "] = {240, 240, 240},
	["0"] = {240, 240, 240},
	["1"] = {242, 178, 51 },
	["2"] = {229, 127, 216},
	["3"] = {153, 178, 242},
	["4"] = {222, 222, 108},
	["5"] = {127, 204, 25 },
	["6"] = {242, 178, 204},
	["7"] = {76,  76,  76 },
	["8"] = {153, 153, 153},
	["9"] = {76,  153, 178},
	["a"] = {178, 102, 229},
	["b"] = {51,  102, 204},
	["c"] = {127, 102, 76 },
	["d"] = {87,  166, 78 },
	["e"] = {204, 76,  76 },
	["f"] = {25,  25,  25 }
}
local interface, canvas = peripheral.find("neuralInterface")
if interface then
	if interface.canvas then
		canvas = interface.canvas()
		notif.newNotification = function(char, text, back, time)
			if #nList > notif.maxNotifs then
				tableremove(nList, 1)
			end
			nList[#nList+1] = {char,text,back,time,1}
		end
		notif.displayNotifications = function(doCountDown)
			local adjList = {
				["i"] = -4,
				["l"] = -3,
				["I"] = -1,
				["t"] = -2,
				["k"] = -1,
				["!"] = -4,
				["|"] = -4,
				["."] = -4,
				[","] = -4,
				[":"] = -4,
				[";"] = -4,
				["f"] = -1,
				["'"] = -3,
				["\""] = -1,
				["<"] = -1,
				[">"] = -1,
			}
			local drawEdgeLine = function(y,alpha)
				local l = canvas.addRectangle(notif.wrapX, 1+(y-1)*notif.height, 1, notif.height)
				l.setColor(unpack(colorTranslate["0"]))
				l.setAlpha(alpha / 2)
			end
			local getWordWidth = function(str)
				local output = 0
				for a = 1, #str do
					output = output + notif.width + (adjList[stringsub(str,a,a)] or 0)
				end
				return output
			end
			canvas.clear()
			local xadj, charadj, wordadj, t, r
			local x, y, words, txtwords, bgwords = 0, 0
			for n = 1, mathmin(#nList, notif.maxNotifs) do
				xadj, charadj = 0, 0
				y = y + 1
				x = 0
				words = explode(" ",nList[n][1],nil,true)
				txtwords = explode(" ",nList[n][1],nList[n][2],true)
				bgwords = explode(" ",nList[n][1],nList[n][3],true)
				local char, text, back
				local currentX = 0
				for w = 1, #words do
					char = words[w]
					text = txtwords[w]
					back = bgwords[w]
					if currentX + getWordWidth(char) > notif.wrapX then
						y = y + 1
						x = 2
						xadj = 0
						currentX = x * notif.width
					end
					for cx = 1, #char do
						x = x + 1
						charadj = (adjList[stringsub(char,cx,cx)] or 0)
						r = canvas.addRectangle(xadj+1+(x-1)*notif.width, 1+(y-1)*notif.height, charadj+notif.width, notif.height)
						if stringsub(back,cx,cx) ~= " " then
							r.setAlpha(notif.alpha * nList[n][5])
							r.setColor(unpack(colorTranslate[stringsub(back,cx,cx)]))
						else
							r.setAlpha(100 * nList[n][5])
							r.setColor(unpack(colorTranslate["7"]))
						end
						drawEdgeLine(y,notif.alpha * nList[n][5])
						t = canvas.addText({xadj+1+(x-1)*notif.width,2+(y-1)*notif.height}, stringsub(char,cx,cx))
						t.setAlpha(notif.alpha * nList[n][5])
						t.setColor(unpack(colorTranslate[stringsub(text,cx,cx)]))
						xadj = xadj + charadj
						currentX = currentX + charadj+notif.width
					end
				end
			end
			for n = mathmin(#nList, notif.maxNotifs), 1, -1 do
				if doCountDown then
					if nList[n][4] > 1 then
						nList[n][4] = nList[n][4] - 1
					else
						if nList[n][5] > 0 then
							while true do
								nList[n][5] = mathmax(nList[n][5] - 0.2, 0)
								notif.displayNotifications(false)
								if nList[n][5] == 0 then break else sleep(0.05) end
							end
						end
						tableremove(nList,n)
					end
				end
			end
		end
	end
end

local darkerCols = {
	["0"] = "8",
	["1"] = "c",
	["2"] = "a",
	["3"] = "b",
	["4"] = "1",
	["5"] = "d",
	["6"] = "2",
	["7"] = "f",
	["8"] = "7",
	["9"] = "b",
	["a"] = "7",
	["b"] = "7",
	["c"] = "f",
	["d"] = "7",
	["e"] = "7",
	["f"] = "f"
}

local animations = {
	slideFromLeft = function(char, text, back, frame, maxFrame, length)
		return {
			stringsub(char, (length or #char) - ((frame/maxFrame)*(length or #char))),
			stringsub(text, (length or #text) - ((frame/maxFrame)*(length or #text))),
			stringsub(back, (length or #back) - ((frame/maxFrame)*(length or #back)))
		}
	end,
	fadeIn = function(char, text, back, frame, maxFrame, length)
		for i = 1, 3 - math.ceil(frame/maxFrame * 3) do
			text = stringgsub(text, ".", darkerCols)
		end
		return {
			char,
			text,
			back
		}
	end,
	flash = function(char, text, back, frame, maxFrame, length)
		local t = palette.txt
		if frame ~= maxFrame then
			t = (frame % 2 == 0) and t or palette.bg
		end
		return {
			char,
			toblit[t]:rep(#text),
			(frame % 2 == 0) and back or (" "):rep(#back)
		}
	end,
	none = function(char, text, back, frame, maxFrame, length)
		return {
			char,
			text,
			back
		}
	end
}

local inAnimate = function(animType, buff, frame, maxFrame, length)
	local char, text, back = buff[1], buff[2], buff[3]
	if srcSettings.doAnimate and (frame >= 0) and (maxFrame > 0) then
		return animations[animType or "slideFromleft"](char, text, back, frame, maxFrame, length)
	else
		return {char,text,back}
	end
end

local genRenderLog = function()
	local buff, prebuff, maxLength, lastUser
	local scrollToBottom = scroll == maxScroll
	renderlog = {}
	local dcName, dcMessage
	for a = 1, #log do
		if not ((lastUser == log[a].personalID and log[a].personalID) and log[a].name == "" and log[a].message == " ") then
			termsetCursorPos(1,1)
			if UIconf.nameDecolor then
				if lastUser == log[a].personalID and log[a].personalID then
					dcName = ""
				else
					dcName = textToBlit(table.concat({log[a].prefix,log[a].name,log[a].suffix}), true, toblit[palette.txt], toblit[palette.bg])
				end
				dcMessage = textToBlit(log[a].message, false, toblit[palette.txt], toblit[palette.bg])
				prebuff = {
					dcName..dcMessage[1],
					toblit[palette.chevron]:rep(#dcName)..dcMessage[2],
					toblit[palette.bg]:rep(#dcName)..dcMessage[3]
				}
			else
				if lastUser == log[a].personalID and log[a].personalID then
					prebuff = textToBlit(" " .. log[a].message, false, toblit[palette.txt], toblit[palette.bg])
				else
					prebuff = textToBlit(table.concat({
						log[a].prefix,
						"&}&r~r",
						log[a].name,
						"&}&r~r",
						log[a].suffix,
						"&}&r~r",
						log[a].message
					}),
					false, toblit[palette.txt], toblit[palette.bg])
				end
			end
			if log[a].message ~= " " and srcSettings.noRepeatNames then
				lastUser = log[a].personalID
			end
			if (log[a].frame == 0) and (canvas and srcSettings.doNotif) then
				if not (log[a].name == "" and log[a].message == " ") then
					notif.newNotification(prebuff[1], prebuff[2], prebuff[3], notif.time * 4)
				end
			end
			if log[a].maxFrame == true then
				log[a].maxFrame = math.floor(mathmin(#prebuff[1], scr_x) / srcSettings.animDiv)
			end
			if log[a].ignoreWrap then
				buff, maxLength = {prebuff}, mathmin(#prebuff[1], scr_x)
			else
				buff, maxLength = blitWrap(prebuff[1], prebuff[2], prebuff[3], true)
			end
			for l = 1, #buff do
				if log[a].animType then
					renderlog[#renderlog + 1] = inAnimate(log[a].animType, buff[l], log[a].frame, log[a].maxFrame, maxLength)
				else
					renderlog[#renderlog + 1] = inAnimate("fadeIn", inAnimate("slideFromLeft", buff[l], log[a].frame, log[a].maxFrame, maxLength), log[a].frame, log[a].maxFrame, maxLength)
				end
			end
			if (log[a].frame < log[a].maxFrame) and log[a].frame >= 0 then
				log[a].frame = log[a].frame + 1
			else
				log[a].frame = -1
			end
		end
	end
	maxScroll = mathmax(0, #renderlog - (scr_y - 2))
	if scrollToBottom then
		scroll = maxScroll
	end
end

local tsv = function(visible)
	if term.current().setVisible and srcSettings.useSetVisible then
		return term.current().setVisible(visible)
	end
end

local renderChat = function(doScrollBackUp)
	tsv(false)
	termsetCursorBlink(false)
	genRenderLog(log)
	local ry
	termsetBackgroundColor(palette.bg)
	for y = UIconf.chatlogTop, (scr_y-UIconf.promptY) - 1 do
		ry = (y + scroll - (UIconf.chatlogTop - 1))
		termsetCursorPos(1,y)
		termclearLine()
		if renderlog[ry] then
			termblit(unpack(renderlog[ry]))
		end
	end
	if UIconf.promptY ~= 0 then
		termsetCursorPos(1,scr_y)
		termsetTextColor(palette.scrollMeter)
		termclearLine()
		termwrite(scroll.." / "..maxScroll.."  ")
	end

	local _title = UIconf.title:gsub("YOURNAME", yourName.."&}&r~r"):gsub("ENCKEY", encKey.."&}&r~r"):gsub("PORT", tostring(src.port))
	if UIconf.doTitle then
		termsetTextColor(palette.title)
		term.setBackgroundColor(palette.titlebg)
		if UIconf.nameDecolor then
			if UIconf.centerTitle then
				cwrite((" "):rep(scr_x)..textToBlit(_title, true)..(" "):rep(scr_x), UIconf.titleY or 1)
			else
				termsetCursorPos(1, UIconf.titleY or 1)
				termwrite(textToBlit(_title, true)..(" "):rep(scr_x))
			end
		else
			local blTitle = textToBlit(_title)
			termsetCursorPos(UIconf.centerTitle and ((scr_x/2) - math.ceil(#blTitle[1]/2)) or 1, UIconf.titleY or 1)
			termclearLine()
			termblit(unpack(blTitle))
		end
	end
	termsetCursorBlink(true)
	tsv(true)
end

local logadd = function(name, message, animType, maxFrame, ignoreWrap, _personalID)
	log[#log + 1] = {
		prefix = name and UIconf.prefix or "",
		suffix = name and UIconf.suffix or "",
		name = name or "",
		message = message or " ",
		ignoreWrap = ignoreWrap,
		frame = 0,
		maxFrame = maxFrame or true,
		animType = animType,
		personalID = _personalID
	}
end

local logaddTable = function(name, message, animType, maxFrame, ignoreWrap, _personalID)
	if type(message) == "table" and type(name) == "string" then
		if #message > 0 then
			local isGood = true
			for l = 1, #message do
				if type(message[l]) ~= "string" then
					isGood = false
					break
				end
			end
			if isGood then
				logadd(name, message[1], animType, maxFrame, ignoreWrap, _personalID)
				for l = 2, #message do
					logadd(nil, message[l], animType, maxFrame, ignoreWrap, _personalID)
				end
			end
		end
	end
end

local srcSend = function(name, message, option, doLog, animType, maxFrame, crying, recipient, ignoreWrap, omitPersonalID)
	option = option or {}
	if option.doLog then
		if type(message) == "string" then
			logadd(name, message, option.animType, option.maxFrame, option.ignoreWrap, (not option.omitPersonalID) and personalID)
		else
			logaddTable(name, message, option.animType, option.maxFrame, option.ignoreWrap, (not option.omitPersonalID) and personalID)
		end
	end
	local messageID = makeRandomString(64)
	local outmsg = encrite({
		name = name,
		message = message,
		animType = option.animType,
		maxFrame = option.maxFrame,
		messageID = messageID,
		recipient = option.recipient,
		ignoreWrap = option.ignoreWrap,
		personalID = (not option.omitPersonalID) and personalID,
		cry = option.crying,
		simCommand = option.simCommand,
		simArgument = option.simArgument,
	})
	IDlog[messageID] = true
	if not src.ignoreModem then
		modemTransmit(src.port, src.port, outmsg)
	end
	if skynet and srcSettings.useSkynet then
		skynet.send(src.skynetPort, outmsg)
	end
end

local cryOut = function(name, crying)
	srcSend(name, nil, {crying = crying})
end

local getPictureFile = function(path)
	if not fs.exists(path) then
		return false, "Bild nicht gefunden."
	else
		local file = fs.open(path,"r")
		local content = file.readAll()
		file.close()
		local output
		if content:find("\31") and content:find("\30") then
			output = explode("\n",content:gsub("\31","&"):gsub("\30","~"),nil,false)
		else
			if content:lower():gsub("[0123456789abcdef\n ]","") ~= "" then
				return false, "Kein Bild."
			else
				output = explode("\n",content:gsub("[^\n]","~%1 "),nil,false)
			end
		end
		return output
	end
end

local getTableLength = function(tbl)
	local output = 0
	for k,v in pairs(tbl) do
		output = output + 1
	end
	return output
end

local userCryList = {}

local commandInit = "/"
local commands = {}
local simmableCommands = {
	big = true
}
commands.info = function()
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	logadd(nil,"SecureRadioCom v."..src.version.." von [REDACTED]")
	logadd(nil,"Gesichertes und Dezentralisiertes Netzwerk")
	logadd(nil,nil)
	logadd(nil,"AES Lua Impl. von SquidDev")
	logadd(nil,"HTTP 'Skynet' von gollark (osmarks)")
end
commands.exit = function()
	srcSend("*", "'"..yourName.."&}&r~r' hat sich abgemeldet.")
	return "exit"
end
commands.me = function(msg)
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if msg then
		srcSend("&2*", yourName.."~r&2 "..msg, {doLog = true})
	else
		logadd("*",commandInit.."me [message]")
	end
end
commands.tron = function()
  local url = "https://raw.githubusercontent.com/LDDestroier/CC/master/tron.lua"
  local prog, contents = http.get(url)
  if prog then
    srcSend("*", yourName .. "&}&r~r hat eine Partie TRON gestartet.", {doLog = true})
    contents = prog.readAll()
    pauseRendering = true
    prog = load(contents, nil, nil, _ENV)(srcSettings.useSkynet and "skynet", "quick", yourName)
  else
    logadd("*", "TRON konnte nicht heruntergeladen werden.")
  end
  pauseRendering = false
  doRender = true
end
commands.colors = function()
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	logadd("*", "&{Farbcodes: (Nutze & oder ~)&}")
	logadd(nil, " &7~11~22~33~44~55~66~7&87~8&78~99~aa~bb~cc~dd~ee~ff")
	logadd(nil, " &{Standard mit &r und ~r.&}")
	logadd(nil, " &{&k for krazy text.&}")
end
commands.update = function()
	local res, message = updatesrc()
	if res then
		srcSend("*", yourName.."&}&r~r wurde aktualisiert und beendet.")
		termsetBackgroundColor(colors.black)
		termsetTextColor(colors.white)
		termclear()
		termsetCursorPos(1,1)
		print(message)
		return "exit"
	else
		logadd("*", res)
	end
end
commands.picto = function(filename)
	local image, output, res
	local isEmpty
	if filename then
		output, res = getPictureFile(filename)
		if not output then
			logadd("*",res)
			logadd(nil,nil)
			return
		else
			tableinsert(output,1,"")
		end
	else
		isEmpty = true
		output = {""}
		pauseRendering = true
		local image = pictochat(26,11)
		pauseRendering = false
		for y = 1, #image[1] do
			output[#output+1] = ""
			for x = 1, #image[1][1] do
				output[#output] = table.concat({
					output[#output],
					"&",
					image[2][y]:sub(x,x),
					"~",
					image[3][y]:sub(x,x),
					image[1][y]:sub(x,x)
				})
				isEmpty = isEmpty and (image[1][y]:sub(x,x) == " " and image[3][y]:sub(x,x) == " ")
			end
		end
	end
	if not isEmpty then
		srcSend(yourName, output, {doLog = true, animType = "slideFromLeft", ignoreWrap = true})
	end
end
commands.list = function()
	userCryList = {}
	local tim = os.startTimer(0.5)
	cryOut(yourName, true)
	while true do
		local evt = {os.pullEvent()}
		if evt[1] == "timer" then
			if evt[2] == tim then
				break
			end
		end
	end
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if getTableLength(userCryList) == 0 then
		logadd(nil,"Niemand ist Online.")
	else
		for k,v in pairs(userCryList) do
			logadd(nil,"+'"..k.."'")
		end
	end
end
commands.nick = function(newName)
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if newName then
		if checkValidName(newName) then
			if newName == yourName then
				logadd("*","Du hast bereits diesen Benutzernamen.")
			else
				srcSend("*", "'"..yourName.."&}&r~r' ist jetzt bekannt als '"..newName.."&}&r~r'.", {doLog = true})
				yourName = newName
			end
		else
			if #newName < 2 then
				logadd("*", "Zu Kurz.")
			elseif #newName > 32 then
				logadd("*", "Zu Lang.")
			end
		end
	else
		logadd("*",commandInit.."nick [newName]")
	end
end
commands.whoami = function(now)
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if now == "now" then
		logadd("*","Du bist immer noch '"..yourName.."&}&r~r'!")
	else
		logadd("*","Du bist '"..yourName.."&}&r~r'!")
	end
end
commands.key = function(newKey)
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if newKey then
		if newKey ~= encKey then
			srcSend("*", "'"..yourName.."&}&r~r' hat sich abgemeldet.")
			setEncKey(newKey)
			logadd("*", "Test gewechselt zu '"..encKey.."&}&r~r'.")
			srcSend("*", "'"..yourName.."&}&r~r' hat sich eingeloggt.", {omitPersonalID = true})
		else
			logadd("*", "Taste bereits zugewiesen")
		end
	else
		logadd("*","Sicherheitscode = '"..encKey.."&}&r~r'")
		logadd("*","Kanal = '"..src.port.."'")
	end
end
commands.shrug = function(face)
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	srcSend(yourName, "¯\\_"..(face and ("("..face..")") or "\2").."_/¯", {doLog = true})
end
commands.asay = function(_argument)
	local sPoint = (_argument or ""):find(" ")
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if not sPoint then
		logadd("*","Animation:")
		for k,v in pairs(animations) do
			logadd(nil," '"..k.."'")
		end
	else
		local animType = _argument:sub(1,sPoint-1)
		local message = _argument:sub(sPoint+1)
		local animFrameMod = {
			flash = 8,
			fadeIn = 4,
		}
		if animations[animType] then
			if textToBlit(message,true):gsub(" ","") ~= "" then
				srcSend(yourName, message, {doLog = true, animType = animType, maxFrame = animFrameMod[animType]})
			else
				logadd("*","Nachricht wurde abgelehnt.")
			end
		else
			logadd("*","Animation nicht gefunden.")
		end
	end
end
commands.big = function(_argument, simUser)
	local sPoint = (_argument or ""):find(" ")
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if not sPoint then
		logadd("*",commandInit .. "big <size> <text>")
	else
		local fontSize = tonumber(_argument:sub(1,sPoint-1))
		local message = _argument:sub(sPoint+1)
		if not fontSize then
			logadd("*","Muss eine Nummer zwischen 0 und 2 sein.")
		elseif fontSize < 0 or fontSize > 2 then
			logadd("*","Muss eine Nummer zwischen 0 und 2 sein.")
		else
			fontSize = math.floor(.5+fontSize)
			local tOutput
			if fontSize > 0 then
				message = textToBlit(message, false, "0", "f")
				local output = {{},{},{}}
				local x, y = 1, 1
				local char
				for i = 1, #message[1] do
					char = bigfont.makeBlittleText(
						fontSize,
						stringsub(message[1],i,i),
						stringsub(message[2],i,i),
						stringsub(message[3],i,i)
					)
					x = x + char.width
					if x >= scr_x then
						y = y + char.height
						x = char.width
					end
					for charY = 1, char.height do
						output[1][y+charY-1] = (output[1][y+charY-1] or " ") .. char[1][charY]
						output[2][y+charY-1] = (output[2][y+charY-1] or " ") .. char[2][charY]
						output[3][y+charY-1] = (output[3][y+charY-1] or " ") .. char[3][charY]
					end
				end
				tOutput = {""}
				local yy = 1
				for y = 1, #output[1] do
					tOutput[#tOutput+1] = ""
					for x = 1, #output[1][y] do
						tOutput[#tOutput] = table.concat({tOutput[#tOutput],"&",output[2][yy]:sub(x,x),"~",output[3][yy]:sub(x,x),output[1][yy]:sub(x,x)})
					end
					yy = yy + 1
				end
			else
				tOutput = message
			end
			if simUser then
				logaddTable(simUser, tOutput)
			else
				logaddTable(yourName, tOutput)
				srcSend(yourName, nil, {simCommand = "big", simArgument = _argument})
			end
		end
	end
end
commands.msg = function(_argument)
	local sPoint = (_argument or ""):find(" ")
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if not sPoint then
		logadd("*",commandInit.."msg <Empfang> <Nachricht>")
	else
		local recipient = _argument:sub(1,sPoint-1)
                local message = _argument:sub(sPoint+1)
		if not message then
			logadd("*","Nicht alle Argumente korrekt.")
		else
			if textToBlit(message,true):gsub(" ","") == "" then
				logadd("*","Nachricht wurde abgelehnt.")
			else
				srcSend(yourName, message, {recipient = recipient})
				logadd("*","an '"..recipient.."': "..message)
			end
		end
	end
end
commands.palette = function(_argument)
	local argument = _argument or ""
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if argument:gsub("%s","") == "" then
		local buff = ""
		for k,v in pairs(palette) do
			buff = buff..k..", "
		end
		buff = buff:sub(1,-3)
		logadd("*",commandInit.."palette "..buff.." <colorcode>")
	else
		argument = explode(" ",argument)
		if #argument == 1 then
			if argument[1]:gsub("%s",""):lower() == "reset" or argument[1]:gsub("%s",""):lower() == "SRC" then
				palette = {
					bg = colors.black,
					txt = colors.white,
					promptbg = colors.gray,
					prompttxt = colors.white,
					scrollMeter = colors.lightGray,
					chevron = colors.black,
					title = colors.lightGray,
					titlebg = colors.gray,
				}
				UIconf = {
					promptY = 1,
					chevron = ">",
					chatlogTop = 1,
					title = "SecureRadioCom",
					doTitle = false,
					titleY = 1,
					nameDecolor = false,
					centerTitle = true,
					prefix = "<",
					suffix = "> "
				}
				termsetBackgroundColor(palette.bg)
				termclear()
				logadd("*","Du nutzt jetzt die SRC Palette.")
				saveSettings()
			elseif argument[1]:gsub("%s",""):lower() == "SRC2" then
				palette = {
					bg = colors.gray,
					txt = colors.white,
					promptbg = colors.white,
					prompttxt = colors.black,
					scrollMeter = colors.white,
					chevron = colors.lightGray,
					title = colors.yellow,
					titlebg = colors.gray,
				}
				UIconf = {
					promptY = 1,
					chevron = ">",
					chatlogTop = 1,
					title = "SecureRadioCom",
					doTitle = false,
					titleY = 1,
					nameDecolor = false,
					centerTitle = false,
					prefix = "<",
					suffix = "> "
				}
				termsetBackgroundColor(palette.bg)
				termclear()
				logadd("*","Du nutzt jetzt die SRC2 Palette.")
				saveSettings()
			elseif argument[1]:gsub("%s",""):lower() == "chat.lua" then
				palette = {
					bg = colors.black,
					txt = colors.white,
					promptbg = colors.black,
					prompttxt = colors.white,
					scrollMeter = colors.white,
					chevron = colors.yellow,
					title = colors.yellow,
					titlebg = colors.black,
				}
				UIconf = {
					promptY = 0,
					chevron = ": ",
					chatlogTop = 2,
					title = "YOURNAME auf ENCKEY",
					doTitle = false,
					titleY = 1,
					nameDecolor = true,
					centerTitle = true,
					prefix = "<",
					suffix = "> "
				}
				termsetBackgroundColor(palette.bg)
				termclear()
				logadd("*","DU nutzt jetzt die/rom/programs/rednet/chat.lua Palette.")
				saveSettings()
			elseif argument[1]:gsub("%s",""):lower() == "SRC-Talk" then
				palette = {
					bg = colors.black,
					txt = colors.white,
					promptbg = colors.black,
					prompttxt = colors.white,
					scrollMeter = colors.white,
					chevron = colors.white,
					title = colors.black,
					titlebg = colors.white,
				}
				UIconf = {
					promptY = 0,
					chevron = "",
					chatlogTop = 1,
					title = " SecureRadioCom    Kannal: ENCKEY:PORT",
					titleY = scr_y - 1,
					doTitle = false,
					nameDecolor = false,
					centerTitle = false,
					prefix = "<",
					suffix = "> "
				}
				termsetBackgroundColor(palette.bg)
				termclear()
				logadd("*","Du nutzt jetzt die SRC-Talk Palette")
				saveSettings()
			elseif argument[1]:gsub("%s",""):lower() == "SRC-Dark" then
				palette = {
					bg = colors.black,
					txt = colors.white,
					promptbg = colors.black,
					prompttxt = colors.white,
					scrollMeter = colors.white,
					chevron = colors.white,
					title = colors.white,
					titlebg = colors.blue,
				}
				UIconf = {
					promptY = 0,
					chevron = "Nachricht: ",
					chatlogTop = 1,
					title = "<Nutzer: YOURNAME> <Kannal: ENCKEY>",
					titleY = scr_y - 1,
					doTitle = false,
					nameDecolor = false,
					centerTitle = true,
					prefix = "",
					suffix = ": "
				}
				termsetBackgroundColor(palette.bg)
				termclear()
				logadd("*","Du nutzt jetzt die SRC-Dark Palette.")
				saveSettings()
			else
				if not palette[argument[1]] then
					logadd("*","Es gibt keine solche Palettenoption.")
				else
					logadd("*","'"..argument[1].."' = '"..toblit[palette[argument[1]]].."'")
				end
			end
		else
			if #argument > 2 then
				argument = {argument[1], table.concat(argument," ",2)}
			end
			argument[1] = argument[1]:lower()
			local newcol = argument[2]:lower()
			if not palette[argument[1]] then
				logadd("*","Das ist keine korrekte Palettenauswahl.")
			else
				if not (tocolors[newcol] or colors_strnames[newcol]) then
					logadd("*","Kein korrekter Farbcode. (0-f)")
				else
					palette[argument[1]] = (tocolors[newcol] or colors_strnames[newcol])
					logadd("*","Palette gewechselt.",false)
					saveSettings()
				end
			end
		end
	end
end
commands.clear = function()
	log = {}
	IDlog = {}
end
commands.ping = function(pong)
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	logadd(nil, pong or "Pong!")
end
commands.set = function(_argument)
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	argument = _argument or ""
	local collist = {
		["string"] = function() return "0" end,
		["table"] = function() return "5" end,
		["number"] = function() return "0" end,
		["boolean"] = function(val) if val then return "d" else return "e" end end,
		["function"] = function() return "c" end,
		["nil"] = function() return "8" end,
		["thread"] = function() return "d" end,
		["userdata"] = function() return "c" end, -- ha
	}
	local custColorize = function(input)
		return "&"..collist[type(input)](input)
	end
	local contextualQuote = function(judgetxt,txt)
		if type(judgetxt) == "string" then
			return table.concat({"'",txt,"'"})
		else
			return txt
		end
	end
	local arguments = explode(" ",argument)
	if #argument == 0 then
		for k,v in pairs(srcSettings) do
			logadd(nil,"&4'"..k.."'&r = "..contextualQuote(v,custColorize(v)..tostring(v).."&r"))
		end
	else
		if srcSettings[arguments[1]] ~= nil then
			if #arguments >= 2 then
				local newval = table.concat(arguments," ",2)
				if tonumber(newval) then
					newval = tonumber(newval)
				elseif textutilsunserialize(newval) ~= nil then
					newval = textutilsunserialize(newval)
				end
				if type(srcSettings[arguments[1]]) == type(newval) then
					srcSettings[arguments[1]] = newval
					logadd("*","Setze '&4"..arguments[1].."&r' auf &{"..contextualQuote(newval,textutilsserialize(newval).."&}").." ("..type(newval)..")")
					saveSettings()
				else
					logadd("*","Falscher Werttyp (es ist "..type(srcSettings[arguments[1]])..")")
				end
			else
				logadd("*","'"..arguments[1].."' ist eingestellt auf "..contextualQuote(srcSettings[arguments[1]],custColorize(srcSettings[arguments[1]])..textutilsserialize(srcSettings[arguments[1]]).."&r").." ("..type(srcSettings[arguments[1]])..")")
			end
		else
			logadd("*","Unbekannte Einstellung.")
		end
	end
	if srcSettings.useSkynet and (not skynet) then
		pauseRendering = true
		termsetBackgroundColor(colors.black)
		termclear()
		pauseRendering = false
	end
end
commands.help = function(cmdname)
	if srcSettings.extraNewline then
		logadd(nil,nil)
	end
	if cmdname then
		local helpList = {
			exit = "Beendet SRC",
			info = "SRC Informationen wie Version, Autor, etc.",
			me = "Sendet eine Nachricht im Format \"* deinName Nachricht\"",
			colors = "Listet alle Farben auf, die du verwenden kannst.",
			update = "Aktualisiert SRC und beendet es bei Erfolg.",
			list = "Listet alle Benutzer im Bereich auf, die denselben Sicherheitscode verwenden.",
			nick = "Gibt dir einen anderen Benutzernamen.",
			whoami = "Zeigt Ihnen Ihren aktuellen Benutzernamen an.",
			key = "Wechselt den aktuellen Sicherheitscode. Sagt Ihnen den Code, wenn ohne Argument.",
			clear = "Reinigt das lokale Chatprotokoll.",
			ping = "Pong.",
			shrug = "Sendet ein Achselzucken-Emoticon.",
			set = "Wechselt Konfigurationsoptionen der aktuellen Sitzung. Listet alle Optionen auf, sofern keine Argumente vorhanden sind.",
			msg = "Sendet eine Nachricht, die nur von einem bestimmten Benutzer protokolliert wird.",
			picto = "Zeigt einen Image Maker und sendet das Ergebnis.",
			tron = "Startet eine TRON-Partie.",
			big = "Sendet Ihre Nachricht, jedoch erweitert um einen bestimmten Betrag über die BigFont-API.",
			help = "Zeigt jeden Befehl an oder beschreibt einen bestimmten Befehl.",
		}
		cmdname = cmdname:gsub(" ",""):gsub("/","")
		if helpList[cmdname] then
			logadd("*", helpList[cmdname])
		else
			if commands[cmdname] then
				logadd("*", "Befehl hat keine Hilfsinformationen.")
			else
				logadd("*", "Unbekannter Befehl.")
			end
		end
	else
		logadd("*","Alle Befehle:")
		local output = ""
		for k,v in pairs(commands) do
			output = output.." "..commandInit..k..","
		end
		logadd(nil, output:sub(1,-2))
	end
end
commandAliases = {
	quit = commands.exit,
	colours = commands.colors,
	ls = commands.list,
	cry = commands.list,
	nickname = commands.nick,
	channel = commands.key,
	palate = commands.palette,
	tell = commands.msg,
	whisper = commands.msg,
	["?"] = commands.help,
}

local checkIfCommand = function(input)
	if input:sub(1,#commandInit) == commandInit then
		return true
	else
		return false
	end
end

local parseCommand = function(input)
	local sPos1, sPos2 = input:find(" ")
	local cmdName, cmdArgs
	if sPos1 then
		cmdName = input:sub(#commandInit+1, sPos1-1)
		cmdArgs = input:sub(sPos2+1)
	else
		cmdName = input:sub(#commandInit+1)
		cmdArgs = nil
	end

	local res
	local CMD = commands[cmdName] or commandAliases[cmdName]
	if CMD then
		res = CMD(cmdArgs)
		if res == "exit" then
			return "exit"
		end
	else
		logadd("*", "Unbekannter Befehl.")
	end
end

local main = function()
	termsetBackgroundColor(palette.bg)
	termclear()
	os.queueEvent("render_src")
	local mHistory = {}

	while true do

		termsetCursorPos(1, scr_y-UIconf.promptY)
		termsetBackgroundColor(palette.promptbg)
		termclearLine()
		termsetTextColor(palette.chevron)
		termwrite(UIconf.chevron)
		termsetTextColor(palette.prompttxt)

		local input = colorRead(nil, mHistory)
		if textToBlit(input,true):gsub(" ","") ~= "" then
			if checkIfCommand(input) then
				local res = parseCommand(input)
				if res == "exit" then
					return "exit"
				end
			else
				if srcSettings.extraNewline then
					logadd(nil,nil,nil,nil,nil,personalID)
				end
				srcSend(yourName, input, {doLog = true})
			end
			if mHistory[#mHistory] ~= input then
				mHistory[#mHistory+1] = input
			end
		elseif input == "" then
			logadd(nil,nil,nil,nil,nil,personalID)
		end
		os.queueEvent("render_src")

	end

end

local handleReceiveMessage = function(user, message, animType, maxFrame, _personalID)
	if srcSettings.extraNewline then
		logadd(nil,nil,nil,nil,nil,_personalID)
	end
	logadd(user, message, animations[animType] and animType or nil, (type(maxFrame) == "number") and maxFrame or nil, nil, _personalID)
	os.queueEvent("render_src")
end

local adjScroll = function(distance)
	scroll = mathmin(maxScroll, mathmax(0, scroll + distance))
end

local checkRSinput = function()
	return (
		rs.getInput("front") or
		rs.getInput("back")  or
		rs.getInput("left")  or
		rs.getInput("right") or
		rs.getInput("top")   or
		rs.getInput("bottom")
	)
end

local handleEvents = function()
	local oldScroll
	local keysDown = {}
	while true do
		local evt = {os.pullEvent()}
		if evt[1] == "src_receive" then
			if type(evt[2]) == "string" and type(evt[3]) == "string" then
				handleReceiveMessage(evt[2], evt[3])
			end
		elseif evt[1] == "chat" and ((not checkRSinput()) or (not src.disableChatboxWithRedstone)) then
			if src.useChatbox then
				if srcSettings.extraNewline then
					logadd(nil,nil)
				end
				srcSend(evt[2], evt[3], {doLog = true})
			end
		elseif evt[1] == "chat_message" and ((not checkRSinput()) or (not src.disableChatboxWithRedstone)) then
			if src.useChatbox then
				if srcSettings.extraNewline then
					logadd(nil,nil)
				end
				srcSend(evt[3], evt[4], {doLog = true})
			end
		elseif (evt[1] == "modem_message") or (evt[1] == "skynet_message" and srcSettings.useSkynet) then
			local side, freq, repfreq, msg, distance
			if evt[1] == "modem_message" then
				side, freq, repfreq, msg, distance = evt[2], evt[3], evt[4], evt[5], evt[6]
			else
				freq, msg = evt[2], evt[3]
			end
			if (freq == src.port) or (freq == src.skynetPort) then
				msg = decrite(msg)
				if type(msg) == "table" then
					if (type(msg.name) == "string") then
						if #msg.name <= 32 then
							if msg.messageID and (not IDlog[msg.messageID]) then
								userCryList[msg.name] = true
								IDlog[msg.messageID] = true
								if ((not msg.recipient) or (msg.recipient == yourName or msg.recipient == textToBlit(yourName,true))) then
									if type(msg.message) == "string" then
										handleReceiveMessage(msg.name, tostring(msg.message), msg.animType, msg.maxFrame, msg.personalID)
										if chatbox and src.useChatbox and ((not checkRSinput()) or (not src.disableChatboxWithRedstone)) then
											chatbox.say(UIconf.prefix .. msg.name .. UIconf.suffix .. msg.message, msg.name)
										end
									elseif type(msg.message) == "table" and srcSettings.acceptPictoChat and #msg.message <= 64 then
										logaddTable(msg.name, msg.message, msg.animType, msg.maxFrame, msg.ignoreWrap, msg.personalID)
										if srcSettings.extraNewline then
											logadd(nil,nil)
										end
									elseif commands[msg.simCommand or false] and type(msg.simArgument) == "string" then
										if simmableCommands[msg.simCommand or false] then
											commands[msg.simCommand](msg.simArgument, msg.name)
										end
									end
								end
								if (msg.cry == true) then
									cryOut(yourName, false)
								end
							end
						end
					end
				end
			end
		elseif evt[1] == "mouse_scroll" and (not pauseRendering) then
			local dist = evt[2]
			oldScroll = scroll
			adjScroll(srcSettings.reverseScroll and -dist or dist)
			if scroll ~= oldScroll then
				dab(renderChat)
			end
		elseif evt[1] == "key" and (not pauseRendering) then
			local key = evt[2]
			keysDown[key] = true
			oldScroll = scroll
			local pageSize = (scr_y-UIconf.promptY) - UIconf.chatlogTop
			if key == keys.pageUp then
				adjScroll(-(keysDown[keys.leftCtrl] and pageSize or srcSettings.pageKeySpeed))
			elseif key == keys.pageDown then
				adjScroll(keysDown[keys.leftCtrl] and pageSize or srcSettings.pageKeySpeed)
			end
			if scroll ~= oldScroll then
				dab(renderChat)
			end
		elseif evt[1] == "key_up" then
			local key = evt[2]
			keysDown[key] = nil
		elseif (evt[1] == "render_src") and (not pauseRendering) then
			dab(renderChat)
		elseif (evt[1] == "tron_complete") then
			if evt[3] then
				if srcSettings.extraNewline then
					logadd(nil,nil)
				end
				if evt[2] == "win" then
					srcSend("*", yourName .. "&}&r~r schlug " .. (evt[4] or "Jemand") .. "&}&r~r in TRON!", {doLog = true})
				elseif evt[2] == "lose" then
					srcSend("*", (evt[4] or "Jemand") .. "&}&r~r schlug " .. yourName .. "&}&r~r in TRON!", {doLog = true})
				elseif evt[2] == "tie" then
					srcSend("*", yourName .. "&}&r~r unentschieden mit " .. (evt[4] or "Jemand") .. "&}&r~r in TRON!", {doLog = true})
				end
			elseif evt[2] == "timeout" then
				if srcSettings.extraNewline then
					logadd(nil,nil)
				end
				srcSend("*", yourName .. "&}&r~r verlierte gegen " .. (evt[4] or "Jemand") .. "&}&r~r in TRON...", {doLog = true})
			end
		elseif evt[1] == "terminate" then
			return "exit"
		end
	end
end

local keepRedrawing = function()
	while true do
		sleep(srcSettings.redrawDelay)
		if not pauseRendering then
			os.queueEvent("render_src")
		end
	end
end

local handleNotifications = function()
	while true do
		os.pullEvent("render_src")
		if canvas and srcSettings.doNotif then
			notif.displayNotifications(true)
		end
	end
end

getModem()

srcSend("*", "'"..yourName.."&}&r~r' hat sich eingeloggt.", {doLog = true, omitPersonalID = true})

local funky = {
	main,
	handleEvents,
	keepRedrawing,
	handleNotifications
}

if skynet then
	funky[#funky+1] = function()
		while true do
			if skynet then
				pcall(skynet.listen)
				local success, msg = pcall(skynet.open, src.skynetPort)
                        	if not success then
                        		skynet = nil
				end
			end
			sleep(5)
		end
	end
end

pauseRendering = false

local res, outcome = pcall(function()
	return parallel.waitForAny(unpack(funky))
end)

os.pullEvent = oldePullEvent
if skynet then
	if skynet.socket then
		skynet.socket.close()
	end
end

if canvas then
	canvas.clear()
end

tsv(true)

if not res then
	prettyClearScreen(1,scr_y-1)
	termsetTextColor(colors.white)
	termsetBackgroundColor(colors.gray)
	cwrite("Kritischer Fehler...",2)
	termsetCursorPos(1,7)
	printError(outcome)
	termsetTextColor(colors.lightGray)
	cwrite("Derzeit keine Reperatur verfügbar.",10)
end

termsetCursorPos(1, scr_y)
termsetBackgroundColor(initcolors.bg)
termsetTextColor(initcolors.txt)
termclearLine()
