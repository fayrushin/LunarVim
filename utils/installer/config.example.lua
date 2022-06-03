local status_vscode = pcall(require, "vscode")
if not status_vscode then
  vim.cmd [[
  colorscheme default
  ]]
else
  vim.g.vscode_style = "light"
  vim.g.vscode_italic_comment = 1
  lvim.colorscheme = "vscode"
end

lvim.builtin.which_key.mappings["i"] = {
  name = "Interface",
  d = { "<cmd>lua require('vscode').change_style('dark')<CR>", "Set dark theme" },
  l = { "<cmd>lua require('vscode').change_style('light')<CR>", "Set light theme" },
  t = { "<cmd>lua require'dapui'.toggle()<CR>", "Toggle debug UI" }
}

lvim.builtin.which_key.mappings["r"] = {
  "<cmd>NvimTreeFindFile<CR>", "File tree"
}

lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "document" },
  q = { "<cmd>Trouble quickfix<cr>", "quickfix" },
  l = { "<cmd>Trouble loclist<cr>", "loclist" },
  r = { "<cmd>Trouble lsp_references<cr>", "references" },
}

-- general
vim.opt.clipboard = ""
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.lsp.diagnostics.virtual_text = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.dap.active = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "json",
  "lua",
  "python",
  "rust",
  "yaml",
  "cpp",
  "cmake"
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- clangd lsp settings
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })
local clangd_flags = {
  "--all-scopes-completion",
  "--suggest-missing-includes",
  "--background-index",
  "--pch-storage=disk",
  "--cross-file-rename",
  "--log=info",
  "--completion-style=detailed",
  "--enable-config", -- clangd 11+ supports reading from .clangd configuration file
  "--clang-tidy",
}
local clangd_bin = "clangd"

local custom_on_attach = function(client, bufnr)
  require("lvim.lsp").common_on_attach(client, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lh", "<Cmd>ClangdSwitchSourceHeader<CR>", opts)
end

local opts = {
  cmd = { clangd_bin, unpack(clangd_flags) },
  -- filetypes = {"c", "cpp", "cuda", "objc", "objcpp"},
  on_attach = custom_on_attach,
}

require("lvim.lsp.manager").setup("clangd", opts)

-- nvim-dap vscode-cpp config
local status_ok, dap = pcall(require, "dap")
if status_ok then
  dap.adapters.cppdbg = {
    type = 'executable',
    command = '/home/ravil/.local/bin/cpptools-linux/extension/debugAdapters/bin/OpenDebugAD7',
    name = "cppdbg",
    id = "cppdbg"
  }

  -- dap.adapters.lldb = {
  --   type = 'executable',
  --   command = '/bin/lldb-vscode-13',
  --   name = "lldb"
  -- }
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
      setupCommands = {
        {
          description = "Enable pretty-printing",
          text = "-enable-pretty-printing",
        }
      }
    }
  }
  -- dap.configurations.cpp = {
  --   {
  --     name = "Launch",
  --     type = "lldb",
  --     request = "launch",
  --     program = function()
  --       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  --     end,
  --     cwd = '${workspaceFolder}',
  --     stopOnEntry = false,
  --     args = {},
  --     runInTerminal = false,
  --   },
  -- }
end


lvim.builtin.which_key.mappings["C"] = {
  name = "CMake",
  n = { "<cmd>CMake create_project<cr>", "Create new project" },
  c = { "<cmd>CMake configure<cr>", "CMake configure" },
  s = { "<cmd>CMake select_target<cr>", "CMake select target" },
  r = { "<cmd>CMake build_and_run<cr>", "CMake run" },
  t = { "<cmd>CMake select_build_type<cr>", "CMake select build type" },
  b = { "<cmd>CMake build<cr>", "CMake build" },
  d = { "<cmd>CMake build_and_debug<cr>", "CMake debug" },
  e = { "<cmd>CMake clean<cr>", "CMake clean" },
  q = { "<cmd>CMake cancel<cr>", "CMake cancel" },
}

lvim.builtin.which_key.mappings["n"] = {
  name = "Hop",
  n = { "<cmd> HopChar1 <cr>", "Hop one char" },
  h = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>", "Hop before cursor" },
  l = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>", "Hop after cursor" },
  j = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", "Hop line before cursor" },
  k = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "Hop line after cursor" },
}


-- Additional Plugins
lvim.plugins = {
  {
    "theHamsta/nvim-dap-virtual-text" },
  config = function()
    require("nvim-dap-virtual-text").setup()
  end,
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "Shatur/neovim-cmake",
    -- commit = "536987ef1fcbe7209ca3f243495603a5f1c250a7",
    config = function()
      require('cmake').setup
      {
        parameters_file = 'neovim.json',
        configure_args = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
        build_args = { '-j 10' },
        dap_configuration = {
          type = 'cppdbg',
          request = 'launch',
          setupCommands = {
            {
              description = "Enable pretty-printing",
              text = "-enable-pretty-printing",
            }
          }
        },
        -- dap_open_command = false,
        -- dap_open_command = require('dap').repl.open,
        dap_open_command = require('dapui').open,
      }
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require('telescope').load_extension('ui-select')
    end,
  },
  {
    "fayrushin/vscode.nvim",
  },
  {
    "phaazon/hop.nvim",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require 'indent_blankline'.setup {
        indentLine_enabled = 1,
        char = "▏",
        filetype_exclude = {
          "help",
          "terminal",
          "alpha",
          "packer",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
          "nvchad_cheatsheet",
          "lsp-installer",
          "dashboard",
          "NvimTree",
          "",
        },
        buftype_exclude = { "terminal" },
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,
        -- show_current_context_start = true,
        show_current_context = true,
      }
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },

  -- {
  --   'nvim-telescope/telescope-media-files.nvim',
  --   config = function()
  --   require('telescope').load_extension('media_files')
  --   end
  -- }
}
