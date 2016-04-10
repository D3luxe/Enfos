function BlessSoul(keys)
-- vars
	--PrintTable(keys)
	local unit = keys.unit or keys.caster

	--Double checks to make sure the hero isn't Cleric, and if it is that Murrula's Flame isn't available
	if unit:HasAbility("cleric_murrulas_flame") then
		--print("-----CLERIC LUA-----")
		local ability = unit:FindAbilityByName("cleric_murrulas_flame")
		local cooldown = ability:GetCooldown(ability:GetLevel()-1)
		local cooldownRemaining = ability:GetCooldownTimeRemaining()
		--print("Cooldown: "..cooldown.." | Remaining: "..cooldownRemaining)
		--print("Cooldown Floor: "..math.floor(cooldown+0.5).." | Remaining Floor: "..math.floor(cooldownRemaining+0.5))
		if ability:GetLevel() >= 1 and math.floor(cooldownRemaining+0.5) == math.floor(cooldown+0.5) then
			--print("Has murrula's ready so not going through bless soul")
			return
		end
	end

	--print("No murrula's, continueing in blesssoul")
	Timers:CreateTimer(DoUniqueString("blss_start"), {
		endTime = 0.05,
		callback = function()
			unit:SetTimeUntilRespawn(unit:GetTimeUntilRespawn() / 2)
			print("Time to respawn: "..unit:GetTimeUntilRespawn())
			Timers:CreateTimer(DoUniqueString("blss"), {
				endTime = unit:GetTimeUntilRespawn(),
				callback = function()
					unit:RespawnHero(false, false, false)
				end
			})
		end
	})
	
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
