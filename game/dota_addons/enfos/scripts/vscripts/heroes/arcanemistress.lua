function TargetedMagic(keys)
-- vars
	local caster = keys.caster
	local frostScythe = caster:GetAbilityByIndex(0)
	local frostScytheLevel = frostScythe:GetLevel()
	local frostScytheManaCost = frostScythe:GetManaCost(frostScytheLevel)
	local radius = (frostScytheLevel * 200) + 500
	local fsCount = 0
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 1, false)
-- logic
	print(frostScytheManaCost)
	for k,v in pairs(targets) do
		fsCount = fsCount + 1
		if fsCount > 10 then
			break
		end
		if caster:GetMana() >= frostScytheManaCost then
			caster:SpendMana(frostScytheManaCost, frostScythe)
			caster:SetCursorCastTarget(v)
			frostScythe:OnSpellStart()
		else
			break
		end
	end
end

function Hailstorm(keys)
-- vars
	local caster = keys.caster
	local target = keys.target_points[1]
	local damage = keys.damage
	local radius = keys.radius
	local ability = keys.ability
	local pid = caster:GetPlayerID()
	local hailstormLevel = caster:GetAbilityByIndex(3):GetLevel()
	Enfos.hailstormDummy = FastDummy(target, caster:GetTeamNumber())
	Enfos.hailstormDummy:AddAbility("arcane_mistress_hailstorm_proxy")
	local dummySpell = Enfos.hailstormDummy:FindAbilityByName("arcane_mistress_hailstorm_proxy")
-- logic
	dummySpell:SetLevel(hailstormLevel)
	Enfos.hailstormDummy:SetCursorTargetingNothing(true) -- dunno if needed
	dummySpell:OnSpellStart()
	Timers:CreateTimer(DoUniqueString("hlsm"..pid), {
		endTime = 0.03,
		callback = function()
			if Enfos.hailstormDummy ~= 0 then
				local units = FindUnitsInRadius(caster:GetTeamNumber(), Enfos.hailstormDummy:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
				local unitCount = table.getn(units)
				--failsafe
				if unitCount == 0 then return 1 end
				local damageLimit = 99999
				local newDamage = damage
				for k,v in pairs(units) do

						if damage * unitCount > damageLimit then
							newDamage = damageLimit / unitCount
						else
							newDamage = damage
						end

						DealDamage(caster, v, newDamage, DAMAGE_TYPE_MAGICAL, 0)
				
				end
				return 1
			end
		end
	})					
end

function HailstormEnd(keys)
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	Enfos.hailstormDummy:Destroy()
	Enfos.hailstormDummy = 0
	Timers:RemoveTimer("hlsm"..pid)
end