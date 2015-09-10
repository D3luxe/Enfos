if Stats == nil then
  print ( '[Stats] creating Stats' )
  Stats = {}
  Stats.__index = Stats
end

-- Custom Stat Values
DMG_PER_STAT = 2.5
HP_PER_STR = 40
HP_REGEN_PER_STR = 0.03
MANA_PER_INT = 16
MANA_REGEN_PER_INT = 0.05
ARMOR_PER_AGI = 0.05
ATKSPD_PER_AGI = 2
MAX_MOVE_SPEED = 522

-- Default Dota Values
DEFAULT_DMG_PER_STAT = 1
DEFAULT_HP_PER_STR = 19
DEFAULT_HP_REGEN_PER_STR = 0.03
DEFAULT_MANA_PER_INT = 13
DEFAULT_MANA_REGEN_PER_INT = 0.04
DEFAULT_ARMOR_PER_AGI = 0.14
DEFAULT_ATKSPD_PER_AGI = 1

THINK_INTERVAL = 0.25

function Stats:ModifyStatBonuses(unit)
	local hero = unit
	local applier = CreateItem("item_stat_modifier", nil, nil)

	local hp_adjustment = HP_PER_STR - DEFAULT_HP_PER_STR
	local hp_regen_adjustment = HP_REGEN_PER_STR - DEFAULT_HP_REGEN_PER_STR
	local mana_adjustment = MANA_PER_INT - DEFAULT_MANA_PER_INT
	local mana_regen_adjustment = MANA_REGEN_PER_INT - DEFAULT_MANA_REGEN_PER_INT
	local armor_adjustment = ARMOR_PER_AGI - DEFAULT_ARMOR_PER_AGI
	local attackspeed_adjustment = ATKSPD_PER_AGI - DEFAULT_ATKSPD_PER_AGI
	local damage_adjustment = DMG_PER_STAT - DEFAULT_DMG_PER_STAT

	print("Modifying Stats Bonus of hero "..hero:GetUnitName())

	Timers:CreateTimer(function()

		if not IsValidEntity(hero) then
			return
		end

		-- Initialize value tracking
		if not hero.custom_stats then
			hero.custom_stats = true
			hero.strength = 0
			hero.agility = 0
			hero.intellect = 0
			hero.movespeed = 0
			hero.damage_bonus = 0
		end

		-- Get player attribute values
		local strength = hero:GetStrength()
		local agility = hero:GetAgility()
		local intellect = hero:GetIntellect()
		local movespeed = hero:GetIdealSpeed()
		local damageStat = hero:GetPrimaryStatValue()
		-- Adjustments

		-- STR
		if strength ~= hero.strength then
			--print("Strength: "..strength.." | hero.strength: "..hero.strength)
			-- HP Bonus
			if not hero:HasModifier("modifier_health_bonus") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_bonus", {})
			end

			local health_stacks = strength * hp_adjustment
			--print("Giving "..health_stacks.." health stacks of "..hp_adjustment.." adjustment")
			hero:SetModifierStackCount("modifier_health_bonus", hero, health_stacks)

			-- HP Regen Bonus
			if not hero:HasModifier("modifier_health_regen_constant") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_regen_constant", {})
			end

			local health_regen_stacks = strength * hp_regen_adjustment * 100
			hero:SetModifierStackCount("modifier_health_regen_constant", hero, health_regen_stacks)

		end

		-- AGI
		if agility ~= hero.agility then

			-- Attack Speed Bonus
			if not hero:HasModifier("modifier_attackspeed_bonus_constant") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_attackspeed_bonus_constant", {})
			end

			local attackspeed_stacks = agility * attackspeed_adjustment
			hero:SetModifierStackCount("modifier_attackspeed_bonus_constant", hero, attackspeed_stacks)

			-- Armor bonus
			-- To remove armor (such as in Enfos 20 agi = 1 armor instead of 7 agi) you have to also remove the default armor gained
			local armorAdjustment = (ARMOR_PER_AGI * agility) - (DEFAULT_ARMOR_PER_AGI * agility)
			hero:SetPhysicalArmorBaseValue(armorAdjustment)
			
		end

		-- INT
		if intellect ~= hero.intellect then
			
			-- Mana Bonus
			if not hero:HasModifier("modifier_mana_bonus") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_mana_bonus", {})
			end

			local mana_stacks = intellect * mana_adjustment
			hero:SetModifierStackCount("modifier_mana_bonus", hero, mana_stacks)

			-- Mana Regen Bonus
			if not hero:HasModifier("modifier_base_mana_regen") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_base_mana_regen", {})
			end

			local mana_regen_stacks = intellect * mana_regen_adjustment * 100
			hero:SetModifierStackCount("modifier_base_mana_regen", hero, mana_regen_stacks)
		end

		-- MS limit
		if movespeed ~= hero.movespeed and movespeed > MAX_MOVE_SPEED then

			if not hero:HasModifier("modifier_movespeed_minus_constant") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_movespeed_minus_constant", {})
			end

			local minus_ms_stacks = movespeed - MAX_MOVE_SPEED
			hero:SetModifierStackCount("modifier_movespeed_minus_constant", hero, minus_ms_stacks)
		end

		-- Damage

		-- Get player primary stat value
		if damageStat ~= hero.damage_bonus then
			if not hero:HasModifier("modifier_damage_bonus") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_damage_bonus", {})
			end

			local damage_stacks = damageStat
			--print("Giving "..damage_stacks.." stacks of "..damage_adjustment.." damage")
			hero:SetModifierStackCount("modifier_damage_bonus", hero, damage_stacks)
		end

		-- Update the stored values for next timer cycle
		hero.strength = strength
		hero.agility = agility
		hero.intellect = intellect
		hero.movespeed = movespeed
		hero.damage_bonus = damageStat

		hero:CalculateStatBonus()
		
		return THINK_INTERVAL
	end)
end