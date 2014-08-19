--[[
relevant KV files:
	npc_abilities_custom.txt
		"mentalist_dazzle"
this spell uses frota timers
this spell uses a table that is defined during game mode initialization (EnfosMod.moonbeamActive) to store the moonbeams
]]
function Dazzle(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
-- spell effect
	if EnfosMod.moonbeamActive[pid] == nil then
		print ("No beam!") -- ph. popup message possible?
		caster:FindAbilityByName("mentalist_dazzle"):EndCooldown()
		return
	end
	local units = FindUnitsInRadius(caster:GetTeamNumber(), EnfosMod.moonbeamActive[pid]:GetOrigin(), caster, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	if units[1] ~= nil then
		for k,v in pairs(units) do
			v:SetHealth(v:GetHealth()/2)
		end
	end
-- placeholder particle. I create a temporary unit so that I don't have to delay the destruction of the beam, which would lead to shenanigans.
	local dUnit = CreateUnitByName("npc_dummy_unit", EnfosMod.moonbeamActive[pid]:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
	dUnit:AddNewModifier(dUnit, dUnit, "modifier_invulnerable", {})
	dUnit:AddNewModifier(dUnit, dUnit, "modifier_phased", {})
	local cPart = ParticleManager:CreateParticle("silencer_global_silence", PATTACH_ABSORIGIN_FOLLOW, dUnit)
-- destroy the moonbeam 
	EnfosMod.moonbeamActive[pid]:Destroy()
	EnfosMod:RemoveTimer("moonbeam_timer" .. pid)
	EnfosMod.moonbeamActive[pid] = nil
-- destroy the particle after a brief delay (particle won't play if you destroy immediately)
	EnfosMod:CreateTimer(DoUniqueString("mbdelay"), {
		useGameTime = true,
		endTime = GameRules:GetGameTime() + 0.1,
		callback = function(funct, args)			
			if dUnit then
				dUnit:Destroy()
			end
		end
	})
end

--[[
relevant KV files:
	npc_abilities_custom.txt
		"mentalist_seal_of_deflection"
this spell uses frota timers
this spell uses a table that is defined during game mode initialization (EnfosMod.globalValue1, EnfosMod.globalValue2) to store base armour value and MR value
if this is meant to only absorb physical damage, then there's no way to properly code it. this absorbs all damage, including pure damage and HP removal.
]]

function SealOfDeflectionOn(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local thisSpell = caster:FindAbilityByName("mentalist_seal_of_deflection")
	local percentBlocked = (0.5 + (thisSpell:GetLevel() * 0.05)) -- 0 = 0%, 1 = 100%. these vars are defined here because the original behaviour does not update the spell if you level it while active.
	local damageAbsorbedPerPoint = thisSpell:GetLevel()
	damageTaken = PlayerResource:GetCreepDamageTaken(pid) + PlayerResource:GetHeroDamageTaken(pid) -- you can also add PlayerResource:GetTowerDamageTaken(pid) if that's a thing
	currentHealth = caster:GetHealth() -- I need to get my old health as well as the damage taken
	arTotalValue = caster:GetPhysicalArmorValue() -- damage dealt which Seal of Deflection is active ignores armour. storing the armour value to retrieve later.
	arBonusValue = caster:GetPhysicalArmorValue() - caster:GetPhysicalArmorBaseValue()
	EnfosMod.globalValue1[pid] = caster:GetPhysicalArmorBaseValue()
	EnfosMod.globalValue2[pid] = caster:GetMagicalArmorValue()
-- start timer
	EnfosMod:CreateTimer("seal_timer" .. pid, {
		useGameTime = true,
		endTime = GameRules:GetGameTime() + 0.03, 	
		callback = function(funct, args)
			if caster:FindAbilityByName("mentalist_seal_of_deflection"):GetToggleState() then
-- second round of vars
				local casterMana = caster:GetMana()
				local oldTaken = damageTaken
				local oldHealth = currentHealth
				damageTaken = PlayerResource:GetCreepDamageTaken(pid) + PlayerResource:GetHeroDamageTaken(pid)
				currentHealth = caster:GetHealth()
				local healthDifference = damageTaken - oldTaken
-- spell logic
				caster:SetPhysicalArmorBaseValue(0 - arBonusValue) -- since we can't modify total armour value, we have to make the base equal to negative the amount of bonus armour
				caster:SetBaseMagicalResistanceValue(EnfosMod.globalValue2[pid] - EnfosMod.globalValue2[pid])
				if damageTaken > oldTaken then
					if casterMana * damageAbsorbedPerPoint > healthDifference * (1 - percentBlocked) then -- we have enough mana left to fully absorb this hit
						if 0 > oldHealth - (healthDifference * (1 - percentBlocked)) then -- calculate if the damage is fatal even with full block
							local blastPart = ParticleManager:CreateParticle("medusa_mana_shield_shatter", PATTACH_ABSORIGIN_FOLLOW, caster) -- placeholder particle thing
							EnfosMod:CreateTimer(DoUniqueString("dthtmr"), { -- slight delay for the particle
								useGameTime = true,
								endTime = GameRules:GetGameTime() + 0.03, 	
								callback = function(funct, args)
									caster:ForceKill(false)
								end
							})
						end
						caster:SetHealth(oldHealth - (healthDifference * (1 - percentBlocked))) -- undo the non-fatal damage
						currentHealth = caster:GetHealth()
						caster:SetMana(casterMana - ((healthDifference * percentBlocked) / damageAbsorbedPerPoint)) -- drain the mana from the shield
						local blastPart = ParticleManager:CreateParticle("medusa_mana_shield_impact", PATTACH_ABSORIGIN_FOLLOW, caster) -- placeholder particle
						ParticleManager:SetParticleControl(blastPart,1,Vector(healthDifference * percentBlocked,0,0))
					elseif casterMana * damageAbsorbedPerPoint < healthDifference then -- we don't have enough mana to fully absorb this hit
						if 0 > (oldHealth - (healthDifference * (1 - percentBlocked))) - ((healthDifference * percentBlocked) - (casterMana * damageAbsorbedPerPoint)) then -- calculate if the damage is fatal even with partial block
							local blastPart = ParticleManager:CreateParticle("medusa_mana_shield_shatter", PATTACH_ABSORIGIN_FOLLOW, caster)
							EnfosMod:CreateTimer(DoUniqueString("dthtmr"), {
								useGameTime = true,
								endTime = GameRules:GetGameTime() + 0.03, 	
								callback = function(funct, args)
									caster:ForceKill(false)
								end
							})
						end
						caster:SetMana(0) -- all our mana is drained by the block
						caster:SetHealth((oldHealth - (healthDifference * (1 - percentBlocked))) - ((healthDifference * percentBlocked) - (casterMana * damageAbsorbedPerPoint))) -- undo the non-fatal damage
						currentHealth = caster:GetHealth()
						local blastPart = ParticleManager:CreateParticle("medusa_mana_shield_shatter", PATTACH_ABSORIGIN_FOLLOW, caster)
						thisSpell:ToggleAbility()
					end
				end
-- restore and then reduce the values again to recalculate changes
				caster:SetPhysicalArmorBaseValue(EnfosMod.globalValue1[pid])
				caster:SetBaseMagicalResistanceValue(EnfosMod.globalValue2[pid])
				arTotalValue = caster:GetPhysicalArmorValue()
				arBonusValue = caster:GetPhysicalArmorValue() - caster:GetPhysicalArmorBaseValue()
				EnfosMod.globalValue1[pid] = caster:GetPhysicalArmorBaseValue()
				EnfosMod.globalValue2[pid] = caster:GetMagicalArmorValue()
				caster:SetPhysicalArmorBaseValue(arTotalValue - arTotalValue - arBonusValue)
				caster:SetBaseMagicalResistanceValue(EnfosMod.globalValue2[pid])
				return GameRules:GetGameTime() + 0.03
			end
		end
	})
end

function SealOfDeflectionOff(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
-- restore values that were zeroed out
	caster:SetPhysicalArmorBaseValue(EnfosMod.globalValue1[pid])
	caster:SetBaseMagicalResistanceValue(EnfosMod.globalValue2[pid])
end






































-- whitespace for my neck's sake. remove this when I'm done