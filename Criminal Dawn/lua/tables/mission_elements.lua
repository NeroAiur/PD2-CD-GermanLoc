local FileIdent = "MissionElements"
local script = managers.mission._scripts.default._elements
local level = managers.job:current_level_id() or "nil"
CrimDawn.Log(FileIdent, "Level ID: " .. level)

local TimerTweaks = { big = {},

  -- Mandatory meth cooking
  alex_1 = { reChance = "on_executed" }, -- Rats day 1
  rat = { reChance = "on_executed" }, -- Cook Off
  mex_cooking = { meth_taken = "on_executed", counter_below3 = "on_executed" }, -- Border Crystals

  -- Assorted timers
  red2 = { logic_link_018 = "on_executed", logic_link_020 = "on_executed" }, -- First World Bank (FWB)
  wwh = { ["120_seconds"] = "timer", placed_saw = "on_executed" }, -- Alaskan Deal
  brb = { ["30"] = "timer" }, -- Brooklyn Bank
  roberts = { logic_timer_operator_001 = "time", logic_timer_operator_002 = "time", logic_timer_operator_003 = "time" }, -- GO Bank
  pbr = { refuel_timer = "timer", bomb_timer = "timer" }, -- Beneath the Mountain
  mia_1 = { hatch_timer_2min = "timer", hatch_timer_3min = "timer",
            ["90s"] = "time", ["120"] = "time", ["180"] = "time" }, -- Hotline Miami day 1
  born = { start = "time" }, -- Biker Heist day 1
  pal = { valve_timer = "timer" }, -- Counterfeit
  rvd2 = { start_wait_for_LN = "on_executed", seq_start_friendly_heli_fly_in = "on_executed" }, -- Reservoir Dogs diamond store
  peta2 = { ["2min"] = "on_executed", ["1min"] = "on_executed", ["30s"] = "on_executed" }, -- Goat Sim day 2
  shoutout_raid = { tick = "on_executed" }, -- Meltdown
  jewelry_store = { policeAreHereRemoveNoAlarmEscape = "on_executed" }, -- Jewelry Store
  run = { func_sequence_034 = "on_executed", func_sequence_033 = "on_executed",
          func_sequence_032 = "on_executed", func_sequence_031 = "on_executed", }, -- Heat Street
  mallcrasher = { delay = "on_executed" }, -- Mallcrasher
  spa = { picklock_timer = "timer", after_20sec = "time", after_30sec = "time", after_40sec = "time" }, -- Brooklyn 10-10
  mad = { set_EMP_timer_001 = "time", scan_timer = "timer" }, -- Boiling Point
  bph = { control_room_timer = "timer" }, -- Hell's Island
  moon = { wait_start = "on_executed", bile_there_in_1_min = "on_executed", bile_30s = "on_executed" }, -- Stealing Xmas
  pex = { hacking_timer = "timer", timer = "timer", delay = "base_delay" }, -- Breakfast in Tijuana
  vit = { objective_started026 = "on_executed", delay_thermite = "on_executed" }, -- White House
  pbr2 = { flyinfwd_show = "on_executed" }, -- Birth of Sky
  sah = { set_timer = "time" }, -- Shacklethorne Auction
  hvh = { timer_add_time = "time" }, -- Cursed Kill Room
  deep = { trigger_pressure_obj = "time" }, -- Crude Awakening
  election_day_3 = { backup_started_link = "on_executed", ["50"] = "on_executed", ["40"] = "on_executed", ["30"] = "on_executed" },
  kenaz = { ["set time 6"] = "time", ["set time 5"] = "time", ["drilling time"] = "timer", ["set time 3"] = "time" }, -- Golden Grin
  hox_2 = { time001 = "on_executed", time002 = "on_executed", time003 = "on_executed", time004 = "on_executed" }, -- Hoxton Breakout day 2
  jolly = { ["Link - delay"] = "on_executed", plt_as1_01 = "on_executed", plt_as1_02 = "on_executed", plt_as1_04 = "on_executed" }, -- Aftershock
  nmh = { success = "on_executed", interacted_with_correct_sample = "on_executed", fail = "on_executed", seq_fail = "on_executed" }, -- No Mercy
  chca = { pulling_timer = "timer" }, -- Black Cat

  -- The Diamond
  mus = { timelock = "timer", logic_timer_operator_001 = "time", time001 = "on_executed", time002 = "on_executed",
          time003 = "on_executed", time004 = "on_executed", time005 = "on_executed", time006 = "on_executed",
          time007 = "on_executed", ["130"] = "on_executed", ["120"] = "on_executed", ["110"] = "on_executed",
          ["80"] = "on_executed", ["70"] = "on_executed", ["60"] = "on_executed", ["50"] = "on_executed", ["30"] = "on_executed",
          ["25"] = "on_executed", ["20"] = "on_executed", ["10"] = "on_executed" },

  -- Big Oil day 2
  welcome_to_the_jungle_2 = { noGas = "on_executed", needsToFuel = "on_executed", isFueling = "on_executed", doneRefuel = "on_executed",
                              ["240"] = "on_executed", ["210"] = "on_executed", ["180"] = "on_executed", ["150"] = "on_executed",
                              ["120"] = "on_executed", ["90"] = "on_executed", ["60"] = "on_executed", ["30s"] = "on_executed",
                              time = "on_executed", logic_link_003 = "on_executed", logic_link_009 = "on_executed",
                              logic_link_010 = "on_executed", logic_link_011 = "on_executed" },

  -- Four Stores
  four_stores = { ["3m20s"] = "on_executed", ["3m"] = "on_executed", ["2m40s"] = "on_executed", ["2m10s"] = "on_executed",
                  ["2m"] = "on_executed", ["1m50s"] = "on_executed", ["1m40s"] = "on_executed", ["1m30s"] = "on_executed",
                  ["1m20s"] = "on_executed", ["1m10s"] = "on_executed", ["1m"] = "on_executed", ["50s"] = "on_executed",
                  ["40s"] = "on_executed", ["30s"] = "on_executed", ["20s"] = "on_executed" },

  -- Bomb: Forest
  crojob3 = { ["filling time"] = "timer", time_122 = "on_executed", time_62 = "on_executed", ["90s"] = "on_executed", ["45s"] = "on_executed",
              water_filling_timer_SET_01 = "time", water_filling_timer_SET_02 = "time", all_flares_fired = "on_executed", call_heli = "on_executed" },
  crojob3_night = crojob3,

  -- Armoured Transport
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

  -- Escapes
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

for i = 1, 18 do -- Big Bank
  if i < 10 then i = "0" .. i end
  TimerTweaks.big["ignite_0" .. i] = "base_delay"
end

if CrimDawn.OnFinalHeist() then TimerTweaks = {} end
local TimerMult = math.min(Global.CrimDawn.data.game.progression_items * 2, 99)
TimerMult = 1 - (TimerMult / 100)

-- Modify element timers
local Values = { time = true, base_delay = true }
if TimerTweaks[level] then
  for ElementName, ElementValue in pairs(TimerTweaks[level]) do
    for BaseElementName, BaseElement in pairs(script) do
      if BaseElement._editor_name == ElementName and BaseElement._values[ElementValue] then
        CrimDawn.Log(FileIdent, "Found mission element " .. ElementName)
        --Utils.PrintTable(BaseElement, 2)

        if Values[ElementValue] and BaseElement._values[ElementValue] then
          BaseElement._values[ElementValue] = BaseElement._values[ElementValue] * TimerMult
          --Utils.PrintTable(BaseElement._values, 1)

        elseif ElementValue == "on_executed" then
          for _, ExecutedElement in ipairs(BaseElement._values.on_executed) do
            ExecutedElement.delay = ExecutedElement.delay * TimerMult
          end break

        elseif ElementValue == "timer" and BaseElement._timer then
          BaseElement._values.timer = BaseElement._values.timer * TimerMult
          BaseElement._timer = BaseElement._timer * TimerMult
        end

      end
    end
  end
end