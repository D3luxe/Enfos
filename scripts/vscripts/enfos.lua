if Enfos == nil then
  Enfos = class({})
  Enfos.__index = Enfos
end

function Enfos:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

Enfos.moonbeamActive = {} -- value for the moonbeam
Enfos.starlightSphere = {} -- value for the starlight sphere
Enfos.strPrediction = {} -- value for prediction
Enfos.agiPrediction = {} -- value for prediction
Enfos.intPrediction = {} -- value for prediction
Enfos.spiritualSwarmJumps = 0
Enfos.curRound = 0
Enfos.flagPos = 0
Enfos.hailstormDummy = 0
Enfos.vertigoDummy = {}
Enfos.aesrelaEverildDummy = 0
Enfos.DropTable = LoadKeyValues("scripts/kv/item_drops.kv")
Enfos.tremorDummy = 0


function spellAbsorb(keys)
	PrintTable(keys)
	--keys.caster:AddNewModifier(keys.caster, nil, "modifier_item_sphere_target", {})
	print(keys.caster:HasModifier("modifier_item_sphere_target"))
end
-- a function that makes dealing damage slightly faster.
function DealDamage(source, target, damage, dType, flags)
	local dTable = {
		victim = target,
		attacker = source,
		damage = damage,
		damage_type = dType,
		damage_flags = flags,
		ability = nil
	}
	ApplyDamage(dTable)
end
-- a function to quickly create an appropriate dummy
function FastDummy(target, team, hero)
	local owner = hero or nil
	local dummy = CreateUnitByName("npc_dummy_unit", target, false, nil, owner, team)
	dummy:SetAbsOrigin(target) -- CreateUnitByName uses only the x and y coordinates so we have to move it with SetAbsOrigin()
	dummy:GetAbilityByIndex(0):SetLevel(1)
	dummy:SetDayTimeVisionRange(250)
	dummy:SetNightTimeVisionRange(250)
	dummy:AddNewModifier(dummy, nil, "modifier_phased", { duration = -1})
	dummy:AddNewModifier(dummy, nil, "modifier_invulnerable", { duration = -1})
	return dummy
end
-- quickly destroy a unit
function DelayDestroy(unit, delayAmount)
	Timers:CreateTimer(DoUniqueString("delay"), {
		endTime = delayAmount or 0.03,
		callback = function()
			unit:Destroy()
		end
	})
end
-- some fast math functions
function AdjustX(vec, xAdj) -- return the vector with x added
	return Vector(vec.x + xAdj, vec.y, vec.z)
end

function AdjustY(vec, yAdj) -- return the vector with y added
	return Vector(vec.x, vec.y + yAdj, vec.z)
end

function AdjustZ(vec, zAdj) -- return the vector with z added
	return Vector(vec.x, vec.y, vec.z + zAdj)
end

function GetMidPoint(vec1, vec2) -- can also pass in units
	if type(vec1) == "table" then
		vec1 = vec1:GetAbsOrigin()
	end
	if type(vec2) == "table" then
		vec2 = vec2:GetAbsOrigin()
	end
	return (vector1 + vector2)/2
end

-- GetLine and GetDistanceToLine by Perry. GetPointOnEdge also probably by Perry

function GetLine(vec1, vec2)
	if type(vec1) == "table" then
		vec1 = vec1:GetAbsOrigin()
	end
	if type(vec2) == "table" then
		vec2 = vec2:GetAbsOrigin()
	end
	local a = vec1.y - vec2.y
	local b = vec2.x - vec1.x
	local c = vec1.x * vec2.y - vec2.x * vec1.y
	return a, b, c
end

function GetDistanceToLine(tVec, a, b, c)
	if type(tVec) == "table" then
		tVec = tVec:GetAbsOrigin()
	end
	return math.abs(a*tVec.x + b*tVec.y + c)/math.sqrt(a * a + b * b) -- okay
end

function GetPointOnEdge(vec, angle, radius)
	if type(vec) == "table" then
		vec = vec:GetAbsOrigin()
	end
	return Vector(vec.x + radius*math.cos(angle), vec.y + radius*math.sin(angle), vec.z)
end
	
function magic_block_check(target)
-- checking for spell shields
	local ability_jug = target:FindAbilityByName("juggernaut_enfos_magic_resistance")
	local ability_war = target:FindAbilityByName("warlock_enfos_deflection")
	local ironbark_leathers = target:HasItemInInventory("item_ironbark_leathers")
	local leatherSlot
	
	if ironbark_leathers ~= nil then
		local itemSlot = -1
		for item = 0, 18 do
			if target:GetItemInSlot(item) ~= nil then
				if target:GetItemInSlot(item):GetName() == "item_ironbark_leathers" then
					leatherSlot = target:GetItemInSlot(item)
				end
			end
		end
	end
	
	if ability_jug ~= nil and ability_jug:IsCooldownReady() then
		if target:HasModifier("modifier_item_sphere_target") then
			if ability_jug:GetLevel() == 10 then -- if it's level 10, then he is permanently magic immune. just skipping the whole remove/reapply thing helps avoid crashes.
				target:EmitSound("DOTA_Item.LinkensSphere.Activate")
				return true
			else
				target:RemoveModifierByName("modifier_item_sphere_target")
				target:EmitSound("DOTA_Item.LinkensSphere.Activate")
				ability_jug:StartCooldown(ability_jug:GetCooldown(ability_jug:GetLevel() - 1))
				return true
			end
		end
	elseif ability_war ~= nil and ability_war:IsCooldownReady() then
		if target:HasModifier("modifier_item_sphere_target") then
			target:RemoveModifierByName("modifier_item_sphere_target")
			target:EmitSound("DOTA_Item.LinkensSphere.Activate")
			ability_war:StartCooldown(40)
			return true
		end
	elseif ironbark_leathers ~= nil then
		if target:HasModifier("modifier_item_sphere_target") then
			target:RemoveModifierByName("modifier_item_sphere_target")
			target:EmitSound("DOTA_Item.LinkensSphere.Activate")
			leatherSlot:StartCooldown(4)
			
			return true
		end
	else 
		return false
	end
end
	

  
