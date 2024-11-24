--[[
    type,
        label - pure text
        bool
        button:
            content - text in button
            func - function(self2) end
        slider:
            min
            max
            decimals
            convar2 - same as convar, but only for input, not follow always
            func - function(self2) end   after action
        color
        coloralpha - with transparency slider
        input - text input, NOT IMPLEMENTED
        combo - dropdown menu:
            content - {{"1table of thingies", "stibb"}, {"2there", "yolo"}, {"3for some reason you need put number at start so it will be properly sorted", "foog"}, {"4though it will be not drawn in ui", "booglybop"}}
    title,
    convar to follow, (without arc9_; color selectors will automatically use _r/_g/_b)
    description to show on right
]]--

ARC9.LanguagesTable = {
{"0GMod Language", ""},
{"1English", "en"},
{"2Deutsch", "de"},
{"2Español", "es-es"},
{"2Русский", "ru"},
{"2Svenska", "sv-se"},
{"2中國人", "zh-cn"},

{"9UwU :3", "uwu"},
}

ARC9.BadPerfromanceSettings = function() return BRANCH != "x86-64" end
ARC9.BadPerfromanceSettingsAlt = function() return BRANCH != "x86-64" or GetConVar("mat_queue_mode"):GetInt() == 0 or GetConVar("cl_threaded_bone_setup"):GetInt() < 1 end

