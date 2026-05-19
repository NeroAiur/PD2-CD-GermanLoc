local FileIdent = "GameSetup"

Hooks:PostHook(GameSetup, "init_finalize", "CrimDawn_GameSetupInit", function()
  local loc, script = managers.localization, managers.mission._scripts.default._elements

  local ponrElement = {
    id = "crimdawn_ponr",
    class = "ElementPointOfNoReturn",
    values = { elements = {} }
  }

  script.crimdawn_ponr = ElementPointOfNoReturn:new(managers.mission, ponrElement)

  -- Heist specific timer elements we want to modify
  dofile(CrimDawn.ModPath .. "lua/tables/mission_elements.lua")

  -- Setup PONR
  math.randomseed(os.time() + (os.clock() * 1000))
  if math.random() > 0.1 then
    loc:add_localized_strings({
      ["hud_crimdawn_no_return"] = loc:text("crimdawn_ponr_default")
    })

  else --assert(not Global.CrimDawn.DLC, "nil returned true")
    loc:add_localized_strings({
      ["hud_crimdawn_no_return"] = loc:text("crimdawn_ponr_rare" .. math.random(1,100))
    })
  end

  tweak_data.point_of_no_returns.crimdawn_ponr_tweak = deep_clone(tweak_data.point_of_no_returns.noreturn)
  tweak_data.point_of_no_returns.crimdawn_ponr_tweak.text_id = "hud_crimdawn_no_return"

  -- Finalisation
  dofile(CrimDawn.ModPath .. "lua/score_handler.lua")
  dofile(CrimDawn.ModPath .. "lua/managers/criminals.lua")
end)