modifier_sniper_ms_limit_lua = class ({})

function modifier_sniper_ms_limit_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_sniper_ms_limit_lua:IsHidden(params)
	return true
end

function modifier_sniper_ms_limit_lua:GetModifierMoveSpeed_Max(params)
	return 350
end

function modifier_sniper_ms_limit_lua:GetModifierMoveSpeed_Limit(params)
	return 350
end