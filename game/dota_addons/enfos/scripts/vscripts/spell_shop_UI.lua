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
	
	
	CustomGameEventManager:RegisterListener("trade_ui_event", Dynamic_Wrap(SpellShopUI, 'TradeResources'))
	CustomGameEventManager:RegisterListener("wood_ui_event", Dynamic_Wrap(SpellShopUI, 'LumberExchange'))
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
		--nilCheck = GameRules.radiantPlayers[goldTarget]
		nilCheck = PlayerResource:GetNthPlayerIDOnTeam(team,goldTarget)

		if nilCheck ~= nil then
			targetID = nilCheck
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
		--nilCheck = GameRules.direPlayers[goldTarget]
		nilCheck = PlayerResource:GetNthPlayerIDOnTeam(team,goldTarget)
		
		if nilCheck ~= nil then
			targetID = nilCheck
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

function SpellShopUI:TradeResources(keys)
	local playerID = tonumber(keys.player)
	local target = tonumber(keys.target)
	local amount = tonumber(keys.amount)
	local resource = tostring(keys.resource)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	if hero == nil then
		return 0
	end
	local team = hero:GetTeam()
	local targetID = 0
	local success = false
	
	--local goldTarget = tonumber(_pnt)
	if not GameRules.ItemSharing then
		Notifications:Bottom(hero:GetPlayerID(), {text="Resource sharing is disabled!", duration=3, style={color="red", ["font-size"]="50px"}})
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", hero:GetPlayerOwner())
		return false
	end

	--[[if team == DOTA_TEAM_GOODGUYS then
		--nilCheck = GameRules.radiantPlayers[goldTarget]
		--nilCheck = PlayerResource:GetNthPlayerIDOnTeam(team,goldTarget)
		nilCheck = target

		if nilCheck ~= nil then
			targetID = nilCheck
		else
			return
		end

		if targetID == nil then
			print("ERROR!")
		else
			print("Target ID: "..targetID)
		end

	else]]
		--print("Bad guys")
		--nilCheck = GameRules.direPlayers[goldTarget]
		--nilCheck = PlayerResource:GetNthPlayerIDOnTeam(team,goldTarget)
		nilCheck = target
		
		if nilCheck ~= nil then
			targetID = nilCheck
		else
			print("Target was nil")
			return
		end

		if targetID == nil then
			print("ERROR!")
		else
			--print(targetID)
		end
	--end

	if ( PlayerResource:IsValidPlayer( targetID ) ) then
		local targetPlayer = PlayerResource:GetPlayer(targetID):GetAssignedHero()

		if resource == "gold" then
				
			if amount == 0 then amount = 99999 end
			local gold = hero:GetGold()
			if amount > gold then amount = gold end
			local targetGold = targetPlayer:GetGold()
			if targetGold + amount > 99999 then amount = (99999 - targetGold) end
			
			hero:SpendGold(amount, DOTA_ModifyGold_Unspecified)
			
			--print("target gold: "..targetGold)
			targetPlayer:ModifyGold(amount, false, 1)
			--targetGold = targetPlayer:GetGold()
			--print("target gold 2: "..targetGold)
		end
		
		if resource == "lumber" then
				
			if amount == 0 then amount = 99999 end
			local wood = Enfos.lumber[playerID]
			if amount > wood then amount = wood end
			local targetWood = Enfos.lumber[targetID]
			if targetWood + amount > 99999 then amount = (99999 - targetWood) end
			
			ModifyLumber(player,-amount)
			
			--print("wood "..PlayerResource:GetPlayer(targetID).lumber)
			ModifyLumber(PlayerResource:GetPlayer(targetID),amount)
			--print("woode "..PlayerResource:GetPlayer(targetID).lumber)
		end
	end
end

function SpellShopUI:LumberExchange(keys)
	local playerID = tonumber(keys.player)
	local amount = tonumber(keys.type)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	if hero == nil then
		return 0
	end
	if hero:FindModifierByName("modifier_get_wood") == nil then
		CEnfosGameMode:SendErrorMessage(playerID, "#dota_hud_error_secret_shop_not_in_range")
		
		return 0
	end
	
	if amount == 0 then
		if hero:GetGold() >= 125 then
			hero:SpendGold(125, DOTA_ModifyGold_Unspecified)
			ModifyLumber(player,1)
		end
	end
	if amount == 1 then
		if hero:GetGold() >= 1250 then
			hero:SpendGold(1250, DOTA_ModifyGold_Unspecified)
			ModifyLumber(player,10)
		end
	end
	if amount == 2 then
		if hero:GetGold() >= 12500 then
			hero:SpendGold(12500, DOTA_ModifyGold_Unspecified)
			ModifyLumber(player,100)
		end
	end
	if amount == 3 then
		if Enfos.lumber[playerID] >= 1 then
			ModifyLumber(player,-1)
			hero:ModifyGold(100, false, 1)
		end
	end
	if amount == 4 then
		if Enfos.lumber[playerID]  >= 10 then
			ModifyLumber(player,-10)
			hero:ModifyGold(1000, false, 1)
		end
	end
	if amount == 5 then
		if Enfos.lumber[playerID]  >= 100 then
			ModifyLumber(player,-100)
			hero:ModifyGold(10000, false, 1)
		end
	end
end