local vars = require("vars")

-- // Monitors
hl.monitor({ output = "DP-1", mode = "3840x2160@160", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "3840x2160@160", position = "3840x0", scale = 1 })


-- // Binds
-- Shell & Tools
hl.bind(vars.mainMod .. " + HOME", hl.dsp.exec_cmd("inu-shell kill; inu-shell")) -- Reload Shell
hl.bind(vars.mainMod .. " + SUPER_L", hl.dsp.exec_cmd("inu-shell ipc call launcher open"), { release = true }) -- Open Launcher
hl.bind(vars.mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprpicker --notify --autocopy --render-inactive")) -- Color Picker
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast")) -- Screenshot

-- App Shortcuts
hl.bind(vars.mainMod .. " + T", hl.dsp.exec_cmd("alacritty"))
hl.bind(vars.mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(vars.mainMod .. " + B", hl.dsp.exec_cmd("firefox"))

-- Media Controls
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- // Autostart
hl.on("hyprland.start", function()
	-- Virtual Mic Setup
	hl.exec_cmd("pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=VirtualMic channel_map=front-left,front-right") -- Create Virtual Mic Nodes
	hl.exec_cmd("pw-jack carla -n ~/.audio-setup/carla-main.carxp") -- Start Audio Filtering
	hl.exec_cmd("qpwgraph ~/.audio-setup/patchbay-main.qpwgraph") -- Connect Nodes

	-- Shell
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("inu-shell")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("streamcontroller -b")
	hl.exec_cmd("openrgb --startminimized -p Main.orp")
end)
