enfos_attribute_bonus = class({})


function enfos_attribute_bonus:GetIntrinsicModifierName()
	return "lua_attribute_bonus_modifier"
end

attribute_table = {
	0,
	2,
	3,
	5,
	6,
	8,
	11,
	13,
	16,
	18,
	21,
	25,
	28,
	32,
	35,
	39,
	44,
	48,
	53,
	57,
	62,
	68,
	73,
	79,
	84,
	90,
	97,
	103,
	110,
	116,
	123,
	131,
	138,
	146,
	153,
	161,
	170,
	178,
	187,
	195,
	204,
	214,
	223,
	233,
	242,
	252,
	263,
	273,
	284,
	294,
	305,
	317,
	328,
	340,
	351,
	363,
	376,
	388,
	401,
	413,
	426,
	440,
	453,
	467,
	480,
	494,
	509,
	523,
	538,
	552,
	567,
	583,
	598,
	614,
	629,
	645,
	662,
	678,
	695,
	711,
	728,
	746,
	763,
	781,
	798,
	816,
	835,
	853,
	872,
	890,
	909,
	929,
	948,
	968,
	987,
	1007,
	1028,
	1048,
	1069,
	1089,
	1110
}

function enfos_attribute_bonus:OnUpgrade()
	local nLevel = self:GetLevel()+1
	local caster = self:GetCaster()
	local cLevel = caster.attribute_level+1
	--print(nLevel)
	--print(cLevel)
	
	caster.strength_bonus = caster.strength_bonus + (attribute_table[nLevel] - attribute_table[cLevel])
	caster.agility_bonus = caster.agility_bonus + (attribute_table[nLevel] - attribute_table[cLevel])
	caster.intellect_bonus = caster.intellect_bonus + (attribute_table[nLevel] - attribute_table[cLevel])
	
	caster.attribute_level = nLevel-1
	
	--stat update
	local heroNetTable = {}
	heroNetTable[caster:GetPlayerID()] = {
		strbn = caster.strength_bonus,
		agibn = caster.agility_bonus,
		intbn = caster.intellect_bonus}
	CustomNetTables:SetTableValue("hero_data_live","stats",heroNetTable)
end