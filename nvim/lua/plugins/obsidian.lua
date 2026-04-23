return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Open note" },
			{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
			{ "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's daily note" },
			{ "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's daily note" },
			{ "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
			{ "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
			{ "<leader>ol", "<cmd>Obsidian follow_link<cr>", desc = "Follow link" },
			{ "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Rename note" },
			{ "<leader>oi", "<cmd>Obsidian template<cr>", desc = "Insert template" },
			{ "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox" },
			{ "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image" },
			{ "<leader>ok", "<cmd>Obsidian tags<cr>", desc = "Tags" },
			{ "<leader>ou", "ds]ds]", desc = "Unlink wikilink", remap = true },
		},
		opts = {
			workspaces = {
				{
					name = "mo",
					path = "~/Documents/obsidian-vault",
				},
			},
			daily_notes = {
				folder = nil,
				date_format = "%Y-%m-%d",
				template = "daily",
			},
			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
			completion = {
				blink = true,
				min_chars = 1,
			},
			ui = { enable = false },
			legacy_commands = false,
			note_id_func = function(title)
				if title then
					return title
				end
				return tostring(os.time())
			end,
		},
	},
}
