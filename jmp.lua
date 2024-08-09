local config = import("micro/config")
local shell = import("micro/shell")
local micro = import("micro")

function init()
	config.MakeCommand("jump", jump, config.NoComplete)
	config.TryBindKey("F12", "command:jump", true)
	config.TryBindKey("Ctrl-F", "command:jump", true)
end

function split_str (inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function jump(bp)
	local filename = bp.Buf.Path
	local cmd = string.format("bash -c \"grep -n '' %s|fzf -e --layout=reverse\"", filename)
	local out = shell.RunInteractiveShell(cmd, false, true)
	local line = tonumber(split_str(out, ":")[1])
	if line == nil then
		micro.InfoBar():Message("jump cancelled.")
		return
	end

	bp.Cursor.Y = line - 1
	micro.InfoBar():Message(string.format("jumped to " .. tostring(line)))
end
