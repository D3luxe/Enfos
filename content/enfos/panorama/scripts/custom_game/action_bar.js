"use strict";
function UpdateTeamPanel()
{
	GameEvents.SendCustomGameEventToServer( "clearTeams", { "key1" : 1 });
 	$.Msg("Updating team panel")
	//Check radiant
	var radiantPlayers = Game.GetPlayerIDsOnTeam( 2 );
    for ( var i = 0; i < radiantPlayers.length; ++i )
    {
        GameEvents.SendCustomGameEventToServer( "updateRadiant", { "key1" : radiantPlayers[i] });
    }

    //Check dire
	var direPlayers = Game.GetPlayerIDsOnTeam( 3 );
    for ( var i = 0; i < direPlayers.length; ++i )
    {
        GameEvents.SendCustomGameEventToServer( "updateDire", { "key1" : direPlayers[i] });
    }
    
    /*var queryUnit = Players.GetLocalPlayerPortraitUnit();
    $.Msg(Entities.GetTeamNumber(queryUnit))
    $.Msg(Game.GetLocalPlayerID())
    if (Entities.GetTeamNumber(queryUnit) == 2) {
    	GameEvents.SendCustomGameEventToServer( "updateRadiant", { "key1" : Game.GetLocalPlayerID() });
    }
    else {
    	GameEvents.SendCustomGameEventToServer( "updateDire", { "key1" : Game.GetLocalPlayerID() });

    }*/

}
function UpdateDire(playerID)
{
	GameEvents.SendCustomGameEventToServer( "updateDire", { "key1" : playerID });
}
function UpdateRadiant( playerID )
{
   GameEvents.SendCustomGameEventToServer( "updateRadiant", { "key1" : playerID });
}

function MakeAbilityPanel( abilityListPanel, ability, queryUnit )
{
	var abilityPanel = $.CreatePanel( "Panel", abilityListPanel, "" );
	abilityPanel.SetAttributeInt( "ability", ability );
	abilityPanel.SetAttributeInt( "queryUnit", queryUnit );
	abilityPanel.BLoadLayout( "file://{resources}/layout/custom_game/action_bar_ability.xml", false, false );	
}

function UpdateAbilityList()
{
	var abilityListPanel = $( "#ability_list" );
	if ( !abilityListPanel )
		return;

	abilityListPanel.RemoveAndDeleteChildren();
	
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if(Entities.GetUnitName(queryUnit) == "npc_spellbringer") {
		UpdateTeamPanel;
		for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
		{
			var ability = Entities.GetAbility( queryUnit, i );
			if ( ability == -1 )
				continue;

			if ( !Abilities.IsDisplayedAbility(ability) )
				continue;
			MakeAbilityPanel( abilityListPanel, ability, queryUnit );
		}


	}
}

(function()
{
	GameEvents.Subscribe( "dota_portrait_ability_layout_changed", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_pick_hero", UpdateTeamPanel );
	
	UpdateAbilityList(); // initial update
})();
