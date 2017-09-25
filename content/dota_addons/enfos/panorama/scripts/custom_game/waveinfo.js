var curWavStats = {};
var curWav2Stats = {};
var nexWavStats = {};
var nexWav2Stats = {};

function AbilityShowTooltip(event)
{
	if (event == 0){$.DispatchEvent( "DOTAShowTitleTextTooltip",$("#CurrentWaveIcon"),	"#"+curWavStats.name,
	"<b>HP:</b> "+curWavStats.hp.toString()+" (+"+curWavStats.hpRegen.toString()+"/s)<br/> <b>MP:</b> "
	+curWavStats.mp.toString()+" (+"+curWavStats.mpRegen.toString()+"/s)<br/> <b>Attack:</b> "
	+curWavStats.atkMin.toString()+"-"+curWavStats.atkMax.toString()+" ("+curWavStats.atkType+")<br/>"
	+curWavStats.atkRate.toString()+"/s - "+curWavStats.atkRange.toString()+" Range ("+curWavStats.atkMelee+")<br/> <b>Defense:</b> "
	+curWavStats.armor.toString()+" Armor ("+curWavStats.armorType+") / "+curWavStats.armorMagic.toString()+"% Spell Resistance<br/> <b>Speed:</b> "
	+curWavStats.speed.toString());}
	if (event == 1){$.DispatchEvent( "DOTAShowTitleTextTooltip",$("#CurrentWaveIcon2"),	"#"+curWav2Stats.name,
	"<b>HP:</b> "+curWav2Stats.hp.toString()+" (+"+curWav2Stats.hpRegen.toString()+"/s)<br/> <b>MP:</b> "
	+curWav2Stats.mp.toString()+" (+"+curWav2Stats.mpRegen.toString()+"/s)<br/> <b>Attack:</b> "
	+curWav2Stats.atkMin.toString()+"-"+curWav2Stats.atkMax.toString()+" ("+curWav2Stats.atkType+")<br/>"
	+curWav2Stats.atkRate.toString()+"/s - "+curWav2Stats.atkRange.toString()+" Range ("+curWav2Stats.atkMelee+")<br/> <b>Defense:</b> "
	+curWav2Stats.armor.toString()+" Armor ("+curWav2Stats.armorType+") / "+curWav2Stats.armorMagic.toString()+"% Spell Resistance<br/> <b>Speed:</b> "
	+curWav2Stats.speed.toString());}
	if (event == 2){$.DispatchEvent( "DOTAShowTitleTextTooltip",$("#NextWaveIcon"),		"#"+nexWavStats.name,
	"<b>HP:</b> "+nexWavStats.hp.toString()+" (+"+nexWavStats.hpRegen.toString()+"/s)<br/> <b>MP:</b> "
	+nexWavStats.mp.toString()+" (+"+nexWavStats.mpRegen.toString()+"/s)<br/> <b>Attack:</b> "
	+nexWavStats.atkMin.toString()+"-"+nexWavStats.atkMax.toString()+" ("+nexWavStats.atkType+")<br/>"
	+nexWavStats.atkRate.toString()+"/s - "+nexWavStats.atkRange.toString()+" Range ("+nexWavStats.atkMelee+")<br/> <b>Defense:</b> "
	+nexWavStats.armor.toString()+" Armor ("+nexWavStats.armorType+") / "+nexWavStats.armorMagic.toString()+"% Spell Resistance<br/> <b>Speed:</b> "
	+nexWavStats.speed.toString());}
	if (event == 3){$.DispatchEvent( "DOTAShowTitleTextTooltip",$("#NextWaveIcon2"),	"#"+nexWav2Stats.name,
	"<b>HP:</b> "+nexWav2Stats.hp.toString()+" (+"+nexWav2Stats.hpRegen.toString()+"/s)<br/> <b>MP:</b> "
	+nexWav2Stats.mp.toString()+" (+"+nexWav2Stats.mpRegen.toString()+"/s)<br/> <b>Attack:</b> "
	+nexWav2Stats.atkMin.toString()+"-"+nexWav2Stats.atkMax.toString()+" ("+nexWav2Stats.atkType+")<br/>"
	+nexWav2Stats.atkRate.toString()+"/s - "+nexWav2Stats.atkRange.toString()+" Range ("+nexWav2Stats.atkMelee+")<br/> <b>Defense:</b> "
	+nexWav2Stats.armor.toString()+" Armor ("+nexWav2Stats.armorType+") / "+nexWav2Stats.armorMagic.toString()+"% Spell Resistance<br/> <b>Speed:</b> "
	+nexWav2Stats.speed.toString());}
}

