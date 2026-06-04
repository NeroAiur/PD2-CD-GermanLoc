local FileIdent = "MissionElements"
local script = managers.mission._scripts.default._elements
local level = managers.job:current_level_id() or "nil"
--CrimDawn.Log(FileIdent, "Level ID: " .. level)

local TimerTweaks = { big = { start_timer = "time", set_time_normal = "time", set_time_reduced = "time" },

  -- Mandatory meth cooking
  -- Rats day 1
  alex_1 = { reChance = "on_executed", escapeWait = "on_executed", ["2min"] = "on_executed", ["1min"] = "on_executed" },

  -- Cook Off
  rat = { reChance = "on_executed", escapeWait = "on_executed", ["4min"] = "on_executed", ["3min"] = "on_executed",
          ["2min"] = "on_executed", ["1min"] = "on_executed", ["30s"] = "on_executed"},

  mex_cooking = { meth_taken = "on_executed", counter_below3 = "on_executed" }, -- Border Crystals

  -- Assorted timers
  red2 = { logic_link_018 = "on_executed", logic_link_020 = "on_executed" }, -- First World Bank
  wwh = { ["120_seconds"] = "timer", placed_saw = "on_executed" }, -- Alaskan Deal
  brb = { ["30"] = "timer", ["Train A"] = "on_executed", ["Train B"] = "on_executed" }, -- Brooklyn Bank
  pbr = { refuel_timer = "timer", bomb_timer = "timer" }, -- Beneath the Mountain
  born = { start = "time", time_to_assemble = "timer" }, -- Biker Heist day 1
  pal = { valve_timer = "timer" }, -- Counterfeit
  rvd2 = { start_wait_for_LN = "on_executed", seq_start_friendly_heli_fly_in = "on_executed" }, -- Reservoir Dogs diamond store
  peta2 = { ["2min"] = "on_executed", ["1min"] = "on_executed", ["30s"] = "on_executed" }, -- Goat Sim day 2
  shoutout_raid = { tick = "on_executed" }, -- Meltdown
  jewelry_store = { policeAreHereRemoveNoAlarmEscape = "on_executed" }, -- Jewelry Store
  ukrainian_job = jewelry_store,
  mallcrasher = { delay = "on_executed" }, -- Mallcrasher
  spa = { picklock_timer = "timer", after_20sec = "time", after_30sec = "time", after_40sec = "time" }, -- Brooklyn 10-10
  mad = { set_EMP_timer_001 = "time", scan_timer = "timer" }, -- Boiling Point
  bph = { control_room_timer = "timer" }, -- Hell's Island
  moon = { wait_start = "on_executed", bile_there_in_1_min = "on_executed", bile_30s = "on_executed" }, -- Stealing Xmas
  pex = { hacking_timer = "timer", timer = "timer", delay = "base_delay" }, -- Breakfast in Tijuana
  vit = { objective_started026 = "on_executed", delay_thermite = "on_executed" }, -- White House
  pbr2 = { flyinfwd_show = "on_executed", waiting_time = "timer" }, -- Birth of Sky
  sah = { set_timer = "time", enable_west_helicopter_input = "on_executed", enable_east_helicopter_input = "on_executed" }, -- Shacklethorne Auction
  deep = { logic_timer_oil_loud = "timer", logic_timer_oil_stealth = "timer" }, -- Crude Awakening
  kenaz = { ["set time 6"] = "time", ["set time 5"] = "time", ["drilling time"] = "timer", ["set time 3"] = "time" }, -- Golden Grin
  hox_2 = { time001 = "on_executed", time002 = "on_executed", time003 = "on_executed", time004 = "on_executed" }, -- Hoxton Breakout day 2
  jolly = { ["Link - delay"] = "on_executed", plt_as1_01 = "on_executed", plt_as1_02 = "on_executed", plt_as1_04 = "on_executed" }, -- Aftershock
  chca = { pulling_timer = "timer" }, -- Black Cat
  glace = { set_plane_time_after_miss = "time", plane_timer = "timer" }, -- Green Bridge
  ranc = { logic_timer_30s = "timer", logic_timer_60s = "timer" }, -- Midland Ranch
  cane = { timer = "timer", delay = "base_delay" }, -- Santa's Workshop
  arena = { timer = "timer" }, -- Alesso
  dah = { obj_started_011 = "on_executed", throw_out_cfo = "on_executed" }, -- Diamond Heist
  hox_3 = { open_timelock_timer = "timer" }, -- Hoxton Revenge
  tag = { normal = "on_executed", h_vhard = "on_executed", ovk = "on_executed", ew_dw = "on_executed", sm = "on_executed" }, -- Breakin' Feds

  -- Watchdogs day 1
  watchdogs_1 = { pilot_001 = "on_executed", ["2minuteswait"] = "on_executed", ["1minute"] = "on_executed",
                  ["30seconds"] = "on_executed", func_sequence_034 = "on_executed", escapeFlyIn = "on_executed",
                  logic_counter_002 = "on_executed", justBeforeCarComesIn = "on_executed",
                  logic_link_050 = "on_executed", logic_link_051 = "on_executed", logic_link_052 = "on_executed" },
  watchdogs_1_night = watchdogs_1,

  watchdogs_2 = { ["150"] = "on_executed", ["120"] = "on_executed", ["60"] = "on_executed", ["30"] = "on_executed" },
  watchdogs_2_day = watchdogs_2,

  -- Scarface Mansion
  friend = { show_and_fly_in = "on_executed", to_car001 = "on_executed", to_car002 = "on_executed", to_car003 = "on_executed",
             to_car004 = "on_executed", to_car005 = "on_executed", logic_link_013 = "on_executed",
             show_go_to_wp006 = "on_executed", show_go_to_wp007 = "on_executed", show_go_to_wp008 = "on_executed",
             show_go_to_wp009 = "on_executed", show_go_to_wp010 = "on_executed", bain_thinking = "on_executed",
             func_instance_output_event_003 = "on_executed", paintings_destroyed = "on_executed",
             bain_contacting_bile = "on_executed", bile_responding = "on_executed", pick_up_cadillac001 = "on_executed",
             pick_up_cadillac002 = "on_executed", pick_up_cadillac003 = "on_executed", pick_up_cadillac004 = "on_executed",
             pick_up_cadillac005 = "on_executed", safe_timer = "timer" },

  -- White Xmas
  pines = { once_flare_01_is_lit = "on_executed", ["50-60_delay"] = "on_executed", ["40_delay"] = "on_executed",
            ["60_delay"] = "on_executed", heli_pilot01_arrives = "on_executed", heli_pilot02_arrives = "on_executed", 
            heli_pilot03_arrives = "on_executed", heli_pilot04_arrives = "on_executed", ["40_delay_001"] = "on_executed",
            ["60_delay_001"] = "on_executed", heli_loot_01_arrives = "on_executed", heli_loot_02_arrives = "on_executed",
            heli_loot_03_arrives = "on_executed", heli_loot_04_arrives = "on_executed", ["30_sec_delay"] = "on_executed",
            heli_flies_in = "on_executed", heli_lands = "on_executed" },

  -- Nightclub
  nightclub = { driver_vo_hello = "on_executed", driver_vo_hello001 = "on_executed", driver_vo_hello002 = "on_executed",
                driver_vo_hello003 = "on_executed", driver_vo_hello004 = "on_executed", driver_vo_4m = "on_executed",
                driver_vo_hello005 = "on_executed", driver_vo_3m = "on_executed", driver_vo_2m = "on_executed",
                driver_vo_1m = "on_executed", driver_vo_30s = "on_executed" },

  -- GO Bank
  roberts = { logic_timer_operator_001 = "time", logic_timer_operator_002 = "time", logic_timer_operator_003 = "time",
              plane_called = "on_executed", logic_link_001 = "on_executed", logic_link_002 = "on_executed",
              logic_link_003 = "on_executed", logic_link_004 = "on_executed" },

  -- Diamond Store
  family = { pick_new_drive_in = "on_executed", logic_link_005 = "on_executed", logic_link_006 = "on_executed",
             logic_link_007 = "on_executed", logic_link_008 = "on_executed" },

  -- Election Day (Breaking Ballot)
  election_day_3 = { backup_started_link = "on_executed", ["50"] = "on_executed", ["40"] = "on_executed", ["30"] = "on_executed" },
  election_day_3_skip1 = election_day_3,
  election_day_3_skip2 = election_day_3,

  -- Hotline Miami day 1
  mia_1 = { hatch_timer_2min = "timer", hatch_timer_3min = "timer", ["90s"] = "time", ["120"] = "time", ["180"] = "time",
            Bile_3minutes = "on_executed", Bile_2minutes = "on_executed", Bile_1minutes = "on_executed",
            Bile_30s_left = "on_executed", bring_in_the_heliflopper = "on_executed", heli_bile_flyin001 = "on_executed",
            heli_bile_flyin002 = "on_executed", heli_bile_flyin003 = "on_executed" },

  -- Heat Street
  run = { func_sequence_034 = "on_executed", func_sequence_033 = "on_executed",
          func_sequence_032 = "on_executed", func_sequence_031 = "on_executed" },

  -- No Mercy
  nmh = { success = "on_executed", interacted_with_correct_sample = "on_executed", fail = "on_executed",
          seq_fail = "on_executed", relay = "on_executed" },

  -- Panic Room
  flat = { sniper_spawn_loop = "on_executed", heli_loop_restart = "on_executed",
           started = "on_executed", ["helicopter drops bag"] = "on_executed" },

  -- Bomb: Dockyard
  crojob2 = { hacking_TIMER_SET_150 = "time", hacking_TIMER_SET_300 = "time", delay_start_chopper = "on_executed",
              chopper_normal_TIMER = "on_executed", chopper_better_pilot_TIMER = "on_executed" },

  -- Cursed Kill Room
  hvh = { timer_add_time = "time", ["60"] = "on_executed", ["50"] = "on_executed", ["40"] = "on_executed",
          ["30"] = "on_executed", ["20"] = "on_executed", ["10"] = "on_executed" }, 

  -- Undercover
  man = { intro_anyways_30s = "on_executed", intro_anyways_40s = "on_executed", intro_anyways_50s = "on_executed",
          intro_anyways_60s = "on_executed", intro_anyways_70s = "on_executed" },

  -- Henry's Rock
  des = { crane_timer = "timer", correct001 = "on_executed", correct002 = "on_executed", correct003 = "on_executed", correct004 = "on_executed",
          wrong001 = "on_executed", wrong002 = "on_executed", wrong003 = "on_executed", wrong004 = "on_executed", shutdown = "on_executed",
          true001 = "on_executed", true002 = "on_executed", true003 = "on_executed", true004 = "on_executed",
          objective_started_035 = "on_executed", helicopter_flyin = "on_executed", helicopter_land = "on_executed" },

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

  -- Prison Nightmare
  help = { ["60"] = "on_executed", ["55"] = "on_executed", ["50"] = "on_executed", ["45"] = "on_executed",
           ["40"] = "on_executed", ["35"] = "on_executed", ["30"] = "on_executed", ["25"] = "on_executed",
           ["20"] = "on_executed", ["15"] = "on_executed", ["10"] = "on_executed", ["5"] = "on_executed" },

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

for i = 1, 18 do -- Big Bank thermite
  if i < 10 then i = "0" .. i end
  TimerTweaks.big["ignite_0" .. i] = "base_delay"
end

if CrimDawn.OnFinalHeist() then TimerTweaks = {} end
local TimerMult = math.min(Global.CrimDawn.data.game.progression_items * 2, 99)
TimerMult = 1 - (TimerMult / 100)

-- Modify element timers
local Values = { time = true }
if TimerTweaks[level] then
  for ElementName, ElementValue in pairs(TimerTweaks[level]) do
    for BaseElementName, BaseElement in pairs(script) do
      if BaseElement._editor_name == ElementName and BaseElement._values[ElementValue] then
        --CrimDawn.Log(FileIdent, "Found mission element " .. ElementName)
        --Utils.PrintTable(BaseElement._values, 2)

        if ElementValue == "time" and BaseElement._values.time then
          BaseElement._values.time = BaseElement._values.time * TimerMult

        elseif ElementValue == "on_executed" then
          for _, ExecutedElement in ipairs(BaseElement._values.on_executed) do
            ExecutedElement.delay = ExecutedElement.delay * TimerMult
            if ExecutedElement.delay_rand then ExecutedElement.delay_rand = ExecutedElement.delay_rand * TimerMult end
          end
          --Utils.PrintTable(BaseElement._values.on_executed, 2)

        elseif ElementValue == "timer" and (BaseElement._timer or BaseElement._values.timer) then
          if BaseElement._values.timer and type(BaseElement._values.timer) == "table" then -- Some timers are tables.
            for _, time in ipairs(BaseElement._values.timer) do time = time * TimerMult end -- ...for some reason.

          elseif level == "arena" then
            if BaseElement._values.timer == 5 then
              BaseElement._values.timer = BaseElement._values.timer * TimerMult
            break end

          else BaseElement._values.timer = BaseElement._values.timer * TimerMult end
          if BaseElement._timer then BaseElement._timer = BaseElement._timer * TimerMult end

        elseif ElementValue == "base_delay" and BaseElement._values.base_delay then
          BaseElement._values.base_delay = BaseElement._values.base_delay * TimerMult
          if BaseElement._values.base_delay_rand then
            BaseElement._values.base_delay_rand = BaseElement._values.base_delay_rand * TimerMult
          end
        end
        --Utils.PrintTable(BaseElement._values, 1)
      end
    end
  end
end