{ config, pkgs, inputs, lib, ... }: {
	# Module Imports
	imports = [
		inputs.spicetify-nix.homeManagerModules.spicetify
		inputs.nixcord.homeModules.nixcord
	];

	# User
	home.username = "inurentto";
	home.homeDirectory = "/home/inurentto";

	# Terminal Shell
	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			set fish_greeting
		'';
		plugins = [];
	};
	programs.oh-my-posh = {
		enable = true;
		enableFishIntegration = true;
		settings = {
			final_space = true;

			blocks = [
				{
					type = "prompt";
					alignment = "left";
					segments = [
						{
							type = "os";
							style = "powerline";
							template = "<darkGray,transparent></>{{ .Icon }} <darkGray,transparent></>";
							foreground = "foreground";
							background = "darkGray";
						}
					];
				}
				{
					type = "prompt";
					alignment = "left";
					segments = [
						{
							type = "nix-shell";
							style = "powerline";
							template = "<blue,transparent></> {{ .Type }} <blue,transparent></>";
							foreground = "black";
							background = "blue";
						}
					];
				}
				{
					type = "prompt";
					alignment = "left";
					segments = [
						{
							type = "path";
							style = "powerline";
							template = "<yellow,transparent></> {{ .Path }} <yellow,transparent></>";
							foreground = "black";
							background = "yellow";
							options = {
								style = "full";
							};
						}
					];
				}

				{
					segments = [
						{
							foreground = "darkGray";
							template = " {{ .CurrentDate | date .Format }} ";
							options = {
								time_format = "15:04:05";
							};
							style = "plain";
							type = "time";
						}
					];
					type = "rprompt";
				}
			];
		};
	};

	# Environment Variables
	home.sessionVariables = {
		STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
	};

	# Fastfetch
	programs.fastfetch.enable = true;

	# Btop
	programs.btop = {
		enable = true;
		package = pkgs.btop.override {
      cudaSupport = true;
    };
	};

	# Hyprland (not enabled by default)
	wayland.windowManager.hyprland = {
		xwayland.enable = lib.mkDefault true;
		systemd.enable = lib.mkDefault true;
		systemd.variables = lib.mkDefault [ "--all" ];

		configType = "lua";

		settings = {
			mainMod = lib.mkDefault { _var = "SUPER"; };

			terminal = lib.mkDefault { _var = "alacritty"; };
			fileManager = lib.mkDefault { _var = "dolphin"; };
			browser = lib.mkDefault { _var = "firefox"; };

			reloadShell = lib.mkDefault { _var = "pkill quickshell; hyprctl dispatch exec qs"; };
			launcher = lib.mkDefault { _var = "qs ipc call launcher open"; };
			screenshot = lib.mkDefault { _var = "grimblast --notify --expire-time 8000 --freeze copysave area"; };
			colorPick = lib.mkDefault { _var = "hyprpicker --notify --autocopy --render-inactive"; };

			# Variables
			config = {
				general = {
					allow_tearing = true;

					layout = "dwindle";
					no_focus_fallback = true;

					resize_on_border = false;

					gaps_in = 8;
					gaps_out = { top = 0; bottom = 16; left = 16; right = 16; };
					float_gaps = 16;
					gaps_workspaces = 0;

					border_size = 0;
					col.inactive_border = "rgb(000000)";
					col.active_border = "rgb(000000)";
					col.nogroup_border = "rgb(000000)";
					col.nogroup_border_active = "rgb(000000)";

					snap = {
						enabled = true;
						window_gap = 8;
						monitor_gap = 16;
						respect_gaps = true;
					};
				};

				decoration = {
					rounding = 16;
					rounding_power = 2;

					active_opacity = 1;
					inactive_opacity = 1;

					dim_modal = true;
					dim_inactive = false;
					dim_strength = 0.5;

					dim_special = 0.5;

					dim_around = 0.5;

					border_part_of_window = true;

					blur = {
						enabled = true;
						size = 8;
						passes = 2;

						ignore_opacity = true;
						xray = false;

						vibrancy = 1;
						vibrancy_darkness = 0;
						contrast = 2;
						brightness = 0.5;
						noise = 0;

						special = true;
						popups = false;
						input_methods = false;

						new_optimizations = true;
					};

					shadow = {
						enabled = true;
						range = 16;
						render_power = 4;
						sharp = false;
						color = "rgba(00000080)";
						offset = (lib.generators.mkLuaInline "{ 0, 0 }");
						scale = 1;
					};

					#motion_blur = {
					#	enabled = true;
					#	samples = 7;
					#};

					glow.enabled = false;
					#wobble.enabled = false;
				};

				animations = {
					enabled = true;
					workspace_wraparound = false;
				};

				input = {
					kb_layout = "se";
					kb_variant = "";
					kb_model = "";
					kb_options = "";
					kb_rules = "";

					numlock_by_default = false;

					resolve_binds_by_sym = false;

					repeat_rate = 25;
					repeat_delay = 600;

					sensitivity = -0.4;
					accel_profile = "flat";
					force_no_accel = false;
					rotation = 0;
					left_handed = false;
					emulate_discrete_scroll = 2;

					off_window_axis_events = 1;

					follow_mouse = 1;
					follow_mouse_shrink = 0;
					follow_mouse_threshold = 0;
					focus_on_close = 1;
					mouse_refocus = true;
					float_switch_override_focus = 1;
					special_fallthrough = false;
				};

				misc = {
					disable_autoreload = false;

					disable_hyprland_logo = true;
					disable_splash_rendering = true;
					disable_scale_notification = true;
					force_default_wallpaper = false;
					background_color = "rgb(000000)";

					vrr = 0;

					mouse_move_enables_dpms = false;
					#key_press_enabled_dpms = false;

					name_vk_after_proc = true;

					always_follow_on_dnd = true;

					layers_hog_keyboard_focus = true;

					animate_manual_resizes = false;
					animate_mouse_windowdragging = false;

					enable_swallow = false;

					focus_on_activate = false;
					on_focus_under_fullscreen = 2;

					exit_window_retains_fullscreen = false;

					mouse_move_focuses_monitor = true;

					allow_session_lock_restore = false;
					session_lock_xray = false;
					#session_lock_blur = false;
					lockdead_screen_delay = 1000;

					close_special_on_empty = false;

					initial_workspace_tracking = 1;
					#initial_workspace_token_timeout = 20;

					middle_click_paste = false;

					render_unfocused_fps = 15;

					disable_xdg_env_checks = false;
					disable_hyprland_guiutils_check = false;

					enable_anr_dialog = false;

					size_limits_tiled = false;

					screencopy_force_8b = true;

					disable_watchdog_warning = false;

					#bell_sound = "none";

					#float_force_onscreen = 0;
					#new_float_force_onscreen = 2;
				};

				layout = {
					single_window_aspect_ratio = (lib.generators.mkLuaInline "{ 0, 0 }" );
					single_window_aspect_ratio_tolerance = 0.1;
				};

				dwindle = {
					preserve_split = true;
				};

				binds = {
					pass_mouse_when_bound = false;
					
					scroll_event_delay = 300;

					workspace_back_and_forth = false;
					hide_special_on_workspace_change = true;
					allow_workspace_cycles = false;
					workspace_center_on = 1;

					focus_preferred_method = 0;

					ignore_group_lock = false;
					movefocus_cycles_fullscreen = false;
					movefocus_cycles_groupfirst = false;

					window_direction_monitor_fallback = true;

					disable_keybind_grabbing = false;

					allow_pin_fullscreen = false;

					drag_threshold = 0;
					#drag_center_window = true;
				};

				xwayland = {
					enabled = true;
					use_nearest_neighbor = true;
					force_zero_scaling = false;
					create_abstract_socket = false;
				};

				opengl = {
					nvidia_anti_flicker = false;	
				};

				render = {
					direct_scanout = 1;

					new_render_scheduling = false;	
				};

				ecosystem = {
					no_update_news = true;
					no_donation_nag = true;
				};
			};

			# Curves & Animation
			curve = [
				{ _args = [ "easeOutQuint" { type = "bezier"; points = (lib.generators.mkLuaInline "{{ 0.23, 1 }, { 0.32, 1 }}"); }]; }
				{ _args = [ "easeInQuint" { type = "bezier"; points = (lib.generators.mkLuaInline "{{ 0.64, 0 }, { 0.78, 0 }}"); }]; }
			];
			animation = [
				{ _args = [{ leaf = "global"; enabled = true; speed = 4; bezier = "default"; }]; }
				{ _args = [{ leaf = "fade"; enabled = true; speed = 1; bezier = "easeOutQuint"; }]; }
				{ _args = [{ leaf = "border"; enabled = true; speed = 4; bezier = "easeOutQuint"; }]; }
				{ _args = [{ leaf = "windows"; enabled = true; speed = 4; bezier = "easeOutQuint"; style = "popin 75%"; }]; }
				{ _args = [{ leaf = "windowsMove"; enabled = true; speed = 4; bezier = "easeOutQuint"; }]; }
				{ _args = [{ leaf = "layers"; enabled = true; speed = 4; bezier = "easeOutQuint"; style = "popin 75%"; }]; }
				{ _args = [{ leaf = "workspaces"; enabled = true; speed = 4; bezier = "easeOutQuint"; style = "slidevert"; }]; }
			];

			# Monitors
			monitor = [
				{ _args = [{ output = ""; mode = "preferred"; position = "auto"; scale = 1; }]; }
			];

			# Binds
			bind = [
				# Hyprland Management
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + M\"")
					(lib.generators.mkLuaInline "hl.dsp.exit()")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + Q\"")
					(lib.generators.mkLuaInline "hl.dsp.window.close()")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + V\"")
					(lib.generators.mkLuaInline "hl.dsp.window.float()")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + F\"")
					(lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + J\"")
					(lib.generators.mkLuaInline "hl.dsp.layout(\"togglesplit\")")
				]; }

				# Shell & Tools
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + HOME\"")
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(reloadShell)")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SUPER_L\"")
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(launcher)")
					{ release = true; }
				]; }
				{ _args = [
					"PRINT"
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(screenshot)")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + PRINT\"")
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(colorPick)")
				]; }

				# App Shortcuts
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + T\"")
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(terminal)")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + E\"")
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(fileManager)")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + B\"")
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(browser)")
				]; }

				# Workspaces (Should use for loops instead but im not sure how to do that with this syntax)
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 1\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 1 })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 2\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 2 })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 3\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 3 })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 4\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 4 })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 5\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 5 })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 6\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 6 })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 7\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 7 })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 8\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 8 })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 9\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 9 })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + 0\"")
					(lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 10 })")
				]; }

				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 1\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 1, follow = true })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 2\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 2, follow = true })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 3\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 3, follow = true })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 4\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 4, follow = true })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 5\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 5, follow = true })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 6\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 6, follow = true })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 7\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 7, follow = true })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 8\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 8, follow = true })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 9\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 9, follow = true })")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 0\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 10, follow = true })")
				]; }

				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + TAB\"")
					(lib.generators.mkLuaInline "hl.dsp.workspace.toggle_special(\"special\")")
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + TAB\"")
					(lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"special:special\" })")
				]; }

				# Windows
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + mouse:272\"")
					(lib.generators.mkLuaInline "hl.dsp.window.drag()")
					{ mouse = true; }
				]; }
				{ _args = [
					(lib.generators.mkLuaInline "mainMod .. \" + mouse:273\"")
					(lib.generators.mkLuaInline "hl.dsp.window.resize()")
					{ mouse = true; }
				]; }

				# Media & Volume
				{ _args = [
					"XF86AudioRaiseVolume"
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+\")")
					{ locked = true; repeating = true; }
				]; }
				{ _args = [
					"XF86AudioLowerVolume"
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
					{ locked = true; repeating = true; }
				]; }
				{ _args = [
					"XF86AudioMute"
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
					{ locked = true; }
				]; }
				{ _args = [
					"XF86AudioMicMute"
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
					{ locked = true; }
				]; }

				{ _args = [
					"XF86AudioPlay"
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
					{ locked = true; }
				]; }
				{ _args = [
					"XF86AudioPause"
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
					{ locked = true; }
				]; }
				{ _args = [
					"XF86AudioNext"
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")")
					{ locked = true; }
				]; }
				{ _args = [
					"XF86AudioPrev"
					(lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")")
					{ locked = true; }
				]; }
			];

			window_rule = [
				{ _args = [{ match = { class = ".*"; }; suppress_event = "maximize"; }]; }

				{ _args = [{ match = { class = "^$"; title = "^$"; xwayland = true; float = true; fullscreen = false; pin = false; }; no_focus = true; }]; }

				{ _args = [{ match = { initial_class = "Godot"; initial_title = "Godot"; }; tile = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "()"; }; float = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "()"; }; stay_focused = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "()"; }; rounding = 0; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "()"; }; border_size = 0; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "()"; }; no_anim = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "()"; }; no_focus = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "^(DEBUG)$"; }; decorate = false; }]; }

				{ _args = [{ match = { initial_class = "Godot"; title = "Create New Node"; }; stay_focused = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "Create Folder"; }; stay_focused = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "Create Script"; }; stay_focused = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "Create New Resource"; }; stay_focused = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "Create New Scene"; }; stay_focused = true; }]; }
				{ _args = [{ match = { initial_class = "Godot"; title = "^(Change Type of)"; }; stay_focused = true; }]; }

				#JetBrains
				# Prevent tooltips from taking focus (always have a title of `win.<id>`)
				#"no_initial_focus on, match:class ^(.*jetbrains.*)$, match:title ^(win.*)$"
				# Make "Go to file" and other dialogs always focused when open
				#"stay_focused on, match:class ^(.*jetbrains.*)$, match:title ^$, match:float true"
				# fix tab dragging (always have a single space character as their title)
				#"no_initial_focus on, match:class ^(.*jetbrains.*)$, match:title ^\\s$"
				# Tile new tabs automatically
				#"tile on, match:class ^(jetbrains-*), match:float false"

				# Unity
				# Move popups to cursor
				#"move (cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5)), match:class ^(Unity)$, match:title ^(Color)$"
				#"move (cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5)), match:class ^(Unity)$, match:title ^(HDR Color)$"

				{ _args = [{ match = { class = "^(code)$"; }; opacity = 0.9; }]; }
				{ _args = [{ match = { class = "^(Spotify)$"; }; opacity = 0.9; }]; }
				{ _args = [{ match = { class = "^(Bitwarden)$"; }; opacity = 0.9; }]; }
				{ _args = [{ match = { class = "^(steam)$"; }; opacity = 0.9; }]; }
			];

			layer_rule = [
				{ _args = [{ match = { namespace = "quickshell"; }; no_anim = true; }]; }
			];

			env = [
				{ _args = [ "XCURSOR_SIZE" 24 ]; }
				{ _args = [ "XCURSOR_THEME" "Posy_Cursor_Black" ]; }
				{ _args = [ "HYPRCURSOR_SIZE" 24 ]; }
				{ _args = [ "HYPRCURSOR_THEME" "hyprcursor_Posys-Cursor-Scalable-Mono-Black" ]; }
			];
		};
	};

	programs.alacritty.settings = {
		terminal = {
			shell = "fish";
		};
		window = {
			padding = {
				x = 8;
				y = 8;
			};
			dynamic_padding = true;
			decorations = "None";
			opacity = 0.9;
		};
		cursor = {
			style = {
				shape = "Beam";
				blinking = "On";
			};
		};
	};
}