function AbilityHideTooltip()
{
	$.DispatchEvent( "DOTAHideTitleTextTooltip");
}

function InitWave() {
	$('#LabelBox').visible = false;
	$('#InfoBox').visible = false;
	$('#SplitBox2').visible = false;
	$('#SplitBox4').visible = false;
	
	$('#CurrentWaveAbil1').visible = false;
	$('#CurrentWaveAbil2').visible = false;
	$('#CurrentWaveAbil3').visible = false;
	$('#CurrentWaveAbil4').visible = false;
	$('#CurrentWaveAbil5').visible = false;
	$('#CurrentWave2Abil1').visible = false;
	$('#CurrentWave2Abil2').visible = false;
	$('#CurrentWave2Abil3').visible = false;
	$('#CurrentWave2Abil4').visible = false;
	$('#CurrentWave2Abil5').visible = false;
	
	$('#NextWaveAbil1').visible = false;
	$('#NextWaveAbil2').visible = false;
	$('#NextWaveAbil3').visible = false;
	$('#NextWaveAbil4').visible = false;
	$('#NextWaveAbil5').visible = false;
	$('#NextWave2Abil1').visible = false;
	$('#NextWave2Abil2').visible = false;
	$('#NextWave2Abil3').visible = false;
	$('#NextWave2Abil4').visible = false;
	$('#NextWave2Abil5').visible = false;
}

