local FileIdent = "SafehouseManager"

Hooks:OverrideFunction(CustomSafehouseManager, "is_being_raided", function() return false end)
Hooks:OverrideFunction(CustomSafehouseManager, "add_coins_ingore_locked", function() end)
Hooks:OverrideFunction(CustomSafehouseManager, "give_upgrade_points", function() end)
Hooks:OverrideFunction(CustomSafehouseManager, "attempt_give_initial_coins", function() end)
Hooks:OverrideFunction(CustomSafehouseManager, "save", function() end)

local MaxSafehouseTier = 6
if Global.CrimDawn.data.game.safehouse_tiers then MaxSafehouseTier = 1 + Global.CrimDawn.data.game.safehouse_tiers end

local function UpdateDescriptions(tier)
  managers.localization:load_localization_file(CrimDawn.SavePath .. "crimdawn_rooms.txt")

  for _, data in ipairs(tweak_data.safehouse.rooms) do
    local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]

    for i = tier, MaxSafehouseTier do
      managers.localization:add_localized_strings({ -- Future items use the description of the current item
        [data.help_id .. "_" .. i] = managers.localization:text(data.help_id .. "_" .. i - 1):gsub("#", "")
      })
    end

    if Global.CrimDawn.data.safehouse[data.room_id] == MaxSafehouseTier then
      managers.localization:add_localized_strings({ -- Final tier description to let you know you're done
        [data.help_id .. "_" .. MaxSafehouseTier] = managers.localization:text("menu_cs_fully_upgraded")
      })
    end
  end
end

local function RoomsUpgraded()
  local RoomUpgrades = 0

  for _, RoomTier in pairs(Global.CrimDawn.data.safehouse) do
    RoomUpgrades = RoomUpgrades + (RoomTier - 1)
  end

return RoomUpgrades end

local function HighestTierUnlocked()
  local SafehouseTier = 1

  for _, RoomTier in pairs(Global.CrimDawn.data.safehouse) do
    if RoomTier > SafehouseTier then
      SafehouseTier = RoomTier
    end
  end

  if RoomsUpgraded() % 23 == 0 and SafehouseTier ~= MaxSafehouseTier then
    SafehouseTier = SafehouseTier + 1
  end

return SafehouseTier end

local function SetTierCap()
  local UnlockableTier = math.min(Global.CrimDawn.data.game.heists_won + 2, MaxSafehouseTier)
  local NextTier = 2 + (1 * math.floor(RoomsUpgraded() / 23))

  CrimDawn.Log(FileIdent, "Tier cap " .. UnlockableTier - 1)

  for _, data in ipairs(tweak_data.safehouse.rooms) do
    local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]
    CurrentRoom.tier_max = math.min(NextTier, UnlockableTier)
  end

  UpdateDescriptions(HighestTierUnlocked())
end

Hooks:PostHook(CustomSafehouseManager, "purchase_room_tier", "CrimDawn_SafehouseUpgrade", function(self, room_id, tier)
  CrimDawn.Log(FileIdent, "Upgraded room: " .. room_id .. " to tier " .. tier)
  Global.CrimDawn.data.safehouse[room_id] = tier
  CrimDawn:WriteSave(FileIdent, "safehouse upgraded")
  SetTierCap()
end)

Hooks:OverrideFunction(CustomSafehouseManager, "add_coins", function(self, amount, reason)
  if reason ~= "archipelago" then return end
  Global.custom_safehouse_manager.total = Application:digest_value(self:coins() + amount, true)
end)

Hooks:OverrideFunction(CustomSafehouseManager, "load", function(self)
  self._global._has_entered_safehouse = true

  for _, data in ipairs(tweak_data.safehouse.rooms) do
    CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]

    if Global.CrimDawn.data.safehouse[data.room_id] then
      CurrentRoom.tier_current = Global.CrimDawn.data.safehouse[data.room_id]

      for i = 2, Global.CrimDawn.data.safehouse[data.room_id] do
        table.insert(CurrentRoom.unlocked_tiers, i)
      end

    end
  end

  self:add_coins((Global.CrimDawn.data.x.coins * 3) - RoomsUpgraded(), "archipelago")
end)

Hooks:PostHook(CustomSafehouseManager, "init", "CrimDawn_SafehouseInit", function()
  SetTierCap()
end)