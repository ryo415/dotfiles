return {
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "rafamadriz/friendly-snippets", -- 任意（スニペット用）
    },
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true },
	  },
	},
  },
}