function UpdateThisWave() {
	curWavStats.wave = CustomNetTables.GetTableValue("this_wave_table","round").value;
	curWavStats.name = CustomNetTables.GetTableValue("this_wave_table","name").value;
	curWavStats.hp = CustomNetTables.GetTableValue("this_wave_table","hp").value;
	curWavStats.hpRegen = CustomNetTables.GetTableValue("this_wave_table","hpRegen").value;
	curWavStats.mp = CustomNetTables.GetTableValue("this_wave_table","mp").value;
	curWavStats.mpRegen = CustomNetTables.GetTableValue("this_wave_table","mpRegen").value;
	curWavStats.atkMin = CustomNetTables.GetTableValue("this_wave_table","atkMin").value;
	curWavStats.atkMax = CustomNetTables.GetTableValue("this_wave_table","atkMax").value;
	curWavStats.atkType = CustomNetTables.GetTableValue("this_wave_table","atkType").value;
	curWavStats.atkRate = Math.round(CustomNetTables.GetTableValue("this_wave_table","atkRate").value * 100) / 100;
	curWavStats.atkRange = CustomNetTables.GetTableValue("this_wave_table","atkRange").value;
	curWavStats.atkMelee = CustomNetTables.GetTableValue("this_wave_table","atkMelee").value;
	curWavStats.armor = CustomNetTables.GetTableValue("this_wave_table","armor").value;
	curWavStats.armorType = CustomNetTables.GetTableValue("this_wave_table","armorType").value;
	curWavStats.armorMagic = CustomNetTables.GetTableValue("this_wave_table","armorMagic").value;
	curWavStats.speed = CustomNetTables.GetTableValue("this_wave_table","speed").value;
	curWavStats.abil1 = CustomNetTables.GetTableValue("this_wave_table","abil1").value;
	curWavStats.abil2 = CustomNetTables.GetTableValue("this_wave_table","abil2").value;
	curWavStats.abil3 = CustomNetTables.GetTableValue("this_wave_table","abil3").value;
	curWavStats.abil4 = CustomNetTables.GetTableValue("this_wave_table","abil4").value;
	curWavStats.abil5 = CustomNetTables.GetTableValue("this_wave_table","abil5").value;
	
	curWav2Stats.name = CustomNetTables.GetTableValue("this_wave_table","name2").value;
	curWav2Stats.hp = CustomNetTables.GetTableValue("this_wave_table","hp2").value;
	curWav2Stats.hpRegen = CustomNetTables.GetTableValue("this_wave_table","hpRegen2").value;
	curWav2Stats.mp = CustomNetTables.GetTableValue("this_wave_table","mp2").value;
	curWav2Stats.mpRegen = CustomNetTables.GetTableValue("this_wave_table","mpRegen2").value;
	curWav2Stats.atkMin = CustomNetTables.GetTableValue("this_wave_table","atkMin2").value;
	curWav2Stats.atkMax = CustomNetTables.GetTableValue("this_wave_table","atkMax2").value;
	curWav2Stats.atkType = CustomNetTables.GetTableValue("this_wave_table","atkType2").value;
	curWav2Stats.atkRate = Math.round(CustomNetTables.GetTableValue("this_wave_table","atkRate2").value * 100) / 100;
	curWav2Stats.atkRange = CustomNetTables.GetTableValue("this_wave_table","atkRange2").value;
	curWav2Stats.atkMelee = CustomNetTables.GetTableValue("this_wave_table","atkMelee2").value;
	curWav2Stats.armor = CustomNetTables.GetTableValue("this_wave_table","armor2").value;
	curWav2Stats.armorType = CustomNetTables.GetTableValue("this_wave_table","armorType2").value;
	curWav2Stats.armorMagic = CustomNetTables.GetTableValue("this_wave_table","armorMagic2").value;
	curWav2Stats.speed = CustomNetTables.GetTableValue("this_wave_table","speed2").value;
	curWav2Stats.abil1 = CustomNetTables.GetTableValue("this_wave_table","abil12").value;
	curWav2Stats.abil2 = CustomNetTables.GetTableValue("this_wave_table","abil22").value;
	curWav2Stats.abil3 = CustomNetTables.GetTableValue("this_wave_table","abil32").value;
	curWav2Stats.abil4 = CustomNetTables.GetTableValue("this_wave_table","abil42").value;
	curWav2Stats.abil5 = CustomNetTables.GetTableValue("this_wave_table","abil52").value;
	
	$('#CurrentWaveIcon').style.backgroundImage = 'url("s2r://panorama/images/custom_game/'+curWavStats.name+'_png.vtex")';
	$('#CurrentWaveIcon2').style.backgroundImage = 'url("s2r://panorama/images/custom_game/'+curWav2Stats.name+'_png.vtex")';
	
	if (CustomNetTables.GetTableValue("this_wave_table","hide").value == true) {
		$('#LabelBox').visible = false;
		$('#InfoBox').visible = false;
	}
	if (CustomNetTables.GetTableValue("this_wave_table","hide").value == false) {
		$('#LabelBox').visible = true;
		$('#InfoBox').visible = true;
		$('#WaveLabel').text = "WAVE "+curWavStats.wave.toString()+":";
	}
	if (CustomNetTables.GetTableValue("this_wave_table","hideSecond").value == true) {
		$('#SplitBox2').visible = false;
	}
	if (CustomNetTables.GetTableValue("this_wave_table","hideSecond").value == false) {
		$('#SplitBox2').visible = true;
	}
	
	if (curWavStats.abil1 == "") {
		$('#CurrentWaveAbil1').visible = false;
	} else {
		$('#CurrentWaveAbil1').visible = true;
		$('#CurrentWaveAbil1').abilityname = curWavStats.abil1;
		$('#CurrentWaveAbil1').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWaveAbil1'), curWavStats.abil1);
		});
		$('#CurrentWaveAbil1').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWaveAbil1'));
		});
	}
	if (curWavStats.abil2 == "" || curWavStats.abil2 == "mob_ensnare_checker") {
		$('#CurrentWaveAbil2').visible = false;
	} else {
		$('#CurrentWaveAbil2').visible = true;
		$('#CurrentWaveAbil2').abilityname = curWavStats.abil2;
		$('#CurrentWaveAbil2').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWaveAbil2'), curWavStats.abil2);
		});
		$('#CurrentWaveAbil2').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWaveAbil2'));
		});
	}
	if (curWavStats.abil3 == "") {
		$('#CurrentWaveAbil3').visible = false;
	} else {
		$('#CurrentWaveAbil3').visible = true;
		$('#CurrentWaveAbil3').abilityname = curWavStats.abil3;
		$('#CurrentWaveAbil3').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWaveAbil3'), curWavStats.abil3);
		});
		$('#CurrentWaveAbil3').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWaveAbil3'));
		});
	}
	if (curWavStats.abil4 == "") {
		$('#CurrentWaveAbil4').visible = false;
	} else {
		$('#CurrentWaveAbil4').visible = true;
		$('#CurrentWaveAbil4').abilityname = curWavStats.abil4;
		$('#CurrentWaveAbil4').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWaveAbil4'), curWavStats.abil4);
		});
		$('#CurrentWaveAbil4').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWaveAbil4'));
		});
	}
	if (curWavStats.abil5 == "") {
		$('#CurrentWaveAbil5').visible = false;
	} else {
		$('#CurrentWaveAbil5').visible = true;
		$('#CurrentWaveAbil5').abilityname = curWavStats.abil5;
		$('#CurrentWaveAbil5').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWaveAbil5'), curWavStats.abil5);
		});
		$('#CurrentWaveAbil5').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWaveAbil5'));
		});
	}
	
	if (curWav2Stats.abil1 == "") {
		$('#CurrentWave2Abil1').visible = false;
	} else {
		$('#CurrentWave2Abil1').visible = true;
		$('#CurrentWave2Abil1').abilityname = curWav2Stats.abil1;
		$('#CurrentWave2Abil1').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWave2Abil1'), curWav2Stats.abil1);
		});
		$('#CurrentWave2Abil1').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWave2Abil1'));
		});
	}
	if (curWav2Stats.abil2 == "" || curWav2Stats.abil2 == "mob_ensnare_checker") {
		$('#CurrentWave2Abil2').visible = false;
	} else {
		$('#CurrentWave2Abil2').visible = true;
		$('#CurrentWave2Abil2').abilityname = curWav2Stats.abil2;
		$('#CurrentWave2Abil2').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWave2Abil2'), curWav2Stats.abil2);
		});
		$('#CurrentWave2Abil2').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWave2Abil2'));
		});
	}
	if (curWav2Stats.abil3 == "") {
		$('#CurrentWave2Abil3').visible = false;
	} else {
		$('#CurrentWave2Abil3').visible = true;
		$('#CurrentWave2Abil3').abilityname = curWav2Stats.abil3;
		$('#CurrentWave2Abil3').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWave2Abil3'), curWav2Stats.abil3);
		});
		$('#CurrentWave2Abil3').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWave2Abil3'));
		});
	}
	if (curWav2Stats.abil4 == "") {
		$('#CurrentWave2Abil4').visible = false;
	} else {
		$('#CurrentWave2Abil4').visible = true;
		$('#CurrentWave2Abil4').abilityname = curWav2Stats.abil4;
		$('#CurrentWave2Abil4').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWave2Abil4'), curWav2Stats.abil4);
		});
		$('#CurrentWave2Abil4').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWave2Abil4'));
		});
	}
	if (curWav2Stats.abil5 == "") {
		$('#CurrentWave2Abil5').visible = false;
	} else {
		$('#CurrentWave2Abil5').visible = true;
		$('#CurrentWave2Abil5').abilityname = curWav2Stats.abil5;
		$('#CurrentWave2Abil5').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#CurrentWave2Abil5'), curWav2Stats.abil5);
		});
		$('#CurrentWave2Abil5').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#CurrentWave2Abil5'));
		});
	}
}
function UpdateNextWave() {
	nexWavStats.gold = CustomNetTables.GetTableValue("next_wave_table","gold").value;
	nexWavStats.name = CustomNetTables.GetTableValue("next_wave_table","name").value;
	nexWavStats.hp = CustomNetTables.GetTableValue("next_wave_table","hp").value;
	nexWavStats.hpRegen = CustomNetTables.GetTableValue("next_wave_table","hpRegen").value;
	nexWavStats.mp = CustomNetTables.GetTableValue("next_wave_table","mp").value;
	nexWavStats.mpRegen = CustomNetTables.GetTableValue("next_wave_table","mpRegen").value;
	nexWavStats.atkMin = CustomNetTables.GetTableValue("next_wave_table","atkMin").value;
	nexWavStats.atkMax = CustomNetTables.GetTableValue("next_wave_table","atkMax").value;
	nexWavStats.atkType = CustomNetTables.GetTableValue("next_wave_table","atkType").value;
	nexWavStats.atkRate = Math.round(CustomNetTables.GetTableValue("next_wave_table","atkRate").value * 100) / 100;
	nexWavStats.atkRange = CustomNetTables.GetTableValue("next_wave_table","atkRange").value;
	nexWavStats.atkMelee = CustomNetTables.GetTableValue("next_wave_table","atkMelee").value;
	nexWavStats.armor = CustomNetTables.GetTableValue("next_wave_table","armor").value;
	nexWavStats.armorType = CustomNetTables.GetTableValue("next_wave_table","armorType").value;
	nexWavStats.armorMagic = CustomNetTables.GetTableValue("next_wave_table","armorMagic").value;
	nexWavStats.speed = CustomNetTables.GetTableValue("next_wave_table","speed").value;
	nexWavStats.abil1 = CustomNetTables.GetTableValue("next_wave_table","abil1").value;
	nexWavStats.abil2 = CustomNetTables.GetTableValue("next_wave_table","abil2").value;
	nexWavStats.abil3 = CustomNetTables.GetTableValue("next_wave_table","abil3").value;
	nexWavStats.abil4 = CustomNetTables.GetTableValue("next_wave_table","abil4").value;
	nexWavStats.abil5 = CustomNetTables.GetTableValue("next_wave_table","abil5").value;
	
	nexWav2Stats.name = CustomNetTables.GetTableValue("next_wave_table","name2").value;
	nexWav2Stats.hp = CustomNetTables.GetTableValue("next_wave_table","hp2").value;
	nexWav2Stats.hpRegen = CustomNetTables.GetTableValue("next_wave_table","hpRegen2").value;
	nexWav2Stats.mp = CustomNetTables.GetTableValue("next_wave_table","mp2").value;
	nexWav2Stats.mpRegen = CustomNetTables.GetTableValue("next_wave_table","mpRegen2").value;
	nexWav2Stats.atkMin = CustomNetTables.GetTableValue("next_wave_table","atkMin2").value;
	nexWav2Stats.atkMax = CustomNetTables.GetTableValue("next_wave_table","atkMax2").value;
	nexWav2Stats.atkType = CustomNetTables.GetTableValue("next_wave_table","atkType2").value;
	nexWav2Stats.atkRate = Math.round(CustomNetTables.GetTableValue("next_wave_table","atkRate2").value * 100) / 100;
	nexWav2Stats.atkRange = CustomNetTables.GetTableValue("next_wave_table","atkRange2").value;
	nexWav2Stats.atkMelee = CustomNetTables.GetTableValue("next_wave_table","atkMelee2").value;
	nexWav2Stats.armor = CustomNetTables.GetTableValue("next_wave_table","armor2").value;
	nexWav2Stats.armorType = CustomNetTables.GetTableValue("next_wave_table","armorType2").value;
	nexWav2Stats.armorMagic = CustomNetTables.GetTableValue("next_wave_table","armorMagic2").value;
	nexWav2Stats.speed = CustomNetTables.GetTableValue("next_wave_table","speed2").value;
	nexWav2Stats.abil1 = CustomNetTables.GetTableValue("next_wave_table","abil12").value;
	nexWav2Stats.abil2 = CustomNetTables.GetTableValue("next_wave_table","abil22").value;
	nexWav2Stats.abil3 = CustomNetTables.GetTableValue("next_wave_table","abil32").value;
	nexWav2Stats.abil4 = CustomNetTables.GetTableValue("next_wave_table","abil42").value;
	nexWav2Stats.abil5 = CustomNetTables.GetTableValue("next_wave_table","abil52").value;
	
	$('#NextWaveIcon').style.backgroundImage = 'url("s2r://panorama/images/custom_game/'+nexWavStats.name+'_png.vtex")';
	$('#NextWaveIcon2').style.backgroundImage = 'url("s2r://panorama/images/custom_game/'+nexWav2Stats.name+'_png.vtex")';
	
	if (CustomNetTables.GetTableValue("next_wave_table","hideSecond").value == true) {
		$('#SplitBox4').visible = false;
	}
	if (CustomNetTables.GetTableValue("next_wave_table","hideSecond").value == false) {
		$('#SplitBox4').visible = true;
	}
	
	$('#GoldLabel').text = nexWavStats.gold.toString();
	if (nexWavStats.gold == 0) {
		$('#GoldLabel').visible = false;
	}
	
	if (nexWavStats.abil1 == "") {
		$('#NextWaveAbil1').visible = false;
	} else {
		$('#NextWaveAbil1').visible = true;
		$('#NextWaveAbil1').abilityname = nexWavStats.abil1;
		$('#NextWaveAbil1').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWaveAbil1'), nexWavStats.abil1);
		});
		$('#NextWaveAbil1').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWaveAbil1'));
		});
	}
	if (nexWavStats.abil2 == "" || nexWavStats.abil2 == "mob_ensnare_checker") {
		$('#NextWaveAbil2').visible = false;
	} else {
		$('#NextWaveAbil2').visible = true;
		$('#NextWaveAbil2').abilityname = nexWavStats.abil2;
		$('#NextWaveAbil2').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWaveAbil2'), nexWavStats.abil2);
		});
		$('#NextWaveAbil2').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWaveAbil2'));
		});
	}
	if (nexWavStats.abil3 == "") {
		$('#NextWaveAbil3').visible = false;
	} else {
		$('#NextWaveAbil3').visible = true;
		$('#NextWaveAbil3').abilityname = nexWavStats.abil3;
		$('#NextWaveAbil3').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWaveAbil3'), nexWavStats.abil3);
		});
		$('#NextWaveAbil3').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWaveAbil3'));
		});
	}
	if (nexWavStats.abil4 == "") {
		$('#NextWaveAbil4').visible = false;
	} else {
		$('#NextWaveAbil4').visible = true;
		$('#NextWaveAbil4').abilityname = nexWavStats.abil4;
		$('#NextWaveAbil4').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWaveAbil4'), nexWavStats.abil4);
		});
		$('#NextWaveAbil4').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWaveAbil4'));
		});
	}
	if (nexWavStats.abil5 == "") {
		$('#NextWaveAbil5').visible = false;
	} else {
		$('#NextWaveAbil5').visible = true;
		$('#NextWaveAbil5').abilityname = nexWavStats.abil5;
		$('#NextWaveAbil5').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWaveAbil5'), nexWavStats.abil5);
		});
		$('#NextWaveAbil5').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWaveAbil5'));
		});
	}
	
	if (nexWav2Stats.abil1 == "") {
		$('#NextWave2Abil1').visible = false;
	} else {
		$('#NextWave2Abil1').visible = true;
		$('#NextWave2Abil1').abilityname = nexWav2Stats.abil1;
		$('#NextWave2Abil1').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWave2Abil1'), nexWav2Stats.abil1);
		});
		$('#NextWave2Abil1').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWave2Abil1'));
		});
	}
	if (nexWav2Stats.abil2 == "" || nexWav2Stats.abil2 == "mob_ensnare_checker") {
		$('#NextWave2Abil2').visible = false;
	} else {
		$('#NextWave2Abil2').visible = true;
		$('#NextWave2Abil2').abilityname = nexWav2Stats.abil2;
		$('#NextWave2Abil2').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWave2Abil2'), nexWav2Stats.abil2);
		});
		$('#NextWave2Abil2').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWave2Abil2'));
		});
	}
	if (nexWav2Stats.abil3 == "") {
		$('#NextWave2Abil3').visible = false;
	} else {
		$('#NextWave2Abil3').visible = true;
		$('#NextWave2Abil3').abilityname = nexWav2Stats.abil3;
		$('#NextWave2Abil3').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWave2Abil3'), nexWav2Stats.abil3);
		});
		$('#NextWave2Abil3').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWave2Abil3'));
		});
	}
	if (nexWav2Stats.abil4 == "") {
		$('#NextWave2Abil4').visible = false;
	} else {
		$('#NextWave2Abil4').visible = true;
		$('#NextWave2Abil4').abilityname = nexWav2Stats.abil4;
		$('#NextWave2Abil4').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWave2Abil4'), nexWav2Stats.abil4);
		});
		$('#NextWave2Abil4').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWave2Abil4'));
		});
	}
	if (nexWav2Stats.abil5 == "") {
		$('#NextWave2Abil5').visible = false;
	} else {
		$('#NextWave2Abil5').visible = true;
		$('#NextWave2Abil5').abilityname = nexWav2Stats.abil5;
		$('#NextWave2Abil5').SetPanelEvent("onmouseover",function(){
			$.DispatchEvent("DOTAShowAbilityTooltip", $('#NextWave2Abil5'), nexWav2Stats.abil5);
		});
		$('#NextWave2Abil5').SetPanelEvent("onmouseout",function(){
			$.DispatchEvent("DOTAHideAbilityTooltip", $('#NextWave2Abil5'));
		});
	}
}

(function () {
	CustomNetTables.SubscribeNetTableListener("this_wave_table",UpdateThisWave);
	CustomNetTables.SubscribeNetTableListener("next_wave_table",UpdateNextWave);
	InitWave();
})();