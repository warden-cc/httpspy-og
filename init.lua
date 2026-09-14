local cloneref = cloneref
local game = cloneref(game)
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Debris = cloneref(game:GetService("Debris"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))

local function randomString()
	local len = math.random(10, 20)
	local t = {}

	for i = 1, len do
		t[i] = string.char(math.random(32, 126))
	end

	return table.concat(t)
end

local function addMarkers(gui)
	local m = Instance.new("BoolValue")

	m.Name = "isNyreliajs"
	m.Parent = gui

	gui:SetAttribute("NyreliajsUI", true)
end

local function protectGui(gui)
	local ok, err = pcall(function()

		if get_hidden_gui or gethui then
			gui.Name = randomString()
			gui.Parent = (get_hidden_gui or gethui)()
		elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
			gui.Name = randomString()
			syn.protect_gui(gui)
			gui.Parent = CoreGui
		elseif CoreGui:FindFirstChild("RobloxGui") then
			gui.Parent = cloneref(CoreGui:FindFirstChild("RobloxGui"))
		else
			gui.Parent = CoreGui
		end

		addMarkers(gui)
	end)
	if not ok then
		warn("[Nyrelia.js] anti-detection failed, using CoreGui.\n" .. tostring(err))
		gui.Parent = CoreGui
		addMarkers(gui)
	end
end

local function scanAndDestroy(parent)
	if not parent then
		return

	end

	local ok, list = pcall(function()

		return parent:GetChildren()
	end)
	if not ok then
		return

	end

	for _, g in ipairs(list) do
		local ref = cloneref(g)

		if ref:IsA("ScreenGui") and (ref:FindFirstChild("isNyreliajs") or ref:GetAttribute("NyreliajsUI")) then
			Debris:AddItem(ref, 0)
		end
	end
end

local function removeOldGUIs()
	scanAndDestroy(CoreGui)

	local rg = CoreGui:FindFirstChild("RobloxGui")

	if rg then
		scanAndDestroy(cloneref(rg))
	end

	pcall(function()
		if get_hidden_gui or gethui then
			local hui = (get_hidden_gui or gethui)()

			if hui then
				scanAndDestroy(cloneref(hui))
			end
		end
	end)
end

removeOldGUIs()

local useGUI = not rconsoleprint
local guiLog

