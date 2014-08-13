-- A helper function for dealing damage from a source unit to a target unit.  Damage dealt is pure damage
function dealDamage(source, target, damage)
    if damage <= 0 or source == nil or target == nil then
      return
    end
    -- target:AddNewModifier(source, nil, "modifier_invoker_tornado", {land_damage = damage, duration = 0} )
    local dmgTable = {4096,2048,1024,512,256,128,64,32,16,8,4,2,1}
    local item = CreateItem( "item_deal_damage", source, source) --creates an item
    if item == nil then
      print("ITEM IS NIL ERROR")
      return
    end
    for i=1,#dmgTable do
      local val = dmgTable[i]
      local count = math.floor(damage / val)
      if count >= 1 then
          item:ApplyDataDrivenModifier( source, target, "dealDamage" .. val, {duration=0} )
          damage = damage - val
      end
    end
    UTIL_RemoveImmediate(item)
    item = nil
    --print("removed")
end