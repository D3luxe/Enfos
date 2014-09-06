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
	local damage = keys.DamageDealt
	local caster = keys.caster
	local percentBlocked = keys.damage_absorbed / 100
	local damageAbsorbedPerPoint = keys.damage_per_mana
	local thisSpell = keys.ability
	local currentHealth = caster:GetHealth()
	local casterMana = caster:GetMana()
	if casterMana * damageAbsorbedPerPoint > damage * (percentBlocked) then -- we have enough mana left to fully absorb this hit
		if 0 > currentHealth - (damage * (1 - percentBlocked)) then -- calculate if the damage is fatal even with full block
			local blastPart = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_shatter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) -- the mana shield explodes
			caster:ForceKill(false) -- we force kill the caster because it goes through the MODIFIER_PROPERTY_MIN_HEALTH modifier
		end
		--caster:SetHealth(currentHealth - (damage * (1 - percentBlocked))) -- undo the non-fatal damage
		Timers:CreateTimer(DoUniqueString("sodh"), {
		endTime = 0.001, 	
		callback = function()
			caster:Heal(damage * (percentBlocked), nil)
		end
		})
		currentHealth = caster:GetHealth()
		caster:SetMana(casterMana - ((damage * percentBlocked) / damageAbsorbedPerPoint)) -- drain the mana from the shield
		local blastPart = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) -- the mana shield particle fires
		ParticleManager:SetParticleControl(blastPart,1,Vector(damage * percentBlocked,0,0)) -- this controls how many shards fly off of the shield
	elseif casterMana * damageAbsorbedPerPoint < damage then -- we don't have enough mana to fully absorb this hit
		print("Not enough mana to fully absorb")
		if 0 > (currentHealth - (damage * (1 - percentBlocked))) - ((damage * percentBlocked) - (casterMana * damageAbsorbedPerPoint)) then -- calculate if the damage is fatal even with partial block
			local blastPart = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_shatter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			caster:EmitSound("Hero_Medusa.ManaShield.Proc")
			caster:ForceKill(false)
		end
		caster:SetMana(0) -- all our mana is drained by the block
		--caster:SetHealth((currentHealth - (damage * (percentBlocked))) - ((damage * percentBlocked) - (casterMana * damageAbsorbedPerPoint))) -- undo the non-fatal damage
		Timers:CreateTimer(DoUniqueString("sodh"), {
		endTime = 0.001, 	
		callback = function()
			caster:Heal((damage * (percentBlocked)) - ((damage * percentBlocked) - (casterMana * damageAbsorbedPerPoint)), nil)
		end
		})
		local blastPart = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_shatter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		caster:EmitSound("Hero_Medusa.ManaShield.Proc")
		thisSpell:ToggleAbility() -- the spell turns off
	end


end


function AuraSight(keys)
	keys.caster:SetMana(keys.caster:GetMana() + (keys.mana_regen / 10)) -- divided by ten since we're calling it ten times per second
end