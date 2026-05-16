if CrimDawnClient then return end
local FileIdent = "ClientBridge"
CrimDawnClient = { DataPath = CrimDawn.SavePath .. "crimdawn_client.txt" }

function CrimDawnClient:LoadData()
  self.data = io.load_as_json(self.DataPath) or {}

  -- Progression items
  self.data["Extra Bot"] = math.min(self.data["Extra Bot"] or 0, 21)
  self.data["Extra Life"] = math.min(self.data["Extra Life"] or 0, 8) + 1
  self.data["Perma-Skill"] = math.min(self.data["Perma-Skill"] or 0, 7)
  self.data["Perma-Perk"] = math.min(self.data["Perma-Perk"] or 0, 7)
  self.data["Skill"] = math.min(self.data["Skill"] or 0, 13)
  self.data["Perk"] = math.min(self.data["Perk"] or 0, 13)

  -- Regular items
  self.data["OVE9000 Saw"] = math.min(self.data["OVE9000 Saw"] or 0, 2)
  self.data["Primary Weapon"] = math.min(self.data["Primary Weapon"] or 0, 77)
  self.data["Akimbo"] = math.min(self.data["Akimbo"] or 0, 58)
  self.data["Secondary Weapon"] = math.min(self.data["Secondary Weapon"] or 0, 78)
  self.data["Melee Weapon"] = math.min(self.data["Melee Weapon"] or 0, 94)
  self.data["Throwable"] = math.min(self.data["Throwable"] or 0, 15)
  self.data["Armor"] = math.min(self.data["Armor"] or 0, 6)
  self.data["Deployable"] = math.min(self.data["Deployable"] or 0, 9)
  self.data["Stat Boost"] = math.min(self.data["Stat Boost"] or 0, 100)
  self.data["Coins"] = math.min(self.data["Coins"] or 0, 46)
end CrimDawnClient:LoadData()

function CrimDawnClient:InitWorld()
  CrimDawnClient:LoadData()

  if not Global.CrimDawn.data.game.seed and self.data.seed then
    CrimDawn.Log(FileIdent, "Writing game config...")
    Global.CrimDawn.data.game.seed = self.data.seed
    Global.CrimDawn.data.game.slot = self.data.slot
    Global.CrimDawn.data.game.max_score_checks = self.data.score_checks
    Global.CrimDawn.data.game.max_progression_items = self.data.max_progression_items
    Global.CrimDawn.data.game.run_length = self.data.run_length
    Global.CrimDawn.data.game.goal = self.data.goal
    Global.CrimDawn.data.game.campaign = self.data.campaign
    Global.CrimDawn.data.game.safehouse_tiers = self.data.safehouse_tiers
    Global.CrimDawn.data.game.deathlink = self.data.deathlink_state
    Global.CrimDawn.data.game.inf_time = self.data.infinite_time
    CrimDawn:WriteSave(FileIdent, "Successfully wrote game config!")
  end
end

-- Update progression related stuff
function CrimDawnClient:PollProgression(ItemLog)
  self:LoadData()
  local data, UpgradeTime = Global.CrimDawn.data, CrimDawn.TimeFromUpgrade()
  if not data.game.ponr then data.game.ponr = 600 + (data.game.progression_items * UpgradeTime) end
  if not CrimDawn.CorrectSaveLoaded() or CrimDawn.GoMode() then return end

  self.progression_items = math.min(self.data["Extra Bot"], 3) +
                           self.data["Extra Life"] - 1 +
                           self.data["Perma-Skill"] +
                           self.data["Perma-Perk"] +
                           self.data["Skill"] +
                           self.data["Perk"]

  if not ItemLog then ItemLog = "" end
  if self.progression_items == data.game.progression_items then
    if not CrimDawn.state.maskup_time and NetworkHelper:IsHost() then

      DelayedCalls:Add("CrimDawn_ChatPONR", 1, function()
        local TimeRemaining = math.floor(Global.CrimDawn.data.game.ponr / 60)

        if Global.CrimDawn.data.game.ponr > 60 then
          CrimDawn.ChatNotify(ItemLog .. managers.localization:text("crimdawn_chat_time_remaining", {
            TIME = TimeRemaining
          }))

        elseif 0 < Global.CrimDawn.data.game.ponr and Global.CrimDawn.data.game.ponr <= 60 then
          CrimDawn.ChatNotify(ItemLog .. managers.localization:text("crimdawn_chat_final_minute"))

        else CrimDawn.ChatNotify(ItemLog .. managers.localization:text("crimdawn_chat_no_time_left")) end
        NetworkHelper:SendToPeers("CrimDawn_TimeUpdate", TimeRemaining)
      end)

    end
  return end

  local ProgressionDelta = self.progression_items - data.game.progression_items
  if ProgressionDelta < 0 then
    CrimDawn.ChatNotify(
      "You seem to have lost progression items (ProgressionDelta == " .. ProgressionDelta ..
      "); please report this issue as soon as possible!\nAttaching your current save and client file" ..
      " would help a lot in narrowing down the issue.\nPAYDAY 2/mods/saves\ncrimdawn_save.txt & crimdawn_client.txt"
    )
  return end

  if self.progression_items > data.game.progression_items then
    CrimDawn.state.cap_reached = false
    data.game.progression_items = self.progression_items
    ItemLog = ItemLog .. managers.localization:text("crimdawn_chat_score_cap_inc", {
      SCORE_CAP = CrimDawn.CalculateScoreCap()
    })
  end

  if managers.groupai then local TimeRemaining, PONR = managers.groupai:state():get_point_of_no_return_timer() end
  if Utils:IsInGameState() and PONR ~= "crimdawn_ponr" then return end

  if NetworkHelper:IsHost() and CrimDawn.InfiniteTime() and CrimDawn.state.maskup_time then
    managers.groupai:state():remove_point_of_no_return_timer("crimdawn_ponr")
    CrimDawn.ChatNotify(ItemLog .. managers.localization:text("crimdawn_chat_infinite_time"))
  return end

  if CrimDawn.state.maskup_time then return end

  data.game.ponr = data.game.ponr + (ProgressionDelta * UpgradeTime)
  CrimDawn.ChatNotify(ItemLog .. managers.localization:text("crimdawn_client_progression_upgrade", {
    TIME_GAINED = ProgressionDelta * UpgradeTime,
    MINS_REMAINING = math.floor(data.game.ponr / 60),
    SPEED = ProgressionDelta * 2,
    TOTAL_SPEED = math.min(data.game.progression_items * 2, 99)
  }))
  CrimDawn:WriteSave(FileIdent, "progression item level up")
