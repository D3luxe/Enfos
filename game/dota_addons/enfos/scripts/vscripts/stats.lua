if Stats == nil then
  print ( '[Stats] creating Stats' )
  Stats = {}
  Stats.__index = Stats
end

-- Custom Stat Values
DMG_PER_STAT = 2.5
HP_PER_STR = 40
HP_REGEN_PER_STR = 0.03				--flat
RESIST_PER_STR = 0
MANA_PER_INT = 16
MANA_REGEN_PER_INT = 0.05			--flat
AMP_PER_INT = 0
ARMOR_PER_AGI = 0.05
ATKSPD_PER_AGI = 1
MOVE_SPEED_PER_AGI = 0.03
MAX_MOVE_SPEED = 522

-- Default Dota Values
DEFAULT_DMG_PER_STAT = 1

DEFAULT_HP_PER_STR = 18
DEFAULT_HP_PER_STR_HERO = 22.5
DEFAULT_HP_REGEN_PER_STR = 0.55			--percentage
DEFAULT_HP_REGEN_PER_STR_HERO = 0.69	--percentage
DEFAULT_RESIST_PER_STR = 0.08
DEFAULT_RESIST_PER_STR_HERO = 0.1

DEFAULT_MANA_PER_INT = 12
DEFAULT_MANA_PER_INT_HERO = 15
DEFAULT_MANA_REGEN_PER_INT = 1.8		--percentage
DEFAULT_MANA_REGEN_PER_INT_HERO = 2.25	--percentage
DEFAULT_AMP_PER_INT = 0.07
DEFAULT_AMP_PER_INT_HERO = 0.088

DEFAULT_ARMOR_PER_AGI = 0.16
DEFAULT_ATKSPD_PER_AGI = 1
DEFAULT_ATKSPD_PER_AGI_HERO = 1.25
DEFAULT_MOVE_SPEED_PER_AGI = 0.05
DEFAULT_MOVE_SPEED_PER_AGI_HERO = 0.063

THINK_INTERVAL = 0.25

