var statBase = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block").FindChildTraverse("stats_container");
var statDmg = statBase.FindChildTraverse("stats").FindChildTraverse("Aligner").FindChildTraverse("StatContainer").FindChildTraverse("Damage").FindChildTraverse("DamageIcon");
var statArm = statBase.FindChildTraverse("stats").FindChildTraverse("Aligner").FindChildTraverse("StatContainer").FindChildTraverse("Armor").FindChildTraverse("ArmorIcon");
var statStr = statBase.FindChildTraverse("stragiint").FindChildTraverse("Strength");
var statAgi = statBase.FindChildTraverse("stragiint").FindChildTraverse("Agility");
var statInt = statBase.FindChildTraverse("stragiint").FindChildTraverse("Intelligence");

var strDigit = $.CreatePanel("Label", $.GetContextPanel(), "StatNumberBase");
strDigit.SetParent(statStr);
var bastard = statStr.FindChildTraverse("StrengthIcon");
bastard.SetParent(statAgi);
bastard.SetParent(statStr);
var agiDigit = $.CreatePanel("Label", $.GetContextPanel(), "StatNumberBase");
agiDigit.SetParent(statAgi);
bastard = statAgi.FindChildTraverse("AgilityIcon");
bastard.SetParent(statStr);
bastard.SetParent(statAgi);
var intDigit = $.CreatePanel("Label", $.GetContextPanel(), "StatNumberBase");
intDigit.SetParent(statInt);
bastard = statInt.FindChildTraverse("IntelligenceIcon");
bastard.SetParent(statAgi);
bastard.SetParent(statInt);
//strDigit.text = "skrrt";

var pIDs = {};
var pINs = {};
var mons = {};
var dmgtypeLast = "";
var armtypeLast = "";
var strBlast = 0;
var strPlast = 0;
var agiBlast = 0;
var agiPlast = 0;
var intBlast = 0;
var intPlast = 0;
//$.Msg(pINs);
//pINs[283].go = 1;
//pINs[283].fuck = 2;
//pINs[283].yourself = 3;
//$.Msg(pINs);
//$.Msg(pINs[283]);

