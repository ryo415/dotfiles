return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    cmd = "Neotree",
    keys = {
      { "<leader>e",  "<cmd>Neotree toggle filesystem left<cr>", desc = "Toggle Neo-tree" },
      { "<leader>E",  "<cmd>Neotree reveal filesystem left<cr>", desc = "Reveal current file" },
      { "<leader>be", "<cmd>Neotree toggle buffers left<cr>", desc = "Buffers tree" },
      { "<leader>ge", "<cmd>Neotree toggle git_status left<cr>", desc = "Git status tree" },
    },
    opts = {
      close_if_last_window = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
      },
      window = {
        position = "left",
        width = 32,
        mappings = {
          ["<space>"] = "none",
          ["l"] = "open",
          ["h"] = "close_node",
          ["o"] = "open",
          ["s"] = "open_split",
          ["v"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["Y"] = "copy_selector",
        },
      },
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,

        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".git",
            "node_modules",
            ".cache",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
        show_unloaded = true,
      },
      git_status = {
        window = {
          position = "float",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
    }
  }
}
