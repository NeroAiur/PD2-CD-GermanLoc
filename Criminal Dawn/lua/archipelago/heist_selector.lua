local FileIdent = "HeistSelector"

function CrimDawn:NextHeist(HeistsWon)
  if Global.CrimDawn.data.game.campaign then self:CampaignHeist(HeistsWon) return end

  local TierIndex = (6 - Global.CrimDawn.data.game.run_length) + (HeistsWon or 0) + 1
  
  local ValidHeists = deep_clone(Global.CrimDawn.tables.heists)
  local CurrentTier, NextHeist
  ValidHeists.dlc = nil

  for tier, heists in pairs(ValidHeists) do
    for i = #heists, 1, -1 do
      if CrimDawn.SettingsData[heists[i]] == false then table.remove(heists, i) end
    end
  end

  -- Remove already played heists from heist pool
  local PlayedHeists = {}
  local PrevHeists = Global.CrimDawn.data.game.previous_run

  for _, heist in ipairs(Global.CrimDawn.data.game.heists) do PlayedHeists[heist] = true end

  for tier, heistTable in pairs(ValidHeists) do
    local NewTable = {}

    for _, heist in ipairs(heistTable) do
      if not PlayedHeists[heist] and not PrevHeists[heist] then table.insert(NewTable, heist) end
    end

    ValidHeists[tier] = NewTable
  end

  -- If we haven't won yet, prevent pick from next tier
  if ValidHeists["tier" .. TierIndex] then

    -- Final Heist overrides
    if Global.CrimDawn.data.game.ponr <= 80 then ValidHeists.tier6 = { "short1", "short2" } -- Tutorials
    elseif not self.InfiniteTime() and Global.CrimDawn.data.game.ponr >= 1680 then
      ValidHeists.tier6 = { "cd_28stores" } -- 28 Stores
    end

    CurrentTier = ValidHeists["tier" .. TierIndex]

    NextHeist = CurrentTier[math.random(#CurrentTier)]
    assert(NextHeist ~= nil, "no available heists, are they all disabled?")

  -- If we HAVE won then ignore heist tiering
  else local AllValidHeists = {}
    for _, tier in pairs(ValidHeists) do
      for _, heist in ipairs(tier) do table.insert(AllValidHeists, heist) end
    end

    assert(#AllValidHeists > 0, "there are no heists left. maybe you should do something else?")
    NextHeist = AllValidHeists[math.random(#AllValidHeists)]
  end

  table.insert(Global.CrimDawn.data.game.heists, NextHeist)
  --NextHeist = Global.CrimDawn.data.game.heists[#Global.CrimDawn.data.game.heists]

  self:WriteSave(FileIdent, "next heist selected [" .. managers.localization:text("heist_" .. NextHeist) .. "]")
end

local campaigns = {
  ["Return Of The Rat"] = { "watchdogs_wrapper", "cd_firestarter1", "alex", "cd_hox2", "hox_3" },
  ["Murky Day"] = { "kosugi", "shoutout_raid", "pbr", "des" },
  ["I Need My Payday Too"] = { "big", "mus", "cd_miami1", "cd_miami2", "cd_hox1", "kenaz" },
  ["Greatest Heist Of All"] = { "cd_reservoir", "brb", "sah", "tag", "bph", "vit" },
  ["Silk Road"] = { "mex", "bex", "pex", "fex" },
  ["City Of Gold"] = { "chas", "chca", "pent" },
  ["Texas Heat"] = { "ranc", "corp", "deep" },
  ["Night Of Frights"] = { "hvh", "help", "nail", "haunted" },
  ["Holiday Special"] = { "pines", "cane", "moon" },
  ["Classics"] = { "red2", "run", "flat", "glace", "dah", "dinner" },
  ["You Guys No Fun"] = { "four_stores", "mallcrasher", "nightclub", "jolly", "shoutout_raid" },
  ["Follow The Money"] = { "branchbank_cash", "roberts", "brb", "bex", "red2", "big" },
  ["Death Of Democracy"] = { "cd_frame3", "cd_erection2", "cd_bigoil" },
  ["Gun Runners"] = { "cd_firestarter1", "jolly", "spa", "crojob2", "ranc", "mex" },
  ["Stealth Mission"] = { "tag", "fish", "dark", "kosugi", "cage" }
}

function CrimDawn:CampaignHeist(HeistsWon)
  local NextHeist
  if HeistsWon < #campaigns[Global.CrimDawn.data.game.goal] then
    NextHeist = campaigns[Global.CrimDawn.data.game.goal][HeistsWon + 1]
    log(NextHeist)
    -- DLC check...
    local FoundHeist
    for tier, _ in pairs(Global.CrimDawn.tables.heists) do
      for _, heist in ipairs(Global.CrimDawn.tables.heists[tier]) do
        if heist == NextHeist then FoundHeist = true break end
      end
    if FoundHeist then break end end

    assert(FoundHeist, "You don't own the next heist (" .. managers.localization:text("heist_" .. NextHeist) .. ")")
    table.insert(Global.CrimDawn.data.game.heists, NextHeist)

  else NextHeist = math.random(1, #campaigns[Global.CrimDawn.data.game.goal])
    table.insert(Global.CrimDawn.data.game.heists, NextHeist)
  end

  self.Log(FileIdent, NextHeist)
  self:WriteSave(FileIdent, "next heist selected")
end