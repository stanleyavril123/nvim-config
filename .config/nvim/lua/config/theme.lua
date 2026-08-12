-- Keeps Neovim in sync with the shared `theme` selector that also recolors
-- Kitty and tmux. The selector writes the active theme to
-- ~/.local/state/theme/nvim.lua, which is read at startup and watched for
-- changes so a theme switched in the terminal reaches an open editor.

local M = {}

local state_dir = (vim.env.XDG_STATE_HOME or vim.env.HOME .. "/.local/state") .. "/theme"
local state_file = state_dir .. "/nvim.lua"

-- Used before any theme has been selected on a fresh machine.
local fallback = {
	id = "catppuccin-mocha",
	name = "Catppuccin Mocha",
	appearance = "dark",
	colorscheme = "catppuccin-mocha",
	plugin = "catppuccin",
	background = "#1e1e2e",
}

-- Several color schemes dim these groups past the point of being readable on a
-- terminal background. Each is nudged toward the background's opposite until it
-- clears its minimum contrast ratio, and left alone when it already does.
local floors = {
	{ group = "Normal", min = 4.5 },
	{ group = "Comment", min = 3.0 },
	{ group = "LineNr", min = 2.2 },
	{ group = "NonText", min = 2.0 },
	{ group = "Whitespace", min = 2.0 },
}

local function channel(value)
	value = value / 255
	if value <= 0.03928 then
		return value / 12.92
	end
	return ((value + 0.055) / 1.055) ^ 2.4
end

local function luminance(color)
	return 0.2126 * channel(math.floor(color / 65536) % 256)
		+ 0.7152 * channel(math.floor(color / 256) % 256)
		+ 0.0722 * channel(color % 256)
end

local function contrast(a, b)
	local high, low = luminance(a), luminance(b)
	if high < low then
		high, low = low, high
	end
	return (high + 0.05) / (low + 0.05)
end

local function blend(color, target, amount)
	local out = 0
	for _, shift in ipairs({ 65536, 256, 1 }) do
		local from = math.floor(color / shift) % 256
		local to = math.floor(target / shift) % 256
		out = out + math.floor(from + (to - from) * amount + 0.5) * shift
	end
	return out
end

local function raise_contrast(group, min, bg)
	local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
	if not hl.fg or contrast(hl.fg, bg) >= min then
		return
	end

	local target = luminance(bg) < 0.18 and 0xffffff or 0x000000
	for step = 1, 20 do
		local fg = blend(hl.fg, target, step / 20)
		if contrast(fg, bg) >= min then
			hl.fg = fg
			vim.api.nvim_set_hl(0, group, hl)
			return
		end
	end
end

-- Kitty owns the background, including its opacity, so the groups that tile the
-- window stay unpainted. Most color schemes are configured that way already;
-- this also covers the ones that ignore their own transparency option.
local surfaces = {
	"Normal",
	"NormalNC",
	"SignColumn",
	"FoldColumn",
	"EndOfBuffer",
	"LineNr",
	"CursorLineNr",
	"MsgArea",
	"NonText",
	"Whitespace",
}

local function clear_backgrounds()
	for _, group in ipairs(surfaces) do
		local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
		if hl.bg then
			hl.bg = nil
			vim.api.nvim_set_hl(0, group, hl)
		end
	end
end

--- Make the color scheme sit on the terminal background and keep dim text
--- legible against it.
---@param spec table
local function harmonize(spec)
	clear_backgrounds()

	local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
	local bg = normal.bg or tonumber((spec.background or ""):sub(2), 16)
	if not bg then
		return
	end

	for _, floor in ipairs(floors) do
		raise_contrast(floor.group, floor.min, bg)
	end
end

local function executable()
	local candidates = {
		vim.fn.exepath("theme"),
		vim.env.HOME .. "/.local/bin/theme",
		vim.env.HOME .. "/.dotfiles/bin/theme",
	}

	for _, path in ipairs(candidates) do
		if path ~= "" and vim.fn.executable(path) == 1 then
			return path
		end
	end
end

--- The active theme, or nil when nothing readable has been written yet.
---@return table|nil
local function read_state()
	if vim.fn.filereadable(state_file) == 0 then
		return nil
	end

	local ok, spec = pcall(dofile, state_file)
	if not ok or type(spec) ~= "table" or not spec.colorscheme then
		return nil
	end
	return spec
end

--- Load the theme's plugin if needed and switch color scheme.
---@param spec table theme description as written by `theme set`
function M.apply(spec)
	if not spec or not spec.colorscheme then
		return false
	end

	if spec.plugin and spec.plugin ~= "" then
		pcall(function()
			require("lazy").load({ plugins = { spec.plugin } })
		end)
	end

	vim.o.background = spec.appearance == "light" and "light" or "dark"
	if not pcall(vim.cmd.colorscheme, spec.colorscheme) then
		vim.notify("theme: cannot load " .. spec.colorscheme .. " (run :Lazy sync)", vim.log.levels.WARN)
		return false
	end

	harmonize(spec)
	M.current = spec
	return true
