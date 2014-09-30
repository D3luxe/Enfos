function cataclysmic_strike(keys)
	local caster = keys.caster
	local level = caster:FindAbilityByName("ahlen_cataclysmic_strike"):GetLevel()
	local spell = caster:FindAbilityByName("ahlen_cataclysmic_strike_proxy")
-- logic
	spell:SetLevel(level)
	spell:SetHidden(false)
	spell:OnSpellStart()
	spell:SetHidden(true)
end