ARC9.SettingsTable = {
    {
        TabName = "v2.settings.tabname.quick",
        Warning = ARC9.BadPerfromanceSettingsAlt,
        { type = "label", text = "badconf.warning", desc = "badconf.warning.desc", important = true, showfunc = ARC9.BadPerfromanceSettingsAlt },
        { type = "label", text = "badconf.x64.title", desc = "badconf.x64.desc", showfunc = function() return BRANCH != "x86-64" end },
        { type = "label", text = "badconf.multicore.title", desc = "badconf.multicore.desc", showfunc = function() return GetConVar("mat_queue_mode"):GetInt() == 0 or GetConVar("cl_threaded_bone_setup"):GetInt() < 1 end },
        { type = "label", text = "", showfunc = ARC9.BadPerfromanceSettingsAlt },
        { type = "label", text = "", showfunc = ARC9.BadPerfromanceSettingsAlt },

        { type = "label", text = "v2.settings.tabname.general", desc = "v2.settings.tabname.quick.desc" },
		{ type = "combo", text = "v2.settings.quick.lang.title", desc = "v2.settings.quick.lang.desc", convar = "language", content = ARC9.LanguagesTable, func = function(self2)
            RunConsoleCommand("arc9_reloadlangs")
        end},
        { type = "bool", text = "v2.settings.hud_game.hud_arc9.title", desc = "v2.settings.hud_game.hud_arc9.desc2", convar = "hud_arc9", requireconvaroff = "hud_force_disable" },
        { type = "bool", text = "v2.settings.tpik.title", desc = "v2.settings.tpik.desc2", convar = "tpik" },
        { type = "bool", text = "v2.settings.aimassist.enable.title", desc = "v2.settings.aimassist.enable.desc2", convar = "aimassist_cl", requireconvar = "aimassist" },
        { type = "bool", text = "v2.settings.gameplay.controller.title", desc = "v2.settings.gameplay.controller.desc", convar = "controller" },
		
        -- { type = "label", text = "settings.modifiers.quick.desc" },
        -- { sv = true, type = "bool", text = "v2.settings.server.hud_game.hud_arc9.title", desc = "v2.settings.server.hud_game.hud_arc9.desc", convar = "hud_force_disable" },
        -- { sv = true, type = "bool", text = "v2.settings.gameplay.truenames.title", desc = "v2.settings.gameplay.truenames.desc", convar = "truenames_default" },
        -- { sv = true, type = "bool", text = "v2.settings.server.aimassist.enable.title", desc = "v2.settings.server.aimassist.enable.desc", convar = "aimassist" },
	},
    {
        TabName = "v2.settings.tabname.hud_game",

        { type = "label", text = "v2.settings.tabname.arc9_hud", desc = "v2.settings.tabname.arc9_hud.desc" },
        { type = "bool", text = "v2.settings.hud_game.hud_arc9.title", desc = "v2.settings.hud_game.hud_arc9.desc", convar = "hud_arc9", requireconvaroff = "hud_force_disable" },
        { type = "bool", text = "v2.settings.hud_game.hud_compact.title", desc = "v2.settings.hud_game.hud_compact.desc", convar = "hud_compact", parentconvar = "hud_arc9", requireconvaroff = "hud_force_disable" },
        { type = "bool", text = "v2.settings.hud_game.hud_always.title", desc = "v2.settings.hud_game.hud_always.desc", convar = "hud_always", parentconvar = "hud_arc9", requireconvaroff = "hud_force_disable" },
		
        { type = "bool", text = "v2.settings.hud_game.keephints.title", desc = "v2.settings.hud_game.keephints.desc", convar = "hud_keephints" },
        { type = "bool", text = "v2.settings.hud_game.nohints.title", desc = "v2.settings.hud_game.nohints.desc", convar = "hud_nohints" },
		
        { type = "bool", text = "v2.settings.hud_game.killfeed_enable.title", desc = "v2.settings.hud_game.killfeed_enable.desc", convar = "killfeed_enable" },
        { type = "bool", text = "v2.settings.hud_game.killfeed_dynamic.title", desc = "v2.settings.hud_game.killfeed_dynamic.desc", convar = "killfeed_dynamic", parentconvar = "killfeed_enable" },
        { type = "bool", text = "v2.settings.hud_game.killfeed_colour.title", desc = "v2.settings.hud_game.killfeed_colour.desc", convar = "killfeed_colour", parentconvar = "killfeed_enable" },
		
        -- { type = "label", text = "v2.settings.tabname.glyphs", desc = "v2.settings.tabname.glyphs.desc" },
        -- { type = "combo", text = "v2.settings.hud_glyph.type_hud.title", desc = "v2.settings.hud_glyph.type_hud.desc", convar = "glyph_family_hud", content = {
				-- {"1" .. ARC9:GetPhrase("v2.settings.hud_glyph.light"), "light"},
				-- {"2" .. ARC9:GetPhrase("v2.settings.hud_glyph.dark"), "dark"},
				-- {"3" .. ARC9:GetPhrase("v2.settings.hud_glyph.knockout"), "knockout"},
			-- },
        -- },
        -- { type = "combo", text = "v2.settings.hud_glyph.type_cust.title", desc = "v2.settings.hud_glyph.type_cust.desc", convar = "glyph_family_cust", content = {
				-- {"1" .. ARC9:GetPhrase("v2.settings.hud_glyph.light"), "light"},
				-- {"2" .. ARC9:GetPhrase("v2.settings.hud_glyph.dark"), "dark"},
				-- {"3" .. ARC9:GetPhrase("v2.settings.hud_glyph.knockout"), "knockout"},
			-- },
        -- },

        { type = "label", text = "v2.settings.tabname.centerhint", desc = "v2.settings.tabname.centerhint.desc" },
        { type = "bool", text = "v2.settings.centerhint.breath_hud.title", desc = "v2.settings.centerhint.breath_hud.desc", convar = "breath_hud" },
        { type = "bool", text = "v2.settings.centerhint.breath_pp.title", desc = "v2.settings.centerhint.breath_pp.desc", convar = "breath_pp", parentconvar = "breath_hud" },
        { type = "bool", text = "v2.settings.centerhint.reload.title", desc = "v2.settings.centerhint.reload.desc", convar = "center_reload_enable" },
        { type = "slider", text = "v2.settings.centerhint.reload_percent.title", desc = "v2.settings.centerhint.reload_percent.desc", convar = "center_reload", min = 0, max = 1, decimals = 2, parentconvar = "center_reload_enable" },
        { type = "bool", text = "v2.settings.centerhint.bipod.title", desc = "v2.settings.centerhint.bipod.desc", convar = "center_bipod" },
        { type = "bool", text = "v2.settings.centerhint.jammed.title", desc = "v2.settings.centerhint.jammed.desc", convar = "center_jam" },
        { type = "bool", text = "v2.settings.centerhint.firemode.title", desc = "v2.settings.centerhint.firemode.desc", convar = "center_firemode" },
        -- { type = "slider", text = "v2.settings.centerhint.firemode_time.title", desc = "v2.settings.centerhint.firemode_time.desc", convar = "center_firemode_time", min = 0.5, max = 2, decimals = 2 },
        { type = "bool", text = "v2.settings.centerhint.overheat.title", desc = "v2.settings.centerhint.overheat.desc", convar = "center_overheat" },
		
        { type = "label", text = "v2.settings.tabname.arc9_hud_adv", desc = "v2.settings.tabname.arc9_hud_adv.desc" },
        { type = "slider", text = "v2.settings.hud_game.hud_scale.title", desc = "v2.settings.hud_game.hud_scale.desc", convar = "hud_arc9", min = 0.5, max = 1.5, decimals = 2, func = function(self2, self3, settingspanel)
            if IsValid(LocalPlayer()) then -- uncust the gun
                local wep = LocalPlayer():GetActiveWeapon()
                if IsValid(wep) and wep.ARC9 then
                    if wep.CustomizeHUD then
                        wep:SetCustomize(false)
                        net.Start("ARC9_togglecustomize")
                        net.WriteBool(false)
                        net.SendToServer()
                    end
                end
            end

            RunConsoleCommand("arc9_hud_scale", self3:GetValue())

            settingspanel:Remove() -- rebuilding
            timer.Simple(0, function()
                ARC9.Regen() -- reload fonts with new scale
                ARC9_OpenSettings()
            end)
        end
		},
        { type = "slider", text = "v2.settings.hud_game.hud_deadzonex.title", desc = "v2.settings.hud_game.hud_deadzonex.desc", convar = "hud_deadzonex", min = 0, max = 500 },
	},
    {
        TabName = "v2.settings.tabname.visuals",

        { type = "label", text = "v2.settings.tabname.tpik", desc = "v2.settings.tabname.tpik.desc" },
        { type = "bool", text = "v2.settings.tpik.title", desc = "v2.settings.tpik.desc", convar = "tpik" },
        { type = "bool", text = "v2.settings.tpik_others.title", desc = "v2.settings.tpik_others.desc", convar = "tpik_others", parentconvar = "tpik" },
        { type = "slider", text = "v2.settings.tpik_framerate.title", desc = "v2.settings.tpik_framerate.desc", convar = "tpik_others", parentconvar = "tpik", min = 0, max = 200 },
		
        { type = "label", text = "v2.settings.tabname.blur", desc = "v2.settings.tabname.blur.desc" },
        { type = "bool", text = "v2.settings.blur.cust_blur.title", desc = "v2.settings.blur.cust_blur.desc", convar = "cust_blur" },
        { type = "bool", text = "v2.settings.blur.fx_reloadblur.title", desc = "v2.settings.blur.fx_reloadblur.desc", convar = "fx_reloadblur" },
        { type = "bool", text = "v2.settings.blur.fx_animblur.title", desc = "v2.settings.blur.fx_animblur.desc", convar = "fx_animblur", parentconvar = "fx_reloadblur" },
        { type = "bool", text = "v2.settings.blur.fx_rtblur.title", desc = "v2.settings.blur.fx_rtblur.desc", convar = "fx_rtblur" },
        { type = "bool", text = "v2.settings.blur.fx_adsblur.title", desc = "v2.settings.blur.fx_adsblur.desc", convar = "fx_adsblur", parentconvar = "fx_rtblur" },
		
        { type = "label", text = "v2.settings.tabname.effects", desc = "v2.settings.tabname.effects.desc" },
        { type = "bool", text = "v2.settings.effects.eject_fx.title", desc = "v2.settings.effects.eject_fx.desc", convar = "eject_fx" },
        { type = "slider", text = "v2.settings.effects.eject_time.title", desc = "v2.settings.effects.eject_time.desc", convar = "eject_time", min = -1, max = 60 },
        { type = "bool", text = "v2.settings.effects.muzzle_light.title", desc = "v2.settings.effects.muzzle_light.desc", convar = "muzzle_light" },
        { type = "bool", text = "v2.settings.effects.muzzle_others.title", desc = "v2.settings.effects.muzzle_others.desc", convar = "muzzle_others" },
        { type = "bool", text = "v2.settings.effects.allflash.title", desc = "v2.settings.effects.allflash.desc", convar = "allflash" },
		
        { type = "label", text = "v2.settings.tabname.vm", desc = "v2.settings.tabname.vm.desc" },
		{ type = "combo", text = "v2.settings.vm.vm_bobstyle.title", desc = "v2.settings.vm.vm_bobstyle.desc", convar = "vm_bobstyle", content = {
				{"1Bread & Darsu", "0"},
				{"2Fesiug", "1"},
				{"3Arctic", "2"},
				{"4Darsu", "3"},
				{"5Bread (exaggerated)", "4"},
				{"6Half-Life 2", "-1"},
			},
		},
        { type = "slider", text = "v2.settings.vm.fov.title", desc = "v2.settings.vm.fov.desc", convar = "fov", min = -40, max = 40 },
        { type = "slider", text = "v2.settings.vm.vm_addx.title", desc = "v2.settings.vm.vm_addx.desc", convar = "vm_addx", min = -16, max = 16, decimals = 1 },
        { type = "slider", text = "v2.settings.vm.vm_addy.title", desc = "v2.settings.vm.vm_addy.desc", convar = "vm_addy", min = -16, max = 16, decimals = 1 },
        { type = "slider", text = "v2.settings.vm.vm_addz.title", desc = "v2.settings.vm.vm_addz.desc", convar = "vm_addz", min = -16, max = 16, decimals = 1 },
        { type = "bool", text = "v2.settings.vm.vm_cambob.title", desc = "v2.settings.vm.vm_cambob.desc", convar = "vm_cambob" },
        { type = "bool", text = "v2.settings.vm.vm_cambobwalk.title", desc = "v2.settings.vm.vm_cambobwalk.desc", convar = "vm_cambobwalk", parentconvar = "vm_cambob" },
        { type = "slider", text = "v2.settings.vm.vm_cambobintensity.title", desc = "v2.settings.vm.vm_cambobintensity.desc", convar = "vm_cambobintensity", min = 0.1, max = 3, decimals = 2, parentconvar = "vm_cambob" },
	},
    {
        TabName = "v2.settings.tabname.gameplay",

        { type = "label", text = "v2.settings.tabname.general", desc = "v2.settings.tabname.general.desc" },
        { type = "bool", text = "v2.settings.gameplay.toggleads.title", desc = "v2.settings.gameplay.toggleads.desc", convar = "toggleads" },
        { type = "bool", text = "v2.settings.gameplay.dtap_sights.title", desc = "v2.settings.gameplay.dtap_sights.desc", convar = "dtap_sights" },
        { type = "bool", text = "v2.settings.gameplay.autoreload.title", desc = "v2.settings.gameplay.autoreload.desc", convar = "autoreload" },
        { type = "bool", text = "v2.settings.gameplay.autolean.title", desc = "v2.settings.gameplay.autolean.desc", convar = "autolean", requireconvar = "lean" },
        { type = "bool", text = "v2.settings.gameplay.togglelean.title", desc = "v2.settings.gameplay.togglelean.desc", convar = "togglelean", requireconvar = "lean" },
        { type = "bool", text = "v2.settings.gameplay.togglepeek.title", desc = "v2.settings.gameplay.togglepeek.desc", convar = "togglepeek" },
        { type = "bool", text = "v2.settings.gameplay.togglepeek_reset.title", desc = "v2.settings.gameplay.togglepeek_reset.desc", convar = "togglepeek_reset", parentconvar = "togglepeek" },
        { type = "bool", text = "v2.settings.gameplay.togglebreath.title", desc = "v2.settings.gameplay.togglebreath.desc", convar = "togglebreath" },
		
        { type = "label", text = "v2.settings.tabname.optics", desc = "v2.settings.tabname.optics.desc" },
        { type = "bool", text = "v2.settings.gameplay.cheapscopes.title", desc = "v2.settings.gameplay.cheapscopes.desc", convar = "cheapscopes" },
        { type = "bool", text = "v2.settings.gameplay.fx_rtvm.title", desc = "v2.settings.gameplay.fx_rtvm.desc", convar = "fx_rtvm", parentconvar = "cheapscopes", parentinvert = true },
        { type = "bool", text = "v2.settings.gameplay.compensate_sens.title", desc = "v2.settings.gameplay.compensate_sens.desc", convar = "compensate_sens" },
        { type = "slider", text = "v2.settings.gameplay.sensmult.title", desc = "v2.settings.gameplay.sensmult.desc", convar = "mult_sens", parentconvar = "compensate_sens", min = 0.1, max = 1, decimals = 1 },
		
        { type = "color", text = "v2.settings.gameplay.color.reflex.title", desc = "v2.settings.gameplay.color.reflex.desc", convar = "reflex" },
        { type = "color", text = "v2.settings.gameplay.color.scope.title", desc = "v2.settings.gameplay.color.scope.desc", convar = "scope" },
		
        { type = "label", text = "v2.settings.tabname.crosshair", desc = "v2.settings.tabname.crosshair.desc" },
        { type = "bool", text = "v2.settings.crosshair.cross_enable.title", desc = "v2.settings.crosshair.cross_enable.desc", convar = "cross_enable" },
        { type = "bool", text = "v2.settings.crosshair.crosshair_force.title", desc = "v2.settings.crosshair.crosshair_force.desc", convar = "crosshair_force", parentconvar = "cross_enable" },
        { type = "bool", text = "v2.settings.crosshair.crosshair_static.title", desc = "v2.settings.crosshair.crosshair_static.desc", convar = "crosshair_static", parentconvar = "cross_enable" },
        { type = "bool", text = "v2.settings.crosshair.crosshair_target.title", desc = "v2.settings.crosshair.crosshair_target.desc", convar = "crosshair_target", parentconvar = "cross_enable" },
        { type = "bool", text = "v2.settings.crosshair.crosshair_peeking.title", desc = "v2.settings.crosshair.crosshair_peeking.desc", convar = "crosshair_peek", parentconvar = "cross_enable" },
		{ type = "combo", text = "v2.settings.crosshair.crosshair_sgstyle.title", desc = "v2.settings.crosshair.crosshair_sgstyle.desc", convar = "cross_sgstyle", parentconvar = "cross_enable", content = {
			{"1" .. ARC9:GetPhrase("v2.settings.crosshair.crosshair_sgstyle_fullcircle"), "1"},
			{"2" .. ARC9:GetPhrase("v2.settings.crosshair.crosshair_sgstyle_four"), "2"},
			{"3" .. ARC9:GetPhrase("v2.settings.crosshair.crosshair_sgstyle_two"), "3"},
			{"4" .. ARC9:GetPhrase("v2.settings.crosshair.crosshair_sgstyle_dots"), "4"},
			{"5" .. ARC9:GetPhrase("v2.settings.crosshair.crosshair_sgstyle_dots_accurate"), "5"}, 
			},
        },
        { type = "color", text = "v2.settings.crosshair.cross.title", desc = "v2.settings.crosshair.cross.desc", convar = "cross", parentconvar = "cross_enable" },
        { type = "slider", text = "v2.settings.crosshair.cross_size_mult.title", desc = "v2.settings.crosshair.cross_size_mult.desc", convar = "cross_size_mult", parentconvar = "cross_enable", min = 0.01, max = 10, decimals = 2 },
        { type = "slider", text = "v2.settings.crosshair.cross_size_dot.title", desc = "v2.settings.crosshair.cross_size_dot.desc", convar = "cross_size_dot", parentconvar = "cross_enable", min = 0.01, max = 10, decimals = 2 },
        { type = "slider", text = "v2.settings.crosshair.cross_size_prong.title", desc = "v2.settings.crosshair.cross_size_prong.desc", convar = "cross_size_prong", parentconvar = "cross_enable", min = 0.01, max = 10, decimals = 2 },
		
		
        { type = "label", text = "v2.settings.tabname.aimassist", desc = "v2.settings.tabname.aimassist.desc" },
        { type = "bool", text = "v2.settings.aimassist.enable.title", desc = "v2.settings.aimassist.enable.desc", convar = "aimassist_cl", requireconvar = "aimassist" },
        { type = "slider", text = "v2.settings.gameplay.sensmult.title", desc = "v2.settings.aimassist.sensmult.desc", convar = "aimassist_multsens", parentconvar = "aimassist_cl", min = 0.1, max = 1, decimals = 2, requireconvar = "aimassist" },
	},
    {
        TabName = "v2.settings.tabname.customization",

        { type = "label", text = "v2.settings.tabname.custmenu", desc = "v2.settings.tabname.custmenu.desc" },
        { type = "color", text = "v2.settings.custmenu.hud_color.title", desc = "v2.settings.custmenu.hud_color.desc", convar = "hud_color" },
        { type = "bool", text = "v2.settings.custmenu.hud_darkmode.title", desc = "v2.settings.custmenu.hud_darkmode.desc", convar = "hud_darkmode" },
        { type = "bool", text = "v2.settings.custmenu.hud_holiday.title", desc = "v2.settings.custmenu.hud_holiday.desc", convar = "hud_holiday" },
        { type = "bool", text = "v2.settings.custmenu.cust_light.title", desc = "v2.settings.custmenu.cust_light.desc", convar = "cust_light" },
        { type = "slider", text = "v2.settings.custmenu.cust_light_brightness.title", desc = "v2.settings.custmenu.cust_light_brightness.desc", convar = "cust_light_brightness", min = -20, max = 30, decimals = 1, parentconvar = "cust_light" },
        { type = "bool", text = "v2.settings.custmenu.cust_hints.title", desc = "v2.settings.custmenu.cust_hints.desc", convar = "cust_hints" },
        { type = "bool", text = "v2.settings.custmenu.cust_tips.title", desc = "v2.settings.custmenu.cust_tips.desc", convar = "cust_tips", parentconvar = "cust_hints" },
        { type = "bool", text = "v2.settings.custmenu.cust_exit_reset_sel.title", desc = "v2.settings.custmenu.cust_exit_reset_sel.desc", convar = "cust_exit_reset_sel" },
        { type = "bool", text = "v2.settings.custmenu.autosave.title", desc = "v2.settings.custmenu.autosave.desc", convar = "autosave" },
        { type = "combo", text = "v2.settings.custmenu.units.title", desc = "v2.settings.custmenu.units.desc", convar = "imperial", content = {
            {"1" .. ARC9:GetPhrase("v2.settings.custmenu.units.metric"), "0" },
            {"2" .. ARC9:GetPhrase("v2.settings.custmenu.units.imperial"), "1" },
			},
		},
		{ type = "combo", text = "v2.settings.quick.lang.title", convar = "language", desc = "v2.settings.quick.lang.desc", content = ARC9.LanguagesTable, func = function(self2)
            RunConsoleCommand("arc9_reloadlangs")
        end},
	},
    {
        TabName = "v2.settings.tabname.server",
		sv = true,
        { type = "label", text = "v2.settings.tabname.hud_game" },
        { sv = true, type = "bool", text = "v2.settings.server.hud_game.hud_arc9.title", desc = "v2.settings.server.hud_game.hud_arc9.desc", convar = "hud_force_disable" },
        { type = "label", text = "v2.settings.tabname.visuals" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.truenames.title", desc = "v2.settings.server.gameplay.truenames.desc", convar = "truenames_default" },
        { type = "label", text = "v2.settings.tabname.gameplay" },
        { sv = true, type = "bool", text = "v2.settings.server.aimassist.enable.title", desc = "v2.settings.server.aimassist.enable.desc", convar = "aimassist" },
        { sv = true, type = "slider", text = "v2.settings.server.aimassist.intensity.title", desc = "v2.settings.server.aimassist.intensity.desc", convar = "aimassist_intensity", min = 0.1, max = 2, decimals = 1, parentconvar = "aimassist" },
        { sv = true, type = "slider", text = "v2.settings.server.aimassist.cone.title", desc = "v2.settings.server.aimassist.cone.desc", convar = "aimassist_cone", min = 1, max = 15, parentconvar = "aimassist" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.infinite_ammo.title", desc = "v2.settings.server.gameplay.infinite_ammo.desc", convar = "infinite_ammo" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.realrecoil.title", desc = "v2.settings.server.gameplay.realrecoil.desc", convar = "realrecoil" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.lean.title", desc = "v2.settings.server.gameplay.lean.desc", convar = "lean" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.mod_sway.title", desc = "v2.settings.server.gameplay.mod_sway.desc", convar = "mod_sway" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.mod_freeaim.title", desc = "v2.settings.server.gameplay.mod_freeaim.desc", convar = "mod_freeaim" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.mod_bodydamagecancel.title", desc = "v2.settings.server.gameplay.mod_bodydamagecancel.desc", convar = "mod_bodydamagecancel" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.breath_slowmo.title", desc = "v2.settings.server.gameplay.breath_slowmo.desc", convar = "breath_slowmo" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.manualbolt.title", desc = "v2.settings.server.gameplay.manualbolt.desc", convar = "manualbolt" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.never_ready.title", desc = "v2.settings.server.gameplay.never_ready.desc", convar = "never_ready" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.recoilshake.title", desc = "v2.settings.server.gameplay.recoilshake.desc", convar = "recoilshake" },
        { sv = true, type = "bool", text = "v2.settings.server.gameplay.equipment_generate_ammo.title", desc = "v2.settings.server.gameplay.equipment_generate_ammo.desc", convar = "equipment_generate_ammo" },
        { sv = true, type = "slider", text = "v2.settings.server.gameplay.mult_defaultammo.title", desc = "v2.settings.server.gameplay.mult_defaultammo.desc", convar = "mult_defaultammo", min = 0, max = 16 },
		
        { type = "label", text = "v2.settings.tabname.customization" },
        { sv = true, type = "bool", text = "v2.settings.server.custmenu.atts_nocustomize.title", desc = "v2.settings.server.custmenu.atts_nocustomize.desc", convar = "atts_nocustomize" },
        { sv = true, type = "slider", text = "v2.settings.server.custmenu.atts_max.title", desc = "v2.settings.server.custmenu.atts_max.desc", convar = "atts_max", min = 0, max = 250 },
        { sv = true, type = "bool", text = "v2.settings.server.custmenu.free_atts.title", desc = "v2.settings.server.custmenu.free_atts.desc", convar = "free_atts" },
        { sv = true, type = "bool", text = "v2.settings.server.custmenu.atts_lock.title", desc = "v2.settings.server.custmenu.atts_lock.desc", convar = "atts_lock" },
        { sv = true, type = "bool", text = "v2.settings.server.custmenu.atts_loseondie.title", desc = "v2.settings.server.custmenu.atts_loseondie.desc", convar = "atts_loseondie" },
        { sv = true, type = "bool", text = "v2.settings.server.custmenu.atts_generateentities.title", desc = "v2.settings.server.custmenu.atts_generateentities.desc", convar = "atts_generateentities" },
		
        { type = "label", text = "v2.settings.tabname.bulletphysics" },
        { sv = true, type = "bool", text = "v2.settings.server.bulletphysics.bullet_physics.title", desc = "v2.settings.server.bulletphysics.bullet_physics.desc", convar = "bullet_physics" },
        { sv = true, type = "slider", text = "v2.settings.server.bulletphysics.bullet_gravity.title", desc = "v2.settings.server.bulletphysics.bullet_gravity.desc", convar = "bullet_gravity", min = 0, max = 10, decimals = 1, parentconvar = "bullet_physics" },
        { sv = true, type = "slider", text = "v2.settings.server.bulletphysics.bullet_drag.title", desc = "v2.settings.server.bulletphysics.bullet_drag.desc", convar = "bullet_drag", min = 0, max = 10, decimals = 1, parentconvar = "bullet_physics" },
        { sv = true, type = "slider", text = "v2.settings.server.bulletphysics.bullet_lifetime.title", desc = "v2.settings.server.bulletphysics.bullet_lifetime.desc", convar = "bullet_lifetime", min = 0, max = 120, parentconvar = "bullet_physics" },
        { sv = true, type = "bool", text = "v2.settings.server.bulletphysics.ricochet.title", desc = "v2.settings.server.bulletphysics.ricochet.desc", convar = "ricochet" },
        { sv = true, type = "bool", text = "v2.settings.server.bulletphysics.mod_penetration.title", desc = "v2.settings.server.bulletphysics.mod_penetration.desc", convar = "mod_penetration" },
		
        { type = "label", text = "v2.settings.tabname.npc" },
        { sv = true, type = "bool", text = "v2.settings.server.npc.npc_autoreplace.title", desc = "v2.settings.server.npc.npc_autoreplace.desc", convar = "npc_autoreplace" },
        { sv = true, type = "bool", text = "v2.settings.server.npc.npc_atts.title", desc = "v2.settings.server.npc.npc_atts.desc", convar = "npc_atts", parentconvar = "npc_autoreplace" },
        { sv = true, type = "bool", text = "v2.settings.server.npc.replace_spawned.title", desc = "v2.settings.server.npc.replace_spawned.desc", convar = "replace_spawned" },
        { sv = true, type = "bool", text = "v2.settings.server.npc.ground_atts.title", desc = "v2.settings.server.npc.ground_atts.desc", convar = "ground_atts", parentconvar = "replace_spawned" },
        { sv = true, type = "bool", text = "v2.settings.server.npc.npc_give_weapons.title", desc = "v2.settings.server.npc.npc_give_weapons.desc", convar = "npc_give_weapons" },
        { sv = true, type = "bool", text = "v2.settings.server.npc.npc_equality.title", desc = "v2.settings.server.npc.npc_equality.desc", convar = "npc_equality" },
        { sv = true, type = "slider", text = "v2.settings.server.npc.npc_spread.title", desc = "v2.settings.server.npc.npc_spread.desc", convar = "npc_spread", min = 0, max = 10, decimals = 1 },
		
        { type = "label", text = "v2.settings.tabname.quickstat" },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_damage.title", desc = "v2.settings.server.quickstat.mod_damage.desc", convar = "mod_damage", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_spread.title", desc = "v2.settings.server.quickstat.mod_spread.desc", convar = "mod_spread", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_recoil.title", desc = "v2.settings.server.quickstat.mod_recoil.desc", convar = "mod_recoil", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_visualrecoil.title", desc = "v2.settings.server.quickstat.mod_visualrecoil.desc", convar = "mod_visualrecoil", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_adstime.title", desc = "v2.settings.server.quickstat.mod_adstime.desc", convar = "mod_adstime", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_sprinttime.title", desc = "v2.settings.server.quickstat.mod_sprinttime.desc", convar = "mod_sprinttime", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_damagerand.title", desc = "v2.settings.server.quickstat.mod_damagerand.desc", convar = "mod_damagerand", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_muzzlevelocity.title", desc = "v2.settings.server.quickstat.mod_muzzlevelocity.desc", convar = "mod_muzzlevelocity", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_rpm.title", desc = "v2.settings.server.quickstat.mod_rpm.desc", convar = "mod_rpm", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_headshotdamage.title", desc = "v2.settings.server.quickstat.mod_headshotdamage.desc", convar = "mod_headshotdamage", min = 0, max = 10, decimals = 1 },
        { sv = true, type = "slider", text = "v2.settings.server.quickstat.mod_malfunction.title", desc = "v2.settings.server.quickstat.mod_malfunction.desc", convar = "mod_malfunction", min = 0, max = 10, decimals = 1 },
	},
    {
        TabName = "v2.settings.tabname.developer",
		sv = true,
        { type = "label", text = "v2.settings.tabname.developer.settings", desc = "v2.settings.tabname.developer.settings.desc" },
        { sv = true, type = "button", text = "v2.settings.server.developer.reloadlangs.title", desc = "v2.settings.server.developer.reloadlangs.desc", content = "v2.settings.server.developer.reload", func = function(self2)
            RunConsoleCommand("arc9_reloadlangs")
        end},
        { sv = true, type = "button", text = "v2.settings.server.developer.reloadatts.title", desc = "v2.settings.server.developer.reloadatts.desc", content = "v2.settings.server.developer.reload", func = function(self2)
            RunConsoleCommand("arc9_reloadatts")
        end},
        { sv = true, type = "bool", text = "v2.settings.server.developer.dev_always_ready.title", desc = "v2.settings.server.developer.dev_always_ready.desc", convar = "dev_always_ready" },
        { sv = true, type = "bool", text = "v2.settings.server.developer.dev_benchgun.title", desc = "v2.settings.server.developer.dev_benchgun.desc", convar = "dev_benchgun" },
        { sv = true, type = "bool", text = "v2.settings.server.developer.dev_crosshair.title", desc = "v2.settings.server.developer.dev_crosshair.desc", convar = "dev_crosshair" },
        { sv = true, type = "bool", text = "v2.settings.server.developer.dev_show_affectors.title", desc = "v2.settings.server.developer.dev_show_affectors.desc", convar = "dev_show_affectors", parentconvar = "dev_crosshair" },
        { sv = true, type = "bool", text = "v2.settings.server.developer.dev_show_shield.title", desc = "v2.settings.server.developer.dev_show_shield.desc", convar = "dev_show_shield" },
        { sv = true, type = "bool", text = "v2.settings.server.developer.dev_greenscreen.title", desc = "v2.settings.server.developer.dev_greenscreen.desc", convar = "dev_greenscreen" },
        { sv = true, type = "button", text = "v2.settings.server.developer.presets_clear.title", desc = "v2.settings.server.developer.presets_clear.desc", content = "v2.settings.server.developer.clear", func = function(self2)
            RunConsoleCommand("arc9_presets_clear")
        end},
		
        { type = "label", text = "v2.settings.tabname.assetcache", desc = "v2.settings.tabname.assetcache.desc" },
        { sv = true, type = "bool", text = "v2.settings.server.assetcache.precache_sounds_onfirsttake.title", desc = "v2.settings.server.assetcache.precache_sounds_onfirsttake.desc", convar = "precache_sounds_onfirsttake" },
        { sv = true, type = "bool", text = "v2.settings.server.assetcache.precache_attsmodels_onfirsttake.title", desc = "v2.settings.server.assetcache.precache_attsmodels_onfirsttake.desc", convar = "precache_attsmodels_onfirsttake" },
        { sv = true, type = "bool", text = "v2.settings.server.assetcache.precache_wepmodels_onfirsttake.title", desc = "v2.settings.server.assetcache.precache_wepmodels_onfirsttake.desc", convar = "precache_wepmodels_onfirsttake" },
        { sv = true, type = "bool", text = "v2.settings.server.assetcache.precache_allsounds_onstartup.title", desc = "v2.settings.server.assetcache.precache_allsounds_onstartup.desc", convar = "precache_allsounds_onstartup" },
        { sv = true, type = "bool", text = "v2.settings.server.assetcache.precache_attsmodels_onstartup.title", desc = "v2.settings.server.assetcache.precache_attsmodels_onstartup.desc", convar = "precache_attsmodels_onstartup" },
        { sv = true, type = "bool", text = "v2.settings.server.assetcache.precache_wepmodels_onstartup.title", desc = "v2.settings.server.assetcache.precache_wepmodels_onstartup.desc", convar = "precache_wepmodels_onstartup" },
        { sv = true, type = "button", text = "v2.settings.server.assetcache.precache_allsounds.title", desc = "v2.settings.server.assetcache.precache_allsounds.desc", content = "v2.settings.server.assetcache.all", func = function(self2)
            RunConsoleCommand("arc9_precache_allsounds")
        end},
        { sv = true, type = "button", text = "v2.settings.server.assetcache.precache_attsmodels.title", desc = "v2.settings.server.assetcache.precache_attsmodels.desc", content = "v2.settings.server.assetcache.all", func = function(self2)
            RunConsoleCommand("arc9_precache_attsmodels")
        end},
        { sv = true, type = "button", text = "v2.settings.server.assetcache.precache_wepmodels.title", desc = "v2.settings.server.assetcache.precache_wepmodels.desc", content = "v2.settings.server.assetcache.all", func = function(self2)
            RunConsoleCommand("arc9_precache_wepmodels")
        end},
		
        { type = "label", text = "v2.settings.tabname.printconsole", desc = "v2.settings.tabname.printconsole.desc" },
        { sv = true, type = "button", text = "v2.settings.server.printconsole.dev_listmyatts.title", desc = "v2.settings.server.printconsole.dev_listmyatts.desc", content = "v2.settings.server.printconsole", func = function(self2)
            RunConsoleCommand("arc9_dev_listmyatts")
        end},
        { sv = true, type = "button", text = "v2.settings.server.printconsole.dev_listanims.title", desc = "v2.settings.server.printconsole.dev_listanims.desc", content = "v2.settings.server.printconsole", func = function(self2)
            RunConsoleCommand("arc9_dev_listanims")
        end},
        { sv = true, type = "button", text = "v2.settings.server.printconsole.dev_listbones.title", desc = "v2.settings.server.printconsole.dev_listbones.desc", content = "v2.settings.server.printconsole", func = function(self2)
            RunConsoleCommand("arc9_dev_listbones")
        end},
        { sv = true, type = "button", text = "v2.settings.server.printconsole.dev_listbgs.title", desc = "v2.settings.server.printconsole.dev_listbgs.desc", content = "v2.settings.server.printconsole", func = function(self2)
            RunConsoleCommand("arc9_dev_listbgs")
        end},
        { sv = true, type = "button", text = "v2.settings.server.printconsole.dev_listatts.title", desc = "v2.settings.server.printconsole.dev_listatts.desc", content = "v2.settings.server.printconsole", func = function(self2)
            RunConsoleCommand("arc9_dev_listatts")
        end},
        { sv = true, type = "button", text = "v2.settings.server.printconsole.dev_listmats.title", desc = "v2.settings.server.printconsole.dev_listmats.desc", content = "v2.settings.server.printconsole", func = function(self2)
            RunConsoleCommand("arc9_dev_listmats")
        end},
        { sv = true, type = "button", text = "v2.settings.server.printconsole.dev_export.title", desc = "v2.settings.server.printconsole.dev_export.desc", content = "v2.settings.server.printconsole", func = function(self2)
            RunConsoleCommand("arc9_dev_export")
        end},
        { sv = true, type = "button", text = "v2.settings.server.printconsole.dev_getjson.title", desc = "v2.settings.server.printconsole.dev_getjson.desc", content = "v2.settings.server.printconsole", func = function(self2)
            RunConsoleCommand("arc9_dev_getjson")
        end},
	},
}

