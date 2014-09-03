function whole_displacement(keys)
	local entSpawner = nil
	local waypoint = nil
	local caster = keys.caster
	local target = keys.target

	if PlayerResource:GetTeam( keys.caster_entindex ) == DOTA_TEAM_GOODGUYS then
		entSpawner = Entities:FindByName( nil, "dire_spawner1" )
		waypoint = Entities:FindByName(nil, "d_wp_5")
	else
		entSpawner = Entities:FindByName( nil, "radiant_spawner1" )
		waypoint = Entities:FindByName( nil, "r_wp_5" )
	end

	if not entSpawner then
		return
	end
	if not waypoint then
		return
	end
	local spawnLocation = entSpawner:GetAbsOrigin()
	FindClearSpaceForUnit(target, spawnLocation, true)
	target:SetInitialGoalEntity(waypoint)
end