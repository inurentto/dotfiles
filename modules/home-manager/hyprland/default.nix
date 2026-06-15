{ config, pkgs, inputs, lib, ... }: {
  options.compositors.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Monitor config";
    };
    autostart = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Apps that will start with hyprland (exec-once)";
    };
  };

  config = lib.mkIf config.compositors.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      systemd.variables = [ "--all" ];

      configType = "hyprlang";

      settings = {
        "$terminal" = "alacritty";
        "$fileManager" = "thunar";
        "$browser" = "firefox";
        "$launcher" = "qs ipc call launcher open";
        "$screenshot" = "grimblast --notify --expire-time 8000 --freeze copysave area";
        "$colorPick" = "hyprpicker --autocopy";
        "$reloadShell" = "pkill quickshell; hyprctl dispatch exec qs";

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, T, exec, $terminal"
          "$mainMod, Q, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, F, fullscreen,"
          "$mainMod, TAB, exec, $launcher"
          "$mainMod, B, exec, $browser"

          # Screenshot & color pick
          ", PRINT, exec, $screenshot"
          "$mainMod, PRINT, exec, $colorPick"

          # Reload Shell
          "$mainMod, HOME, exec, $reloadShell"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          "$mainMod, J, layoutmsg, togglesplit"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"
        ];

        exec-once = config.compositors.hyprland.autostart;

        monitor = config.compositors.hyprland.monitors;

        env = [
          "XCURSOR_SIZE, 24"
          "XCURSOR_THEME, 'Posy_Cursor_Black'"
          "HYPRCURSOR_SIZE, 24"
          "HYPRCURSOR_THEME, 'hyprcursor_Posys-Cursor-Scalable-Mono-Black'"
        ];

        input = {
          kb_layout = "se";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = true;

          sensitivity = -0.7;
        };

        general = {
          gaps_in = 8;
          gaps_out = 16;

          border_size = 1;

          resize_on_border = false;

          allow_tearing = true;

          layout = "dwindle";
        };

        decoration = {
          rounding = 16;
          rounding_power = 2;

          active_opacity = 1;
          inactive_opacity = 1;

          shadow = {
            enabled = false;
            range = 12;
            render_power = 3;
          };

          blur = {
            enabled = true;
            new_optimizations = true;
            size = 8;
            passes = 2;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        dwindle = {
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = false;
          disable_hyprland_logo = true;
        };

        windowrule = [
          # Ignore maximize requests from apps. You'll probably like this.
          "suppress_event maximize, match:class .*"

          # Fix some dragging issues with XWayland
          "no_focus on,match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false"

          # Quickshell
          "float on, match:class ^(quickshell)$"
          "no_blur on, match:class ^(quickshell)$"

          # Rofi fixes
          "center on, match:initial_class Rofi"
          "stay_focused on, match:initial_class Rofi"
          "opaque on, match:initial_class Rofi"
          "no_blur on, match:initial_class Rofi"

          # Thunar fixes
          "float on, match:initial_class Thunar, match:title ^(?!.*Thunar$).*"

          # Godot fixes
          "tile on, match:initial_class Godot, match:initial_title Godot"
          "float on, match:initial_class Godot, match:title ()"
          "stay_focused on, match:initial_class Godot, match:title ()"
          "rounding 0, match:initial_class Godot, match:title ()"
          "border_size 0, match:initial_class Godot, match:title ()"
          "no_anim on, match:initial_class Godot, match:title ()"
          "no_focus on, match:initial_class Godot, match:title ()"
          "decorate off, match:initial_title Godot, match:title ^(DEBUG)$"

          "stay_focused on, match:initial_class Godot, match:title Create New Node"
          "stay_focused on, match:initial_class Godot, match:title Create Folder"
          "stay_focused on, match:initial_class Godot, match:title Create Script"
          "stay_focused on, match:initial_class Godot, match:title Create New Resource"
          "stay_focused on, match:initial_class Godot, match:title Create New Scene"
          "stay_focused on, match:initial_class Godot, match:title ^(Change Type of)" # this doesn't work for some reason :)

          # JetBrains
          # Prevent tooltips from taking focus (always have a title of `win.<id>`)
          "no_initial_focus on, match:class ^(.*jetbrains.*)$,  match:title ^(win.*)$"
          # Make "Go to file" and other dialogs always focused when open
          "stay_focused on, match:class ^(.*jetbrains.*)$,  match:title ^$, match:float true"
          # fix tab dragging (always have a single space character as their title)
          "no_initial_focus on, match:class ^(.*jetbrains.*)$,  match:title ^\\s$"
          # Tile new tabs automatically
          "tile on, match:class ^(jetbrains-*), match:float false"

          # Unity
          # Move popups to cursor
          "move (cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5)), match:class ^(Unity)$,  match:title ^(Color)$"
          "move (cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5)), match:class ^(Unity)$,  match:title ^(HDR Color)$"
        ];

        layerrule = [
          "no_anim on, match:namespace quickshell"
        ];
      };
    };
  };
}
