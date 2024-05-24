-- enable experimental loader
pcall(function() vim.loader.enable() end)

-- plugin manager
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd("echo 'Installing `mini.nvim`' | redraw")
  local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd("echo 'Installed `mini.nvim`' | redraw")
end

require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- options
now(function()
  local opt = vim.opt

  opt.autowrite = true -- enable auto write

  if not vim.env.SSH_TTY then
    opt.clipboard = "unnamedplus" -- Sync with system clipboard
  end

  opt.completeopt = "menu,menuone,noselect"
  opt.conceallevel = 0           -- show * markup for bold and italic
  opt.confirm = true             -- confirm to save changes before exiting modified buffer
  opt.cursorline = false         -- disables highlighting of the current line
  opt.expandtab = true           -- use spaces instead of tabs
  opt.formatoptions = "jcroqlnt" -- tcqj
  opt.fillchars = { eob = " " }  -- disables tilde on end of buffer
  opt.grepformat = "%f:%l:%c:%m"
  opt.grepprg = "rg --vimgrep"
  opt.guicursor = ""
  opt.ignorecase = true      -- ignore case
  opt.inccommand = "nosplit" -- preview incremental substitute
  opt.laststatus = 3
  opt.list = true            -- show some invisible characters (tabs etc.)
  opt.listchars:append("eol:↴")
  opt.mouse = "a"            -- enable mouse mode
  opt.number = true          -- print line number
  opt.pumblend = 10          -- popup blend
  opt.pumheight = 10         -- maximum number of entries in a popup
  opt.relativenumber = true  -- relative line numbers
  opt.scrolloff = 4          -- lines of context
  opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
  opt.shiftround = true      -- round indent
  opt.shiftwidth = 2         -- size of an indent
  opt.shortmess:append({ W = true, I = true, c = true })
  opt.showmode = false       -- dont show mode since we have a statusline
  opt.sidescrolloff = 8      -- columns of context
  opt.signcolumn = "yes"     -- always show the signcolumn, otherwise it would shift the text each time
  opt.smartcase = true       -- don"t ignore case with capitals
  opt.smartindent = true     -- insert indents automatically
  opt.spelllang = { "en" }
  opt.splitbelow = true      -- put new windows below current
  opt.splitright = true      -- put new windows right of current
  opt.tabstop = 2            -- number of spaces tabs count for
  opt.termguicolors = true   -- true color support
  opt.timeoutlen = 300
  opt.undofile = true
  opt.undolevels = 10000
  opt.updatetime = 200               -- save swap file and trigger CursorHold
  opt.virtualedit = "block"          -- allow cursor to move anywhere
  opt.wildmode = "longest:full,full" -- command-line completion mode
  opt.winminwidth = 5                -- minimum window width
  opt.wrap = false                   -- disable line wrap

  -- disable some default providers
  for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
  end

  vim.g.maplocalleader = " "
  vim.g.mapleader = " "

  vim.g.markdown_recommended_style = 0
end)

-- colorscheme
now(function()
  add({ source = "catppuccin/nvim", name = "catppuccin" })
  require("catppuccin").setup({
    background = {
      dark = "mocha",
    },
    transparent_background = true,
    color_overrides = {
      mocha = {
        rosewater = "#ea6962",
        flamingo = "#ea6962",
        pink = "#d3869b",
        mauve = "#d3869b",
        red = "#ea6962",
        maroon = "#ea6962",
        peach = "#e78a4e",
        yellow = "#d8a657",
        green = "#a9b665",
        teal = "#89b482",
        sky = "#89b482",
        sapphire = "#89b482",
        blue = "#7daea3",
        lavender = "#7daea3",
        text = "#ebdbb2",
        subtext1 = "#d5c4a1",
        subtext0 = "#bdae93",
        overlay2 = "#a89984",
        overlay1 = "#928374",
        overlay0 = "#595959",
        surface2 = "#4d4d4d",
        surface1 = "#404040",
        surface0 = "#292929",
        base = "#1d2021",
        mantle = "#191b1c",
        crust = "#141617",
      },
    },
    custom_highlights = function(colors)
      return {
        MiniStatuslineModeNormal = { bg = colors.blue, fg = colors.base },
        MiniStatuslineModeInsert = { bg = colors.green, fg = colors.base },
        MiniStatuslineModeCommand = { bg = colors.pink, fg = colors.base },
        MiniStatuslineModeVisual = { bg = colors.red, fg = colors.base },
        MiniStatuslineModeOther = { bg = colors.teal, fg = colors.base },
      }
    end,
  })
  vim.cmd("colorscheme catppuccin")
end)