local ARC9ScreenScale = ARC9.ScreenScale
-- local mat_icon = Material("arc9/arc9_logo_ui.png", "mips smooth")
local arc9logo_layer1 = Material("arc9/logo/logo_bottom.png", "mips smooth")
local arc9logo_layer2 = Material("arc9/logo/logo_middle.png", "mips smooth")
local mat_Notif = Material("arc9/ui/info.png", "mips")
local color_Notif = Color(255, 50, 50)

local function DrawSettings(bg, page)
    local cornercut = ARC9ScreenScale(3.5)

    local buttontalling = 0
    local activedesc = ""
    local activecvar = ""

    local sheet = vgui.Create("ARC9ColumnSheet", bg)
    sheet:Dock(FILL)
    sheet:DockMargin(0, 0, ARC9ScreenScale(100), ARC9ScreenScale(1.7))
    sheet.Navigation:DockMargin(-120, 0, 0, ARC9ScreenScale(5)) -- idk why -120
    sheet.Navigation:SetWidth(ARC9ScreenScale(100))

    for k, v in pairs(ARC9.SettingsTable) do
        local newpanel = vgui.Create("DPanel", sheet)
        newpanel:Dock(FILL)
        newpanel.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, ARC9.GetHUDColor("bg")) end
        local newpanelscroll = vgui.Create("ARC9ScrollPanel", newpanel)
        newpanelscroll:Dock(FILL)
        newpanelscroll:DockMargin(ARC9ScreenScale(4), ARC9ScreenScale(4), ARC9ScreenScale(4), 0)

        for k2, v2 in ipairs(v) do
            if v2.showfunc and !v2.showfunc() then continue end
            
            local elpanel = vgui.Create("DPanel", newpanelscroll)
            elpanel.realtall = ARC9ScreenScale(v2.type == "label" and 14 or 21) * ((v2.type == "label" or v2.type == "bool" ) and 0.85 or 1)
            elpanel:SetTall(elpanel.realtall)
            elpanel:DockMargin(0, (k2 != 1 and v2.type == "label") and ARC9ScreenScale(4) or 0, 0, 0)
            elpanel:Dock(TOP)

            local noperms = !game.SinglePlayer() and !LocalPlayer():IsListenServerHost() and !LocalPlayer():IsAdmin()
                    and v2.convar and ARC9.ConVarData["arc9_" .. v2.convar] and !ARC9.ConVarData["arc9_" .. v2.convar].client

            elpanel.Paint = function(self2, w, h)
                if v2.type == "label" and v2.text != "" then
                    surface.SetDrawColor(0, 0, 0, 75)
                    if v2.important then surface.SetDrawColor(233, 21, 21, 171) end
                    surface.DrawRect(0, 0, w, h)
                end

                local txt = ""
				local txt_desc = ARC9:GetPhrase(v2.desc) or v2.desc or ""

				if v2.sv then 
					-- txt = "[ SERVER ] "
					-- txt_desc = txt_desc .. ARC9:GetPhrase("v2.settings.server")
				end

                if v2.requireconvar then
                    local boolll = !GetConVar("arc9_" .. v2.requireconvar):GetBool()
					if v2.requireconvaroff then boolll = !boolll end

					if boolll then
						txt = txt .. ARC9:GetPhrase("v2.settings.disabled")
						txt_desc = ARC9:GetPhrase("v2.settings.disabled.desc") .. txt_desc
					end
                end

                if v2.requireconvaroff then
                    local boolll = GetConVar("arc9_" .. v2.requireconvaroff):GetBool()

					if boolll then
						txt = txt .. ARC9:GetPhrase("v2.settings.disabled")
						txt_desc = ARC9:GetPhrase("v2.settings.disabled.desc") .. txt_desc
					end
                end

                if v2.parentconvar then
                    local boolll = !GetConVar("arc9_" .. v2.parentconvar):GetBool()
                    if v2.parentinvert then boolll = !boolll end

                    if boolll then
                        self2:SetTall(1)
                        return
                    else
                        self2:SetTall(elpanel.realtall)
                    end

                    txt = "   › "
                end
				
				local convarperms = ( v2.requireconvar and !GetConVar("arc9_" .. v2.requireconvar):GetBool() ) or 
				( v2.requireconvaroff and GetConVar("arc9_" .. v2.requireconvaroff):GetBool() )
				
                -- desc!!!!!!!!

                if self2:IsHovered() and activedesc != (ARC9:GetPhrase(v2.desc) or v2.desc or "") then
                    activedesc = (txt_desc or "")
                    activecvar = v2.convar and ("arc9_" .. v2.convar) or ""
                    if bg.desc then bg.desc:Remove() end

                    local desc = vgui.Create("ARC9ScrollPanel", bg)
                    desc:SetPos(bg:GetWide() - ARC9ScreenScale(97.5), ARC9ScreenScale(35))
                    desc:SetSize(ARC9ScreenScale(93), bg:GetTall() - ARC9ScreenScale(40))
                    desc.Paint = function(self2, w, h)
                        -- surface.SetDrawColor(144, 0, 0, 100)
                        -- surface.DrawRect(0, 0, w, h)
                    end
                    bg.desc = desc

                    local descmultiline = ARC9MultiLineText(activedesc, desc:GetWide() - ARC9ScreenScale(1), "ARC9_8")
                    for i, text in ipairs(descmultiline) do
                        local desc_line = vgui.Create("DPanel", desc)
                        desc_line:SetSize(desc:GetWide(), ARC9ScreenScale(8))
                        desc_line:Dock(TOP)
                        desc_line.Paint = function(self2, w, h)
                            surface.SetFont("ARC9_8")
                            surface.SetTextColor(ARC9.GetHUDColor("fg"))
                            surface.SetTextPos(ARC9ScreenScale(2), 0)
                            surface.DrawText(text)
                        end
                    end
                end

                txt = txt .. ARC9:GetPhrase(v2.text) or ARC9:GetPhrase("settings" .. "." .. (v2.convar or "") .. ".title") or v2.text or ""

                surface.SetFont("ARC9_12_Slim")
                local tw, th = surface.GetTextSize(txt)
                if noperms or convarperms then
                    surface.SetTextColor(ARC9.GetHUDColor("unowned"))
                else
                    surface.SetTextColor(ARC9.GetHUDColor("fg"))
                end

                surface.SetTextPos(ARC9ScreenScale(4), h/2 - th/2)
                surface.DrawText(txt)
            end

            local elpw, elph = bg:GetWide() - ARC9ScreenScale(232), ARC9ScreenScale(21)

            if v2.type == "label" then
                -- woopsie
            elseif v2.type == "bool" then
                local newel = vgui.Create("ARC9Checkbox", elpanel)
                newel:SetPos(elpw+ARC9ScreenScale(5), ARC9ScreenScale(4))
                if v2.convar then newel:SetConVar("arc9_" .. v2.convar) end
                if noperms then newel:SetEnabled(false) end
            elseif v2.type == "slider" then
                local newel = vgui.Create("ARC9NumSlider", elpanel)
                newel:SetPos(ARC9ScreenScale(23), ARC9ScreenScale(6))
                newel:SetSize(elpw, 30)
                newel:SetDecimals(v2.decimals or 0)
                newel:SetMin(v2.min or 0)
                newel:SetMax(v2.max or 255)
                if v2.convar then newel:SetConVar("arc9_" .. v2.convar) end
                if v2.convar2 then newel:SetValue(GetConVar("arc9_" .. v2.convar2):GetFloat()) end
                if noperms then newel:SetEnabled(false) end

                local oldmousereleased = newel.Slider.OnMouseReleased
                newel.Slider.OnMouseReleased = function(self2, kc)
                    oldmousereleased(self2, kc)
                    if v2.func then v2.func(self2, newel, bg) end
                end
            elseif v2.type == "color" then
                local newel = vgui.Create("ARC9ColorButton", elpanel)
                newel:SetPos(elpw-ARC9ScreenScale(65), ARC9ScreenScale(6))

                local cvar = "arc9_" .. (v2.convar or "ya_dumbass")
                newel:CustomSetConvar(cvar)

                if GetConVar(cvar .. "_r") then
                    newel.rgbcolor = Color(GetConVar(cvar .. "_r"):GetInt() or 255, GetConVar(cvar .. "_g"):GetInt() or 0, GetConVar(cvar .. "_b"):GetInt() or 0)
                else
                    newel.rgbcolor = Color(255, 0, 0)
                    print("you are dumb, missing color convar")
                end

                if noperms then newel:SetEnabled(false) end
            elseif v2.type == "coloralpha" then
                local newel = vgui.Create("ARC9ColorButton", elpanel)
                newel:SetPos(elpw-ARC9ScreenScale(65), ARC9ScreenScale(6))
                newel:EnableAlpha()

                local cvar = "arc9_" .. (v2.convar or "ya_dumbass")
                newel:CustomSetConvar(cvar)

                if GetConVar(cvar .. "_a") then
                    newel.rgbcolor = Color(GetConVar(cvar .. "_r"):GetInt() or 255, GetConVar(cvar .. "_g"):GetInt() or 0, GetConVar(cvar .. "_b"):GetInt() or 0, GetConVar(cvar .. "_a"):GetInt() or 255)
                else
                    newel.rgbcolor = Color(255, 0, 0)
                    print("you are dumb, missing color convar (or its _alpha)")
                end

                if noperms then newel:SetEnabled(false) end
            elseif v2.type == "input" then
                local newel = vgui.Create("DTextEntry", elpanel)
                newel:SetPos(elpw-ARC9ScreenScale(65), ARC9ScreenScale(6))
                newel:SetText(v2.text)
            elseif v2.type == "combo" then
                local newel = vgui.Create("ARC9ComboBox", elpanel)
                newel:SetPos(elpw-ARC9ScreenScale(65), ARC9ScreenScale(6))
                newel:CustomSetConvar("arc9_" .. v2.convar)

                local cvdata = GetConVar("arc9_" .. v2.convar):GetString()

                for _, choice in pairs(v2.content) do
                    if tostring(choice[2]) == cvdata then
                        newel:AddChoice(choice[1], choice[2], true)
                    else
                        newel:AddChoice(choice[1], choice[2])
                    end
                end

                local oldCloseMenu = newel.CloseMenu
                newel.CloseMenu = function(self2)
                    oldCloseMenu(self2, kc)
                    if true and v2.func then v2.func(self2) end
                end

                if noperms then newel:SetEnabled(false) end
            elseif v2.type == "button" then
                local newel = vgui.Create("ARC9Button", elpanel)
                newel:SetPos(elpw-ARC9ScreenScale(65), ARC9ScreenScale(6))
                newel.text = ARC9:GetPhrase(v2.content)

                local oldmousepressed = newel.OnMousePressed
                newel.OnMousePressed = function(self2, kc)
                    oldmousepressed(self2, kc)
                    if kc == MOUSE_LEFT and v2.func then v2.func(self2) end
                end

                if noperms then newel:SetEnabled(false) end
            end
        end

        local thatsheet = sheet:AddSheet(v.TabName, newpanel)
        thatsheet.PageID = k

        thatsheet.Button:DockMargin(0, 0, ARC9ScreenScale(1.5), ARC9ScreenScale(1.7))
        thatsheet.Button:SetTall(ARC9ScreenScale(19))
        thatsheet.Button:SetText("")

        thatsheet.Button.Paint = function(self2, w, h)
            local mainbuttoncolor = ARC9.GetHUDColor("bg")
            local barbuttoncolor = ARC9.GetHUDColor("bg")
            local buttontextcolor = ARC9.GetHUDColor("fg")

            if sheet:GetActiveButton() == self2 then
                mainbuttoncolor = ARC9.GetHUDColor("hi")
                barbuttoncolor = ARC9.GetHUDColor("hi")
                buttontextcolor = ARC9.GetHUDColor("shadow")
            end

            if v.Warning and v.Warning() then
                barbuttoncolor = color_Notif
            end

            if self2:IsHovered() then
                barbuttoncolor = ARC9.GetHUDColor("hi")
            end

            surface.SetDrawColor(barbuttoncolor)
            surface.DrawRect(0, 0, ARC9ScreenScale(1.7), h)
            surface.SetDrawColor(mainbuttoncolor)
			
            surface.DrawRect(ARC9ScreenScale(3.4), 0, w-ARC9ScreenScale(3.4), h)

            surface.SetFont("ARC9_12")
            local tw = surface.GetTextSize(ARC9:GetPhrase(v.TabName) or v.TabName)

            surface.SetTextColor(buttontextcolor)
            surface.SetTextPos((w - tw) / 2 + ARC9ScreenScale(1.7), ARC9ScreenScale(3))
			
			if v.sv and noperms then
				surface.SetTextColor(ARC9.GetHUDColor("unowned"))
			end
			
            surface.DrawText(ARC9:GetPhrase(v.TabName) or v.TabName)

            if v.Warning and v.Warning() then
                surface.SetDrawColor(color_Notif)
                surface.SetMaterial(mat_Notif)
                surface.DrawTexturedRect(ARC9ScreenScale(8), h / 2 - h / 6, h / 3, h / 3)
            end

        end

        thatsheet.Button.DoClickOld = thatsheet.Button.DoClick
        thatsheet.Button.DoClick = function(self2)
			if v.sv and noperms then return end
            self2:DoClickOld()
            ARC9.SettingsActiveTab = k
        end

        buttontalling = buttontalling + ARC9ScreenScale(19+1.7)
    end

    bg.Paint = function(self2, w, h)
        draw.NoTexture()

        surface.SetDrawColor(ARC9.GetHUDColor("bg"))
        local talll = sheet.Navigation:GetTall() + ARC9ScreenScale(6.7)
        surface.DrawPoly({{x = cornercut, y = h}, {x = 0, y = h-cornercut}, {x = 0, y = h-math.max(ARC9ScreenScale(5), talll-buttontalling)}, {x = ARC9ScreenScale(98,4), y = h-math.max(ARC9ScreenScale(5), talll-buttontalling)}, {x = ARC9ScreenScale(98,4), y = h}}) -- left bottom panel
        surface.DrawPoly({{x = w-ARC9ScreenScale(98,4), y = h}, {x = w-ARC9ScreenScale(98,4), y = ARC9ScreenScale(25.7)}, {x = w, y = ARC9ScreenScale(25.7)}, {x = w, y = h-cornercut}, {x = w-cornercut, y = h}}) -- right panel
        surface.DrawPoly({{x = 0, y = ARC9ScreenScale(24)},{x = 0, y = cornercut},{x = cornercut, y = 0}, {x = w-cornercut, y = 0}, {x = w, y = cornercut}, {x = w, y = ARC9ScreenScale(24)}}) -- top panel

        surface.SetDrawColor(ARC9.GetHUDColor("hi"))
        surface.DrawPoly({{x = cornercut, y = h}, {x = 0, y = h-cornercut}, {x = cornercut, y = h-cornercut*.5}})
        surface.DrawPoly({{x = w, y = h-cornercut}, {x = w-cornercut, y = h}, {x = w-cornercut, y = h-cornercut*.5}})
        surface.DrawPoly({{x = cornercut, y = h-cornercut*.5}, {x = w-cornercut, y = h-cornercut*.5}, {x = w-cornercut, y = h}, {x = cornercut, y = h}, })


        -- surface.SetDrawColor(ARC9.GetHUDColor("fg"))
        -- surface.SetMaterial(mat_icon)
        -- surface.DrawTexturedRect(ARC9ScreenScale(4), ARC9ScreenScale(2), ARC9ScreenScale(20), ARC9ScreenScale(20))

        -- ARC9.DrawColoredARC9Logo(ARC9ScreenScale(4), ARC9ScreenScale(2), ARC9ScreenScale(20), ARC9.GetHUDColor("hi"))

        -- function ARC9.DrawColoredARC9Logo(x, y, s, col)
        do
            local x, y, s = ARC9ScreenScale(4), ARC9ScreenScale(2), ARC9ScreenScale(20)
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(arc9logo_layer1)
            surface.DrawTexturedRect(x, y, s, s)

            surface.SetDrawColor(ARC9.GetHUDColor("hi"))
            surface.SetMaterial(arc9logo_layer2)
            surface.DrawTexturedRect(x, y, s, s)
        end

        surface.SetFont("ARC9_8_Slim")
        surface.SetTextColor(ARC9.GetHUDColor("fg"))
        surface.SetTextPos(w-ARC9ScreenScale(96), ARC9ScreenScale(26))
        surface.DrawText(activedesc != "" and ARC9:GetPhrase("settings.desc") or "") -- no title if no desc

        if activecvar != "" then -- display the cvar at the bottom of the description page
            local freshcvar = ""
            local cvarrealm = nil

            if !GetConVar(activecvar) and GetConVar(activecvar .. "_r") then
                freshcvar = activecvar .. "_r/_g/_b" .. (GetConVar(activecvar .. "_a") and "/_a" or "")
            else
                freshcvar = activecvar .. " " .. (GetConVar(activecvar):GetString() or "")
            end

            if !GetConVar(activecvar) and GetConVar(activecvar .. "_r") then -- also display the default value of said cvar

                if GetConVar(activecvar .. "_a") then ifalpha = "," .. GetConVar(activecvar .. "_a"):GetDefault() else ifalpha = "" end -- check if an alpha convar also exists

                if string.len(ARC9:GetPhrase("settings.default_convar")) > 17 then -- if the string is over 17 characters long, then make it two value displays
                    defaultvalue = GetConVar(activecvar .. "_r"):GetDefault() .. "," .. GetConVar(activecvar .. "_g"):GetDefault() .. ","
                    defaultvalue2 = GetConVar(activecvar .. "_b"):GetDefault() .. ifalpha
                else -- otherwise, only use one
                    defaultvalue = GetConVar(activecvar .. "_r"):GetDefault() .. "," .. GetConVar(activecvar .. "_g"):GetDefault() .. "," .. GetConVar(activecvar .. "_b"):GetDefault() .. ifalpha
                    defaultvalue2 = ""
                end

                if !game.SinglePlayer() and !LocalPlayer():IsListenServerHost() then
                    if ARC9.ConVarData[activecvar .. "_r"].client then
                        cvarrealm = "settings.convar_client"
                    else
                        cvarrealm = "settings.convar_server"
                    end
                end
            else
                defaultvalue = GetConVar(activecvar):GetDefault()
                defaultvalue2 = ""

                if !game.SinglePlayer() and !LocalPlayer():IsListenServerHost() then
                    if ARC9.ConVarData[activecvar].client then
                        cvarrealm = "settings.convar_client"
                    else
                        cvarrealm = "settings.convar_server"
                    end
                end
            end

            local bump = cvarrealm and ARC9ScreenScale(37.5) or ARC9ScreenScale(30)
            surface.SetTextColor(ARC9.GetHUDColor("hint"))

            surface.SetTextColor(ARC9.GetHUDColor("fg"))
            surface.SetTextPos(w-ARC9ScreenScale(90), h-bump)
            surface.DrawText(freshcvar)
            bump = bump - ARC9ScreenScale(7.5)

            surface.SetTextColor(ARC9.GetHUDColor("hint"))
            if cvarrealm then
                surface.SetTextPos(w-ARC9ScreenScale(90), h-bump)
                surface.DrawText(ARC9:GetPhrase(cvarrealm))
                bump = bump - ARC9ScreenScale(7.5)
            end

            surface.SetTextPos(w-ARC9ScreenScale(90), h-bump)
            surface.DrawText(ARC9:GetPhrase("settings.default_convar") .. ": " .. defaultvalue)
            bump = bump - ARC9ScreenScale(7.5)

            surface.SetTextPos(w-ARC9ScreenScale(90), h-bump)
            surface.DrawText(defaultvalue2)
        end

        surface.SetFont("ARC9_16")
        surface.SetTextColor(ARC9.GetHUDColor("fg"))
        surface.SetTextPos(ARC9ScreenScale(30), ARC9ScreenScale(4))
        surface.DrawText(ARC9:GetPhrase("settings.title"))
    end

    if page then
        for k, v in pairs(sheet.Items) do
            if v.PageID == page then
                v.Button:DoClick()
            end
        end
    end
