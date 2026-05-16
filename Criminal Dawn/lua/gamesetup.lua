local FileIdent = "GameSetup"

Hooks:PostHook(GameSetup, "init_finalize", "CrimDawn_GameSetupInit", function()
  local loc, script = managers.localization, managers.mission._scripts.default._elements
  local level = managers.job:current_level_id()
  CrimDawn.Log(FileIdent, "Level ID: " .. level)

  local ponrElement = {
    id = "crimdawn_ponr",
    class = "ElementPointOfNoReturn",
    values = { elements = {} }
  }

  script.crimdawn_ponr = ElementPointOfNoReturn:new(managers.mission, ponrElement)

  -- Heist specific timer elements we want to modify
  local TimerTweaks = { big = {},
  
    -- Mandatory meth cooking
    alex_1 = { reChance = "on_executed" },
    rat = { reChance = "on_executed" },
    mex_cooking = { meth_taken = "on_executed", counter_below3 = "on_executed" },

    -- Assorted timers
    red2 = { logic_link_018 = "on_executed", logic_link_020 = "on_executed" }, -- FWB thermite
    wwh = { ["120_seconds"] = "timer" }, -- Alaskan Deal fuel
    brb = { ["30"] = "timer" }, -- Brooklyn Bank circle cutter
    roberts = { logic_timer_operator_001 = "time", logic_timer_operator_002 = "time", logic_timer_operator_003 = "time" },
    pbr = { refuel_timer = "timer", bomb_timer = "timer" },
    mia_1 = { hatch_timer_2min = "timer", hatch_timer_3min = "timer",
              ["90s"] = "time", ["120"] = "time", ["180"] = "time" },
    born = { start = "time" },
    pal = { valve_timer = "timer" },
    rvd2 = { start_wait_for_LN = "on_executed", seq_start_friendly_heli_fly_in = "on_executed" },
    peta2 = { ["2min"] = "on_executed", ["1min"] = "on_executed", ["30s"] = "on_executed" },
    shoutout_raid = { tick = "on_executed" },
    jewelry_store = { policeAreHereRemoveNoAlarmEscape = "on_executed" },
    run = { func_sequence_034 = "on_executed", func_sequence_033 = "on_executed",
            func_sequence_032 = "on_executed", func_sequence_031 = "on_executed", },
    mallcrasher = { delay = "on_executed" },
    spa = { picklock_timer = "timer", after_20sec = "time", after_30sec = "time", after_40sec = "time" },
    mad = { set_EMP_timer_001 = "time", scan_timer = "timer" },
    bph = { control_room_timer = "timer" },
    moon = { wait_start = "on_executed", bile_there_in_1_min = "on_executed", bile_30s = "on_executed" },
    pex = { hacking_timer = "timer" },
    welcome_to_the_jungle_2 = { noGas = "on_executed", needsToFuel = "on_executed", isFueling = "on_executed", doneRefuel = "on_executed",
                                ["240"] = "on_executed", ["210"] = "on_executed", ["180"] = "on_executed", ["150"] = "on_executed",
                                ["120"] = "on_executed", ["90"] = "on_executed", ["60"] = "on_executed" },

    arm_hcm = { logic_link_021 = "on_executed", logic_link_022 = "on_executed",
                logic_link_023 = "on_executed", logic_link_024 = "on_executed" },
    arm_und = { logic_link_016 = "on_executed", logic_link_017 = "on_executed",
                logic_link_018 = "on_executed", logic_link_022 = "on_executed" },
    arm_par = { logic_link_035 = "on_executed", logic_link_036 = "on_executed",
                logic_link_037 = "on_executed", logic_link_038 = "on_executed" },
    arm_fac = { logic_link_005 = "on_executed", logic_link_006 = "on_executed",
                logic_link_007 = "on_executed", logic_link_008 = "on_executed" },
    arm_cro = { logic_link_005 = "on_executed", logic_link_006 = "on_executed",
                logic_link_007 = "on_executed", logic_link_008 = "on_executed" },

    escape_park_day = { ["3min"] = "on_executed", ["4min"] = "on_executed", ["5min"] = "on_executed",
                        ["4minues_remaining"] = "on_executed", ["3minutes_remaining"] = "on_executed",
                        ["2minutes_remaining"] = "on_executed", ["almost_there_1minute"] = "on_executed",
                        ["30sec_left"] = "on_executed", ["almost_there_30seconds_2"] = "on_executed" },

    escape_park = { ["3min"] = "on_executed", ["4min"] = "on_executed", ["5min"] = "on_executed",
                    ["4minues_remaining"] = "on_executed", ["3minutes_remaining"] = "on_executed",
                    ["2minutes_remaining"] = "on_executed", ["almost_there_1minute"] = "on_executed",
                    ["30sec_left"] = "on_executed", ["almost_there_30seconds_2"] = "on_executed" },

    escape_cafe_day = { ["3min"] = "on_executed", ["2min"] = "on_executed", ["2min_left"] = "on_executed",
                        ["1min_left"] = "on_executed", ["30sec_left"] = "on_executed" },

    escape_cafe = { ["3min"] = "on_executed", ["2min"] = "on_executed", ["2min_left"] = "on_executed",
                    ["1min_left"] = "on_executed", ["30sec_left"] = "on_executed" },

    escape_street = { ["2"] = "on_executed", ["1.5"] = "on_executed", ["1min_left"] = "on_executed",
                      ["30secs_left"] = "on_executed", ["10secs_left"] = "on_executed" },

    escape_overpass = { ["4min"] = "on_executed", ["3min"] = "on_executed", ["3min_left"] = "on_executed",
                        ["2min_left"] = "on_executed", ["1min_left"] = "on_executed", ["30sec"] = "on_executed" },

    escape_overpass_night = { ["4min"] = "on_executed", ["3min"] = "on_executed", ["3min_left"] = "on_executed",
                              ["2min_left"] = "on_executed", ["1min_left"] = "on_executed", ["30sec"] = "on_executed" },
  }

  --for i = 1, 18 do
  --  if i < 10 then i = "0" .. i end
  --  TimerTweaks.big["ignite_0" .. i] = "base_delay"
  --end

  local TimerMult = math.min(Global.CrimDawn.data.game.progression_items * 2, 99)
  TimerMult = 1 - (TimerMult / 100)

  -- Modify element timers
  if TimerTweaks[level] then
    for ElementName, ElementValue in pairs(TimerTweaks[level]) do
      for BaseElementName, BaseElement in pairs(script) do
        if BaseElement._editor_name == ElementName and BaseElement._values[ElementValue] then
          CrimDawn.Log(FileIdent, "Found mission element " .. ElementName)
          --Utils.PrintTable(BaseElement, 2)

          if ElementValue ~= "on_executed" then
            BaseElement._values[ElementValue] = BaseElement._values[ElementValue] * TimerMult
            --Utils.PrintTable(BaseElement._values, 1)

          else for _, ExecutedElement in ipairs(BaseElement._values.on_executed) do
            ExecutedElement.delay = ExecutedElement.delay * TimerMult
          end break end

        end
      end
    end
  end

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

  dofile(CrimDawn.ModPath .. "lua/score_handler.lua")
  dofile(CrimDawn.ModPath .. "lua/managers/criminals.lua")
end)