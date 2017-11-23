function soul_drain_start(keys)
	local caster = keys.caster
	local ability = keys.ability
	local manacost = keys.manacost

	--entire function rendered pointless by order filter. lol
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_soul_drain", {})
	--[[if caster:GetHealth() < caster:GetMaxHealth() then
		print("Searching for corpse")
		local corpse = Corpses:FindClosestInRadius(caster:GetPlayerOwnerID(), caster:GetAbsOrigin(), 200)
		if corpse then
			print("Applying modifier")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_soul_drain", {})
			corpse:RemoveCorpse()
		else CEnfosGameMode:SendErrorMessage(caster:GetPlayerOwnerID(), "No usable corpses nearby") end
	else
		print("Already at max health")
		Timers:CreateTimer(DoUniqueString("soul_drain_cancel"), {
			endTime = 0.01,
			callback = function()
				ability:EndChannel(true)
				ability:EndCooldown()
				caster:GiveMana(manacost)
				--CEnfosGameMode:SendErrorMessage(caster:GetPlayerOwnerID(), "Already at full health")
			end
		})
		
	end]]
end

function soul_drain_heal(keys)
	keys.caster:Heal(keys.caster:GetMaxHealth() * (keys.ability:GetSpecialValueFor("heal") / 1000), keys.caster) -- 0.8% of his max health per tick. 10 ticks per second
	if keys.caster:GetHealth() >= keys.caster:GetMaxHealth() then
		keys.caster:Interrupt()
	end
end

function scalping_cry(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local sDuration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	for k,v in pairs(units) do
		ability:ApplyDataDrivenModifier(caster, v, "modifier_scalping_cry", {duration = sDuration})
	end
end

function bloodboil(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("health_drain", ability:GetLevel() - 1) / 10 -- ticks 10 times per second
	DealDamage(caster, caster, damage, DAMAGE_TYPE_PURE, 0)
end

function soul_feast_check(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.stolenUltimate ~= nil then
		sUltimate = caster.stolenUltimate
		sUltimateIndex = caster:FindAbilityByName(sUltimate)
		if not sUltimateIndex:IsCooldownReady() then
			caster:SwapAbilities("troll_cannibal_soul_feast", sUltimate, true, false)
			if sUltimate == "moon_mage_burn" then
				caster:FindAbilityByName("generic_focus_moonbeam"):EndCooldown()
				caster:SwapAbilities("troll_cannibal_soul_drain", "generic_focus_moonbeam", true, false)
				caster:RemoveAbility("generic_focus_moonbeam")
			end
			if sUltimate == "faenrae_champion_inner_chaos" then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_soul_feast_inner_chaos_bat", {duration = 30})
			end
			ability:SetLevel(sUltimateIndex:GetLevel())
			ability:EndCooldown()
			sUltimateIndex:EndCooldown() -- should I?
			--caster:RemoveAbility(sUltimate)
			caster.stolenUltimate = nil
		else
			return
		end
	end
end

function soul_feast_passive_check(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:SwapAbilities("troll_cannibal_soul_feast", caster.passiveAbility, true, false)
	ability:SetLevel(caster:FindAbilityByName(caster.passiveAbility):GetLevel())
	ability:EndCooldown()
	--caster:RemoveAbility(caster.passiveAbility)
	caster.stolenUltimate = nil
end
		
		
		
		
		
		
		
		