if useGUI then
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 9999
	ScreenGui.IgnoreGuiInset = true

	local function mkCorner(r, p)
		local c = Instance.new("UICorner")

		c.CornerRadius = UDim.new(0, r)

		c.Parent = p

	end

	local function mkPad(l, r, t, b, p)
		local pad = Instance.new("UIPadding")

		pad.PaddingLeft = UDim.new(0, l or 0)
		pad.PaddingRight = UDim.new(0, r or 0)
		pad.PaddingTop = UDim.new(0, t or 0)
		pad.PaddingBottom = UDim.new(0, b or 0)
		pad.Parent = p

	end

	local Win = Instance.new("Frame")
	Win.Name = "HttpSpyWin"
	Win.Size = UDim2.new(0, 680, 0, 480)
	Win.Position = UDim2.new(0.5, -340, 0.5, -240)
	Win.BackgroundColor3 = Color3.fromRGB(10, 10, 17)
	Win.BorderSizePixel = 0
	Win.Active = true
	Win.Parent = ScreenGui

	mkCorner(9, Win)

	do
		local s = Instance.new("UIStroke")
		s.Color = Color3.fromRGB(48, 48, 72)

		s.Thickness = 1

		s.Parent = Win

	end

	local TBar = Instance.new("Frame")
	TBar.Size = UDim2.new(1, 0, 0, 38)
	TBar.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
	TBar.BorderSizePixel = 0
	TBar.Parent = Win

	mkCorner(9, TBar)
	local TFix = Instance.new("Frame")
	TFix.Size = UDim2.new(1, 0, 0.5, 0)
	TFix.Position = UDim2.new(0, 0, 0.5, 0)
	TFix.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
	TFix.BorderSizePixel = 0
	TFix.Parent = TBar

	local TTitle = Instance.new("TextLabel")
	TTitle.Text = "  HttpSpy  v1.1.3"
	TTitle.Font = Enum.Font.GothamBold
	TTitle.TextSize = 13
	TTitle.TextColor3 = Color3.fromRGB(180, 190, 255)
	TTitle.BackgroundTransparency = 1
	TTitle.Size = UDim2.new(1, -90, 1, 0)
	TTitle.TextXAlignment = Enum.TextXAlignment.Left
	TTitle.Parent = TBar

	local LiveBadge = Instance.new("Frame")
	LiveBadge.Size = UDim2.new(0, 38, 0, 16)
	LiveBadge.Position = UDim2.new(0, 148, 0.5, -8)
	LiveBadge.BackgroundColor3 = Color3.fromRGB(30, 130, 70)
	LiveBadge.BorderSizePixel = 0
	LiveBadge.Parent = TBar

	mkCorner(3, LiveBadge)
	local LiveLbl = Instance.new("TextLabel")
	LiveLbl.Text = "LIVE"
	LiveLbl.Font = Enum.Font.GothamBold
	LiveLbl.TextSize = 9
	LiveLbl.TextColor3 = Color3.fromRGB(200, 255, 220)
	LiveLbl.BackgroundTransparency = 1
	LiveLbl.Size = UDim2.new(1, 0, 1, 0)
	LiveLbl.Parent = LiveBadge

	local function winBtn(txt, bg, xOff)
		local b = Instance.new("TextButton")

		b.Text = txt
		b.Font = Enum.Font.GothamBold
		b.TextSize = 12
		b.TextColor3 = Color3.fromRGB(215, 215, 225)
		b.BackgroundColor3 = bg
		b.Size = UDim2.new(0, 26, 0, 20)
		b.Position = UDim2.new(1, xOff, 0.5, -10)
		b.BorderSizePixel = 0
		b.Parent = TBar

		mkCorner(4, b)
		return b
	end

	local MinBtn = winBtn("-", Color3.fromRGB(35, 35, 55), -60)
	local CloseBtn = winBtn("✕", Color3.fromRGB(55, 20, 20), -28)
	local Toolbar = Instance.new("Frame")

	Toolbar.Size = UDim2.new(1, 0, 0, 30)
	Toolbar.Position = UDim2.new(0, 0, 0, 38)
	Toolbar.BackgroundColor3 = Color3.fromRGB(13, 13, 22)
	Toolbar.BorderSizePixel = 0
	Toolbar.Parent = Win

	do
		local l = Instance.new("UIListLayout")
		l.FillDirection = Enum.FillDirection.Horizontal
		l.VerticalAlignment = Enum.VerticalAlignment.Center
		l.Padding = UDim.new(0, 5)
		l.Parent = Toolbar

		mkPad(8, 0, 0, 0, Toolbar)
	end

	local function toolBtn(txt, bg, w)
		local b = Instance.new("TextButton")

		b.Text = txt
		b.Font = Enum.Font.Gotham
		b.TextSize = 11
		b.TextColor3 = Color3.fromRGB(195, 195, 215)
		b.BackgroundColor3 = bg
		b.Size = UDim2.new(0, w or 85, 0, 21)
		b.BorderSizePixel = 0
		b.AutoButtonColor = true
		b.Parent = Toolbar

		mkCorner(4, b)
		return b
	end

	local ClearBtn = toolBtn("🗑  clear", Color3.fromRGB(46, 16, 16), 90)
	local PauseBtn = toolBtn("⏸  pause", Color3.fromRGB(16, 36, 16), 85)
	local CopyBtn = toolBtn("📋  copy last", Color3.fromRGB(16, 24, 50), 110)
	local Sep = Instance.new("Frame")

	Sep.Size = UDim2.new(0, 1, 0, 18)
	Sep.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	Sep.BorderSizePixel = 0
	Sep.Parent = Toolbar

	local CountFrame = Instance.new("Frame")
	CountFrame.Size = UDim2.new(0, 65, 0, 20)
	CountFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
	CountFrame.BorderSizePixel = 0
	CountFrame.Parent = Toolbar

	mkCorner(4, CountFrame)
	local CountLbl = Instance.new("TextLabel")
	CountLbl.Text = "0 requests"
	CountLbl.Font = Enum.Font.GothamBold
	CountLbl.TextSize = 10
	CountLbl.TextColor3 = Color3.fromRGB(120, 130, 200)
	CountLbl.BackgroundTransparency = 1
	CountLbl.Size = UDim2.new(1, 0, 1, 0)
	CountLbl.Parent = CountFrame

	local FBar = Instance.new("Frame")
	FBar.Size = UDim2.new(1, 0, 0, 26)
	FBar.Position = UDim2.new(0, 0, 0, 68)
	FBar.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
	FBar.BorderSizePixel = 0
	FBar.Parent = Win

	mkPad(10, 8, 5, 5, FBar)
	local FIcon = Instance.new("TextLabel")
	FIcon.Text = "⌕"
	FIcon.TextSize = 14
	FIcon.BackgroundTransparency = 1
	FIcon.Size = UDim2.new(0, 18, 1, 0)
	FIcon.TextColor3 = Color3.fromRGB(80, 80, 115)
	FIcon.Font = Enum.Font.GothamBold
	FIcon.Parent = FBar

	local FBox = Instance.new("TextBox")
	FBox.PlaceholderText = "filter by URL, method, body..."
	FBox.Text = ""
	FBox.Font = Enum.Font.Code
	FBox.TextSize = 11
	FBox.TextColor3 = Color3.fromRGB(160, 172, 210)
	FBox.PlaceholderColor3 = Color3.fromRGB(55, 55, 85)
	FBox.BackgroundTransparency = 1
	FBox.Size = UDim2.new(1, -22, 1, 0)
	FBox.Position = UDim2.new(0, 20, 0, 0)
	FBox.TextXAlignment = Enum.TextXAlignment.Left
	FBox.ClearTextOnFocus = false
	FBox.Parent = FBar

	local Scroll = Instance.new("ScrollingFrame")
	Scroll.Size = UDim2.new(1, -6, 1, -120)
	Scroll.Position = UDim2.new(0, 3, 0, 97)
	Scroll.BackgroundColor3 = Color3.fromRGB(7, 7, 12)
	Scroll.BorderSizePixel = 0
	Scroll.ScrollBarThickness = 4
	Scroll.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 100)
	Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Scroll.Parent = Win

	mkCorner(6, Scroll)
	local LogCont = Instance.new("Frame")
	LogCont.Name = "LogContainer"
	LogCont.Size = UDim2.new(1, 0, 0, 0)
	LogCont.AutomaticSize = Enum.AutomaticSize.Y
	LogCont.BackgroundTransparency = 1
	LogCont.Parent = Scroll

	do
		local l = Instance.new("UIListLayout")

		l.Padding = UDim.new(0, 2)

		l.Parent = LogCont

		mkPad(4, 4, 4, 4, LogCont)
	end

	local SBar = Instance.new("Frame")
	SBar.Size = UDim2.new(1, 0, 0, 21)
	SBar.Position = UDim2.new(0, 0, 1, -21)
	SBar.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
	SBar.BorderSizePixel = 0
	SBar.Parent = Win

	mkCorner(9, SBar)

	do
		local fix = Instance.new("Frame")
		fix.Size = UDim2.new(1, 0, 0.5, 0)
		fix.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
		fix.BorderSizePixel = 0
		fix.Parent = SBar

	end

	local SLabel = Instance.new("TextLabel")
	SLabel.Text = "● active | 0 requests captured"
	SLabel.Font = Enum.Font.Gotham
	SLabel.TextSize = 10
	SLabel.TextColor3 = Color3.fromRGB(60, 190, 110)
	SLabel.BackgroundTransparency = 1
	SLabel.Size = UDim2.new(0.65, 0, 1, 0)
	SLabel.Position = UDim2.new(0, 8, 0, 0)
	SLabel.TextXAlignment = Enum.TextXAlignment.Left
	SLabel.Parent = SBar

	local TipLbl = Instance.new("TextLabel")
	TipLbl.Text = "right click in entry to copy  "
	TipLbl.Font = Enum.Font.Gotham
	TipLbl.TextSize = 10
	TipLbl.TextColor3 = Color3.fromRGB(50, 50, 80)
	TipLbl.BackgroundTransparency = 1
	TipLbl.Size = UDim2.new(0.35, 0, 1, 0)
	TipLbl.Position = UDim2.new(0.65, 0, 0, 0)
	TipLbl.TextXAlignment = Enum.TextXAlignment.Right
	TipLbl.Parent = SBar

	protectGui(ScreenGui)

	local paused = false
	local reqCount = 0
	local lastText = nil
	local minimized = false
	local MAX_ENTRIES = 200
	local function setStatus(text, color, tempSecs)
		SLabel.Text = text
		SLabel.TextColor3 = color or Color3.fromRGB(60, 190, 110)

		if tempSecs then
			task.delay(tempSecs, function()
				if paused then
					SLabel.Text = "⏸ Pausado | " .. reqCount .. " solicitudes"
					SLabel.TextColor3 = Color3.fromRGB(200, 150, 40)
				else
					SLabel.Text = "● Activo | " .. reqCount .. " solicitudes capturadas"
					SLabel.TextColor3 = Color3.fromRGB(60, 190, 110)
				end
			end)
		end
	end

	local function refreshStatus()
		CountLbl.Text = reqCount .. " requests"

		if paused then
			setStatus("⏸ paused | " .. reqCount .. " requests", Color3.fromRGB(200, 150, 40))

		else

			setStatus("● active | " .. reqCount .. " requests captured")
		end
	end

	local THEMES = {
		request = {
			bg = Color3.fromRGB(11, 11, 19),
			tc = Color3.fromRGB(160, 192, 255),
			ac = Color3.fromRGB(60, 70, 150)
		},
		response = {
			bg = Color3.fromRGB(9, 19, 11),
			tc = Color3.fromRGB(130, 220, 158),
			ac = Color3.fromRGB(40, 125, 70)
		},
		error = {
			bg = Color3.fromRGB(20, 8, 8),
			tc = Color3.fromRGB(255, 100, 100),
			ac = Color3.fromRGB(150, 40, 40)
		},
		blocked = {
			bg = Color3.fromRGB(21, 16, 6),
			tc = Color3.fromRGB(238, 182, 60),
			ac = Color3.fromRGB(140, 100, 20)
		},
		ws = {
			bg = Color3.fromRGB(9, 9, 22),
			tc = Color3.fromRGB(150, 150, 255),
			ac = Color3.fromRGB(70, 70, 190)
		},
		method = {
			bg = Color3.fromRGB(17, 9, 20),
			tc = Color3.fromRGB(210, 150, 255),
			ac = Color3.fromRGB(130, 50, 170)
		},
	}
	guiLog = function(text, kind)

		if paused then
			return

		end

		reqCount = reqCount + 1
		lastText = text

		local theme = THEMES[kind] or THEMES.request
		local frames = {}

		for _, c in ipairs(LogCont:GetChildren()) do
			local ref = cloneref(c)

			if ref:IsA("Frame") then
				frames[#frames + 1] = ref
			end
		end

		if #frames >= MAX_ENTRIES then
			frames[1]:Destroy()
		end

		local E = Instance.new("Frame")
		E.Size = UDim2.new(1, 0, 0, 0)
		E.AutomaticSize = Enum.AutomaticSize.Y
		E.BackgroundColor3 = theme.bg
		E.BorderSizePixel = 0
		E.Parent = LogCont

		mkCorner(4, E)

		do
			local s = Instance.new("UIStroke")

			s.Color = Color3.fromRGB(28, 28, 48)

			s.Thickness = 0.5

			s.Parent = E

		end

		local Stripe = Instance.new("Frame")
		Stripe.Size = UDim2.new(0, 2, 1, -8)
		Stripe.Position = UDim2.new(0, 2, 0, 4)
		Stripe.BackgroundColor3 = theme.ac
		Stripe.BorderSizePixel = 0
		Stripe.Parent = E

		mkCorner(2, Stripe)
		mkPad(10, 6, 3, 3, E)
		local NumLbl = Instance.new("TextLabel")
		NumLbl.Text = "#" .. reqCount
		NumLbl.Font = Enum.Font.GothamBold
		NumLbl.TextSize = 9
		NumLbl.TextColor3 = Color3.fromRGB(80, 80, 120)
		NumLbl.BackgroundTransparency = 1
		NumLbl.Size = UDim2.new(0, 28, 0, 12)
		NumLbl.TextXAlignment = Enum.TextXAlignment.Left
		NumLbl.Parent = E

		local kindNames = {
			request = "REQUEST",
			response = "RESPONSE",
			error = "ERROR",
			blocked = "BLOCKED",
			ws = "WS",
			method = "METHOD"
		}
		local KindLbl = Instance.new("TextLabel")
		KindLbl.Text = kindNames[kind] or "REQUEST"
		KindLbl.Font = Enum.Font.GothamBold
		KindLbl.TextSize = 8
		KindLbl.TextColor3 = theme.ac
		KindLbl.BackgroundTransparency = 1
		KindLbl.Size = UDim2.new(0, 28, 0, 12)
		KindLbl.Position = UDim2.new(0, 30, 0, 0)
		KindLbl.TextXAlignment = Enum.TextXAlignment.Left
		KindLbl.Parent = E

		local TLbl = Instance.new("TextLabel")
		TLbl.Text = text
		TLbl.Font = Enum.Font.Code
		TLbl.TextSize = 11
		TLbl.TextColor3 = theme.tc
		TLbl.BackgroundTransparency = 1
		TLbl.Size = UDim2.new(1, -60, 0, 0)
		TLbl.AutomaticSize = Enum.AutomaticSize.Y
		TLbl.Position = UDim2.new(0, 58, 0, 0)
		TLbl.TextXAlignment = Enum.TextXAlignment.Left
		TLbl.TextWrapped = true
		TLbl.Parent = E

		local capturedCount = reqCount
		E.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton2 then
				pcall(setclipboard, text)
				setStatus("📋 entry #" .. capturedCount .. " copied to clipboard", Color3.fromRGB(90, 170, 255), 2)
			end
		end)

		local ft = FBox.Text:lower()

		if ft ~= "" and not text:lower():find(ft, 1, true) then
			E.Visible = false
		end

		task.defer(function()
			Scroll.CanvasPosition = Vector2.new(0, math.huge)
		end)
		refreshStatus()
	end

	FBox:GetPropertyChangedSignal("Text"):Connect(function()

		local ft = FBox.Text:lower()

		for _, c in ipairs(LogCont:GetChildren()) do
			local ref = cloneref(c)

			if ref:IsA("Frame") then
				local found = false

				for _, ch in ipairs(ref:GetChildren()) do
					local chRef = cloneref(ch)

					if chRef:IsA("TextLabel") and chRef.TextSize == 11 then
						ref.Visible = (ft == "") or (chRef.Text:lower():find(ft, 1, true) ~= nil)
						found = true

						break
					end
				end

				if not found then
					ref.Visible = true
				end
			end
		end
	end)

	ClearBtn.MouseButton1Click:Connect(function()
		for _, c in ipairs(LogCont:GetChildren()) do
			local ref = cloneref(c)

			if ref:IsA("Frame") then
				ref:Destroy()
			end
		end

		reqCount = 0

		lastText = nil
		refreshStatus()
	end)
	PauseBtn.MouseButton1Click:Connect(function()
		paused = not paused
		PauseBtn.Text = paused and "▶  resume" or "⏸  pause"
		PauseBtn.BackgroundColor3 = paused and Color3.fromRGB(46, 30, 8) or Color3.fromRGB(16, 36, 16)
		LiveBadge.BackgroundColor3 = paused and Color3.fromRGB(120, 40, 30) or Color3.fromRGB(30, 130, 70)
		LiveLbl.Text = paused and "PAUSED" or "LIVE"
		refreshStatus()
	end)
	CopyBtn.MouseButton1Click:Connect(function()
		if lastText then
			pcall(setclipboard, lastText)
			setStatus("📋 last entry copied", Color3.fromRGB(90, 170, 255), 2)
		else
			setStatus("⚠ still nothing to copy", Color3.fromRGB(195, 150, 50), 2)
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized

		local show = not minimized
		Scroll.Visible = show
		Toolbar.Visible = show
		FBar.Visible = show
		SBar.Visible = show
		Win.Size = minimized and UDim2.new(0, 680, 0, 38) or UDim2.new(0, 680, 0, 480)
		MinBtn.Text = minimized and "+" or "-"
	end)
	local dragging = false
	local dragConn = nil
	local dragOffset = Vector2.new(0, 0)
	local currentPos = Vector2.new(0, 0)
	local targetPos = Vector2.new(0, 0)
	local SMOOTHING = 0.18
	TBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true

			local abs = Win.AbsolutePosition
			dragOffset = Vector2.new(
			input.Position.X - abs.X, input.Position.Y - abs.Y)
			currentPos = Vector2.new(abs.X, abs.Y)
			targetPos = currentPos
			dragConn = RunService.RenderStepped:Connect(function()
				currentPos = currentPos:Lerp(targetPos, SMOOTHING)
				Win.Position = UDim2.new(0, currentPos.X, 0, currentPos.Y)
			end)
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false

					if dragConn then
						dragConn:Disconnect()
						dragConn = nil
					end
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			targetPos = Vector2.new(
			input.Position.X - dragOffset.X, input.Position.Y - dragOffset.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false

			if dragConn then
				dragConn:Disconnect()
				dragConn = nil
			end
		end
	end)
