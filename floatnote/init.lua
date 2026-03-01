local M = {}

M.note_buf = nil
M.note_win = nil
M.note_path = nil

function M.setup(opts)
  opts = opts or {}
  M.note_path = vim.fn.stdpath("config") .. "/note.md"

  vim.api.nvim_create_user_command("Note", function()
    M.toggle()
  end, { desc = "Toggle floating note/todo list" })

  if opts.keymap ~= false then
    vim.keymap.set("n", "<leader>nn", "<cmd>Note<CR>", {
      desc = "Toggle floating note/todo",
      silent = true,
    })
  end
end

local function ensure_note_file()
  if vim.fn.filereadable(M.note_path) == 1 then
    return
  end

  vim.fn.mkdir(vim.fn.fnamemodify(M.note_path, ":h"), "p")

  local starter = {
    "# My Notes & Todos",
    "",
    "## Todos",
    "",
    "## Quick Notes",
    "",
    "---",
    "Last updated: " .. os.date("%Y-%m-%d %H:%M"),
  }

  vim.fn.writefile(starter, M.note_path)
end

local function get_or_create_buf()
  if M.note_buf and vim.api.nvim_buf_is_valid(M.note_buf) then
    return M.note_buf
  end

  ensure_note_file()

  M.note_buf = vim.fn.bufadd(M.note_path)
  vim.fn.bufload(M.note_buf)

  vim.bo[M.note_buf].filetype    = "markdown"
  vim.bo[M.note_buf].buftype     = ""
  vim.bo[M.note_buf].swapfile    = false
  vim.bo[M.note_buf].modifiable  = true

  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = M.note_buf,
    callback = function()
      local timestamp = "Last updated: " .. os.date("%Y-%m-%d %H:%M")
      local lines = vim.api.nvim_buf_get_lines(M.note_buf, 0, -1, false)

      local updated = false
      for i = math.max(1, #lines - 5), #lines do
        if lines[i]:match("^Last updated:") then
          lines[i] = timestamp
          updated = true
          break
        end
      end

      if not updated then
        vim.list_extend(lines, { "", "---", timestamp })
      end

      local was_modified = vim.bo[M.note_buf].modified
      vim.api.nvim_buf_set_lines(M.note_buf, 0, -1, false, lines)
      vim.bo[M.note_buf].modified = was_modified
    end,
    desc = "Update floatnote timestamp after save",
  })

  return M.note_buf
end

function M.open()
  ensure_note_file()

  local buf = get_or_create_buf()

  if M.note_win and vim.api.nvim_win_is_valid(M.note_win) then
    vim.api.nvim_set_current_win(M.note_win)
    return
  end

  local width  = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.5)
  local row    = math.floor((vim.o.lines - height) / 2)
  local col    = math.floor((vim.o.columns - width) / 2)

  M.note_win = vim.api.nvim_open_win(buf, true, {
    relative = "win",
    width    = width,
    height   = height,
    row      = row,
    col      = col,
    style    = "minimal",
    border   = "rounded",
    title    = " Note / Todo List ",
    title_pos = "center",
  })

  vim.wo[M.note_win].number         = true
  vim.wo[M.note_win].cursorline     = true
  vim.wo[M.note_win].wrap           = true
  vim.wo[M.note_win].linebreak      = true
  vim.wo[M.note_win].conceallevel   = 2

  local opts = { noremap = true, silent = true, buffer = buf }
  vim.keymap.set("n", "q",     M.close, opts)
  vim.keymap.set("n", "<Esc>", M.close, opts)
end

function M.close()
  if not (M.note_win and vim.api.nvim_win_is_valid(M.note_win)) then
    return
  end

  if M.note_buf and vim.api.nvim_buf_is_valid(M.note_buf) and vim.bo[M.note_buf].modified then
    vim.api.nvim_buf_call(M.note_buf, function()
      vim.cmd("silent! write")
    end)
  end

  vim.api.nvim_win_close(M.note_win, true)
  M.note_win = nil
end

function M.toggle()
  if M.note_win and vim.api.nvim_win_is_valid(M.note_win) then
    M.close()
  else
    M.open()
  end
end

return M
