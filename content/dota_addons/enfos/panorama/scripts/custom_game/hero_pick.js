var radTeam = {};
var dirTeam = {};
var selectedPlayer = -1;
var heroData = {};
var shifter = 0;
var mapData = {};

GameEvents.Subscribe("hero_change",UpdatePickUI);
GameEvents.Subscribe("hero_hover",UpdatePrePickIcon);
GameEvents.Subscribe("pause_check",PauseCheck);
GameEvents.Subscribe("ui_chat_update",ChatUpdate);

function UpdatePickUI() {
	var pID = Game.GetLocalPlayerID();
	radTeam = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);
	dirTeam = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS);
	$('#RadiantPlayerBox1').visible = false;
	$('#RadiantPlayerBox2').visible = false;
	$('#RadiantPlayerBox3').visible = false;
	$('#RadiantPlayerBox4').visible = false;
	$('#RadiantPlayerBox5').visible = false;
	$('#DirePlayerBox1').visible = false;
	$('#DirePlayerBox2').visible = false;
	$('#DirePlayerBox3').visible = false;
	$('#DirePlayerBox4').visible = false;
	$('#DirePlayerBox5').visible = false;
	var order = 1;
	for (var playerID in radTeam) {
		//var pData = Game.GetPlayerInfo(parseInt(playerID));
		var hero = Players.GetPlayerSelectedHero(parseInt(radTeam[playerID]));
		var color = Players.GetPlayerColor(parseInt(radTeam[playerID]));
		var name = Players.GetPlayerName(parseInt(radTeam[playerID]));
		var icon = heroData[parseInt(radTeam[playerID])];
		color = color.toString(16);
		color = color.match(/[a-fA-F0-9]{2}/g).reverse().join('');
		
		//$.Msg('#RadiantPlayerBox'+order.toString());
		if (hero == "npc_dota_hero_wisp") {
			if (Players.GetTeam(pID) == 2) {
				if (icon == undefined
				|| icon == "npc_dota_hero_random"
				|| icon == "npc_dota_hero_random_combat"
				|| icon == "npc_dota_hero_random_caster"
				|| icon == "npc_dota_hero_random_support"
				|| icon == "npc_dota_hero_random_rounded") {
					$('#RadiantPlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").style.backgroundImage = 'url("s2r://panorama/images/heroes/npc_dota_hero_wisp_png.vtex")';
				}
				else {$('#RadiantPlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ icon +'_png.vtex")';}
			}
			else {$('#RadiantPlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").style.backgroundImage = 'url("")';}
		}
		else {$('#RadiantPlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ hero +'_png.vtex")';}
		$('#RadiantPlayerBox'+order.toString()).FindChildTraverse("PlayerColor").style.backgroundColor = '#'+color;
		$('#RadiantPlayerBox'+order.toString()).FindChildTraverse("PlayerLabel").text = name;
		$('#RadiantPlayerBox'+order.toString()).visible = true;
		//if (radTeam[playerID] == selectedPlayer) {
			//$('#ButtonGlow'+toString(order)).visible = true;
			//$('#ButtonArrow'+toString(order)).visible = true;
		//}
		if (hero == "npc_dota_hero_wisp") {$('#RadiantPlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").AddClass("Desaturate");}
		else {$('#RadiantPlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").RemoveClass("Desaturate");}
		order += 1;
	}
	order = 1;
	for (var playerID in dirTeam) {
		//var pData = Game.GetPlayerInfo(parseInt(playerID));
		var hero = Players.GetPlayerSelectedHero(parseInt(dirTeam[playerID]));
		var color = Players.GetPlayerColor(parseInt(dirTeam[playerID]));
		var name = Players.GetPlayerName(parseInt(dirTeam[playerID]));
		var icon = heroData[parseInt(dirTeam[playerID])];
		color = color.toString(16);
		color = color.match(/[a-fA-F0-9]{2}/g).reverse().join('');
		
		//$.Msg('#DirePlayerBox'+order.toString());
		if (hero == "npc_dota_hero_wisp") {
			if (Players.GetTeam(pID) == 3) {
				if (icon == undefined
				|| icon == "npc_dota_hero_random"
				|| icon == "npc_dota_hero_random_combat"
				|| icon == "npc_dota_hero_random_caster"
				|| icon == "npc_dota_hero_random_support"
				|| icon == "npc_dota_hero_random_rounded") {
					$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").style.backgroundImage = 'url("s2r://panorama/images/heroes/npc_dota_hero_wisp_png.vtex")';
				}
				else {$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ icon +'_png.vtex")';}
			}
			else {$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").style.backgroundImage = 'url("")';}
		}
		else {$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ hero +'_png.vtex")';}
		$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerColor").style.backgroundColor = '#'+color;
		$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerLabel").text = name;
		$('#DirePlayerBox'+order.toString()).visible = true;
		//if (radTeam[playerID] == selectedPlayer) {
			//$('#ButtonGlow'+toString(order)).visible = true;
			//$('#ButtonArrow'+toString(order)).visible = true;
		//}
		if (hero == "npc_dota_hero_wisp") {$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").AddClass("Desaturate");}
		else {$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").RemoveClass("Desaturate");}
		order += 1;
	}
	PickCheck();
	MapIconUpdate(0);
}

function UpdatePrePickIcon(event) {
	if (event.hero == "mapupdate") {
		mapData[event.pid] = event.mapnum;
		MapIconUpdate(0);
	}
	else {
		heroData[event.pid] = event.hero;
		UpdatePickUI();
	}
}

function PickCheck() {
	if (Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()) != "npc_dota_hero_wisp"
	&& Math.floor(Game.GetDOTATime(false,true)) >= -10) {
		$("#PickUIBase").visible = false;
		GameUI.SetCameraTarget(-1);
	} else {
		$("#PickUIBase").visible = true;
		GameUI.SetCameraTarget(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()));
		
		//$('#PortraitBox').visible = false;
		//$('#StatBox').visible = false;
		//$('#SpellBox').visible = false;
		//$('#PortraitLabel').visible = false;
		//$('#WelcomeBox').visible = true;
	}
	ChatBoxCheck();
}

function HeroButtonPressed(event) {
	//$.Msg(event);
	//var hero = CustomNetTables.GetTableValue("hero_data", "stats");
	if(event == "npc_dota_hero_meepo") {return 0;}
	
	//but first, this
	var table = {};
	table.hero = event;
	table.player = Game.GetLocalPlayerID();
	$.Msg(table.player);
	GameEvents.SendCustomGameEventToServer("hero_button_pressed",table);
	$('#FinalPickLabel').text = ("PICK "+$.Localize("#"+event)).toUpperCase();
	$('#PortraitLabel').text = $.Localize("#"+event).toUpperCase();
	
	if(event == "npc_dota_hero_random"
	|| event == "npc_dota_hero_random_combat"
	|| event == "npc_dota_hero_random_caster"
	|| event == "npc_dota_hero_random_support"
	|| event == "npc_dota_hero_random_rounded") {
		$('#PortraitBox').visible = false;
		$('#StatBox').visible = false;
		$('#SpellBox').visible = false;
		$('#PortraitLabel').visible = true;
		//$('#WelcomeBox').visible = true;
		$('#WelcomeLabel').visible = true;
		return 0;
	}
	
	$('#PortraitBox').visible = true;
	$('#StatBox').visible = true;
	$('#SpellBox').visible = true;
	$('#PortraitLabel').visible = true;
	$('#PortraitLabel').text = $.Localize("#"+event).toUpperCase();
	$('#WelcomeBox').visible = false;
	$('#WelcomeLabel').visible = false;
	
	//switching webms rawdog causes render errors. need to delay it slightly
	$('#PortraitWebm').visible = false;
	$.Schedule(0.1,function() {
		$('#PortraitWebm').visible = true;
		$('#PortraitWebm').heroname = event;
	});
	
	//attributes
	$('#AttStrBox').FindChildTraverse("AttGlowBox").visible = false;
	$('#AttAgiBox').FindChildTraverse("AttGlowBox").visible = false;
	$('#AttIntBox').FindChildTraverse("AttGlowBox").visible = false;
	if (heroData[event].baseatt == "DOTA_ATTRIBUTE_STRENGTH") {
		$('#AttStrBox').FindChildTraverse("AttGlowBox").visible = true;
	}
	if (heroData[event].baseatt == "DOTA_ATTRIBUTE_AGILITY") {
		$('#AttAgiBox').FindChildTraverse("AttGlowBox").visible = true;
	}
	if (heroData[event].baseatt == "DOTA_ATTRIBUTE_INTELLECT") {
		$('#AttIntBox').FindChildTraverse("AttGlowBox").visible = true;
	}
	$('#AttStrBox').FindChildTraverse("AttBigLabel").text = heroData[event].str;
	$('#AttAgiBox').FindChildTraverse("AttBigLabel").text = heroData[event].agi;
	$('#AttIntBox').FindChildTraverse("AttBigLabel").text = heroData[event].int;
	$('#AttStrBox').FindChildTraverse("AttSmallLabel").text = "(+"+Math.round(heroData[event].strpl * 100) / 100+")";
	$('#AttAgiBox').FindChildTraverse("AttSmallLabel").text = "(+"+Math.round(heroData[event].agipl * 100) / 100+")";
	$('#AttIntBox').FindChildTraverse("AttSmallLabel").text = "(+"+Math.round(heroData[event].intpl * 100) / 100+")";
	
	//attack and armor types
	if(event == "npc_dota_hero_lina") {$('#AttLeftBox').visible = false;} else {
		$('#AttLeftBox').visible = true;
		if(heroData[event].atktype == "modifier_attack_normal") {
			$('#AttLeftBox').FindChildTraverse("AttTinyLabel").text = "Normal";
			$('#AttLeftBox').FindChildTraverse("oops").SetImage("file://{images}/items/broadsword.png");
			$('#AttLeftBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttLeftBox'), "#DOTA_Tooltip_modifier_attack_normal_Description");
			});
			$('#AttLeftBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttLeftBox'));
			});
		}
		if(heroData[event].atktype == "modifier_attack_pierce") {
			$('#AttLeftBox').FindChildTraverse("AttTinyLabel").text = "Piercing";
			$('#AttLeftBox').FindChildTraverse("oops").SetImage("file://{images}/items/javelin.png");
			$('#AttLeftBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttLeftBox'), "#DOTA_Tooltip_modifier_attack_pierce_Description");
			});
			$('#AttLeftBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttLeftBox'));
			});
		}
		if(heroData[event].atktype == "modifier_attack_siege") {
			$('#AttLeftBox').FindChildTraverse("AttTinyLabel").text = "Siege";
			$('#AttLeftBox').FindChildTraverse("oops").SetImage("file://{images}/items/mythril_hammer.png");
			$('#AttLeftBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttLeftBox'), "#DOTA_Tooltip_modifier_attack_siege_Description");
			});
			$('#AttLeftBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttLeftBox'));
			});
		}
		if(heroData[event].atktype == "modifier_attack_chaos") {
			$('#AttLeftBox').FindChildTraverse("AttTinyLabel").text = "Chaos";
			$('#AttLeftBox').FindChildTraverse("oops").SetImage("file://{images}/items/silver_edge.png");
			$('#AttLeftBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttLeftBox'), "#DOTA_Tooltip_modifier_attack_chaos_Description");
			});
			$('#AttLeftBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttLeftBox'));
			});
		}
		if(heroData[event].atktype == "modifier_attack_hero") {
			$('#AttLeftBox').FindChildTraverse("AttTinyLabel").text = "Hero";
			$('#AttLeftBox').FindChildTraverse("oops").SetImage("file://{images}/items/radiance.png");
			$('#AttLeftBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttLeftBox'), "#DOTA_Tooltip_modifier_attack_hero_Description");
			});
			$('#AttLeftBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttLeftBox'));
			});
		}
		if(heroData[event].atktype == "modifier_attack_magical") {
			$('#AttLeftBox').FindChildTraverse("AttTinyLabel").text = "Magical";
			$('#AttLeftBox').FindChildTraverse("oops").SetImage("file://{images}/items/magic_wand.png");
			$('#AttLeftBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttLeftBox'), "#DOTA_Tooltip_modifier_attack_magical_Description");
			});
			$('#AttLeftBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttLeftBox'));
			});
		}
	}
	if(heroData[event].armtype == "modifier_armor_unarmored") {
		$('#AttRightBox').FindChildTraverse("AttTinyLabel").text = "Unarmored";
		$('#AttRightBox').FindChildTraverse("oops").SetImage("file://{images}/items/belt_of_strength.png");
		$('#AttRightBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttRightBox'), "#DOTA_Tooltip_modifier_armor_unarmored_Description");
			});
			$('#AttRightBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttRightBox'));
			});
	}
	if(heroData[event].armtype == "modifier_armor_light") {
		$('#AttRightBox').FindChildTraverse("AttTinyLabel").text = "Light";
		$('#AttRightBox').FindChildTraverse("oops").SetImage("file://{images}/items/stout_shield.png");
		$('#AttRightBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttRightBox'), "#DOTA_Tooltip_modifier_armor_light_Description");
			});
			$('#AttRightBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttRightBox'));
			});
	}
	if(heroData[event].armtype == "modifier_armor_medium") {
		$('#AttRightBox').FindChildTraverse("AttTinyLabel").text = "Medium";
		$('#AttRightBox').FindChildTraverse("oops").SetImage("file://{images}/items/buckler.png");
		$('#AttRightBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttRightBox'), "#DOTA_Tooltip_modifier_armor_medium_Description");
			});
			$('#AttRightBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttRightBox'));
			});
	}
	if(heroData[event].armtype == "modifier_armor_heavy") {
		$('#AttRightBox').FindChildTraverse("AttTinyLabel").text = "Heavy";
		$('#AttRightBox').FindChildTraverse("oops").SetImage("file://{images}/items/shivas_guard.png");
		$('#AttRightBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttRightBox'), "#DOTA_Tooltip_modifier_armor_heavy_Description");
			});
			$('#AttRightBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttRightBox'));
			});
	}
	if(heroData[event].armtype == "modifier_armor_fortified") {
		$('#AttRightBox').FindChildTraverse("AttTinyLabel").text = "Fortified";
		$('#AttRightBox').FindChildTraverse("oops").SetImage("file://{images}/items/blade_mail.png");
		$('#AttRightBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttRightBox'), "#DOTA_Tooltip_modifier_armor_fortified_Description");
			});
			$('#AttRightBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttRightBox'));
			});
	}
	if(heroData[event].armtype == "modifier_armor_hero") {
		$('#AttRightBox').FindChildTraverse("AttTinyLabel").text = "Hero";
		$('#AttRightBox').FindChildTraverse("oops").SetImage("file://{images}/items/solar_crest.png");
		$('#AttRightBox').SetPanelEvent(
			"onmouseover",
			function(){
				$.DispatchEvent("DOTAShowTextTooltip", $('#AttRightBox'), "#DOTA_Tooltip_modifier_armor_hero_Description");
			});
			$('#AttRightBox').SetPanelEvent(
			"onmouseout",
			function(){
				$.DispatchEvent("DOTAHideTextTooltip", $('#AttRightBox'));
			});
	}
	
	//hp and mp
	$('#HeroHPBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].hp;
	$('#HeroMPBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].mp;
	
	//damage
	if(event == "npc_dota_hero_lina") {
		$('#HeroAtkBox').FindChildTraverse("AttHeroSmallLabel").text = "--";
		$('#HeroAspBox').FindChildTraverse("AttHeroSmallLabel").text = "--";
		$('#HeroRngBox').FindChildTraverse("AttHeroSmallLabel").text = "--";
	}
	else {
		$('#HeroAtkBox').FindChildTraverse("AttHeroSmallLabel").text =
		heroData[event].atkmin+"-"+heroData[event].atkmax;
		$('#HeroAspBox').FindChildTraverse("AttHeroSmallLabel").text = Math.round((1/heroData[event].atkspd) * 100) / 100+"/s";
		if (heroData[event].atkrng < 200){
			$('#HeroRngBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].atkrng+" (Melee)";
		}
		else {
			if(event == "npc_dota_hero_drow_ranger") $('#HeroRngBox').FindChildTraverse("AttHeroSmallLabel").text = "250-"+heroData[event].atkrng;
			else $('#HeroRngBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].atkrng;
		}
	}
	
	//armor and speed
	$('#HeroArmBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].armor;
	$('#HeroMRBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].mr+"%";
	$('#HeroSpdBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].speed;
	
	//abilities
	var slot1 = $('#SpellInfo1').FindChildTraverse("IWasTagged")
	var slot2 = $('#SpellInfo2').FindChildTraverse("IWasTagged")
	var slot3 = $('#SpellInfo3').FindChildTraverse("IWasTagged")
	var slot4 = $('#SpellInfo4').FindChildTraverse("IWasTagged")
	var slot5 = $('#SpellInfo5').FindChildTraverse("IWasTagged")
	var slot6 = $('#SpellInfo6').FindChildTraverse("IWasTagged")
	slot1.abilityname = heroData[event].spell1;
	slot1.SetPanelEvent("onmouseover",function(){
		$.DispatchEvent("DOTAShowAbilityTooltip", slot1, heroData[event].spell1);
	});
	slot1.SetPanelEvent("onmouseout",function(){
		$.DispatchEvent("DOTAHideAbilityTooltip",slot1);
	});
	slot2.abilityname = heroData[event].spell2;
	slot2.SetPanelEvent("onmouseover",function(){
		$.DispatchEvent("DOTAShowAbilityTooltip", slot2, heroData[event].spell2);
	});
	slot2.SetPanelEvent("onmouseout",function(){
		$.DispatchEvent("DOTAHideAbilityTooltip",slot2);
	});
	slot3.abilityname = heroData[event].spell3;
	slot3.SetPanelEvent("onmouseover",function(){
		$.DispatchEvent("DOTAShowAbilityTooltip", slot3, heroData[event].spell3);
	});
	slot3.SetPanelEvent("onmouseout",function(){
		$.DispatchEvent("DOTAHideAbilityTooltip",slot3);
	});
	slot4.abilityname = heroData[event].spell4;
	slot4.SetPanelEvent("onmouseover",function(){
		$.DispatchEvent("DOTAShowAbilityTooltip", slot4, heroData[event].spell4);
	});
	slot4.SetPanelEvent("onmouseout",function(){
		$.DispatchEvent("DOTAHideAbilityTooltip",slot4);
	});
	slot5.abilityname = heroData[event].spell5;
	slot5.SetPanelEvent("onmouseover",function(){
		$.DispatchEvent("DOTAShowAbilityTooltip", slot5, heroData[event].spell5);
	});
	slot5.SetPanelEvent("onmouseout",function(){
		$.DispatchEvent("DOTAHideAbilityTooltip",slot5);
	});
	if (heroData[event].spell6 == "" || heroData[event].spell6 == "ahlen_cataclysmic_strike_proxy") {
		$('#SpellInfo6').visible = false;
	} else {
		$('#SpellInfo6').visible = true;
		slot6.abilityname = heroData[event].spell6;
		slot6.SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", slot6, heroData[event].spell6);
		});
		slot6.SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip",slot6);
		});
	}
}

function PickButtonPressed() {
	var data = {};
	data.player = Game.GetLocalPlayerID();
	data.hero = heroData[data.player];
	
	var color = Players.GetPlayerColor(data.player);
	color = color.toString(16);
	color = color.match(/[a-fA-F0-9]{2}/g).reverse().join('');
	
	data.color = color
	//$.Msg(data.hero)
	GameEvents.SendCustomGameEventToServer("player_repick",data);
	PickCheck();
}

function HeroDataTableFill() {
	heroData = CustomNetTables.GetTableValue("hero_data","stats");
	//$.Msg(heroData.npc_dota_hero_bounty_hunter.str);
}

function UpdateTimer() {
	//if (CustomNetTables.GetTableValue("this_wave_table","round").value >= 4
	//&& $('#PickUIBase').visible == true){
		//$('#PickUIBase').visible = false;
		//$("#UIMask").visible = false;
		//heroData[Game.GetLocalPlayerID()] = "npc_dota_hero_random";
		//PickButtonPressed();
	//}
	var time = Math.floor(Game.GetDOTATime(false,true));
	var realTime = 0;
	if (time < 0) {
		realTime = Math.abs(time) - 10;
		if (time >= -10) {
			realTime = Math.abs(time);
			$('#RoundLabel').text = "GAME STARTS IN";
			if($("#PickUIBase").visible == true) PickCheck();
		}
	}
	else {
		var second = (time%60).toString();
		if (second.length < 2) {second = "0"+second;}
		realTime = (Math.floor(time/60)).toString()+":"+second;
		$('#RoundLabel').text = "WAVE "+CustomNetTables.GetTableValue("this_wave_table","round").value.toString();
	}
	$('#TimeLabel').text = realTime;
	$('#PickRandomVideo').RemoveClass("OhGodNoItsTerrible"+shifter);
	shifter += 1;
	if(shifter == 120) shifter = 0;
	$('#PickRandomVideo').AddClass("OhGodNoItsTerrible"+shifter);
	$.Schedule(0.1,function() {UpdateTimer();});
}

function ChatBoxCheck() {
	//$('#ChatBox').DOTAChatCancelMessageMode();
	//$('#DOTAChatDoesntWorkCorrectlySoNowIHaveToDoThisBox').DOTAChatCancelMessageMode();
	$.Msg($("#PickUIBase").visible);
	if($("#PickUIBase").visible == false) {
		$('#ChatField').SetAcceptsFocus(false);
		$.DispatchEvent("DropInputFocus", $('#ChatField'));
	}
	else
	{
		$('#ChatField').SetAcceptsFocus(true);
		$('#ChatField').SetFocus();
	}
}

function ChatBoxClear() {
	$('#ChatField').text = "";
}

function ChatBoxEnter() {
	var data = {};
	data.player = Game.GetLocalPlayerID();
	data.msg = $('#ChatField').text;
	data.team = true;
	$.Msg(data.msg);
	if (data.msg.substr(0,5) == "/all ")
	{
		data.team = false;
		data.msg = data.msg.replace("/all ","");
	}
	$.Msg(data.msg);
	GameEvents.SendCustomGameEventToServer("pick_ui_chat",data);
	
	ChatBoxClear();
}

function ChatUpdate(event) {
	if (event.msg.substr(0,1) == "/" || event.msg.substr(0,1) == "-") return 0;
	if (Players.GetTeam(Game.GetLocalPlayerID()) != Players.GetTeam(event.pid) && event.team) return 0;
	var hero = Players.GetPlayerSelectedHero(event.pid);
	var color = Players.GetPlayerColor(event.pid);
	var name = Players.GetPlayerName(event.pid);
	color = color.toString(16);
	color = color.match(/[a-fA-F0-9]{2}/g).reverse().join('');
	var newLine = $.CreatePanel("Label", $("#ChatLinesInner"), "");
	newLine.AddClass("AChatLine");
	newLine.html = true;
	newLine.text = event.msg;
	if (event.pid != -1)
	{
		var img = $.CreatePanel("Image", newLine, "ChatLinePic");
		img.SetImage("s2r://panorama/images/heroes/"+hero+"_png.vtex");
		if(event.team) newLine.text = "|||||||||||| (Allies) <font color='#"+color+"'>"+name+":</font> "+newLine.text;
		else newLine.text = "|||||||||||| <font color='#"+color+"'>"+name+"</font>: "+newLine.text;
		//newLine.text = "             "+newLine.text;
	}
	$("#ChatLines").ScrollToTop();
}

function TogglePause() {
	var data = {};
	data.player = Game.GetLocalPlayerID();
	GameEvents.SendCustomGameEventToServer("toggle_pause",data);
}

function PauseCheck() {
	if(Game.IsGamePaused()) {$('#PauseLabel').text = "UNPAUSE";}
	else {$('#PauseLabel').text = "PAUSE";}
}

function MapButtonHover(event) {
	if(event == 0) $('#MapLaneLabel').text = "";
	if(event == 1) $('#MapLaneLabel').text = "Left Lane";
	if(event == 2) $('#MapLaneLabel').text = "Right Lane";
	if(event == 3) $('#MapLaneLabel').text = "Middle Lane";
	if(event == 4) $('#MapLaneLabel').text = "Left Teleport";
	if(event == 5) $('#MapLaneLabel').text = "Right Teleport";
	if(event == 6) $('#MapLaneLabel').text = "Shop";
}
function MapButtonPressed(event) {
	//mapData[Game.GetLocalPlayerID()] = event;
	var table = {};
	table.hero = "mapupdate";
	table.player = Game.GetLocalPlayerID();
	table.mapnum = event;
	GameEvents.SendCustomGameEventToServer("hero_button_pressed",table);
	/*$('#IconContainer').FindChildTraverse("HeroMapIcon1").SetImage("");
	$('#IconContainer').FindChildTraverse("HeroMapIcon2").SetImage("");
	$('#IconContainer').FindChildTraverse("HeroMapIcon3").SetImage("");
	$('#IconContainer').FindChildTraverse("HeroMapIcon4").SetImage("");
	$('#IconContainer').FindChildTraverse("HeroMapIcon5").SetImage("");
	
	$('#LeftLaneButton').FindChildTraverse("HeroMapIcon1").visible = false;
	$('#LeftLaneButton').FindChildTraverse("HeroMapIcon2").visible = false;
	$('#LeftLaneButton').FindChildTraverse("HeroMapIcon3").visible = false;
	$('#LeftLaneButton').FindChildTraverse("HeroMapIcon4").visible = false;
	$('#LeftLaneButton').FindChildTraverse("HeroMapIcon5").visible = false;
	
	$('#RightLaneButton').FindChildTraverse("HeroMapIcon1").visible = false;
	$('#RightLaneButton').FindChildTraverse("HeroMapIcon2").visible = false;
	$('#RightLaneButton').FindChildTraverse("HeroMapIcon3").visible = false;
	$('#RightLaneButton').FindChildTraverse("HeroMapIcon4").visible = false;
	$('#RightLaneButton').FindChildTraverse("HeroMapIcon5").visible = false;
	
	$('#MidLaneButton').FindChildTraverse("HeroMapIcon1").visible = false;
	$('#MidLaneButton').FindChildTraverse("HeroMapIcon2").visible = false;
	$('#MidLaneButton').FindChildTraverse("HeroMapIcon3").visible = false;
	$('#MidLaneButton').FindChildTraverse("HeroMapIcon4").visible = false;
	$('#MidLaneButton').FindChildTraverse("HeroMapIcon5").visible = false;
	
	$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon1").visible = false;
	$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon2").visible = false;
	$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon3").visible = false;
	$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon4").visible = false;
	$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon5").visible = false;
	
	$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon1").visible = false;
	$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon2").visible = false;
	$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon3").visible = false;
	$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon4").visible = false;
	$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon5").visible = false;
	
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").visible = false;
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").visible = false;
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").visible = false;
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").visible = false;
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").visible = false;
	
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").RemoveClass("AttentionShoppers");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").RemoveClass("AttentionShoppersMini");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").RemoveClass("AttentionShoppersSmall");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").RemoveClass("AttentionShoppers");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").RemoveClass("AttentionShoppersMini");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").RemoveClass("AttentionShoppersSmall");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").RemoveClass("AttentionShoppers");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").RemoveClass("AttentionShoppersMini");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").RemoveClass("AttentionShoppersSmall");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").RemoveClass("AttentionShoppers");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").RemoveClass("AttentionShoppersMini");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").RemoveClass("AttentionShoppersSmall");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").RemoveClass("AttentionShoppers");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").RemoveClass("AttentionShoppersMini");
	$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").RemoveClass("AttentionShoppersSmall");
	
	if(event > 1) {
		$('#IconContainer').FindChildTraverse("HeroMapIcon1").SetImage("file://{images}/heroes/icons/npc_dota_hero_omniknight.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon1").SetImage("file://{images}/heroes/icons/npc_dota_hero_omniknight.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon1").visible = true;
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon1").SetImage("file://{images}/heroes/icons/npc_dota_hero_omniknight.png");
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon1").visible = true;
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon1").SetImage("file://{images}/heroes/icons/npc_dota_hero_omniknight.png");
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon1").visible = true;
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon1").SetImage("file://{images}/heroes/icons/npc_dota_hero_omniknight.png");
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon1").visible = true;
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon1").SetImage("file://{images}/heroes/icons/npc_dota_hero_omniknight.png");
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon1").visible = true;
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").SetImage("file://{images}/heroes/icons/npc_dota_hero_omniknight.png");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").visible = true;
	}
	if(event > 2) {
		$('#IconContainer').FindChildTraverse("HeroMapIcon2").SetImage("file://{images}/heroes/icons/npc_dota_hero_dragon_knight.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon2").SetImage("file://{images}/heroes/icons/npc_dota_hero_dragon_knight.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon2").visible = true;
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon2").SetImage("file://{images}/heroes/icons/npc_dota_hero_dragon_knight.png");
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon2").visible = true;
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon2").SetImage("file://{images}/heroes/icons/npc_dota_hero_dragon_knight.png");
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon2").visible = true;
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon2").SetImage("file://{images}/heroes/icons/npc_dota_hero_dragon_knight.png");
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon2").visible = true;
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon2").SetImage("file://{images}/heroes/icons/npc_dota_hero_dragon_knight.png");
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon2").visible = true;
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").SetImage("file://{images}/heroes/icons/npc_dota_hero_dragon_knight.png");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").visible = true;
	}
	if(event > 3) {
		$('#IconContainer').FindChildTraverse("HeroMapIcon3").SetImage("file://{images}/heroes/icons/npc_dota_hero_troll_warlord.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon3").SetImage("file://{images}/heroes/icons/npc_dota_hero_troll_warlord.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon3").visible = true;
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon3").SetImage("file://{images}/heroes/icons/npc_dota_hero_troll_warlord.png");
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon3").visible = true;
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon3").SetImage("file://{images}/heroes/icons/npc_dota_hero_troll_warlord.png");
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon3").visible = true;
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon3").SetImage("file://{images}/heroes/icons/npc_dota_hero_troll_warlord.png");
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon3").visible = true;
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon3").SetImage("file://{images}/heroes/icons/npc_dota_hero_troll_warlord.png");
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon3").visible = true;
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").SetImage("file://{images}/heroes/icons/npc_dota_hero_troll_warlord.png");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").visible = true;
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").AddClass("AttentionShoppersMini");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").AddClass("AttentionShoppersMini");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").AddClass("AttentionShoppersMini");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").AddClass("AttentionShoppersMini");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").AddClass("AttentionShoppersMini");
	}
	if(event > 4) {
		$('#IconContainer').FindChildTraverse("HeroMapIcon4").SetImage("file://{images}/heroes/icons/npc_dota_hero_storm_spirit.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon4").SetImage("file://{images}/heroes/icons/npc_dota_hero_storm_spirit.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon4").visible = true;
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon4").SetImage("file://{images}/heroes/icons/npc_dota_hero_storm_spirit.png");
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon4").visible = true;
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon4").SetImage("file://{images}/heroes/icons/npc_dota_hero_storm_spirit.png");
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon4").visible = true;
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon4").SetImage("file://{images}/heroes/icons/npc_dota_hero_storm_spirit.png");
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon4").visible = true;
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon4").SetImage("file://{images}/heroes/icons/npc_dota_hero_storm_spirit.png");
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon4").visible = true;
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").SetImage("file://{images}/heroes/icons/npc_dota_hero_storm_spirit.png");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").visible = true;
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").RemoveClass("AttentionShoppersMini");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").RemoveClass("AttentionShoppersMini");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").RemoveClass("AttentionShoppersMini");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").RemoveClass("AttentionShoppersMini");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").RemoveClass("AttentionShoppersMini");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").AddClass("AttentionShoppersSmall");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").AddClass("AttentionShoppersSmall");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").AddClass("AttentionShoppersSmall");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").AddClass("AttentionShoppersSmall");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").AddClass("AttentionShoppersSmall");
	}
	if(event > 5) {
		$('#IconContainer').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_earth_spirit.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_earth_spirit.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon5").visible = true;
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_earth_spirit.png");
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon5").visible = true;
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_earth_spirit.png");
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon5").visible = true;
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_earth_spirit.png");
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon5").visible = true;
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_earth_spirit.png");
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon5").visible = true;
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_earth_spirit.png");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").visible = true;
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").RemoveClass("AttentionShoppersSmall");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").RemoveClass("AttentionShoppersSmall");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").RemoveClass("AttentionShoppersSmall");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").RemoveClass("AttentionShoppersSmall");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").RemoveClass("AttentionShoppersSmall");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon1").AddClass("AttentionShoppers");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon2").AddClass("AttentionShoppers");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon3").AddClass("AttentionShoppers");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon4").AddClass("AttentionShoppers");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").AddClass("AttentionShoppers");
	}
	if(event > 6) {
		$('#IconContainer').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_wisp.png");
		$('#LeftLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_wisp.png");
		$('#RightLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_wisp.png");
		$('#MidLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_wisp.png");
		$('#LeftHighLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_wisp.png");
		$('#RightHighLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_wisp.png");
		$('#ShopLaneButton').FindChildTraverse("HeroMapIcon5").SetImage("file://{images}/heroes/icons/npc_dota_hero_wisp.png");
	}*/
	//MapIconUpdate(event);
}
function MapIconUpdate(event) {
	var base = $('#IconContainer');
	var left = $('#LeftLaneButton');
	var right = $('#RightLaneButton');
	var mid = $('#MidLaneButton');
	var upleft = $('#LeftHighLaneButton');
	var upright = $('#RightHighLaneButton');
	var shop = $('#ShopLaneButton');
	
	base.FindChildTraverse("HeroMapIcon1").SetImage("");
	base.FindChildTraverse("HeroMapIcon2").SetImage("");
	base.FindChildTraverse("HeroMapIcon3").SetImage("");
	base.FindChildTraverse("HeroMapIcon4").SetImage("");
	base.FindChildTraverse("HeroMapIcon5").SetImage("");
	
	left.FindChildTraverse("HeroMapIcon1").visible = false;
	left.FindChildTraverse("HeroMapIcon2").visible = false;
	left.FindChildTraverse("HeroMapIcon3").visible = false;
	left.FindChildTraverse("HeroMapIcon4").visible = false;
	left.FindChildTraverse("HeroMapIcon5").visible = false;
	
	right.FindChildTraverse("HeroMapIcon1").visible = false;
	right.FindChildTraverse("HeroMapIcon2").visible = false;
	right.FindChildTraverse("HeroMapIcon3").visible = false;
	right.FindChildTraverse("HeroMapIcon4").visible = false;
	right.FindChildTraverse("HeroMapIcon5").visible = false;
	
	mid.FindChildTraverse("HeroMapIcon1").visible = false;
	mid.FindChildTraverse("HeroMapIcon2").visible = false;
	mid.FindChildTraverse("HeroMapIcon3").visible = false;
	mid.FindChildTraverse("HeroMapIcon4").visible = false;
	mid.FindChildTraverse("HeroMapIcon5").visible = false;
	
	upleft.FindChildTraverse("HeroMapIcon1").visible = false;
	upleft.FindChildTraverse("HeroMapIcon2").visible = false;
	upleft.FindChildTraverse("HeroMapIcon3").visible = false;
	upleft.FindChildTraverse("HeroMapIcon4").visible = false;
	upleft.FindChildTraverse("HeroMapIcon5").visible = false;
	
	upright.FindChildTraverse("HeroMapIcon1").visible = false;
	upright.FindChildTraverse("HeroMapIcon2").visible = false;
	upright.FindChildTraverse("HeroMapIcon3").visible = false;
	upright.FindChildTraverse("HeroMapIcon4").visible = false;
	upright.FindChildTraverse("HeroMapIcon5").visible = false;
	
	shop.FindChildTraverse("HeroMapIcon1").visible = false;
	shop.FindChildTraverse("HeroMapIcon2").visible = false;
	shop.FindChildTraverse("HeroMapIcon3").visible = false;
	shop.FindChildTraverse("HeroMapIcon4").visible = false;
	shop.FindChildTraverse("HeroMapIcon5").visible = false;
	
	var order = 1;
	if (Players.GetTeam(Game.GetLocalPlayerID()) == 2) {
		for (var playerID in radTeam) {
			//var pData = Game.GetPlayerInfo(parseInt(playerID));
			var hero = Players.GetPlayerSelectedHero(parseInt(radTeam[playerID]));
			var color = Players.GetPlayerColor(parseInt(radTeam[playerID]));
			var name = Players.GetPlayerName(parseInt(radTeam[playerID]));
			var icon = heroData[parseInt(radTeam[playerID])];
			color = color.toString(16);
			color = color.match(/[a-fA-F0-9]{2}/g).reverse().join('');
			
			if (mapData[parseInt(radTeam[playerID])] == undefined) mapData[parseInt(radTeam[playerID])] = 0;
			var mapPlace
			switch(mapData[parseInt(radTeam[playerID])]) {
				case 0:
					mapPlace = base;
					break;
				case 1:
					mapPlace = left;
					break;
				case 2:
					mapPlace = right;
					break;
				case 3:
					mapPlace = mid;
					break;
				case 4:
					mapPlace = upleft;
					break;
				case 5:
					mapPlace = upright;
					break;
				case 6:
					mapPlace = shop;
					break;
			}
			
			mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).visible = true;
			if (hero == "npc_dota_hero_wisp") {
				if (icon == undefined
				|| icon == "npc_dota_hero_random"
				|| icon == "npc_dota_hero_random_combat"
				|| icon == "npc_dota_hero_random_caster"
				|| icon == "npc_dota_hero_random_support"
				|| icon == "npc_dota_hero_random_rounded") {
					mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).SetImage('file://{images}/heroes/icons/npc_dota_hero_wisp.png');
				}
				else {mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).SetImage('file://{images}/heroes/icons/'+ icon +'.png');}
			}
			else {mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).SetImage('file://{images}/heroes/icons/'+ hero +'.png');}
			
			if (hero == "npc_dota_hero_wisp") {mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).AddClass("Desaturate");}
			else {mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).RemoveClass("Desaturate");}
			order += 1;
		}
	}
	if (Players.GetTeam(Game.GetLocalPlayerID()) == 3) {
		for (var playerID in dirTeam) {
			//var pData = Game.GetPlayerInfo(parseInt(playerID));
			var hero = Players.GetPlayerSelectedHero(parseInt(dirTeam[playerID]));
			var color = Players.GetPlayerColor(parseInt(dirTeam[playerID]));
			var name = Players.GetPlayerName(parseInt(dirTeam[playerID]));
			var icon = heroData[parseInt(dirTeam[playerID])];
			color = color.toString(16);
			color = color.match(/[a-fA-F0-9]{2}/g).reverse().join('');
			
			if (mapData[parseInt(dirTeam[playerID])] == undefined) mapData[parseInt(dirTeam[playerID])] = 0;
			var mapPlace
			switch(mapData[parseInt(dirTeam[playerID])]) {
				case 0:
					mapPlace = base;
					break;
				case 1:
					mapPlace = left;
					break;
				case 2:
					mapPlace = right;
					break;
				case 3:
					mapPlace = mid;
					break;
				case 4:
					mapPlace = upleft;
					break;
				case 5:
					mapPlace = upright;
					break;
				case 6:
					mapPlace = shop;
					break;
			}
			
			mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).visible = true;
			if (hero == "npc_dota_hero_wisp") {
				if (icon == undefined
				|| icon == "npc_dota_hero_random"
				|| icon == "npc_dota_hero_random_combat"
				|| icon == "npc_dota_hero_random_caster"
				|| icon == "npc_dota_hero_random_support"
				|| icon == "npc_dota_hero_random_rounded") {
					mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).SetImage('file://{images}/heroes/icons/npc_dota_hero_wisp.png');
				}
				else {mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).SetImage('file://{images}/heroes/icons/'+ icon +'.png');}
			}
			else {mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).SetImage('file://{images}/heroes/icons/'+ hero +'.png');}
			
			if (hero == "npc_dota_hero_wisp") {mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).AddClass("Desaturate");}
			else {mapPlace.FindChildTraverse("HeroMapIcon"+order.toString()).RemoveClass("Desaturate");}
			order += 1;
		}
	}
}

(function () {
	//CustomNetTables.SubscribeNetTableListener("this_wave_table",UpdateTimer);
	CustomNetTables.SubscribeNetTableListener("hero_data",HeroDataTableFill);
	UpdatePickUI();
	UpdateTimer();
	HeroDataTableFill();
	//$('#PickUIBase').visible = false;
	//$('#ChatBox').FindChildTraverse("Chat").chatstyle = "hud";
	
	//$('#PickUIBase').visible = true;
	//$.Schedule(2,function() {
	//	$('#PickUIBase').visible = false;
	//});
	//$.Schedule(4,function() {
	//	$('#PickUIBase').visible = true;
	//});
	
	//$('#ChatBox').FindChildTraverse("Chat").enabled = true;
	//$('#DOTAChatDoesntWorkCorrectlySoNowIHaveToDoThisBox').FindChildTraverse("Chat").enabled = true;
	
	$('#PortraitBox').visible = false;
	$('#StatBox').visible = false;
	$('#SpellBox').visible = false;
	$('#PortraitLabel').visible = false;
	$('#WelcomeLabel').visible = false;
	
	$('#ChatField').SetFocus();
	
	MapIconUpdate(0);
})();