end

if rconsoleprint then
	rconsoleprint("https://eleutheri.com - #1 Whitelist Service\n\n")
end

assert(syn or http, "your exploit is not supported (requires require thing)")

local options = ({
	...
})[1] or {
	AutoDecode = true,
	Highlighting = true,
	SaveLogs = true,
	CLICommands = true,
	ShowResponse = true,
	BlockedURLs = {},
	API = true,
}

local version = "v1.1.3"
local logname = string.format("%d-%s-log.txt", game.PlaceId, os.date("%d_%m_%y"))

if options.SaveLogs then
	writefile(logname, string.format("Http Logs from %s\n\n", os.date("%d/%m/%y")))
end

local Serializer = loadstring(game:HttpGet("https://raw.githubusercontent.com/warden-cc/httpspy-og/refs/heads/main/serializer.lua"))()
local clonef = clonefunction
local format = clonef(string.format)
local gsub = clonef(string.gsub)
local match = clonef(string.match)
local append = clonef(appendfile)
local Type = clonef(type)
local crunning = clonef(coroutine.running)
local cwrap = clonef(coroutine.wrap)
local cresume = clonef(coroutine.resume)
local cyield = clonef(coroutine.yield)
local Pcall = clonef(pcall)
local Pairs = clonef(pairs)
local Error = clonef(error)
local getnamecallmethod = clonef(getnamecallmethod)
local blocked = options.BlockedURLs
local enabled = true
local reqfunc = (syn or http).request
local libtype = syn and "syn" or "http"
local hooked = {}
local proxied = {}
local methods = {
	HttpGet = not syn,
	HttpGetAsync = not syn,
	GetObjects = true,
	HttpPost = not syn,
	HttpPostAsync = not syn,
}
Serializer.UpdateConfig({
	highlighting = options.Highlighting
})