-- mappings
local map = function(defaults)
  local config = vim.tbl_deep_extend("force", { mode = {}, prefix = "", opts = {} }, defaults)
  return function(lhs, rhs, desc, opts)
    lhs = config.prefix .. lhs
    opts = opts or {}
    -- stylua: ignore
    if type(desc) == "table" then opts = desc else opts.desc = desc end
    opts = vim.tbl_deep_extend("force", config.opts, opts)
    vim.keymap.set(config.mode, lhs, rhs, opts)
  end
end

local nmap = map({ mode = "n" })
local imap = map({ mode = "i" })
local lmap = map({ mode = "n", prefix = "<leader>" })

-- basics
now(function()
  require("mini.basics").setup({
    options = {
      basic = false,
    },
    mappings = {
      basic = true,
      windows = true,
      option_toggle_prefix = "<leader>t",
      move_with_alt = true,
    },
  })

  require("mini.misc").setup_auto_root({ ".git", "Makefile", ".root" })
  require("mini.misc").setup_restore_cursor()

  nmap(";", ":", "Command")
  nmap("<C-c>", "<esc><cmd>q<cr>", "Quit")
  imap("<C-c>", "<esc><cmd>q<cr>", "Quit")

  lmap("qq", "<cmd>qa<cr>", "Quit all")
end)

-- icons
now(function()
  add("nvim-tree/nvim-web-devicons")
  require("nvim-web-devicons").setup()
end)

-- notifications
now(function()
  require("mini.notify").setup({
    window = { winblend = 0, config = { border = "rounded" } },
    lsp_progress = { enable = false },
  })
  vim.notify = require("mini.notify").make_notify()
end)

-- statusline
now(function()
  require("mini.statusline").setup({
    set_vim_settings = false,
  })
end)

-- dashboard
now(function()
  local starter = require("mini.starter")
  starter.setup({
    evaluate_single = true,
    items = {
      starter.sections.recent_files(5, false, false),
      { name = "Find file",       action = "Telescope find_files",              section = "Actions" },
      { name = "Browse files",    action = "Telescope file_browser",            section = "Actions" },
      { name = "Session restore", action = "lua require('persistence').load()", section = "Actions" },
      { name = "Update plugins",  action = "DepsUpdate",                        section = "Actions" },
      { name = "Quit",            action = "q",                                 section = "Actions" },
    },
    footer = function() return "" end,
    content_hooks = {
      starter.gen_hook.aligning("center", "center"),
      starter.gen_hook.indexing("all", { "Actions" }),
    },
  })

  local toggle = function()
    if vim.bo.filetype == "starter" then
      starter.close()
    else
      starter.open()
    end
  end

  lmap(";", toggle, "Open Dashboard")
end)

-- treesitter
now(function()
  add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "master",
    monitor = "main",
    hooks = {
      post_checkout = function() vim.cmd("TSUpdate") end,
    },
  })
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "vimdoc" },
    highlight = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = "<nop>",
        node_decremental = "<bs>",
      },
    },
  })
end)

-- lspconfig
now(function()
  add({
    source = "neovim/nvim-lspconfig",
    depends = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
  })
  local lspconfig = require("lspconfig")
  require("lspconfig.ui.windows").default_options.border = "rounded"
  require("mason").setup({ ui = { border = "rounded" } })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  local icons = { Error = " ", Warn = " ", Hint = "󰌶", Info = " " }
  for name, icon in pairs(icons) do
    vim.fn.sign_define("DiagnosticSign" .. name, { text = icon, texthl = "DiagnosticSign" .. name })
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local on_attach = function(_, bufnr)
    vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

    local opts = { buffer = bufnr, noremap = true }

    local bmap = function(m, lhs, rhs, desc)
      opts.desc = desc
      vim.keymap.set(m, lhs, rhs, opts)
    end

    bmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Show lsp hover")
    bmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition")
    bmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto declaration")
    bmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto implementation")
    bmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Goto type definition")
    bmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "List references")
    bmap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Open signature help")
    bmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol")
    bmap(
      { "n", "x" },
      "<F3>",
      "<cmd>lua require('conform').format({async = true, lsp_fallback = true})<cr>",
      "Format buffer (async)"
    )
    bmap({ "n", "v" }, "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action")
    bmap("x", "<F4>", "<cmd>lua vim.lsp.buf.range_code_action()<cr>", "Code action")

    bmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", "Open diagnostic float")
  end

  local configs = {
    ["lua_ls"] = {
      settings = {
        Lua = {
          completion = { keywordSnippet = "Both", callSnippet = "Disable" },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          diagnostics = {
            disable = { "lowercase-global", "undefined-global" },
          },
        },
      },
    },
  }

  local default_handler = function(server)
    local config = configs[server] or {}
    config.on_attach = on_attach
    config.capabilities = capabilities
    lspconfig[server].setup(config)
  end

  require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(configs),
    handlers = { default_handler },
  })
end)

-- code formatter
later(function()
  add("stevearc/conform.nvim")
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      go = { "gofumpt", "goimports" },
      javascript = { { "prettierd", "prettier" } },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end)

