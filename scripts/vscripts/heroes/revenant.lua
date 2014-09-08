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
	local spellDuration = keys.duration
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_DEAD, 1, false)
	local validTargets = {}
	if units[1] == nil then
		return
	end
	for k,v in pairs(units) do
		if not v:IsAlive() and not v.noCorpse then
			table.insert(validTargets, v)
		end
	end
	if Enfos.appliers[pid].AnimateDeadApplier == nil then
		Enfos.appliers[pid] = {AnimateDeadApplier = CreateItem('item_applier_animate_dead', nil, nil)} -- add it to the table
	end
	local applier = Enfos.appliers[pid].AnimateDeadApplier
-- find all the nearby dead units and reraise them
	for i=1,unitsRaised	do
		if validTargets[i] == nil then
			return
		end
		local raisedUnit = CreateUnitByName(validTargets[i]:GetUnitName(), validTargets[i]:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
		raisedUnit:SetControllableByPlayer(caster:GetPlayerID(), true)
		FindClearSpaceForUnit(raisedUnit, raisedUnit:GetAbsOrigin(), true)
		ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_ABSORIGIN_FOLLOW, raisedUnit)
		applier:ApplyDataDrivenModifier(caster, raisedUnit, "modifier_revenant_animate_dead_buff_" .. caster:GetAbilityByIndex(1):GetLevel(), {duration = spellDuration})
		validTargets[i]:Destroy()
	end
	caster:EmitSound("Hero_ObsidianDestroyer.ArcaneOrb.Impact")
end

-- function Deathwave(keys)
-- -- vars
	-- local caster = keys.caster
	-- local damage = keys.damage
	-- local radius = keys.radius
	-- local spellDuration = keys.duration
	-- local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	-- if Enfos.appliers[pid].DeathwaveApplier == nil then
		-- Enfos.appliers[pid] = {DeathwaveApplier = CreateItem('item_applier_animate_dead', nil, nil)} -- add it to the table
	-- end
	-- local applier = Enfos.appliers[pid].DeathwaveApplier
-- -- apply the spell. it's a simple one
	-- for k,v in pairs(units) do
		-- DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
		-- applier:ApplyDataDrivenModifier(caster, v, "modifier_revenant_deathwave_debuff_" .. caster:GetAbilityByIndex(2):GetLevel(), {duration = spellDuration})
		-- -- ParticleManager:CreateParticle("particle", PATTACH_ABSORIGIN_FOLLOW, v)
	-- end
-- end

function CorpseExplosion(keys)
-- vars
	local caster = keys.caster
	local damage = keys.damage -- this is a percentage of the corpse's max life
	local radius = keys.radius
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 400, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_DEAD, 1, false)
	local validTargets = {}
-- fail if no units found.
	if units[1] == nil then
		return
	end
-- place dead units into a table
	for k,v in pairs(units) do
		if not v:IsAlive() and not v.noCorpse then
			table.insert(validTargets, v)
		end
	end
-- fail if no units are dead
	if validTargets[1] == nil then
		return
	end
	local targetUnits = FindUnitsInRadius(caster:GetTeamNumber(), validTargets[1]:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
-- deal the damage and detonate the corpse
	for k,v in pairs(targetUnits) do
		DealDamage(caster, v, validTargets[1]:GetMaxHealth() / (100/damage), DAMAGE_TYPE_MAGICAL, 0)
	end
	local particle = ParticleManager:CreateParticle("particles/hero_revenant/revenant_corpse_explosion_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, validTargets[1])
	ParticleManager:SetParticleControl(particle, 62, Vector(radius, 0, 400))
	validTargets[1]:EmitSound("Hero_LifeStealer.Consume")
	DelayDestroy(validTargets[1], 0.2)
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
