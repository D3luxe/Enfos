-- this DOES work
function TippingTheScales(keys)
-- vars
	local damage = keys.DamageDealt
	local attacker = keys.attacker
	local caster = keys.caster
	local percentReflected = keys.damage_reflected / 100

	local armor = keys.caster:GetPhysicalArmorValue()
	local damageMultiplication = ((0.06 * armor) / (1 + 0.06 * armor)) + 1


	local reflectedDamage = damage * percentReflected * damageMultiplication

	DealDamage(caster, attacker, reflectedDamage, DAMAGE_TYPE_PURE, 0)

	--[[local pid = caster:GetPlayerID()
	local thisSpell = caster:FindAbilityByName("omniknight_enfos_tipping_the_scales")
	
	damageTaken = PlayerResource:GetCreepDamageTaken(pid) + PlayerResource:GetHeroDamageTaken(pid) -- you can also add PlayerResource:GetTowerDamageTaken(pid) if that's a thing
	-- these functions are the most reliable way of tracking how much damage was taken so we can undo the damage with the shield code.
	currentHealth = caster:GetHealth() -- I need to get the old health as well as the damage taken
	--print(damageTaken)
-- start timer
	Timers:CreateTimer("tipping_timer" .. pid, {
		endTime = 0.03, 	
		callback = function()
-- second round of vars
				local oldTaken = damageTaken -- store the old values for comparing
				local oldHealth = currentHealth
				damageTaken = PlayerResource:GetCreepDamageTaken(pid) + PlayerResource:GetHeroDamageTaken(pid)
				currentHealth = caster:GetHealth()
				local healthDifference = damageTaken - oldTaken
				local damageDealt = healthDifference * percentReflected
-- spell logic
				if damageTaken > oldTaken then
					DealDamage(caster, attacker, damageDealt, DAMAGE_TYPE_PURE, 0)
				end
				return 0.03
		end
	})]]--
end