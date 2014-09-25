function SleightOfHand(keys)
-- vars
	local caster = keys.caster
	local cpid = caster:GetPlayerID()

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
		if PlayerResource:GetTeam(enmPlayer) ~= PlayerResource:GetTeam(keys.caster:GetPlayerID()) and PlayerResource:IsValidPlayer( enmPlayer ) and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsHero() and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():IsAlive() and PlayerResource:GetPlayer(enmPlayer):GetAssignedHero():GetGold() > 1 then
			break
		end
	end
	local target = PlayerResource:GetPlayer(enmPlayer)
	local targetHero = target:GetAssignedHero()
	if target == nil then
		print("ERROR: SLEIGHT OF HAND TARGET IS NIL")
		return
	end
	local tpid = target:GetPlayerID()
	local cReliableGold = PlayerResource:GetReliableGold(cpid)
	local tReliableGold = PlayerResource:GetReliableGold(tpid)	
	local cUnreliableGold = PlayerResource:GetUnreliableGold(cpid)
	local tUnreliableGold = PlayerResource:GetUnreliableGold(tpid)
	local totalStolen = math.floor((tReliableGold + tUnreliableGold) / 10)
	local characters = string.len(tostring(totalStolen))
-- do the theft
	PlayerResource:SetGold(cpid, math.floor(cReliableGold + (tReliableGold / 10)), true)
	PlayerResource:SetGold(cpid, math.floor(cUnreliableGold + (tUnreliableGold / 10)), false)	
	PlayerResource:SetGold(tpid, math.floor(tReliableGold - (tReliableGold / 10)), true)
	PlayerResource:SetGold(tpid, math.floor(tUnreliableGold - (tUnreliableGold / 10)), false)
-- do particles
	local cParticle = ParticleManager:CreateParticle("particles/hero_hypnotist/hypnotist_increase_amount.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	local tParticle = ParticleManager:CreateParticle("particles/hero_hypnotist/hypnotist_increase_amount.vpcf", PATTACH_OVERHEAD_FOLLOW, targetHero)
	ParticleManager:SetParticleControl(cParticle,1,Vector(100,totalStolen,0))
	ParticleManager:SetParticleControl(cParticle,2,Vector(characters + 1,0,0))
	ParticleManager:SetParticleControl(cParticle,3,Vector(200,90,0))	
	ParticleManager:SetParticleControl(tParticle,1,Vector(1,totalStolen,0))
	ParticleManager:SetParticleControl(tParticle,2,Vector(characters + 1,0,0))
	ParticleManager:SetParticleControl(tParticle,3,Vector(200,90,0))
end

function Khri_Silence(keys)

end
	
	