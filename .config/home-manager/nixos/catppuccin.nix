{ config, pkgs, ... }:

let
  catppuccin_flavor = "frappe";

in
{
  catppuccin = {
    bat = {
      enable = true;
      flavor = catppuccin_flavor;
    };
    btop = {
      enable = true;
      flavor = catppuccin_flavor;
    };
    dunst = {
      enable = true;
      flavor = catppuccin_flavor;
    };
    fzf = {
      enable = true;
      flavor = catppuccin_flavor;
    };
    gtk = {
      enable = true;
      flavor = catppuccin_flavor;
      icon.enable = true;
    };
    rofi = {
      enable = true;
      flavor = catppuccin_flavor;
    };
    tmux = {
      enable = true;
      flavor = catppuccin_flavor;
      extraConfig = ''
        set -g @catppuccin_flavor "frappe"
        set -g @catppuccin_window_status_style "rounded"
        set -ogq @catppuccin_window_text " #T"
        set -ogq @catppuccin_window_current_text " #T"
        set -g status-right "#{E:@catppuccin_status_application}"
        set -ag status-right "#{E:@catppuccin_status_session}"
        set -ag status-right "#{E:@catppuccin_status_uptime}"
        set -ag status-right "#{E:@catppuccin_date_time_icon}"
      '';
    };
  };
}
