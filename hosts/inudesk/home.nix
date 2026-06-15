{ config, pkgs, inputs, lib, ... }: {
  # Module Imports
  imports = [
    ../../modules/home-manager
  ];

  # Home Manager
  home.username = "inurentto";
  home.homeDirectory = "/home/inurentto";
  home.stateVersion = "25.11";

  # Nixpkgs
  nixpkgs.config.allowUnfree = true;

  # Packages (Separate into modules)
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default

    protonup-ng

    kdePackages.kdenlive
    krita

    vulkan-tools

    kdePackages.ark

    hyprpicker
    grimblast

    gnome-disk-utility

    openssl
    libargon2

    bitwarden-cli
    bitwarden-desktop

    flatpak-xdg-utils
    glib

    firefox
    filezilla

    sourcegit
    jetbrains-toolbox

    qtcreator
    kdePackages.qt6ct
    nwg-look

    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    libnotify
    playerctl

    prismlauncher
    r2modman
    steamcmd

    reaper
    vital

    pnpm_10

    davinci-resolve

    heroic

    renderdoc

    vpkedit

    kdePackages.isoimagewriter

    craftos-pc

    shaderc

    deadlock-mod-manager

    hexedit
  ];

  # Hyprland
  compositors.hyprland = {
    enable = true;
    monitors = [
      "DP-1, 3840x2160@160, 0x0, 1"
      "DP-2, 3840x2160@160, 3840x0, 1"
    ];
    autostart = [
      "mullvad-vpn"

      "~/.audio-setup/start.sh"

      "awww-daemon"
      "qs"

      "streamcontroller -b"

      "hypridle"

      "bitwarden"
    ];
  };

  # Cursor
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.posy-cursors;
    name = "Posy_Cursor_Black";
    size = 24;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
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

  # Cliphist
  services.cliphist = {
    enable = true;
  };

  # Stylix
  services.stylix = {
    enable = true;
    base16Scheme = "ayu-dark";
    firefox.profileNames = [ "main" ];
  };

  # Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
        decorations = "None";
      };
    };
  };

  # Firefox
  programs.firefox = {
    enable = true;
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
      extensions = with pkgs.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide
        arrterian.nix-env-selector

        # C++
        ms-vscode.cpptools
        ms-vscode.cmake-tools
        ms-vscode.makefile-tools

        # C#
        ms-dotnettools.csharp
        ms-dotnettools.vscode-dotnet-runtime

        # Unity
        visualstudiotoolsforunity.vstuc

        # QML
        #bbenoist.qml <<< doesnt exiiiiiiisssssstttt on the nix vscode extension repooooooooooooooooooooooooooooooooooooooooooooo BLEHHHHHHHHHHH

        # Svelte
        svelte.svelte-vscode

        # TOML
        tamasfe.even-better-toml
      ];
      userSettings = {
        "workbench.sideBar.location" = "right";

        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmDelete" = false;
        "github.copilot.enable.*" = false;

        "svelte.enable-ts-plugin" = true;

        "workbench.editorAssociations" = {
          "*.copilotmd" = "vscode.markdown.preview.editor";
          "{git,gitlens,chat-editing-snapshot-text-model,copilot,git-graph,git-graph-3}:/**/*.qrc" = "default";
          "*.qrc" = "qt-core.qrcEditor";
        };
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
      autoUpdate = false;
      autoUpdateNotification = false;
      useQuickCss = true;
      themeLinks = [];
      enabledThemes = [];
      enableReactDevtools = false;
      frameless = false;
      transparent = false;
      #winCtrlQ = false;
      disableMinSize = false;
      #winNativeTitleBar = false;
      plugins = {
        #chatInputButtonAPI.enable = true;
        #commandsAPI.enable = true;
        #messageAccessoriesAPI.enable = true;
        #messageEventsAPI.enable = true;
        #messagePopoverAPI.enable = true;
        #messageUpdaterAPI.enable = true;
        #serverListAPI.enable = true;
        #userSettingsAPI.enable = true;
        accountPanelServerProfile.enable = true;
        alwaysAnimate.enable = true;
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
        betterNotesBox = {
          enable = true;
          hide = true;
          noSpellCheck = true;
        };
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
        biggerStreamPreview.enable = true;
        callTimer = {
          enable = true;
          format = "stopwatch";
        };
        #clearURLs.enable = true;
        copyEmojiMarkdown.enable = true;
        copyFileContents.enable = true;
        copyStickerLinks.enable = true;
        #copyUserURLs.enable = true;
        crashHandler.enable = true;
        disableCallIdle.enable = true;
        expressionCloner.enable = true;
        favoriteEmojiFirst.enable = true;
        favoriteGifSearch.enable = true;
        fixCodeblockGap.enable = true;
        fixImagesQuality.enable = true;
        fixSpotifyEmbeds = {
          enable = true;
          #volume = 10;
        };
        fixYoutubeEmbeds.enable = true;
        forceOwnerCrown.enable = true;
        friendInvites.enable = true;
        friendsSince.enable = true;
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
            #spotify = true;
            #steam = true;
            #epic = true;
            #tidal = true;
            #itunes = true;
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
        shikiCodeblocks = {
            enable = true;
            theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/2d87559c7601a928b9f7e0f0dda243d2fb6d4499/packages/tm-themes/themes/ayu-dark.json";
            tryHljs = "SECONDARY";
            useDevIcon = "GREYSCALE";
            bgOpacity = 99.81949458483754;
        };
        # spotifyControls = {
        #     enable = true;
        #     #hoverControls = true;
        #     #useSpotifyUris = false;
        #     #previousButtonRestartsTrack = true;
        # };
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
        #badgeAPI.enable = true;
        # noTrack = {
        #     enable = true;
        #     disableAnalytics = true;
        # };
        # settings = {
        #     enable = true;
        #     settingsLocation = "aboveNitro";
        # };
        disableDeepLinks.enable = true;
        #supportHelper.enable = true;
        webContextMenus.enable = true;
      };
    };
  };

  # Neovim
  programs.nvf = {
    enable = true;
    settings = {
      vim.viAlias = false;
      vim.vimAlias = false;

      vim.lsp = {
        enable = true;
        lspSignature.enable = false;
      };
      vim.languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        clang.enable = true;
        csharp.enable = true;
        qml.enable = true;
        svelte.enable = true;
      };

      vim.filetree = {
        neo-tree = {
          enable = true;
        };
      };
      vim.autocomplete = {
        nvim-cmp.enable = false;
        blink-cmp.enable = true;
      };

      vim.visuals = {
        nvim-scrollbar.enable = true;
      };

      vim.minimap = {
        codewindow.enable = true;
      };

      vim.dashboard = {
        alpha.enable = true;
      };

      vim.projects = {
        project-nvim.enable = true;
      };

      vim.utility = {
        icon-picker.enable = true;
        surround.enable = true;
        multicursors.enable = true;
        smart-splits.enable = true;
        undotree.enable = true;
      };

      vim.ui = {
        breadcrumbs = {
          enable = true;
          navbuddy.enable = true;
        };

      };

      vim.lazy = {
        enable = true;
        plugins = {};
      };
      vim.extraPlugins = {};
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

  # Lutris
  programs.lutris = {
    enable = true;
  };

  # Monado Hand Tracking
  home.file.".local/share/monado/hand-tracking-models".source = pkgs.fetchgit {
    url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models";
    sha256 = "x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
    fetchLFS = true;
  };

  # OpenXR Discovery
  # xdg.configFile."openxr/1/active_runtime.json".source =
  #   "${pkgs.monado}/share/openxr/1/openxr_monado.json";
  # xdg.configFile."openvr/openvrpaths.vrpath".text = builtins.toJSON {
  #   config = [ "${config.xdg.dataHome}/Steam/config" ];
  #   external_drivers = null;
  #   jsonid = "vrpathreg";
  #   log = [ "${config.xdg.dataHome}/Steam/logs" ];
  #   runtime = [ "${pkgs.opencomposite}/lib/opencomposite" ];
  #   version = 1;
  # };

  # Obsidian
  programs.obsidian = {
    enable = true;
  };
}
