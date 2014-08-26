-- made ResetCooldowns slightly more efficient
-- fixed an infinite loop on StealMana
-- fixed FallenOne dealing no damage

function AddExperience(keys)
	keys.caster:GetPlayerOwner():GetAssignedHero():AddExperience (keys.expamt,false)
end

function ResetCooldowns(keys) 
	for i=0,4 do
		keys.target:GetPlayerOwner():GetAssignedHero():GetAbilityByIndex(i):EndCooldown()
	end
end

function StealMana(keys)
	--PrintTable(keys)
	maxMana = keys.caster:GetMaxMana()
	manaStolen = 0
	manaLeech = keys.manaLeech

	manaStolen = maxMana * manaLeech / 100
	keys.caster:GiveMana(manaStolen)

end

function DrainMana(keys)
	--print("Draining mana")
	maxMana = keys.target:GetMaxMana()
	manaDrain = keys.manaDrain
	manaStolen = maxMana * manaDrain / 100

	keys.caster:ReduceMana(manaStolen)
end

function StealManaDisrupt(keys)
	--print("Draining mana")
	--PrintTable(keys)
	enmPlayer = 0
	enmPlayer = RandomInt(0, HeroList:GetHeroCount()) 
	local safetyValue = 0
	maxMana = 0
	-- while PlayerResource:IsValidPlayer( enmPlayer ) do
	-- 	repeat
	-- 		enmPlayer = RandomInt(0, HeroList:GetHeroCount())
	-- 	until PlayerResource:GetTeam(enmPlayer) ~= PlayerResource:GetTeam(keys.caster:GetPlayerID())
	-- end

	while true do
		enmPlayer = RandomInt(0, HeroList:GetHeroCount())
		safetyValue = safetyValue + 1 -- shoutouts to infinite loops
		if safetyValue > 100 then
			break
		end
		if PlayerResource:GetTeam(enmPlayer) ~= PlayerResource:GetTeam(keys.caster:GetPlayerID()) and PlayerResource:IsValidPlayer( enmPlayer ) and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsHero() and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsAlive() then
			break
		end
	end

	if ( PlayerResource:IsValidPlayer( enmPlayer ) ) then
		maxMana = tonumber(PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():GetMana())
	else
		print("ENMPLAYER IS NOT VALID PLAYER")
	end
	
	manaDrain = tonumber(keys.manaReplenish)
	manaStolen = tonumber(keys.manaStolen)
	manaReplenished = 0
	if maxMana >= manaStolen then
		manaReplenished = manaStolen * manaDrain / 100
	elseif maxMana < manaStolen then
		manaStolen = maxMana
		manaReplenished = manaStolen * manaDrain / 100
	end

	--print(PlayerResource:GetPlayer(enmPlayer):GetAssignedHero())
	if ( PlayerResource:IsValidPlayer( enmPlayer ) ) then
		PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():ReduceMana(maxMana)
		keys.caster:GiveMana(manaReplenished)
	else
		print("ENMPLAYER IS NOT VALID PLAYER!")
	end
end

function EnergyFlare(keys)
	local caster = keys.caster
	local dmg = caster:GetMaxHealth() * keys.damage / 100
	local damageTable = {
		victim = keys.target,
		attacker = caster,
		damage = dmg,
		damage_type = DAMAGE_TYPE_PURE,
	}
	PrintTable(damageTable)
	--damageTable.victim = damageTable.victim.__self
	--PrintTable(damageTable)

	--ApplyDamage(damageTable)
	DealDamage(caster, caster, dmg, DAMAGE_TYPE_MAGICAL, 0)
end

function FallenOneHurtCaster(keys)
	keys.caster:SetHealth(1) -- you don't need to get the hero if you know the hero's gonna be the one casting it
end
function FallenOneHurtEnemies(keys)
	keys.target:SetHealth(1)
end

function ModelScale(keys)
	--PrintTable(keys)
	keys.caster:SetModelScale(keys.scale)
end

function Empower_Armor(keys)
	local strength = keys.caster:GetStrength()
	local healed = strength * 20

	keys.caster:Heal(healed, keys.caster)
end

function Permenant_Invisibility(keys)
	keys.caster:AddNewModifier(keys.caster, nil, "modifier_invisible", {})

	EnfosGameMode:CreateTimer(DoUniqueString("Kill Ward"), {
	useGameTime = true, 
	endTime = GameRules:GetGameTime() + keys.Duration, 
	callback = function(funct, args) 
		
		keys.caster:RemoveModifierByName("modifier_invisible")
			
	end})
end

function ModifyHealthStat(keys)
	local caster = keys.caster
	local pid = caster:GetPlayerID()


	Timers:CreateTimer("modify_stats" .. pid, {
		endTime = 0.03, 	
		callback = function()
			--Log health values
			local currentHealth = keys.caster:GetHealth()
			--print (string.format( "Current HP %d", currentHealth ) )
			local currentHealthDeficit = keys.caster:GetHealthDeficit()
			--print (string.format( "Current HP deficit %d", currentHealthDeficit ) )
			local maxHealth = keys.caster:GetMaxHealth()
			--print (string.format( "Max HP %d", maxHealth ) )

			--Log stat values
			local strength = keys.caster:GetStrength()
			local agility = keys.caster:GetAgility()
			local intelligence = keys.caster:GetIntellect()
			--print(agility)


			--Calculate and set player max hp
			local bonusHealth = strength * 40 + 10
			--print (string.format( "New Max HP %d", bonusHealth ) )
			keys.caster:SetMaxHealth(bonusHealth)

			local calculatedHPPercent = currentHealth / bonusHealth
			--print (string.format( "New health percent %d", calculatedHPPercent ) )

			maxHealth = keys.caster:GetMaxHealth()
			if bonusHealth ~= maxHealth then
				--Calculate and set player hp
				local newHealth = bonusHealth * calculatedHPPercent
				keys.caster:SetHealth(newHealth)
			end

				--Calculate armor
				--local bonusArmor = agility / 7 * -1
				--print(bonusArmor)
				--keys.caster:AddNewModifier(keys.caster, nil, "modifier_item_forcestaff_active", { push_length = 600 })

			return 0.1
		end
	})


end

function ModifyArmorStat(keys)
	local caster = keys.caster
	local pid = caster:GetPlayerID()

	Timers:CreateTimer("update_armor" .. pid, {
		endTime = 0.03, 	
		callback = function()
			--Log stat values
			local agility = keys.caster:GetAgility()

			--Create dummy unit
			local statUpdater = CreateItem("item_stats_modifier", nil, nil) 

			--Run check to determine how much negative armor needed
			if agility >= 7 and agility < 14 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_1", {})
			elseif agility >= 14  and agility < 20 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_2", {})
			elseif agility >= 28  and agility < 35 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_3", {})
			elseif agility >= 35  and agility < 40 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_4", {})
			elseif agility >= 49  and agility < 56 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_5", {})
			elseif agility >= 56  and agility < 60 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_6", {})
			elseif agility >= 70  and agility < 77 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_7", {})
			elseif agility >= 77  and agility < 80 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_8", {})
			elseif agility >= 91  and agility < 98 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_9", {})
			elseif agility >= 105 then
				statUpdater:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_armor_10", {})
			end


			return 2.0
		end
	})
end
