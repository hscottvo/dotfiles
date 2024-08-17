-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Appearance
config.color_scheme = "Everforest Dark Medium (Gogh)"
config.font_size = 18
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- https://wezfurlong.org/wezterm/config/lua/gui-events/gui-startup.html
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- https://ansidev.xyz/posts/2023-05-18-wezterm-cheatsheet
-- Keybinds

local act = wezterm.action
local handle = io.popen("which nvim")
local result = handle:read("*a")
handle:close()
local nvim = result:gsub("s+", "")

local home_dir = os.getenv("HOME")
local wezterm_config_path = home_dir .. "/.wezterm.lua"

config.keys = {
	{
		key = "T",
		mods = "CMD|SHIFT",
		action = act.ShowTabNavigator,
	},
	{
		key = "R",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

return config
