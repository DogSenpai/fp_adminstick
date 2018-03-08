-- The admin mod/addon that your server uses.
-- If you don't use any third-party admin mods; use: "fadmin".
-- ("FAdmin" is the built-in admin mod for DarkRP.)
cfg_adminmod = "ulx"
-- Supported admin mods: "fadmin", "ulx"

-- The usergroups/ranks that are allowed to use the Admin Stick.
cfg_adminranks = {
		"founder",
		"superadmin",
		"head admin",
		"staffmanager",
		"moderator",
		"t mod",
		"admin",
                "moddonator",
                "t moddonator"
}
-- Default: Moderator and above.

-- The usergroups/ranks that are allowed to edit people wallet (add/subtract money)
cfg_moneyranks = {
		"founder",
		"superadmin",
                "head admin"
}
-- Default: Superadmin and above.

-- Set this to "true" if your server uses the Buildermode script.
cfg_buildermode = false
-- Buildermode: https://scriptfodder.com/scripts/view/944

-- Set this to "true" if your server uses the Distress bonus script (included in with Admin Stick)
cfg_usesdistress = false