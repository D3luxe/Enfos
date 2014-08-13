function AddExperience(keys)
	keys.caster:GetPlayerOwner():GetAssignedHero():AddExperience (keys.expamt,false)
end

function ResetCooldowns(keys) 
	keys.target:GetPlayerOwner():GetAssignedHero():GetAbilityByIndex(0):EndCooldown()
	keys.target:GetPlayerOwner():GetAssignedHero():GetAbilityByIndex(1):EndCooldown()
	keys.target:GetPlayerOwner():GetAssignedHero():GetAbilityByIndex(2):EndCooldown()
	keys.target:GetPlayerOwner():GetAssignedHero():GetAbilityByIndex(3):EndCooldown()
	keys.target:GetPlayerOwner():GetAssignedHero():GetAbilityByIndex(4):EndCooldown()
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

	maxMana = 0
	-- while PlayerResource:IsValidPlayer( enmPlayer ) do
	-- 	repeat
	-- 		enmPlayer = RandomInt(0, HeroList:GetHeroCount())
	-- 	until PlayerResource:GetTeam(enmPlayer) ~= PlayerResource:GetTeam(keys.caster:GetPlayerID())
	-- end

	repeat
		enmPlayer = RandomInt(0, HeroList:GetHeroCount())
	until PlayerResource:GetTeam(enmPlayer) ~= PlayerResource:GetTeam(keys.caster:GetPlayerID()) and PlayerResource:IsValidPlayer( enmPlayer ) and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsHero() and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsAlive()

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
	PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():ReduceMana(maxMana)
	keys.caster:GiveMana(manaReplenished)
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

	ApplyDamage(damageTable)
end

function FallenOne(keys)
	local caster = keys.caster
	local dmg = caster:GetMaxHealth() - 1
--print(dmg)
--PrintTable(keys)
	keys.caster:GetPlayerOwner():GetAssignedHero():SetHealth(1)

end

function Tippingthescales(keys)
	PrintTable(keys)
end