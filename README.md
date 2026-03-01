# Floatnote

A lightweight Neovim plugin that provides a floating note/todo list that persists across sessions. Keep your notes, todos, and quick thoughts accessible with a single keypress while working in your editor.

## Features

- 📝 **Floating Note Window** - Opens a centered floating window with a rounded border
- 💾 **Persistent Storage** - Notes are automatically saved to a markdown file
- ⏰ **Auto-Timestamping** - Automatically updates a timestamp whenever you save
- 🚀 **Zero Configuration** - Works out of the box with sensible defaults
- 📦 **Minimal Footprint** - Lightweight Lua implementation with no external dependencies

## Installation

### Using Lazy.nvim

```lua
{
  "ceelvin/floatnote",
  config = function()
    require("floatnote").setup()
  end,
}
```

### Using Packer

```lua
use {
  "ceelvin/floatnote",
  config = function()
    require("floatnote").setup()
  end,
}
```

## Usage

### Basic Commands

**Toggle the floating note window:**
```vim
:Note
```

Or use the default keybinding:
```vim
<leader>nn
```

**Close the window:**
- Press `q` or `<Esc>` while focused on the floating window

### Workflow

1. Press `<leader>nn` to open your floating note window
2. Edit your notes, add todos, or jot down quick thoughts
3. Changes are automatically saved when you write (`:w`)
4. Press `q` or `<Esc>` to close and return to your work
5. Open again with `<leader>nn` - your notes are still there!

## Configuration

### Basic Setup

```lua
require("floatnote").setup()
```

### Custom Configuration

```lua
require("floatnote").setup({
  keymap = true,  -- Set to false to disable default <leader>nn keybinding
})
```

### Disable Default Keybinding

If you want to use a custom keybinding:

```lua
require("floatnote").setup({ keymap = false })

-- Add your custom keybinding
vim.keymap.set("n", "<leader>n", "<cmd>Note<CR>", { noremap = true, silent = true })
```

## File Location

Notes are stored as a markdown file at:
```
~/.config/nvim/note.md
```

You can access and edit this file directly if needed. The plugin automatically creates it on first use with a template structure.

## Plugin Behavior

### Window Appearance

- **Size**: 50% of your editor width and 50% of your editor height
- **Position**: Centered on your screen
- **Style**: Minimal with rounded border
- **Title**: Displayed as " 📝 Note / Todo List " at the top center

### Editor Features

Inside the floating window:
- Line numbers enabled
- Cursor line highlighting
- Text wrapping and line breaking
- Markdown syntax highlighting
- Concealing enabled for markdown formatting

### Auto-Save Behavior

- Changes are saved when you use `:w` in the floating window
- A timestamp (`Last updated: YYYY-MM-DD HH:MM`) is automatically updated in the file
- The timestamp appears in the last section of the file or at the end with a separator

## Template Structure

When the note file is first created, it includes this template:

```markdown
# My Notes & Todos

## Todos

## Quick Notes

---
Last updated: YYYY-MM-DD HH:MM
```

Feel free to customize this template by editing `~/.config/nvim/note.md` directly.

## Requirements

- Neovim >= 0.5.0
- No external dependencies (pure Lua)

## Performance

Floatnote is designed to be lightweight and have minimal impact on editor performance:
- Only loads when requested
- Efficient buffer and window management
- Automatic cleanup of invalid windows/buffers
- No background processes or timers

---

**Happy note-taking! 📝**
