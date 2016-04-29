function Empower_Armor(keys)
	local caster = keys.caster
	local casterMana = caster:GetMana()
	local ability = caster:FindAbilityByName("generic_enfos_empower_armor")
	local manaCost = ability:GetManaCost(1)
	local cooldown = ability:GetCooldown(1)
	local cooldownRemaining = ability:GetCooldownTimeRemaining()
	local healMultiplier = ability:GetSpecialValueFor("heal_per_str")

	if casterMana >= manaCost and cooldownRemaining == 0 then
		caster:SetMana(casterMana - manaCost)
		caster:FindAbilityByName("generic_enfos_empower_armor"):StartCooldown(cooldown)
		--Heal caster
		local strength = caster:GetStrength()
		local healed = strength * healMultiplier

		caster:Heal(healed, keys.caster)

		--Play fx
		local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

		Timers:CreateTimer(DoUniqueString("destroyArmorParticle"), {
		endTime = 1,
		callback = function()
			if fx ~= nil then
				ParticleManager:DestroyParticle(fx, false)
			end
		end
		})

	end
end

function MagicInfuserSpendMana(keys)
	local caster = keys.caster
	local manaCost = keys.manacost
	local ability = keys.ability
	local radius = keys.radius
	
	local casterMana = caster:GetMana()
	if casterMana >= manaCost then
		caster:SetMana(casterMana - manaCost)
		ability:OnChannelFinish(false)
	end
end

function BracerShot(keys)
	local caster = keys.caster
	local ability = keys.ability
	local velocity = caster:GetForwardVector() * 1800
	local spawnpoint = caster:GetAbsOrigin()
	if caster:HasModifier("modifier_empower_bracers_proc") then
		return
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_empower_bracers_proc", {duration = 0.2})
	Timers:CreateTimer(DoUniqueString("brace"), {
		endTime = 0.4,
		callback = function()
			local shot = 
			{
				Ability = keys.ability,
				EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
				vSpawnOrigin = spawnpoint,
				fDistance = 500,
				fStartRadius = 150,
				fEndRadius = 150,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				fExpireTime = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit = false,
				vVelocity = velocity,
				bProvidesVision = false,
				iVisionRadius = 0,
				iVisionTeamNumber = nil
			}
			projectile = ProjectileManager:CreateLinearProjectile(shot)
			caster:EmitSound("Hero_Magnataur.ShockWave.Cast")
		end
	})					
	
end