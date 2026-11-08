local vars = require("vars")

-- // Options
hl.config({
	general = {
		allow_tearing = true,

		layout = "dwindle",
		no_focus_fallback = true,

		resize_on_border = false,

		gaps_in = 8,
		gaps_out = 16,
		float_gaps = 16,
		gaps_workspaces = 0,

		border_size = 0,
		col = {
			inactive_border = "rgb(000000)",
			active_border = "rgb(000000)",
			nogroup_border = "rgb(000000)",
			nogroup_border_active = "rgb(000000)"
		},

		snap = {
			enabled = true,
			window_gap = 8,
			monitor_gap = 16,
			respect_gaps = true
		}
	},

	decoration = {
		rounding = 16,
		rounding_power = 2,

		active_opacity = 1,
		inactive_opacity = 1,

		dim_modal = true,
		dim_inactive = false,
		dim_strength = 0.5,

		dim_special = 0.5,

		dim_around = 0.5,

		border_part_of_window = true,

		blur = {
			enabled = true,
			size = 16,
			passes = 2,

			ignore_opacity = true,
			xray = false,

			vibrancy = 1,
			vibrancy_darkness = 0,
			contrast = 2,
			brightness = 0.5,
			noise = 0,

			special = true,
			popups = false,
			input_methods = false,

			new_optimizations = true
		},

		shadow = {
			enabled = true,
			range = 16,
			render_power = 4,
			sharp = false,
			color = "rgba(00000080)",
			offset = { 0, 0 },
			scale = 1
		}
	},

	animations = {
		enabled = true,
		workspace_wraparound = false
	},

	input = {
		kb_layout = "se",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		numlock_by_default = false,

		resolve_binds_by_sym = false,

		repeat_rate = 25,
		repeat_delay = 600,

		sensitivity = -0.4,
		accel_profile = "flat",
		force_no_accel = false,
		rotation = 0,
		left_handed = false,
		emulate_discrete_scroll = 2,

		off_window_axis_events = 1,

		follow_mouse = 1,
		follow_mouse_shrink = 0,
		follow_mouse_threshold = 0,
		focus_on_close = 1,
		mouse_refocus = true,
		float_switch_override_focus = 1,
		special_fallthrough = false,

		tablet = {
			output = "current"
		}
	},

	misc = {
		disable_autoreload = false,

		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_scale_notification = true,
		force_default_wallpaper = false,
		background_color = "rgb(000000)",

		vrr = 0,

		mouse_move_enables_dpms = false,

		name_vk_after_proc = true,

		always_follow_on_dnd = true,

		layers_hog_keyboard_focus = true,

		animate_manual_resizes = false,
		animate_mouse_windowdragging = false,

		enable_swallow = false,

		focus_on_activate = false,
		on_focus_under_fullscreen = 2,

		exit_window_retains_fullscreen = false,

		mouse_move_focuses_monitor = true,

		allow_session_lock_restore = false,
		session_lock_xray = false,
		lockdead_screen_delay = 1000,

		close_special_on_empty = false,

		initial_workspace_tracking = 1,

		middle_click_paste = false,

		render_unfocused_fps = 15,

		disable_xdg_env_checks = false,
		disable_hyprland_guiutils_check = false,

		enable_anr_dialog = false,

		size_limits_tiled = false,

		screencopy_force_8b = true,

		disable_watchdog_warning = false
	},

	layout = {
		single_window_aspect_ratio = { 0, 0 },
		single_window_aspect_ratio_tolerance = 0.1
	},

	dwindle = {
		preserve_split = true
	},

	binds = {
		pass_mouse_when_bound = false,
		
		scroll_event_delay = 300,

		workspace_back_and_forth = false,
		hide_special_on_workspace_change = true,
		allow_workspace_cycles = false,
		workspace_center_on = 1,

		focus_preferred_method = 0,

		ignore_group_lock = false,
		movefocus_cycles_fullscreen = false,
		movefocus_cycles_groupfirst = false,

		window_direction_monitor_fallback = true,

		disable_keybind_grabbing = false,

		allow_pin_fullscreen = false,

		drag_threshold = 0
	},

	xwayland = {
		enabled = true,
		use_nearest_neighbor = true,
		force_zero_scaling = false,
		create_abstract_socket = false
	},

	opengl = {
		nvidia_anti_flicker = false
	},

	render = {
		direct_scanout = 1,

		new_render_scheduling = false
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true
	}
})

