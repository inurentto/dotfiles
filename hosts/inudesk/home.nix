{ config, pkgs, inputs, lib, ... }: {
	# Module Imports
	imports = [
		../../modules/home-manager
	];

	# Nixpkgs
	nixpkgs.config.allowUnfree = true;

	# Environement Variables
	home.sessionVariables = {
		QT_STYLE_OVERRIDE = "kvantum";
		KRITA_NO_STYLE_OVERRIDE = "1";
	};

	# Packages (Separate into modules)
	home.packages = with pkgs; [
		# Disk Management
		kdePackages.partitionmanager
		kdePackages.isoimagewriter
		
		# Shell
		inputs.inu-shell.packages.${pkgs.stdenv.hostPlatform.system}.default

		# Theming
		pywalfox-native
		papirus-icon-theme
		kdePackages.qt6ct
		nwg-look

		# Font Management
		font-manager

		# Mail
		protonmail-desktop

		# Music Players
		# inputs.sone.packages.${pkgs.stdenv.hostPlatform.system}.default # poop ass vibe coded shit slop that takes up 100% processing power on ONE THREAD when i scroll on a FUCKING page (replace when tidal comes out with a native client, or a better one is available)
		# tidal-hifi # this one just doesn't work and tries to like load the page multiple times a second and fails every time?

		# Video & Image Editing
		kdePackages.kdenlive
		krita

		# Password Management
		bitwarden-cli
		bitwarden-desktop

		# Git Client
		sourcegit

		# Image Viewer
		kdePackages.gwenview

		# Video & Audio Player
		vlc

		# Godot
		godotPackages_4_7.godot
		godotPackages_4_7.godot-mono

		# Unity
		unityhub

		# Game Modding
		(prismlauncher.override {
			additionalLibs = [
				alsa-lib
				libGL
				vulkan-loader

				libx11
				libxcursor
				libxext
				libxfixes
				libxi
				libxrandr
				libxrender
				libxtst
				libxinerama
				libice
				libsm
				libxkbcommon
				libpulseaudio
				libxft
				icu

				wayland
				libdecor 
			];

			jdks = [
				jdk21
				jdk25
			];
		})
		r2modman
		deadlock-mod-manager

		# Debugging
		renderdoc

		# Custom Steam Proton Version Management
		protonup-qt
	];

	# Hyprland
	wayland.windowManager.hyprland = {
		enable = true;
		systemd.enable = false;

		extraLuaFiles = {
			"inudesk" = {
				content = ./hyprland/hyprland.lua;
				autoLoad = true;
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

	# Theming
	## Cursor
	home.pointerCursor = {
		enable = true;
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
		style = {
			name = "kvantum";
			package = pkgs.kdePackages.qtstyleplugin-kvantum;
		};
		qt6ctSettings = {
			Appearance = {
				icon_theme = "Papirus-Dark";
				standard_dialogs = "xdgdesktopportal";
				style = "kvantum";
			};
			Fonts = {
				fixed = "\"JetBrainsMono Nerd Font Propo,12\"";
				general = "\"JetBrainsMono Nerd Font Mono,12\"";
			};
		};
		kvantum = {
			enable = true;
			settings.General.theme = "catppuccin-macchiato-lavender";
			themes = with pkgs; [
				catppuccin-kvantum
			];
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

	# Kde Settings
	home.file.".config/kdeglobals" = { source = ./kde-settings/kdeglobals; force = false; };
	home.file.".config/dolphinrc" = { source = ./kde-settings/dolphinrc; force = false; };

	# Wallpaper
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
		mutableExtensionsDir = true;
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
				"terminal.integrated.defaultProfile.linux" = "fish";
				"terminal.integrated.profiles.linux" = {
					"bash" = {
						"path" = "bash";
						"icon" = "terminal-bash";
					};
					"zsh" = {
						"path" = "zsh";
					};
					"fish" = {
						"path" = "fish";
					};
					"tmux" = {
						"path" = "tmux";
						"icon" = "terminal-tmux";
					};
					"pwsh" = {
						"path" = "pwsh";
						"icon" = "terminal-powershell";
					};
				};

				"editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
				"editor.insertSpaces" = false;

				"chat.disableAIFeatures" = true;
				"chat.agent.enabled" = false;

				"svelte.enable-ts-plugin" = true;

				"qt-core.showWelcomePageOnActivation" = false;

				"zig.zls.enabled" = "on";
			};
		};
	};

	# Nixcord
	programs.nixcord = {
		enable = true;

		discord = {
			enable = true;
			equicord.enable = true;
			krisp.enable = false;
		};

		config = {
			autoUpdate = true;
			autoUpdateNotification = true;
			notifyAboutUpdates = true;

			frameless = true;
			
			plugins = {
				accountPanelServerProfile.enable = true;
				addAttachments.enable = true;
				advancedPermissions.enable = true;
				alwaysExpandRoles.enable = true;
				anonymiseFileNames.enable = true;
				atSomeone.enable = true;
				betterActivities.enable = true;
				betterBackreading.enable = true;
				betterCommands = {
					enable = true;
					autoFillArguments = false;
				};
				betterFolders = {
					enable = true;
					closeAllFolders = true;
					closeAllHomeButton = true;
					closeOthers = true;
					forceOpen = true;
					showFolderIcon = 2;
				};
				betterForwards = {
					resendOnFail = false;
				};
				betterGifAltText.enable = true;
				betterGifPicker.enable = true;
				betterInvites.enable = true;
				betterRoleContext.enable = true;
				betterSessions.enable = true;
				betterSettings.enable = true;
				betterUploadButton.enable = true;
				biggerStreamPreview.enable = true;
				blockKrisp.enable = true;
				bypassPinPrompt.enable = true;
				callTimer = {
					enable = true;
					allCallTimers = true;
					trackSelf = true;
				};
				cancelFriendRequest.enable = true;
				clearUrls.enable = true;
				clickableRoles.enable = true;
				copyEmojiMarkdown.enable = true;
				copyFileContents.enable = true;
				copyProfileColors.enable = true;
				copyUserMention.enable = true;
				crashHandler.enable = true;
				customFolderIcons.enable = true;
				customTimestamps = {
					formats.enable = false;
				};
				declutter = {
					enable = true;
					alwaysShowUsername = false;
					removeBillingSettings = false;
					removeClanTag = false;
					removeDisplayNameStyles = false;
					removeLibraryAboveDms = true;
					removeNameplate = false;
					removeProfileEffect = false;
					removeProfileFrame = false;
					removeQuestsAboveDms = true;
					removeServerBoostInfo = false;
				};
				directFileDownload.enable = true;
				disableCallIdle.enable = true;
				dragFavoriteEmotes.enable = true;
				dragify.enable = true;
				equibopStreamFixes.enable = true;
				equiTweaks = {
					enable = true;
					noMirroredCamera = true;
					refreshSlashCommands = true;
				};
				fakeNitro = {
					enable = true;
					enableEmojiBypass = false;
					enableStickerBypass = false;
				};
				favoriteAnything = {
					enable = true;
					localThumbnails = true;
				};
				favoriteEmojiFirst.enable = true;
				findReply.enable = true;
				fixCodeblockGap.enable = true;
				fixImagesQuality.enable = true;
				fixSpotifyEmbeds.enable = true;
				fixYoutubeEmbeds.enable = true;
				forceOwnerCrown.enable = true;
				friendInvites.enable = true;
				fullSearchContext.enable = true;
				fullUserInChatbox.enable = true;
				gifProviderSwitcher.enable = true;
				greetStickerPicker.enable = true;
				hideMedia.enable = true;
				imageFilename.enable = true;
				imageZoom = {
					enable = true;
					size = 700.0;
					square = true;
					zoom = 5.0;
				};
				implicitRelationships.enable = true;
				jumpToTop.enable = true;
				keepCurrentChannel.enable = true;
				memberCount.enable = true;
				mentionAvatars.enable = true;
				messageClickActions.enable = true;
				messageLatency.enable = true;
				messageLogger = {
					enable = true;
					deleteStyle = "overlay";
					ignoreBots = false;
				};
				middleClickTweaks.enable = true;
				moreUserTags = {
					tagSettings = {
						administrator.enable = false;
						chatModerator.enable = false;
						moderator.enable = false;
						moderatorStaff.enable = false;
						owner.enable = false;
						voiceModerator.enable = false;
						webhook.enable = false;
						enable = false;
					};
				};
				newPluginsManager.enable = true;
				noF1.enable = true;
				noNitroUpsell.enable = true;
				noOnboardingDelay.enable = true;
				noPendingCount = {
					enable = true;
					hideFriendRequestsCount = false;
					hideMessageRequestsCount = false;
				};
				noReplyMention.enable = true;
				noSystemBadge.enable = true;
				notificationTitle.enable = true;
				openInApp.enable = true;
				pauseInvitesForever.enable = true;
				permissionFreeWill.enable = true;
				permissionsViewer.enable = true;
				petpet.enable = true;
				pinIcon.enable = true;
				readAllNotificationsButton.enable = true;
				reverseImageSearch.enable = true;
				searchFix.enable = true;
				sendTimestamps.enable = true;
				spotifyCrack = {
					keepSpotifyActivityOnIdle = true;
				};
				tidalEmbeds.enable = true;
				userMessagesPronouns.enable = true;
				validReply.enable = true;
				validUser.enable = true;
				volumeBooster = {
					enable = true;
					multiplier = 3.0;
				};
				webKeybinds.enable = true;
				webScreenShareFixes.enable = true;
				whoReacted.enable = true;
				whosWatching.enable = true;
				youtubeAdblock.enable = true;
			};
		};
		extraConfig.plugins = {
			musicRichPresence = {
				showLastFmLogo = true;
			};
			serverListIndicators = {
				useCompact = false;
			};
			shikiCodeblocks = {
				tryHljs = "SECONDARY";
			};
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
