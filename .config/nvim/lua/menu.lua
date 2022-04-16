local menu = require("which-key")

menu.register({
  ["<leader>r"] = { ":redo<cr>", "Redo" },
  ["<leader>u"] = { ":undo<cr>", "Undo" },
  ["<leader>e"] = { ":NvimTreeToggle<cr>", "Explorer" },
  ["<leader>n"] = { ":noh<cr>", "No Highlighting" },
  ["<leader>c"] = { ":bdelete<cr>", "Close Tab" },
  ["<leader>;"] = { ":Dashboard<cr>", "Dashboard" },
  ["<leader>T"] = { ":Tetris<cr>", "Tetris" },
  ["<leader>d"] = { ":TroubleToggle<cr>", "Show List" },
})

menu.register({
  ["<Leader>"] = {
    w = {
      name = "+Formatting (not working)",
      a = {":Autoformat<cr>", "Format File"},
      b = {":AutoformatLine<cr>", "Format Line"},
      f = {":RemoveTrailingSpaces<cr>", "Remove Trailing Spaces"},
    }
  }
})

menu.register({
  ["<Leader>"] = {
    f = {
      name = "+Terminal",
      t = {":ToggleTerm direction=float<cr>", "Floating Terminal"},
      b = {":ToggleTerm<cr>", "Terminal on the bottom"},
    }
  }
})

menu.register({
  ["<Leader>"] = {
    a = {
      name = "+Line Management",
      b = {":call append(line('.'), '')<cr>", "Add Line Below"},
      a = {":call append(line('.')-1, '')<cr>", "Add Line Above"},
    }
  }
})

menu.register({
  ["<Leader>"] = {
    m = {
      name = "+Markdown",
      o = {":MarkdownPreview<cr>", "Start Preview"},
      c = {":MarkdownPreviewStop<cr>", "Stop Preview"},
    }
  }
})

menu.register({
  ["<Leader>"] = {
    b = {
      name = "+Buffer / Tab",
      c = {":bdelete<cr>", "Close"},
      d = {":BufferLinePickClose<cr>", "Close Selection"},
      o = {":BufferLinePick<cr>", "GoTo Selection"},
      n = {":BufferLineMoveNext<cr>", "Move Next"},
      p = {":BufferLineMovePrev<cr>", "Move Prev"},
    }
  }
})

menu.register({
  ["<Leader>"] = {
    t = {
      name = "+Telescope",
      f = {":Telescope find_files<cr>", "Files"},
      l = {":Telescope live_grep<cr>", "Live Grep"},
      t = {":Telescope buffers<cr>", "Open Editors"},
      p = {":Telescope planets<cr>", "Planets"},
    }
  }
})

menu.register({
  ["<Leader>"] = {
    g = {
      name = "+Git",
      l = {":Gitsigns toggle_signs<cr>", "Toggle Git Changes Sign"},
      s = {":Telescope git_status<cr>", "Git Status"},
      c = {":Telescope git_commits<cr>", "Git Commits"},
      b = {":Telescope git_branches<cr>", "Git Branches"},
    }
  }
})




