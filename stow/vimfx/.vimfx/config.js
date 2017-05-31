vimfx.addCommand({
  name: 'view_source',
  description: 'View source',
  mode: 'normal',
}, ({vim}) => {
  vim.window.BrowserViewSource(vim.window.gBrowser.selectedBrowser);
})

let options = {
  "prevent_autofocus": true,
  "custom.mode.normal.view_source": "gf",
  "mode.normal.focus_search_bar": "s",
  "mode.normal.copy_current_url": "y",
  "mode.normal.go_up_path": "",
  "mode.normal.go_to_root": "",
  "mode.normal.go_home": "",
  "mode.normal.history_list": "",
  "mode.normal.reload_all": "",
  "mode.normal.reload_all_force": "",
  "mode.normal.stop": "",
  "mode.normal.stop_all": "",
  "mode.normal.scroll_page_down": "<c-f>",
  "mode.normal.scroll_page_up": "<c-b>",
  "mode.normal.scroll_half_page_down": "<c-d>",
  "mode.normal.scroll_half_page_up": "<c-u>",
  "mode.normal.tab_duplicate": "",
  "mode.normal.tab_select_previous": "gT",
  "mode.normal.tab_select_next": "gt",
  "mode.normal.tab_select_most_recent": "",
  "mode.normal.tab_select_oldest_unvisited": "",
  "mode.normal.tab_move_backward": "gH",
  "mode.normal.tab_move_forward": "gL",
  "mode.normal.tab_close": "d",
  "mode.normal.tab_restore": "u",
  "mode.normal.tab_restore_list": "",
  "mode.normal.tab_close_to_end": "",
  "mode.normal.tab_close_other": "",
  "mode.normal.follow_copy": "",
  "mode.normal.element_text_copy": "",
  "mode.normal.enter_mode_ignore": "<c-z>",
  "mode.caret.move_word_left": "b B",
  "mode.caret.move_word_right": "w W",
  "mode.ignore.exit": "<escape>"
};

Object.entries(options).forEach(([option, value]) => vimfx.set(option, value));