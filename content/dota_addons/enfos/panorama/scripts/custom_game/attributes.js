var statBase = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block").FindChildTraverse("stats_container");
var statDmg = statBase.FindChildTraverse("stats").FindChildTraverse("Aligner").FindChildTraverse("StatContainer").FindChildTraverse("Damage").FindChildTraverse("DamageIcon");
var statArm = statBase.FindChildTraverse("stats").FindChildTraverse("Aligner").FindChildTraverse("StatContainer").FindChildTraverse("Armor").FindChildTraverse("ArmorIcon");
var statStr = statBase.FindChildTraverse("stragiint").FindChildTraverse("Strength");
var statAgi = statBase.FindChildTraverse("stragiint").FindChildTraverse("Agility");
var statInt = statBase.FindChildTraverse("stragiint").FindChildTraverse("Intelligence");

var pIDs = {};
var pINs = {};
var mons = {};
var dmgtypeLast = "";
var armtypeLast = "";

function SkrrtSkrrt()
{
	var query = Players.GetQueryUnit(Players.GetLocalPlayer());
	if(query == -1) {
		query = Players.GetLocalPlayerPortraitUnit();
	}
	//$.Msg(query);
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
			if(pIDs[Entities.GetPlayerOwnerID(query)].attack != undefined) dmgtype = pIDs[Entities.GetPlayerOwnerID(query)].attack;
			if(pIDs[Entities.GetPlayerOwnerID(query)].armor != undefined) armtype = pIDs[Entities.GetPlayerOwnerID(query)].armor;
		}
		else
		{
			//$.Msg("just got rich");
			//$.Msg(Entities.GetUnitName(query));
			//$.Msg(mons[Entities.GetUnitName(query)]);
			if(mons[Entities.GetUnitName(query)] != undefined) {
				dmgtype = mons[Entities.GetUnitName(query)].atktype;
				armtype = mons[Entities.GetUnitName(query)].armtype;
				//$.Msg(dmgtype);
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
	//$.Msg(bufs);
	//$.Msg(dmgtypeLast);
	
	//statStr.FindChildTraverse("StrengthLabel").text = "9";
	//statStr.FindChildTraverse("StrengthModifierLabel").text = "";
	//$.Msg(Entities.GetBuff(query,1));
	//$.Msg(Buffs.GetName(query,1));
}

function DVonGetTheTables()
{
	//This nettable literally exists JUST for faen. I hate this game
	
	var heroData2 = CustomNetTables.GetTableValue("hero_data_live","stats");
	for (var playerID in pIDs) {
		var hero = Players.GetPlayerSelectedHero(parseInt(playerID));
		//$.Msg("argh "+heroData2[hero].atktype);
		if(heroData2[hero].atktype != undefined) pIDs[playerID].attack = heroData2[hero].atktype;
		if(heroData2[hero].armtype != undefined) pIDs[playerID].armor = heroData2[hero].armtype;
		//$.Msg("urgh "+pIDs[playerID].attack);
	}
	SkrrtSkrrt();
}

function HoldOn(event)
{
	$.Msg("WORLD HOLD ON");
	$.Msg(event.player);
	$.Msg(event.heroindex);
	pINs[playerID] = event.heroindex
	Entities.GetPlayerOwnerID(event.heroindex);
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
	for (var playerID in pIDs) {
		var hero = Players.GetPlayerSelectedHero(parseInt(playerID));
		//$.Msg("aa "+playerID);
		//$.Msg("aa "+Players.GetPlayerSelectedHero(parseInt(playerID)));
		pIDs[playerID] = new Array(8);
		pIDs[playerID].strength = heroData[hero].str;
		pIDs[playerID].strength_bonus = 0;
		pIDs[playerID].agility = heroData[hero].agi;
		pIDs[playerID].agility_bonus = 0;
		pIDs[playerID].intellect = heroData[hero].int;
		pIDs[playerID].intellect_bonus = 0;
		pIDs[playerID].attack = heroData[hero].atktype;
		pIDs[playerID].armor = heroData[hero].armtype;
		//$.Msg(pIDs[playerID].attack);
		//$.Msg(heroData[hero].atktype);
		//are we not pINs
		//pINs[playerID] = Players.GetPlayerHeroEntityIndex(parseInt(playerID));
	}
	SkrrtSkrrt();
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
	SkrrtSkrrt(); // initial update
	//$.Schedule(1,function() {Bah();});
})();
