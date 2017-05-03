function faenrae_blood_true_sight(keys)
	local caster = keys.caster
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()
	local radius = ability:GetLevelSpecialValueFor("radius", abilityLevel - 1)
	caster:AddNewModifier(caster, nil, 'modifier_truesight', {true_sight_range = radius})
end
	

function dark_hand_curse_counter(keys)
	local caster = keys.caster
	local ability = caster:FindAbilityByName("faenrae_champion_dark_hand_curse")
	local stacks = caster:GetModifierStackCount("modifier_faenrae_champion_dark_hand_curse", caster)
	local abilityLevel = ability:GetLevel()
	caster:SetModifierStackCount("modifier_faenrae_champion_dark_hand_curse", caster, stacks + 1)
	if stacks > 18 then -- transform the spell here. keep in mind that stacks start at 0. 0 = 1, 1 = 2, etc.
		caster:RemoveAbility("faenrae_champion_dark_hand_curse")
		caster:AddAbility("faenrae_champion_dark_hand_curse_active")
		caster:FindAbilityByName("faenrae_champion_dark_hand_curse_active"):SetLevel(abilityLevel)
		if caster:HasModifier("modifier_faenrae_champion_dark_hand_curse") then
			caster:RemoveModifierByName("modifier_faenrae_champion_dark_hand_curse")
		end
	end
end

function dark_hand_curse_active_counter(keys)
	local caster = keys.caster
	local ability = caster:FindAbilityByName("faenrae_champion_dark_hand_curse_active")
	caster:SetModifierStackCount("modifier_faenrae_champion_dark_hand_curse_active", caster, ability:GetLevelSpecialValueFor("stacks_for_cast", ability:GetLevel())) -- transformed version always has 20. not working currently
end

function dark_hand_curse(keys)
	local caster = keys.caster
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()
	local targets = ability:GetLevelSpecialValueFor("targets", abilityLevel - 1)
	local damage = ability:GetLevelSpecialValueFor("damage", abilityLevel - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", abilityLevel - 1)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	if units[1] == nil then -- end if no units found
		return
	end
	while #units > targets do -- random target selection
		table.remove(units, math.random(#units))
	end
	for k,v in pairs(units) do
		DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 1, v:GetAbsOrigin())
		v:EmitSound("Hero_Pugna.NetherWard.Target")
	end
	caster:EmitSound("Hero_Pugna.NetherBlast")
	caster:RemoveAbility("faenrae_champion_dark_hand_curse_active") -- transform back
	caster:AddAbility("faenrae_champion_dark_hand_curse")
	caster:FindAbilityByName("faenrae_champion_dark_hand_curse"):SetLevel(abilityLevel)
	if caster:HasModifier("modifier_faenrae_champion_dark_hand_curse_active") then
		caster:RemoveModifierByName("modifier_faenrae_champion_dark_hand_curse_active")
	end
end	

function word_of_chaos(keys)
	local caster = keys.caster
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()
	local radius = ability:GetLevelSpecialValueFor("radius", abilityLevel - 1)
	local killChance = ability:GetLevelSpecialValueFor("kill", abilityLevel - 1)
	local stunChance = ability:GetLevelSpecialValueFor("stun", abilityLevel - 1) + killChance
	local halfChance = ability:GetLevelSpecialValueFor("half_health", abilityLevel - 1) + stunChance
	local stunDuration = ability:GetLevelSpecialValueFor("stun_duration", abilityLevel - 1)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	for k,v in pairs(units) do
		local chance = math.random(1,100)
		if chance <= killChance then
			--v:Kill(ability, caster) apparently because of int spell amp reversal this doesnt kill anymore. oops!
			local dTable = {
				victim = v,
				attacker = caster,
				damage = 9999999,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = 0,
				ability = ability
			}
			ApplyDamage(dTable)
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 2, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 4, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 8, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)
		elseif chance > killChance and chance <= stunChance then
			v:AddNewModifier(caster, nil, "modifier_stunned", {duration = stunDuration})
			local particle = ParticleManager:CreateParticle("particles/items_fx/abyssal_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
		elseif chance > stunChance and chance < halfChance then
			DealDamage(caster, v, v:GetHealth() / 2, DAMAGE_TYPE_PURE, 0)
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
		end
	end
	caster:EmitSound("Hero_Nightstalker.Darkness")
end

function inner_chaos_splash(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local splash_close = ability:GetLevelSpecialValueFor("splash_close", 1 )
	local splash_medium = ability:GetLevelSpecialValueFor("splash_medium", 1 )
	local splash_far = ability:GetLevelSpecialValueFor("splash_far", 1 )

	local damage = caster:GetAttackDamage()
		
	--Deal splash damage

	local close = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), caster, splash_close, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	local medium = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), caster, splash_medium, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	local far = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), caster, splash_far, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)

	--10% splash damage total
	if #far > 0 then
		for i=1, #far do
			DealDamage(caster, far[i], damage*0.1, DAMAGE_TYPE_MAGICAL, 0)
		end
	end


	--50% splash damage total
	if #medium > 0 then
		for i=1, #medium do
			DealDamage(caster, medium[i], damage*0.4, DAMAGE_TYPE_MAGICAL, 0)
		end
	end

	--100% splash damage total
	if #close > 0 then
		for i=1, #close do
			DealDamage(caster, close[i], damage*0.5, DAMAGE_TYPE_MAGICAL, 0)
		end
	end
