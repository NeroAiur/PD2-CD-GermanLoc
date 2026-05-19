TimerGui.upgrade_colors = {
  upgrade_color_0 = tweak_data.screen_colors.item_stage_3,
	upgrade_color_1 = Global.CrimDawn.archicolours.green_alt,
	upgrade_color_2 = Global.CrimDawn.archicolours.blue_alt,
	upgrade_color_3 = Global.CrimDawn.archicolours.pink_alt,
	upgrade_color_4 = Global.CrimDawn.archicolours.yellow_alt,
	upgrade_color_5 = Global.CrimDawn.archicolours.orange_alt,
	upgrade_color_6 = Global.CrimDawn.archicolours.red_alt
}

local DrillLevel = CrimDawn.DiffScale(true, 6)
Hooks:PostHook(TimerGui, "init", "CrimDawn_InitTimerGUI", function(self, timer)
  self._jam_times = 3 - math.max(math.floor(DrillLevel / 2), 0)
end)

Hooks:PreHook(TimerGui, "_start", "CrimDawn_StartTimerGUI", function(self, timer)
  if CrimDawn.OnFinalHeist() then return end
  local TimerMult = math.min(Global.CrimDawn.data.game.progression_items * 2, 99)
  TimerMult = 1 - (TimerMult / 100)
  self:set_timer_multiplier(TimerMult)
end)