-- Animation
hl.curve("easeOutQuint", { type = "bezier"; points = {{ 0.23, 1 }, { 0.32, 1 }} })
hl.curve("easeInQuint", { type = "bezier"; points = {{ 0.64, 0 }, { 0.78, 0 }} })

hl.animation({ leaf = "global"; enabled = true; speed = 4; bezier = "default"; })
hl.animation({ leaf = "fade"; enabled = true; speed = 1; bezier = "easeOutQuint"; })
hl.animation({ leaf = "border"; enabled = true; speed = 4; bezier = "easeOutQuint"; })
hl.animation({ leaf = "windows"; enabled = true; speed = 4; bezier = "easeOutQuint"; style = "popin 75%"; })
hl.animation({ leaf = "windowsMove"; enabled = true; speed = 4; bezier = "easeOutQuint"; })
hl.animation({ leaf = "layers"; enabled = true; speed = 4; bezier = "easeOutQuint"; style = "popin 75%"; })
hl.animation({ leaf = "workspaces"; enabled = true; speed = 4; bezier = "easeOutQuint"; style = "slidevert"; })

-- // Default Monitor
hl.monitor({ output = ""; mode = "preferred"; position = "auto"; scale = 1; })

-- // Binds
-- Window Management
hl.bind(vars.mainMod .. " + Q", hl.dsp.window.close())
hl.bind(vars.mainMod .. " + V", hl.dsp.window.float())
hl.bind(vars.mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(vars.mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(vars.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces
for workspaceIndex = 1, vars.workspaces, 1 do
	local nunberKey = tostring(workspaceIndex % vars.workspaces)
	hl.bind(vars.mainMod .. " + " .. nunberKey, hl.dsp.focus({ workspace = workspaceIndex })) -- Switch Workspace
	hl.bind(vars.mainMod .. " + SHIFT + " .. nunberKey, hl.dsp.window.move({ workspace = workspaceIndex, follow = true })) -- Move Window to Workspace
end

hl.bind(vars.mainMod .. " + TAB", hl.dsp.workspace.toggle_special("special"))
hl.bind(vars.mainMod .. " + SHIFT + TAB", hl.dsp.window.move({ workspace = "special:special" }))

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true; repeating = true; })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true; repeating = true; })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true; })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true; })

-- // Rules
-- Window Rules
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({ match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })

hl.window_rule({ match = { initial_class = "Godot", initial_title = "Godot" }, tile = true })
hl.window_rule({ match = { initial_class = "Godot", title = "()" }, float = true })
hl.window_rule({ match = { initial_class = "Godot", title = "()" }, stay_focused = true })
hl.window_rule({ match = { initial_class = "Godot", title = "()" }, rounding = 0 })
hl.window_rule({ match = { initial_class = "Godot", title = "()" }, border_size = 0 })
hl.window_rule({ match = { initial_class = "Godot", title = "()" }, no_anim = true })
hl.window_rule({ match = { initial_class = "Godot", title = "()" }, no_focus = true })
hl.window_rule({ match = { initial_class = "Godot", title = "^(DEBUG)$" }, decorate = false })

hl.window_rule({ match = { initial_class = "Godot"; title = "Create New Node" }, stay_focused = true })
hl.window_rule({ match = { initial_class = "Godot"; title = "Create Folder" }, stay_focused = true })
hl.window_rule({ match = { initial_class = "Godot"; title = "Create Script" }, stay_focused = true })
hl.window_rule({ match = { initial_class = "Godot"; title = "Create New Resource" }; stay_focused = true })
hl.window_rule({ match = { initial_class = "Godot"; title = "Create New Scene" }, stay_focused = true })
hl.window_rule({ match = { initial_class = "Godot"; title = "^(Change Type of)" }, stay_focused = true })

hl.window_rule({ match = { class = "^(code)$" }, opacity = 0.9 })
hl.window_rule({ match = { class = "^(Bitwarden)$" }, opacity = 0.9 })
hl.window_rule({ match = { class = "^(steam)$" }, opacity = 0.9 })

-- Layer Rules
hl.layer_rule({ match = { namespace = "quickshell" }, no_anim = true })

-- // Cursor
hl.env("XCURSOR_SIZE", 24)
hl.env("XCURSOR_THEME", "Posy_Cursor_Black")
hl.env("HYPRCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_THEME", "hyprcursor_Posys-Cursor-Scalable-Mono-Black")
