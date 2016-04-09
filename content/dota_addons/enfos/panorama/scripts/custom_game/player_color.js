(function()
{
	
	var queryUnitID = Game.GetLocalPlayerID();
	var color = Players.GetPlayerColor(queryUnitID);
	var hero = Players.GetPlayerSelectedHero(queryUnitID);

	//var teamDetails = Players.GetPlayerHeroEntityIndex(queryUnitID);


	//color = ((color % 0x100) << 16) + (((color % 0x10000) / 0x100) << 8) + ((color % 0x1000000) / 0x10000);
	//var r = Math.floor(color / (256*256));
	//var g = Math.floor(color / 256) % 256;
	//var b = Math.floor(color % 256);
	var r = Math.floor(color % 0x100);
	var g = Math.floor((color % 0x10000) / 0x100);
	var b = Math.floor((color % 0x1000000) / 0x10000);


	GameEvents.SendCustomGameEventToServer( "get_player_color", { "key1" : r, "key2" : g, "key3" : b, "key4" : color });

})();