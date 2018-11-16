var radTeam = {};
var dirTeam = {};
var selectedPlayer = -1;
var heroData = {};
var shifter = 0;
var mapData = {};
var aspectData = {};
var isAutoOrPassive = {};
var randoCheck = false;

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
	
	for (i=1; i<=10; i++) {
		$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
	}
	
	var aspect1 = 0;
	var aspect2 = 0;
	var aspect3 = 0;
	var aspect4 = 0;
	var aspect5 = 0;
	var aspect6 = 0;
	var aspect7 = 0;
	var aspect1max = 0;
	var aspect2max = 0;
	var aspect3max = 0;
	var aspect4max = 0;
	var aspect5max = 0;
	var aspect6max = 0;
	var aspect7max = 0;
	var prepip = false;
	
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
		
		if (Players.GetTeam(pID) == 2) {
			if (hero == "npc_dota_hero_wisp")
			{
				prepip = true;
				if (icon == undefined || icon == "npc_dota_hero_random" || icon == "npc_dota_hero_random_combat" || icon == "npc_dota_hero_random_caster" || icon == "npc_dota_hero_random_support" || icon == "npc_dota_hero_random_rounded")
				{aspect1 = 0;
				aspect2 = 0;
				aspect3 = 0;
				aspect4 = 0;
				aspect5 = 0;
				aspect6 = 0;
				aspect7 = 0;}
				else {
					aspect1 = aspectData[icon].stattank;
					aspect2 = aspectData[icon].statcarry;
					aspect3 = aspectData[icon].statcaster;
					aspect4 = aspectData[icon].statstun;
					aspect5 = aspectData[icon].statbuff;
					aspect6 = aspectData[icon].statheal;
					aspect7 = aspectData[icon].statdisrupt;
				}
			}
			else {
				prepip = false;
				if (icon == undefined)
				{aspect1 = 0;
				aspect2 = 0;
				aspect3 = 0;
				aspect4 = 0;
				aspect5 = 0;
				aspect6 = 0;
				aspect7 = 0;}
				else {
					aspect1 = aspectData[hero].stattank;
					aspect2 = aspectData[hero].statcarry;
					aspect3 = aspectData[hero].statcaster;
					aspect4 = aspectData[hero].statstun;
					aspect5 = aspectData[hero].statbuff;
					aspect6 = aspectData[hero].statheal;
					aspect7 = aspectData[hero].statdisrupt;
				}
			}
			aspect1max += aspect1;
			aspect2max += aspect2;
			aspect3max += aspect3;
			aspect4max += aspect4;
			aspect5max += aspect5;
			aspect6max += aspect6;
			aspect7max += aspect7;
			
			if (1+aspect1max-aspect1 <= 10 && aspect1 > 0) {
				for (i = 1+aspect1max - aspect1; i <= Math.min(aspect1max,10); i++) {
					$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect2max-aspect2 <= 10 && aspect2 > 0) {
				for (i = 1+aspect2max - aspect2; i <= Math.min(aspect2max,10); i++) {
					$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect3max-aspect3 <= 10 && aspect3 > 0) {
				for (i = 1+aspect3max - aspect3; i <= Math.min(aspect3max,10); i++) {
					$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect4max-aspect4 <= 10 && aspect4 > 0) {
				for (i = 1+aspect4max - aspect4; i <= Math.min(aspect4max,10); i++) {
					$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect5max-aspect5 <= 10 && aspect5 > 0) {
				for (i = 1+aspect5max - aspect5; i <= Math.min(aspect5max,10); i++) {
					$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect6max-aspect6 <= 10 && aspect6 > 0) {
				for (i = 1+aspect6max - aspect6; i <= Math.min(aspect6max,10); i++) {
					$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect7max-aspect7 <= 10 && aspect7 > 0) {
				for (i = 1+aspect7max - aspect7; i <= Math.min(aspect7max,10); i++) {
					$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
		}
		order += 1;
	}
	order = 1;
	aspect1 = 0;
	aspect2 = 0;
	aspect3 = 0;
	aspect4 = 0;
	aspect5 = 0;
	aspect6 = 0;
	aspect7 = 0;
	aspect1max = 0;
	aspect2max = 0;
	aspect3max = 0;
	aspect4max = 0;
	aspect5max = 0;
	aspect6max = 0;
	aspect7max = 0;
	
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
		
		if (Players.GetTeam(pID) == 3) {
			if (hero == "npc_dota_hero_wisp")
			{
				prepip = true;
				if (icon == undefined || icon == "npc_dota_hero_random" || icon == "npc_dota_hero_random_combat" || icon == "npc_dota_hero_random_caster" || icon == "npc_dota_hero_random_support" || icon == "npc_dota_hero_random_rounded")
				{aspect1 = 0;
				aspect2 = 0;
				aspect3 = 0;
				aspect4 = 0;
				aspect5 = 0;
				aspect6 = 0;
				aspect7 = 0;}
				else {
					aspect1 = aspectData[icon].stattank;
					aspect2 = aspectData[icon].statcarry;
					aspect3 = aspectData[icon].statcaster;
					aspect4 = aspectData[icon].statstun;
					aspect5 = aspectData[icon].statbuff;
					aspect6 = aspectData[icon].statheal;
					aspect7 = aspectData[icon].statdisrupt;
				}
			}
			else {
				prepip = false;
				if (icon == undefined || icon == "npc_dota_hero_random" || icon == "npc_dota_hero_random_combat" || icon == "npc_dota_hero_random_caster" || icon == "npc_dota_hero_random_support" || icon == "npc_dota_hero_random_rounded")
				{aspect1 = 0;
				aspect2 = 0;
				aspect3 = 0;
				aspect4 = 0;
				aspect5 = 0;
				aspect6 = 0;
				aspect7 = 0;}
				else {
					aspect1 = aspectData[hero].stattank;
					aspect2 = aspectData[hero].statcarry;
					aspect3 = aspectData[hero].statcaster;
					aspect4 = aspectData[hero].statstun;
					aspect5 = aspectData[hero].statbuff;
					aspect6 = aspectData[hero].statheal;
					aspect7 = aspectData[hero].statdisrupt;
				}
			}
			aspect1max += aspect1;
			aspect2max += aspect2;
			aspect3max += aspect3;
			aspect4max += aspect4;
			aspect5max += aspect5;
			aspect6max += aspect6;
			aspect7max += aspect7;
			
			if (1+aspect1max-aspect1 <= 10 && aspect1 > 0) {
				for (i = 1+aspect1max - aspect1; i <= Math.min(aspect1max,10); i++) {
					$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect2max-aspect2 <= 10 && aspect2 > 0) {
				for (i = 1+aspect2max - aspect2; i <= Math.min(aspect2max,10); i++) {
					$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect3max-aspect3 <= 10 && aspect3 > 0) {
				for (i = 1+aspect3max - aspect3; i <= Math.min(aspect3max,10); i++) {
					$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect4max-aspect4 <= 10 && aspect4 > 0) {
				for (i = 1+aspect4max - aspect4; i <= Math.min(aspect4max,10); i++) {
					$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect5max-aspect5 <= 10 && aspect5 > 0) {
				for (i = 1+aspect5max - aspect5; i <= Math.min(aspect5max,10); i++) {
					$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect6max-aspect6 <= 10 && aspect6 > 0) {
				for (i = 1+aspect6max - aspect6; i <= Math.min(aspect6max,10); i++) {
					$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
			if (1+aspect7max-aspect7 <= 10 && aspect7 > 0) {
				for (i = 1+aspect7max - aspect7; i <= Math.min(aspect7max,10); i++) {
					$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
					if (prepip == true) {
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = false;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = false;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = false;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").style.borderColor = '#'+color;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#00000099';
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = true;
					}
					else {
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipGlow").visible = true;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipShadow").visible = true;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PipEdge").visible = true;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
						$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).FindChildTraverse("PrePip").visible = false;
					}
				}
			}
		}
		
		order += 1;
	}
	PickCheck();
	MapIconUpdate(0);
	if (randoCheck) {
		if (Players.GetPlayerSelectedHero(pID) != "npc_dota_hero_wisp") {
			$.Schedule(0.1,function() {
				HeroButtonPressed(Players.GetPlayerSelectedHero(pID));
			});
		}
		randoCheck = false;
	}
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
	&& Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()) != ""
	&& Math.floor(Game.GetDOTATime(false,true)) >= -10) {
		if ($("#PickUIBase").visible == true) GameUI.SetCameraTarget(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()));
		$("#PickUIBase").visible = false;
		$.Schedule(0.1,function() {GameUI.SetCameraTarget(-1);});
	} else {
		$("#PickUIBase").visible = true;
		GameUI.SetCameraTarget(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()));
		$.Schedule(0.1,function() {GameUI.SelectUnit(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()),false);});
		
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
	//if(event == "npc_dota_hero_meepo") {return 0;}
	
	//but first, this
	var table = {};
	table.hero = event;
	table.player = Game.GetLocalPlayerID();
	//$.Msg(table.player);
	GameEvents.SendCustomGameEventToServer("hero_button_pressed",table);
	$('#FinalPickLabel').text = ($.Localize("#DOTA_HeroSelector_SelectHero_Label")+" "+$.Localize("#"+event)).toUpperCase();
	$('#PortraitLabel').text = $.Localize("#"+event).toUpperCase();
	//$('#PortraitBox').style.backgroundImage = 'url("file://{images}/heroes/selection/'+ event +'.png")';
	
	for (i=1; i<=5; i++) {
		if(aspectData[event].stattank >= i) $('#MainTankBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainTankBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statcarry >= i) $('#MainCarryBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainCarryBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statcaster >= i) $('#MainCasterBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainCasterBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statstun >= i) $('#MainStunBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainStunBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statbuff >= i) $('#MainBuffBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainBuffBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statheal >= i) $('#MainHealBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainHealBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statdisrupt >= i) $('#MainDisruptBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainDisruptBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
	}
	
	if(event == "npc_dota_hero_random"
	|| event == "npc_dota_hero_random_combat"
	|| event == "npc_dota_hero_random_caster"
	|| event == "npc_dota_hero_random_support"
	|| event == "npc_dota_hero_random_rounded") {
		$('#PortraitBox').visible = false;
		$('#StatBox').visible = false;
		$('#SpellBox').visible = false;
		$('#PortraitLabel').visible = true;
		$('#PortraitLabel').text = $('#PortraitLabel').text.replace(" HERO","");
		$('#WelcomeBox').visible = false;
		$('#RandomBox').visible = true;
		$('#WelcomeLabel').visible = true;
		$('#PortraitBox').style.backgroundImage = 'url("file://{images}/heroes/selection/npc_dota_hero_wisp.png")';
		$('#DiceBox').RemoveClass("ShiftCombat");
		$('#DiceBox').RemoveClass("ShiftCaster");
		$('#DiceBox').RemoveClass("ShiftSupport");
		$('#DiceBox').RemoveClass("ShiftRounded");
		if (event == "npc_dota_hero_random_combat") $('#DiceBox').AddClass("ShiftCombat");
		if (event == "npc_dota_hero_random_caster") $('#DiceBox').AddClass("ShiftCaster");
		if (event == "npc_dota_hero_random_support") $('#DiceBox').AddClass("ShiftSupport");
		if (event == "npc_dota_hero_random_rounded") $('#DiceBox').AddClass("ShiftRounded");
		if (event == "npc_dota_hero_random") {
			$('#RewardLabelLeft').text = "50% more gold per wave";
			$('#RewardLabelRight').text = "Potion of Healing x2";
		}
		else {
			$('#RewardLabelLeft').text = "10% more gold per wave";
			$('#RewardLabelRight').text = "Potion of Healing";
		}
		return 0;
	}
	
	$('#PortraitBox').style.backgroundImage = 'url("file://{images}/heroes/selection/'+ event +'.png")';
	$('#PortraitBox').visible = true;
	$('#StatBox').visible = true;
	$('#SpellBox').visible = true;
	$('#PortraitLabel').visible = true;
	//$('#PortraitLabel').text = $.Localize("#"+event).toUpperCase();
	$('#WelcomeBox').visible = false;
	$('#RandomBox').visible = false;
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
			$('#AttLeftBox').FindChildTraverse("oops").SetImage("file://{images}/items/mithril_hammer.png");
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
			$('#HeroRngBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].atkrng+" ("+$.Localize("#DOTA_HeroSelectorCategory_AttackRange_Melee")+")";
		}
		else {
			if(event == "npc_dota_hero_drow_ranger") $('#HeroRngBox').FindChildTraverse("AttHeroSmallLabel").text = "250-"+heroData[event].atkrng;
			else $('#HeroRngBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].atkrng;
		}
	}
	
	//armor and speed
	$('#HeroArmBox').FindChildTraverse("AttHeroSmallLabel").text = heroData[event].armor - 2;
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
	if(isAutoOrPassive[slot1.abilityname].casttype == 1 && slot1.abilityname != "faenrae_champion_dark_hand_curse") {
		$('#SpellInfo1').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/passive_ability_border_png.vtex");
		$('#SpellInfo1').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot1.AddClass("FitToPassive");
		slot1.RemoveClass("FitToActive");
		slot1.RemoveClass("FitToAuto");
	}
	else if(isAutoOrPassive[slot1.abilityname].casttype == 2) {
		$('#SpellInfo1').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/autocastable_ability_border_png.vtex");
		$('#SpellInfo1').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot1.RemoveClass("FitToPassive");
		slot1.RemoveClass("FitToActive");
		slot1.AddClass("FitToAuto");
	}
	else {
		$('#SpellInfo1').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/active_ability_border_png.vtex");
		$('#SpellInfo1').FindChildTraverse("IWasTagged2").AddClass("FitToActiveOuter");
		slot1.RemoveClass("FitToPassive");
		slot1.AddClass("FitToActive");
		slot1.RemoveClass("FitToAuto");
	}
	
	slot2.abilityname = heroData[event].spell2;
	slot2.SetPanelEvent("onmouseover",function(){
		$.DispatchEvent("DOTAShowAbilityTooltip", slot2, heroData[event].spell2);
	});
	slot2.SetPanelEvent("onmouseout",function(){
		$.DispatchEvent("DOTAHideAbilityTooltip",slot2);
	});
	if(isAutoOrPassive[slot2.abilityname].casttype == 1) {
		$('#SpellInfo2').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/passive_ability_border_png.vtex");
		$('#SpellInfo2').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot2.AddClass("FitToPassive");
		slot2.RemoveClass("FitToActive");
		slot2.RemoveClass("FitToAuto");
	}
	else if(isAutoOrPassive[slot2.abilityname].casttype == 2) {
		$('#SpellInfo2').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/autocastable_ability_border_png.vtex");
		$('#SpellInfo2').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot2.RemoveClass("FitToPassive");
		slot2.RemoveClass("FitToActive");
		slot2.AddClass("FitToAuto");
	}
	else {
		$('#SpellInfo2').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/active_ability_border_png.vtex");
		$('#SpellInfo2').FindChildTraverse("IWasTagged2").AddClass("FitToActiveOuter");
		slot2.RemoveClass("FitToPassive");
		slot2.AddClass("FitToActive");
		slot2.RemoveClass("FitToAuto");
	}
	
	slot3.abilityname = heroData[event].spell3;
	slot3.SetPanelEvent("onmouseover",function(){
		$.DispatchEvent("DOTAShowAbilityTooltip", slot3, heroData[event].spell3);
	});
	slot3.SetPanelEvent("onmouseout",function(){
		$.DispatchEvent("DOTAHideAbilityTooltip",slot3);
	});
	if(isAutoOrPassive[slot3.abilityname].casttype == 1) {
		$('#SpellInfo3').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/passive_ability_border_png.vtex");
		$('#SpellInfo3').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot3.AddClass("FitToPassive");
		slot3.RemoveClass("FitToActive");
		slot3.RemoveClass("FitToAuto");
	}
	else if(isAutoOrPassive[slot3.abilityname].casttype == 2) {
		$('#SpellInfo3').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/autocastable_ability_border_png.vtex");
		$('#SpellInfo3').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot3.RemoveClass("FitToPassive");
		slot3.RemoveClass("FitToActive");
		slot3.AddClass("FitToAuto");
	}
	else {
		$('#SpellInfo3').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/active_ability_border_png.vtex");
		$('#SpellInfo3').FindChildTraverse("IWasTagged2").AddClass("FitToActiveOuter");
		slot3.RemoveClass("FitToPassive");
		slot3.AddClass("FitToActive");
		slot3.RemoveClass("FitToAuto");
	}
	
	slot4.abilityname = heroData[event].spell4;
	slot4.SetPanelEvent("onmouseover",function(){
		$.DispatchEvent("DOTAShowAbilityTooltip", slot4, heroData[event].spell4);
	});
	slot4.SetPanelEvent("onmouseout",function(){
		$.DispatchEvent("DOTAHideAbilityTooltip",slot4);
	});
	if(isAutoOrPassive[slot4.abilityname].casttype == 1) {
		$('#SpellInfo4').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/passive_ability_border_png.vtex");
		$('#SpellInfo4').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot4.AddClass("FitToPassive");
		slot4.RemoveClass("FitToActive");
		slot4.RemoveClass("FitToAuto");
	}
	else if(isAutoOrPassive[slot4.abilityname].casttype == 2) {
		$('#SpellInfo4').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/autocastable_ability_border_png.vtex");
		$('#SpellInfo4').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot4.RemoveClass("FitToPassive");
		slot4.RemoveClass("FitToActive");
		slot4.AddClass("FitToAuto");
	}
	else {
		$('#SpellInfo4').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/active_ability_border_png.vtex");
		$('#SpellInfo4').FindChildTraverse("IWasTagged2").AddClass("FitToActiveOuter");
		slot4.RemoveClass("FitToPassive");
		slot4.AddClass("FitToActive");
		slot4.RemoveClass("FitToAuto");
	}
	
	slot5.abilityname = heroData[event].spell5;
	slot5.SetPanelEvent("onmouseover",function(){
		$.DispatchEvent("DOTAShowAbilityTooltip", slot5, heroData[event].spell5);
	});
	slot5.SetPanelEvent("onmouseout",function(){
		$.DispatchEvent("DOTAHideAbilityTooltip",slot5);
	});
	if(isAutoOrPassive[slot5.abilityname].casttype == 1) {
		$('#SpellInfo5').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/passive_ability_border_png.vtex");
		$('#SpellInfo5').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot5.AddClass("FitToPassive");
		slot5.RemoveClass("FitToActive");
		slot5.RemoveClass("FitToAuto");
	}
	else if(isAutoOrPassive[slot5.abilityname].casttype == 2) {
		$('#SpellInfo5').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/autocastable_ability_border_png.vtex");
		$('#SpellInfo5').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
		slot5.RemoveClass("FitToPassive");
		slot5.RemoveClass("FitToActive");
		slot5.AddClass("FitToAuto");
	}
	else {
		$('#SpellInfo5').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/active_ability_border_png.vtex");
		$('#SpellInfo5').FindChildTraverse("IWasTagged2").AddClass("FitToActiveOuter");
		slot5.RemoveClass("FitToPassive");
		slot5.AddClass("FitToActive");
		slot5.RemoveClass("FitToAuto");
	}
	
	if (heroData[event].spell6 == "" || heroData[event].spell6 == "ahlen_cataclysmic_strike_proxy"
	|| heroData[event].spell6 == "enfos_attribute_bonus"
	|| heroData[event].spell6 == "generic_hidden") {
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
		if(isAutoOrPassive[slot6.abilityname].casttype == 1) {
			$('#SpellInfo6').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/passive_ability_border_png.vtex");
			$('#SpellInfo6').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
			slot6.AddClass("FitToPassive");
			slot6.RemoveClass("FitToActive");
			slot6.RemoveClass("FitToAuto");
		}
		else if(isAutoOrPassive[slot6.abilityname].casttype == 2) {
			$('#SpellInfo6').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/autocastable_ability_border_png.vtex");
			$('#SpellInfo6').FindChildTraverse("IWasTagged2").RemoveClass("FitToActiveOuter");
			slot6.RemoveClass("FitToPassive");
			slot6.RemoveClass("FitToActive");
			slot6.AddClass("FitToAuto");
		}
		else {
			$('#SpellInfo6').FindChildTraverse("IWasTagged2").SetImage("s2r://panorama/images/hud/active_ability_border_png.vtex");
			$('#SpellInfo6').FindChildTraverse("IWasTagged2").AddClass("FitToActiveOuter");
			slot6.RemoveClass("FitToPassive");
			slot6.AddClass("FitToActive");
			slot6.RemoveClass("FitToAuto");
		}
	}
	
	/*for (i=1; i<=5; i++) {
		if(aspectData[event].stattank >= i) $('#MainTankBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainTankBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statcarry >= i) $('#MainCarryBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainCarryBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statcaster >= i) $('#MainCasterBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainCasterBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statstun >= i) $('#MainStunBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainStunBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statbuff >= i) $('#MainBuffBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainBuffBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statheal >= i) $('#MainHealBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainHealBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		if(aspectData[event].statdisrupt >= i) $('#MainDisruptBox').FindChildTraverse("AspectPip"+i.toString()).visible = true;
		else $('#MainDisruptBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
	}*/
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
	if (data.hero == "npc_dota_hero_random"
	|| data.hero == "npc_dota_hero_random_combat"
	|| data.hero == "npc_dota_hero_random_caster"
	|| data.hero == "npc_dota_hero_random_support"
	|| data.hero == "npc_dota_hero_random_rounded") randoCheck = true;
	if (data.hero != undefined) GameEvents.SendCustomGameEventToServer("player_repick",data);
	PickCheck();
}

function HeroDataTableFill() {
	heroData = CustomNetTables.GetTableValue("hero_data","stats");
	aspectData = CustomNetTables.GetTableValue("hero_data","aspect");
	isAutoOrPassive = CustomNetTables.GetTableValue("hero_data","cast");
	if (aspectData["npc_dota_hero_random"] == undefined) {
		aspectData["npc_dota_hero_random"] = {}; aspectData["npc_dota_hero_random"].stattank = 0; aspectData["npc_dota_hero_random"].statcarry = 0; aspectData["npc_dota_hero_random"].statcaster = 0; aspectData["npc_dota_hero_random"].statstun = 0; aspectData["npc_dota_hero_random"].statbuff = 0; aspectData["npc_dota_hero_random"].statheal = 0; aspectData["npc_dota_hero_random"].statdisrupt = 0;
		aspectData["npc_dota_hero_random_combat"] = {}; aspectData["npc_dota_hero_random_combat"].stattank = 0; aspectData["npc_dota_hero_random_combat"].statcarry = 0; aspectData["npc_dota_hero_random_combat"].statcaster = 0; aspectData["npc_dota_hero_random_combat"].statstun = 0; aspectData["npc_dota_hero_random_combat"].statbuff = 0; aspectData["npc_dota_hero_random_combat"].statheal = 0; aspectData["npc_dota_hero_random_combat"].statdisrupt = 0;
		aspectData["npc_dota_hero_random_caster"] = {}; aspectData["npc_dota_hero_random_caster"].stattank = 0; aspectData["npc_dota_hero_random_caster"].statcarry = 0; aspectData["npc_dota_hero_random_caster"].statcaster = 0; aspectData["npc_dota_hero_random_caster"].statstun = 0; aspectData["npc_dota_hero_random_caster"].statbuff = 0; aspectData["npc_dota_hero_random_caster"].statheal = 0; aspectData["npc_dota_hero_random_caster"].statdisrupt = 0;
		aspectData["npc_dota_hero_random_support"] = {}; aspectData["npc_dota_hero_random_support"].stattank = 0; aspectData["npc_dota_hero_random_support"].statcarry = 0; aspectData["npc_dota_hero_random_support"].statcaster = 0; aspectData["npc_dota_hero_random_support"].statstun = 0; aspectData["npc_dota_hero_random_support"].statbuff = 0; aspectData["npc_dota_hero_random_support"].statheal = 0; aspectData["npc_dota_hero_random_support"].statdisrupt = 0;
		aspectData["npc_dota_hero_random_rounded"] = {}; aspectData["npc_dota_hero_random_rounded"].stattank = 0; aspectData["npc_dota_hero_random_rounded"].statcarry = 0; aspectData["npc_dota_hero_random_rounded"].statcaster = 0; aspectData["npc_dota_hero_random_rounded"].statstun = 0; aspectData["npc_dota_hero_random_rounded"].statbuff = 0; aspectData["npc_dota_hero_random_rounded"].statheal = 0; aspectData["npc_dota_hero_random_rounded"].statdisrupt = 0;
	}
	//$.Msg(heroData.npc_dota_hero_bounty_hunter.str);
}

function UpdateTimer() {
	//if (CustomNetTables.GetTableValue("this_wave_table","round").value >= 4
	//&& $('#PickUIBase').visible == true){
		//$('#PickUIBase').visible = false;
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
	$('#DiceBox').RemoveClass("OhGodNoItsTerrible"+((shifter%5)*24));
	shifter += 1;
	if(shifter == 120) shifter = 0;
	$('#PickRandomVideo').AddClass("OhGodNoItsTerrible"+shifter);
	if (heroData[Game.GetLocalPlayerID()] == "npc_dota_hero_random") $('#DiceBox').AddClass("OhGodNoItsTerrible"+((shifter%5)*24));
	$.Schedule(0.1,function() {UpdateTimer();});
}

function ChatBoxCheck() {
	//$('#ChatBox').DOTAChatCancelMessageMode();
	//$('#DOTAChatDoesntWorkCorrectlySoNowIHaveToDoThisBox').DOTAChatCancelMessageMode();
	//$.Msg($("#PickUIBase").visible);
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
		if(event.team) newLine.text = "||||||||||||. (Allies) <font color='#"+color+"'>"+name+":</font> "+newLine.text;
		else newLine.text = "||||||||||||. <font color='#"+color+"'>"+name+"</font>: "+newLine.text;
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
	if (Players.IsSpectator(Game.GetLocalPlayerID())) {
		$('#PickUIBase').visible = false;
		return;
	}
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
	//$('#ChatBox').FindChildTraverse("Chat").FindChildTraverse("ChatCorePanel").FindChildTraverse("ChatMainPanel").FindChildTraverse("ChatControls").FindChildTraverse("ChatInput").visible = false;
	
	//SetInputFocus('PickUIBase')
	
	$('#PortraitBox').visible = false;
	$('#StatBox').visible = false;
	$('#SpellBox').visible = false;
	$('#PortraitLabel').visible = false;
	$('#RandomBox').visible = false;
	$('#SteamBox1').FindChildTraverse("DUN").GetChild(0).AddClass("Dunn");
	$('#SteamBox2').FindChildTraverse("DUN").GetChild(0).AddClass("Dunn");
	$('#SteamBox3').FindChildTraverse("DUN").GetChild(0).AddClass("Dunn");
	
	$('#ChatField').SetFocus();
	
	var color = Players.GetPlayerColor(Game.GetLocalPlayerID());
	color = color.toString(16);
	color = color.match(/[a-fA-F0-9]{2}/g).reverse().join('');
	
	for (i=1; i<=10; i++) {
		if (i <= 5) {
			$('#MainTankBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
			$('#MainTankBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
			$('#MainCarryBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
			$('#MainCarryBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
			$('#MainCasterBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
			$('#MainCasterBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
			$('#MainStunBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
			$('#MainStunBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
			$('#MainBuffBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
			$('#MainBuffBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
			$('#MainHealBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
			$('#MainHealBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
			$('#MainDisruptBox').FindChildTraverse("AspectPip"+i.toString()).style.backgroundColor = '#'+color;
			$('#MainDisruptBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		}
		$('#TeamTankBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamCarryBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamCasterBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamStunBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamBuffBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamHealBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
		$('#TeamDisruptBox').FindChildTraverse("AspectPip"+i.toString()).visible = false;
	}
	MapIconUpdate(0);
})();