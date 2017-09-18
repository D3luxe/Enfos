function VitalityHealing(keys)
	local caster = keys.caster
	caster:Heal(999999, caster)
end

function Regenerate(keys)
	local caster = keys.caster
	local hpRestored = keys.health_restored / 300
	local manaRestored = keys.mana_restored / 300
	local duration = 30
	
	Timers:CreateTimer(DoUniqueString("empath_regenerate"), {
		endTime = 0.1,
		callback = function()
			caster:Heal(hpRestored, caster)
			caster:GiveMana(manaRestored)
			duration = duration - 0.1
			if duration > 0.0 then
				return 0.1
			end
		end
	})	
end
--[[
	Author: Noya
	Date: April 5, 2015
	Creates the Life Drain Particle rope. 
	It is indexed on the caster handle to have access to it later, because the Color CP changes if the drain is restoring mana.
]]
function LifeDrainParticle( event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local particleName = "particles/units/heroes/hero_pugna/pugna_life_give.vpcf"
	caster.LifeDrainParticle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.LifeDrainParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

end

--[[
	Author: Noya
	Date: April 5, 2015
]]
function TransferencePreCast( event )
	local caster = event.caster
	local target = event.target
	local player = caster:GetPlayerOwner()
	local pID = caster:GetPlayerOwnerID()
	-- This prevents the spell from going off
	if target == caster then
		caster:Stop()

		-- Play Error Sound
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", player)

	end
end

function LifeDrainHealthTransfer( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local health_drain = ability:GetLevelSpecialValueFor( "health_drain" , ability:GetLevel() - 1 )
	local mana_drain = ability:GetLevelSpecialValueFor("mana_drain", ability:GetLevel() - 1)
	local tick_rate = ability:GetLevelSpecialValueFor( "tick_rate" , ability:GetLevel() - 1 )
	local HP_drain = health_drain * tick_rate
	local MP_drain = mana_drain * tick_rate

	-- Location variables
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()

	-- Distance variables
	local distance = (target_location - caster_location):Length2D()
	local break_distance = ability:GetCastRange() + 50
	local direction = (target_location - caster_location):Normalized()

	-- If the leash is broken then stop the channel
	if distance >= break_distance then
		--print("BREAKING! "..break_distance)
		ability:OnChannelFinish(false)
		caster:Stop()
		return
	end

	if not ability:IsChanneling() then
		caster:Stop()
		target:RemoveModifierByName("modifier_life_drain") --[[Returns:void
		Removes a modifier
		]]
		return
	end

	-- Make sure that the caster always faces the target
	caster:SetForwardVector(direction)
	
	-- Health Transfer Caster->Ally
	ApplyDamage({ victim = caster, attacker = caster, damage = HP_drain, damage_type = DAMAGE_TYPE_MAGICAL })
	target:Heal( HP_drain, caster)
	
	--Check to see if caster has enough mana
	if caster:GetMana() < MP_drain then
		MP_drain = caster:GetMana()
	end
	caster:SetMana(caster:GetMana() - MP_drain)
	target:GiveMana(MP_drain)
	
	-- Set the particle control color as green
	ParticleManager:SetParticleControl(caster.LifeDrainParticle, 10, Vector(0,0,0))
	ParticleManager:SetParticleControl(caster.LifeDrainParticle, 11, Vector(0,0,0))
end

function LifeDrainParticleEnd( event )
	local caster = event.caster
	ParticleManager:DestroyParticle(caster.LifeDrainParticle,false)
end

function Alchemy(keys)
	local caster = keys.caster
	local ability =  caster:FindAbilityByName("empath_alchemy")
    local level = ability:GetLevel()
	--Alchemist(ability:GetLevel() , caster)
	local DropInfo = Enfos.DropTable["alchemy_"..level]
    if DropInfo then
        for k,ItemTable in pairs(DropInfo) do
            -- If its an ItemSet entry, decide which item to drop
            local item_name
            if ItemTable.ItemSets then
                -- Count how many there are to choose from
                local count = 0
                for i,v in pairs(ItemTable.ItemSets) do
                    count = count+1
                end
                local random_i = RandomInt(1,count)
                item_name = ItemTable.ItemSets[tostring(random_i)]
            else
                item_name = ItemTable.Item
            end
            local chance = ItemTable.Chance or 100
            local max_drops = ItemTable.Multiple or 1

            for i=1,max_drops do
  
                if RollPercentage(chance) then
       
                    local item = CreateItem(item_name, nil, nil)
                    item:SetPurchaseTime(0)
                    local pos = caster:GetAbsOrigin()
                    local drop = CreateItemOnPositionSync( pos, item )
                    local pos_launch = pos+RandomVector(RandomFloat(150,200))
                    item:LaunchLoot(false, 200, 0.75, pos_launch)
                end
            end
        end
    end
end

function Nissas_Binding(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	end
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_nightmare_datadriven", {})
	
	if caster.repick == 0 then caster.repick = 1 end
end
