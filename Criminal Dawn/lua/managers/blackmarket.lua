-- Automatically unlock side job weapons so they are available for use
Hooks:OverrideFunction(BlackMarketManager, "has_unlocked_arbiter", function() return true end)
Hooks:OverrideFunction(BlackMarketManager, "has_unlocked_breech", function() return true end)
Hooks:OverrideFunction(BlackMarketManager, "has_unlocked_ching", function() return true end)
Hooks:OverrideFunction(BlackMarketManager, "has_unlocked_erma", function() return true end)
Hooks:OverrideFunction(BlackMarketManager, "has_unlocked_victor", function() return true end)

-- Force game to register 2 of every item
Hooks:PostHook(BlackMarketManager, "get_item_amount", "CrimDawn_BMInfiniteItems", function(self, _, category)
  if category ~= "weapon_skins" then return 2 end
end)

-- Force default throwable to Ace of Spades
Hooks:PostHook(BlackMarketManager, "_setup", "CrimDawn_BMSetup", function(self)
  self._defaults.grenade = "wpn_prj_ace"
end)

-- Unlock all crew boosts
Hooks:OverrideFunction(BlackMarketManager, "_setup_unlocked_crew_items", function(self)
  self:_unlock_crew_item("crew_interact")
  self:_unlock_crew_item("crew_inspire")
  self:_unlock_crew_item("crew_scavenge")
  self:_unlock_crew_item("crew_ai_ap_ammo")
  self:_unlock_crew_item("crew_ai_cable_ties")
  self:_unlock_crew_item("crew_ai_flashbang")
  self:_unlock_crew_item("crew_ai_counter_strike")
  self:_unlock_crew_item("crew_ai_counter_tase")
	self:_unlock_crew_item("crew_healthy")
	self:_unlock_crew_item("crew_sturdy")
	self:_unlock_crew_item("crew_evasive")
	self:_unlock_crew_item("crew_motivated")
	self:_unlock_crew_item("crew_regen")
	self:_unlock_crew_item("crew_quiet")
	self:_unlock_crew_item("crew_generous")
	self:_unlock_crew_item("crew_eager")
end)

-- Assign random van skin
Hooks:OverrideFunction(BlackMarketManager, "equipped_van_skin", function()
  local skins = { "default", "brown", "green", "grey", "red", "white", "yellow", "icecream", "spooky" }
  if not Global.CrimDawn.DLC and managers.dlc:is_dlc_unlocked("overkill_pack") then table.insert(skins, "overkill") end
  return skins[math.random(1, #skins)]
end)

-- Unlock all inventory slots by default
Hooks:OverrideFunction(BlackMarketManager, "_setup_unlocked_mask_slots", function(self)
  local unlocked_mask_slots = {}
  Global.blackmarket_manager.unlocked_mask_slots = unlocked_mask_slots

  for i = 1, 320 do unlocked_mask_slots[i] = true end
end)

Hooks:OverrideFunction(BlackMarketManager, "_setup_unlocked_weapon_slots", function(self)
  local unlocked_weapon_slots = {}
  Global.blackmarket_manager.unlocked_weapon_slots = unlocked_weapon_slots
  unlocked_weapon_slots.primaries = unlocked_weapon_slots.primaries or {}
  unlocked_weapon_slots.secondaries = unlocked_weapon_slots.secondaries or {}

  for i = 1, 320 do
    unlocked_weapon_slots.primaries[i] = true
    unlocked_weapon_slots.secondaries[i] = true
  end
end)

-- Validate equipped deployable
Hooks:PostHook(BlackMarketManager, "_verfify_equipped", "CrimDawn_VerfifyDeployable", function(self)
  local DefaultDeployable = (self:equipped_deployable() == "grenade_crate") or (self:equipped_deployable() == "spy_camera")
  if not Global.CrimDawn.data.unlocks[self:equipped_deployable()] and not DefaultDeployable then
    self:equip_deployable({ target_slot = 1 })
  end
end)