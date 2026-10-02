return {
  -- File explorer
  { "stevearc/oil.nvim", opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Snacks explorer: show hidden/gitignored files
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
        update_focused_file = {
          enable = true,
        },
      })
    end,
  },

  -- Completion (blink.cmp) — Markdown では補完を無効化
  -- 散文を書く filetype ではバッファ単語のサジェストが邪魔になるため、
  -- enabled を false にして補完メニュー自体を出さない
  {
    "saghen/blink.cmp",
    opts = {
      enabled = function()
        return not vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype)
      end,
    },
  },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1,
    config = function()
      pcall(require("telescope").load_extension, "fzf")
    end
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "go", "typescript", "tsx", "javascript", "lua", "vim", "vimdoc", "markdown", "markdown_inline" },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },

  -- Jump
  {
    "hadronized/hop.nvim",
    event = "VeryLazy",
    config = function()
      local hop = require("hop")
      hop.setup()
      vim.keymap.set("n", "<leader>j", hop.hint_words, { desc = "Hop words" })
    end,
  },

  -- Disable mason: LSP servers are installed via Homebrew (gopls, typescript-language-server)
  -- to avoid pulling prebuilt binaries from a third-party registry.
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },

  -- LSP settings (Go 1.26 + gopls optimized)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- ── Diagnostic UI ─────────────────────────────────────────────
      -- Go 1.26 の強化された analysis 基盤から多くの診断が出るため、
      -- サイン・フロート・重要度ソートを整えて視認性を確保する
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
          },
        },
        float = {
          border = "rounded",
          source = true, -- どの analyzer が報告したか表示
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true, -- ERROR を最優先表示
      })

      -- ── Helper: code action を同期的に適用 ────────────────────────
      local function apply_code_action(bufnr, action_kind)
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { action_kind }, diagnostics = {} }
        local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
        for _, res in pairs(result or {}) do
          for _, action in pairs(res.result or {}) do
            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
            elseif action.command then
              vim.lsp.buf.execute_command(action.command)
            end
          end
        end
      end

      -- ── BufWritePre: Go ファイル保存時の自動整形 ──────────────────
      -- 1) organizeImports — 不要な import を除去し、欠けた import を追加
      -- 2) fixAll         — gopls の analysis 結果 (modernize 等) を一括適用
      -- 3) format         — Go 1.26 標準の gofmt 準拠フォーマット
      -- NOTE: LazyVim の conform.nvim と併用する場合は
      --       conform 側の Go フォーマッタを無効化してください
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("GoFormatOnSave", { clear = true }),
        pattern = "*.go",
        callback = function(ev)
          apply_code_action(ev.buf, "source.organizeImports")
          apply_code_action(ev.buf, "source.fixAll")
          vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
        end,
      })

      -- ── LspAttach: カスタムキーマップ ─────────────────────────────
      -- LazyVim が既に提供するキーマップ (gd, gD, gI, gr, gy, K, gK,
      -- <leader>ca, <leader>cr, <leader>cd, [d, ]d, [e, ]e, <leader>uh 等)
      -- は再定義せず、追加分のみ設定する
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Go 固有: gopls 接続時に inlay hints をデフォルト有効化
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "gopls" then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
        end,
      })

      -- blink.cmp から LSP capabilities を取得
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- ── Go LSP (gopls) — Go 1.26 最適化設定 ──────────────────────
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            -- == Analysis 設定 ==
            -- Go 1.26 で強化された golang.org/x/tools/go/analysis 基盤をフル活用
            analyses = {
              -- Go 1.26 の新構文 (min/max, range-over-int, new(expr) 等) への
              -- 自動変換提案を有効化。レガシーパターンのモダナイズを支援
              modernize = true,
              -- nil になり得ないポインタの冗長な nil チェックを検出
              nilness = true,
              -- 使用されていない関数パラメータを検出
              unusedparams = true,
              -- 読まれることのない変数への書き込みを検出
              unusedwrite = true,
              -- interface{} → any への置換を提案 (Go 1.18+ の型エイリアス)
              useany = true,
              -- 変数のシャドウイングを検出し、意図しないバグを防止
              shadow = true,
            },
            -- staticcheck の lint ルールを gopls 内で実行
            staticcheck = true,

            -- == Inlay Hints (型ヒント) ==
            -- コード中に型情報やパラメータ名をインラインで表示し、
            -- Go の暗黙的な型推論を可視化する
            hints = {
              assignVariableTypes = true,    -- v := expr → v の推論型を表示
              compositeLiteralFields = true, -- 構造体リテラルのフィールド名を表示
              compositeLiteralTypes = true,  -- 複合リテラルの型を表示
              constantValues = true,         -- 定数の計算結果を表示
              functionTypeParameters = true, -- ジェネリクスの型パラメータを表示
              parameterNames = true,         -- 関数呼び出しの引数名を表示
              rangeVariableTypes = true,     -- range 変数の型を表示
            },
          },
        },
      })
      vim.lsp.enable("gopls")

      -- ── TypeScript/JavaScript LSP ─────────────────────────────────
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("ts_ls")
    end,
  },

  -- Force blink.cmp to use the pure-Lua fuzzy matcher instead of downloading a
  -- prebuilt Rust binary from GitHub releases.
  {
    "saghen/blink.cmp",
    opts = {
      fuzzy = { implementation = "lua" },
    },
  },

  -- In-buffer markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {},
  },
}
