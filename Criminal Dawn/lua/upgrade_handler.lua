local FileIdent = "UpgradeHandler"

Hooks:OverrideFunction(PlayerManager, "verify_equipment", function() return true end)
Hooks:OverrideFunction(PlayerManager, "health_skill_multiplier", function() return 1 end)

local function PermaUpgrade(upg_name, count)
  if upg_name == "permaskills" or upg_name == "permaperks" then
    for i = 1, Global.CrimDawn.data.x[upg_name] do
      for _, currentUpgrade in ipairs(Global.CrimDawn.tables.upgrades[upg_name][i]) do
        managers.upgrades:aquire(currentUpgrade)
      end
    end
  else managers.upgrades:aquire(upg_name .. count) end
end

local function ApplyUpgrades()
  for _, upgrade in ipairs(Global.CrimDawn.data.upgrades) do
    local tableName, upgradeName = upgrade:match("([^%-]+)%-(.+)")

    for _, currentUpgrade in ipairs(Global.CrimDawn.tables.upgrades[tableName][upgradeName]) do
      managers.upgrades:aquire(currentUpgrade)
    end

  end
end

local function ApplyUnlocks()
  for key, _ in pairs(Global.CrimDawn.data.unlocks) do

    if not Global.upgrades_manager.aquired[key] then
      CrimDawn.Log(FileIdent, "Unlocking " .. key)
      managers.upgrades:aquire(key)
    end

  end
end

local NukeImmune = {
  amcar = true, glock_17 = true, weapon = true, second_deployable_1 = true, wpn_prj_ace = true
}

local function DropNuke()
  for key, _ in pairs(Global.upgrades_manager.aquired) do
    if not NukeImmune[key] then
      if not Global.CrimDawn.data.unlocks[key] then managers.upgrades:unaquire(key) end
    elseif key == "second_deployable_1" then Global.upgrades_manager.aquired.second_deployable_1 = nil end
  end -- Removing Jack of all Trades using unaquire causes it to reset the second deployable

  Global.player_manager.upgrades = {}
  Global.player_manager.team_upgrades = {}
  Global.player_manager.cooldown_upgrades = { cooldown = {} }
  -- When I tried using managers.upgrades:unaquire it wouldn't clear playermanager upgrades correctly,
  -- leading to persistent upgrades that won't disappear until you restart the game.
  -- Only practical issue with current approach is the game forces you to equip consumables every load.
end

Hooks:PreHook(PlayerManager, "aquire_default_upgrades", "CrimDawn_DefaultUpgrades", function()
  DropNuke()

  tweak_data.skilltree.default_upgrades = {
    "player_hostage_trade", "player_special_enemy_highlight", "player_sec_camera_highlight", "cable_tie",
    "temporary_first_aid_damage_reduction", "temporary_passive_revive_damage_reduction_2", "wpn_prj_ace",
    "passive_player_xp_multiplier", "player_flashbang_multiplier_2", "trip_mine_can_switch_on_off"
  }

  if Global.CrimDawn.data.x.permaskills > 0 then PermaUpgrade("permaskills") end
  if Global.CrimDawn.data.x.max_lives > 1 then PermaUpgrade("player_additional_lives_", Global.CrimDawn.data.x.max_lives - 1) end
  if CrimDawn.DiffScale(true, 6) > 0 then PermaUpgrade("player_drill_speed_multiplier", CrimDawn.DiffScale(true, 6)) end
  if Global.CrimDawn.data.x.permaperks > 0 then PermaUpgrade("permaperks") end

  ApplyUpgrades()
  ApplyUnlocks()
end)

Hooks:OverrideFunction(PlayerManager, "_dodge_replenish_armor", function(self)
  --local armour = self:player_unit():character_damage():_max_armor() * 0.1
  self:player_unit():character_damage():restore_health(0.2)
end)

Hooks:OverrideFunction(PlayerManager, "health_skill_addend", function(self)
	local addend = 0
	addend = addend + self:upgrade_value("team", "crew_add_health", 0)
	addend = addend - self:upgrade_value("player", "health_decrease", 0)

  -- Convert health multipliers to flat amount
  addend = addend + self:upgrade_value("player", "health_multiplier", 0)
	addend = addend + self:upgrade_value("player", "passive_health_multiplier", 0)
	addend = addend + self:upgrade_value("health", "passive_multiplier", 0)
  addend = addend + self:get_hostage_bonus_multiplier("health") - 1
	addend = addend + self:upgrade_value("player", "mrwi_health_multiplier", 0)

  if self:num_local_minions() > 0 then
		addend = addend + self:upgrade_value("player", "minion_master_health_multiplier", 0)
	end

  -- Max health can't go below 1
  if PlayerDamage._HEALTH_INIT + addend <= 0 then addend = -PlayerDamage._HEALTH_INIT + 0.1 end

	return addend
end)

Hooks:OverrideFunction(PlayerManager, "body_armor_skill_addend", function(self, override_armor)
  local addend = 0
	addend = addend + self:upgrade_value("player", tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. "_armor_addend", 0)

	if self:has_category_upgrade("player", "armor_increase") then
	  local AnarchArmour = 5 * self:upgrade_value("player", "armor_increase", 1)
		addend = addend + AnarchArmour
	end

	addend = addend + self:upgrade_value("team", "crew_add_armor", 0)
	return addend
end)