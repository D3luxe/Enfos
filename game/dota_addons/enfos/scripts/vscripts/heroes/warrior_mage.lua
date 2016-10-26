function Tingle( keys )
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability


        -- hit initial target
    local lightning = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
    local loc = target:GetAbsOrigin()
    ParticleManager:SetParticleControl(lightning, 0, loc + Vector(0, 0, 1000))
    ParticleManager:SetParticleControl(lightning, 1, loc)
    ParticleManager:SetParticleControl(lightning, 2, loc)
    EmitSoundOn("Hero_Leshrac.Lightning_Storm", target)

    itemTable = {}
    local maxCount = 5
 

   	for i = 0, maxCount do
		local _item = target:GetItemInSlot(i)
		if _item ~= nil then
			table.insert(itemTable, {slot = i, item = _item:GetName()})
			
		end
	end

	
	if #itemTable > 0 then 
		local randomSlot = RandomInt(1, #itemTable)

		local itemChosen = itemTable[randomSlot]
		local item = target:GetItemInSlot(itemChosen.slot)

		if item ~= nil then
	  		local pos = target:GetAbsOrigin()
	        local drop = target:DropItemAtPositionImmediate( item, pos)
	        local pos_launch = pos+RandomVector(RandomFloat(150,200))
	        item:LaunchLoot(false, 200, 0.75, pos_launch)
	        item.CanBePickedUp = 7

	        Timers:CreateTimer(DoUniqueString("itemPickupControl"), {
				endTime = 1,
				callback = function()
					if item.CanBePickedUp > 0 then
						item.CanBePickedUp = item.CanBePickedUp-1
						return 1
					else
						return
					end
				end
			})
		end
	end

 end

 function FortressOfIce(keys)
-- vars
	local caster = keys.caster
	local thisSpellLevel = caster:GetAbilityByIndex(0):GetLevel()
	local findUnits = Entities:FindAllByClassnameWithin("npc_dota_creature", caster:GetAbsOrigin(), 1000)
	local ability = keys.ability
-- logic
	print("Spawning unit")
	for k,v in pairs(findUnits) do
		if v:GetUnitName() == "npc_fortress_of_ice" and not v.summonerUnit then -- in case the cooldowns get refreshed, we don't want to upgrade existing units
			v.summonerUnit = true 	
			AddTypes(v, "modifier_armor_fortified", "modifier_attack_normal")
			v:SetPhysicalArmorBaseValue(keys.armour)
			v:SetMaxHealth(keys.health)
			v:SetBaseMaxHealth(keys.health)
			v:SetHealth(keys.health)
			v:GetAbilityByIndex(0):SetLevel(1)
			v:SetHullRadius(75.0)
			for i=1,3 do
				FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
			end
		end
	end
end

function AddTypes(mob, armor, attack)
	local spawnedUnitIndex = mob
	local armorType = armor
	local attackType = attack

	local armorItem = CreateItem("item_armor_type_modifier", nil, nil) 
	armorItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, armorType, {})
	UTIL_RemoveImmediate(armorItem)
	armorItem = nil

	local attackItem = CreateItem("item_attack_type_modifier", nil, nil) 
	attackItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, attackType, {})
	UTIL_RemoveImmediate(attackItem)
	attackItem = nil
end

function BerserkersCall( keys )
	local caster = keys.caster
	local target = keys.target

	-- Clear the force attack target
	target:SetForceAttackTarget(nil)

	-- Give the attack order if the caster is alive
	if caster ~= nil then
		if caster:IsAlive() then
			local order = 
			{
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = caster:entindex()
			}

			ExecuteOrderFromTable(order)
		end

		-- Set the force attack target to be the caster
		target:SetForceAttackTarget(caster)
	end
end

-- Clears the force attack target upon expiration
function BerserkersCallEnd( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end

function fire_rain(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local pid = caster:GetPlayerID()
	local damage = ability:GetLevelSpecialValueFor("initial_damage", ability:GetLevel() - 1)
	local impactRadius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local duration = ability:GetSpecialValueFor("duration")
	local searchRadius = ability:GetSpecialValueFor("meteor_fall_area")

	if caster.blastDummy ~= nil then
		caster.blastDummy:Destroy()
		Timers:RemoveTimer("frrn"..pid)
		--print("destroy")
		caster.blastDummy = nil
	end
	caster.blastDummy = FastDummy(target, caster:GetTeamNumber())
	caster.blastDummy:EmitSound("Hero_AbyssalUnderlord.Firestorm.Cast")
	caster.blasticle = ParticleManager:CreateParticle("particles/hero_warriormage/firerain_pre.vpcf", PATTACH_ABSORIGIN, caster.blastDummy)
	ParticleManager:SetParticleControl(caster.blasticle,1,Vector(impactRadius,impactRadius,1))
	
	Timers:CreateTimer("frrn"..pid, {
		endTime = 0.6,
		callback = function()
			if caster.blastDummy ~= nil then
				if caster.blasticle ~= nil then ParticleManager:DestroyParticle(caster.blasticle,false) end
				caster.blastDummy:EmitSound("Hero_AbyssalUnderlord.Firestorm")
				caster.blasticle = ParticleManager:CreateParticle("particles/hero_warriormage/firerain_wave.vpcf", PATTACH_ABSORIGIN, caster.blastDummy)
				ParticleManager:SetParticleControl(caster.blasticle,4,Vector(impactRadius*1.25,impactRadius*1.25,impactRadius*1.25))
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster.blastDummy:GetAbsOrigin(), caster, impactRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
				local unitCount = table.getn(enemies)
				--failsafe
				if unitCount == 0 then return 1 end
				for k,v in pairs(enemies) do
					DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
					ability:ApplyDataDrivenModifier(caster,v,"modifier_fire_rain",{duration = duration})
				end
				return 1
			end
		end
	})
end

function fire_rain_end(keys)
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	if caster.blastDummy ~= nil then
		--caster.blasticle = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.blastDummy)
		ParticleManager:DestroyParticle(caster.blasticle,false)
		--caster.blasticle = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", PATTACH_ABSORIGIN, caster.blastDummy)
		--caster.blastDummy:Destroy()
		Timers:RemoveTimer("frrn"..pid)
		--caster.blastDummy = nil
	end
end