function Prediction(keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	local pid = target:GetPlayerID() -- this is the target's pid, not the caster's pid!
	local maxIncrease = keys.attribute_increase
	if Enfos.strPrediction[pid] == nil then
		Enfos.strPrediction[pid] = 0
	end
	if Enfos.intPrediction[pid] == nil then
		Enfos.intPrediction[pid] = 0
	end
	if Enfos.agiPrediction[pid] == nil then
		Enfos.agiPrediction[pid] = 0
	end
	if caster == target then -- attribute penalty for self-targetting
		maxIncrease = maxIncrease - 2
	end 
-- reset the values
	target:SetBaseStrength(target:GetBaseStrength() - Enfos.strPrediction[pid])
	target:SetBaseAgility(target:GetBaseAgility() - Enfos.agiPrediction[pid])
	target:SetBaseIntellect(target:GetBaseIntellect() - Enfos.intPrediction[pid])
-- roll the increase
	local strIncreaseAmount = math.random(0,maxIncrease) -- we can't directly add it because we need this amount for the particles
	local agiIncreaseAmount = math.random(0,maxIncrease) -- we can't directly add it because we need this amount for the particles
	local intIncreaseAmount = math.random(0,maxIncrease) -- we can't directly add it because we need this amount for the particles
	local characters = string.len(tostring(strIncreaseAmount))
	Enfos.strPrediction[pid] = Enfos.strPrediction[pid] + strIncreaseAmount
	Enfos.agiPrediction[pid] = Enfos.agiPrediction[pid] + agiIncreaseAmount
	Enfos.intPrediction[pid] = Enfos.intPrediction[pid] + intIncreaseAmount
-- set the increase
	target:SetBaseStrength(target:GetBaseStrength() + Enfos.strPrediction[pid])
	target:SetBaseAgility(target:GetBaseAgility() + Enfos.agiPrediction[pid])
	target:SetBaseIntellect(target:GetBaseIntellect() + Enfos.intPrediction[pid])
-- particles and sounds
	local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff_symbol.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

	Timers:CreateTimer(DoUniqueString("strBonus"), {
		endTime = 0.01,
		callback = function()		
			local increaseParticleStr = ParticleManager:CreateParticle("particles/hero_hypnotist/hypnotist_increase_amount.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
			if strIncreaseAmount > 0 then
				ParticleManager:SetParticleControl(increaseParticleStr,1,Vector(100,strIncreaseAmount,0)) -- (plus sign, amount, symbol at the end [never used])
				ParticleManager:SetParticleControl(increaseParticleStr,2,Vector(characters + 1,0,0)) -- (plus sign, amount, symbol at the end [never used])
				ParticleManager:SetParticleControl(increaseParticleStr,3,Vector(255,0,0)) -- (plus sign, amount, symbol at the end [never used])
				target:EmitSound("Hero_WitchDoctor.Maledict_Cast")
			else
				ParticleManager:SetParticleControl(increaseParticleStr,1,Vector(2,0,0)) -- create a sad face
				ParticleManager:SetParticleControl(increaseParticleStr,2,Vector(1,0,0))
				ParticleManager:SetParticleControl(increaseParticleStr,3,Vector(255,255,255)) -- (plus sign, amount, symbol at the end [never used])
				target:EmitSound("Hero_WitchDoctor.Maledict_CastFail")
			end
		end
	})
	Timers:CreateTimer(DoUniqueString("agiBonus"), {
		endTime = 0.5,
		callback = function()		
			local increaseParticleAgi = ParticleManager:CreateParticle("particles/hero_hypnotist/hypnotist_increase_amount.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
			if agiIncreaseAmount > 0 then
				ParticleManager:SetParticleControl(increaseParticleAgi,1,Vector(100,agiIncreaseAmount,0)) -- (plus sign, amount, symbol at the end [never used])
				ParticleManager:SetParticleControl(increaseParticleAgi,2,Vector(characters + 1,0,0)) -- (plus sign, amount, symbol at the end [never used])
				ParticleManager:SetParticleControl(increaseParticleAgi,3,Vector(0,255,0)) -- (plus sign, amount, symbol at the end [never used])
			else
				ParticleManager:SetParticleControl(increaseParticleAgi,1,Vector(2,0,0)) -- create a sad face
				ParticleManager:SetParticleControl(increaseParticleAgi,2,Vector(1,0,0))
				ParticleManager:SetParticleControl(increaseParticleAgi,3,Vector(255,255,255)) -- (plus sign, amount, symbol at the end [never used])
				target:EmitSound("Hero_WitchDoctor.Maledict_CastFail")
			end
		end
	})
	Timers:CreateTimer(DoUniqueString("intBonus"), {
		endTime = 1,
		callback = function()		
			local increaseParticleInt = ParticleManager:CreateParticle("particles/hero_hypnotist/hypnotist_increase_amount.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
			if intIncreaseAmount > 0 then
				ParticleManager:SetParticleControl(increaseParticleInt,1,Vector(100,intIncreaseAmount,0)) -- (plus sign, amount, symbol at the end [never used])
				ParticleManager:SetParticleControl(increaseParticleInt,2,Vector(characters + 1,0,0)) -- (plus sign, amount, symbol at the end [never used])
				ParticleManager:SetParticleControl(increaseParticleInt,3,Vector(0,50,255)) -- (plus sign, amount, symbol at the end [never used])
			else
				ParticleManager:SetParticleControl(increaseParticleInt,1,Vector(2,0,0)) -- create a sad face
				ParticleManager:SetParticleControl(increaseParticleInt,2,Vector(1,0,0))
				ParticleManager:SetParticleControl(increaseParticleInt,3,Vector(255,255,255)) -- (plus sign, amount, symbol at the end [never used])
				target:EmitSound("Hero_WitchDoctor.Maledict_CastFail")
			end
		end
	})


	
-- recalculate the stats
	target:CalculateStatBonus()
end
	
function Hallucination(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local spellLevel = caster:GetAbilityByIndex(1):GetLevel()
	local target = keys.target
	local targetName = target:GetUnitName()
	local targetHealth = target:GetHealth()
-- make the unit and give it the modifiers
	local unit = CreateUnitByName(targetName, target:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	unit:SetHealth(targetHealth)
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
	if Enfos.appliers[pid].HallucinationApplier == nil then
		Enfos.appliers[pid] = {HallucinationApplier = CreateItem('item_applier_hallucination', nil, nil)} -- add it to the table
	end
	Enfos.appliers[pid].HallucinationApplier:ApplyDataDrivenModifier(caster, unit, "modifier_hypnotist_hallucination_" .. spellLevel, {})
end

function MindShout(keys) -- warning: the sound effect for this can get a bit loud.
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local hexDuration = keys.duration
	local radius = keys.radius
	if(Enfos.moonbeamActive[pid] ~= nil) then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), Enfos.moonbeamActive[pid]:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		for k,v in pairs(units) do
			v:AddNewModifier(caster, nil, "modifier_sheepstick_debuff", {duration = hexDuration})
		end
	end
end

function TelekineticStorm(keys)
-- vars
	local caster = keys.caster
	local damage = keys.damage
	local radius = keys.radius
	local spellDuration = keys.duration
	local slivers = keys.slivers
	local count = 0
-- if the cooldown is refreshed, we want to kill all the old units.
	--local oldUnits = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	local oldUnits = Entities:FindAllByClassname("npc_dota_base_additive")
	for k,v in pairs(oldUnits) do
		if v.telekineticStormDuration ~= nil then 
			v:Destroy()
			v = nil
		end
	end
-- initial release timer
	Timers:CreateTimer(DoUniqueString("slvr"), {
		endTime = 0.03,
		callback = function()
			count = count + 1
			local thisUnit = FastDummy(caster:GetAbsOrigin(), caster:GetTeamNumber())
			local movement = {}
			thisUnit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
			thisUnit:SetBaseMoveSpeed(500)
			thisUnit.telekineticStormDuration = GameRules:GetGameTime() + spellDuration
			ParticleManager:CreateParticle("particles/hero_hypnotist/bounty_hunter_suriken_toss_hidden_hunter.vpcf", PATTACH_OVERHEAD_FOLLOW, thisUnit)
			local vec = GetPointOnEdge(caster:GetAbsOrigin(), math.random(0,360), radius)
			local movement = {
				UnitIndex = thisUnit:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = vec,
				Queue = true
			}
			ExecuteOrderFromTable(movement)
-- thinker timer
			Timers:CreateTimer(DoUniqueString("slvrthnk"), {
				endTime = 1,
				callback = function()
					if thisUnit ~= nil then
						-- if the unit's duration is done, return to the caster then kill it
						if GameRules:GetGameTime() > thisUnit.telekineticStormDuration then
							-- this timer searches for the caster
							Timers:CreateTimer(DoUniqueString("slvrrtrn"), {
								endTime = 0.03,
								callback = function()
									thisUnit:Destroy()
									thisUnit:StopSound("Hero_Shredder.Chakram")
									thisUnit = nil
								end
							})
						end
						-- end the function if there's no unit
						if not thisUnit then
							return
						end
						-- end the function if the caster is dead
						if not caster:IsAlive() then
							thisUnit:Destroy()
							thisUnit = nil
							return
						end
						-- look for enemies if the unit is awake
						if not thisUnit.asleep then
							local unitsFound = FindUnitsInRadius(caster:GetTeamNumber(), thisUnit:GetAbsOrigin(), caster, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
							local unitsHurt = FindUnitsInRadius(caster:GetTeamNumber(), thisUnit:GetAbsOrigin(), caster, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
							-- we found a unit but weren't close enough to damage
							if unitsFound[1] and not unitsHurt[1] then
								movement = {
									UnitIndex = thisUnit:entindex(),
									OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
									Position = unitsFound[1]:GetAbsOrigin()
								}	
							-- we were close enough to damage
							elseif unitsHurt[1] then
								DealDamage(caster, unitsHurt[1], damage, DAMAGE_TYPE_MAGICAL, 0)
								unitsHurt[1]:EmitSoundParams("Hero_Shredder.WhirlingDeath.Damage", 100, 0.2, 1)
								thisUnit.strikeTimer = GameRules:GetGameTime() + 2
								thisUnit.asleep = true
								movement = {
									UnitIndex = thisUnit:entindex(),
									OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
									Position = caster:GetAbsOrigin()
								}	
							-- we didn't find a unit so return home
							else
								movement = {
									UnitIndex = thisUnit:entindex(),
									OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
									Position = Vector(caster:GetAbsOrigin().x + math.random(-1000, 1000), caster:GetAbsOrigin().y + math.random(-1000, 1000), caster:GetAbsOrigin().z)
								}							
							end
						-- the unit is asleep, so we return to dazzle in order to wake up
						elseif thisUnit.asleep then
							movement = {
								UnitIndex = thisUnit:entindex(),
								OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
								Position = caster:GetAbsOrigin(),
							}
							local dazzleFound = FindUnitsInRadius(caster:GetTeamNumber(), thisUnit:GetAbsOrigin(), caster, 150, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 1, false)
							if dazzleFound[1] and (thisUnit.strikeTimer > GameRules:GetGameTime()) then
								thisUnit.asleep = false
							end
						end
						ExecuteOrderFromTable(movement)
					end
					return 0.1
				end
			})
			if count < slivers then
				return 0.03
			else
				count = 0
				return
			end
		end
	})
end





















