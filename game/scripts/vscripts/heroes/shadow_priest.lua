function preservation(keys)
	local caster = keys.caster
	local ability = keys.ability
	local shadowArts = caster:FindAbilityByName("shadow_priest_shadow_art_mastery")
	local shadowArtsLevel = shadowArts:GetLevel() - 1
	local shadowArtsLives = shadowArts:GetLevelSpecialValueFor("lives", shadowArtsLevel)
	print (shadowArtsLives)
	local lives = ability:GetSpecialValueFor("lives") + shadowArtsLives
	GameRules.Enfos:ModifyLife(caster:GetTeam(), 0, lives)
end

function enfeeble(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sDuration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local shadowArts = caster:FindAbilityByName("shadow_priest_shadow_art_mastery")
	local shadowArtsLevel = shadowArts:GetLevel() - 1
	local shadowArtsDuration = shadowArts:GetLevelSpecialValueFor("duration", shadowArtsLevel)
	local totalDuration = sDuration + shadowArtsDuration
	print (shadowArtsDuration)
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_enfeeble_enfos", {duration = totalDuration}) -- the logic for enfeeble is handled in addon_game_mode.lua in the OnEntityKilled block
	end
end

function greater_hallucination(keys)
-- illusion code largely taken from SpellLibrary: https://github.com/Pizzalol/SpellLibrary
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local target = keys.target
	local ability = keys.ability
	local shadowArts = caster:FindAbilityByName("shadow_priest_shadow_art_mastery")
	local shadowArtsLevel = shadowArts:GetLevel() - 1
	local shadowArtsHeal = shadowArts:GetLevelSpecialValueFor("heal", shadowArtsLevel)
	local unit_name = target:GetUnitName()
	local origin = target:GetAbsOrigin() + RandomVector(100)
	local sDuration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor("outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor("incoming_damage", ability:GetLevel() - 1 )

	-- handle_UnitOwner needs to be nil, else it will crash the game.
	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(target:GetPlayerID())
	illusion:SetControllableByPlayer(player, true)
	
	-- Level Up the unit to the casters level
	local targetLevel = target:GetLevel()
	for i=1,targetLevel-1 do
		illusion:HeroLevelUp(false)
	end

	-- Set the skill points to 0 and learn the skills of the caster
	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = target:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			if illusionAbility ~= nil then
				illusionAbility:SetLevel(abilityLevel)
			end
		end
	end

	-- Recreate the items of the caster
	for itemSlot=0,5 do
		local item = target:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end

	GameRules.Enfos:ModifyStatBonuses(illusion)

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = sDuration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
	if shadowArtsHeal ~= nil then
		illusion:Heal(shadowArtsHeal, ability)
	end
end

function armageddon(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local impactRadius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local searchRadius = ability:GetSpecialValueFor("meteor_fall_area")
	local shadowArts = caster:FindAbilityByName("shadow_priest_shadow_art_mastery")
	local shadowArtsLevel = shadowArts:GetLevel() - 1
	local shadowArtsChance = shadowArts:GetLevelSpecialValueFor("chance", shadowArtsLevel)
	local randomPoint = nil
	local randomNumber = math.random(1,100)
	if shadowArtsChance > randomNumber then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		if units[1] == nil then -- end if no units found
			randomPoint = caster:GetAbsOrigin() + (RandomVector(searchRadius) * RandomFloat(0,1))
		else
			while #units > 1 do -- remove random units from the table until there's only one left
				table.remove(units, math.random(#units))
			end
			randomPoint = units[1]:GetAbsOrigin() -- not so random I guess
		end
	else
		randomPoint = caster:GetAbsOrigin() + (RandomVector(searchRadius) * RandomFloat(0,1))
	end
	local blastDummy = FastDummy(randomPoint, caster:GetTeamNumber())
	blastDummy:EmitSound("Hero_Invoker.SunStrike.Ignite")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, blastDummy)
	ParticleManager:SetParticleControl(particle, 0, randomPoint) 
	ParticleManager:SetParticleControl(particle, 1, Vector(impactRadius,0,0))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), blastDummy:GetAbsOrigin(), caster, impactRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	for k,v in pairs(enemies) do
		DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
	end
	DelayDestroy(blastDummy, 1)
end


						-- "FireEffect"
						-- {
							-- "EffectName"        "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
							-- "EffectAttachType"  "follow_origin"
							-- "Target"            "TARGET"

							-- "ControlPoints"
							-- {
								-- "01"	"%area_of_effect 0 0"
							-- }
						-- }












