function warlock_deflection(keys)
-- vars
	local caster = keys.caster
	local ability = keys.ability
	if ability ~= nil and ability:IsCooldownReady() and not caster:HasModifier("modifier_item_sphere_target") then
		caster:AddNewModifier(caster, ability, "modifier_item_sphere_target", {duration = -1})
	end
end

function warlock_deflection_thinker(keys)
-- checks to see if the sphere should be up
	local caster = keys.caster
	local ability = keys.ability
	if not caster:HasModifier("modifier_item_sphere_target") then
		if ability ~= nil and ability:IsCooldownReady() then
			caster:AddNewModifier(caster, ability, "modifier_item_sphere_target", {duration = -1})
		end
	end
end

function StealManaDisrupt(keys)
	local caster = keys.caster
	--print("Draining mana")
	--PrintTable(keys)
	enmPlayer = 0
	enmPlayer = RandomInt(0, HeroList:GetHeroCount()) 
	local safetyValue = 0
	maxMana = 0

	local spellbringers = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, 0, 0, false)
	if spellbringers ~= nil then
		local sb = math.random(1, #spellbringers)

		local sbTarget = spellbringers[sb]
		if sbTarget ~= nil then
			if sbTarget:GetMana() ~= nil then 
				maxMana = tonumber(sbTarget:GetMana())
				manaDrain = tonumber(keys.manaReplenish)
				manaStolen = tonumber(keys.manaStolen)
				manaReplenished = 0
				if maxMana >= manaStolen then
					manaReplenished = manaStolen * manaDrain / 100
				elseif maxMana < manaStolen then
					manaStolen = maxMana
					manaReplenished = manaStolen * manaDrain / 100
				end
			end
			print(caster.spellbringer)
			caster.spellbringer:GiveMana(manaReplenished)
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, sbTarget)

			sbTarget:ReduceMana(maxMana)
			caster:GiveMana(manaReplenished)
		end
	else
		keys.ability:EndCooldown()
	end
end

function Spellcurse(keys)
	local caster = keys.caster
	local target = keys.target
	local thisSpell = caster:FindAbilityByName("warlock_enfos_spellcurse")

	local spellbringer = target.spellbringer
	
	thisSpell:ApplyDataDrivenModifier(caster, spellbringer, "modifier_spellcurse", {})
end

function EnergyFlare(keys)
	local caster = keys.caster
	local dmg = caster:GetMaxHealth() * keys.damage / 100
	DealDamage(caster, caster, dmg, DAMAGE_TYPE_PURE, 0)
end