-- 1. Лидер-клавиша (Пробел)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Автозагрузка lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Подключение плагинов
require("lazy").setup({
  spec = {
    -- Тема Catppuccin с прозрачностью под Ghostty
    {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false,
      priority = 1000,
      config = function()
        require("catppuccin").setup({
          flavour = "mocha",
          transparent_background = true,
          integrations = {
            treesitter = true,
            cmp = true,
            dadbod_ui = true,
          },
        })
        vim.cmd.colorscheme("catppuccin-mocha")

        -- Повышенная яркость номеров строк
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#a6adc8" })
      end,
    },

    -- Статус-лайн Lualine
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        options = {
          theme = "auto",
        },
      },
    },

    -- Подсветка синтаксиса Treesitter (Nvim 0.12+)
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
    },

    -- Живой предпросмотр Markdown в браузере
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function()
        vim.fn["mkdp#util#install"]()
      end,
      keys = {
        { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
      },
    },

    -- Работа с базами данных (Dadbod UI + Completion)
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = {
        { "tpope/vim-dadbod", lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
      },
      cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
      },
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        vim.g.db_ui_winwidth = 35
        vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
        vim.g.db_ui_execute_on_save = 0
        vim.g.db_ui_disable_query_bind_parameters = 1
      end,
      keys = {
        { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Открыть / закрыть панель БД" },
        { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Найти буфер запроса БД" },
      },
    },

    -- Автодополнение кода (nvim-cmp)
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          snippet = {
            expand = function(args)
              vim.snippet.expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "buffer" },
          }),
        })

        cmp.setup.filetype({ "sql", "mysql", "plsql", "pgsql" }, {
          sources = cmp.config.sources({
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
          }),
        })
      end,
    },

    -- Нечеткий поиск (Fzf-Lua)
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        winopts = {
          preview = {
            default = "bat",
          },
        },
      },
      keys = {
        { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Найти файлы" },
        { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Поиск текста (grep)" },
        { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Список буферов" },
        { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Справка Neovim" },
        { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Недавние файлы" },
      },
    },

    -- Файловый менеджер (Oil)
    {
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["q"] = "actions.close",
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 30,
          border = "rounded",
        },
      },
      keys = {
        { "-", "<cmd>Oil<cr>", desc = "Открыть родительскую папку (Oil)" },
        { "<leader>e", "<cmd>Oil --float<cr>", desc = "Файловый менеджер (Oil)" },
      },
    },

    -- Всплывающее меню подсказок горячих клавиш (Which-Key)
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
    },

    -- Git-статусы в строках (Gitsigns)
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      },
      keys = {
        { "]c", "<cmd>Gitsigns next_hunk<cr>", desc = "Следующий diff hunk" },
        { "[c", "<cmd>Gitsigns prev_hunk<cr>", desc = "Предыдущий diff hunk" },
        { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Превью изменений hunk" },
        { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Git blame строки" },
      },
    },

    -- Манипуляции со скобками и кавычками (Surround)
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      opts = {},
    },

    -- Автоматическое закрытие скобок (Autopairs)
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {
        fast_wrap = {},
      },
      config = function(_, opts)
        local npairs = require("nvim-autopairs")
        npairs.setup(opts)
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },

    -- Настройка LSP и Mason
    {
      "williamboman/mason.nvim",
      cmd = "Mason",
      opts = {},
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        automatic_installation = true,
      },
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Перейти к определению" }))
            vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Документация" }))
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Перейти к реализации" }))
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Переименовать символ" }))
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
            vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Найти ссылки" }))
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Предыдущая ошибка" }))
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Следующая ошибка" }))
            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Показать ошибку в окне" }))
          end,
        })

        local lspconfig = require("lspconfig")
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls" },
          handlers = {
            function(server_name)
              lspconfig[server_name].setup({
                capabilities = capabilities,
              })
            end,
          },
        })
      end,
    },
  },
  rocks = {
    enabled = false,
  },
})

-- 4. Настройки интерфейса и навигации
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"

-- 5. Поддержка русской раскладки в режимах Normal и Visual
vim.opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- 6. Функция форматирования с сохранением позиции курсора
local function format_sql_buffer()
  local view = vim.fn.winsaveview()
  vim.cmd("silent! normal! gggqG")
  vim.fn.winrestview(view)
end

-- 7. Настройки буферов SQL (форматирование, выполнение и автодополнение)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql", "pgsql" },
  callback = function(event)
    -- Сброс встроенного formatexpr, чтобы gq использовал formatprg
    vim.bo[event.buf].formatexpr = ""
    -- pg_format: без лишней строки в конце (-L), ключевые слова (-u 2), функции (-f 2) и типы данных (-U 2) в верхнем регистре
    vim.bo[event.buf].formatprg = "pg_format -L -u 2 -f 2 -U 2 -"
    vim.bo[event.buf].omnifunc = "vim_dadbod_completion#omni"

    -- Шорткаты ручного форматирования (<leader>f)
    vim.keymap.set("n", "<leader>f", format_sql_buffer, { buffer = event.buf, desc = "Форматировать весь файл" })
    vim.keymap.set("x", "<leader>f", "gq", { buffer = event.buf, desc = "Форматировать выделенный фрагмент" })

    -- Выполнение SQL-запроса (<leader>r или Ctrl + Enter)
    for _, lhs in ipairs({ "<leader>r", "<C-CR>" }) do
      vim.keymap.set("n", lhs, "vip<Plug>(DBUI_ExecuteQuery)", {
        buffer = event.buf,
        remap = true,
        desc = "Выполнить текущий запрос",
      })
      vim.keymap.set("x", lhs, "<Plug>(DBUI_ExecuteQuery)", {
        buffer = event.buf,
        desc = "Выполнить выделенный запрос",
      })
    end
  end,
})

-- Автоформатирование перед сохранением (:w)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.sql", "*.pgsql" },
  callback = format_sql_buffer,
})

-- Автоматически подтягивать внешние изменения файлов на диске
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

-- Скопировать полный путь текущего файла в буфер обмена macOS
vim.keymap.set("n", "<leader>cp", function()
  local path = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg("+", path)
  vim.notify("Скопировано: " .. path)
end, { desc = "Копировать путь к файлу" })

-- Настройки табуляции и отступов
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Визуализация пробелов и табов (как в VS Code)
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",       -- Таб отображается стрелкой с отступом
  space = "·",      -- Каждый отдельный пробел отображается точкой
  trail = "•",      -- Пробелы в конце строк
  nbsp = "␣",
}

-- Приглушенный цвет для символов пробелов и табов (Catppuccin Surface 1)
vim.api.nvim_set_hl(0, "Whitespace", { fg = "#45475a" })
vim.api.nvim_set_hl(0, "NonText", { fg = "#45475a" })
