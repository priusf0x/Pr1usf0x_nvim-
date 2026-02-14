return {
  "neovim/nvim-lspconfig",
  config = function()
  -- Настройка сервера clangd
  vim.lsp.config.clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    root_markers = {
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac",
      "Makefile",
      "configure.in",
      "config.h.in",
      "meson.build",
      "meson_options.txt",
      "build.ninja",
      ".git",
    },
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  }

  -- Включаем сервер
  vim.lsp.enable("clangd")

  -- Клавиши для clangd
  vim.keymap.set("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header (C/C++)" })

  -- Базовые LSP маппинги
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                              callback = function(ev)
                              local opts = { buffer = ev.buf }
                              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                              vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                              end,
  })
  end,
}
