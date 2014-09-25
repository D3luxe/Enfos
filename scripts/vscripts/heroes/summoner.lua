function AddTypes(mob, armor, attack)
	local spawnedUnitIndex = mob
	local armorType = armor
	local attackType = attack

	local armorItem = CreateItem("item_armor_type_modifier", nil, nil) 
	armorItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, armorType, {})
	UTIL_RemoveImmediate(armorItem)
	armorItem = nil

	local attackItem = CreateItem("item_attack_type_modifier", nil, nil) 
	attackItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, attackType, {})
	UTIL_RemoveImmediate(attackItem)
	attackItem = nil
end

function AntiMagicShell(keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	target:AddAbility("summoner_anti_magic_shell_proxy")
	local spell = target:FindAbilityByName("summoner_anti_magic_shell_proxy")
-- logic
	spell:SetHidden(false)
	spell:SetLevel(1)
	target:CastAbilityImmediately(spell, caster:GetPlayerID())
	spell:SetHidden(true)
end

function AntiMagicShellParticle(keys)
-- vars
	local target = keys.target
-- logic
	if not target:HasModifier("modifier_ember_spirit_flame_guard") then
		if target:HasModifier("summoner_anti_magic_spell_particle") then
			target:RemoveModifierByName("summoner_anti_magic_spell_particle")
		end
	end
end

function SummonHellbearWarriors(keys)
-- vars
	local caster = keys.caster
	local thisSpellLevel = caster:GetAbilityByIndex(0):GetLevel()
	local findUnits = Entities:FindAllByClassnameWithin("npc_dota_creature", caster:GetAbsOrigin(), 1000)
-- logic
	for k,v in pairs(findUnits) do
		if v:GetUnitName() == "npc_summoner_hellbear_warrior" and not v.summonerUnit then -- in case the cooldowns get refreshed, we don't want to upgrade existing units
			v:AddNewModifier(unit, nil, "modifier_phased", {duration = 3}) -- to prevent them from getting stuck
			v.summonerUnit = true 
			v:SetPhysicalArmorBaseValue(keys.armour)
			v:SetBaseAttackTime(keys.base_attack_time)
			v:SetBaseDamageMin(keys.damage)
			v:SetBaseDamageMax(keys.damage)
			v:SetMaxHealth(keys.health)
			v:SetHealth(keys.health)
			if thisSpellLevel < 3 then -- spells on units made with SpawnUnit start learned. we need to unlearn them here if necessary
				v:GetAbilityByIndex(0):SetLevel(0)
			end
			if thisSpellLevel < 5 then
				v:GetAbilityByIndex(1):SetLevel(0)
			end
			if thisSpellLevel < 7 then
				v:GetAbilityByIndex(2):SetLevel(0)
			end
			if thisSpellLevel < 10 then
				v:GetAbilityByIndex(3):SetLevel(0)
			end		
			AddTypes(v, "modifier_armor_heavy", "modifier_attack_normal")

		end
	end
end

function SummonSatyrRangers(keys) -- this violates DRY a bit, but whatever. it might need to be different in the future
-- vars
	local caster = keys.caster
	local thisSpellLevel = caster:GetAbilityByIndex(1):GetLevel()
	local findUnits = Entities:FindAllByClassnameWithin("npc_dota_creature", caster:GetAbsOrigin(), 1000)
-- logic
	for k,v in pairs(findUnits) do
		if v:GetUnitName() == "npc_summoner_satyr_ranger" and not v.summonerUnit then
			v:AddNewModifier(unit, nil, "modifier_phased", {duration = 3})
			v.summonerUnit = true
			v:SetBaseAttackTime(keys.base_attack_time)
			v:SetBaseDamageMin(keys.damage)
			v:SetBaseDamageMax(keys.damage)
			v:SetMaxHealth(keys.health)
			v:SetHealth(keys.health)
			if thisSpellLevel < 3 then
				v:GetAbilityByIndex(0):SetLevel(0)
			end
			if thisSpellLevel < 5 then
				v:GetAbilityByIndex(1):SetLevel(0)
			end
			if thisSpellLevel < 7 then
				v:GetAbilityByIndex(2):SetLevel(0)
			end
			if thisSpellLevel < 10 then
				v:GetAbilityByIndex(3):SetLevel(0)
			-- elseif thisSpellLevel == 10 then
				-- v:GetAbilityByIndex(3):ToggleAutoCast()
			end	
			AddTypes(v, "modifier_armor_medium", "modifier_attack_chaos")
		end
	end
end

function SummonDarkrift(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local target = keys.target_points[1]
	if Enfos.appliers[pid].SummonDarkriftApplier == nil then
		Enfos.appliers[pid] = {SummonDarkriftApplier = CreateItem('item_applier_summon_darkrift', nil, nil)}
	end
	local applier = Enfos.appliers[pid].SummonDarkriftApplier
	local kvRound = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	local round = Enfos.curRound + 4
-- filter out invalid rounds
	if round == 20 then
		round = 19
	elseif round == 36 then
		round = 35
	elseif round > 42 then
		round = 42
	end
-- get the correct data
	local roundString = string.format("Round" .. round)
	local roundData = kvRound[roundString]
	local unitToSpawn = roundData.UnitFodder_1a.NPCName
-- spawn the unit
	for i=1,3 do
		local unit = CreateUnitByName(unitToSpawn, Vector(target.x+i*50, target.y+i*50, target.z), true, caster, caster, caster:GetTeamNumber())
		unit:SetInitialGoalEntity(nil) -- (should) stop the spawned units from trying to run to the goal.
		unit.summonerUnit = true
		AddTypes(unit, roundData.UnitFodder_1a.ArmorType, roundData.UnitFodder_1a.AttackType)
		for i=1,3 do -- I dunno why I need to FindClearSpaceForUnit a bunch, but I do
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		end
		unit:SetControllableByPlayer(caster:GetPlayerID(), true)
		applier:ApplyDataDrivenModifier(caster, unit, "modifier_summoner_summon_darkrift", {duration = 60})
		unit:AddNewModifier(unit, nil, "modifier_phased", {duration = 3})
		for i=1,15 do -- bit of a hacky way to make sure the units learn their abilities...
			if unit:GetAbilityByIndex(i) ~= nil then
				unit:GetAbilityByIndex(i):SetLevel(1)
			end
		end
		unit:SetRenderColor(0, 84, 255)
	end
end

function FlagOfSummoning(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local spellLevel = caster:GetAbilityByIndex(3):GetLevel()
	if Enfos.appliers[pid].FlagOfSummoningApplier == nil then
		Enfos.appliers[pid] = {FlagOfSummoningApplier = CreateItem('item_applier_flag_of_summoning', nil, nil)}
	end
	local applier = Enfos.appliers[pid].FlagOfSummoningApplier
	local findUnits = Entities:FindAllByClassnameWithin("npc_dota_creature", caster:GetAbsOrigin(), 2000)
-- logic
	for k,v in pairs(findUnits) do
		if v:GetUnitName() == "npc_summoner_flag_of_summoning" and not v.summonerUnit then
			v.summonerUnit = true
			v:SetForwardVector(Vector(v:GetForwardVector().x, v:GetForwardVector().y - 0.7, v:GetForwardVector().z))
			applier:ApplyDataDrivenModifier(caster, v, "modifier_summoner_flag_of_summoning_aura_" .. spellLevel, {duration = 102})
			Enfos.flagPos = v:GetAbsOrigin()
		end
	end
end
	
function CheckFlagValidity(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	if Enfos.appliers[pid].FlagOfSummoningApplier == nil then
		Enfos.appliers[pid] = {FlagOfSummoningApplier = CreateItem('item_applier_flag_of_summoning', nil, nil)}
	end
	local applier = Enfos.appliers[pid].FlagOfSummoningApplier
	local spellLevel = caster:GetAbilityByIndex(3):GetLevel()
	local radius = 1000 + (200 * spellLevel) -- be careful if there's ever a balance change on this skill. because we couldn't send the values from AbilitySpecial, we had to manually define the radius here.
	local findUnits = Entities:FindAllByClassnameWithin("npc_dota_creature", Enfos.flagPos, radius)
-- logic
	for k,v in pairs(findUnits) do
		if v.summonerUnit then
			applier:ApplyDataDrivenModifier(caster, v, "modifier_summoner_flag_of_summoning_" .. spellLevel, {duration = 1})
			if v:HasModifier("modifier_summoner_flag_of_summoning_" .. spellLevel - 1) then -- in case the flag is leveled up while it is active, so we don't have a temporary stack of modifiers
				v:RemoveModifierByName("modifier_summoner_flag_of_summoning_" .. spellLevel - 1)
			end
		end
	end
end

















