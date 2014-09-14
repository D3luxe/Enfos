-- particles are all bad
function ThunderMaul(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local damage = keys.damage
	local stunArea = keys.stun_area_of_effect
	local stunDuration = keys.stun_duration
	local slowArea = keys.slow_area_of_effect
	local slowDuration = keys.slow_duration
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, stunArea, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	if Enfos.appliers[pid].CambrinthChargeApplier == nil then
		Enfos.appliers[pid] = {CambrinthChargeApplier = CreateItem('item_applier_cambrinth_charge', nil, nil)} -- add it to the table
	end
	local applier = Enfos.appliers[pid].CambrinthChargeApplier
	local particle = ParticleManager:CreateParticle("particles/prototype_fx/item_linkens_buff_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	caster:EmitSound("Hero_Sven.StormBolt")
-- logic
	for k,v in pairs(units) do
		v:AddNewModifier(caster, nil, "modifier_stunned", {duration = stunDuration})
		DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
	end
	if caster:HasModifier("modifier_weaponsmith_cambrinth_charge") then
		local unitsSlow = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, slowArea, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		local particleSlow = ParticleManager:CreateParticle("particles/hero_weaponsmith/invoker_chaos_meteor_land_ring_lrg.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particleSlow, 62, Vector(10,0,0)) -- x represents the scale. 0 to 10, where 0 is invisible, 1 is normal size, and 10 is ten times larger
		caster:EmitSound("Hero_Sven.StormBoltImpact")
		for k,v in pairs(unitsSlow) do
			applier:ApplyDataDrivenModifier(caster, v, "modifier_weaponsmith_cambrinth_charge_thunder_maul_debuff", {duration = slowDuration})
		end
	end
end

function Forge(keys)
-- vars
	local caster = keys.caster
	local damageBonus = keys.damage_bonus
	print("Damage Bonus pre charge: "..damageBonus)
	if caster:HasModifier("modifier_weaponsmith_cambrinth_charge") then
		damageBonus = damageBonus * 2
	end
	print("Damage Bonus post charge: "..damageBonus)
	if caster.forge == nil then
		caster.forge = 0
	end

	local strength = caster:GetStrength() * 2.5
	print("Caster's forge: "..caster.forge)
	print("Caster's Strength: "..strength)
	print("Min dmg prior: "..caster:GetBaseDamageMin())
	print("Max dmg prior: "..caster:GetBaseDamageMax())
	caster:SetBaseDamageMin(caster:GetBaseDamageMin() - caster.forge - strength)
	caster:SetBaseDamageMax(caster:GetBaseDamageMax() - caster.forge - strength)
	print("Min dmg mid: "..caster:GetBaseDamageMin())
	print("Max dmg mid: "..caster:GetBaseDamageMax())
	caster.forge = caster.forge + damageBonus
	caster:SetBaseDamageMin(caster:GetBaseDamageMin() + caster.forge - strength)
	caster:SetBaseDamageMax(caster:GetBaseDamageMax() + caster.forge - strength)
	print("Caster's forge: "..caster.forge)
	print("Min dmg post: "..caster:GetBaseDamageMin())
	print("Max dmg post: "..caster:GetBaseDamageMax())
end	