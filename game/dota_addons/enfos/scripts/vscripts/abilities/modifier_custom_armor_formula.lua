modifier_custom_armor_formula = class({})

function modifier_custom_armor_formula:IsPurgable()
	return false
end

function modifier_custom_armor_formula:IsHidden()
	return true
end

function modifier_custom_armor_formula:RemoveOnDeath()
	return false
end

function modifier_custom_armor_formula:IsPermanent()
	return true
end

function modifier_custom_armor_formula:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
	}
end

if IsServer() then
	function modifier_custom_armor_formula:GetModifierPhysicalArmorBonus()
		if (self.checkArmor) then
			return 0
		else
			self.checkArmor = true
			local armor = self:GetParent():GetPhysicalArmorValue(false)
			self.checkArmor = false
			--print("armbh "..armor * -1)
			return armor * -1;
		end
	end
	
	function modifier_custom_armor_formula:GetModifierIncomingPhysicalDamage_Percentage()
		self.checkArmor = true
		local armor = self:GetParent():GetPhysicalArmorValue(false)
		self.checkArmor = false
		local physicalResistance = (0.06*armor)/(1+0.06*armor)*100*-1
		if armor < 0 then physicalResistance = ((2-(0.94^math.abs(math.max(armor,-20))))*100)-100 end
		print("phys resist babey!!! "..physicalResistance)
		return physicalResistance
	end
end