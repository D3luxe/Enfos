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

function HauntingSpirit(keys) -- this thinks every 10 seconds in kv
-- vars
	local caster = keys.caster
	local radius = keys.radius
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	if units[1] == nil then
		return
	end
	local randomUnit = units[math.random(1,#units)]
-- kill it and particles
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, randomUnit)
	ParticleManager:SetParticleControl(particle, 1, randomUnit:GetAbsOrigin())
	DealDamage(caster, randomUnit, 9999999, DAMAGE_TYPE_PURE, 0)
end
	
function AnimateDead(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local radius = keys.radius
	local unitsRaised = keys.units_raised
	--local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_DEAD, 1, false)
	local units = Corpses:FindInRadius(pid, caster:GetAbsOrigin(), radius)

	local thisSpell = caster:GetAbilityByIndex(0)
	if #units == 0 then
		thisSpell:EndCooldown()
		local manaCost = thisSpell:GetManaCost(thisSpell:GetLevel()-1)
		caster:GiveMana(manaCost)
		CEnfosGameMode:SendErrorMessage(pid, "No usable corpses nearby")
		return
	end
-- find all the nearby dead units and reraise them
	for i=1,math.min(unitsRaised,#units) do
		local raisedUnit = CreateUnitByName(units[i].unit_name, units[i]:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
		raisedUnit:SetControllableByPlayer(pid, true)
		raisedUnit:SetHullRadius(units[i].hullSize)
		raisedUnit.hullSize = units[i].hullSize --just in case
		FindClearSpaceForUnit(raisedUnit, raisedUnit:GetAbsOrigin(), true)
		ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_ABSORIGIN_FOLLOW, raisedUnit)
		thisSpell:ApplyDataDrivenModifier(raisedUnit, raisedUnit, "modifier_revenant_animate_dead_buff", {})
		units[i]:RemoveCorpse()
		raisedUnit:SetRenderColor(0, 84, 255)
		raisedUnit:CreatureLevelUp(math.floor(GameRules.DIFFICULTY+(0.25*GameRules.DIFFICULTY)-1))
		raisedUnit:SetNoCorpse()

		AddTypes(raisedUnit, units[i].armorType, units[i].attackType)
		
		keys.ability:ApplyDataDrivenModifier(caster, raisedUnit, "modifier_purification_target", {})
		raisedUnit:AddNewModifier(raisedUnit, nil, "modifier_kill", {duration = keys.duration})
	end
	caster:EmitSound("Hero_ObsidianDestroyer.ArcaneOrb.Impact")
end

function CorpseExplosion(keys)
-- vars
	local caster = keys.caster
	local damage = keys.damage -- this is a percentage of the corpse's max life
	local radius = keys.radius
	local ability = keys.ability
	local searchrange = keys.searchrange
	local spell = caster:FindAbilityByName("revenant_corpse_explosion")
	local pid = caster:GetPlayerID()
	local units = Corpses:FindInRadius(pid, caster:GetAbsOrigin(), searchrange)
-- fail if no units found.
	if units[1] == nil then
		spell:EndCooldown()
		local manaCost = spell:GetManaCost(spell:GetLevel()-1)
		caster:GiveMana(manaCost)
		CEnfosGameMode:SendErrorMessage(pid, "No usable corpses nearby")
		return
	end
	local targetUnits = FindUnitsInRadius(caster:GetTeamNumber(), units[1]:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
-- deal the damage and detonate the corpse
	print(units[1].bomb_health * (damage/100))
	for k,v in pairs(targetUnits) do
		--DealDamage(caster, v, validTargets[1]:GetMaxHealth() * (damage/100), DAMAGE_TYPE_MAGICAL, 0)
		local dTable = {
			victim = v,
			attacker = caster,
			damage = units[1].bomb_health * (1/3),
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR,
			ability = ability
		}
		ApplyDamage(dTable)
	end
	local corpsedummy = FastDummy(units[1]:GetAbsOrigin(), caster:GetTeamNumber())
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, corpsedummy)
	--ParticleManager:SetParticleControl(particle, 62, Vector(radius, 0, 400))
	ParticleManager:SetParticleControl(particle, 4, corpsedummy:GetAbsOrigin())
	units[1]:EmitSound("Hero_LifeStealer.Consume")
	corpsedummy:ForceKill(false)
	--DelayDestroy(units[1], 0.2)
	units[1]:RemoveCorpse()
end
		
function SpiritualSwarmCast(keys)
-- vars
	local caster = keys.caster
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false) -- guessing on radius
	Enfos.spiritualSwarmJumps = keys.jumps -- works a bit poorly with cooldown refresh. figure something out?
	for i=1,4 do
		if units[i] == nil then
			return
		end
		local info = {
			EffectName = "particles/units/heroes/hero_weaver/weaver_base_attack.vpcf",
			Ability = caster:GetAbilityByIndex(3),
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = 800,
			fStartRadius = 125,
			fEndRadius = 125,
			Target = units[i],
			Source = caster,
			iMoveSpeed = 800,
			bReplaceExisting = false,
			bHasFrontalCone = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEM,
			iUnitTargetFlags = 0,
			iUnitTargetType = DOTA_UNIT_TARGET_CREEP,
			fExpireTime = GameRules:GetGameTime() + 10
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end
end

function SpiritualSwarmJump(keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	Enfos.spiritualSwarmJumps = Enfos.spiritualSwarmJumps - 1
	print (Enfos.spiritualSwarmJumps)
-- make sure we have enough jumps left
	if Enfos.spiritualSwarmJumps < 1 then
		return
	end
-- find units and put them into a table if they're valid
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
	if units[1] == nil then
		return
	end
	local validTargets = {}
	for k,v in pairs(units) do
		if not v:HasModifier("modifier_revenant_spiritual_swarm_debuff") then
			table.insert(validTargets, v)
		end
	end
	if validTargets[1] == nil then
		return
	end
-- select a new random target
	local bounceTarget = validTargets[math.random(1,#validTargets)]
	local info = {
		EffectName = "particles/units/heroes/hero_weaver/weaver_base_attack.vpcf",
		Ability = caster:GetAbilityByIndex(3),
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = 800,
		fStartRadius = 125,
		fEndRadius = 125,
		Target = bounceTarget,
		Source = target,
		iMoveSpeed = 800,
		bReplaceExisting = false,
		bHasFrontalCone = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEM,
		iUnitTargetFlags = 0,
		iUnitTargetType = DOTA_UNIT_TARGET_CREEP,
		fExpireTime = GameRules:GetGameTime() + 10
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
