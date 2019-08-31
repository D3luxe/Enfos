if modifier_spell_amplify_percentage == nil then
    modifier_spell_amplify_percentage = class({})
end

function modifier_spell_amplify_percentage:IsHidden() 
	return true 
end

function modifier_spell_amplify_percentage:IsPurgable() 
	return false 
end


function modifier_spell_amplify_percentage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_spell_amplify_percentage:OnCreated( kv )
	--self.resist = self:GetAbility():GetSpecialValueFor( "amplify" )
	if IsServer() then self:SetStackCount(1) end
end

function modifier_spell_amplify_percentage:GetModifierSpellAmplify_Percentage( params )
	return self:GetStackCount() * 0.01--self.amplify
end