end

local hoversound = "arc9/newui/uimouse_hover.ogg"
local clicksound = "arc9/newui/uimouse_click_return.ogg"

local arc9_hud_darkmode = GetConVar("arc9_hud_darkmode")

function ARC9_OpenSettings(page)
    page = page or ARC9.SettingsActiveTab
    local bg = vgui.Create("DFrame")
    bg:SetPos(0, 0)
    bg:SetSize(ScrW(), ScrH())
    bg:SetTitle("")
    bg:SetDraggable(false)
    bg:ShowCloseButton(false)        -- set to false when done please!!
    bg:SetAlpha(0)
    bg:AlphaTo(255, 0.2, 0, nil)
    bg:SetBackgroundBlur(true)
    -- bg:MakePopup()

    bg.Paint = function(self2, w, h)
        if arc9_hud_darkmode:GetBool() then
            surface.SetDrawColor(58, 58, 58, 206)
        else
            surface.SetDrawColor(20, 20, 20, 224)
        end
        surface.DrawRect(0, 0, w, h)
    end

    local panel = vgui.Create("DFrame", bg)
    -- panel:SetSize(ARC9ScreenScale(330), ARC9ScreenScale(242))
    panel:SetSize(ScrH()*1.25, ScrH()*0.75)
    panel:MakePopup()
    panel:SetAlpha(0)
    panel:AlphaTo(255, 0.2, 0, nil)
    panel:Center()
    panel:SetTitle("")
    panel:DockPadding(0, ARC9ScreenScale(25.7), 0, 0)
    panel:ShowCloseButton(false)
    DrawSettings(panel, page)

    panel.OnRemove = function() bg:Remove() end


    -- do only if april fools
    local day = tonumber(os.date("%d"))
    local month = tonumber(os.date("%m"))

    if month == 4 and day == 1 then
        local m9k = vgui.Create("ARC9TopButton", panel)
        m9k:SetPos(panel:GetWide() - ARC9ScreenScale(21*4 + 11), ARC9ScreenScale(2))
        m9k:SetIcon(Material("arc9/ui/w9k.png", "mips smooth"))
        m9k.DoClick = function(self2)
            surface.PlaySound(clicksound)
            gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=128089118")
        end
    end

    local discord = vgui.Create("ARC9TopButton", panel)
    discord:SetPos(panel:GetWide() - ARC9ScreenScale(21*3 + 8), ARC9ScreenScale(2))
    discord:SetIcon(Material("arc9/ui/discord.png", "mips smooth"))
    discord.DoClick = function(self2)
        surface.PlaySound(clicksound)
        gui.OpenURL("https://discord.gg/wkafWps44a")
    end

    local steam = vgui.Create("ARC9TopButton", panel)
    steam:SetPos(panel:GetWide() - ARC9ScreenScale(21*2 + 5), ARC9ScreenScale(2))
    steam:SetIcon(Material("arc9/ui/steam.png", "mips smooth"))
    steam.DoClick = function(self2)
        surface.PlaySound(clicksound)
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2910505837")
    end

    local close = vgui.Create("ARC9TopButton", panel)
    close:SetPos(panel:GetWide() - ARC9ScreenScale(21+2), ARC9ScreenScale(2))
    close:SetIcon(Material("arc9/ui/close.png", "mips smooth"))
    close.DoClick = function(self2)
        surface.PlaySound(clicksound)
        -- print(ARC9.SettingsActiveTab)
        panel:AlphaTo(0, 0.1, 0, nil)
        bg:AlphaTo(0, 0.1, 0, function()
            bg:Remove()
            panel:Remove()
        end)
    end

    bg.OnMousePressed = function(self2, keycode)
        close.DoClick()
    end

    -- timer.Simple(33, function()
    --     bg:Remove()
    --     panel:Remove()
    -- end)
end

concommand.Add("arc9_settings_open", ARC9_OpenSettings)