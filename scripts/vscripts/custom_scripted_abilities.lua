-- made ResetCooldowns slightly more efficient
-- fixed an infinite loop on StealMana
-- fixed FallenOne dealing no damage

function AddExperience(keys)
	keys.caster:GetPlayerOwner():GetAssignedHero():AddExperience (keys.expamt,false)
end

function ResetCooldowns(keys) 
	for i=0,4 do
		keys.target:GetPlayerOwner():GetAssignedHero():GetAbilityByIndex(i):EndCooldown()
	end
end

function StealMana(keys)
	--PrintTable(keys)
	maxMana = keys.caster:GetMaxMana()
	manaStolen = 0
	manaLeech = keys.manaLeech

	manaStolen = maxMana * manaLeech / 100
	keys.caster:GiveMana(manaStolen)

end

function DrainMana(keys)
	--print("Draining mana")
	maxMana = keys.target:GetMaxMana()
	manaDrain = keys.manaDrain
	manaStolen = maxMana * manaDrain / 100

	keys.caster:ReduceMana(manaStolen)
end

function StealMana(keys)
	--print("Draining mana")
	--PrintTable(keys)
	enmPlayer = 0
	enmPlayer = RandomInt(0, HeroList:GetHeroCount()) 
	local safetyValue = 0
	maxMana = 0
	-- while PlayerResource:IsValidPlayer( enmPlayer ) do
	-- 	repeat
	-- 		enmPlayer = RandomInt(0, HeroList:GetHeroCount())
	-- 	until PlayerResource:GetTeam(enmPlayer) ~= PlayerResource:GetTeam(keys.caster:GetPlayerID())
	-- end

	while true do
		enmPlayer = RandomInt(0, HeroList:GetHeroCount())
		safetyValue = safetyValue + 1 -- shoutouts to infinite loops
		if safetyValue > 100 then
			break
		end
		if PlayerResource:GetTeam(enmPlayer) ~= PlayerResource:GetTeam(keys.caster:GetPlayerID()) and PlayerResource:IsValidPlayer( enmPlayer ) and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsHero() and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsAlive() then
			break
		end
	end

	if ( PlayerResource:IsValidPlayer( enmPlayer ) ) then
		maxMana = tonumber(PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():GetMana())
	else
		print("ENMPLAYER IS NOT VALID PLAYER")
	end
	
	manaDrain = tonumber(keys.manaReplenish)
	manaStolen = tonumber(keys.manaStolen)
	manaReplenished = 0
	if maxMana >= manaStolen then
		manaReplenished = manaStolen * manaDrain / 100
	elseif maxMana < manaStolen then
		manaStolen = maxMana
		manaReplenished = manaStolen * manaDrain / 100
	end

	--print(PlayerResource:GetPlayer(enmPlayer):GetAssignedHero())
	if ( PlayerResource:IsValidPlayer( enmPlayer ) ) then
		PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():ReduceMana(maxMana)
		keys.caster:GiveMana(manaReplenished)
	else
		print("ENMPLAYER IS NOT VALID PLAYER!")
	end
end

function EnergyFlare(keys)
	local caster = keys.caster
	local dmg = caster:GetMaxHealth() * keys.damage / 100
	local damageTable = {
		victim = keys.target,
		attacker = caster,
		damage = dmg,
		damage_type = DAMAGE_TYPE_PURE,
	}
	PrintTable(damageTable)
	--damageTable.victim = damageTable.victim.__self
	--PrintTable(damageTable)

	--ApplyDamage(damageTable)
	DealDamage(caster, caster, dmg, DAMAGE_TYPE_MAGICAL, 0)
end

function FallenOneHurtCaster(keys)
	keys.caster:SetHealth(1) -- you don't need to get the hero if you know the hero's gonna be the one casting it
end
function FallenOneHurtEnemies(keys)
	keys.target:SetHealth(1)
end

function ModelScale(keys)
	--PrintTable(keys)
	keys.caster:SetModelScale(keys.scale)
end

function Empower_Armor(keys)
	local strength = keys.caster:GetStrength()
	local healed = strength * 20

	keys.caster:Heal(healed, keys.caster)
end

function Permenant_Invisibility(keys)
	keys.caster:AddNewModifier(keys.caster, nil, "modifier_invisible", {})

	EnfosGameMode:CreateTimer(DoUniqueString("Kill Ward"), {
	useGameTime = true, 
	endTime = GameRules:GetGameTime() + keys.Duration, 
	callback = function(funct, args) 
		
		keys.caster:RemoveModifierByName("modifier_invisible")
			
	end})
end
