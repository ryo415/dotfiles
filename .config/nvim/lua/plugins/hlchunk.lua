return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        duration = 0,
        delay = 0,
      },
      indent = {
        enable = true,
        deley = 0,
        ahead_lines = 20,
      },
      blank = {
        enable = false,
      },
      line_num = {
        enable = false,
      },
    })
  end
}
