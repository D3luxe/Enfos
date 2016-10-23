var radTeam = {};
var dirTeam = {};
var selectedPlayer = -1;

GameEvents.Subscribe("hero_change",UpdateTradeUI);

function TransferSelect(event){
	var data = {};
	//0-4 - Select player to trade with
	//5-8 - Send gold
	//9-12 - Send lumber
	if (Players.GetTeam(Game.GetLocalPlayerID()) == DOTATeam_t.DOTA_TEAM_GOODGUYS) {data.target = radTeam[selectedPlayer]};
	if (Players.GetTeam(Game.GetLocalPlayerID()) == DOTATeam_t.DOTA_TEAM_BADGUYS) {data.target = dirTeam[selectedPlayer]};
	//$.Msg(radTeam[selectedPlayer])
	//$.Msg(selectedPlayer)
	if(event <= 4){
		selectedPlayer = event;
		//$("#GoldButton1").RemoveClass("selected");
		$('#ButtonGlow1').visible = false;
		$('#ButtonArrow1').visible = false;
		$('#ButtonGlow2').visible = false;
		$('#ButtonArrow2').visible = false;
		$('#ButtonGlow3').visible = false;
		$('#ButtonArrow3').visible = false;
		$('#ButtonGlow4').visible = false;
		$('#ButtonArrow4').visible = false;
		$('#ButtonGlow5').visible = false;
		$('#ButtonArrow5').visible = false;
		if (event == 0){
			//$("#GoldButton1").AddClass("selected");
			$('#ButtonGlow1').visible = true;
			$('#ButtonArrow1').visible = true;
		}
		if (event == 1){
			//$("#GoldButton2").AddClass("selected");
			$('#ButtonGlow2').visible = true;
			$('#ButtonArrow2').visible = true;
		}
		if (event == 2){
			//$("#GoldButton3").AddClass("selected");
			$('#ButtonGlow3').visible = true;
			$('#ButtonArrow3').visible = true;
		}
		if (event == 3){
			//$("#GoldButton4").AddClass("selected");
			$('#ButtonGlow4').visible = true;
			$('#ButtonArrow4').visible = true;
		}
		if (event == 4){
			//$("#GoldButton5").AddClass("selected");
			$('#ButtonGlow5').visible = true;
			$('#ButtonArrow5').visible = true;
		}
	}
	else if(event >= 5 && selectedPlayer > -1){
		data.player = Game.GetLocalPlayerID();
		if(event == 5 || event == 9){data.amount = 10;}
		if(event == 6 || event == 10){data.amount = 100;}
		if(event == 7 || event == 11){data.amount = 1000;}
		if(event == 8 || event == 12){data.amount = 0;}
		if(event >= 9 && event <= 11){data.amount = data.amount/10;}
		if(event >= 5 && event <= 8){data.resource = "gold"}
		if(event >= 9 && event <= 12){data.resource = "lumber"}
		GameEvents.SendCustomGameEventToServer("trade_ui_event",data);
	}
}

function UpdateTradeUI() {
	var pID = Game.GetLocalPlayerID();
	var team = Players.GetTeam(pID);
	//PlayerPicked( data.PlayerID, data.HeroName );
	//SetHero(team);
	var teamList = Game.GetPlayerIDsOnTeam(team);
	if (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) {radTeam = teamList;}
	if (team == DOTATeam_t.DOTA_TEAM_BADGUYS) {dirTeam = teamList;}
	$('#GoldButton5').visible = false;
	$('#ButtonGlow5').visible = false;
	$('#ButtonArrow5').visible = false;
	$('#ButtonColor5').visible = false;
	$('#GoldButton4').visible = false;
	$('#ButtonGlow4').visible = false;
	$('#ButtonArrow4').visible = false;
	$('#ButtonColor4').visible = false;
	$('#GoldButton3').visible = false;
	$('#ButtonGlow3').visible = false;
	$('#ButtonArrow3').visible = false;
	$('#ButtonColor3').visible = false;
	$('#GoldButton2').visible = false;
	$('#ButtonGlow2').visible = false;
	$('#ButtonArrow2').visible = false;
	$('#ButtonColor2').visible = false;
	$('#GoldButton1').visible = false;
	$('#ButtonGlow1').visible = false;
	$('#ButtonArrow1').visible = false;
	$('#ButtonColor1').visible = false;
	var order = 0;
	for (var playerID in teamList) {
		//var pData = Game.GetPlayerInfo(parseInt(playerID));
		var name = Players.GetPlayerSelectedHero(parseInt(teamList[playerID]));
		var color = Players.GetPlayerColor(parseInt(teamList[playerID]));
		color = color.toString(16);
		color = color.match(/[a-fA-F0-9]{2}/g).reverse().join('');
		$.Msg(color);
		if (order == 4) {
			$('#GoldButton5').style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ name +'_png.vtex")';
			$('#GoldButton5').visible = true;
			$('#ButtonColor5').style.backgroundColor = '#'+color;
			$('#ButtonColor5').visible = true;
			if (teamList[playerID] == selectedPlayer) {
				$('#ButtonGlow5').visible = true;
				$('#ButtonArrow5').visible = true;
			}
			order += 1;
		}
		if (order == 3) {
			$('#GoldButton4').style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ name +'_png.vtex")';
			$('#GoldButton4').visible = true;
			$('#ButtonColor4').style.backgroundColor = '#'+color;
			$('#ButtonColor4').visible = true;
			if (teamList[playerID] == selectedPlayer) {
				$('#ButtonGlow4').visible = true;
				$('#ButtonArrow4').visible = true;
			}
			order += 1;
		}
		if (order == 2) {
			$('#GoldButton3').style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ name +'_png.vtex")';
			$('#GoldButton3').visible = true;
			$('#ButtonColor3').style.backgroundColor = '#'+color;
			$('#ButtonColor3').visible = true;
			if (teamList[playerID] == selectedPlayer) {
				$('#ButtonGlow3').visible = true;
				$('#ButtonArrow3').visible = true;
			}
			order += 1;
		}
		if (order == 1) {
			$('#GoldButton2').style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ name +'_png.vtex")';
			$('#GoldButton2').visible = true;
			$('#ButtonColor2').style.backgroundColor = '#'+color;
			$('#ButtonColor2').visible = true;
			if (teamList[playerID] == selectedPlayer) {
				$('#ButtonGlow2').visible = true;
				$('#ButtonArrow2').visible = true;
			}
			order += 1;
		}
		if (order == 0) {
			$('#GoldButton1').style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ name +'_png.vtex")';
			$('#GoldButton1').visible = true;
			$('#ButtonColor1').style.backgroundColor = '#'+color;
			$('#ButtonColor1').visible = true;
			if (teamList[playerID] == selectedPlayer) {
				$('#ButtonGlow1').visible = true;
				$('#ButtonArrow1').visible = true;
			}
			order += 1;
		}
	}
}

function FlipTradeUI() {
	if($('#goldMenu').visible != true){
		$('#goldMenu').visible = true;
		UpdateTradeUI();
	}
	else{$('#goldMenu').visible = false;}
}

(function () {
	FlipTradeUI();
})();