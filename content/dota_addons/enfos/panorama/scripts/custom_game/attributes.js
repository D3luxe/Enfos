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
//tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("IntelligenceContainer").FindChildrenWithClassTraverse("AttributeDetails").FindChildTraverse("IntelligenceDamageLabel").text = "wipe my ass";
//$.Msg($.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Tooltips").FindChildTraverse("DOTAHUDDamageArmorTooltip").GetChild(1).FindChildTraverse("Contents").FindChildTraverse("AttributesContainer").FindChildTraverse("IntelligenceContainer").GetChild(1).FindChildTraverse("IntelligenceDamageLabel"));
var tooltipBox;
var strDmgLabel;
var strStatLabel;
var strBaseLabel;
var strPlusLabel;
var strGainLabel;
var agiDmgLabel;
var agiStatLabel;
var agiBaseLabel;
var agiPlusLabel;
var agiGainLabel;
var intDmgLabel;
var intStatLabel;
var intBaseLabel;
var intPlusLabel;
var intGainLabel;

var atkBoxBase;
var defBoxBase;
var atkBoxNo;
var defBoxNo;

var atkPrev;
var defPrev;

function SkrrtSkrrt()
{
	var query = Players.GetQueryUnit(Players.GetLocalPlayer());
	if(query == -1) {
		query = Players.GetLocalPlayerPortraitUnit();
	}
	var pOwner = Entities.GetPlayerOwnerID(query);
	//$.Msg("query "+query);
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
				//$.Msg("pinsQcheck weapon "+pINs[query]);
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
				//$.Msg("pinsQcheck weapon "+pINs[query]);
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
	else if(Entities.IsHero(query))
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
	if(tooltipBox != undefined)
	{
		if($.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Tooltips").FindChildTraverse("DOTAHUDDamageArmorTooltip").BHasClass("TooltipVisible") == false)
		{
			if (Entities.IsHero(query))
			{
				var tooltipDamage = Math.round((strBlast+strPlast)* 250/*2.5 * 100*/) / 100
				var tooltipHP = Math.round((strBlast+strPlast)* 4000/*40 * 100*/) / 100
				var tooltipHPR = Math.round((strBlast+strPlast)* 3/*0.03 * 100*/) / 100
				var tooltipArmor = Math.round((agiBlast+agiPlast)* 5/*0.05 * 100*/) / 100
				var tooltipIAS = Math.round((agiBlast+agiPlast)* 100/*1 * 100*/) / 100
				var tooltipMS = Math.round((agiBlast+agiPlast)* 3/*0.03 * 100*/) / 100
				var tooltipMP = Math.round((intBlast+intPlast)* 1600/*16 * 100*/) / 100
				var tooltipMPR = Math.round((intBlast+intPlast)* 5/*0.05 * 100*/) / 100
				
				var tooltipStrGain;
				var tooltipAgiGain;
				var tooltipIntGain;
				
				if (pINs[query] != undefined)
				{
					tooltipStrGain = Math.round(pINs[query].strength_gain * 100)/100;
					tooltipAgiGain = Math.round(pINs[query].agility_gain * 100)/100;
					tooltipIntGain = Math.round(pINs[query].intellect_gain * 100)/100;
				}
				else
				{
					tooltipStrGain = Math.round(pIDs[pOwner].strength_gain * 100)/100;
					tooltipAgiGain = Math.round(pIDs[pOwner].agility_gain * 100)/100;
					tooltipIntGain = Math.round(pIDs[pOwner].intellect_gain * 100)/100;
				}
				if(tooltipStrGain - Math.round(tooltipStrGain) == 0) tooltipStrGain = tooltipStrGain+".0";
				if(tooltipAgiGain - Math.round(tooltipAgiGain) == 0) tooltipAgiGain = tooltipAgiGain+".0";
				if(tooltipIntGain - Math.round(tooltipIntGain) == 0) tooltipIntGain = tooltipIntGain+".0";
				
				strDmgLabel.text = "= "+tooltipDamage+" Damage (Primary Role Bonus)";
				strStatLabel.text = "= "+tooltipHP+" HP and "+tooltipHPR+" HP Regen";
				
				strBaseLabel.text = Math.round(strBlast);
				if (strPlast > 0)
				{
					/*if(strPlusLabel.BHasClass("NoBonus")) */strPlusLabel.RemoveClass("NoBonus");
					strPlusLabel.text = "+"+strPlast;
				}
				else if(strPlusLabel.BHasClass("NoBonus") == false) strPlusLabel.AddClass("NoBonus");
				strGainLabel.text = "(Gains "+tooltipStrGain+" per lvl)";
				
				agiDmgLabel.text = "= "+tooltipDamage+" Damage (Primary Role Bonus)";
				agiStatLabel.text = "= "+tooltipArmor+" Armor, "+tooltipIAS+" Attack Speed and "+tooltipMS+" Movement Speed";
				
				agiBaseLabel.text = Math.round(agiBlast);
				if (agiPlast > 0)
				{
					if(agiPlusLabel.BHasClass("NoBonus")) agiPlusLabel.RemoveClass("NoBonus");
					agiPlusLabel.text = "+"+agiPlast;
				}
				else if(agiPlusLabel.BHasClass("NoBonus") == false) agiPlusLabel.AddClass("NoBonus");
				agiGainLabel.text = "(Gains "+tooltipAgiGain+" per lvl)";
				
				intDmgLabel.text = "= "+tooltipDamage+" Damage (Primary Role Bonus)";
				intStatLabel.text = "= "+tooltipMP+" Mana and "+tooltipMPR+" Mana Regen";
				
				intBaseLabel.text = Math.round(intBlast);
				if (intPlast > 0)
				{
					if(intPlusLabel.BHasClass("NoBonus")) intPlusLabel.RemoveClass("NoBonus");
					intPlusLabel.text = "+"+intPlast;
				}
				else if(intPlusLabel.BHasClass("NoBonus") == false) intPlusLabel.AddClass("NoBonus");
				intGainLabel.text = "(Gains "+tooltipIntGain+" per lvl)";
			}
			
			atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelNormal");
			atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelGreen");
			atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelRed");
			atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelBlue");
			atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelPurple");
			atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelYellow");
			
			defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelNormal");
			defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelBlack");
			defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelGreen");
			defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelRed");
			defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelBlue");
			defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelPurple");
			defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelYellow");
			
			if(Entities.GetUnitName(query) == "npc_dota_hero_lina"
			|| Entities.GetUnitName(query) == "npc_spellbringer"
			|| Entities.GetUnitName(query) == "npc_starlight_sphere"
			|| Entities.GetUnitName(query) == "npc_dota_spirit_hawk"
			|| Entities.GetUnitName(query) == "npc_dota_spirit_owl"
			|| Entities.GetUnitName(query) == "npc_summon_sidhlot"
			|| Entities.GetUnitName(query) == "npc_summon_arhat"
			|| Entities.GetUnitName(query) == "npc_summon_havroth"
			|| Entities.GetUnitName(query) == "npc_summon_uthmor") atkBoxNo.style.visibility = "visible";
			else atkBoxNo.style.visibility = "collapse";
			if(Entities.GetUnitName(query) == "npc_spellbringer"
			|| Entities.GetUnitName(query) == "npc_summon_sidhlot"
			|| Entities.GetUnitName(query) == "npc_summon_arhat"
			|| Entities.GetUnitName(query) == "npc_summon_havroth"
			|| Entities.GetUnitName(query) == "npc_summon_uthmor") defBoxNo.style.visibility = "visible";
			else defBoxNo.style.visibility = "collapse";
			
			if(dmgtypeLast == "DamageMask")
			{
				atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "NORMAL";
				atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelNormal");
				atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/broadsword.png")';
			}
			if(dmgtypeLast == "DamageMaskPiercing")
			{
				atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "PIERCING";
				atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelGreen");
				atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/javelin.png")';
			}
			if(dmgtypeLast == "DamageMaskSiege")
			{
				atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "SIEGE";
				atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelRed");
				atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/mithril_hammer.png")';
			}
			if(dmgtypeLast == "DamageMaskMagic")
			{
				atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "MAGIC";
				atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelBlue");
				atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/magic_wand.png")';
			}
			if(dmgtypeLast == "DamageMaskChaos")
			{
				atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "CHAOS";
				atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelPurple");
				atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/silver_edge.png")';
			}
			if(dmgtypeLast == "DamageMaskHero")
			{
				atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "HERO";
				atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelYellow");
				atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/radiance.png")';
			}
			
			if(armtypeLast == "ArmorMask")
			{
				defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "NORMAL";
				defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelNormal");
				defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/chainmail.png")';
			}
			if(armtypeLast == "ArmorMaskNone")
			{
				defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "UNARMORED";
				defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelBlack");
				defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/belt_of_strength.png")';
			}
			if(armtypeLast == "ArmorMaskLight")
			{
				defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "LIGHT";
				defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelGreen");
				defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/stout_shield.png")';
			}
			if(armtypeLast == "ArmorMaskMedium")
			{
				defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "MEDIUM";
				defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelRed");
				defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/buckler.png")';
			}
			if(armtypeLast == "ArmorMaskHeavy")
			{
				defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "HEAVY";
				defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelBlue");
				defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/shivas_guard.png")';
			}
			if(armtypeLast == "ArmorMaskFortified")
			{
				defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "FORTIFIED";
				defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelPurple");
				defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/blade_mail.png")';
			}
			if(armtypeLast == "ArmorMaskHero")
			{
				defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "HERO";
				defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelYellow");
				defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/solar_crest.png")';
			}
			
			var dNor = 100;
			var dUna = 100;
			if(dmgtypeLast == "DamageMaskPiercing" || dmgtypeLast == "DamageMaskSiege") dUna = 150;
			var dLig = 100;
			if(dmgtypeLast == "DamageMaskPiercing") dLig = 200;
			if(dmgtypeLast == "DamageMaskMagic") dLig = 125;
			var dMed = 100;
			if(dmgtypeLast == "DamageMask") dMed = 125;
			if(dmgtypeLast == "DamageMaskPiercing" || dmgtypeLast == "DamageMaskMagic") dMed = 75;
			if(dmgtypeLast == "DamageMaskSiege") dMed = 50;
			var dHea = 100;
			if(dmgtypeLast == "DamageMaskMagic") dHea = 150;
			var dFor = 100;
			if(dmgtypeLast == "DamageMask") dFor = 80;
			if(dmgtypeLast == "DamageMaskPiercing" || dmgtypeLast == "DamageMaskHero") dFor = 50;
			if(dmgtypeLast == "DamageMaskSiege") dFor = 150;
			if(dmgtypeLast == "DamageMaskMagic") dFor = 40;
			var dHer = 100;
			if(dmgtypeLast == "DamageMaskPiercing" || dmgtypeLast == "DamageMaskSiege" || dmgtypeLast == "DamageMaskMagic") dHer = 50;
			
			var aNor = 100;
			if(armtypeLast == "ArmorMaskMedium") aNor = 125;
			if(armtypeLast == "ArmorMaskFortified") aNor = 80;
			var aPie = 100;
			if(armtypeLast == "ArmorMaskNone") aPie = 150;
			if(armtypeLast == "ArmorMaskLight") aPie = 200;
			if(armtypeLast == "ArmorMaskMedium") aPie = 75;
			if(armtypeLast == "ArmorMaskFortified" || armtypeLast == "ArmorMaskHero") aPie = 50;
			var aSie = 100;
			if(armtypeLast == "ArmorMaskNone" || armtypeLast == "ArmorMaskFortified") aSie = 150;
			if(armtypeLast == "ArmorMaskMedium" || armtypeLast == "ArmorMaskHero") aSie = 50;
			var aMag = 100;
			if(armtypeLast == "ArmorMaskLight") aMag = 125;
			if(armtypeLast == "ArmorMaskMedium") aMag = 75;
			if(armtypeLast == "ArmorMaskHeavy") aMag = 150;
			if(armtypeLast == "ArmorMaskFortified") aMag = 40;
			if(armtypeLast == "ArmorMaskHero") aMag = 50;
			var aCha = 100;
			var aHer = 100;
			if(armtypeLast == "ArmorMaskFortified") aHer = 50;
			
			DetermineDamageNumbers("attack", "NormalArmorRow", dNor);
			DetermineDamageNumbers("attack", "UnarmoredRow", dUna);
			DetermineDamageNumbers("attack", "LightArmorRow", dLig);
			DetermineDamageNumbers("attack", "MediumArmorRow", dMed);
			DetermineDamageNumbers("attack", "HeavyArmorRow", dHea);
			DetermineDamageNumbers("attack", "FortifiedArmorRow", dFor);
			DetermineDamageNumbers("attack", "HeroArmorRow", dHer);
			
			DetermineDamageNumbers("defense", "NormalDamageRow", aNor);
			DetermineDamageNumbers("defense", "PiercingDamageRow", aPie);
			DetermineDamageNumbers("defense", "SiegeDamageRow", aSie);
			DetermineDamageNumbers("defense", "MagicDamageRow", aMag);
			DetermineDamageNumbers("defense", "ChaosDamageRow", aCha);
			DetermineDamageNumbers("defense", "HeroDamageRow", aHer);
			
			atkPrev = dmgtype;
			defPrev = armtype;
			
			//$.Msg(intStatLabel.text);
			//$.Msg($.Localize("#DOTA_HUD_PrimaryAttributeIntelligence"));
			//intDmgLabel.SetDialogVariable("d:primary_attribute_damage",((9)*2.5).toString);
			//intStatLabel.SetDialogVariable("d:intelligence_mana",((9)*2.5).toString);
			//intStatLabel.SetDialogVariable("s:intelligence_mana_regen",((9)*2.5).toString);
			//intStatLabel.SetDialogVariableInt("s:intelligence_spell_amp",0);
			//$.Msg(intDmgLabel.text);
			//intDmgLabel.text = "honestly fuck you";
			//intStatLabel.text.str.replace("%",""); figure this out later
		}
	}
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
		//$.Msg(checkem);
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
		//$.Msg("please dont change or im get mad "+dex);
		//pIDs[playerID] = new Array(8);
		if(pINs[hero] != undefined)
		{
			//$.Msg("pINs defined");
		}
		else
		{
			//$.Msg("pINs undefined");
			if(pIDs[playerID].starterstat == undefined || pIDs[playerID].starterstat != dex)
			{
				//$.Msg("aa "+playerID);
				//$.Msg("aa "+Players.GetPlayerSelectedHero(parseInt(playerID)));
				pIDs[playerID] = new Array(12);
				pIDs[playerID].strength = heroData[hero].str;
				pIDs[playerID].strength_bonus = 0;
				pIDs[playerID].strength_gain = heroData[hero].strpl;
				pIDs[playerID].agility = heroData[hero].agi;
				pIDs[playerID].agility_bonus = 0;
				pIDs[playerID].agility_gain = heroData[hero].agipl;
				pIDs[playerID].intellect = heroData[hero].int;
				pIDs[playerID].intellect_bonus = 0;
				pIDs[playerID].intellect_gain = heroData[hero].intpl;
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

function WaitForToolTipBox()
{
	if($.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Tooltips").FindChildTraverse("DOTAHUDDamageArmorTooltip") != undefined)
	{
		//$.Msg("Yes!");
		tooltipBox = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Tooltips").FindChildTraverse("DOTAHUDDamageArmorTooltip").GetChild(1).FindChildTraverse("Contents");
		
		strDmgLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("StrengthContainer").GetChild(1).FindChildTraverse("StrengthDamageLabel");
		strStatLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("StrengthContainer").GetChild(1).FindChildTraverse("StrengthDetails");
		
		strBaseLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("StrengthContainer").GetChild(1).FindChildTraverse("AttributeValues").FindChildTraverse("BaseStrengthLabel");
		strPlusLabel = $.CreatePanel("Label", $.GetContextPanel(), "TooltipNumberBase");
		strPlusLabel.SetParent(strBaseLabel.GetParent());
		strGainLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("StrengthContainer").GetChild(1).FindChildTraverse("AttributeValues").FindChildTraverse("StrengthGainLabel");
		
		agiDmgLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("AgilityContainer").GetChild(1).FindChildTraverse("AgilityDamageLabel");
		agiStatLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("AgilityContainer").GetChild(1).FindChildTraverse("AgilityDetails");
		
		agiBaseLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("AgilityContainer").GetChild(1).FindChildTraverse("AttributeValues").FindChildTraverse("BaseAgilityLabel");
		//agiPlusLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("AgilityContainer").GetChild(1).FindChildTraverse("AttributeValues").FindChildTraverse("BonusAgilityabel"); //YEP, THAT'S A TYPO IN VALVE'S CSS
		agiPlusLabel = $.CreatePanel("Label", $.GetContextPanel(), "TooltipNumberBase");
		agiPlusLabel.SetParent(agiBaseLabel.GetParent());
		agiGainLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("AgilityContainer").GetChild(1).FindChildTraverse("AttributeValues").FindChildTraverse("AgilityGainLabel");
		
		intDmgLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("IntelligenceContainer").GetChild(1).FindChildTraverse("IntelligenceDamageLabel");
		intStatLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("IntelligenceContainer").GetChild(1).FindChildTraverse("IntelligenceDetails");
		
		intBaseLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("IntelligenceContainer").GetChild(1).FindChildTraverse("AttributeValues").FindChildTraverse("BaseIntelligenceLabel");
		intPlusLabel = $.CreatePanel("Label", $.GetContextPanel(), "TooltipNumberBase");
		intPlusLabel.SetParent(intBaseLabel.GetParent());
		intGainLabel = tooltipBox.FindChildTraverse("AttributesContainer").FindChildTraverse("IntelligenceContainer").GetChild(1).FindChildTraverse("AttributeValues").FindChildTraverse("IntelligenceGainLabel");
		
		var anotherBastard = strBaseLabel.GetParent();
		strGainLabel.SetParent(agiBaseLabel.GetParent());
		strGainLabel.SetParent(anotherBastard);
		anotherBastard = agiBaseLabel.GetParent();
		agiGainLabel.SetParent(strBaseLabel.GetParent());
		agiGainLabel.SetParent(anotherBastard);
		anotherBastard = intBaseLabel.GetParent();
		intGainLabel.SetParent(agiBaseLabel.GetParent());
		intGainLabel.SetParent(anotherBastard);
		
		tooltipBox.FindChildTraverse("AttackDefenseContainer").style.height = "374px";
		var boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "AttackTypeContainer");
		boxxy.SetParent(tooltipBox.FindChildTraverse("AttackDefenseContainer").FindChildTraverse("AttackContainer"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "DefenseTypeContainer");
		boxxy.SetParent(tooltipBox.FindChildTraverse("AttackDefenseContainer").FindChildTraverse("DefenseContainer"));
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "BGBox");
		boxxy.SetParent(tooltipBox.FindChildTraverse("AttackDefenseContainer").FindChildTraverse("AttackContainer").FindChildTraverse("AttackTypeContainer"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "BGBox");
		boxxy.SetParent(tooltipBox.FindChildTraverse("AttackDefenseContainer").FindChildTraverse("DefenseContainer").FindChildTraverse("DefenseTypeContainer"));
		
		atkBoxBase = $.CreatePanel("Panel", $.GetContextPanel(), "FlowBox");
		atkBoxBase.SetParent(tooltipBox.FindChildTraverse("AttackDefenseContainer").FindChildTraverse("AttackContainer").FindChildTraverse("AttackTypeContainer"));
		defBoxBase = $.CreatePanel("Panel", $.GetContextPanel(), "FlowBox");
		defBoxBase.SetParent(tooltipBox.FindChildTraverse("AttackDefenseContainer").FindChildTraverse("DefenseContainer").FindChildTraverse("DefenseTypeContainer"));
		
		atkBoxNo = $.CreatePanel("Panel", $.GetContextPanel(), "OverBox");
		atkBoxNo.SetParent(tooltipBox.FindChildTraverse("AttackDefenseContainer").FindChildTraverse("AttackContainer").FindChildTraverse("AttackTypeContainer"));
		defBoxNo = $.CreatePanel("Panel", $.GetContextPanel(), "OverBox");
		defBoxNo.SetParent(tooltipBox.FindChildTraverse("AttackDefenseContainer").FindChildTraverse("DefenseContainer").FindChildTraverse("DefenseTypeContainer"));
		
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "OverLabel");
		boxxy.SetParent(atkBoxNo);
		boxxy.text = $.Localize("#dota_hud_error_unit_cant_attack");
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "OverLabel");
		boxxy.SetParent(defBoxNo);
		boxxy.text = $.Localize("#DOTA_Tooltip_lm_take_no_damage");
		
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "AttackTypeHeader");
		boxxy.SetParent(atkBoxBase);
		boxxy.text = "NORMAL";
		boxxy.AddClass("StatLabelNormal");
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "DefenseTypeHeader");
		boxxy.SetParent(defBoxBase);
		boxxy.text = "NORMAL";
		boxxy.AddClass("StatLabelNormal");
		
		///
		///
		///
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "NormalArmorRow");
		boxxy.SetParent(atkBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("NormalArmorRow"));
		boxxy.text = "Normal:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("NormalArmorRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconArmor");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("NormalArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("NormalArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "UnarmoredRow");
		boxxy.SetParent(atkBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("UnarmoredRow"));
		boxxy.text = "Unarmored:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("UnarmoredRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconArmor");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("UnarmoredRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "ArmorMaskNone");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("UnarmoredRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconArmor"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("UnarmoredRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LightArmorRow");
		boxxy.SetParent(atkBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("LightArmorRow"));
		boxxy.text = "Light:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("LightArmorRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconArmor");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("LightArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "ArmorMaskLight");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("LightArmorRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconArmor"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("LightArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "MediumArmorRow");
		boxxy.SetParent(atkBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("MediumArmorRow"));
		boxxy.text = "Medium:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("MediumArmorRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconArmor");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("MediumArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "ArmorMaskMedium");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("MediumArmorRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconArmor"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("MediumArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "HeavyArmorRow");
		boxxy.SetParent(atkBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeavyArmorRow"));
		boxxy.text = "Heavy:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeavyArmorRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconArmor");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeavyArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "ArmorMaskHeavy");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeavyArmorRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconArmor"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeavyArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "FortifiedArmorRow");
		boxxy.SetParent(atkBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("FortifiedArmorRow"));
		boxxy.text = "Fortified:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("FortifiedArmorRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconArmor");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("FortifiedArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "ArmorMaskFortified");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("FortifiedArmorRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconArmor"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("FortifiedArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "HeroArmorRow");
		boxxy.SetParent(atkBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeroArmorRow"));
		boxxy.text = "Hero:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeroArmorRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconArmor");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeroArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "ArmorMaskHero");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeroArmorRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconArmor"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(atkBoxBase.FindChildTraverse("HeroArmorRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		///
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "NormalDamageRow");
		boxxy.SetParent(defBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(defBoxBase.FindChildTraverse("NormalDamageRow"));
		boxxy.text = "Normal:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(defBoxBase.FindChildTraverse("NormalDamageRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconAttack");
		boxxy.SetParent(defBoxBase.FindChildTraverse("NormalDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(defBoxBase.FindChildTraverse("NormalDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "PiercingDamageRow");
		boxxy.SetParent(defBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(defBoxBase.FindChildTraverse("PiercingDamageRow"));
		boxxy.text = "Piercing:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(defBoxBase.FindChildTraverse("PiercingDamageRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconAttack");
		boxxy.SetParent(defBoxBase.FindChildTraverse("PiercingDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "DamageMaskPiercing");
		boxxy.SetParent(defBoxBase.FindChildTraverse("PiercingDamageRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconAttack"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(defBoxBase.FindChildTraverse("PiercingDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "SiegeDamageRow");
		boxxy.SetParent(defBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(defBoxBase.FindChildTraverse("SiegeDamageRow"));
		boxxy.text = "Siege:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(defBoxBase.FindChildTraverse("SiegeDamageRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconAttack");
		boxxy.SetParent(defBoxBase.FindChildTraverse("SiegeDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "DamageMaskSiege");
		boxxy.SetParent(defBoxBase.FindChildTraverse("SiegeDamageRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconAttack"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(defBoxBase.FindChildTraverse("SiegeDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "MagicDamageRow");
		boxxy.SetParent(defBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(defBoxBase.FindChildTraverse("MagicDamageRow"));
		boxxy.text = "Magic:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(defBoxBase.FindChildTraverse("MagicDamageRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconAttack");
		boxxy.SetParent(defBoxBase.FindChildTraverse("MagicDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "DamageMaskMagic");
		boxxy.SetParent(defBoxBase.FindChildTraverse("MagicDamageRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconAttack"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(defBoxBase.FindChildTraverse("MagicDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "ChaosDamageRow");
		boxxy.SetParent(defBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(defBoxBase.FindChildTraverse("ChaosDamageRow"));
		boxxy.text = "Chaos:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(defBoxBase.FindChildTraverse("ChaosDamageRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconAttack");
		boxxy.SetParent(defBoxBase.FindChildTraverse("ChaosDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "DamageMaskChaos");
		boxxy.SetParent(defBoxBase.FindChildTraverse("ChaosDamageRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconAttack"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(defBoxBase.FindChildTraverse("ChaosDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "HeroDamageRow");
		boxxy.SetParent(defBoxBase);
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabel");
		boxxy.SetParent(defBoxBase.FindChildTraverse("HeroDamageRow"));
		boxxy.text = "Hero:";
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "LeftRightFlow");
		boxxy.SetParent(defBoxBase.FindChildTraverse("HeroDamageRow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "TypeIconAttack");
		boxxy.SetParent(defBoxBase.FindChildTraverse("HeroDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy = $.CreatePanel("Panel", $.GetContextPanel(), "DamageMaskHero");
		boxxy.SetParent(defBoxBase.FindChildTraverse("HeroDamageRow").FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeIconAttack"));
		boxxy = $.CreatePanel("Label", $.GetContextPanel(), "TypeStatLabelRight");
		boxxy.SetParent(defBoxBase.FindChildTraverse("HeroDamageRow").FindChildTraverse("LeftRightFlow"));
		boxxy.text = "100%";
		boxxy.AddClass("TypeLabelNormal");
		
		///
		///
		///
		
		var query = Players.GetQueryUnit(Players.GetLocalPlayer());
		if(query == -1) {
			query = Players.GetLocalPlayerPortraitUnit();
		}
		if (Entities.IsHero(query))
		{
			var pOwner = Entities.GetPlayerOwnerID(query);
			
			var tooltipDamage = Math.round((strBlast+strPlast)* 250/*2.5 * 100*/) / 100
			var tooltipHP = Math.round((strBlast+strPlast)* 4000/*40 * 100*/) / 100
			var tooltipHPR = Math.round((strBlast+strPlast)* 3/*0.03 * 100*/) / 100
			var tooltipArmor = Math.round((agiBlast+agiPlast)* 5/*0.05 * 100*/) / 100
			var tooltipIAS = Math.round((agiBlast+agiPlast)* 100/*1 * 100*/) / 100
			var tooltipMS = Math.round((agiBlast+agiPlast)* 3/*0.03 * 100*/) / 100
			var tooltipMP = Math.round((intBlast+intPlast)* 1600/*16 * 100*/) / 100
			var tooltipMPR = Math.round((intBlast+intPlast)* 5/*0.05 * 100*/) / 100
			
			var tooltipStrGain;
			var tooltipAgiGain;
			var tooltipIntGain;
			
			if (pINs[query] != undefined)
			{
				tooltipStrGain = Math.round(pINs[query].strength_gain * 100)/100;
				tooltipAgiGain = Math.round(pINs[query].agility_gain * 100)/100;
				tooltipIntGain = Math.round(pINs[query].intellect_gain * 100)/100;
			}
			else
			{
				tooltipStrGain = Math.round(pIDs[pOwner].strength_gain * 100)/100;
				tooltipAgiGain = Math.round(pIDs[pOwner].agility_gain * 100)/100;
				tooltipIntGain = Math.round(pIDs[pOwner].intellect_gain * 100)/100;
			}
			if(tooltipStrGain - Math.round(tooltipStrGain) == 0) tooltipStrGain = tooltipStrGain+".0";
			if(tooltipAgiGain - Math.round(tooltipAgiGain) == 0) tooltipAgiGain = tooltipAgiGain+".0";
			if(tooltipIntGain - Math.round(tooltipIntGain) == 0) tooltipIntGain = tooltipIntGain+".0";
			
			strDmgLabel.text = "= "+tooltipDamage+" Damage (Primary Role Bonus)";
			strStatLabel.text = "= "+tooltipHP+" HP and "+tooltipHPR+" HP Regen";
			
			strBaseLabel.text = strBlast;
			if (strPlast > 0)
			{
				if(strPlusLabel.BHasClass("NoBonus")) strPlusLabel.RemoveClass("NoBonus");
				strPlusLabel.text = "+"+strPlast;
			}
			else if(strPlusLabel.BHasClass("NoBonus") == false) strPlusLabel.AddClass("NoBonus");
			strGainLabel.text = "(Gains "+tooltipStrGain+" per lvl)";
			
			agiDmgLabel.text = "= "+tooltipDamage+" Damage (Primary Role Bonus)";
			agiStatLabel.text = "= "+tooltipArmor+" Armor, "+tooltipIAS+" Attack Speed and "+tooltipMS+" Movement Speed";
			
			agiBaseLabel.text = agiBlast;
			if (agiPlast > 0)
			{
				if(agiPlusLabel.BHasClass("NoBonus")) agiPlusLabel.RemoveClass("NoBonus");
				agiPlusLabel.text = "+"+agiPlast;
			}
			else if(agiPlusLabel.BHasClass("NoBonus") == false) agiPlusLabel.AddClass("NoBonus");
			agiGainLabel.text = "(Gains "+tooltipAgiGain+" per lvl)";
			
			intDmgLabel.text = "= "+tooltipDamage+" Damage (Primary Role Bonus)";
			intStatLabel.text = "= "+tooltipMP+" Mana and "+tooltipMPR+" Mana Regen";
			
			intBaseLabel.text = intBlast;
			if (intPlast > 0)
			{
				if(intPlusLabel.BHasClass("NoBonus")) intPlusLabel.RemoveClass("NoBonus");
				intPlusLabel.text = "+"+intPlast;
			}
			else if(intPlusLabel.BHasClass("NoBonus") == false) intPlusLabel.AddClass("NoBonus");
			intGainLabel.text = "(Gains "+tooltipIntGain+" per lvl)";
		}
		
		/*atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelNormal");
		atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelGreen");
		atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelRed");
		atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelBlue");
		atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelPurple");
		atkBoxBase.FindChildTraverse("AttackTypeHeader").RemoveClass("StatLabelYellow");
		
		defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelNormal");
		defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelBlack");
		defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelGreen");
		defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelRed");
		defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelBlue");
		defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelPurple");
		defBoxBase.FindChildTraverse("DefenseTypeHeader").RemoveClass("StatLabelYellow");*/
		
		if(Entities.GetUnitName(query) == "npc_dota_hero_lina"
		|| Entities.GetUnitName(query) == "npc_spellbringer"
		|| Entities.GetUnitName(query) == "npc_starlight_sphere"
		|| Entities.GetUnitName(query) == "npc_dota_spirit_hawk"
		|| Entities.GetUnitName(query) == "npc_dota_spirit_owl"
		|| Entities.GetUnitName(query) == "npc_summon_sidhlot"
		|| Entities.GetUnitName(query) == "npc_summon_arhat"
		|| Entities.GetUnitName(query) == "npc_summon_havroth"
		|| Entities.GetUnitName(query) == "npc_summon_uthmor") atkBoxNo.style.visibility = "visible";
		else atkBoxNo.style.visibility = "collapse";
		if(Entities.GetUnitName(query) == "npc_spellbringer"
		|| Entities.GetUnitName(query) == "npc_summon_sidhlot"
		|| Entities.GetUnitName(query) == "npc_summon_arhat"
		|| Entities.GetUnitName(query) == "npc_summon_havroth"
		|| Entities.GetUnitName(query) == "npc_summon_uthmor") defBoxNo.style.visibility = "visible";
		else defBoxNo.style.visibility = "collapse";
		
		if(dmgtypeLast == "DamageMask")
		{
			//atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "NORMAL";
			//atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelNormal");
			atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/broadsword.png")';
		}
		if(dmgtypeLast == "DamageMaskPiercing")
		{
			atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "PIERCING";
			atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelGreen");
			atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/javelin.png")';
		}
		if(dmgtypeLast == "DamageMaskSiege")
		{
			atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "SIEGE";
			atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelRed");
			atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/mithril_hammer.png")';
		}
		if(dmgtypeLast == "DamageMaskMagic")
		{
			atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "MAGIC";
			atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelBlue");
			atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/magic_wand.png")';
		}
		if(dmgtypeLast == "DamageMaskChaos")
		{
			atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "CHAOS";
			atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelPurple");
			atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/silver_edge.png")';
		}
		if(dmgtypeLast == "DamageMaskHero")
		{
			atkBoxBase.FindChildTraverse("AttackTypeHeader").text = "HERO";
			atkBoxBase.FindChildTraverse("AttackTypeHeader").AddClass("StatLabelYellow");
			atkBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/radiance.png")';
		}
		
		if(armtypeLast == "ArmorMask")
		{
			//defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "NORMAL";
			//defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelNormal");
			defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/chainmail.png")';
		}
		if(armtypeLast == "ArmorMaskNone")
		{
			defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "UNARMORED";
			defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelBlack");
			//defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/belt_of_strength.png")';
		}
		if(armtypeLast == "ArmorMaskLight")
		{
			defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "LIGHT";
			defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelGreen");
			defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/stout_shield.png")';
		}
		if(armtypeLast == "ArmorMaskMedium")
		{
			defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "MEDIUM";
			defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelRed");
			defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/buckler.png")';
		}
		if(armtypeLast == "ArmorMaskHeavy")
		{
			defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "HEAVY";
			defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelBlue");
			defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/shivas_guard.png")';
		}
		if(armtypeLast == "ArmorMaskFortified")
		{
			defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "FORTIFIED";
			defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelPurple");
			defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/blade_mail.png")';
		}
		if(armtypeLast == "ArmorMaskHero")
		{
			defBoxBase.FindChildTraverse("DefenseTypeHeader").text = "HERO";
			defBoxBase.FindChildTraverse("DefenseTypeHeader").AddClass("StatLabelYellow");
			defBoxBase.GetParent().FindChildTraverse("BGBox").style.backgroundImage = 'url("file://{images}/items/solar_crest.png")';
		}
		
		var dNor = 100;
		var dUna = 100;
		if(dmgtypeLast == "DamageMaskPiercing" || dmgtypeLast == "DamageMaskSiege") dUna = 150;
		var dLig = 100;
		if(dmgtypeLast == "DamageMaskPiercing") dLig = 200;
		if(dmgtypeLast == "DamageMaskMagic") dLig = 125;
		var dMed = 100;
		if(dmgtypeLast == "DamageMask") dMed = 125;
		if(dmgtypeLast == "DamageMaskPiercing" || dmgtypeLast == "DamageMaskMagic") dMed = 75;
		if(dmgtypeLast == "DamageMaskSiege") dMed = 50;
		var dHea = 100;
		if(dmgtypeLast == "DamageMaskMagic") dHea = 150;
		var dFor = 100;
		if(dmgtypeLast == "DamageMask") dFor = 80;
		if(dmgtypeLast == "DamageMaskPiercing" || dmgtypeLast == "DamageMaskHero") dFor = 50;
		if(dmgtypeLast == "DamageMaskSiege") dFor = 150;
		if(dmgtypeLast == "DamageMaskMagic") dFor = 40;
		var dHer = 100;
		if(dmgtypeLast == "DamageMaskPiercing" || dmgtypeLast == "DamageMaskSiege" || dmgtypeLast == "DamageMaskMagic") dHer = 50;
		
		var aNor = 100;
		if(armtypeLast == "ArmorMaskMedium") aNor = 125;
		if(armtypeLast == "ArmorMaskFortified") aNor = 80;
		var aPie = 100;
		if(armtypeLast == "ArmorMaskNone") aPie = 150;
		if(armtypeLast == "ArmorMaskLight") aPie = 200;
		if(armtypeLast == "ArmorMaskMedium") aPie = 75;
		if(armtypeLast == "ArmorMaskFortified" || armtypeLast == "ArmorMaskHero") aPie = 50;
		var aSie = 100;
		if(armtypeLast == "ArmorMaskNone" || armtypeLast == "ArmorMaskFortified") aSie = 150;
		if(armtypeLast == "ArmorMaskMedium" || armtypeLast == "ArmorMaskHero") aSie = 50;
		var aMag = 100;
		if(armtypeLast == "ArmorMaskLight") aMag = 125;
		if(armtypeLast == "ArmorMaskMedium") aMag = 75;
		if(armtypeLast == "ArmorMaskHeavy") aMag = 150;
		if(armtypeLast == "ArmorMaskFortified") aMag = 40;
		if(armtypeLast == "ArmorMaskHero") aMag = 50;
		var aCha = 100;
		var aHer = 100;
		if(armtypeLast == "ArmorMaskFortified") aHer = 50;
		
		DetermineDamageNumbers("attack", "NormalArmorRow", dNor);
		DetermineDamageNumbers("attack", "UnarmoredRow", dUna);
		DetermineDamageNumbers("attack", "LightArmorRow", dLig);
		DetermineDamageNumbers("attack", "MediumArmorRow", dMed);
		DetermineDamageNumbers("attack", "HeavyArmorRow", dHea);
		DetermineDamageNumbers("attack", "FortifiedArmorRow", dFor);
		DetermineDamageNumbers("attack", "HeroArmorRow", dHer);
		
		DetermineDamageNumbers("defense", "NormalDamageRow", aNor);
		DetermineDamageNumbers("defense", "PiercingDamageRow", aPie);
		DetermineDamageNumbers("defense", "SiegeDamageRow", aSie);
		DetermineDamageNumbers("defense", "MagicDamageRow", aMag);
		DetermineDamageNumbers("defense", "ChaosDamageRow", aCha);
		DetermineDamageNumbers("defense", "HeroDamageRow", aHer);
	}
	else
	{
		//$.Msg("No...");
		$.Schedule(0.1,function() {WaitForToolTipBox();});
	}
}

function DetermineDamageNumbers(base, type, number)
{
	var temp;
	var lowlabel;
	var highlabel;
	if (base == "attack")
	{
		temp = atkBoxBase.FindChildTraverse(type).FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeStatLabelRight");
		lowlabel = "TypeLabelBad";
		highlabel = "TypeLabelGood"
	}
	if (base == "defense")
	{
		temp = defBoxBase.FindChildTraverse(type).FindChildTraverse("LeftRightFlow").FindChildTraverse("TypeStatLabelRight");
		lowlabel = "TypeLabelGood";
		highlabel = "TypeLabelBad"
	}
	temp.RemoveClass("TypeLabelBad");
	temp.RemoveClass("TypeLabelGood");
	temp.RemoveClass("TypeLabelNormal");
	if(number < 100) temp.AddClass(lowlabel);
	if(number > 100) temp.AddClass(highlabel);
	if(number == 100) temp.AddClass("TypeLabelNormal");
	temp.text = number+"%";
	//$.Msg(type);
	//$.Msg(number);
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
	//intDmgLabel.text = "wipe my ass";
	//var heroData = CustomNetTables.GetTableValue("hero_data","stats");
	//$.Msg(heroData);
	//SkrrtSkrrt(); // initial update
	//$.Schedule(1,function() {Bah();});
	WaitForToolTipBox();
})();
