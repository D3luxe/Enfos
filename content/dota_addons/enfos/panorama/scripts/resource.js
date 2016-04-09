"use strict";

function OnPlayerLumberChanged ( args ) {
	var iPlayerID = Players.GetLocalPlayer()
	var lumber = args.lumber
	$.Msg("Player "+iPlayerID+" Lumber: "+lumber)
	$('#LumberText').text = lumber
}

function AbilityShowTooltip()
{
	var lumberText = $( "#LumberIcon" );
	$.DispatchEvent( "DOTAShowTitleTextTooltip", lumberText, "Available Lumber: "+$('#LumberText').text, "Lumber is used to buy special items from the side shop." );
}

function AbilityHideTooltip()
{
	$.DispatchEvent( "DOTAHideTitleTextTooltip");
}

(function () {
	GameEvents.Subscribe( "player_lumber_changed", OnPlayerLumberChanged );
})();