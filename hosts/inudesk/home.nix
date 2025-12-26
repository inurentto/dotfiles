{ config, pkgs, inputs, ... }: {
  # Module Imports
  imports = [
    ../../modules/home-manager
  ];

  # Home Manager
  home.username = "inurentto";
  home.homeDirectory = "/home/inurentto";
  home.stateVersion = "25.11";

  # Packages (Separate into modules)
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default

    protonup-ng

    kdePackages.kdenlive
    krita

    vulkan-tools

    kdePackages.ark

    hyprpolkitagent
    hyprshot

    gnome-disk-utility

    networkmanagerapplet

    openssl
    libargon2

    flatpak-xdg-utils
    glib

    firefox
    filezilla

    sourcegit
    jetbrains-toolbox

    zig

    gcc
    gdb
    cmake
    gnumake
    ninja

    jdk21

    qtcreator
    kdePackages.qt6ct
    nwg-look

    pavucontrol
    
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    rofi
    dunst
    libnotify
    playerctl
    
    prismlauncher
    r2modman
    steamcmd

    winetricks

    reaper
    vital

    pnpm_10
  ];

  # Hyprland
  compositors.hyprland = {
    enable = true;
    monitors = [
      "DP-1, 3840x2160@160, 0x0, 1"
      "DP-2, 3840x2160@160, 3840x0, 1"
    ];
  };

  # Waybar
  programs.waybar = {
    enable = true;
    style = ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: JetBrainsMono Nerd Font Propo, Roboto, Helvetica, Arial, sans-serif;
          font-size: 14px;
      }

      window#waybar {
          transition-property: background-color;
          transition-duration: .5s;
          
          border: 2px solid @base03;
          border-radius: 0px;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      .modules-left, .modules-right {
          margin: 0 4px;
      }

      .module {
          margin: 8px 4px;

          padding: 0 12px;
          
          border-radius: 4px;

          transition-property: background-color, color;
          transition-duration: .25s;
      }

      .module#workspaces {
          padding: 0 4px;
      }
      .module#workspaces button {
          margin-top: 4px;
          margin-bottom: 4px;
          padding: 0 4px;

          background-color: transparent;

          border: none;
          border-radius: 0px;
          box-shadow: none;

          transition-property: background-color, color;
          transition-duration: .25s;
      }
      .modules-left #workspaces button,
      .modules-left #workspaces button.focused,
      .modules-left #workspaces button.active,
      .modules-center #workspaces button,
      .modules-center #workspaces button.focused,
      .modules-center #workspaces button.active,
      .modules-right #workspaces button,
      .modules-right #workspaces button.focused,
      .modules-right #workspaces button.active {
        border-bottom: none;
      }
      .module#workspaces button:hover {
          background-color: @base02;
      }
      .module#workspaces button.active {
          background-color: @base0D;
          color: @base00;
      }
      .module#workspaces button.urgent {
          background-color: @base0F;
          color: @base00;
      }
      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }
      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      window #window {
          transition-duration: 0s;
      }
      window#waybar.empty #window {
          background-color: transparent;
      }

      .module#wireplumber.sink {
          margin-right: 0;

          padding-right: 6;

          border-top-right-radius: 0;
          border-bottom-right-radius: 0;
      }
      .module#wireplumber.source {
          margin-left: 0;

          padding-left: 6;

          border-top-left-radius: 0;
          border-bottom-left-radius: 0;
      }

      .module#power-profiles-daemon {
          margin-right: 0;

          padding-right: 6;

          border-top-right-radius: 0;
          border-bottom-right-radius: 0;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 48;
        spacing = 0;
        mode = "dock";
        margin-top = 20;
        margin-left = 20;
        margin-right = 20;

        modules-left = [
          "custom/power-menu"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "custom/spotify"
          "tray"
          "wireplumber#sink"
          "wireplumber#source"
          "bluetooth"
          "network"
          "memory"
          "cpu"
          "temperature"
        ];
        
        "custom/power-menu" = {
          format = "⏻";
          on-click = "rofi -show power-menu -modi power-menu:~/.config/rofi/rofi-power-menu";
          tooltip = false;
        };
        "hyprland/workspaces" = {
          format = "{name}";
        };
        "hyprland/window" = {
          icon = true;
          icon-size = 20;

          tooltip = true;
          tooltip-format = "Class: {class}\nInitial Class: {initialClass}\nTitle: {title}\nInitial Title: {initialTitle}";
        };

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%H:%M:%S - %Y-%m-%d}";
          interval = 1;
          
          calendar = {
            weeks-pos = "left";
          };
        };

        "custom/spotify" = {
          format = "{}";
          interval = 1;
          escape = true;
          return-type = "json";
          on-click = "playerctl -p spotify play-pause";
          on-click-right = "killall spotify";
          on-scroll-right = "playerctl -p spotify next";
          on-scroll-left = "playerctl -p spotify previous";
          on-scroll-up = "playerctl -p spotify volume 0.05+";
          on-scroll-down = "playerctl -p spotify volume 0.05-";
          exec = "$HOME/.config/waybar/spotify.sh";
        };
        "tray" = {
          spacing = 8;
        };
        "wireplumber#sink" = {
          node-type = "Audio/Sink";
          
          format = "{volume}% {icon}";
          format-muted = "MUTED ";
          format-icons = [ "" "" "" ];

          tooltip = true;
          tooltip-format = "Output\nDefault: {source_desc}";

          on-click = "pavucontrol";
        };
        "wireplumber#source" = {
          node-type = "Audio/Source";

          format = "{volume}% {icon}";
          format-muted = "MUTED ";
          format-icons = [ "" ];

          tooltip = true;
          tooltip-format = "Input\nDefault: {source_desc}";

          on-click = "pavucontrol";
        };
        "bluetooth" = {
          format-off = "Off 󰂲";
          format-on = "No Devices Connected 󰂯";
          format-connected = "{num_connections} 󰂱";
          format-no-controller = " 󰂯";

          tooltip = true;
          tooltip-format = "{status} with {num_connections} device(s) on controller {controller_alias}";

          on-click = "blueman-manager";
        };
        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "󰈀";
          format-linked = "󰌗";
          format-disconnected = "Disconnected ";
          tooltip-format = "{ifname} via {gwaddr}\n{ipaddr}/{cidr}\n{bandwidthDownBytes}  {bandwidthUpBytes} ";

          interval = 1;
        };
        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "Default ";
            performance = "Performance ";
            balanced = "Balanced ";
            power-saver = "Eco ";
          };
        };
        "memory" = {
          format = "{percentage}%  {swapPercentage}% 󰯍";
        };
        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
        };
        "temperature" = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
      };
    };
  };

  # Dunst
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_width = 2;
        corner_radius = 0;
        markup = true;
        format = "%s %p\n%b";
        sort = true;
        indicate_hidden = true;
        alignment = "left";
        bounce_freq = 5;
        show_age_threshold = 60;
        word_wrap = true;
        ignore_newline = false;
        origin = "top-center";
        offset = "(0, 20)";
        width = "(200, 1000)";
        height = "(50, 300)";
        shrink = true;
        transparency = 0;
        idle_threshold = 120;
        monitor = 0;
        follow = "mouse";
        sticky_history = true;
        history_length = 20;
        show_indicators = true;
        line_height = 0;
        separator_height = 1;
        padding = 8;
        horizontal_padding = 10;
        startup_notification = false;
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "app.zen_browser.zen";
        icon_position = "left;";
        icon_path = "/usr/share/icons/Adwaita/16x16/status/:/usr/share/icons/Adwaita/16x16/devices/";
        max_icon_size=128;
      };

      shortcuts = {
        close = "mod1+space";
        close_all = "ctrl+mod1+space";
        history = "ctrl+mod4+h ";
        context = "ctrl+mod1+c";
      };

      urgency_low = {
        timeout = 10;
      };

      urgency_normal = {
        timeout = 10;
      };

      urgency_critical = {
        timeout = 0;
      };
    };
  };

  # Rofi
  programs.rofi = {
    enable = true;
    theme = {
      "*" = {
        spacing = 10;
      };
      "window" = {
        border = 2;
        padding = 5;
        border-radius = 0;
        width = "500px";
      };
      "mainbox" = {
        border = 0;
        padding = 0;
      };
      "message" = {
        border = "2px 0px 0px";
        padding = "1px";
      };
      "listview" = {
        fixed-height = false;
        dynamic = true;
        spacing = "20px";
        scrollbar = true;
        padding = "5px 10px 10px 10px";
        lines = 20;
      };
      "element" = {
        border = 0;
        padding = "0px";
      };
      "element-icon" = {
        size = "20px";
      };
      "scrollbar" = {
        width = "5px";
        border = 0;
        handle-width = "10px";
        handle-rounded-corners = false;
        padding = "0px";
      };
      "mode-switcher" = {
        border = "2px 0px 0px";
      };
      "button" = {
        spacing = 0;
      };
      "inputbar" = {
        spacing = 0;
        padding = "10px 10px 0px 10px";
      };
      "case-indicator" = {
        spacing = 0;
      };
      "entry" = {
        spacing = 0;
      };
      "inputbar" = {
        children = [ "entry" "case-indicator" ];
      };
    };
  };

  # Alacritty
  programs.alacritty = {
    enable = true;
  };

  # Firefox
  programs.firefox = {
    enable = true;
    profiles = {
      main = {
        name = "Main";
        id = 0;

        search.default = "ddg";

        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            sponsorblock
          ];
          settings."uBlock0@raymondhill.net".settings = {
            selectedFilterLists = [
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-unbreak"
              "ublock-quick-fixes"
            ];
          };
        };
      };
    };
  };

  # Visual Studio Code
  programs.vscode = {
    enable = true;
  };

  # Vesktop
  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "stable";
      minimizeToTray = true;
      arRPC = true;
      slpashTheming = true;
      slpashColor = "rgb(230, 231, 233)";
      hardwareVideoAcceleration = true;
      checkUpdates = false;
    };
    vencord = {
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = true;
        themeLinks = [];
        eagerPatches = false;
        enabledThemes = [];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;
        plugins = {
          ChatInputButtonAPI.enabled = true;
          CommandsAPI.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          MessagePopoverAPI.enabled = true;
          MessageUpdaterAPI.enabled = true;
          ServerListAPI.enabled = true;
          UserSettingsAPI.enabled = true;
          AccountPanelServerProfile.enabled = true;
          AlwaysAnimate.enabled = true;
          AlwaysExpandRoles.enabled = true;
          AnonymiseFileNames = {
            enabled = true;
            anonymiseByDefault = true;
            method = 0;
            randomisedLength = 7;
            consistent = "image";
          };
          BetterFolders = {
            enabled = true;
            sidebar = true;
            sidebarAnim = true;
            closeAllFolders = true;
            closeAllHomeButton = true;
            closeOthers = true;
            forceOpen = true;
            keepIcons = false;
            showFolderIcon = 2;
          };
          BetterGifAltText.enabled = true;
          BetterGifPicker.enabled = true;
          BetterNotesBox = {
            enabled = true;
            hide = true;
            noSpellCheck = true;
          };
          BetterRoleContext = {
            enabled = true;
            roleIconFileFormat = "png";
          };
          BetterRoleDot = {
            enabled = true;
            bothStyles = false;
            copyRoleColorInProfilePopout = false;
          };
          BetterSessions = {
            enabled = true;
            backgroundCheck = true;
            checkInterval = 20;
          };
          BetterSettings ={
            enabled = true;
            disableFade = true;
            organizeMenu = true;
            eagerLoad = true;
          };
          BetterUploadButton.enabled = true;
          BiggerStreamPreview.enabled = true;
          CallTimer = {
            enabled = true;
            format = "stopwatch";
          };
          ClearURLs.enabled = true;
          CopyEmojiMarkdown.enabled = true;
          CopyFileContents.enabled = true;
          CopyStickerLinks.enabled = true;
          CopyUserURLs.enabled = true;
          CrashHandler.enabled = true;
          DisableCallIdle.enabled = true;
          ExpressionCloner.enabled = true;
          FavoriteEmojiFirst.enabled = true;
          FavoriteGifSearch.enabled = true;
          FixCodeblockGap.enabled = true;
          FixImagesQuality.enabled = true;
          FixSpotifyEmbeds = {
            enabled = true;
            volume = 10;
          };
          FixYoutubeEmbeds.enabled = true;
          ForceOwnerCrown.enabled = true;
          FriendInvites.enabled = true;
          FriendsSince.enabled = true;
          FullSearchContext.enabled = true;
          FullUserInChatbox.enabled = true;
          GreetStickerPicker = {
            enabled = true;
            greetMode = "Greet";
          };
          HideMedia.enabled = true;
          ImageFilename = {
            enabled = true;
            showFullUrl = false;
          };
          ImageZoom = {
            enabled = true;
            saveZoomValues = true;
            invertScroll = true;
            nearestNeighbour = false;
            square = true;
            zoom = 5.0;
            size = 700;
            zoomSpeed = 0.5;
          };
          ImplicitRelationships = {
              enabled = true;
              sortByAffinity = true;
          };
          KeepCurrentChannel.enabled = true;
          MemberCount = {
              enabled = true;
              toolTip = true;
              memberList = true;
              voiceActivity = true;
          };
          MentionAvatars = {
              enabled = true;
              showAtSymbol = true;
          };
          MessageClickActions = {
              enabled = true;
              enableDeleteOnClick = true;
              enableDoubleClickToEdit = true;
              enableDoubleClickToReply = true;
              requireModifier = false;
          };
          MessageLatency = {
              enabled = true;
              latency = 2;
              detectDiscordKotlin = true;
              showMillis = false;
              ignoreSelf = false;
          };
          MessageLogger = {
              enabled = true;
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
          NoF1.enabled = true;
          NoOnboardingDelay.enabled = true;
          NoPendingCount = {
              enabled = true;
              hideFriendRequestsCount = false;
              hideMessageRequestsCount = false;
              hidePremiumOffersCount = true;
          };
          NoReplyMention = {
              enabled = true;
              userList = "1234567890123445,1234567890123445";
              roleList = "1234567890123445,1234567890123445";
              shouldPingListed = true;
              inverseShiftReply = false;
          };
          OpenInApp = {
              enabled = true;
              spotify = true;
              steam = true;
              epic = true;
              tidal = true;
              itunes = true;
          };
          PauseInvitesForever.enabled = true;
          PermissionFreeWill = {
              enabled = true;
              lockout = true;
              onboarding = true;
          };
          PermissionsViewer = {
              enabled = true;
              permissionsSortOrder = 0;
          };
          ReadAllNotificationsButton.enabled = true;
          ReverseImageSearch.enabled = true;
          SendTimestamps = {
              enabled = true;
              replaceMessageContents = true;
          };
          ShikiCodeblocks = {
              enabled = true;
              theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/2d87559c7601a928b9f7e0f0dda243d2fb6d4499/packages/tm-themes/themes/dark-plus.json";
              tryHljs = "SECONDARY";
              useDevIcon = "GREYSCALE";
              bgOpacity = 99.81949458483754;
          };
          SpotifyControls = {
              enabled = true;
              hoverControls = true;
              useSpotifyUris = false;
              previousButtonRestartsTrack = true;
          };
          SpotifyCrack = {
              enabled = true;
              noSpotifyAutoPause = true;
              keepSpotifyActivityOnIdle = true;
          };
          SpotifyShareCommands.enabled = true;
          UserMessagesPronouns = {
              enabled = true;
              pronounsFormat = "LOWERCASE";
              showSelf = true;
          };
          ValidReply.enabled = true;
          ValidUser.enabled = true;
          VolumeBooster = {
              enabled = true;
              multiplier = 3;
          };
          WebKeybinds.enabled = true;
          WebScreenShareFixes.enabled = true;
          WhoReacted.enabled = true;
          YoutubeAdblock.enabled = true;
          BadgeAPI.enabled = true;
          NoTrack = {
              enabled = true;
              disableAnalytics = true;
          };
          Settings = {
              enabled = true;
              settingsLocation = "aboveNitro";
          };
          DisableDeepLinks.enabled = true;
          SupportHelper.enabled = true;
          WebContextMenus.enabled = true;
        };
      };
    };
  };

  # Spicetify
  programs.spicetify = {
    enable = true;
  };

  # Stylix
  services.stylix = {
    enable = true;
    base16Scheme = "ayu-dark";
    firefox.profileNames = [ "main" ];
  };

  # Nixcord
  # programs.nixcord = {
  #   enable = true;
  #   discord = {
  #     enable = true;
  #     vencord.enable = false;
  #     equicord.enable = true;
  #   };
  #   vesktop.enable = true;
  #   equibop.enable = true;
  # };
}