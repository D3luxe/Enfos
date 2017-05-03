function DoExchange(event){
	var data = {};
	//0-2 - Buy lumber
	//3-5 - Sell lumber
	//$.Msg(radTeam[selectedPlayer])
	//$.Msg(selectedPlayer)
	data.player = Game.GetLocalPlayerID();
	data.type = event;
	GameEvents.SendCustomGameEventToServer("wood_ui_event",data);
}