function TechniqueAcqRangeUp(keys)
	local ammo = keys.caster:FindAbilityByName("sniper_fire_ammo")
	local ammoLevel = ammo:GetLevel()
	local ammoCast = ammo:GetAutoCastState()
	keys.caster:RemoveAbility("sniper_fire_ammo")
	keys.caster:AddAbility("sniper_fire_ammo_2")
	keys.caster:FindAbilityByName("sniper_fire_ammo_2"):SetLevel(ammoLevel)
	if ammoCast == true then
		keys.caster:FindAbilityByName("sniper_fire_ammo_2"):ToggleAutoCast()
	end
	keys.caster:RemoveAbility("sniper_standard_technique")
	keys.caster:AddAbility("sniper_sniper_technique")
	keys.caster:SetAcquisitionRange(3600)
	keys.caster:FindAbilityByName("sniper_sniper_technique"):StartCooldown(30.0)
	keys.caster:FindAbilityByName("sniper_sniper_technique"):SetLevel(1) --[[Returns:void
	Sets the level of this ability.
	]]

end

function TechniqueAcqRangeDown(keys)
	local ammo = keys.caster:FindAbilityByName("sniper_fire_ammo_2")
	local ammoLevel = ammo:GetLevel()
	local ammoCast = ammo:GetAutoCastState()
	local stance = keys.caster:FindAbilityByName("sniper_sniper_technique")
	local cooldown = stance:GetCooldownTimeRemaining()
	local dead = keys.am_i_dead
	keys.caster:RemoveAbility("sniper_fire_ammo_2")
	keys.caster:AddAbility("sniper_fire_ammo")
	keys.caster:FindAbilityByName("sniper_fire_ammo"):SetLevel(ammoLevel)
	if ammoCast == true then
		keys.caster:FindAbilityByName("sniper_fire_ammo"):ToggleAutoCast()
	end
	keys.caster:RemoveModifierByName("modifier_sniper_technique")
	keys.caster:RemoveAbility("sniper_sniper_technique")
	keys.caster:AddAbility("sniper_standard_technique")
	keys.caster:SetAcquisitionRange(700)
	if dead == 0 then
		keys.caster:FindAbilityByName("sniper_standard_technique"):StartCooldown(30.0)
	else
		keys.caster:FindAbilityByName("sniper_standard_technique"):StartCooldown(cooldown)
	end
	keys.caster:FindAbilityByName("sniper_standard_technique"):SetLevel(1)
end

function TechniquePierce(keys)
	local caster = keys.caster
	local pID = caster:GetPlayerID()
	local target = keys.target
	local damage = Enfos.damageSpillValue[pID]
	local ability = keys.ability
	--print("spill dmg "..damage)
	if target ~= Enfos.damageSpillTarget[pID] then
		local dTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR,
			ability = ability
		}
		ApplyDamage(dTable)
	end
end
--[[
	local caster = keys.caster
	local target = keys.target
	local damage = caster:GetAverageTrueAttackDamage(caster) -- this isn't perfect but it's good enough. damage ranges really aren't a meaningful factor
	local pid = caster:GetPlayerID()
	local start_radius = 50
	local end_radius = 100
	local end_distance = 150

	local cone_units = GetEnemiesInCone( caster, target, start_radius, end_radius, end_distance )

	for _,unit in pairs(cone_units) do
		if unit ~= target and unit ~= caster then
			PrintTable(cone_units)
			print(damage)
			DealDamage(caster, unit, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR)
		end
	end

end]]

function DamageSpill(keys)
	--print("keep the Os")
	local caster = keys.caster
	local target = keys.target
	local pID = caster:GetPlayerID()
	local ability = keys.ability
	local spawnpoint = target:GetAbsOrigin()
	--local origin = caster:GetAbsOrigin()
	--origin.z = spawnpoint.z
	--local diff = spawnpoint - origin
	local velocity = caster:GetForwardVector() * 10000
	--local velocity = diff:Normalized() * 10000
	--Enfos.damageSpillValue[pID] = keys.damage
	--Enfos.damageSpillTarget[pID] = target
	Timers:CreateTimer(DoUniqueString("spill"..pID), {
		endTime = 0.15,
		callback = function()
			local shot = 
			{
				Ability = keys.ability,
				vSpawnOrigin = spawnpoint,
				fDistance = 150,
				fStartRadius = 50,
				fEndRadius = 50,
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
			print(caster.damageSpillValue)
			print(caster.damageSpillTarget)
			print(velocity)
			print(spawnpoint)
			projectile = ProjectileManager:CreateLinearProjectile(shot)
			caster:EmitSound("Hero_Clinkz.SearingArrows.Impact")
		end
	})
end

function FireAmmo(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("damage_bonus", ability_level)
	local pID = caster:GetPlayerID()

	local dTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
		ability = ability
	}
	ApplyDamage(dTable)
	Timers:CreateTimer(DoUniqueString("spillend"..pID), {
		endTime = 0.20,
		callback = function()
			Enfos.damageSpillValue[pID] = nil
			Enfos.damageSpillTarget[pID] = nil
			--print("damage clear - ammo")
		end
	})
end

-- Returns true if the element can be found on the list, false otherwise
function tableContains(list, element)
    if list == nil then return false end
    for i=1,#list do
        if list[i] == element then
            return true
        end
    end
    return false
end

function FireAmmoRefund(keys)
-- vars
	local caster = keys.caster
	local spell = caster:GetAbilityByIndex(0)
	local cost = spell:GetManaCost(spell:GetLevel() - 1)
	caster:SetMana(caster:GetMana() + cost)
end

function FireAmmoCost(keys)
-- vars
	local caster = keys.caster
	local spell = caster:GetAbilityByIndex(0)
	local cost = spell:GetManaCost(spell:GetLevel())
	caster:SetMana(caster:GetMana() - cost)
-- turn it off if we don't have the mana
	if caster:GetMana() <= 0 then
		if spell:GetToggleState() then
			spell:ToggleAbility()
		end
	end
end
		

function BurningGrenade(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local damage = keys.damage
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target, caster, keys.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
	for k,v in pairs(units) do
		DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
	end
end