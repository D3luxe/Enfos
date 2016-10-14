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
-- vars
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
			-- Damage
			DealDamage(caster, unit, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR)
		end
	end

end

function GetEnemiesInCone( caster, unit, start_radius, end_radius, end_distance)
	local DEBUG = false
	
	-- Positions
	local fv = caster:GetForwardVector()
	local origin = unit:GetAbsOrigin()

	local start_point = origin + fv * start_radius -- Position to find units with start_radius
	local end_point = origin + fv * (start_radius + end_distance) -- Position to find units with end_radius

	if DEBUG then
		DebugDrawCircle(start_point, Vector(255,0,0), 100, start_radius, true, 3)
		DebugDrawCircle(end_point, Vector(255,0,0), 100, end_radius, true, 3)
	end

	-- 1 medium circle should be enough as long as the mid_interval isn't too large
	local mid_interval = end_distance - start_radius - end_radius
	local mid_radius = (start_radius + end_radius) / 2
	local mid_point = origin + fv * mid_radius * 2
	
	if DEBUG then
		--print("There's a space of "..mid_interval.." between the circles at the cone edges")
		DebugDrawCircle(mid_point, Vector(0,255,0), 100, mid_radius, true, 3)
	end

	-- Find the units
	local team = unit:GetTeamNumber()
	local iTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local iType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local iFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local iOrder = FIND_ANY_ORDER

	local start_units = FindUnitsInRadius(team, start_point, nil, start_radius, iTeam, iType, iFlag, iOrder, false)
	local end_units = FindUnitsInRadius(team, end_point, nil, end_radius, iTeam, iType, iFlag, iOrder, false)
	local mid_units = FindUnitsInRadius(team, mid_point, nil, mid_radius, iTeam, iType, iFlag, iOrder, false)

	-- Join the tables
	local cone_units = {}
	for k,v in pairs(end_units) do
		table.insert(cone_units, v)
	end

	for k,v in pairs(start_units) do
		if not tableContains(cone_units, k) then
			table.insert(cone_units, v)
		end
	end	

	for k,v in pairs(mid_units) do
		if not tableContains(cone_units, k) then
			table.insert(cone_units, v)
		end
	end

	--DeepPrintTable(cone_units)
	return cone_units

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