function FocusMoonbeam(keys)
-- vars
	local caster = keys.caster
	local target = keys.target_points[1]
	local pid = caster:GetPlayerID()
-- checks for a previously cast moonbeam unit and, if it exists, destroys it and the timer tied to it. (is this correct behaviour?)
	if Enfos.moonbeamActive[pid] ~= nil then
		Enfos.moonbeamActive[pid]:Destroy()
		Timers:RemoveTimer("moonbeam_timer" .. pid)
		Enfos.moonbeamActive[pid] = nil
	end
	if Enfos.burnActive[pid] then
		Enfos.burnActive[pid]:StopSound("Hero_Phoenix.SunRay.Loop")
		Enfos.burnActive[pid]:EmitSound("Hero_Phoenix.SunRay.Stop")
		ParticleManager:DestroyParticle(Enfos.burnFx[pid],true)
		Enfos.burnActive[pid]:ForceKill(false)
		--Enfos.burnActive[pid]:Destroy()
		Enfos.burnActive[pid] = nil
		Timers:RemoveTimer("moonbeam_timer" .. pid)
		Timers:RemoveTimer("burn_sound_timer" .. pid)
	end
-- creates the moonbeam unit and sets a timer to destroy it after the duration expires
	Enfos.moonbeamActive[pid] = FastDummy(AdjustZ(target, 1536), caster:GetTeamNumber())
	Enfos.moonbeamActive[pid]:AddAbility("modspell_focus_moonbeam")
	Enfos.moonbeamActive[pid]:FindAbilityByName("modspell_focus_moonbeam"):SetLevel(1)
	Enfos.moonbeamActive[pid]:EmitSound("Hero_Luna.LucentBeam.Cast")
	local cPart = ParticleManager:CreateParticle("particles/hero_generic/moonbeam.vpcf", PATTACH_ABSORIGIN_FOLLOW, Enfos.moonbeamActive[pid])	
	ParticleManager:SetParticleControl(cPart,1,target)
	
	Timers:CreateTimer("moonbeam_timer" .. pid, {
		endTime = 300,
		callback = function()
			if Enfos.moonbeamActive[pid] ~= nil then
				Enfos.moonbeamActive[pid]:Destroy()
				Enfos.moonbeamActive[pid] = nil
			end
		end
	})
-- placeholder particle
end

function EtherealShieldAutocast( event )
	local caster = event.caster
	local target = event.target -- victim of the attack
	local ability = event.ability
	local level = ability:GetLevel() 

	-- Name of the modifier to avoid casting the spell on targets that were already buffed
	local modifier = "modifier_ethereal_shield_buff"

	-- Get if the ability is on autocast mode and cast the ability on the attacked target if it doesn't have the modifier
	if ability:GetAutoCastState() then
		if not IsChanneling( caster ) and caster:GetMana() >= ability:GetManaCost(level) and ability:GetCooldownTimeRemaining() == 0 then
			if not target:HasModifier(modifier) then
				caster:CastAbilityOnTarget(target, ability, caster:GetPlayerOwnerID())
			end
		end	
	end	
end

-- Auxiliar function that goes through every ability and item, checking for any ability being channelled
function IsChanneling ( hero )
	
	for abilitySlot=0,15 do
		local ability = hero:GetAbilityByIndex(abilitySlot)
		if ability ~= nil and ability:IsInAbilityPhase() then 
			return true
		end
	end

	for itemSlot=0,5 do
		local item = hero:GetItemInSlot(itemSlot)
		if item ~= nil and item:IsChanneling() then
			return true
		end
	end

	return false
end

function FrostSplash(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), caster, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
	for k,v in pairs(enemies) do
		DealDamage(caster, v, 1, DAMAGE_TYPE_PHYSICAL, 0)
		ability:ApplyDataDrivenModifier(caster,v,"modifier_enfos_slow_generic",{duration = duration})
	end
end

function FleeCheck(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	if caster:IsMoving() == false and caster:IsIdle() == true and caster.hold ~= nil then
		if caster.hold == false then
			--flee function, from https://github.com/MNoya/DotaCraft/blob/6d9c6444974f7ae6e5cd7a3442a19de70abe405b/game/dota_addons/dotacraft/scripts/vscripts/units/aggro_filter.lua
			local unit_origin = caster:GetAbsOrigin()
			local target_origin = attacker:GetAbsOrigin()
			local flee_position = unit_origin + (unit_origin - target_origin):Normalized() * 200
			caster:MoveToPosition(flee_position)
		end
	end
end

function purify_summon(keys)
	--[[
	--PrintTable(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	--print(caster:entindex())
	--print(target:entindex())
	print("abname "..ability:GetAbilityName())
	
	if not target:IsNull() and target:IsAlive() then
		local dTable = {
			victim = target,
			attacker = target,
			damage = 50000,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = ability
		}
		ApplyDamage(dTable)
		if not target:IsNull() and target:IsAlive() then
			print("reapplying mod")
			ability:ApplyDataDrivenModifier(ability, target, "modifier_purification_target", {})
		else
			print("bye fail")
		end
	end
	--print(caster:entindex())
	]]
end