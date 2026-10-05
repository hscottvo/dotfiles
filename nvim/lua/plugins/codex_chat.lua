return {
	{
		dir = vim.fn.expand("~/Repos/codex-chat.nvim"),
		name = "codex-chat.nvim",
		main = "chatproto",
		lazy = true,
		dependencies = { "nvim-telescope/telescope.nvim" },
		cmd = {
			"CodexChat",
			"CodexChatNew",
			"CodexChats",
			"CodexChatReconnect",
			"CodexChatRename",
			"CodexChatNotes",
			"CodexChatInfo",
			"CodexChatSkills",
			"CodexChatDiagram",
		},
		keys = {
			{ "<leader>at", "<cmd>CodexChat<cr>", desc = "Open Codex chat" },
			{ "<leader>an", "<cmd>CodexChatNew<cr>", desc = "New Codex chat" },
			{ "<leader>ah", "<cmd>CodexChats<cr>", desc = "Find Codex conversations" },
			{ "<leader>aR", "<cmd>CodexChatRename<cr>", desc = "Rename Codex chat" },
			{ "<leader>aN", "<cmd>CodexChatNotes<cr>", desc = "Pending Codex notes" },
			{ "<leader>ak", "<cmd>CodexChatSkills<cr>", desc = "Choose Codex skill" },
		},
		opts = {},
	},
}
