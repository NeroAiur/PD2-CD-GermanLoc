local FileIdent = "MenuManager"

-- PLAY BUTTON
function MenuCallbackHandler:CrimDawn_CreateLobby()
  CrimDawnClient:InitWorld()

  if CrimDawn.CorrectSaveLoaded() then
    CrimDawnClient:PollProgression()
    CrimDawnClient:PollData()

    if NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY ~= Global.CrimDawn.data.game.seed then
      local key = Global.CrimDawn.data.game.seed .. "_" .. Global.CrimDawn.data.game.slot
      NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY = key
      NetworkMatchMakingEPIC._BUILD_SEARCH_INTEREST_KEY = key
      CrimDawn.Log(FileIdent, "Updated matchmaking key: " .. NetworkMatchMakingEPIC._BUILD_SEARCH_INTEREST_KEY)
    end

    if CrimDawnClient.data.seed then
      managers.localization:load_localization_file(CrimDawn.SavePath .. "crimdawn_rooms.txt")
      managers.localization:add_localized_strings({
        ["crimdawn_enter_lobby_title"] = managers.localization:text("crimdawn_create_lobby_title"),
        ["crimdawn_enter_lobby_desc"] = managers.localization:text("crimdawn_create_lobby_desc")
      })
    end

    self:create_lobby()

  elseif not Global.CrimDawn.data.game.seed then
    local NeedSeed = QuickMenu:new(
      managers.localization:text("crimdawn_multiworld_missing_title"),
      managers.localization:text("crimdawn_multiworld_missing_desc"),
      {}, true
    )
  else local InvalidSeed = QuickMenu:new(
    managers.localization:text("crimdawn_multiworld_invalid_title"),
    managers.localization:text("crimdawn_multiworld_invalid_desc"),
    {}, true
  )
  end
end

-- Safehouse button
function MenuCallbackHandler:CrimDawn_Safehouse()
  CrimDawnClient:PollData()
  managers.menu:open_node("custom_safehouse")
  if Global.CrimDawn.data.game.run_length > 0 then
    managers.localization:add_localized_strings({
      ["menu_cs_upgrade_owned"] = managers.localization:text("crimdawn_safehouse_upg_hint")
    })
  else managers.localization:add_localized_strings({
      ["menu_cs_upgrade_owned"] = managers.localization:text("crimdawn_safehouse_inf_upg_hint")
    })
  end
end

function MenuCallbackHandler:CrimDawn_SaveToggleSettings(item)
  CrimDawn.SettingsData[item:name():sub(10)] = item:value() == "on"
	io.save_as_json(CrimDawn.SettingsData, CrimDawn.SettingsFile)
end

function MenuCallbackHandler:CrimDawn_SaveChoiceSettings(item)
  CrimDawn.SettingsData[item:name():sub(10)] = item:value()
	io.save_as_json(CrimDawn.SettingsData, CrimDawn.SettingsFile)
end

-- Add custom buttons to menu
local function InjectCrimDawnButtons(node)
  local data = {
    type = "CoreMenuItem.Item",
  }

  local params = {
    name = "crimdawn_createlobby_btn",
    text_id = "crimdawn_enter_lobby_title",
    help_id = "crimdawn_enter_lobby_desc",
    callback = "CrimDawn_CreateLobby",
    font_size = 35,
    font = tweak_data.menu.pd2_large_font
  }

  local new_item = node:create_item(data, params)

  new_item.dirty_callback = callback(node, node, "item_dirty")
  if node.callback_handler then
    new_item:set_callback_handler(node.callback_handler)
  end

  local position = 2
  table.insert(node._items, position, new_item)

  -- Add the safehouse button
  local data = {
    type = "CoreMenuItem.Item",
  }
  local params = {
    name = "crimdawn_safehouse",
    text_id = "menu_cn_chill",
    help_id = "crimdawn_safehouse_desc",
    callback = "CrimDawn_Safehouse",
    font_size = 35,
    font = tweak_data.menu.pd2_large_font
  }

  local new_item = node:create_item(data, params)

  new_item.dirty_callback = callback(node, node, "item_dirty")
  if node.callback_handler then
    new_item:set_callback_handler(node.callback_handler)
  end

  local position = 3
  table.insert(node._items, position, new_item)
