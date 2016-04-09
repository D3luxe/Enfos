function FocusMoonbeam(keys)
-- vars
	local caster = keys.caster
	local target = keys.target_points[1]
	local pid = caster:GetPlayerID()
-- checks for a previously cast moonbeam unit and, if it exists, destroys it and the timer tied to it. (is this correct behaviour?)
	if Enfos.moonbeamActive[pid] ~= nil then
		Enfos.moonbeamActive[pid]:Destroy()
		Timers:RemoveTimer("moonbeam_timer" .. pid)
	end
-- creates the moonbeam unit and sets a timer to destroy it after the duration expires
	Enfos.moonbeamActive[pid] = FastDummy(AdjustZ(target, 1536), caster:GetTeamNumber())
	Enfos.moonbeamActive[pid]:AddAbility("modspell_focus_moonbeam")
	Enfos.moonbeamActive[pid]:FindAbilityByName("modspell_focus_moonbeam"):SetLevel(1)
	Enfos.moonbeamActive[pid]:EmitSound("Hero_Luna.LucentBeam.Cast")
	local cPart = ParticleManager:CreateParticle("particles/hero_mentalist/luna_lucent_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, Enfos.moonbeamActive[pid])	
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