local OnRequest = Instance.new("BindableEvent")

local function printf(...)
	local raw = format(...)
	local stripped = gsub(raw, "\27%[%d+m", "")

	if options.SaveLogs then
		append(logname, stripped)
	end

	if rconsoleprint then
		rconsoleprint(raw)
	end

	if useGUI and guiLog then
		local kind = "request"

		if stripped:find("Response Data") then
			kind = "response"

		elseif stripped:find("blocked url") then
			kind = "blocked"

		elseif stripped:find("websocket") then
			kind = "ws"

		elseif stripped:find("game:") then
			kind = "method"
		end

		guiLog(stripped, kind)
	end
end

local function DeepClone(tbl, cloned)
	cloned = cloned or {}

	for i, v in Pairs(tbl) do
		cloned[i] = (Type(v) == "table") and DeepClone(v) or v
	end

	return cloned
end

local function ConstantScan(constant)
	for _, v in Pairs(getgc(true)) do
		if type(v) == "function" and islclosure(v) and getfenv(v).script == getfenv(saveinstance).script and table.find(debug.getconstants(v), constant) then
				return v
			end
		end
	end

	local __namecall

	__namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)

		local method = getnamecallmethod()

		if methods[method] then
			printf("game:%s(%s)\n\n", method, Serializer.FormatArguments(...))
		end

		return __namecall(self, ...)
	end))
	local __request

	__request = hookfunction(reqfunc, newcclosure(function(req)

		if Type(req) ~= "table" then
			return __request(req)
		end

		local RequestData = DeepClone(req)

		if not enabled then
			return __request(req)
		end

		if Type(RequestData.Url) ~= "string" then
			return __request(req)
		end

		if not options.ShowResponse then
			printf("%s.request(%s)\n\n", libtype, Serializer.Serialize(RequestData))
			return __request(req)
		end

		local t = crunning()
		cwrap(function()
			if RequestData.Url and blocked[RequestData.Url] then
				printf("%s.request(%s) -- blocked url\n\n", libtype, Serializer.Serialize(RequestData))
				return cresume(t, {})
			end

			if RequestData.Url then
				local Host = match(RequestData.Url, "https?://(%w+.%w+)/")

				if Host and proxied[Host] then
					RequestData.Url = gsub(RequestData.Url, Host, proxied[Host], 1)
				end
			end

			OnRequest:Fire(RequestData)

			local ok, ResponseData = Pcall(__request, RequestData)

			if not ok then
				Error(ResponseData, 0)
			end

			local BackupData = {}

			for i, v in Pairs(ResponseData) do
				BackupData[i] = v
			end

			if BackupData.Headers["Content-Type"] and match(BackupData.Headers["Content-Type"], "application/json") and options.AutoDecode then
				local body = BackupData.Body
				local ok2, res = Pcall(HttpService.JSONDecode, HttpService, body)

				if ok2 then
					BackupData.Body = res
				end
			end

			printf("%s.request(%s)\n\nResponse Data: %s\n\n", libtype, Serializer.Serialize(RequestData), Serializer.Serialize(BackupData))
			cresume(t, hooked[RequestData.Url] and hooked[RequestData.Url](ResponseData) or ResponseData)
		end)()
		return cyield()
	end))
	if request then
		replaceclosure(request, reqfunc)
	end

	if syn and syn.websocket then
		local WsConnect, WsBackup = debug.getupvalue(syn.websocket.connect, 1)
		WsBackup = hookfunction(WsConnect, function(...)
			printf("syn.websocket.connect(%s)\n\n", Serializer.FormatArguments(...))
			return WsBackup(...)
		end)
	end

	if syn and syn.websocket then
		local HttpGet

		HttpGet = hookfunction(

		getupvalue(ConstantScan("ZeZLm2hpvGJrD6OP8A3aEszPNEw8OxGb"), 2), function(self, ...)
			printf("game.HttpGet(game, %s)\n\n", Serializer.FormatArguments(...))
			return HttpGet(self, ...)
		end)
		local HttpPost

		HttpPost = hookfunction(

		getupvalue(ConstantScan("gpGXBVpEoOOktZWoYECgAY31o0BlhOue"), 2), function(self, ...)
			printf("game.HttpPost(game, %s)\n\n", Serializer.FormatArguments(...))
			return HttpPost(self, ...)
		end)
	end

	for method, en in Pairs(methods) do
		if en then
			local b

			b = hookfunction(game[method], newcclosure(function(self, ...)

				printf("game.%s(game, %s)\n\n", method, Serializer.FormatArguments(...))
				return b(self, ...)
			end))
		end
	end

	if not debug.info(2, "f") then
		if rconsoleprint then
			rconsoleprint("You are running an outdated version, please use the loadstring at https://github.com/Snxdfer/HttpSpy\n")

		elseif useGUI and guiLog then
			guiLog("⚠ You are running an outdated version, please use the loadstring at https://github.com/Snxdfer/HttpSpy\n", "error")
		end
	end

	if rconsoleprint then
		rconsoleprint(format("HttpSpy %s (Creator: https://github.com/NotDSF)\nLogs are automatically being saved to: \27[32m%s\27[0m\n\n", version, options.SaveLogs and logname or "(You aren't saving logs, enable SaveLogs if you want to save logs)"))

	elseif useGUI and guiLog then
		guiLog(string.format("HttpSpy %s loaded — Logs: %s", version, options.SaveLogs and logname or "(You aren't saving logs, enable SaveLogs if you want to save logs)"), "request")
	end

	if not options.API then
		return

	end

	local API = {}
	API.OnRequest = OnRequest.Event

	function API:HookSynRequest(url, hook)
		hooked[url] = hook
	end

	function API:ProxyHost(host, proxy)
		proxied[host] = proxy
	end

	function API:RemoveProxy(host)
		if not proxied[host] then
			error("host isn't proxied", 0)
		end

		proxied[host] = nil
	end

	function API:UnHookSynRequest(url)
		if not hooked[url] then
			error("url isn't hooked", 0)
		end

		hooked[url] = nil
	end

	function API:BlockUrl(url)
		blocked[url] = true
	end

	function API:WhitelistUrl(url)
		blocked[url] = false
	end

	return API
