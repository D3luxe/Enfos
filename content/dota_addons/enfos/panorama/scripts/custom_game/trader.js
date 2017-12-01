var SelectedUnit = -1;
var PrevSelect = {};
var CurrentStock = {};
var Cost = {};
Cost[1] = 2;
Cost[2] = 20;
Cost[3] = 100;
Cost[4] = 50;
Cost[5] = 250;
Cost[6] = 150;
Cost[7] = 1500;
Cost[8] = 750;
Cost[9] = 2500;
Cost[10] = 3000;
Cost[11] = 100;

var sunnyboy = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements");
var sunstonepanel = $.CreatePanel("Panel", $.GetContextPanel(), "Sunstone");
var huddy = sunnyboy.FindChildTraverse("topbar");
sunstonepanel.BLoadLayoutSnippet("Sunstone");
sunstonepanel.SetParent(sunnyboy);
sunstonepanel.hittest = false;
sunnyboy.MoveChildBefore(sunstonepanel,huddy);

function ShopSelectedCheck() {
	if (SelectedUnit == -1) $("#GuildShopMenu").visible = false;
	else {
		$("#GuildShopMenu").visible = true;
		var table = {};
		table.shop = SelectedUnit;
		table.player = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
		table.mode = 0;
		GameEvents.SendCustomGameEventToServer("guild_shop_lua_interaction",table);
	}
}

function UnitQuery() {
	var query = Players.GetQueryUnit(Players.GetLocalPlayer());
	//$.Msg("QUERY: "+query)
	if (Entities.GetUnitName(query) == "npc_trader_guild_shop") {
		SelectedUnit = query;
		ShopSelectedCheck();
		
		if (PrevSelect != undefined) {
			var starter = false;
			var newselect = PrevSelect;
			for (i = 0; i < newselect.length; i++) {
				GameUI.SelectUnit(newselect[i],starter);
				if (starter == false) starter = true;
			}
		}
		else{
			GameUI.SelectUnit(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()),false);
		}
	}
	else {
		PrevSelect = undefined;
	}
	/*else {
		SelectedUnit = -1;
		ShopSelectedCheck();
	}*/
}

function UnitSelect() {
	//$.Msg(Players.GetSelectedEntities(Players.GetLocalPlayer()));
	//$.Msg(Entities.GetUnitName(Players.GetLocalPlayerPortraitUnit()));
	var group = {}
	group = Players.GetSelectedEntities(Players.GetLocalPlayer());
	//$.Msg(Entities.GetUnitName(group[0]));
	//$.Msg("GROUP: "+group);
	PrevSelect = group;
}

function GuildShopBuyItem(event) {
	var multi = Cost[event];
	if(event == 2 && CurrentStock[10] != -1) multi = Cost[11];
	if(Players.GetGold(Game.GetLocalPlayerID()) >= multi) {
		if(CurrentStock[event] <= 0) {
			GameEvents.SendEventClientSide("dota_hud_error_message", {"splitscreenplayer":0,"reason":80 ,"message":"#dota_hud_error_item_out_of_stock"} );
			return;
		}
		var table = {};
		table.shop = SelectedUnit;
		table.player = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
		table.mode = 1;
		table.item = $("#ItemSlot"+event.toString()).FindChildTraverse("gotitem").itemname;
		GameEvents.SendCustomGameEventToServer("guild_shop_lua_interaction",table);
	}
	else GameEvents.SendEventClientSide("dota_hud_error_message", {"splitscreenplayer":0,"reason":80 ,"message":"#dota_hud_error_not_enough_gold"} );
}

