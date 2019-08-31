function CollectAssets(keys)
-- vars
	local caster = keys.caster
	local lumber = math.floor(keys.lumber_base + (keys.lumber_per_level*caster:GetLevel()))

	print("Lumber: "..lumber)
	ModifyLumber(caster:GetPlayerOwner(),lumber)
	
	local effect = ParticleManager:CreateParticle("particles/hero_trader/trader_collect_assets_flash.vpcf", PATTACH_ABSORIGIN, caster)
	local lumberAmount = ParticleManager:CreateParticle("particles/msg_fx/msg_poison.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(lumberAmount,1,Vector(0,lumber,0))
	ParticleManager:SetParticleControl(lumberAmount,2,Vector(1,string.len(tostring(lumber))+1,0))
	ParticleManager:SetParticleControl(lumberAmount,3,Vector(32,196,0)) -- colour
	caster:EmitSound("Hero_Furion.Teleport_Appear")
	
	if caster.repick == 0 then caster.repick = 1 end
end

function GuildShop(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local duration = keys.duration
	local level = ability:GetLevel()
	
	local pid = caster:GetPlayerID()
	local shop = CreateUnitByName("npc_trader_guild_shop", target, true, caster, caster, caster:GetTeamNumber() )
	if caster.guildShop ~= nil and caster.guildShop:IsNull() == false then
		caster.guildShop:ForceKill(false)
	end
	caster.guildShop = shop
	--shop:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	--shop:SetOwner(caster:GetOwner())
	shop:SetNoCorpse()
	shop:GetAbilityByIndex(0):SetLevel(1)
	
	shop.CebiRoot = 5
	shop.HealPot = -1
	shop.GreatHealPot = -1
	shop.GreatHisan = -1
	shop.BlinkScroll = -1
	shop.LurePouch = -1
	shop.BlockOrb = -1
	shop.IvoryMail = -1
	shop.SunStone = -1
	shop.DwarvenPride = -1
	shop.Bloodstone = -1
	shop.CebiRestock = false
	shop.OrbRestock = false
	if level >= 2 then
		if level < 10 then
			shop.HealPot = 1
		else shop.GreatHealPot = 1
		end
	end
	if level >= 3 then
		shop.GreatHisan = 1
	end
	if level >= 4 then
		shop.BlinkScroll = 2
	end
	if level >= 5 then
		shop.LurePouch = 1
	end
	if level >= 6 then
		shop.BlockOrb = 1
	end
	if level >= 7 then
		shop.IvoryMail = 1
	end
	if level >= 8 then
		shop.SunStone = 1
	end
	if level >= 9 then
		shop.DwarvenPride = 1
	end
	if level == 10 then
		shop.Bloodstone = 1
	end
	
	--shop:AddNewModifier(shop, nil, "modifier_phased", {duration = duration})
	--shop:AddNewModifier(shop, nil, "modifier_invulnerable", {duration = duration})
	shop:AddNewModifier(shop, nil, "modifier_kill", {duration = duration})
	shop:SetHullRadius(50.0)
	for i=1,3 do
		FindClearSpaceForUnit(shop, shop:GetAbsOrigin(), true)
	end
end

function ShopAura(keys)
	local caster = keys.caster
	local caster_entindex = keys.caster_entindex
	
	local onoff = keys.onoff
	print(caster_entindex)
	local stock = {}
	stock.shop = caster_entindex
	
	if onoff == 2 then
		print("DIE")
		caster:AddNoDraw()
		local blastDummy = FastDummy(caster:GetAbsOrigin(), caster:GetTeamNumber())
		blastDummy:EmitSound("Portal.Hero_Disappear")
		local p1 = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_start_l_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, blastDummy)
		local p2 = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_start_dust_bits_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, blastDummy)
		local p3 = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_start_dust_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, blastDummy)
		local p4 = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_start_n_endcap_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, blastDummy)
		DelayDestroy(blastDummy, 1)
		stock.dead = true
		CustomGameEventManager:Send_ServerToAllClients( "guild_shop_update", stock )
		return
	end
	
	local target = keys.target
	if onoff == 1 then
		print("ON")
		stock.InRange = true
		stock.CebiRoot = caster.CebiRoot
		stock.HealPot = caster.HealPot
		stock.GreatHealPot = caster.GreatHealPot
		stock.GreatHisan = caster.GreatHisan
		stock.BlinkScroll = caster.BlinkScroll
		stock.LurePouch = caster.LurePouch
		stock.BlockOrb = caster.BlockOrb
		stock.IvoryMail = caster.IvoryMail
		stock.SunStone = caster.SunStone
		stock.DwarvenPride = caster.DwarvenPride
		stock.Bloodstone = caster.Bloodstone
		CustomGameEventManager:Send_ServerToPlayer( target:GetPlayerOwner(), "guild_shop_update", stock )
	else
		print("OFF")
		stock.InRange = false
		CustomGameEventManager:Send_ServerToPlayer( target:GetPlayerOwner(), "guild_shop_update", stock )
	end
end

function CaravanBomb(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local radius = keys.radius
	local collision_radius = keys.collision_radius
	local cart_speed = keys.cart_speed
	local casterPos = caster:GetAbsOrigin()
	local fVec = caster:GetForwardVector()
	
	local forwardVec = target - casterPos
		forwardVec = forwardVec:Normalized()
	local backwardVec = casterPos - target
		backwardVec = backwardVec:Normalized()
	local spawnPoint = casterPos + ( radius * backwardVec )
	local velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )
	
	local projectileTable = {
		Ability = ability,
		EffectName = "particles/hero_trader/trader_caravan_bomb.vpcf",
		vSpawnOrigin = spawnPoint,
		fDistance = radius * 2,
		fStartRadius = collision_radius,
		fEndRadius = collision_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		vVelocity = velocityVec * cart_speed
	}
	ProjectileManager:CreateLinearProjectile( projectileTable )
end

function CaravanExplosion(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local blastDummy = FastDummy(target, caster:GetTeamNumber())
	blastDummy:EmitSound("Hero_Techies.Suicide")
	local particle = ParticleManager:CreateParticle("particles/hero_trader/trader_caravan_bomb_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, blastDummy)
	--ParticleManager:SetParticleControl(particle, 0, randomPoint) 
	ParticleManager:SetParticleControl(particle, 2, Vector(2,2,2))
	DelayDestroy(blastDummy, 1)
end