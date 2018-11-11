if item_stat_modifier_lua == nil then
    item_stat_modifier_lua = class({})
end

LinkLuaModifier( "modifier_magical_resistance_bonus", "items/luastatsres.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spell_amplify_percentage", "items/luastatsamp.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_movespeed_cap", "items/luastatsmov.lua", LUA_MODIFIER_MOTION_NONE)

function item_stat_modifier_lua:GetBehavior()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end