-- gitsigns
later(function()
  add("lewis6991/gitsigns.nvim")
  require("gitsigns").setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
  })
end)

-- completions
later(function()
  require("mini.pairs").setup({
    mappings = {
      -- prevents the action if the cursor is just before any character or next to a "\".
      ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][%s%)%]%}]" },
      ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][%s%)%]%}]" },
      ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][%s%)%]%}]" },
      -- this is default (prevents the action if the cursor is just next to a "\").
      [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
      ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
      ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
      -- prevents the action if the cursor is just before or next to any character.
      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w][^%w]", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w][^%w]", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w][^%w]", register = { cr = false } },
    },
  })

  require("mini.completion").setup({
    window = {
      info = { border = "rounded" },
      signature = { border = "rounded" },
    },
    lsp_completion = {
      source_func = "omnifunc",
      auto_setup = false,
    },
  })

  imap("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
  imap("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

  local function on_cr()
    if vim.fn.pumvisible() ~= 0 then
      local item_selected = vim.fn.complete_info()["selected"] ~= -1
      return item_selected and "<C-y>" or "<C-y><CR>"
    else
      return require("mini.pairs").cr()
    end
  end

  imap("<cr>", on_cr, { expr = true })
end)

-- telescope
later(function()
  add({
    source = "nvim-telescope/telescope.nvim",
    depends = {
      { source = "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-lua/plenary.nvim",
    },
  })
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "	",
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      preview = {
        treesitter = false,
        timeout = 250,
        filesize_hook = function(filepath, bufnr, opts)
          local path = require("plenary.path"):new(filepath)
          local height = vim.api.nvim_win_get_height(opts.winid)
          local lines = vim.split(path:head(height), "[\r]?\n")
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        end,
      },
      mappings = {
        n = { ["q"] = require("telescope.actions").close },
        i = {
          ["<C-c>"] = require("telescope.actions").close,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
          ["<C-j>"] = require("telescope.actions").move_selection_next,
        },
      },
      extensions_list = { "file_browser", "fzf" },
      extensions = {
        file_browser = {
          grouped = true,
        },
      },
    },
  })

  local telescoped = function(builtin, opts)
    local params = { builtin = builtin, opts = opts }
    return function()
      builtin = params.builtin
      opts = params.opts
      local cwd = vim.fn.getcwd()
      local results_title = "Results (" .. string.match(cwd, "/([^/]+)/?$") .. ")"
      opts = vim.tbl_deep_extend("force", { results_title = results_title }, opts or {})
      if builtin == "find_files" then
        if vim.loop.fs_stat(cwd .. "/.git") then
          opts.show_untracked = true
          builtin = "git_files"
        else
          builtin = "find_files"
        end
      end
      require("telescope.builtin")[builtin](opts)
    end
  end

  nmap(",", "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current buffer fuzzy find")

  lmap("ft", "<cmd>Telescope<cr>", "Telescope")
  lmap("ff", telescoped("find_files"), "Find files")
  lmap("fr", telescoped("oldfiles"), "Find recent files")
  lmap("fw", telescoped("grep_string"), "Find word")
  lmap("fb", "<cmd>Telescope file_browser hidden=true<cr>", "File browser")
  lmap("fh", "<cmd>Telescope help_tags<cr>", "Find helptags")
  lmap("fc", "<cmd>Telescope resume<cr>", "Continue")
  lmap("/", telescoped("live_grep"), "Live grep")

  lmap("x", function() vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua") end, "Neovim config")
end)

-- misc plugins
later(function()
  require("mini.cursorword").setup({}) -- highlight word on cursor
  require("mini.bracketed").setup({})  -- enhance square brackets
  require("mini.splitjoin").setup({})  -- split and join arguments
  require("mini.surround").setup({})   -- surround actions
  require("mini.comment").setup({})    -- comment lines/selections
  require("mini.move").setup({})       -- move lines/selections with alt
  require("mini.jump").setup({ mappings = { repeat_jump = "" } })

  add("lukas-reineke/indent-blankline.nvim") -- indent lines
  add("dstein64/vim-startuptime")            -- measure startuptime
  add("romainl/vim-cool")                    -- better search highlights

  require("ibl").setup({
    indent = { tab_char = "│", char = "│", highlight = { "NonText" } },
    exclude = { filetypes = { "help", "starter" } },
    scope = { enabled = false },
  })

  local hipatterns = require("mini.hipatterns") -- custom highlights
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  require("mini.bufremove").setup({}) -- easy close buffers
  lmap("qw", function() MiniBufremove.delete() end, "Delete buffer")
  lmap("qW", function() MiniBufremove.delete(0, true) end, "Delete buffer (force)")

  add("folke/persistence.nvim") -- session management
  local persistence = require("persistence")
  persistence.setup({})
  lmap("qs", function() persistence.load() end, "Restore session (cwd)")
  lmap("qS", function() persistence.load({ last = true }) end, "Restore last session")
end)

