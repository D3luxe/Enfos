function blink(keys)
	--PrintTable(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()

	local difference = point - casterPos

	if difference:Length2D() > keys.Range then
		point = casterPos + (point - casterPos):Normalized() * keys.Range
	end
	FindClearSpaceForUnit(caster, point, false)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

	Timers:CreateTimer("blink_timer" .. pid, {
		endTime = 0.03, 	
		callback = function()
			ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	})
end

function item_2000_gold(keys)
	print("Giving 2k gold")
	local caster = keys.caster
	local oldGold = caster:GetGold()
	local newGold = oldGold + 2000
	print("Old gold: "..oldGold.." - New gold: "..newGold)
	caster:SetGold(newGold, false)
end

function item_tome_str(keys)
	local caster = keys.caster
	local statBonus = keys.bonus_stat
	--if caster.tome_str == nil then
	--	caster.tome_str = 0
	--end

	--caster:SetBaseStrength(caster:GetBaseStrength() - caster.tome_str)
	--caster.tome_str = caster.tome_str + statBonus
	--caster:SetBaseStrength(caster:GetBaseStrength() + caster.tome_str)

	caster:ModifyStrength(statBonus)

end

function item_10000_gold(keys)
	print("Giving 10k gold")
	local caster = keys.caster
	local oldGold = caster:GetGold()
	local newGold = oldGold + 10000
	print("Old gold: "..oldGold.." - New gold: "..newGold)
	caster:SetGold(newGold, false)
end

function item_tome_str(keys)
	local caster = keys.caster
	local statBonus = keys.bonus_stat
	--if caster.tome_str == nil then
	--	caster.tome_str = 0
	--end

	--caster:SetBaseStrength(caster:GetBaseStrength() - caster.tome_str)
	--caster.tome_str = caster.tome_str + statBonus
	--caster:SetBaseStrength(caster:GetBaseStrength() + caster.tome_str)

	caster:ModifyStrength(statBonus)

end
function item_tome_agi(keys)
	local caster = keys.caster
	local statBonus = keys.bonus_stat
	--if caster.tome_agi == nil then
	--	caster.tome_agi = 0
	--end

	--caster:SetBaseAgility(caster:GetBaseAgility() - caster.tome_agi)
	--caster.tome_agi = caster.tome_agi + statBonus
	--caster:SetBaseAgility(caster:GetBaseAgility() + caster.tome_agi)

	caster:ModifyAgility(statBonus)

end
function item_tome_int(keys)
	local caster = keys.caster
	local statBonus = keys.bonus_stat
	--if caster.tome_int == nil then
	--	caster.tome_int = 0
	--end

	--caster:SetBaseIntellect(caster:GetBaseIntellect() - caster.tome_int)
	--caster.tome_int = caster.tome_int + statBonus
	--caster:SetBaseIntellect(caster:GetBaseIntellect() + caster.tome_int)

	caster:ModifyIntellect(statBonus)

end
function item_tome_knowledge(keys)
	local caster = keys.caster
	local statBonus = keys.bonus_stat
	--if caster.tome_int == nil then
	--	caster.tome_int = 0
	--end
	--if caster.tome_agi == nil then
	--	caster.tome_agi = 0
	--end
	--if caster.tome_str == nil then
	--	caster.tome_str = 0
	--end

	caster:ModifyStrength(statBonus)
	caster:ModifyAgility(statBonus)
	caster:ModifyIntellect(statBonus)
	--caster:SetBaseStrength(caster:GetBaseStrength() - caster.tome_str)
	--caster.tome_str = caster.tome_str + statBonus
	--caster:SetBaseStrength(caster:GetBaseStrength() + caster.tome_str)

	--caster:SetBaseAgility(caster:GetBaseAgility() - caster.tome_agi)
	--caster.tome_agi = caster.tome_agi + statBonus
	--caster:SetBaseAgility(caster:GetBaseAgility() + caster.tome_agi)

	--caster:SetBaseIntellect(caster:GetBaseIntellect() - caster.tome_int)
	--caster.tome_int = caster.tome_int + statBonus
	--caster:SetBaseIntellect(caster:GetBaseIntellect() + caster.tome_int)



end
function item_tome_combat(keys)
	local caster = keys.caster
	local statBonus = keys.bonus_stat
	if caster.tome_combat == nil then
		caster.tome_combat = 0
	end

	-- 0 = str, 1 = agi, 2 = int
	local primaryAttribute = caster:GetPrimaryAttribute()

	if primaryAttribute == 0 then
		caster:SetBaseDamageMin(caster:GetBaseDamageMin() - caster.tome_combat - caster:GetStrength())
		caster:SetBaseDamageMax(caster:GetBaseDamageMax() - caster.tome_combat - caster:GetStrength())
		caster.tome_combat = caster.tome_combat + statBonus
		caster:SetBaseDamageMin(caster:GetBaseDamageMin() + caster.tome_combat - caster:GetStrength())
		caster:SetBaseDamageMax(caster:GetBaseDamageMax() + caster.tome_combat - caster:GetStrength())
	elseif primaryAttribute == 1 then
		caster:SetBaseDamageMin(caster:GetBaseDamageMin() - caster.tome_combat - caster:GetAgility())
		caster:SetBaseDamageMax(caster:GetBaseDamageMax() - caster.tome_combat - caster:GetAgility())
		caster.tome_combat = caster.tome_combat + statBonus
		caster:SetBaseDamageMin(caster:GetBaseDamageMin() + caster.tome_combat - caster:GetAgility())
		caster:SetBaseDamageMax(caster:GetBaseDamageMax() + caster.tome_combat - caster:GetAgility())
	elseif primaryAttribute == 2 then
		caster:SetBaseDamageMin(caster:GetBaseDamageMin() - caster.tome_combat - caster:GetIntellect())
		caster:SetBaseDamageMax(caster:GetBaseDamageMax() - caster.tome_combat - caster:GetIntellect())
		caster.tome_combat = caster.tome_combat + statBonus
		caster:SetBaseDamageMin(caster:GetBaseDamageMin() + caster.tome_combat - caster:GetIntellect())
		caster:SetBaseDamageMax(caster:GetBaseDamageMax() + caster.tome_combat - caster:GetIntellect())
	else
		print("Invalid primary attribute!")
	end
end
function item_tome_retraining(keys)
	local caster = keys.caster
	local statBonus = keys.bonus_stat
	local pointsUsed = 0

	--Handle unique cases here where innate is in slot 6
	if caster:GetClassname() == "npc_dota_hero_luna" then
		for i=0,4 do
			pointsUsed = pointsUsed + caster:GetAbilityByIndex(i):GetLevel()
			caster:GetAbilityByIndex(i):SetLevel(0)
		end
	else
		for i=0,3 do
			pointsUsed = pointsUsed + caster:GetAbilityByIndex(i):GetLevel()
			caster:GetAbilityByIndex(i):SetLevel(0)
		end
	end
	
	caster:SetAbilityPoints(caster:GetAbilityPoints() + pointsUsed)


end