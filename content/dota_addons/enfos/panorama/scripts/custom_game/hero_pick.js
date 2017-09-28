var radTeam = {};
var dirTeam = {};
var selectedPlayer = -1;
var heroData = {};
var shifter = 0;

GameEvents.Subscribe("hero_change",UpdatePickUI);
GameEvents.Subscribe("hero_hover",UpdatePrePickIcon);

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
		color = color.toString(16);
		color = color.match(/[a-fA-F0-9]{2}/g).reverse().join('');
		
		//$.Msg('#DirePlayerBox'+order.toString());
		$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerIcon").style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ hero +'_png.vtex")';
		$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerColor").style.backgroundColor = '#'+color;
		$('#DirePlayerBox'+order.toString()).FindChildTraverse("PlayerLabel").text = name;
		$('#DirePlayerBox'+order.toString()).visible = true;
		//if (radTeam[playerID] == selectedPlayer) {
			//$('#ButtonGlow'+toString(order)).visible = true;
			//$('#ButtonArrow'+toString(order)).visible = true;
		//}
		order += 1;
	}
	PickCheck();
}

function UpdatePrePickIcon(event) {
	heroData[event.pid] = event.hero;
	UpdatePickUI();
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
	};
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
			PickCheck();
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
})();