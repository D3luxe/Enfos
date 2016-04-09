lua_attribute_bonus_modifier = class({})

attribute_table = {
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

function lua_attribute_bonus_modifier:DeclareFunctions()
	local funcs = {
MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function lua_attribute_bonus_modifier:OnCreated()
	if IsServer() then
		self.Primary = self:GetParent():GetPrimaryAttribute() 
	end
end


function lua_attribute_bonus_modifier:IsHidden()
	return true
end

function lua_attribute_bonus_modifier:GetAttributes() 
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function lua_attribute_bonus_modifier:GetModifierBonusStats_Strength()
	return self:GetModifierBonusStats_All(0, self:GetParent():GetStrengthGain())
end
function lua_attribute_bonus_modifier:GetModifierBonusStats_Agility()
	return self:GetModifierBonusStats_All(1, self:GetParent():GetAgilityGain())
end
function lua_attribute_bonus_modifier:GetModifierBonusStats_Intellect()
	return self:GetModifierBonusStats_All(2, self:GetParent():GetIntellectGain())
end

function lua_attribute_bonus_modifier:GetModifierBonusStats_All(nType, nBonus)
	local hAbility = self:GetAbility()
	local nLevel = hAbility:GetLevel()
	--
	return (attribute_table[nLevel])
end