function UpdateStock(event) {
	if (event.shop == SelectedUnit) {
		if (event.dead == true) {
			CloseButton();
			return;
		}
		if (event.CebiRoot != undefined) CurrentStock[1] = event.CebiRoot;
		if (event.HealPot != undefined) {
			if (event.HealPot == -1 && event.GreatHealPot != -1) {
				CurrentStock[2] = event.GreatHealPot;
				$("#ItemSlot2").FindChildTraverse("gotitem").itemname = "item_trader_potion_of_greater_healing";
			}
			else {
				CurrentStock[2] = event.HealPot;
				$("#ItemSlot2").FindChildTraverse("gotitem").itemname = "item_trader_potion_of_healing";
			}
		}
		if (event.GreatHisan != undefined) CurrentStock[3] = event.GreatHisan;
		if (event.BlinkScroll != undefined) CurrentStock[4] = event.BlinkScroll;
		if (event.LurePouch != undefined) CurrentStock[5] = event.LurePouch;
		if (event.BlockOrb != undefined) CurrentStock[6] = event.BlockOrb;
		if (event.IvoryMail != undefined) CurrentStock[7] = event.IvoryMail;
		if (event.SunStone != undefined) CurrentStock[8] = event.SunStone;
		if (event.DwarvenPride != undefined) CurrentStock[9] = event.DwarvenPride;
		if (event.Bloodstone != undefined) CurrentStock[10] = event.Bloodstone;
		
		for (i=1; i<=10; i++) {
			if (CurrentStock[i] == -1) {
				$("#ItemSlot"+i.toString()).FindChildTraverse("Nope").visible = true;
				$("#ItemSlot"+i.toString()).FindChildTraverse("ItemFont").text = "";
			}
			else {
				$("#ItemSlot"+i.toString()).FindChildTraverse("Nope").visible = false;
				if (CurrentStock[i] == 0) {
					$("#ItemSlot"+i.toString()).FindChildTraverse("OutOfStock").visible = true;
					$("#ItemSlot"+i.toString()).FindChildTraverse("ItemFont").text = "";
				}
				else {
					$("#ItemSlot"+i.toString()).FindChildTraverse("OutOfStock").visible = false;
					$("#ItemSlot"+i.toString()).FindChildTraverse("ItemFont").text = CurrentStock[i];
				}
			}
		}
		
		if (event.InRange == true) $("#RangeBox").visible = false;
		if (event.InRange == false) $("#RangeBox").visible = true;
		
		$("#TimeBox").visible = false;
	}
}

function WasThisTheAnswerAllAlong() {
	$.Msg("oh god dammit");
}

function CloseButton() {
	SelectedUnit = -1;
	$("#TimeBox").visible = true;
	ShopSelectedCheck();
}

function SunstoneToggle(event) {
	if (event.isTrue) {
		sunstonepanel.RemoveClass("Off");
		sunstonepanel.AddClass("On");
		Game.EmitSound("Hero_Silencer.GlobalSilence.Effect");
	}
	if (!event.isTrue) {
		sunstonepanel.RemoveClass("On");
		sunstonepanel.AddClass("Off");
	}
}

(function () {
	ShopSelectedCheck();
	GameEvents.Subscribe("dota_player_update_selected_unit", UnitSelect);
	GameEvents.Subscribe("dota_player_update_query_unit", UnitQuery);
	GameEvents.Subscribe("guild_shop_update", UpdateStock);
	GameEvents.Subscribe("sunstone_use", SunstoneToggle);
	
	/*$("#ItemSlot1").FindChildTraverse("Nope").visible = false;
	$("#ItemSlot2").FindChildTraverse("Nope").visible = true;
	$("#ItemSlot3").FindChildTraverse("Nope").visible = true;
	$("#ItemSlot4").FindChildTraverse("Nope").visible = true;
	$("#ItemSlot5").FindChildTraverse("Nope").visible = true;
	$("#ItemSlot6").FindChildTraverse("Nope").visible = true;
	$("#ItemSlot7").FindChildTraverse("Nope").visible = true;
	$("#ItemSlot8").FindChildTraverse("Nope").visible = true;
	$("#ItemSlot9").FindChildTraverse("Nope").visible = true;
	$("#ItemSlot10").FindChildTraverse("Nope").visible = true;*/
	
	$("#ItemSlot1").FindChildTraverse("OutOfStock").visible = false;
	$("#ItemSlot2").FindChildTraverse("OutOfStock").visible = false;
	$("#ItemSlot3").FindChildTraverse("OutOfStock").visible = false;
	$("#ItemSlot4").FindChildTraverse("OutOfStock").visible = false;
	$("#ItemSlot5").FindChildTraverse("OutOfStock").visible = false;
	$("#ItemSlot6").FindChildTraverse("OutOfStock").visible = false;
	$("#ItemSlot7").FindChildTraverse("OutOfStock").visible = false;
	$("#ItemSlot8").FindChildTraverse("OutOfStock").visible = false;
	$("#ItemSlot9").FindChildTraverse("OutOfStock").visible = false;
	$("#ItemSlot10").FindChildTraverse("OutOfStock").visible = false;
	
	$("#TimeBox").visible = true;
	$("#RangeBox").visible = false;
	
	GameEvents.Subscribe("dota_pause_event", WasThisTheAnswerAllAlong);
	
	sunstonepanel.AddClass("Off");
})();