end

--- Apply a theme everywhere: this editor now, then Kitty, tmux, and every
--- other running Neovim through the selector.
---@param id string
function M.set(id)
	local themes = M.list()
	for _, spec in ipairs(themes) do
		if spec.id == id then
			M.apply(spec)
			break
		end
	end

	local exe = executable()
	if not exe then
		vim.notify("theme: the theme command is not on PATH", vim.log.levels.WARN)
		return
	end
	vim.system({ exe, "set", id }, { text = true })
end

--- Themes reported by the selector, or just the active one if it is missing.
---@return table[]
function M.list()
	local exe = executable()
	if not exe then
		return { M.current or read_state() or fallback }
	end

	local themes = {}
	for _, line in ipairs(vim.fn.systemlist({ exe, "list", "--raw" })) do
		local fields = vim.split(line, "\t", { plain = true })
		if #fields == 6 and fields[4] ~= "" then
			themes[#themes + 1] = {
				id = fields[1],
				name = fields[2],
				appearance = fields[3],
				colorscheme = fields[4],
				plugin = fields[5],
				background = fields[6],
			}
		end
	end
	return themes
end

--- Pick a theme with live preview. Moving the selection applies the theme;
--- leaving the picker without choosing restores the previous one.
function M.pick()
	local themes = M.list()
	local original = M.current or read_state() or fallback

	local ok, pickers = pcall(require, "telescope.pickers")
	if not ok then
		local ids = vim.tbl_map(function(spec)
			return spec.id
		end, themes)
		vim.ui.select(ids, { prompt = "Theme" }, function(choice)
			if choice then
				M.set(choice)
			end
		end)
		return
	end

	local finders = require("telescope.finders")
	local previewers = require("telescope.previewers")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local conf = require("telescope.config").values
	local accepted = false

	pickers
		.new({}, {
			prompt_title = "Themes",
			finder = finders.new_table({
				results = themes,
				entry_maker = function(spec)
					return {
						value = spec,
						display = string.format("%-22s %s", spec.name, spec.appearance),
						ordinal = spec.name .. " " .. spec.id,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = previewers.new_buffer_previewer({
				title = "Live preview",
				define_preview = function(self, entry)
					M.apply(entry.value)
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
						entry.value.name,
						"",
						"id         " .. entry.value.id,
						"appearance " .. entry.value.appearance,
						"",
						"Enter applies to Kitty, tmux, and Neovim.",
						"Esc restores " .. original.name .. ".",
					})
				end,
			}),
			attach_mappings = function(prompt_bufnr, map)
				-- One Esc leaves the picker instead of only leaving insert mode.
				map({ "i", "n" }, "<Esc>", actions.close)

				actions.select_default:replace(function()
					local entry = action_state.get_selected_entry()
					accepted = true
					actions.close(prompt_bufnr)
					if entry then
						M.set(entry.value.id)
					end
				end)

				vim.api.nvim_create_autocmd("BufWipeout", {
					buffer = prompt_bufnr,
					once = true,
					callback = function()
						vim.schedule(function()
							if not accepted then
								M.apply(original)
							end
						end)
					end,
				})

				return true
			end,
		})
		:find()
end

-- Reload when the selector writes a new theme from outside this editor. The
-- whole state directory is watched, because a single `theme set` replaces
-- several files and the events for them arrive in no fixed order.
local function watch()
	vim.fn.mkdir(state_dir, "p")

	local handle = vim.uv.new_fs_event()
	if not handle then
		return
	end

	local queued = false
	local function reload()
		if queued then
			return
		end
		queued = true

		-- Settle first: the state is read once per burst of writes.
		vim.defer_fn(function()
			queued = false
			local spec = read_state()
			if spec and (not M.current or spec.id ~= M.current.id) then
				M.apply(spec)
			end
		end, 50)
	end

	handle:start(
		state_dir,
		{},
		vim.schedule_wrap(function(err)
			if not err then
				reload()
			end
		end)
	)
end

function M.setup()
	M.apply(read_state() or fallback)
	watch()

	vim.api.nvim_create_user_command("Theme", function(args)
		if args.args == "" then
			M.pick()
		else
			M.set(args.args)
		end
	end, {
		nargs = "?",
		desc = "Select the Kitty, tmux, and Neovim theme",
		complete = function()
			return vim.tbl_map(function(spec)
				return spec.id
			end, M.list())
		end,
	})

	vim.keymap.set("n", "<leader>ut", M.pick, { desc = "Switch theme" })
end

return M
