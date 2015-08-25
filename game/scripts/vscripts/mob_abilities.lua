function permenant_invisibility(keys)
	local unit = keys.caster

	--local invis = CreateItem("item_modifier_master", nil, nil) 
	--invis:ApplyDataDrivenModifier(unit, unit, "modifier_invisible", {subtle = 3, cancelattack = 0, fadetime = 1})

	unit:AddNewModifier(unit, nil, "modifier_invisible", {fadetime = 0})

end