end

-- All functions beyond this by Pizzalol/Noya. https://github.com/Pizzalol/SpellLibrary
function ModelSwapStart( keys )
	local caster = keys.caster
	local model = keys.model
	local projectile_model = keys.projectile_model
	local lifeMod = nil
	local lifeItem = nil

	-- Saves the original model and attack capability
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	caster.caster_attack = caster:GetAttackCapability()

	-- Sets the new model and projectile
	caster:SetOriginalModel(model)
	caster:SetRangedProjectileName(projectile_model)

	-- Sets the new attack to ranged
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

	-- Makes Inner Chaos respect lifesteal rules
	if caster:HasModifier("modifier_thirsting_blade_leech") then
		caster:RemoveModifierByName("modifier_thirsting_blade_leech")
	end
	if caster:HasModifier("modifier_bloodthirst_leech") then
		caster:RemoveModifierByName("modifier_bloodthirst_leech")
	end
	--[[if caster:HasModifier("modifier_vampiric_potion_leech") then
		lifeMod = caster:FindModifierByName("modifier_vampiric_potion_leech")
		lifeItem = CreateItem("item_vampiric_potion", nil, nil)
		caster:RemoveModifierByName("modifier_vampiric_potion_leech")
		lifeItem:ApplyDataDrivenModifier(caster, caster, "modifier_vampiric_potion_nope", {})
	end]]
	
	--Stores the old attack and armor types
	if caster.armorType == nil then
		caster.armorType = "modifier_armor_light"
	end

	if caster.attackType == nil then
		caster.attackType = "modifier_attack_hero"
	end
	caster:RemoveModifierByName(caster.armorType)
	caster:RemoveModifierByName(caster.attackType)
	local armorType = CreateItem("item_armor_type_modifier", nil, nil) 
	armorType:ApplyDataDrivenModifier(caster, caster, "modifier_armor_hero", {})
	UTIL_RemoveImmediate(armorType)
	armorType = nil

	local attackItem = CreateItem("item_attack_type_modifier", nil, nil) 
	attackItem:ApplyDataDrivenModifier(caster, caster, "modifier_attack_chaos", {})
	UTIL_RemoveImmediate(attackItem)
	attackItem = nil

end

function ModelSwapEnd( keys )
	local caster = keys.caster
	local lifeMod = nil
	local lifeItem = nil

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetAttackCapability(caster.caster_attack)
	if caster:GetUnitName() == "npc_dota_hero_troll_warlord" then
		caster:SetRangedProjectileName("particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf")
	end

	if caster:HasItemInInventory("item_thirsting_blade") then
		lifeMod = CreateItem("item_thirsting_blade", nil, nil)
		lifeMod:ApplyDataDrivenModifier(caster, caster, "modifier_thirsting_blade_leech", {})
	end
	if caster:HasItemInInventory("item_bloodthirst") then
		lifeMod = CreateItem("item_bloodthirst", nil, nil)
		lifeMod:ApplyDataDrivenModifier(caster, caster, "modifier_bloodthirst_leech", {})
	end
	--[[if caster:HasModifier("modifier_vampiric_potion_nope") then
		lifeMod = caster:FindModifierByName("modifier_vampiric_potion_nope")
		lifeItem = CreateItem("item_vampiric_potion", nil, nil)
		caster:RemoveModifierByName("modifier_vampiric_potion_nope")
		lifeItem:ApplyDataDrivenModifier(caster, caster, "modifier_vampiric_potion_leech", {})
	end]]

	--Resets Faenrae's attack and armor types
	if caster:GetUnitName() == "npc_dota_hero_terrorblade" then
		caster:RemoveModifierByName("modifier_armor_hero")
		caster:RemoveModifierByName("modifier_attack_chaos")
		local armorType = CreateItem("item_armor_type_modifier", nil, nil) 
		armorType:ApplyDataDrivenModifier(caster, caster, caster.armorType, {})
		UTIL_RemoveImmediate(armorType)
		armorType = nil

		local attackItem = CreateItem("item_attack_type_modifier", nil, nil) 
		attackItem:ApplyDataDrivenModifier(caster, caster, caster.attackType, {})
		UTIL_RemoveImmediate(attackItem)
		attackItem = nil
	end
end

function HideWearables( event )
	local hero = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	--hero:AddNoDraw() -- Doesn't work on classname dota_item_wearable

	hero.wearableNames = {} -- In here we'll store the wearable names to revert the change
	hero.hiddenWearables = {} -- Keep every wearable handle in a table, as its way better to iterate than in the MovePeer system
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            local modelName = model:GetModelName()
            if string.find(modelName, "invisiblebox") == nil then
            	-- Add the original model name to revert later
            	table.insert(hero.wearableNames,modelName)
            	print("Hidden "..modelName.."")

            	-- Set model invisible
            	model:SetModel("models/development/invisiblebox.vmdl")
            	table.insert(hero.hiddenWearables,model)
            end
        end
        model = model:NextMovePeer()
        if model ~= nil then
        end
    end
end

function ShowWearables( event )
	local hero = event.caster

	-- Iterate on both tables to set each item back to their original modelName
	for i,v in ipairs(hero.hiddenWearables) do
		for index,modelName in ipairs(hero.wearableNames) do
			if i==index then
				v:SetModel(modelName)
			end
		end
	end
end
			
			
	










		
		
	