function SkrrtSkrrt()
{
	var query = Players.GetQueryUnit(Players.GetLocalPlayer());
	if(query == -1) {
		query = Players.GetLocalPlayerPortraitUnit();
	}
	var pOwner = Entities.GetPlayerOwnerID(query);
	$.Msg("query "+query);
	var dmgtype = "";
	var armtype = "";
	var bufs = Entities.GetNumBuffs(query);
	for(var i = 0; i < bufs; i++)
	{
		//$.Msg(Buffs.GetTexture(query,i));
		if(Buffs.GetName(query,i) == "modifier_attack_normal") {dmgtype = "DamageMask";}
		if(Buffs.GetName(query,i) == "modifier_attack_pierce") {dmgtype = "DamageMaskPiercing";}
		if(Buffs.GetName(query,i) == "modifier_attack_siege") {dmgtype = "DamageMaskSiege";}
		if(Buffs.GetName(query,i) == "modifier_attack_magical") {dmgtype = "DamageMaskMagic";}
		if(Buffs.GetName(query,i) == "modifier_attack_chaos") {dmgtype = "DamageMaskChaos";}
		if(Buffs.GetName(query,i) == "modifier_attack_hero") {dmgtype = "DamageMaskHero";}
		if(Buffs.GetName(query,i) == "modifier_armor_normal") {armtype = "ArmorMask";}
		if(Buffs.GetName(query,i) == "modifier_armor_light") {armtype = "ArmorMaskLight";}
		if(Buffs.GetName(query,i) == "modifier_armor_medium") {armtype = "ArmorMaskMedium";}
		if(Buffs.GetName(query,i) == "modifier_armor_heavy") {armtype = "ArmorMaskHeavy";}
		if(Buffs.GetName(query,i) == "modifier_armor_fortified") {armtype = "ArmorMaskFortified";}
		if(Buffs.GetName(query,i) == "modifier_armor_hero") {armtype = "ArmorMaskHero";}
		if(Buffs.GetName(query,i) == "modifier_armor_unarmored") {armtype = "ArmorMaskNone";}
		
		if(dmgtype != "" && armtype != "") i = bufs;
	}
	if(dmgtype == "" || armtype == "")
	{
		//FAILSAFE
		
		if(Entities.IsHero(query))
		{
			//$.Msg("just got rich");
			//$.Msg(pIDs[Entities.GetPlayerOwnerID(query)].attack);
			//$.Msg(pIDs[Entities.GetPlayerOwnerID(query)].armor	);
			//$.Msg("pinscheck weapon "+pINs);
			if(pINs[query] != undefined)
			{
				$.Msg("pinsQcheck weapon "+pINs[query]);
				if(pINs[query].attack != undefined) dmgtype = pINs[query].attack;
				if(pINs[query].armor != undefined) armtype = pINs[query].armor;
			}
			else
			{
				if(pIDs[Entities.GetPlayerOwnerID(query)].attack != undefined) dmgtype = pIDs[Entities.GetPlayerOwnerID(query)].attack;
				if(pIDs[Entities.GetPlayerOwnerID(query)].armor != undefined) armtype = pIDs[Entities.GetPlayerOwnerID(query)].armor;
			}
		}
		else
		{
			//$.Msg("just got rich");
			//$.Msg(Entities.GetUnitName(query));
			//$.Msg(mons[Entities.GetUnitName(query)]);
			if(pINs[query] != undefined)
			{
				$.Msg("pinsQcheck weapon "+pINs[query]);
				if(pINs[query].attack != undefined) dmgtype = pINs[query].attack;
				if(pINs[query].armor != undefined) armtype = pINs[query].armor;
			}
			else
			{
				if(mons[Entities.GetUnitName(query)] != undefined) {
					dmgtype = mons[Entities.GetUnitName(query)].atktype;
					armtype = mons[Entities.GetUnitName(query)].armtype;
					//$.Msg(dmgtype);
				}
			}
		}
		if(dmgtype == "modifier_attack_normal") {dmgtype = "DamageMask";}
		if(dmgtype == "modifier_attack_pierce") {dmgtype = "DamageMaskPiercing";}
		if(dmgtype == "modifier_attack_siege") {dmgtype = "DamageMaskSiege";}
		if(dmgtype == "modifier_attack_magical") {dmgtype = "DamageMaskMagic";}
		if(dmgtype == "modifier_attack_chaos") {dmgtype = "DamageMaskChaos";}
		if(dmgtype == "modifier_attack_hero") {dmgtype = "DamageMaskHero";}
		if(armtype == "modifier_armor_normal") {armtype = "ArmorMask";}
		if(armtype == "modifier_armor_light") {armtype = "ArmorMaskLight";}
		if(armtype == "modifier_armor_medium") {armtype = "ArmorMaskMedium";}
		if(armtype == "modifier_armor_heavy") {armtype = "ArmorMaskHeavy";}
		if(armtype == "modifier_armor_fortified") {armtype = "ArmorMaskFortified";}
		if(armtype == "modifier_armor_hero") {armtype = "ArmorMaskHero";}
		if(armtype == "modifier_armor_unarmored") {armtype = "ArmorMaskNone";}
		
		//fuck it
		if(dmgtype == ""){dmgtype = "DamageMask";}
		if(armtype == "") {armtype = "ArmorMask";}
		/*for(var i = 0; i < pINs.length; i++)
		{
			if(pINs[i] == query)
			{
				pIDs[i].attack
				i = pINs.length;
			}
		}*/
	}
	
	if(dmgtype != dmgtypeLast) {
		statDmg.RemoveAndDeleteChildren()
		var damagemask = $.CreatePanel("Panel", $.GetContextPanel(), dmgtype);
		damagemask.BLoadLayoutSnippet(dmgtype);
		damagemask.SetParent(statDmg);
		dmgtypeLast = dmgtype;
	}
	if(armtype != armtypeLast) {
		statArm.RemoveAndDeleteChildren()
		var armormask = $.CreatePanel("Panel", $.GetContextPanel(), armtype);
		armormask.BLoadLayoutSnippet(armtype);
		armormask.SetParent(statArm);
		armtypeLast = armtype;
	}
	
	
	
	if(pINs[query] != undefined)
	{
		//$.Msg("pinsQcheck att "+pINs[query]);
		//ARE WE NOT PINS
		if(strBlast != pINs[query].strength)
		{
			statStr.FindChildTraverse("StrengthLabel").text = Math.round(parseInt(pINs[query].strength));
			strBlast = pINs[query].strength;
		}
		if(strPlast != pINs[query].strength_bonus) 
		{
			if(pINs[query].strength_bonus > 0) strDigit.text = "+"+pINs[query].strength_bonus;
			else strDigit.text = "";
			strPlast = pINs[query].strength_bonus;
		}
		if(agiBlast != pINs[query].agility)
		{
			statAgi.FindChildTraverse("AgilityLabel").text = Math.round(parseInt(pINs[query].agility));
			agiBlast = pINs[query].agility;
		}
		if(agiPlast != pINs[query].agility_bonus) 
		{
			if(pINs[query].agility_bonus > 0) agiDigit.text = "+"+pINs[query].agility_bonus;
			else agiDigit.text = "";
			agiPlast = pINs[query].agility_bonus;
		}
		if(intBlast != pINs[query].intellect)
		{
			statInt.FindChildTraverse("IntelligenceLabel").text = Math.round(parseInt(pINs[query].intellect));
			intBlast = pINs[query].intellect;
		}
		if(intPlast != pINs[query].intellect_bonus) 
		{
			if(pINs[query].intellect_bonus > 0) intDigit.text = "+"+pINs[query].intellect_bonus;
			else intDigit.text = "";
			intPlast = pINs[query].intellect_bonus;
		}
	}
	else
	{
		if(strBlast != pIDs[pOwner].strength)
		{
			statStr.FindChildTraverse("StrengthLabel").text = Math.round(parseInt(pIDs[pOwner].strength));
			strBlast = pIDs[pOwner].strength;
		}
		if(strPlast != pIDs[pOwner].strength_bonus) 
		{
			if(pIDs[pOwner].strength_bonus > 0) strDigit.text = "+"+pIDs[pOwner].strength_bonus;
			else strDigit.text = "";
			strPlast = pIDs[pOwner].strength_bonus;
		}
		if(agiBlast != pIDs[pOwner].agility)
		{
			statAgi.FindChildTraverse("AgilityLabel").text = Math.round(parseInt(pIDs[pOwner].agility));
			agiBlast = pIDs[pOwner].agility;
		}
		if(agiPlast != pIDs[pOwner].agility_bonus) 
		{
			if(pIDs[pOwner].agility_bonus > 0) agiDigit.text = "+"+pIDs[pOwner].agility_bonus;
			else agiDigit.text = "";
			agiPlast = pIDs[pOwner].agility_bonus;
		}
		if(intBlast != pIDs[pOwner].intellect)
		{
			statInt.FindChildTraverse("IntelligenceLabel").text = Math.round(parseInt(pIDs[pOwner].intellect));
			intBlast = pIDs[pOwner].intellect;
		}
		if(intPlast != pIDs[pOwner].intellect_bonus) 
		{
			if(pIDs[pOwner].intellect_bonus > 0) intDigit.text = "+"+pIDs[pOwner].intellect_bonus;
			else intDigit.text = "";
			intPlast = pIDs[pOwner].intellect_bonus;
		}
	}
	//$.Msg(bufs);
	//$.Msg(dmgtypeLast);
	
	//statStr.FindChildTraverse("StrengthLabel").text = "9";
	//statStr.FindChildTraverse("StrengthModifierLabel").text = "";
	//$.Msg(Entities.GetBuff(query,1));
	//$.Msg(Buffs.GetName(query,1));
}

