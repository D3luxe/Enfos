function Prediction(keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	local pid = target:GetPlayerID() -- this is the target's pid, not the caster's pid!
	local maxIncrease = keys.attribute_increase
	local minIncrease = 0
	local ability = keys.ability
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
		minIncrease = minIncrease - 2
	end 
-- reset the values
	--[[target:SetBaseStrength(target:GetBaseStrength() - Enfos.strPrediction[pid])
	target:SetBaseAgility(target:GetBaseAgility() - Enfos.agiPrediction[pid])
	target:SetBaseIntellect(target:GetBaseIntellect() - Enfos.intPrediction[pid])]]

-- Add the stacking modifier if player doesnt have them
	if not target:HasModifier("modifier_prediction_str") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_prediction_str", {})
	end
	if not target:HasModifier("modifier_prediction_int") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_prediction_int", {})
	end
	if not target:HasModifier("modifier_prediction_agi") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_prediction_agi", {})
	end


-- roll the increase
	local strIncreaseAmount = math.random(minIncrease,maxIncrease) -- we can't directly add it because we need this amount for the particles
	local agiIncreaseAmount = math.random(minIncrease,maxIncrease) -- we can't directly add it because we need this amount for the particles
	local intIncreaseAmount = math.random(minIncrease,maxIncrease) -- we can't directly add it because we need this amount for the particles
	local strCharacters = string.len(tostring(strIncreaseAmount))
	local agiCharacters = string.len(tostring(agiIncreaseAmount))
	local intCharacters = string.len(tostring(intIncreaseAmount))
	Enfos.strPrediction[pid] = Enfos.strPrediction[pid] + strIncreaseAmount
	Enfos.agiPrediction[pid] = Enfos.agiPrediction[pid] + agiIncreaseAmount
	Enfos.intPrediction[pid] = Enfos.intPrediction[pid] + intIncreaseAmount
	print("Str: "..strIncreaseAmount.." | Agi: "..agiIncreaseAmount.." | Int: "..intIncreaseAmount)
-- set the increase
	--target:SetBaseStrength(target:GetBaseStrength() + Enfos.strPrediction[pid])
	target.strength = target.strength + strIncreaseAmount
	--target:SetBaseAgility(target:GetBaseAgility() + Enfos.agiPrediction[pid])
	target.agility = target.agility + agiIncreaseAmount
	--target:SetBaseIntellect(target:GetBaseIntellect() + Enfos.intPrediction[pid])
	target.intellect = target.intellect + intIncreaseAmount
-- Adjust the stacks for display only
	target:SetModifierStackCount("modifier_prediction_str", caster, Enfos.strPrediction[pid])
	target:SetModifierStackCount("modifier_prediction_agi", caster, Enfos.agiPrediction[pid])
	target:SetModifierStackCount("modifier_prediction_int", caster, Enfos.intPrediction[pid])
-- particles and sounds
	local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff_symbol.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

	Timers:CreateTimer(DoUniqueString("strBonus"), {
		endTime = 0.01,
		callback = function()		
			local increaseParticleStr = ParticleManager:CreateParticle("particles/msg_fx/msg_evade.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
			if strIncreaseAmount > 0 then
				ParticleManager:SetParticleControl(increaseParticleStr,1,Vector(0,strIncreaseAmount,2)) -- (plus sign, amount, symbol at the end [never used])
				ParticleManager:SetParticleControl(increaseParticleStr,2,Vector(1,strCharacters+2,0)) -- total number of characters in the string
				ParticleManager:SetParticleControl(increaseParticleStr,3,Vector(255,50,50)) -- colour
				target:EmitSound("Hero_WitchDoctor.Maledict_Cast")
			else
				if strIncreaseAmount == 0 then
					ParticleManager:SetParticleControl(increaseParticleStr,1,Vector(2,0,2)) -- create a sad face
					ParticleManager:SetParticleControl(increaseParticleStr,2,Vector(1,2,0))
				else
					ParticleManager:SetParticleControl(increaseParticleStr,1,Vector(1,math.abs(strIncreaseAmount),2))
					ParticleManager:SetParticleControl(increaseParticleStr,2,Vector(1,3,0))
				end
				ParticleManager:SetParticleControl(increaseParticleStr,3,Vector(255,125,125))
				target:EmitSound("Hero_WitchDoctor.Maledict_CastFail")
			end
		end
	})
	Timers:CreateTimer(DoUniqueString("agiBonus"), {
		endTime = 0.5,
		callback = function()		
			local increaseParticleAgi = ParticleManager:CreateParticle("particles/msg_fx/msg_evade.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
			if agiIncreaseAmount > 0 then
				ParticleManager:SetParticleControl(increaseParticleAgi,1,Vector(0,agiIncreaseAmount,2))
				ParticleManager:SetParticleControl(increaseParticleAgi,2,Vector(1,agiCharacters+2,0))
				ParticleManager:SetParticleControl(increaseParticleAgi,3,Vector(50,255,50))
			else
				if agiIncreaseAmount == 0 then
					ParticleManager:SetParticleControl(increaseParticleAgi,1,Vector(2,0,2))
					ParticleManager:SetParticleControl(increaseParticleAgi,2,Vector(1,2,0))
				else
					ParticleManager:SetParticleControl(increaseParticleAgi,1,Vector(1,math.abs(agiIncreaseAmount),2))
					ParticleManager:SetParticleControl(increaseParticleAgi,2,Vector(1,3,0))
				end
				ParticleManager:SetParticleControl(increaseParticleAgi,3,Vector(125,255,125))
				target:EmitSound("Hero_WitchDoctor.Maledict_CastFail")
			end
		end
	})
	Timers:CreateTimer(DoUniqueString("intBonus"), {
		endTime = 1,
		callback = function()		
			local increaseParticleInt = ParticleManager:CreateParticle("particles/msg_fx/msg_evade.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
			if intIncreaseAmount > 0 then
				ParticleManager:SetParticleControl(increaseParticleInt,1,Vector(0,intIncreaseAmount,2))
				ParticleManager:SetParticleControl(increaseParticleInt,2,Vector(1,intCharacters+2,0))
				ParticleManager:SetParticleControl(increaseParticleInt,3,Vector(50,50,255))
			else
				if intIncreaseAmount == 0 then
					ParticleManager:SetParticleControl(increaseParticleInt,1,Vector(2,0,2))
					ParticleManager:SetParticleControl(increaseParticleInt,2,Vector(1,2,0))
				else
					ParticleManager:SetParticleControl(increaseParticleInt,1,Vector(1,math.abs(intIncreaseAmount),2))
					ParticleManager:SetParticleControl(increaseParticleInt,2,Vector(1,3,0))
				end
				ParticleManager:SetParticleControl(increaseParticleInt,3,Vector(125,125,255))
				target:EmitSound("Hero_WitchDoctor.Maledict_CastFail")
			end
		end
	})


	
-- recalculate the stats
	target:CalculateStatBonus()
	--stat update
	local heroNetTable = {}
	heroNetTable[target:GetPlayerID()] = {
		str = target.strength,
		agi = target.agility,
		int = target.intellect}
	CustomNetTables:SetTableValue("hero_data_live","stats",heroNetTable)
	
	if caster.repick == 0 then caster.repick = 1 end
end
	
function Hallucination(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local thisSpell = caster:GetAbilityByIndex(1)
	local target = keys.target
	local targetName = target:GetUnitName()
	local targetHealth = target:GetHealth()
	local targetHull = target.hullSize --just in case
-- make the unit and give it the modifiers
	local unit = CreateUnitByName(targetName, target:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	unit:SetHealth(targetHealth)
	unit:SetRenderColor(0,84,255)
	unit.hullSize = targetHull
	unit:SetHullRadius(targetHull)
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
	thisSpell:ApplyDataDrivenModifier(caster, unit, "modifier_hypnotist_hallucination", {})
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
		-- destroy the moonbeam 
		Enfos.moonbeamActive[pid]:Destroy()
		Timers:RemoveTimer("moonbeam_timer" .. pid)
		Enfos.moonbeamActive[pid] = nil
	else
		caster:GiveMana(keys.ability:GetManaCost(keys.ability:GetLevel() - 1))
		keys.ability:EndCooldown()
		print("INACTIVE MOON BEAM")
		return
	end
end

-- Telekinetic Storm based off Exorcism by Noya
-- https://github.com/Pizzalol/SpellLibrary/tree/SpellLibrary/game/dota_addons/spelllibrary
function TelekineticStormStart(keys)
-- vars
	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerID()
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 ) or 1000
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 ) or 30
	local spirits = ability:GetLevelSpecialValueFor( "spirits", ability:GetLevel() - 1 ) or 20
	local delay_between_spirits = ability:GetLevelSpecialValueFor( "delay_between_spirits", ability:GetLevel() - 1 ) or 0.01
	local unit_name = "npc_dummy_unit"

	-- Initialize the table to keep track of all spirits
	caster.spirits = {}
	for i=1,spirits do
		Timers:CreateTimer(i * delay_between_spirits, function()
			local unit = CreateUnitByName(unit_name, caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
			-- ParticleManager:CreateParticle("particles/hero_hypnotist/bounty_hunter_suriken_toss_hidden_hunter.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
			-- The modifier takes care of the physics and logic
			if ability:IsNull() == false then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_telekinetic_storm_spirit", {})
			end
			
			-- Add the spawned unit to the table
			table.insert(caster.spirits, unit)

			-- Initialize the number of hits, to define the heal done after the ability ends
			unit.numberOfHits = 0

			-- Double check to kill the units, remove this later
			Timers:CreateTimer(duration+10, function() if unit and IsValidEntity(unit) then unit:RemoveSelf() end end)
		end)
	end
end

-- Movement logic for each spirit
-- Units have 4 states: 
	-- acquiring: transition after completing one target-return cycle.
	-- target_acquired: tracking an enemy or point to collide
	-- returning: After colliding with an enemy, move back to the casters location
	-- end: moving back to the caster to be destroyed and heal
function TelekineticStormPhysics( keys )
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 ) or 1000
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 ) or 30
	local spirit_speed = ability:GetLevelSpecialValueFor( "spirit_speed", ability:GetLevel() - 1 ) or 500
	local min_damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 ) or 300
	local max_damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 ) or 300
	local average_damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 ) or 300
	local give_up_distance = ability:GetLevelSpecialValueFor( "give_up_distance", ability:GetLevel() - 1 ) or 1200
	local max_distance = ability:GetLevelSpecialValueFor( "max_distance", ability:GetLevel() - 1 ) or 2000
	local min_time_between_attacks = ability:GetLevelSpecialValueFor( "min_time_between_attacks", ability:GetLevel() - 1 ) or 0.5
	local abilityDamageType = ability:GetAbilityDamageType()
	local abilityTargetType = ability:GetAbilityTargetType()
	--local particleNameHeal = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_start_sparks_b.vpcf"
	Timers:CreateTimer(DoUniqueString("hypno_tkstorm"), {
		endTime = 0.1,
		callback = function()
			
		
			-- Make the spirit a physics unit
			Physics:Unit(unit)

			-- General properties
			unit:PreventDI(true)
			unit:SetAutoUnstuck(false)
			unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
			unit:FollowNavMesh(false)
			unit:SetPhysicsVelocityMax(spirit_speed)
			unit:SetPhysicsVelocity(spirit_speed * RandomVector(1))
			unit:SetPhysicsFriction(0)
			unit:Hibernate(false)
			unit:SetGroundBehavior(PHYSICS_GROUND_LOCK)

			-- Initial default state
			unit.state = "acquiring"

			-- This is to skip frames
			local frameCount = 0

			-- Store the damage done
			unit.damage_done = 0

			-- Store the interval between attacks, starting at min_time_between_attacks
			unit.last_attack_time = GameRules:GetGameTime() - min_time_between_attacks

			-- Color Debugging for points and paths. Turn it false later!
			local Debug = false
			local pathColor = Vector(255,255,255) -- White to draw path
			local targetColor = Vector(255,0,0) -- Red for enemy targets
			local idleColor = Vector(0,255,0) -- Green for moving to idling points
			local returnColor = Vector(0,0,255) -- Blue for the return
			local endColor = Vector(0,0,0) -- Back when returning to the caster to end
			local draw_duration = 3

			-- Find one target point at random which will be used for the first acquisition.
			local point = caster:GetAbsOrigin() + RandomVector(RandomInt(radius/2, radius))

			-- This is set to repeat on each frame
			unit:OnPhysicsFrame(function(unit)

				-- Move the unit orientation to adjust the particle
				unit:SetForwardVector( ( unit:GetPhysicsVelocity() ):Normalized() )

				-- Current positions
				local source = caster:GetAbsOrigin()
				local current_position = unit:GetAbsOrigin()

				-- Print the path on Debug mode
				if Debug then DebugDrawCircle(current_position, pathColor, 0, 2, true, draw_duration) end

				local enemies = nil

				-- Use this if skipping frames is needed (--if frameCount == 0 then..)
				frameCount = (frameCount + 1) % 3

				-- Movement and Collision detection are state independent

				-- MOVEMENT	
				-- Get the direction
				local diff = point - unit:GetAbsOrigin()
		        diff.z = 0
		        local direction = diff:Normalized()

				-- Calculate the angle difference
				local angle_difference = RotationDelta(VectorToAngles(unit:GetPhysicsVelocity():Normalized()), VectorToAngles(direction)).y
				
				-- Set the new velocity
				if math.abs(angle_difference) < 5 then
					-- CLAMP
					local newVel = unit:GetPhysicsVelocity():Length() * direction
					unit:SetPhysicsVelocity(newVel)
				elseif angle_difference > 0 then
					local newVel = RotatePosition(Vector(0,0,0), QAngle(0,10,0), unit:GetPhysicsVelocity())
					unit:SetPhysicsVelocity(newVel)
				else		
					local newVel = RotatePosition(Vector(0,0,0), QAngle(0,-10,0), unit:GetPhysicsVelocity())
					unit:SetPhysicsVelocity(newVel)
				end

				-- COLLISION CHECK
				local distance = (point - current_position):Length()
				local collision = distance < 50

				-- MAX DISTANCE CHECK
				local distance_to_caster = (source - current_position):Length()
				if distance > max_distance then 
					unit:SetAbsOrigin(source)
					unit.state = "acquiring" 
				end

				-- STATE DEPENDENT LOGIC
				-- Damage, Healing and Targeting are state dependent.
				-- Update the point in all frames

				-- Acquiring...
				-- Acquiring -> Target Acquired (enemy or idle point)
				-- Target Acquired... if collision -> Acquiring or Return
				-- Return... if collision -> Acquiring

				-- Acquiring finds new targets and changes state to target_acquired with a current_target if it finds enemies or nil and a random point if there are no enemies
				if unit.state == "acquiring" then

					-- This is to prevent attacking the same target very fast
					local time_between_last_attack = GameRules:GetGameTime() - unit.last_attack_time
					--print("Time Between Last Attack: "..time_between_last_attack)

					-- If enough time has passed since the last attack, attempt to acquire an enemy
					if time_between_last_attack >= min_time_between_attacks then
						-- If the unit doesn't have a target locked, find enemies near the caster
						enemies = FindUnitsInRadius(caster:GetTeamNumber(), source, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
													  abilityTargetType, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

						-- Check the possible enemies
						-- Focus the last attacked target if there's any
						local last_targeted = caster.last_targeted
						local target_enemy = nil
						for _,enemy in pairs(enemies) do

							-- If the caster has a last_targeted and this is in range of the ghost acquisition, set to attack it
							if last_targeted and enemy == last_targeted then
								target_enemy = enemy
							end
						end

						-- Else if we don't have a target_enemy from the last_targeted, get one at random
						if not target_enemy then
							target_enemy = enemies[RandomInt(1, #enemies)]
						end
						
						-- Keep track of it, set the state to target_acquired
						if target_enemy then
							unit.state = "target_acquired"
							unit.current_target = target_enemy
							point = unit.current_target:GetAbsOrigin()
							--print("Acquiring -> Enemy Target acquired: "..unit.current_target:GetUnitName())

						-- If no enemies, set the unit to collide with a random idle point.
						else
							unit.state = "target_acquired"
							unit.current_target = nil
							unit.idling = true
							point = source + RandomVector(RandomInt(radius/2, radius))
							--print("Acquiring -> Random Point Target acquired")
							if Debug then DebugDrawCircle(point, idleColor, 100, 25, true, draw_duration) end
						end

					-- not enough time since the last attack, get a random point
					else
						unit.state = "target_acquired"
						unit.current_target = nil
						unit.idling = true
						point = source + RandomVector(RandomInt(radius/2, radius))
						print("Waiting for attack time. Acquiring -> Random Point Target acquired")
						if Debug then DebugDrawCircle(point, idleColor, 100, 25, true, draw_duration) end
					end

				-- If the state was to follow a target enemy, it means the unit can perform an attack. 		
				elseif unit.state == "target_acquired" then

					-- Update the point of the target's current position
					if unit.current_target then
						point = unit.current_target:GetAbsOrigin()
						if Debug then DebugDrawCircle(point, targetColor, 100, 25, true, draw_duration) end
					end

					-- Give up on the target if the distance goes over the give_up_distance
					if distance_to_caster > give_up_distance then
						unit.state = "acquiring"
						--print("Gave up on the target, acquiring a new target.")

					end

					-- Do physical damage here, and increase hit counter. 
					if collision then

						-- If the target was an enemy and not a point, the unit collided with it
						if unit.current_target ~= nil then
							
							-- Damage, units will still try to collide with attack immune targets but the damage wont be applied
							if not unit.current_target:IsAttackImmune() then
								local damage_table = {}

								local spirit_damage = RandomInt(min_damage,max_damage)
								damage_table.victim = unit.current_target
								damage_table.attacker = caster					
								damage_table.damage_type = abilityDamageType
								damage_table.damage = spirit_damage

								ApplyDamage(damage_table)

								-- Calculate how much physical damage was dealt
								local targetArmor = unit.current_target:GetPhysicalArmorValue()
								local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
								local damagePostReduction = spirit_damage * (1 - damageReduction)

								unit.damage_done = unit.damage_done + damagePostReduction

								-- Increase the numberOfHits for this unit
								unit.numberOfHits = unit.numberOfHits + 1 

								-- Fire Sound on the target unit
								-- unit.current_target:EmitSoundParams("Hero_Shredder.WhirlingDeath.Damage", math.random(0.8,1.2), 0.1, 1)
								
								-- Set to return
								unit.state = "returning"
								point = source
								--print("Returning to caster after dealing ",unit.damage_done)

								-- Update the attack time of the unit.
								unit.last_attack_time = GameRules:GetGameTime()
								--unit.enemy_collision = true

							end

						-- In other case, its a point, reacquire target or return to the caster (50/50)
						else
							if RollPercentage(50) then
								unit.state = "acquiring"
								--print("Attempting to acquire a new target")
							else
								unit.state = "returning"
								point = source
								--print("Returning to caster after idling")
							end
						end
					end

				-- If it was a collision on a return (meaning it reached the caster), change to acquiring so it finds a new target
				elseif unit.state == "returning" then
					
					-- Update the point to the caster's current position
					point = source
					if Debug then DebugDrawCircle(point, returnColor, 100, 25, true, draw_duration) end

					if collision then 
						unit.state = "acquiring"
					end	

				-- if set the state to end, the point is also the caster position, but the units will be removed on collision
				elseif unit.state == "end" then
					point = source
					if Debug then DebugDrawCircle(point, endColor, 100, 25, true, 2) end

					-- Last collision ends the unit
					if collision then 

						unit:SetPhysicsVelocity(Vector(0,0,0))
			        	unit:OnPhysicsFrame(nil)
			        	unit:ForceKill(false)

			        end
			    end
		    end)
		end
	})
end

-- Change the state to end when the modifier is removed
function TelekineticStormEnd( keys )
	local caster = keys.caster
	local targets = caster.spirits

	print("TelekineticStorm End")
	for _,unit in pairs(targets) do		
	   	if unit and IsValidEntity(unit) then
    	  	unit.state = "end"
    	end
	end

	-- Reset the last_targeted
	caster.last_targeted = nil
end

-- Updates the last_targeted enemy, to focus the ghosts on it.
function TelekineticStormAttack( keys )
	local caster = keys.caster
	local target = keys.target

	caster.last_targeted = target
	--print("LAST TARGET: "..target:GetUnitName())
end

-- Kill all units when the owner dies or the spell is cast while the first one is still going
function TelekineticStormDeath( keys )
	local caster = keys.caster
	local targets = caster.spirits or {}

	print("TelekineticStorm Death")
	for _,unit in pairs(targets) do		
	   	if unit and IsValidEntity(unit) then
    	  	unit:SetPhysicsVelocity(Vector(0,0,0))
	        unit:OnPhysicsFrame(nil)

			-- Kill
	      --  unit:ForceKill(false)
			unit:Destroy()
    	end
	end
end





