function Stats:ModifyStatBonuses(unit)
	local hero = unit
	local applier = CreateItem("item_stat_modifier", nil, nil)
	local applier2 = CreateItem("item_stat_modifier_lua", nil, nil)

	--[[local hp_adjustment = HP_PER_STR - DEFAULT_HP_PER_STR
	local hp_regen_adjustment = HP_REGEN_PER_STR - DEFAULT_HP_REGEN_PER_STR
	local hp_regen_adjustment_flat = HP_REGEN_PER_STR
	local magic_resist_adjustment = RESIST_PER_STR - DEFAULT_RESIST_PER_STR
	local mana_adjustment = MANA_PER_INT - DEFAULT_MANA_PER_INT
	local mana_regen_adjustment = MANA_REGEN_PER_INT - DEFAULT_MANA_REGEN_PER_INT
	local mana_regen_adjustment_flat = MANA_REGEN_PER_INT
	local spell_amp_adjustment = AMP_PER_INT - DEFAULT_AMP_PER_INT
	local armor_adjustment = ARMOR_PER_AGI - DEFAULT_ARMOR_PER_AGI
	local attackspeed_adjustment = ATKSPD_PER_AGI - DEFAULT_ATKSPD_PER_AGI
	local damage_adjustment = DMG_PER_STAT - DEFAULT_DMG_PER_STAT]]
	
	local att = hero:GetPrimaryAttribute()
	
	--[[if att == DOTA_ATTRIBUTE_STRENGTH then
		hp_adjustment = HP_PER_STR - DEFAULT_HP_PER_STR_HERO
		hp_regen_adjustment = HP_REGEN_PER_STR - DEFAULT_HP_REGEN_PER_STR_HERO
		magic_resist_adjustment = RESIST_PER_STR - DEFAULT_RESIST_PER_STR_HERO
	end
	if att == DOTA_ATTRIBUTE_INTELLECT then
		local mana_adjustment = MANA_PER_INT - DEFAULT_MANA_PER_INT_HERO
		local mana_regen_adjustment = MANA_REGEN_PER_INT - DEFAULT_MANA_REGEN_PER_INT_HERO
		local spell_amp_adjustment = AMP_PER_INT - DEFAULT_AMP_PER_INT_HERO
	end
	if att == DOTA_ATTRIBUTE_AGILITY then
		local armor_adjustment = ARMOR_PER_AGI - DEFAULT_ARMOR_PER_AGI
		local attackspeed_adjustment = ATKSPD_PER_AGI - DEFAULT_ATKSPD_PER_AGI
	end]]

	print("Modifying Stats Bonus of hero "..hero:GetUnitName())

	Timers:CreateTimer(function()

		if not IsValidEntity(hero) then
			return
		end

		-- Initialize value tracking
		if not hero.custom_stats then
			hero.custom_stats = true
			hero.strength = 0
			hero.strength_gain = 0
			hero.strength_bonus = 0
			hero.strength_total = 0
			hero.agility = 0
			hero.agility_gain = 0
			hero.agility_bonus = 0
			hero.agility_total = 0
			hero.intellect = 0
			hero.intellect_gain = 0
			hero.intellect_bonus = 0
			hero.intellect_total = 0
			hero.movespeed = 0
			hero.speedagi = 0
			hero.speedbase = hero:GetBaseMoveSpeed()
			hero.damage_bonus = 0
			hero.attribute_level = 0
			
			for k, v in pairs(GameRules.HeroKV) do
				if hero:GetUnitName() == v.override_hero then
					hero.strength = v.AttributeBaseStrength2
					hero.strength_gain = v.AttributeStrengthGain2
					hero.agility = v.AttributeBaseAgility2
					hero.agility_gain = v.AttributeAgilityGain2
					hero.intellect = v.AttributeBaseIntelligence2
					hero.intellect_gain = v.AttributeIntelligenceGain2
				end
			end
			
			if not hero:HasModifier("modifier_movespeed_cap") then
				hero:AddNewModifier( hero, applier2, "modifier_movespeed_cap", {} )
			end
			
			local heroNetTable = {}
			heroNetTable[hero:GetPlayerID()] = {
				str = hero.strength,
				strbn = 0,
				agi = hero.agility,
				agibn = 0,
				int = hero.intellect,
				intbn = 0}
			CustomNetTables:SetTableValue("hero_data_live","stats",heroNetTable)
		end

		-- Get player attribute values
		local strength = hero.strength + hero.strength_bonus
		local agility = hero.agility + hero.agility_bonus
		local intellect = hero.intellect + hero.intellect_bonus
		local movespeed = hero:GetIdealSpeed()
		local basespeed = hero:GetBaseMoveSpeed()
		local damageStat = 0
		local damageStatBase = 0
		local damageStatPlus = 0
		if att == DOTA_ATTRIBUTE_STRENGTH then
			damageStat = strength
			damageStatBase = hero.strength
			damageStatPlus = hero.strength_bonus
		end
		if att == DOTA_ATTRIBUTE_AGILITY then
			damageStat = agility
			damageStatBase = hero.agility
			damageStatPlus = hero.agility_bonus
		end
		if att == DOTA_ATTRIBUTE_INTELLECT then
			damageStat = intellect
			damageStatBase = hero.intellect
			damageStatPlus = hero.intellect_bonus
		end
		-- Adjustments

		-- STR
		if strength ~= hero.strength_total then
			--print("Strength: "..strength.." | hero.strength: "..hero.strength)
			-- HP Bonus
			if not hero:HasModifier("modifier_health_bonus") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_bonus", {})
			end

			--local health_stacks = strength * hp_adjustment
			local health_stacks = strength * HP_PER_STR
			--print("Giving "..health_stacks.." health stacks of "..hp_adjustment.." adjustment")
			hero:SetModifierStackCount("modifier_health_bonus", hero, health_stacks)

			-- HP Regen Bonus (percentage)
			--[[if not hero:HasModifier("modifier_health_regen_percentage") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_regen_percentage", {})
			end

			local health_regen_p_stacks = strength * hp_regen_adjustment * 100
			hero:SetModifierStackCount("modifier_health_regen_percentage", hero, health_regen_p_stacks)]]
			
			-- HP Regen Bonus (flat)
			if not hero:HasModifier("modifier_health_regen_constant") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_regen_constant", {})
			end

			--local health_regen_stacks = strength * hp_regen_adjustment_flat * 100
			local health_regen_stacks = strength * HP_REGEN_PER_STR * 100
			hero:SetModifierStackCount("modifier_health_regen_constant", hero, health_regen_stacks)
			
			--Magic Resist
			--[[local magic_resist_stacks = strength * magic_resist_adjustment * 100
			if not hero:HasModifier("modifier_magical_resistance_bonus") then
				hero:AddNewModifier( hero, applier2, "modifier_magical_resistance_bonus", {} )
				hero:SetModifierStackCount("modifier_magical_resistance_bonus", hero, magic_resist_stacks)
			end]]
			
			print("STR: Was "..hero.strength_total..", Now "..strength)

		end

		-- AGI
		if agility ~= hero.agility_total then

			-- Attack Speed Bonus
			if not hero:HasModifier("modifier_attackspeed_bonus_constant") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_attackspeed_bonus_constant", {})
			end

			--local attackspeed_stacks = agility * attackspeed_adjustment
			local attackspeed_stacks = agility * ATKSPD_PER_AGI
			hero:SetModifierStackCount("modifier_attackspeed_bonus_constant", hero, attackspeed_stacks)

			-- Armor bonus
			-- To remove armor (such as in Enfos 20 agi = 1 armor instead of 7 agi) you have to also remove the default armor gained
			
			--local armorAdjustment = (ARMOR_PER_AGI * agility) - (DEFAULT_ARMOR_PER_AGI * agility) + (hero.baseArmor - 2)
			local armorAdjustment = (ARMOR_PER_AGI * hero.agility) + hero.baseArmor
			hero:SetPhysicalArmorBaseValue(armorAdjustment)
			if not hero:HasModifier("modifier_physical_armor_bonus") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_physical_armor_bonus", {})
			end
			local armorAdjustment = ARMOR_PER_AGI * hero.agility_bonus * 100
			hero:SetModifierStackCount("modifier_physical_armor_bonus", hero, armorAdjustment)
			
			--Move Speed Bonus
			hero:SetBaseMoveSpeed(hero.speedbase + (MOVE_SPEED_PER_AGI * agility))
			
			print("AGI: Was "..hero.agility_total..", Now "..agility)
			
		end

		-- INT
		if intellect ~= hero.intellect_total then
			
			-- Mana Bonus
			if not hero:HasModifier("modifier_mana_bonus") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_mana_bonus", {})
				hero:GiveMana(1)
			end

			--local mana_stacks = (intellect * mana_adjustment) -1
			local mana_stacks = intellect * MANA_PER_INT
			hero:SetModifierStackCount("modifier_mana_bonus", hero, mana_stacks)

			-- Mana Regen Bonus (percentage)
			--[[if not hero:HasModifier("modifier_mana_regen_percentage") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_mana_regen_percentage", {})
			end

			local mana_regen_p_stacks = intellect * mana_regen_adjustment * 100
			hero:SetModifierStackCount("modifier_mana_regen_percentage", hero, mana_regen_p_stacks)]]
			
			-- Mana Regen Bonus (flat)
			if not hero:HasModifier("modifier_base_mana_regen") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_base_mana_regen", {})
			end

			--local mana_regen_stacks = intellect * mana_regen_adjustment_flat * 100
			local mana_regen_stacks = intellect * MANA_REGEN_PER_INT * 100
			hero:SetModifierStackCount("modifier_base_mana_regen", hero, mana_regen_stacks)
			
			-- Spell Amp
			--[[local spell_amp_stacks = intellect * spell_amp_adjustment * 100
			if not hero:HasModifier("modifier_spell_amplify_percentage") then
				hero:AddNewModifier( hero, applier2, "modifier_spell_amplify_percentage", {} )
				hero:SetModifierStackCount("modifier_spell_amplify_percentage", hero, spell_amp_stacks)
			end]]
			
			print("INT: Was "..hero.intellect_total..", Now "..intellect)
			
		end

		-- MS limit
		--[[if movespeed ~= hero.movespeed and movespeed > MAX_MOVE_SPEED then

			if not hero:HasModifier("modifier_movespeed_minus_constant") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_movespeed_minus_constant", {})
			end
			
			local minus_ms_stacks = movespeed - MAX_MOVE_SPEED
			hero:SetModifierStackCount("modifier_movespeed_minus_constant", hero, minus_ms_stacks)
			
		end]]

		-- Damage

		-- Get player primary stat value
		if damageStat ~= hero.damage_bonus then
			if not hero:HasModifier("modifier_damage_bonus") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_damage_bonus", {})
			end

			local damage_stacks = damageStatBase
			--print("Giving "..damage_stacks.." stacks of "..damage_adjustment.." damage")
			hero:SetModifierStackCount("modifier_damage_bonus", hero, damage_stacks)
			
			if not hero:HasModifier("modifier_damage_bonus_plus") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_damage_bonus_plus", {})
			end
			if not hero:HasModifier("modifier_damage_bonus_minus") then
				applier:ApplyDataDrivenModifier(hero, hero, "modifier_damage_bonus_minus", {})
				hero:SetModifierStackCount("modifier_damage_bonus_minus", hero, 1)
			end
			
			local damage_stacks_plus = damageStatPlus
			hero:SetModifierStackCount("modifier_damage_bonus_plus", hero, damage_stacks_plus+1)
		end
		
		-- Update the stored values for next timer cycle
		hero.strength_total = strength
		hero.agility_total = agility
		hero.intellect_total = intellect
		hero.movespeed = movespeed
		hero.damage_bonus = damageStat

		hero:CalculateStatBonus()
		
		return THINK_INTERVAL
	end)
end