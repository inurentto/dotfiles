{ config, pkgs, inputs, lib, ... }: {
	# Module Imports
	imports = [
		../../modules/home-manager
	];

	# Nixpkgs
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.permittedInsecurePackages = [
		"electron-39.8.10" # Allowed for Discord (Version is EOL)
	];

	# Packages (Separate into modules)
	home.packages = with pkgs; [
		kdePackages.kdenlive
		krita

		vulkan-tools

		hyprpicker
		grimblast

		openssl
		libargon2

		bitwarden-cli
		bitwarden-desktop

		flatpak-xdg-utils
		glib

		filezilla

		sourcegit

		qtcreator
		kdePackages.qt6ct
		nwg-look

		libnotify
		playerctl

		prismlauncher
		r2modman
		steamcmd

		reaper
		vital

		davinci-resolve

		heroic

		renderdoc

		vpkedit

		kdePackages.isoimagewriter

		craftos-pc

		shaderc

		deadlock-mod-manager

		pywalfox-native

		protonup-qt

		font-manager
	];

	# Hyprland
	wayland.windowManager.hyprland = {
		enable = true;

		settings = {
			mainMod = { _var = "SUPER"; };

			terminal = { _var = "alacritty"; };
			fileManager = { _var = "dolphin"; };
			browser = { _var = "firefox"; };

			reloadShell = { _var = "pkill quickshell; hyprctl eval \"hl.exec_cmd('qs')\""; };
			launcher = { _var = "qs ipc call launcher open"; };
			screenshot = { _var = "grimblast --notify --expire-time 8000 --freeze copysave area"; };
			colorPick = { _var = "hyprpicker --notify --autocopy --render-inactive"; };

			monitor = [
				{ _args = [{ output = "DP-1"; mode = "3840x2160@160"; position = "0x0"; scale = 1; }]; }
				{ _args = [{ output = "DP-2"; mode = "3840x2160@160"; position = "3840x0"; scale = 1; }]; }
			];

			on = {
				_args = [
					"hyprland.start"
					(lib.generators.mkLuaInline ''function()
	hl.exec_cmd("pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=VirtualMic channel_map=front-left,front-right")
	hl.exec_cmd("pw-jack carla -n ~/.audio-setup/carla-main.carxp")
	hl.exec_cmd("qpwgraph ~/.audio-setup/patchbay-main.qpwgraph")
	
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("pywalfox start --profile-path ~/.config/mozilla/firefox/main --manifest-path ~/.config/mozilla/native-messaging-hosts")
	hl.exec_cmd("qs")

	hl.exec_cmd("streamcontroller -b")
	hl.exec_cmd("openrgb --startminimized -p Main.orp")
	
	hl.exec_cmd("hypridle")
end'')
				];
			};
		};
	};

	# Hypridle
	services.hypridle = {
		enable = true;
		settings = {
			general = {
				after_sleep_cmd = "hyprctl dispatch dpms on";
				ignore_dbus_inhibit = false;
			};

			listener = [
				{
					timeout = 1200;
					on-timeout = "hyprctl dispatch dpms off";
					on-resume = "hyprctl dispatch dpms on";
				}
			];
		};
	};

	# Shell
	programs.quickshell = {
		enable = true;
	};

	# Theming
	## Cursor
	home.pointerCursor = {
		gtk.enable = true;
		package = pkgs.posy-cursors;
		name = "Posy_Cursor_Black";
		size = 24;
	};
	## GTK
	gtk = {
		enable = true;
		iconTheme = {
			name = "Papirus-Dark";
			package = pkgs.papirus-icon-theme;
		};
	};
	## Qt
	qt = {
		enable = true;
		platformTheme.name = "qtct";
		qt5ctSettings = {
			Appearence = {
				icon_theme = "Papirus-Dark";
				standard_dialogs = "xdgdesktopportal";
			};
			Fonts = {
				general = "\"JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular,0,0\"";
				fixed = "\"JetBrainsMono Nerd Font Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular,0,0\"";
			};
		};
		qt6ctSettings = {
			Appearence = {
				icon_theme = "Papirus-Dark";
				standard_dialogs = "xdgdesktopportal";
			};
			Fonts = {
				general = "\"JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular,0,0\"";
				fixed = "\"JetBrainsMono Nerd Font Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular,0,0\"";
			};
		};
	};
	## Color Palette
	programs.wallust = {
		enable = true;
		settings = {
			backend = "wal";
			palette = "dark16";
			color_space = "lch";
			fallback_generator = "complementary";

			templates = {
				wal = { src = "wal.json"; dst = "~/.cache/wal/colors.json"; };

				quickshell = { src = "quickshell.qml"; dst = "~/.config/quickshell/singletons/Config.qml"; };

				gtk3 = { src = "gtk.css"; dst = "~/.config/gtk-3.0/colors.css"; };
				gtk4 = { src = "gtk.css"; dst = "~/.config/gtk-4.0/colors.css"; };

				alacritty = { src = "alacritty.toml"; dst = "~/.config/alacritty/colors.toml"; };

				vscode = { src = "vscode.json"; dst = "~/.cache/wallust/colors.json"; };
				vscode2 = { src = "vscode"; dst = "~/.cache/wallust/colors"; };
			};
		};
	};

	### Templates
	home.file.".config/wallust/templates/wal.json" = { source = ./wallust-templates/wal.json; force = true; };

	home.file.".config/wallust/templates/quickshell.qml" = { source = ./wallust-templates/quickshell.qml; force = true; };

	home.file.".config/wallust/templates/gtk.css" = { source = ./wallust-templates/gtk.css; force = true; };

	home.file.".config/wallust/templates/alacritty.toml" = { source = ./wallust-templates/alacritty.toml; force = true; };

	home.file.".config/wallust/templates/vscode" = { source = ./wallust-templates/vscode/vscode; force = true; };
	home.file.".config/wallust/templates/vscode.json" = { source = ./wallust-templates/vscode/vscode.json; force = true; };

	## Wallpaper
	services.awww = {
		enable = true;
	};

	# Cliphist
	services.cliphist = {
		enable = true;
	};

	# Alacritty
	programs.alacritty = {
		enable = true;
		settings = {
			general = {
				import = [ "colors.toml" ];
			};
		};
	};

	# Firefox
	programs.firefox = {
		enable = true;
		configPath = "${config.xdg.configHome}/mozilla/firefox";
		profiles = {
			main = {
				name = "Main";
				id = 0;

				search = {
					default = "ddg";
					force = true;
				};

				extensions.force = false;
			};
		};
	};

	# Visual Studio Code
	programs.vscode = {
		enable = true;
		profiles.default = {
			enableUpdateCheck = false;
			enableExtensionUpdateCheck = false;
			userSettings = {
				"workbench.colorTheme" = "Catppuccin Macchiato";
				"workbench.iconTheme" = "catppuccin-perfect-macchiato";
				"workbench.sideBar.location" = "right";
				"workbench.startupEditor" = "none";

				"explorer.compactFolders" = false;
				"explorer.confirmDragAndDrop" = false;
				"explorer.confirmDelete" = false;

				"terminal.external.linuxExec" = "fish";

				"editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";

				"chat.disableAIFeatures" = true;
				"chat.agent.enabled" = false;

				"svelte.enable-ts-plugin" = true;

				"workbench.editorAssociations" = {
					"*.copilotmd" = "vscode.markdown.preview.editor";
					"{git,gitlens,chat-editing-snapshot-text-model,copilot,git-graph,git-graph-3}:/**/*.qrc" = "default";
					"*.qrc" = "qt-core.qrcEditor";
				};

				"zig.zls.enabled" = "on";
			};
		};
	};

	# Spicetify
	programs.spicetify = {
		enable = true;
	};

	# Nixcord
	programs.nixcord = {
		enable = true;

		discord = {
			enable = true;
			vencord.enable = false;
			equicord.enable = true;
		};

		vesktop.enable = false;
		equibop.enable = false;

		config = {
			autoUpdate = true;
			autoUpdateNotification = true;
			frameless = true;
			useQuickCss = true;
			plugins = {
				accountPanelServerProfile.enable = true;
				alwaysExpandRoles.enable = true;
				anonymiseFileNames = {
					enable = true;
					anonymiseByDefault = true;
					method = 0;
					randomisedLength = 7;
					consistent = "image";
				};
				betterFolders = {
					enable = true;
					sidebar = true;
					sidebarAnim = true;
					closeAllFolders = true;
					closeAllHomeButton = true;
					closeOthers = true;
					forceOpen = true;
					keepIcons = false;
					showFolderIcon = 2;
				};
				betterGifAltText.enable = true;
				betterGifPicker.enable = true;
				betterRoleContext = {
					enable = true;
					roleIconFileFormat = "png";
				};
				betterRoleDot = {
					enable = true;
					bothStyles = false;
					copyRoleColorInProfilePopout = false;
				};
				betterSessions = {
					enable = true;
					backgroundCheck = true;
					checkInterval = 20;
				};
				betterSettings ={
					enable = true;
					disableFade = true;
					organizeMenu = true;
					eagerLoad = true;
				};
				betterUploadButton.enable = true;
				blockKrisp.enable = true;
				biggerStreamPreview.enable = true;
				callTimer = {
					enable = true;
					format = "stopwatch";
				};
				copyEmojiMarkdown.enable = true;
				copyFileContents.enable = true;
				copyStickerLinks.enable = true;
				crashHandler.enable = true;
				disableCallIdle.enable = true;
				expressionCloner.enable = true;
				favoriteEmojiFirst.enable = true;
				fixCodeblockGap.enable = true;
				fixImagesQuality.enable = true;
				fixSpotifyEmbeds = {
					enable = true;
				};
				fixYoutubeEmbeds.enable = true;
				forceOwnerCrown.enable = true;
				friendInvites.enable = true;
				fullSearchContext.enable = true;
				fullUserInChatbox.enable = true;
				greetStickerPicker = {
					enable = true;
					greetMode = "Greet";
				};
				hideMedia.enable = true;
				imageFilename = {
					enable = true;
					showFullUrl = false;
				};
				imageZoom = {
					enable = true;
					saveZoomValues = true;
					invertScroll = true;
					nearestNeighbour = false;
					square = true;
					zoom = 5.0;
					size = 700.0;
					zoomSpeed = 0.5;
				};
				implicitRelationships = {
					enable = true;
					sortByAffinity = true;
				};
				keepCurrentChannel.enable = true;
				memberCount = {
					enable = true;
					toolTip = true;
					memberList = true;
					voiceActivity = true;
				};
				mentionAvatars = {
					enable = true;
					showAtSymbol = true;
				};
				messageClickActions = {
					enable = true;
					enableDeleteOnClick = true;
					enableDoubleClickToEdit = true;
					enableDoubleClickToReply = true;
					requireModifier = false;
				};
				messageLatency = {
					enable = true;
					latency = 2;
					detectDiscordKotlin = true;
					showMillis = false;
					ignoreSelf = false;
				};
				messageLogger = {
					enable = true;
					deleteStyle = "overlay";
					logDeletes = true;
					collapseDeleted = false;
					logEdits = true;
					inlineEdits = true;
					ignoreBots = false;
					ignoreSelf = false;
					ignoreUsers = "";
					ignoreChannels = "";
					ignoreGuilds = "";
				};
				noF1.enable = true;
				noOnboardingDelay.enable = true;
				noPendingCount = {
					enable = true;
					hideFriendRequestsCount = false;
					hideMessageRequestsCount = false;
					hidePremiumOffersCount = true;
				};
				noReplyMention = {
					enable = true;
					userList = "1234567890123445,1234567890123445";
					roleList = "1234567890123445,1234567890123445";
					shouldPingListed = true;
					inverseShiftReply = false;
				};
				openInApp = {
					enable = true;
					spotify = true;
					steam = true;
				};
				pauseInvitesForever.enable = true;
				permissionFreeWill = {
					enable = true;
					lockout = true;
					onboarding = true;
				};
				permissionsViewer = {
					enable = true;
					permissionsSortOrder = 0;
				};
				readAllNotificationsButton.enable = true;
				reverseImageSearch.enable = true;
				sendTimestamps = {
					enable = true;
					replaceMessageContents = true;
				};
				spotifyCrack = {
					enable = true;
					noSpotifyAutoPause = true;
					keepSpotifyActivityOnIdle = true;
				};
				spotifyShareCommands.enable = true;
				userMessagesPronouns = {
					enable = true;
					pronounsFormat = "LOWERCASE";
					showSelf = true;
				};
				validReply.enable = true;
				validUser.enable = true;
				volumeBooster = {
					enable = true;
					multiplier = 3.0;
				};
				webKeybinds.enable = true;
				webScreenShareFixes.enable = true;
				whoReacted.enable = true;
				youtubeAdblock.enable = true;
				noNitroUpsell.enable = true;
				equibopStreamFixes.enable = true;
			};
		};
	};

	# Zed
	programs.zed-editor = {
		enable = true;
		extensions = [
			"toml"

		 	"nix"

			"make"

			"qml"
		];
		userSettings = {
			disable_ai = true;

			auto_update = false;

			base_keymap = "VSCode";

			hard_tabs = true;
			show_whitespaces = "all";
		};
	};

	# Mullvad VPN
	programs.mullvad-vpn = {
		enable = true;
		settings = {
			animateMap = true;
			autoConnect = true;
			browsedForSplitTunnelingApplications = [];
			changelogDisplayedForVersion = "";
			enableSystemNotifications = true;
			monochromaticIcon = true;
			preferredLocale = "system";
			startMinimized = true;
			unpinnedWindow = true;
			updateDismissedForVersion = "";
		};
	};

	# Obsidian
	programs.obsidian = {
		enable = true;
	};

	# OnlyOffice
	programs.onlyoffice = {
		enable = true;
		settings = {
		  UITheme = "theme-contrast-dark";
		  editorWindowMode = true;
		  titlebar = "custom";
		};
	};

	# State Version
	home.stateVersion = "25.11";
}
