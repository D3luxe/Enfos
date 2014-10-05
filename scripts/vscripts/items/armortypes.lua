--				|Armor Type
--Damage Type	|Unarmored	Light	Medium	Heavy	Fortified	Hero
--Normal		|100%		100%	150%	125%	70%			75%
--Pierce		|150%		200%	75%		75%		35%			50%
--Siege			|100%		100%	50%		125%	150%		75%
--Chaos			|100%		100%	100%	100%	40%			100%
--Hero			|100%		100%	100%	100%	50%			100%
--Magic			|100%		100%	100%	100%	100%		75%


function CalculateArmor(keys)
	--PrintTable(keys)
	local attacker = keys.attacker
	local caster = keys.caster
	local ability = keys.ability
	local armorType = keys.ArmorType
	local target = keys.target
	local damage = keys.DamageTaken
	--print("Damage Taken: "..damage)
	local dealOrHeal = 0

	--Gets the attacker's attack type
	local attackType = nil
	if attacker:HasModifier("modifier_attack_normal") then
		attackType = "modifier_attack_normal"
	elseif attacker:HasModifier("modifier_attack_pierce") then
		attackType = "modifier_attack_pierce"
	elseif attacker:HasModifier("modifier_attack_siege") then
		attackType = "modifier_attack_siege"
	elseif attacker:HasModifier("modifier_attack_chaos") then
		attackType = "modifier_attack_chaos"
	elseif attacker:HasModifier("modifier_attack_magical") then
		attackType = "modifier_attack_magical"
	elseif attacker:HasModifier("modifier_attack_hero") then
		attackType = "modifier_attack_hero"
	else
	--print("Invalid Attack Type")
	end



	if attackType ~= nil then
		--If caster is magic immune, sets a timer to heal all magic damage after the fact
		local isMagicImmune = caster:IsMagicImmune()
		if isMagicImmune and attackType == "modifier_attack_magical" then
			local health = caster:GetHealth()
		--print("Magic immune - healing damage")
			Timers:CreateTimer(DoUniqueString("magicImmuneHeal"), {
				endTime = 0.002, 	
				callback = function()
					caster:SetHealth(health)
				end
			})
		end


		--Unarmored
		if armorType == "unarmored" then
			if attackType == "modifier_attack_pierce" then
				dealOrHeal = 1
				damage = damage * 0.5
			elseif attackType == "modifier_attack_magical" then
				local health = caster:GetHealth()
				Timers:CreateTimer(DoUniqueString("magicImmuneHeal"), {
					endTime = 0.002, 	
					callback = function()
						if caster:IsAlive() then 
							caster:SetHealth(health)
							local armor = caster:GetPhysicalArmorValue()
							local damageMultiplication = ((0.06 * armor) / (1 + 0.06 * armor)) + 1
							damage = damage * damageMultiplication
						--print(damage)
							DealDamage(attacker, caster, damage, DAMAGE_TYPE_MAGICAL, 0)
						end
					end
				})
				
			end
		--Light armor
		elseif armorType == "light" then
			if attackType == "modifier_attack_pierce" then
				dealOrHeal = 1
			end
		-- Medium armor
		elseif armorType == "medium" then
			if attackType == "modifier_attack_normal" then
				dealOrHeal = 1
				damage = damage * 0.5
			elseif attackType == "modifier_attack_pierce" then
				dealOrHeal = 2
				damage = damage * 0.25
			elseif attackType == "modifier_attack_siege" then
				dealOrHeal = 2
				damage = damage * 0.5
			elseif attackType == "modifier_attack_magical" then
				local health = caster:GetHealth()
				Timers:CreateTimer(DoUniqueString("magicImmuneHeal"), {
					endTime = 0.002, 	
					callback = function()
						if caster:IsAlive() then 
							caster:SetHealth(health)
							local armor = caster:GetPhysicalArmorValue()
							local damageMultiplication = ((0.06 * armor) / (1 + 0.06 * armor)) + 1
							damage = damage * damageMultiplication
						--print(damage)
							DealDamage(attacker, caster, damage, DAMAGE_TYPE_MAGICAL, 0)
						end
					end
				})
				
			end
		-- Heavy armor
		elseif armorType == "heavy" then
			if attackType == "modifier_attack_normal" then
				dealOrHeal = 1
				damage = damage * 0.25
			elseif attackType == "modifier_attack_pierce" then
				dealOrHeal = 2
				damage = damage * 0.25
			elseif attackType == "modifier_attack_siege" then
				dealOrHeal = 1
				damage = damage * 0.25
			elseif attackType == "modifier_attack_magical" then
				local health = caster:GetHealth()
				--print("Unit Health: "..health)
				Timers:CreateTimer(DoUniqueString("magicImmuneHeal"), {
					endTime = 0.002, 	
					callback = function()
						if caster:IsAlive() then 
							caster:SetHealth(health)
							local armor = caster:GetPhysicalArmorValue()
							local damageMultiplication = ((0.06 * armor) / (1 + 0.06 * armor)) + 1
							damage = damage * damageMultiplication
						--print("Damage dealt as magical: "..damage)
							DealDamage(attacker, caster, damage, DAMAGE_TYPE_MAGICAL, 0)
						end
					end
				})
				
			end
		-- Fortified armor
		elseif armorType == "fortified" then
			if attackType == "modifier_attack_normal" then
				dealOrHeal = 2
				damage = damage * 0.2
			elseif attackType == "modifier_attack_pierce" then
				dealOrHeal = 2
				damage = damage * 0.5
			elseif attackType == "modifier_attack_siege" then
				dealOrHeal = 1
				damage = damage * 0.5
			elseif attackType == "modifier_attack_hero" then
				dealOrHeal = 2
				damage = damage * 0.5
			elseif attackType == "modifier_attack_chaos" then
				local armor = caster:GetPhysicalArmorValue()
				local damageMultiplication = ((0.06 * armor) / (1 + 0.06 * armor)) + 1

				dealOrHeal = 2
				damage = damage * 0.6 * damageMultiplication
			elseif attackType == "modifier_attack_magical" then
				local health = caster:GetHealth()
				Timers:CreateTimer(DoUniqueString("magicImmuneHeal"), {
					endTime = 0.002, 	
					callback = function()
						if caster:IsAlive() then 
							caster:SetHealth(health)
							local armor = caster:GetPhysicalArmorValue()
							local damageMultiplication = ((0.06 * armor) / (1 + 0.06 * armor)) + 1
							damage = damage * damageMultiplication
							DealDamage(attacker, caster, damage, DAMAGE_TYPE_MAGICAL, 0)
						end
					end
				})
				
			end
		-- Hero armor
		elseif armorType == "hero" then
			if attackType == "modifier_attack_magical" then
				dealOrHeal = 2
				damage = damage * 0.75
			elseif attackType == "modifier_attack_magical" then
				local health = caster:GetHealth()
				Timers:CreateTimer(DoUniqueString("magicImmuneHeal"), {
					endTime = 0.002, 	
					callback = function()
						if caster:IsAlive() then 
							caster:SetHealth(health)
							local armor = caster:GetPhysicalArmorValue()
							local damageMultiplication = ((0.06 * armor) / (1 + 0.06 * armor)) + 1
							damage = damage * 0.75 * damageMultiplication
							--print(damage)
							DealDamage(attacker, caster, damage, DAMAGE_TYPE_MAGICAL, 0)
						end
					end
				})
				
			end
		-- Divine armor
		elseif armorType == "divine" then
			if attackType == "modifier_attack_normal" then
				dealOrHeal = 2
				damage = damage * 0.95
			elseif attackType == "modifier_attack_pierce" then
				dealOrHeal = 2
				damage = damage * 0.95
			elseif attackType == "modifier_attack_siege" then
				dealOrHeal = 2
				damage = damage * 0.95
			elseif attackType == "modifier_attack_hero" then
				dealOrHeal = 2
				damage = damage * 0.95
			elseif attackType == "modifier_attack_magical" then
				local health = caster:GetHealth()
				Timers:CreateTimer(DoUniqueString("magicImmuneHeal"), {
					endTime = 0.002, 	
					callback = function()
						if caster:IsAlive() then 
							caster:SetHealth(health)
							local armor = caster:GetPhysicalArmorValue()
							local damageMultiplication = ((0.06 * armor) / (1 + 0.06 * armor)) + 1
							damage = damage * damageMultiplication * 0.05
							--print(damage)
							DealDamage(attacker, caster, damage, DAMAGE_TYPE_MAGICAL, 0)
						end
					end
				})
				
			end
		else
		--print("Invalid armor type")
		end
	end

	if dealOrHeal == 1 then
		-- Deal extra damage based on armor
	--print("Extra damage due to armor: "..damage)
		DealDamage(attacker, caster, damage, DAMAGE_TYPE_PURE, 0)

	elseif dealOrHeal == 2 then
		--Deal less damage based on armor
		Timers:CreateTimer(DoUniqueString("armorHeal"), {
			endTime = 0.001, 	
			callback = function()
				if caster:IsAlive() then 
				--print("Damage healed due to armor: "..damage)
					caster:Heal(damage, caster)
				end
			end
		})
	else
	--print("No damage change "..dealOrHeal)
	end
end