end

-- Main update function
function CrimDawnClient:PollData()
  if not managers.blackmarket then return end -- Can't save if blackmarket doesn't exist

  CrimDawnClient:LoadData()
  if not CrimDawn.CorrectSaveLoaded() then return end

  local DataChanged, ItemLog = false, managers.localization:text("crimdawn_chat_received_items")
  math.randomseed(os.time() + (os.clock() * 1000))

  -- Nine Lives
  if self.data["Extra Life"] > Global.CrimDawn.data.x.max_lives then
    CrimDawn.Log(FileIdent, "Nine Lives Lv" .. self.data["Extra Life"])
    local ExtraLives = self.data["Extra Life"] - Global.CrimDawn.data.x.max_lives
    Global.CrimDawn.data.x.lives = Global.CrimDawn.data.x.lives + ExtraLives
    Global.CrimDawn.data.x.max_lives = self.data["Extra Life"]
    ItemLog = ItemLog .. managers.localization:text("crimdawn_client_extra_life", {
      LIVES = self.data["Extra Life"]
    })
    DataChanged = true
  end

  -- Perma-Skills
  if self.data["Perma-Skill"] > Global.CrimDawn.data.x.permaskills then
    CrimDawn.Log(FileIdent, "Permaskills: " .. self.data["Perma-Skill"])
    Global.CrimDawn.data.x.permaskills = self.data["Perma-Skill"]
    ItemLog = ItemLog .. managers.localization:text("crimdawn_client_new_item", {
      ITEM = "perma-skill",
      CURRENT = self.data["Perma-Skill"],
      TOTAL = 7
    })
    DataChanged = true
  end

  -- Perma-Perks
  if self.data["Perma-Perk"] > Global.CrimDawn.data.x.permaperks then
    CrimDawn.Log(FileIdent, "Permaperks: " .. self.data["Perma-Perk"])
    Global.CrimDawn.data.x.permaperks = self.data["Perma-Perk"]
    ItemLog = ItemLog .. managers.localization:text("crimdawn_client_new_item", {
      ITEM = "perma-perk",
      CURRENT = self.data["Perma-Perk"],
      TOTAL = 7
    })
    DataChanged = true
  end

  -- Bots
  if self.data["Extra Bot"] > Global.CrimDawn.data.x.bots then
    CrimDawn.Log(FileIdent, self.data["Extra Bot"] .. " bots")
    Global.CrimDawn.data.x.bots = self.data["Extra Bot"]
    ItemLog = ItemLog .. managers.localization:text("crimdawn_client_new_item", {
      ITEM = "extra bot",
      CURRENT = self.data["Extra Bot"],
      TOTAL = 3
    })
    DataChanged = true
  end

  -- Safehouse coins
  if managers.custom_safehouse then
    if self.data["Coins"] > Global.CrimDawn.data.x.coins then
      local CoinDelta = self.data["Coins"] - Global.CrimDawn.data.x.coins
      local CoinAmount = 3 * CoinDelta

      CrimDawn.Log(FileIdent, "Giving " .. CoinAmount .. " coins")
      managers.custom_safehouse:add_coins(CoinAmount, "archipelago")
      ItemLog = ItemLog .. managers.localization:text("crimdawn_client_coins", {
        NUM = CoinAmount
      })

      Global.CrimDawn.data.x.coins = self.data["Coins"]
      DataChanged = true
    end
  end

  -- Saws
  if self.data["OVE9000 Saw"] > Global.CrimDawn.data.x.saws then
    CrimDawn.Log(FileIdent, "Unlocking random saw")

    local saws = { "saw", "saw_secondary" }
    if managers.dlc:is_dlc_unlocked("esp") then table.insert(saws, "laser_watch") end

    for i = #saws, 1, -1 do
      if Global.CrimDawn.data.unlocks[saws[i]] then table.remove(saws, i) end
    end

    Global.CrimDawn.data.x.saws = self.data["OVE9000 Saw"]

    if #saws ~= 0 then
      local ChosenSaw = saws[#saws]
      Global.CrimDawn.data.unlocks[ChosenSaw] = true
      managers.upgrades:aquire(ChosenSaw)
      ItemLog = ItemLog .. managers.localization:text("crimdawn_client_" .. ChosenSaw)
      DataChanged = true
    end
  end

  -- Deployables
  local UnlockObtained = 0
  for _, deployable in ipairs(Global.CrimDawn.tables.etc.deployables) do
    if Global.CrimDawn.data.unlocks[deployable] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "deployables" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Deployable"] > UnlockObtained then
    local UnlockNeeded = self.data["Deployable"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "etc", TableName = "deployables" })
    end

    DataChanged = true
  end

  -- Armour
  local UnlockObtained = 0
  for _, armour in ipairs(Global.CrimDawn.tables.etc.armour) do
    if Global.CrimDawn.data.unlocks[armour] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "armour" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Armor"] > UnlockObtained then
    local UnlockNeeded = self.data["Armor"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "etc", TableName = "armour" })
    end

    DataChanged = true
  end

  -- Primaries
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.primaries) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "primaries" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Primary Weapon"] > UnlockObtained then
    local UnlockNeeded = self.data["Primary Weapon"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "primaries" })
    end

    DataChanged = true
  end
  
  -- Akimbos
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.akimbos) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "akimbos" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Akimbo"] > UnlockObtained then
    local UnlockNeeded = self.data["Akimbo"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "akimbos" })
    end

    DataChanged = true
  end

  -- Secondaries
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.secondaries) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "secondaries" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Secondary Weapon"] > UnlockObtained then
    local UnlockNeeded = self.data["Secondary Weapon"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "secondaries" })
    end

    DataChanged = true
  end

  -- Melees
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.melee) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "melee" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Melee Weapon"] > UnlockObtained then
    local UnlockNeeded = self.data["Melee Weapon"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "melee" })
    end

    DataChanged = true
  end

  -- Throwables
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.throwables) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "throwables" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Throwable"] > UnlockObtained then
    local UnlockNeeded = self.data["Throwable"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "throwables" })
    end

    DataChanged = true
  end

  -- Skills
  if self.data["Skill"] > Global.CrimDawn.data.x.skills then
    local SkillsNeeded = self.data["Skill"] - Global.CrimDawn.data.x.skills
    CrimDawn:RandomUpgrade(SkillsNeeded, "skills")

    Global.CrimDawn.data.x.skills = self.data["Skill"]
    ItemLog = ItemLog .. managers.localization:text("crimdawn_client_new_item", {
      ITEM = "skill",
      CURRENT = self.data["Skill"],
      TOTAL = 13
    })
    DataChanged = true
  end

  -- Perks
  if self.data["Perk"] > Global.CrimDawn.data.x.perks then
    local PerksNeeded = self.data["Perk"] - Global.CrimDawn.data.x.perks
    CrimDawn:RandomUpgrade(PerksNeeded, "perks")

    Global.CrimDawn.data.x.perks = self.data["Perk"]
    ItemLog = ItemLog .. managers.localization:text("crimdawn_client_new_item", {
      ITEM = "perk",
      CURRENT = self.data["Perk"],
      TOTAL = 13
    })
    DataChanged = true
  end

  -- Stat boosts
  if self.data["Stat Boost"] > Global.CrimDawn.data.x.stats then
    local StatsNeeded = self.data["Stat Boost"] - Global.CrimDawn.data.x.stats
    CrimDawn:RandomUpgrade(StatsNeeded, "stats")

    Global.CrimDawn.data.x.stats = self.data["Stat Boost"]
    ItemLog = ItemLog .. managers.localization:text("crimdawn_client_infinite_item", { ITEM = "stat boost" })
    DataChanged = true
  end

  -- Finalize
  if DataChanged then -- Pull upgrades from save, split into table/index pair
    for _, upgrade in pairs(Global.CrimDawn.data.upgrades) do
      local tableName, upgradeName = upgrade:match("([^%-]+)%-(.+)")
      if tonumber(upgradeName) then upgradeName = tonumber(upgradeName) end -- Permaupgrades

      if tableName == nil then -- If table is nil it's an actual upgrade ID, just add it
        if not Global.upgrades_manager.aquired[upgrade] then managers.upgrades:aquire(upgrade) end

      else -- On table/index pair, look it up and add all upgrades it encompasses
        for _, currentUpgrade in ipairs(Global.CrimDawn.tables.upgrades[tableName][upgradeName]) do
          if not Global.upgrades_manager.aquired[currentUpgrade] then managers.upgrades:aquire(currentUpgrade) end
        end
      end
    end

    self:PollProgression(ItemLog)
    CrimDawn:RandomUnlock()
    CrimDawn:WriteSave(FileIdent, "received client update")
  end
end