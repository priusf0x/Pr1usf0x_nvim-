return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
  -- Setup global capabilities for all LSP servers
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  vim.lsp.config("*", { capabilities = cmp_nvim_lsp.default_capabilities() })

  -- Setup highlight for ghost text
  vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

  local cmp = require("cmp")
  local luasnip = require("luasnip")

  -- Load snippets
  require("luasnip.loaders.from_vscode").lazy_load()

  -- Auto select first item
  local auto_select = true

  cmp.setup({
    snippet = {
      expand = function(args)
      luasnip.lsp_expand(args.body)
      end,
    },
    completion = {
      completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
    },
    preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                                        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                                        ["<C-Space>"] = cmp.mapping.complete(),
                                        ["<CR>"] = cmp.mapping.confirm({
                                          select = auto_select,
                                          behavior = cmp.ConfirmBehavior.Insert
                                        }),
                                        ["<C-y>"] = cmp.mapping.confirm({
                                          select = true,
                                          behavior = cmp.ConfirmBehavior.Insert
                                        }),
                                        ["<S-CR>"] = cmp.mapping.confirm({
                                          select = true,
                                          behavior = cmp.ConfirmBehavior.Replace
                                        }),
                                        ["<C-CR>"] = function(fallback)
                                        cmp.abort()
                                        fallback()
                                        end,
                                        ["<Tab>"] = cmp.mapping(function(fallback)
                                        if cmp.visible() then
                                          cmp.select_next_item()
                                          elseif luasnip.expand_or_jumpable() then
                                            luasnip.expand_or_jump()
                                            else
                                              fallback()
                                              end
                                              end, { "i", "s" }),
                                              ["<S-Tab>"] = cmp.mapping(function(fallback)
                                              if cmp.visible() then
                                                cmp.select_prev_item()
                                                elseif luasnip.jumpable(-1) then
                                                  luasnip.jump(-1)
                                                  else
                                                    fallback()
                                                    end
                                                    end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    }, {
      { name = "buffer" },
    }),
    formatting = {
      format = function(entry, item)
        -- Иконки для разных типов
        local icons = {
          Text = " ",
          Method = " ",
          Function = " ",
          Constructor = " ",
          Field = " ",
          Variable = " ",
          Class = " ",
          Interface = " ",
          Module = " ",
          Property = " ",
          Unit = " ",
          Value = " ",
          Enum = " ",
          Keyword = " ",
          Snippet = " ",
          Color = " ",
          File = " ",
          Reference = " ",
          Folder = " ",
          EnumMember = " ",
          Constant = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        }

        item.kind = (icons[item.kind] or "") .. item.kind

        -- Добавляем источник
        item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name] or ""

        -- Ограничение ширины
        local widths = {
          abbr = 40,
          menu = 30,
        }

        for key, width in pairs(widths) do
          if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
            item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
            end
            end

            return item
            end,
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    window = {
      completion = {
        border = "rounded",
        winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder",
      },
      documentation = {
        border = "rounded",
        winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder",
      },
    },
    experimental = {
      ghost_text = {
        hl_group = "CmpGhostText",
      },
    },
  })

  -- Setup cmdline completion
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                      { name = "path" },
                    }, {
                      { name = "cmdline" },
                    }),
  })

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                      { name = "buffer" },
                    },
  })
  end,
}
