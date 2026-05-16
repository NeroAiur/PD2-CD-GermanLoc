local upgrades = { skills = {}, perks = {}, stats = {}, deployable = {} }
local loc = managers.localization
local UpgradeStr, PermaHeader
local MenuTitle, MenuText

local function PermaUpgrade(upg_name, count)
  if upg_name == "permaskills" or upg_name == "permaperks" then
    local PermaType = upg_name:sub(6)

    if not PermaHeader and PermaType == "skills" and Global.CrimDawn.data.x.skills > 0 then
      table.insert(upgrades[PermaType], string.upper("Perma-skills:"))
      PermaHeader = true
    end

    for i = 1, Global.CrimDawn.data.x[upg_name] do
      UpgradeStr = "- " .. string.upper(loc:text("cd_perma" .. PermaType .. i .. "_name")) ..": "
        .. loc:text("cd_perma" .. PermaType .. i .. "_desc")
      table.insert(upgrades[PermaType], UpgradeStr)
    end

  else -- Directly add upgrade
    if not PermaHeader and Global.CrimDawn.data.x.skills > 0 then
      table.insert(upgrades.skills, string.upper("Perma-skills:"))
      PermaHeader = true
    end

    UpgradeStr = "- " .. string.upper(loc:text("cd_" .. upg_name .. count .. "_name")) ..": "
      .. loc:text("cd_" .. upg_name .. count .. "_desc", {
        SPEED = math.min(Global.CrimDawn.data.game.progression_items * 2, 99)
      })
    table.insert(upgrades.skills, UpgradeStr)
  end
end

if Global.CrimDawn.data.x.permaskills > 0 then PermaUpgrade("permaskills") end
if Global.CrimDawn.data.x.max_lives > 1 then PermaUpgrade("player_additional_lives_", Global.CrimDawn.data.x.max_lives - 1) end
if Global.CrimDawn.data.game.progression_items > 0 then PermaUpgrade("faster_objectives", "") end
if PermaHeader then table.insert(upgrades.skills, string.upper("\nRandom Skills:")) end

if Global.CrimDawn.data.x.permaperks > 0 then
  if Global.CrimDawn.data.x.perks > 0 then
    table.insert(upgrades.perks, string.upper("Perma-perks:"))
  end

  PermaUpgrade("permaperks")

  if Global.CrimDawn.data.x.perks > 0 then
    table.insert(upgrades.perks, string.upper("\nRandom Perks:"))
  end
end

for _, upgrade in ipairs(Global.CrimDawn.data.upgrades) do
  local tableName, upgradeName = upgrade:match("([^%-]+)%-(.+)")

  local currentUpgrade = Global.CrimDawn.tables.upgrades[tableName][upgradeName]
  UpgradeStr = "- " .. string.upper(loc:text("cd_" .. upgradeName .. "_name")) ..": "
            .. loc:text("cd_" .. upgradeName .. "_desc")

  table.insert(upgrades[tableName], UpgradeStr)
end

local function UpgradeMenu(Page)
  local MenuButtons = {
    [1] = { text = loc:text("crimdawn_upgrades_button_skills"),
            callback = CrimDawn.DisplaySkills },
    [2] = { text = loc:text("crimdawn_upgrades_button_perks"),
            callback = CrimDawn.DisplayPerks },
    [3] = { text = loc:text("crimdawn_upgrades_button_stats"),
            callback = CrimDawn.DisplayStats },
    [4] = { text = loc:text("crimdawn_upgrades_button_deploy"),
            callback = CrimDawn.DisplayDeploy },
    [5] = { text = loc:text("menu_back"),
            is_cancel_button = true }
  }

  table.remove(MenuButtons, Page)

  return QuickMenu:new(
    MenuTitle,
    MenuText,
    MenuButtons
  )
end

function CrimDawn.BuildUpgradeMenus()
  MenuTitle = loc:text("crimdawn_upgrades_title_skills")
  if next(upgrades.skills) then MenuText = table.concat(upgrades.skills, "\n")
  else MenuText = loc:text("crimdawn_upgrades_none") end
  CrimDawn.SkillsMenu = UpgradeMenu(1)

  MenuTitle = loc:text("crimdawn_upgrades_title_perks")
  if next(upgrades.perks) then MenuText = table.concat(upgrades.perks, "\n")
  else MenuText = loc:text("crimdawn_upgrades_none") end
  CrimDawn.PerksMenu = UpgradeMenu(2)

  MenuTitle = loc:text("crimdawn_upgrades_title_stats")
  if next(upgrades.stats) then MenuText = table.concat(upgrades.stats, "\n")
  else MenuText = loc:text("crimdawn_upgrades_none") end
  CrimDawn.StatsMenu = UpgradeMenu(3)

  MenuTitle = loc:text("crimdawn_upgrades_title_deploy")
  if next(upgrades.deployable) then MenuText = table.concat(upgrades.deployable, "\n")
  else MenuText = loc:text("crimdawn_upgrades_none") end
  CrimDawn.DeployMenu = UpgradeMenu(4)
end

function CrimDawn.CloseUpgradeMenus()
  CrimDawn.SkillsMenu:Hide()
  CrimDawn.PerksMenu:Hide()
  CrimDawn.StatsMenu:Hide()
  CrimDawn.DeployMenu:Hide()
end

function CrimDawn.DisplaySkills()
  CrimDawn.BuildUpgradeMenus()
  CrimDawn.CloseUpgradeMenus()
  CrimDawn.SkillsMenu:Show()
end

function CrimDawn.DisplayPerks()
  CrimDawn.BuildUpgradeMenus()
  CrimDawn.CloseUpgradeMenus()
  CrimDawn.PerksMenu:Show()
end

function CrimDawn.DisplayStats()
  CrimDawn.BuildUpgradeMenus()
  CrimDawn.CloseUpgradeMenus()
  CrimDawn.StatsMenu:Show()
end

function CrimDawn.DisplayDeploy()
  CrimDawn.BuildUpgradeMenus()
  CrimDawn.CloseUpgradeMenus()
  CrimDawn.DeployMenu:Show()
end