{ pkgs, config, lib, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
  font = config.stylix.fonts.monospace.name;
  waybarFont = lib.replaceStrings [ " Mono" "Mono" ] [ "" "" ] font;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "bottom";
        position = "top";
        height = 34;
        margin = "2 2 2 2"; # Top Right Bottom Left
        exclusive = true;
        passthrough = false;

        modules-left = [
          "hyprland/workspaces"
          "wlr/taskbar"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "group/sysinfo"
          "pulseaudio"
          "network"
          "custom/network-speed"
          "tray"
        ];

        # --- MODULES ---
        "hyprland/workspaces" = {
          "all-outputs" = true;
          format = "{name}";
          "format-icons" = {
            "10" = "10";
          };
        };

        "wlr/taskbar" = {
          format = "{icon}";
          "icon-size" = 16;
          "tooltip-format" = "{title}";
          "ignore-list" = [ "rofi" "wofi" "fuzzel" "waybar" "foot" "footclient" ];
        };

        clock = {
          format = "󰥔 {:%I:%M %p}";
          interval = 60;
          "format-alt" = "󰃭 {:%a, %d %b}";
          "tooltip-format" = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            "mode-mon-col" = 3;
            format = {
              months = "<span color='${c.base09}'><b>{}</b></span>";   # Orange
              weekdays = "<span color='${c.base0A}'><b>{}</b></span>"; # Yellow
              today = "<span color='${c.base0E}'><b>{}</b></span>";    # Purple
            };
          };
        };

        # Group: System Info
        "group/sysinfo" = {
          orientation = "horizontal";
          modules = [ "cpu" "temperature" "memory" "battery" ];
        };

        cpu = {
          format = " {}%";
          interval = 5;
        };

        temperature = {
          format = " {}°C";
          interval = 5;
        };

        memory = {
          format = " {used:0.1f}G";
          interval = 10;
        };

        battery = {
          format = "{icon} {capacity}%";
          "format-plugged" = " {capacity}%";
          "format-full" = " Charged";
          interval = 30;
          "format-icons" = {
            charging = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
            default = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          "format-muted" = "󰝟 Mute";
          "format-bluetooth" = "󰂰 {volume}%";
          "scroll-step" = 5;
          "on-click" = "pavucontrol";
          "max-volume" = 100;
          "format-icons" = {
            muted = "󰝟";
            bluetooth = "󰂰";
            default = [ "" "" "󰕾" " " ];
          };
        };

        network = {
          format = "{ifname}";
          "format-wifi" = ''{icon} {essid}'';
          "format-ethernet" = "󰈀 {ifname}";
          "format-disconnected" = "󰤮 Offline";
          "format-alt" = " {bandwidthDownBytes}  {bandwidthUpBytes}";
          "max-length" = 20;
          interval = 10;
          "format-icons" = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        };

        "custom/network-speed" = {
          exec = ''${./scripts/network-speed-loop.sh}'';
          format = "{}";
        };

        tray = {
          "icon-size" = 16;
          spacing = 6;
        };
      };
    };

    # bg-darkest -> base00   | accent-primary (Cyan) -> base0C
    # bg-dark    -> base01   | accent-secondary (Blue) -> base0D
    # fg-primary -> base05   | accent-warning (Orange) -> base09
    # accent-error -> base08 | accent-success (Green) -> base0B

    style = ''
      * {
        font-family: "${waybarFont}", "JetBrainsMono NF", "GeistMono NF";
        font-size: 14px;
        font-weight: 600;
        min-height: 12px;
        border: none;
        border-radius: 10px;
      }

      window#waybar {
        background-color: ${c.base00};
        color: ${c.base05};
        transition: background-color 0.5s;
      }

      window#waybar.empty {
        background-color: ${c.base00};
      }

      tooltip {
        background-color: ${c.base00};
        color: ${c.base05};
        border: 1px solid ${c.base02};
        padding: 8px 12px;
      }

      /* module pill */
      #clock,
      #workspaces,
      #network,
      #pulseaudio,
      #tray,
      #custom-network-speed,
      #sysinfo,
      #taskbar {
        background: ${c.base01};
        padding: 0px 16px; /* Increased horizontal padding */
        margin: 4px;
        border-radius: 8px;
      }

      /* hover effects */
      #clock:hover,
      #sysinfo:hover,
      #network:hover,
      #pulseaudio:hover,
      #tray:hover,
      #custom-network-speed:hover,
      #taskbar button:hover {
        background-color: ${c.base02};
        transition: background-color 0.2s;
      }

      /* Workspaces */
      #workspaces button {
        color: ${c.base05};
        padding: 0px 2px;
        margin: 0px 1px;
        border-bottom: 2px solid ${c.base02};
        border-radius: 2px;
      }

      #workspaces button.active {
        color: ${c.base0C};
        background-color: ${c.base02};
        border-bottom: 2px solid ${c.base0C};
      }

      #workspaces button.urgent {
        color: ${c.base08};
        border-bottom: 2px solid ${c.base08};
      }

      #workspaces button:hover {
        background-color: ${c.base02};
        color: ${c.base0C};
      }

      /* Taskbar */
      #taskbar button {
        padding: 0px 4px;
        border-radius: 2px;
      }

      #taskbar button.active {
        color: ${c.base0C};
        background: ${c.base02};
        border-bottom: 2px solid ${c.base0D};
        margin-bottom: 0px;
      }

      /* sysinfo */
      #sysinfo {
        padding: 0 4px;
      }

      #cpu, #memory, #battery, #temperature {
        padding: 0px 6px;
        background: transparent;
        color: ${c.base04};
      }

      /* module specific css */
      #clock {
        color: ${c.base09};
      }
      #battery {
        color: ${c.base0B};
      }
      #cpu {
        color: ${c.base0D};
      }
      #temperature {
        color: ${c.base08};
      }
      #memory {
        color: ${c.base09};
      }
      #network {
        color: ${c.base0E};
      }
      #network.alt {
        color: ${c.base0F};
      }
      #pulseaudio {
        color: ${c.base0A};
      }
      #custom-network-speed {
        color: ${c.base0F};
        min-width: 150px;
      }
    '';
  };
}