-- harpoon
later(function()
  add("ingur/captain.nvim")
  local captain = require("captain")
  captain.setup({})

  lmap("j", function() captain.hook('j') end, "which_key_ignore")
  lmap("k", function() captain.hook('k') end, "which_key_ignore")
  lmap("l", function() captain.hook('l') end, "which_key_ignore")

  lmap("hh", function() captain.info() end, "Show Hooks")
  lmap("hd", function() captain.unhook() end, "Unhook File")
  lmap("hD", function() captain.unhook({ all = true }) end, "Unhook All Files (cwd)")
end)

-- terminals
later(function()
  add("akinsho/toggleterm.nvim")

  require("toggleterm").setup({
    shade_terminals = false,
    open_mapping = nil,
    persist_mode = false,
    float_opts = { border = "rounded" },
    size = function(term)
      if term.direction == "horizontal" then
        return 8
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.25
      end
    end,
  })

  local direction = "horizontal"
  local toggle_term = function() vim.cmd(string.format('execute v:count . "ToggleTerm direction=%s"', direction)) end
  local toggle_direction = function()
    local visible = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if string.find(vim.fn.bufname(buf), "^term://") then visible = true end
    end
    if visible then toggle_term() end
    direction = direction == "vertical" and "horizontal" or "vertical"
    if visible then toggle_term() end
  end

  local bmap = function(t, lhs, rhs)
    vim.keymap.set("t", lhs, rhs, { noremap = true, silent = true, buffer = t.bufnr })
  end
  local term = require("toggleterm.terminal").Terminal
  local lazygits = {}
  local idx = 1337

  local toggle_lazygit = function()
    local cwd = vim.fn.getcwd()
    if not lazygits[cwd] then
      lazygits[cwd] = term:new({
        cmd = "lazygit",
        count = idx,
        hidden = true,
        direction = "float",
        on_open = function(t)
          bmap(t, "<esc>", "<esc>")
          bmap(t, "<C-g>", function() _G._toggle_lazygit() end)
          bmap(t, "<C-t>", function() toggle_term() end)
        end,
      })
      idx = idx + 1
    end
    lazygits[cwd]:toggle()
  end
  _G._toggle_lazygit = toggle_lazygit

  local nimap = map({ mode = { "n", "i" } })
  nimap("<C-t>", function() toggle_term() end, "Toggle terminal")
  nimap("<C-g>", function() toggle_lazygit() end, "Toggle lazygit")
  lmap("tt", function() toggle_direction() end, "Toggle terminal direction")

  local tmap = map({ mode = "t" })
  tmap("<C-t>", function() toggle_term() end, "Toggle terminal")
  tmap("<esc>", "<C-\\><C-n>", "Normal mode")
  tmap("<C-j>", "<C-\\><C-n><C-w>j", "Move to left window")
  tmap("<C-k>", "<C-\\><C-n><C-w>k", "Move to bottom window")
  tmap("<C-h>", "<C-\\><C-n><C-w>h", "Move to top window")
  tmap("<C-l>", "<C-\\><C-n><C-w>l", "Move to right window")
  tmap("<C-Up>", "<C-\\><C-n><cmd>resize -2<cr>", "Resize window up")
  tmap("<C-Down>", "<C-\\><C-n><cmd>resize +2<cr>", "Resize window down")
  tmap("<C-Left>", "<C-\\><C-n><cmd>vertical resize -2<cr>", "Resize window left")
  tmap("<C-Right>", "<C-\\><C-n><cmd>vertical resize +2<cr>", "Resize window right")
end)

-- key clues
later(function()
  add("folke/which-key.nvim")
  local wk = require("which-key")
  wk.setup({
    window = {
      border = "rounded",
    },
  })
  wk.register({
    mode = { "n", "v" },
    ["g"] = { name = "+goto" },
    ["]"] = { name = "+next" },
    ["["] = { name = "+prev" },
    ["<leader>f"] = { name = "+file/find" },
    ["<leader>h"] = { name = "+hooks" },
    ["<leader>q"] = { name = "+quit/sessions" },
    ["<leader>t"] = { name = "+toggle" },
  })
end)

-- autocmds
later(function() --
  local function augroup(name) return vim.api.nvim_create_augroup("custom_" .. name, { clear = true }) end

  -- Check if we need to reload the file when it changed
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    command = "checktime",
  })

  -- resize splits if window got resized
  vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function() vim.cmd("tabdo wincmd =") end,
  })

  -- close some filetypes with <q>
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
      "help",
      "lspinfo",
      "man",
      "notify",
      "qf",
      "query",
      "startuptime",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
  })
end)
