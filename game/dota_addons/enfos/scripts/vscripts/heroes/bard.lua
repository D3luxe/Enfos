function nexus(keys)
	local caster = keys.caster
	local ability = keys.ability
	local mana_restored = ability:GetSpecialValueFor("mana_restored")
	local spellbringer = caster.spellbringer
	spellbringer:GiveMana(mana_restored)
	if caster.repick == 0 then caster.repick = 1 end
end
	
function merauds_blessing(keys)
	local caster = keys.caster
	local ability = keys.ability
	local mana_restored = ability:GetLevelSpecialValueFor("mana_restored", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 0, 0, false)
	for k,v in pairs(units) do
		if v ~= caster then
			v:GiveMana(mana_restored)
		end
	end
end

function FaenellasGracePreCast( event )
	local caster = event.caster
	local target = event.target
	local player = caster:GetPlayerOwner()
	local pID = caster:GetPlayerOwnerID()
	-- This prevents the spell from going off
	if target == caster then
		caster:Stop()

		-- Play Error Sound
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", player)

	elseif caster.repick == 0 then
		caster.repick = 1
	end
end

-- mainly taken from Spell Library. https://github.com/Pizzalol/SpellLibrary/
function call_of_the_siren( keys )
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local ability = keys.ability
	local unit_name = caster:GetUnitName()
	local images_count = ability:GetLevelSpecialValueFor("images_count", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("illusion_duration", ability:GetLevel() - 1)
	local damage = ability:GetLevelSpecialValueFor("siren_damage", ability:GetLevel() - 1)

	local casterOrigin = caster:GetAbsOrigin()
	local casterAngles = caster:GetAngles()

	-- Stop any actions of the caster otherwise its obvious which unit is real
	caster:Stop()

	-- Initialize the illusion table to keep track of the units created by the spell
	if not caster.mirror_image_illusions then
		caster.mirror_image_illusions = {}
	end

	-- Kill the old images
	for k,v in pairs(caster.mirror_image_illusions) do
		if v and IsValidEntity(v) then 
			v:ForceKill(false)
		end
	end

	-- Start a clean illusion table
	caster.mirror_image_illusions = {}

	-- Setup a table of potential spawn positions
	local vRandomSpawnPos = {
		Vector( 72, 0, 0 ),		-- North
		Vector( 0, 72, 0 ),		-- East
		Vector( -72, 0, 0 ),	-- South
		Vector( 0, -72, 0 ),	-- West
	}

	for i=#vRandomSpawnPos, 2, -1 do	-- Simply shuffle them
		local j = RandomInt( 1, i )
		vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
	end

	-- Insert the center position and make sure that at least one of the units will be spawned on there.
	table.insert( vRandomSpawnPos, RandomInt( 1, images_count+1 ), Vector( 0, 0, 0 ) )

	-- At first, move the main hero to one of the random spawn positions.
	FindClearSpaceForUnit( caster, casterOrigin + table.remove( vRandomSpawnPos, 1 ), true )

	-- Spawn illusions
	for i=1, images_count do

		local origin = casterOrigin + table.remove( vRandomSpawnPos, 1 )

		-- handle_UnitOwner needs to be nil, else it will crash the game.
		local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
		illusion:SetPlayerID(caster:GetPlayerID())
		illusion:SetControllableByPlayer(player, true)

		illusion:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		-- bard-specific stuff
		illusion:SetBaseStrength(0)
		illusion:SetBaseAgility(0)
		illusion:SetBaseIntellect(0)
		illusion:SetBaseDamageMin(damage)
		illusion:SetBaseDamageMax(damage)
		illusion:AddAbility("bard_call_of_the_siren_multi_shot")
		illusion:FindAbilityByName("bard_call_of_the_siren_multi_shot"):SetLevel(1)
		-- Set the unit as an illusion
		-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = 100, incoming_damage = 0 })

		if ability:GetLevel() < 4 then
			illusion:SetBaseAttackTime(0.6)
		elseif ability:GetLevel() >= 4 and ability:GetLevel() < 9 then
			illusion:SetBaseAttackTime(0.5)
		elseif ability:GetLevel() >= 9 then
			illusion:SetBaseAttackTime(0.25)
		else
			illusion:SetBaseAttackTime(0.6)
		end
		
		-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
		illusion:MakeIllusion()
		-- Set the illusion hp to be the same as the caster
		illusion:SetMaxHealth(999999)
		illusion:SetBaseMaxHealth(999999)
		illusion:SetHealth(999999)
		illusion:SetPhysicalArmorBaseValue(9999)
		-- Add the illusion created to a table within the caster handle, to remove the illusions on the next cast if necessary
		table.insert(caster.mirror_image_illusions, illusion)
	end
end

-- mainly taken from Spell Library. https://github.com/Pizzalol/SpellLibrary/
function split_shot(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	-- Ability variables
	local radius = ability:GetSpecialValueFor("range")
	local max_targets = ability:GetSpecialValueFor("arrow_count")
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
	local split_shot_projectile = "particles/units/heroes/hero_medusa/medusa_base_attack.vpcf"

	local split_shot_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, FIND_CLOSEST, false)

	-- Create projectiles for units that are not the casters current attack target
	for _,v in pairs(split_shot_targets) do
		if v ~= attack_target then
			local projectile_info = 
			{
				EffectName = split_shot_projectile,
				Ability = ability,
				vSpawnOrigin = caster_location,
				Target = v,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = false
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
		end
		-- If we reached the maximum amount of targets then break the loop
		if max_targets == 0 then break end
	end
end

-- Apply the auto attack damage to the hit unit
function SplitShotDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = caster:GetAttackDamage()

	ApplyDamage(damage_table)
end