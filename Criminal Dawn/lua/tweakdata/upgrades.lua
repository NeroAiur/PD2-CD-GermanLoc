Hooks:PostHook(UpgradesTweakData, "init", "CrimDawn_InitUpgradeTweakData", function(self)
  table.insert(self.values.shape_charge.quantity, 6)

  -- Lock everything to level 193
  local all_levels = { upgrades = {
    "s552", "scar", "spas12", "rpk", "usp", "ppk", "p226", "m45", "mp7", "x_packrat", "x_sr2",
    "brass_knuckles", "toothbrush", "kabar", "briefcase", "swagger", "spoon_gold", "fists" }
  }
  for _, level in pairs(self.level_tree) do
    if level.upgrades then
      for _, upgrade in ipairs(level.upgrades) do
        if upgrade ~= "wpn_prj_ace" then table.insert(all_levels.upgrades, upgrade) end
      end
    end
  end
  self.level_tree = { [193] = all_levels }
end)

-- Defines values for custom upgrade levels
Hooks:PostHook(UpgradesTweakData, "_init_pd2_values", "CrimDawn_InitPD2UpgradeTweakData", function(self)
  self.values.player.additional_lives = { 1, 2, 3, 4, 5, 6, 7, 8 }
  self.values.player.drill_speed_multiplier = { 0.85, 0.7, 0.55, 0.4, 0.25, 0.1 }

  -- Rise Above
  self.values.player.health_decrease = { 5, 7.5, 10 }
  self.values.player.armor_increase = { 1, 2, 3 }

  -- Hysteria stacks
  self.cocaine_stacks_tick_rounding = 2
  self.cocaine_stacks_decay_t = cocaine_stacks_tick_rounding
  self.cocaine_stacks_decay_amount_per_tick = 0
  self.cocaine_stacks_decay_percentage_per_tick = 1

  -- Health mult to flat
  self.values.player.health_multiplier = { 1 }
  self.values.team.health.passive_multiplier = { 1 }
  self.values.player.passive_health_multiplier = { 1, 2, 4, 8, 10 }
  self.values.player.mrwi_health_multiplier = { 2, 4, 6, 8 }
  self.values.player.minion_master_health_multiplier = { 3 }

  -- Health regen
  self.values.player.passive_health_regen = { 0.3 }
  self.values.player.hostage_health_regen_addend = { 0.2, 0.5 }

  -- Armour
  self.values.player.body_armor.armor = { 0, 3, 4, 5.5, 8, 10, 13}
  self.values.player.body_armor.dodge = { 0.25, 0, -0.10, -0.15, -0.25, -0.5, -1 }

  -- Deployables
  self.doctor_bag_base = 3
  self.values.doctor_bag.amount_increase[1] = 1

  self.values.first_aid_kit.quantity[1] = 3
  self.values.first_aid_kit.downs_restore_chance[1] = 0.5

  table.insert(self.values.doctor_bag.quantity, 3)
  table.insert(self.values.ammo_bag.quantity, 3)
end)

-- Creates definitions for custom upgrade levels
Hooks:PostHook(UpgradesTweakData, "_player_definitions", "CrimDawn_PlayerUpgradeDefinitions", function(self)
  for i = 3, 8 do -- Nine Lives
    self.definitions["player_additional_lives_" .. i] = deep_clone(self.definitions.player_additional_lives_2)
    self.definitions["player_additional_lives_" .. i].upgrade.value = i
  end

  for i = 3, 6 do -- Drill Speed
    self.definitions["player_drill_speed_multiplier" .. i] = deep_clone(self.definitions.player_drill_speed_multiplier2)
    self.definitions["player_drill_speed_multiplier" .. i].upgrade.value = i
  end

  for i = 2, 3 do -- Rise Above
    self.definitions["player_health_decrease_" .. i] = deep_clone(self.definitions.player_health_decrease_1)
    self.definitions["player_health_decrease_" .. i].upgrade.value = i
  end
end)

Hooks:PostHook(UpgradesTweakData, "_ammo_bag_definitions", "CrimDawn_AmmoBagUpgradeDefinitions", function(self)
  self.definitions.ammo_bag_quantity_2 = deep_clone(self.definitions.ammo_bag_quantity)
  self.definitions.ammo_bag_quantity_2.upgrade.value = 2
end)

Hooks:PostHook(UpgradesTweakData, "_doctor_bag_definitions", "CrimDawn_DoctorBagUpgradeDefinitions", function(self)
  self.definitions.doctor_bag_quantity_2 = deep_clone(self.definitions.doctor_bag_quantity)
  self.definitions.doctor_bag_quantity_2.upgrade.value = 2
end)

Hooks:PostHook(UpgradesTweakData, "_trip_mine_definitions", "CrimDawn_TripMineUpgradeDefinitions", function(self)
  self.definitions.shape_charge_quantity_increase_3 = deep_clone(self.definitions.shape_charge_quantity_increase_2)
  self.definitions.shape_charge_quantity_increase_3.upgrade.value = 3
end)