end

local function ordinal(n)
  if n % 10 == 1 and n % 100 ~= 11 then return tostring(n) .. "st"
  elseif n % 10 == 2 and n % 100 ~= 12 then return tostring(n) .. "nd"
  elseif n % 10 == 3 and n % 100 ~= 13 then return tostring(n) .. "rd"
  else return tostring(n) .. "th" end
end


-- MENU CHANGES START HERE --
Hooks:Add("MenuManagerBuildCustomMenus", "CrimDawn_MenuTweaks", function(menu_manager, nodes)
  local mainmenu = nodes.main
  local pausemenu = nodes.pause
  local lobbymenu = nodes.lobby

  -- Main Menu
  if mainmenu ~= nil then
    managers.localization:load_localization_file(CrimDawn.SavePath .. "crimdawn_rooms.txt")

    if Global.CrimDawn.PostBoot then
      DelayedCalls:Add("CrimDawn_MenuPoll", 1, function() CrimDawnClient:PollData() end)
    else Global.CrimDawn.PostBoot = true end

    local MaxTime = 900 * Global.CrimDawn.data.game.run_length
    if Global.CrimDawn.data.game.run_length == 0 then MaxTime = 6000 end
    local TimeCharMap = { "", "", "" }
    local TimeCharacter = ""

    if Global.CrimDawn.data.game.ponr then
      for i = 1, 3 do
        if Global.CrimDawn.data.game.ponr < ((i/3) * MaxTime) then TimeCharacter = TimeCharMap[i] break end
      end
    end

    -- Play button
    if CrimDawn.InfiniteTime() then managers.localization:add_localized_strings({
      ["crimdawn_continue_run_desc"] = managers.localization:text("crimdawn_play_inf_desc")
    })

    else managers.localization:add_localized_strings({
      ["crimdawn_continue_run_desc"] = managers.localization:text("crimdawn_play_next_desc", {
        CLOCK = TimeCharacter,
        TIME = math.floor((Global.CrimDawn.data.game.ponr or 0) / 60)
      })
    })
    end

    local HeistNumText = ""
    local IsEndless = Global.CrimDawn.data.game.heists_won >= Global.CrimDawn.data.game.run_length
    if IsEndless then HeistNumText = ("[Heist " .. #Global.CrimDawn.data.game.heists .. "]")
    else HeistNumText = "[" .. #Global.CrimDawn.data.game.heists .. "/" .. Global.CrimDawn.data.game.run_length .. "]" end

    managers.localization:add_localized_strings({
      ["crimdawn_continue_run_title"] = managers.localization:text("crimdawn_play_next_title", {
        ORDINAL = ordinal(Global.CrimDawn.data.game.run),
        HEIST_NUM = HeistNumText
      })
    })

    if Global.CrimDawn.data.game.run == 1 then managers.localization:add_localized_strings({
      ["crimdawn_start_run_title"] = managers.localization:text("crimdawn_first_run_title")
    })

    else managers.localization:add_localized_strings({
      ["crimdawn_start_run_title"] = managers.localization:text("crimdawn_new_run_title", {
        ORDINAL = ordinal(Global.CrimDawn.data.game.run)
      })
    }) end

    -- Create Lobby
    managers.localization:add_localized_strings({
      ["crimdawn_enter_lobby_title"] = managers.localization:text("crimdawn_init_multiworld_title"),
      ["crimdawn_enter_lobby_desc"] = managers.localization:text("crimdawn_init_multiworld_desc")
    })

    if CrimDawn.CorrectSaveLoaded() then managers.localization:add_localized_strings({
      ["crimdawn_enter_lobby_title"] = managers.localization:text("crimdawn_create_lobby_title"),
      ["crimdawn_enter_lobby_desc"] = managers.localization:text("crimdawn_create_lobby_desc")
    })
    end

    InjectCrimDawnButtons(mainmenu)

    -- Hides all the unnecessary menu buttons
    local HiddenButtons = {
      crimenet = true, crimenet_offline = true, story_missions = true,
      fbi_files = true, gamehub = true, movie_theater = true,
      achievements = true, crimdawn_safehouse = true
    }

    for i, item in pairs(mainmenu._items) do
      if HiddenButtons[item._parameters.name] then item:set_visible(false) end
    end

    if RestructuredMenus then
      if RestructuredMenus.settings.main_add_crimenet_broker then
        MenuHelper:HideMenuItem(mainmenu, 'contract_broker')
      end
    end
  end

  -- Lobby
  if lobbymenu ~= nil then
    InjectCrimDawnButtons(lobbymenu)

    -- Make start game button always visible
    for i, item in pairs(lobbymenu._items) do
      if item._parameters.name == "start_the_game" then
        table.remove(item._visible_callback_list, 2)

        if next(Global.CrimDawn.data.game.heists) then
          item._parameters.text_id = "crimdawn_continue_run_title"
          item._parameters.help_id = "crimdawn_continue_run_desc"

        else item._parameters.text_id = "crimdawn_start_run_title"
          item._parameters.help_id = "crimdawn_start_run_desc"
        end break
      end
    end

    -- Hides all the unnecessary menu buttons
    local HiddenButtons = { story_missions = true, achievements = true, side_jobs = true,
                            crimdawn_createlobby_btn = true, crimenet_nj = true, crimenet_j = true  }

    for i, item in pairs(lobbymenu._items) do
      if HiddenButtons[item._parameters.name] then item:set_visible(false) end
    end

    if RestructuredMenus then
      if RestructuredMenus.settings.lobby_add_contract_broker then
        MenuHelper:HideMenuItem(lobbymenu, "contract_broker")
      end
    end
  end

  -- Pause Menu
  if pausemenu ~= nil then
    local breakCounter = 0
    for i, item in pairs(pausemenu._items) do

      if item._parameters.name == "end_game" then
        item:set_visible(false)
        item._enabled = false
      break end

    end
  end
end)
-- MENU CHANGES END HERE --

Hooks:PreHook(MenuCallbackHandler, "start_the_game", "CrimDawn_PreStartGame", function(self)
  if Utils:IsInGameState() or CrimDawn.state.heist_started then return end

  -- Check for any last second items
  CrimDawnClient:PollProgression()
  CrimDawnClient:PollData()

  if NetworkHelper:IsHost() then -- Pick starting heist if no active run
    if not next(Global.CrimDawn.data.game.heists) then CrimDawn:NextHeist(0) end

    -- Activate mutators
    dofile(CrimDawn.ModPath .. "lua/tables/mutators.lua")

    -- Setup next heist
    local NextHeist = Global.CrimDawn.data.game.heists[#Global.CrimDawn.data.game.heists]

    self:start_job({
      difficulty = tweak_data.difficulties[CrimDawn.DiffIndex()],
      one_down = true,
      job_id = NextHeist
    })

    CrimDawn.Log(FileIdent, "Loading " .. NextHeist .. " on " .. tweak_data.difficulties[CrimDawn.DiffIndex()])
  end

  -- Prevent from running again, otherwise peer mutators become desynced
  CrimDawn.state.heist_started = true
end)

Hooks:OverrideFunction(MenuCallbackHandler, "abort_mission", function(self)
  if game_state_machine:current_state_name() == "disconnected" then return end

	local function yes_func()
		NetworkHelper:SendToPeers("CrimDawn_ResetRun", true)
	  CrimDawn:RunReset(FileIdent)

		self:load_start_menu_lobby()
		managers.preplanning:reset_rebuy_assets()
	end

	managers.menu:show_abort_mission_dialog({ yes_func = yes_func })
end)

-- Resetting save also resets mod
Hooks:PostHook(MenuManager, "do_clear_progress", "CrimDawn_ResetSave", function(self)
  CrimDawn.Log(FileIdent, "Wiping save data")
  CrimDawn:Reset()
  io.save_as_json(Global.CrimDawn.data, CrimDawn.SaveFile)

  CrimDawnClient:LoadData()
  if CrimDawnClient.data then
    CrimDawn.Log(FileIdent, "Wiping client data")
    os.remove(CrimDawnClient.DataPath)
    os.remove(CrimDawn.SavePath .. "crimdawn_rooms.txt")
  end

  setup:load_start_menu()
end)