function DVonGetTheTables()
{
	//This nettable is for illusions/summons because I can't plan ahead
	var bam = CustomNetTables.GetTableValue("hero_data_live","summons");
	for (var skrrt in bam) {
		$.Msg("d "+skrrt);
		$.Msg("d "+skrrt.destroy);
		if(skrrt.destroy == undefined) pINs[skrrt] = bam[skrrt];
		else delete pINs[skrrt];
	}
	$.Msg("a brand new hip");
	$.Msg(pINs);
	
	//This nettable literally exists JUST for faen. I hate this game
	var heroData2 = CustomNetTables.GetTableValue("hero_data_live","stats");
	var checkem;
	for (var playerID in pIDs) {
		//var hero = Players.GetPlayerSelectedHero(parseInt(playerID));
		//$.Msg("argh "+heroData2[hero].atktype);
		if(heroData2[playerID].str != undefined)		pIDs[playerID].strength = heroData2[playerID].str;
		if(heroData2[playerID].strbn != undefined)		pIDs[playerID].strength_bonus = heroData2[playerID].strbn;
		if(heroData2[playerID].agi != undefined)		pIDs[playerID].agility = heroData2[playerID].agi;
		if(heroData2[playerID].agibn != undefined)		pIDs[playerID].agility_bonus = heroData2[playerID].agibn;
		if(heroData2[playerID].int != undefined)		pIDs[playerID].intellect = heroData2[playerID].int;
		if(heroData2[playerID].intbn != undefined)		pIDs[playerID].intellect_bonus = heroData2[playerID].intbn;
		if(heroData2[playerID].atktype != undefined)	pIDs[playerID].attack = heroData2[playerID].atktype;
		if(heroData2[playerID].armtype != undefined)	pIDs[playerID].armor = heroData2[playerID].armtype;
		if(heroData2[playerID] != undefined)			checkem = playerID;
		//$.Msg("urgh "+pIDs[playerID].attack);
		$.Msg(checkem);
	}
	var query = Players.GetQueryUnit(Players.GetLocalPlayer());
	if(query == -1) query = Players.GetLocalPlayerPortraitUnit();
	if(Entities.GetPlayerOwnerID(query) == checkem)
	{
		SkrrtSkrrt();
		if(Players.GetPlayerSelectedHero(parseInt(playerID)) == "npc_dota_hero_terrorblade" && heroData2[playerID].atktype == "modifier_attack_chaos")
		{$.Schedule(0.05,function() {SkrrtSkrrt();});}
	}
}

