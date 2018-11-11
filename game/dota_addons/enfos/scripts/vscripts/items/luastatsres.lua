if modifier_magical_resistance_bonus == nil then
    modifier_magical_resistance_bonus = class({})
end

function modifier_magical_resistance_bonus:IsHidden() 
	return true 
end

function modifier_magical_resistance_bonus:IsPurgable() 
	return false 
end


function modifier_magical_resistance_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_magical_resistance_bonus:OnCreated( kv )
	--self.resist = self:GetAbility():GetSpecialValueFor( "resist" )
	if IsServer() then self:SetStackCount(1) end
end

function modifier_magical_resistance_bonus:GetModifierMagicalResistanceBonus( params )
	return self:GetStackCount() * 0.01--self.resist
end