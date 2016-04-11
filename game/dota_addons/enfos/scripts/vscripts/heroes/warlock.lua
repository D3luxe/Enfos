--[[
	Based off a script by Noya
]]
function EnergyDrainTransfer( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local mana_drain = ability:GetLevelSpecialValueFor("mana_per_second", ability:GetLevel() - 1)
	local tick_rate = ability:GetLevelSpecialValueFor( "tick_rate" , ability:GetLevel() - 1 )
	local MP_drain = mana_drain * tick_rate

	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		ability:OnChannelFinish(false)
		caster:Stop()
		return
	end
	
	if caster:HasModifier("modifier_energy_drain_channel_workaround") == false then
		target:RemoveModifierByNameAndCaster("modifier_energy_drain",caster)
	end
	-- Location variables
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()

	-- Distance variables
	local distance = (target_location - caster_location):Length2D()
	local direction = (target_location - caster_location):Normalized()
	
	-- Make sure that the caster always faces the target
	caster:SetForwardVector(direction)
	
	
	--Check to see if caster has enough mana
	if target:GetMana() < MP_drain then
		MP_drain = caster:GetMana()
	end
	target:SetMana(target:GetMana() - MP_drain)
	caster:GiveMana(MP_drain)
	
end

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

	local enmPlayer = 0
	enmPlayer = RandomInt(0, HeroList:GetHeroCount()) 
	local safetyValue = 0
	maxMana = 0

	while true do
		enmPlayer = RandomInt(0, HeroList:GetHeroCount())
		safetyValue = safetyValue + 1 -- shoutouts to infinite loops
		if safetyValue > 100 then
			break
		end
		if PlayerResource:GetTeam(enmPlayer) ~= PlayerResource:GetTeam(keys.caster:GetPlayerID()) and PlayerResource:IsValidPlayer( enmPlayer ) and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsHero() and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsAlive() and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():GetGold() > 1 then
			break
		end
	end

	local target = PlayerResource:GetPlayer(enmPlayer)
	if target == nil then
		print("ERROR: DISRUPT TARGET IS NIL")
		return
	end
	local targetHero = target:GetAssignedHero()
	local targetSB = targetHero.spellbringer

	if targetSB ~= nil then
		if targetSB:GetMana() ~= nil then 
			--print("SB has mana")
			maxMana = tonumber(targetSB:GetMana())
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
		caster.spellbringer:GiveMana(manaReplenished)
		ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, targetSB)
		targetSB:ReduceMana(manaStolen)
		--caster:GiveMana(manaReplenished)
	else
		keys.ability:EndCooldown()
	end

	--[[if spellbringers ~= nil then
		PrintTable(spellbringers)
		local sb = math.random(1, #spellbringers)

		local sbTarget = spellbringers[sb]
		print(sbTarget)
		if sbTarget ~= nil then
			if sbTarget:GetMana() ~= nil then 
				print("SB has mana")
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
	end]]
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
	--print(caster:GetHealth())
	local dmg = caster:GetHealth() * keys.damage / 100
	--print(dmg)
	--DealDamage(caster, caster, dmg, DAMAGE_TYPE_PURE, 0)
	ApplyDamage({ victim = caster, attacker = caster, damage = dmg, damage_type = DAMAGE_TYPE_PURE, ability = keys.ability})
	caster:SetMana(0)
end