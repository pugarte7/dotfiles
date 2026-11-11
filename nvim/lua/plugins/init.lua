-- File: lua/plugins/init.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "python", "yaml", "bash", "java", "go", "html" },
      highlight = { enable = true },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  {
    "nemanjamalesija/smart-paste.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "pugarte7/clip-paste.nvim",
    lazy = false,
  },

  {
    "ChmaraX/herdr-nvim",
    lazy = false,
    opts = {},
  },

  {
    import = "plugins.mason",
  },

  {
    import = "plugins.none-ls",
  },

  {
    import = "plugins.lint",
  },
}