function HoldOn(event)
{
	/*$.Msg("WORLD HOLD ON");
	$.Msg(event.player);
	$.Msg(event.heroindex);
	//pINs[playerID] = event.heroindex
	Entities.GetPlayerOwnerID(event.heroindex);*/
	pINs = CustomNetTables.GetTableValue("hero_data_live","summons");
}

function MaybeUberMaybeCab()
{
	mons = CustomNetTables.GetTableValue("monster_data_pretaped","dont_crash");
}

function Bah()
{
	var heroData = CustomNetTables.GetTableValue("hero_data","stats");
	//$.Msg("ARGH");
	//$.Msg(heroData["npc_dota_hero_drow_ranger"].armtype);
	//$.Schedule(0.1,function() {
	for (var playerID in pIDs) {
		var hero = Players.GetPlayerSelectedHero(parseInt(playerID));
		var dex = Players.GetPlayerHeroEntityIndex(parseInt(playerID));
		$.Msg("please dont change or im get mad "+dex);
		//pIDs[playerID] = new Array(8);
		if(pINs[hero] != undefined)
		{
			$.Msg("pINs defined");
		}
		else
		{
			$.Msg("pINs undefined");
			if(pIDs[playerID].starterstat == undefined || pIDs[playerID].starterstat != dex)
			{
				//$.Msg("aa "+playerID);
				//$.Msg("aa "+Players.GetPlayerSelectedHero(parseInt(playerID)));
				pIDs[playerID] = new Array(9);
				pIDs[playerID].strength = heroData[hero].str;
				pIDs[playerID].strength_bonus = 0;
				pIDs[playerID].agility = heroData[hero].agi;
				pIDs[playerID].agility_bonus = 0;
				pIDs[playerID].intellect = heroData[hero].int;
				pIDs[playerID].intellect_bonus = 0;
				pIDs[playerID].attack = heroData[hero].atktype;
				pIDs[playerID].armor = heroData[hero].armtype;
				pIDs[playerID].starterstat = dex;
				//$.Msg(pIDs[playerID].attack);
				//$.Msg(heroData[hero].atktype);
				//are we not pINs
				//pINs[playerID] = Players.GetPlayerHeroEntityIndex(parseInt(playerID));
			}
		}
		//$.Msg("STOP IT "+pIDs[playerID].strength);
	}
	SkrrtSkrrt();
	//});
}

(function()
{
	GameEvents.Subscribe( "dota_player_update_query_unit", SkrrtSkrrt );
	GameEvents.Subscribe( "dota_player_update_selected_unit", SkrrtSkrrt );
	GameEvents.Subscribe( "dota_player_pick_hero", Bah );
	CustomNetTables.SubscribeNetTableListener("hero_data", Bah );
	CustomNetTables.SubscribeNetTableListener("hero_data_live", DVonGetTheTables );
	CustomNetTables.SubscribeNetTableListener("monster_data_pretaped", MaybeUberMaybeCab );
	pIDs = Game.GetAllPlayerIDs();
	//var heroData = CustomNetTables.GetTableValue("hero_data","stats");
	//$.Msg(heroData);
	//SkrrtSkrrt(); // initial update
	//$.Schedule(1,function() {Bah();});
})();
