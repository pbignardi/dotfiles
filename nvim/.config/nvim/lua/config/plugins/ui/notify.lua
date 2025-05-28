return {
	"echasnovski/mini.notify",
	version = false,
	config = function()
		local notify = require("mini.notify")
		notify.setup({
			content = {
				format = function(notif)
					local content = ""
					if notif.level == "INFO" then
						content = content .. "  Info - "
					elseif notif.level == "ERROR" then
						content = content .. "  Error - "
					elseif notif.level == "WARN" then
						content = content .. "  Warning - "
					elseif notif.level == "DEBUG" then
						content = content .. "  Debug - "
					else
						content = ""
					end
					return content .. notif.msg .. " "
				end,
			},
			window = {
				config = {
					border = "rounded",
				},
				max_width_share = 0.4,
			},
		})
		vim.notify = notify.make_notify()
	end,
}
