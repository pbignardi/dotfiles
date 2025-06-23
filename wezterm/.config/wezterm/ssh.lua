local M = {}
local wezterm = require("wezterm")

M.setup = function(config)
	config.ssh_domains = {
		{
			name = "raspberrypi",
			remote_address = "192.168.1.16",
		},
	}
end

return M
