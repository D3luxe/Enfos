--[[
relevant KV files:
	npc_abilities_custom.txt
		"shared_focus_moonbeam"
		"modspell_focus_moonbeam"
this spell uses frota timers
this spell uses a table that is defined during game mode initialization (EnfosMod.moonbeamActive)
]]
function FocusMoonbeam(keys)
-- vars
	local caster = keys.caster
	local target = keys.target_points[1]
	local pid = caster:GetPlayerID()
-- checks for a previously cast moonbeam unit and, if it exists, destroys it and the timer tied to it. (is this correct behaviour?)
	if EnfosMod.moonbeamActive[pid] ~= nil then
		EnfosMod.moonbeamActive[pid]:Destroy()
		EnfosMod:RemoveTimer("moonbeam_timer" .. pid)
	end
-- creates the moonbeam unit and sets a timer to destroy it after the duration expires
	EnfosMod.moonbeamActive[pid] = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, caster:GetTeamNumber())
	EnfosMod.moonbeamActive[pid]:AddNewModifier(EnfosMod.moonbeamActive[pid], EnfosMod.moonbeamActive[pid], "modifier_invulnerable", {})
	EnfosMod.moonbeamActive[pid]:AddNewModifier(EnfosMod.moonbeamActive[pid], EnfosMod.moonbeamActive[pid], "modifier_phased", {})
	EnfosMod.moonbeamActive[pid]:AddAbility("modspell_focus_moonbeam")
	EnfosMod.moonbeamActive[pid]:FindAbilityByName("modspell_focus_moonbeam"):SetLevel(1)
	EnfosMod:CreateTimer("moonbeam_timer" .. pid, {
		useGameTime = true,
		endTime = GameRules:GetGameTime() + 300,
		callback = function(funct, args)
			if EnfosMod.moonbeamActive[pid] ~= nil then
				EnfosMod.moonbeamActive[pid]:Destroy()
				EnfosMod.moonbeamActive[pid] = nil
			end
		end
	})
-- placeholder particle
	local cPart = ParticleManager:CreateParticle("alchemist_acid_spray", PATTACH_ABSORIGIN_FOLLOW, EnfosMod.moonbeamActive[pid])	
	ParticleManager:SetParticleControl(cPart,0,Vector(0,0,0))	
	ParticleManager:SetParticleControl(cPart,1,Vector(100,1,1))	
	ParticleManager:SetParticleControl(cPart,16,Vector(1,0,0))	
end

