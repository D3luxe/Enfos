function BlessSoul(keys)
-- vars
	--PrintTable(keys)
	local unit = keys.unit or keys.caster

	--Double checks to make sure the hero isn't Cleric, and if it is that Murrula's Flame isn't available
	if unit:HasAbility("cleric_murrulas_flame") then
		local ability = unit:FindAbilityByName("cleric_murrulas_flame")
		local cooldown = ability:GetCooldown(ability:GetLevel()-1)
		local cooldownRemaining = ability:GetCooldownTimeRemaining()
		if cooldown - cooldownRemaining <= 1 then
			return
		end
	end


	unit:SetTimeUntilRespawn(unit:GetRespawnTime() / 2)
	Timers:CreateTimer(DoUniqueString("blss"), {
		endTime = unit:GetTimeUntilRespawn(),
		callback = function()
			unit:RespawnHero(false, false, false)
		end
	})
end

function ShieldOfLight(keys)
-- vars
	local caster = keys.caster
	local damageDealt = keys.damage_dealt
	local damageBlocked = keys.damage_blocked
	local casterHealth = caster:GetHealth()
-- logic
	if damageBlocked > damageDealt then
		caster:Heal(damageDealt, caster)
	elseif damageDealt > (damageBlocked + casterHealth) then
		caster:ForceKill(false)
	elseif damageDealt > damageBlocked then
		caster:Heal(damageBlocked, caster)
	end
end

function ShieldOfLightFailure(keys)
-- vars
	local caster = keys.caster
	local damageDealt = keys.damage_dealt
	local casterHealth = caster:GetHealth()
-- logic
	if damageDealt > casterHealth then
		caster:ForceKill(false)
	end
end


function AesrelaEverild(keys)
-- vars
	local caster = keys.caster
	local level = caster:GetAbilityByIndex(3):GetLevel()
	local spell = caster:FindAbilityByName("cleric_aesrela_everild_proxy")
-- logic
	spell:SetLevel(level)
	spell:SetHidden(false)
	spell:OnSpellStart()
	spell:SetHidden(true)
end

function AesrelaEverildStart(keys)
	local caster = keys.caster
	caster:AddAbility("cleric_aesrela_everild_proxy")
end
function AesrelaEverildEmd(keys)
	local caster = keys.caster
	caster:RemoveAbility("cleric_aesrela_everild_proxy")
end
