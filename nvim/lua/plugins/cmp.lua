vim.cmd [[set completeopt=menu,menuone,noselect]]

return {
   {
      'L3MON4D3/LuaSnip',
      lazy = true,
      config = function()
         require("luasnip.loaders.from_snipmate").load()
      end
   },
   {
      'hrsh7th/nvim-cmp',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-buffer',
         'saadparwaiz1/cmp_luasnip',
      },
      event = "InsertEnter",
      config = function()
         local cmp = require 'cmp'
         local luasnip = function() return require 'luasnip' end
         local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
         end

         cmp.setup {
            snippet = {
               expand = function(args)
                  luasnip().lsp_expand(args.body)
               end,
            },
            mapping = cmp.mapping.preset.insert {
               ['<C-d>'] = cmp.mapping.scroll_docs(-4),
               ['<C-f>'] = cmp.mapping.scroll_docs(4),
               ['<C-Space>'] = cmp.mapping.complete(),
               ['<C-e>'] = cmp.mapping.close(),
               ['<CR>'] = cmp.mapping.confirm { select = true },
               ['<Tab>'] = cmp.mapping(function(fallback)
                  if luasnip().expand_or_jumpable() then
                     luasnip().expand_or_jump()
                  elseif cmp.visible() then
                     local entry = cmp.get_selected_entry()
                     if not entry then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                     else
                        cmp.confirm { select = true }
                     end
                  elseif has_words_before() then
                     cmp.complete()
                  else
                     fallback()
                  end
               end, { 'i', 's' }),
               ['<S-Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_prev_item()
                  elseif luasnip().jumpable(-1) then
                     luasnip().jump(-1)
                  else
                     fallback()
                  end
               end, { 'i', 's' }),
            },
            sources = {
               { name = 'luasnip' },
               { name = 'nvim_lsp' },
            },
            completion = {
               get_trigger_characters = function(chars)
                  return chars
               end,
               keyword_length = 2,
            },
         }
      end,
   }
}
