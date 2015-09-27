if SpellShopUI == nil then
	SpellShopUI = class({})
end

function SpellShopUI:InitGameMode()
	
	_res = 4;
	
	Convars:RegisterCommand( "buySpell", function(name, _ID, abilityName, _cost, _pnt)
		--print("buySpell: "..name)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerBuySpell( cmdPlayer, _ID, abilityName, _cost, _pnt)
		end
	end, "Add the spell to the player", 0 )
	
	Convars:RegisterCommand( "sellSpell", function(name, _ID, abilityName, _cost, _pnt)
		--print("sellSpell: "..name)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerSellSpell( cmdPlayer, _ID, abilityName, _cost, _pnt)
		end
	end, "Remove the spell from the player", 0 )
	
	Convars:RegisterCommand( "upgradeSpell", function(name, _ID, abilityName, _cost, _pnt)
		--print("upgradeSpell: "..name)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerUpgradeSpell( cmdPlayer, _ID, abilityName, _cost, _pnt)
		end
	end, "Upgrade the spell of the player", 0 )
	
	Convars:RegisterCommand( "buySkillpoint", function(name, _cost)
		--print("buySkillpoint: "..name)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerBuySkillpoint( cmdPlayer, _cost)
		end
	end, "Upgrade the spell of the player", 0 )
	
	Convars:RegisterCommand( "sellSkillpoint", function(name, _cost)
		--print("sellSkillpoint: "..name)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerSellSkillpoint( cmdPlayer, _cost)
		end
	end, "Upgrade the spell of the player", 0 )
	
	--[[ test commands, feel free to remove
	Convars:RegisterCommand( "removeSpell", function(name)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:RemoveAbilities( cmdPlayer )
		end
	end, "Remove abaddons abilities", 0 )]]
	
end

-- function that takes care of buying the spell
function SpellShopUI:PlayerBuySpell( player, _ID, abilityName, _cost, _pnt )
	print("Buy Spell.")
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	if hero == nil then
		return 0
	end
	local team = hero:GetTeam()
	local targetID = 0
	local success = false
	local gold = hero:GetGold()
	local goldTarget = tonumber(_pnt)
	if not GameRules.ItemSharing then
		Notifications:Bottom(hero:GetPlayerID(), {text="Gold sharing is disabled!", duration=3, style={color="red", ["font-size"]="50px"}})
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", hero:GetPlayerOwner())
		return false
	end

	if team == DOTA_TEAM_GOODGUYS then
		nilCheck = GameRules.radiantPlayers[goldTarget]

		if nilCheck ~= nil then
			targetID = nilCheck.id
		else
			return
		end

		if targetID == nil then
			print("ERROR!")
		else
			print("Target ID: "..targetID)
		end

	else
		print("Bad guys")
		nilCheck = GameRules.direPlayers[goldTarget]
		if nilCheck ~= nil then
			targetID = nilCheck.id
		else
			print("Target was nil")
			return
		end

		if targetID == nil then
			print("ERROR!")
		else
			print("Target ID: "..targetID)
		end
	end

	if ( PlayerResource:IsValidPlayer( targetID ) ) then
		local targetPlayer = PlayerResource:GetPlayer(targetID):GetAssignedHero()

		if( gold >= tonumber(_cost) ) and team == targetPlayer:GetTeam() then
			
			if abilityName == "give_gold_10" then
				
				
				hero:SpendGold(tonumber(_cost), DOTA_ModifyGold_Unspecified)

				local targetGold = targetPlayer:GetGold()
				--print("target gold: "..targetGold)
				targetPlayer:ModifyGold(10, false, 1)
				targetGold = targetPlayer:GetGold()
				--print("target gold 2: "..targetGold)
			elseif abilityName == "give_gold_100" then
				
				
				hero:SpendGold(tonumber(_cost), DOTA_ModifyGold_Unspecified)

				local targetGold = targetPlayer:GetGold()
				--print("target gold: "..targetGold)
				targetPlayer:ModifyGold(100, false, 1)
				targetGold = targetPlayer:GetGold()
				--print("target gold 2: "..targetGold)
			elseif abilityName == "give_gold_1000" then
				
				
				hero:SpendGold(tonumber(_cost), DOTA_ModifyGold_Unspecified)

				local targetGold = targetPlayer:GetGold()
				--print("target gold: "..targetGold)
				targetPlayer:ModifyGold(1000, false, 1)
				targetGold = targetPlayer:GetGold()
				--print("target gold 2: "..targetGold)
			elseif abilityName == "give_gold_all" then
				
				local gold = hero:GetGold()
				hero:SpendGold(gold, DOTA_ModifyGold_Unspecified)

				local targetGold = targetPlayer:GetGold()
				--print("target gold: "..targetGold)
				targetPlayer:ModifyGold(gold, false, 1)
				targetGold = targetPlayer:GetGold()
				--print("target gold 2: "..targetGold)
			end
			
		end
	end
	
	
	
end

function SpellShopUI:PlayerUpgradeSpell( player, _ID, abilityName, _cost, _pnt )
	print("Upgrading.")
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	local success = false
	local gold = hero:GetGold()
	
	-- add your code here: ifs, whens, butts..
	if( gold >= tonumber(_cost) ) then
	
		
	end

end

-- function that takes care of selling(removing) the spell
function SpellShopUI:PlayerSellSpell( player, _ID, abilityName, _cost, _pnt)
	print("Selling.")
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	local success = false
	
	
end

function SpellShopUI:PlayerBuySkillpoint( player, _cost)
	print("Buy Skillpoint.")
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	local success = false
	local gold = hero:GetGold()

end

function SpellShopUI:PlayerSellSkillpoint( player, _cost)
	print("Sell Skillpoint.")
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	local success = false
	

end