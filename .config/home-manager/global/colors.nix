{ lib, config, ... }:

{
  options.custom.themes.everforest.colors = with lib; {
    # Palette1: Background (hard contrast)
    bg0 = mkOption { type = types.str; default = "#1E2326"; description = "Default background (hard)"; };
    bg1 = mkOption { type = types.str; default = "#272E33"; description = "Line numbers, signs"; };
    bg2 = mkOption { type = types.str; default = "#2E383C"; description = "Cursor line, folds"; };
    bg3 = mkOption { type = types.str; default = "#374145"; description = "Popups, floating windows"; };
    bg4 = mkOption { type = types.str; default = "#414B50"; description = "Separators, whitespace"; };
    bg5 = mkOption { type = types.str; default = "#495156"; description = "Unused"; };
    bg6 = mkOption { type = types.str; default = "#4F5B58"; description = "Unused"; };

    bg_visual = mkOption { type = types.str; default = "#4C3743"; description = "Visual selection"; };
    bg_red = mkOption { type = types.str; default = "#493B40"; description = "Diff deleted background"; };
    bg_green = mkOption { type = types.str; default = "#3C4841"; description = "Diff added background"; };
    bg_blue = mkOption { type = types.str; default = "#384B55"; description = "Diff changed background"; };
    bg_yellow = mkOption { type = types.str; default = "#45443C"; description = "Warning background"; };

    # Palette2: Foreground
    fg = mkOption { type = types.str; default = "#D3C6AA"; description = "Default foreground"; };
    red = mkOption { type = types.str; default = "#E67E80"; description = "Keywords, errors"; };
    orange = mkOption { type = types.str; default = "#E69875"; description = "Operators, titles"; };
    yellow = mkOption { type = types.str; default = "#DBBC7F"; description = "Types, warnings"; };
    green = mkOption { type = types.str; default = "#A7C080"; description = "Functions, strings"; };
    aqua = mkOption { type = types.str; default = "#83C092"; description = "Constants, macros"; };
    blue = mkOption { type = types.str; default = "#7FBBB3"; description = "Identifiers, info"; };
    purple = mkOption { type = types.str; default = "#D699B6"; description = "Numbers, booleans"; };

    grey0 = mkOption { type = types.str; default = "#7A8478"; description = "Line numbers, UI elements"; };
    grey1 = mkOption { type = types.str; default = "#859289"; description = "Comments, punctuation"; };
    grey2 = mkOption { type = types.str; default = "#9DA9A0"; description = "Cursor line number"; };

    # Statusline (uses existing accent colors)
    statusline1 = mkOption { type = types.str; default = "#A7C080"; description = "Statusline bg 1"; };
    statusline2 = mkOption { type = types.str; default = "#D3C6AA"; description = "Statusline fg"; };
    statusline3 = mkOption { type = types.str; default = "#E67E80"; description = "Statusline accent"; };
  };
}

