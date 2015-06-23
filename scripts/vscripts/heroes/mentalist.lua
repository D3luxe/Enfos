function Dazzle(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
-- spell effect
	if Enfos.moonbeamActive[pid] == nil then
		print ("No beam!") -- ph. popup message possible?
		caster:FindAbilityByName("mentalist_dazzle"):EndCooldown()
		return
	end
	local units = FindUnitsInRadius(caster:GetTeamNumber(), Enfos.moonbeamActive[pid]:GetOrigin(), caster, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	for k,v in pairs(units) do
		DealDamage(caster, v, v:GetHealth()/2, DAMAGE_TYPE_PURE, 0)
		ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_trigger_swirl.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
	end
-- I create a temporary unit so that I don't have to delay the destruction of the beam, which could cause problems
	local dUnit = FastDummy(AdjustZ(Enfos.moonbeamActive[pid]:GetAbsOrigin(), -1536), caster:GetTeamNumber())
	local cPart = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_global_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, dUnit)
	Enfos.moonbeamActive[pid]:EmitSound("Hero_Luna.Eclipse.Cast")
-- destroy the moonbeam 
	Enfos.moonbeamActive[pid]:Destroy()
	Timers:RemoveTimer("moonbeam_timer" .. pid)
	Enfos.moonbeamActive[pid] = nil
-- destroy the particle after a brief delay (particle won't play if you destroy immediately)
	DelayDestroy(dUnit, 0.05) -- DelayDestroy is a function in enfos.lua
end

function SealOfDeflection(keys)
-- vars
	local caster = keys.caster
	local ability = keys.ability
	local damage_per_mana = ability:GetLevelSpecialValueFor("damage_per_mana", ability:GetLevel() - 1 )
	local absorption_percent = ability:GetLevelSpecialValueFor("absorption_tooltip", ability:GetLevel() - 1 ) * 0.01
	local damage = keys.Damage * absorption_percent
	local not_reduced_damage = keys.Damage - damage

	local caster_mana = caster:GetMana()
	local mana_needed = damage / damage_per_mana

	-- Check if the not reduced damage kills the caster
	local oldHealth = caster.OldHealth - not_reduced_damage

	-- If it doesnt then do the HP calculation
	if oldHealth >= 1 then

		-- If the caster has enough mana, fully heal for the damage done
		if mana_needed <= caster_mana then
			caster:SpendMana(mana_needed, ability)
			caster:SetHealth(oldHealth)
			
			-- Impact particle based on damage absorbed
			local particleName = "particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf"
			local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, Vector(mana_needed,0,0))
		else
			local newHealth = oldHealth - damage
			mana_needed =
			caster:SpendMana(mana_needed, ability)
			caster:SetHealth(newHealth)
		end
	end	
end

function SealOfDeflectionHealth(keys)
	local caster = keys.caster
	caster.OldHealth = caster:GetHealth()
end

-- Seal of Deflection code by Noya
-- https://github.com/Pizzalol/SpellLibrary/blob/SpellLibrary/game/dota_addons/spelllibrary/scripts/vscripts/heroes/hero_medusa/mana_shield.lua


function AuraSight(keys)
	keys.caster:SetMana(keys.caster:GetMana() + (keys.mana_regen / 10)) -- divided by ten since we're calling it ten times per second
end