local FileIdent = "Gameover"

Hooks:PostHook(GameOverState, "at_enter", "CrimDawn_HeistFailed", function(self)
  if CrimDawn.SettingsData.deathlink > 0 then
    local TimeRemaining
    if level_id ~= "hvh" then
      local MaskupDuration = TimerManager:game():time() - CrimDawn.state.maskup_time
      TimeRemaining = Global.CrimDawn.data.game.ponr - MaskupDuration
    else TimeRemaining = managers.groupai:state():get_point_of_no_return_timer() end

    if TimeRemaining > 0.1 then
      Global.CrimDawn.data.game.deathlink_in = os.time() + 15
      if NetworkHelper:IsHost() then Global.CrimDawn.data.game.deathlink_out = os.time() end
    end
  end

  CrimDawn:RunReset(FileIdent)
end)