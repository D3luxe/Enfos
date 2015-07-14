--[[
Enfos

	Underscore prefix such as "_function()" denotes a local function and is used to improve readability
	
	Variable Prefix Examples
		"fl"	Float
		"n"		Int
		"v"		Table
		"b"		Boolean
]]
require( "Enfos_game_round" )
require( "Enfos_game_spawner" )
require( "util")
require( "enfos")
require( "base_trigger")
require( 'spell_shop_UI' )
-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')

MAX_LEVEL = 125
XP_PER_LEVEL_TABLE = {}
XP_PER_LEVEL_TABLE[0] = 0
radiantXP = 0
direXP = 0
for i=1,MAX_LEVEL do
  XP_PER_LEVEL_TABLE[i] = i * 100 + XP_PER_LEVEL_TABLE[i-1] + 100
end

RADIANT_TEAM_MEMBERS = {}
DIRE_TEAM_MEMBERS = {}

-- Stage constants
local STAGE_WAITING = 0
local STAGE_VOTING = 1
local STAGE_BANNING = 2
local STAGE_PICKING = 3
local STAGE_PLAYING = 4

armorTable = {
				{	["armorType"]="modifier_armor_unarmored",
					["modifier_attack_normal"]="1",
					["modifier_attack_pierce"]="1.5",
					["modifier_attack_siege"]="1",
					["modifier_attack_chaos"]="1",
					["modifier_attack_hero"]="1",
					["modifier_attack_magical"]="1",
				},
				{	["armorType"]="modifier_armor_light",
					["modifier_attack_normal"]="1",
					["modifier_attack_pierce"]="2",
					["modifier_attack_siege"]="1",
					["modifier_attack_chaos"]="1",
					["modifier_attack_hero"]="1",
					["modifier_attack_magical"]="1",
				},
				{	["armorType"]="modifier_armor_medium",
					["modifier_attack_normal"]="1.5",
					["modifier_attack_pierce"]="0.75",
					["modifier_attack_siege"]="0.50",
					["modifier_attack_chaos"]="1",
					["modifier_attack_hero"]="1",
					["modifier_attack_magical"]="1",
				},
				{	["armorType"]="modifier_armor_heavy",
					["modifier_attack_normal"]="1.25",
					["modifier_attack_pierce"]="0.75",
					["modifier_attack_siege"]="1.25",
					["modifier_attack_chaos"]="1",
					["modifier_attack_hero"]="1",
					["modifier_attack_magical"]="1",
				},
				{	["armorType"]="modifier_armor_fortified",
					["modifier_attack_normal"]="0.70",
					["modifier_attack_pierce"]="0.35",
					["modifier_attack_siege"]="1.50",
					["modifier_attack_chaos"]="0.40",
					["modifier_attack_hero"]="0.50",
					["modifier_attack_magical"]="1",
				},
				{	["armorType"]="modifier_armor_hero",
					["modifier_attack_normal"]="0.75",
					["modifier_attack_pierce"]="0.50",
					["modifier_attack_siege"]="0.75",
					["modifier_attack_chaos"]="1",
					["modifier_attack_hero"]="1",
					["modifier_attack_magical"]="0.75",
				},

}
playerColors = {
}
expTable = {
				{ 	["name"]="npc_dota_creature_crab",
					["exp"]="25",
				},
				{ 	["name"]="npc_dota_creature_kobold_tunneler",
					["exp"]="25",
				},
				{ 	["name"]="npc_dota_creature_gnoll_assassin",
					["exp"]="25",
				},
				{ 	["name"]="npc_dota_creep_crazed_spearman",
					["exp"]="40",
				},
				{ 	["name"]="npc_dota_creep_crazed_madmen",
					["exp"]="40",
				},
				{ 	["name"]="npc_dota_creature_boar",
					["exp"]="40",
				},
				{ 	["name"]="npc_dota_creature_wood_troll",
					["exp"]="60",
				},
				{ 	["name"]="npc_dota_creature_wood_troll_rock_tosser",
					["exp"]="60",
				},
				{ 	["name"]="npc_dota_neutral_satyr_reaver",
					["exp"]="60",
				},
				{ 	["name"]="npc_dota_blood_wolf",
					["exp"]="85",
				},
				{ 	["name"]="npc_dota_giant_spider",
					["exp"]="85",
				},
				{ 	["name"]="npc_dota_giant_poison_spider",
					["exp"]="85",
				},
				{ 	["name"]="npc_dota_rock_troll",
					["exp"]="115",
				},
				{ 	["name"]="npc_dota_brown_bear",
					["exp"]="115",
				},
				{ 	["name"]="npc_dota_dark_fiend",
					["exp"]="150",
				},
				{ 	["name"]="npc_dota_snowbeast",
					["exp"]="150",
				},
				{ 	["name"]="npc_dota_lesser_sluagh",
					["exp"]="190",
				},
				{ 	["name"]="npc_dota_arbelog",
					["exp"]="190",
				},
				{ 	["name"]="npc_dota_moss_mey",
					["exp"]="235",
				},
				{ 	["name"]="npc_dota_swamp_troll",
					["exp"]="235",
				},
				{ 	["name"]="npc_dota_young_ogre",
					["exp"]="285",
				},
				{ 	["name"]="npc_dota_mottled_westanuryn",
					["exp"]="285",
				},
				{ 	["name"]="npc_dota_small_peccary",
					["exp"]="340",
				},
				{ 	["name"]="npc_dota_spirit_hawk",
					["exp"]="690",
				},
				{ 	["name"]="npc_dota_giant_thicket_viper",
					["exp"]="340",
				},
				{ 	["name"]="npc_dota_yvhh_latami",
					["exp"]="400",
				},
				{ 	["name"]="npc_dota_giant_black_leucro",
					["exp"]="400",
				},
				{ 	["name"]="npc_dota_fendryad",
					["exp"]="465",
				},
				{ 	["name"]="npc_dota_death_spirit",
					["exp"]="465",
				},
				{ 	["name"]="npc_dota_rock_guardian",
					["exp"]="535",
				},
				{ 	["name"]="npc_dota_pirate",
					["exp"]="535",
				},
				{ 	["name"]="npc_dota_skeletal_sailor",
					["exp"]="610",
				},
				{ 	["name"]="npc_dota_giant_sea_turtle",
					["exp"]="610",
				},
				{ 	["name"]="npc_dota_blood_warrior",
					["exp"]="690",
				},
				{ 	["name"]="npc_dota_zombie_nomad",
					["exp"]="690",
				},
				{ 	["name"]="npc_dota_shadow_mage",
					["exp"]="775",
				},
				{ 	["name"]="npc_dota_hunter",
					["exp"]="775",
				},
				{ 	["name"]="npc_dota_krahei",
					["exp"]="865",
				},
				{ 	["name"]="npc_dota_polohizh",
					["exp"]="865",
				},
				{ 	["name"]="npc_dota_spirit_owl",
					["exp"]="1165",
				},
				{ 	["name"]="npc_dota_misshapen",
					["exp"]="960",
				},
				{ 	["name"]="npc_dota_armored_warklin",
					["exp"]="960",
				},
				{ 	["name"]="npc_dota_warklin_mauler",
					["exp"]="1060",
				},
				{ 	["name"]="npc_dota_ssugi_malchata",
					["exp"]="1060",
				},
				{ 	["name"]="npc_dota_snaer_hafwa",
					["exp"]="1165",
				},
				{ 	["name"]="npc_dota_slai_screamer",
					["exp"]="2490",
				}
}
heroTable = {
				{	["name"]="npc_dota_hero_naga_siren",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_juggernaut",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_unarmored",
				},
				{	["name"]="npc_dota_hero_beastmaster",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_skywrath_mage",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_ursa",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_shadow_shaman",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_dragon_knight",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_fortified",
				},
				{	["name"]="npc_dota_hero_bounty_hunter",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_phantom_assassin",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_fortified",
				},
				{	["name"]="npc_dota_hero_silencer",
					["attackType"]="modifier_attack_normal",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_storm_spirit",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_luna",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_dazzle",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_unarmored",
				},
				{	["name"]="npc_dota_hero_omniknight",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_lich",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_sniper",
					["attackType"]="modifier_attack_pierce",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_treant",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_antimage",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_light",
				},
				{	["name"]="npc_dota_hero_earth_spirit",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_spirit_breaker",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_crystal_maiden",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_sven",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_light",
				},
				{	["name"]="npc_dota_hero_sven",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_lina",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_unarmored",
				},
				{	["name"]="npc_dota_hero_terrorblade",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_ember_spirit",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_troll_warlord",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_witch_doctor",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},				
				{	["name"]="npc_dota_hero_medusa",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_unarmored",
				}
		}	

uniqueItems = { "item_nimsha",
				"item_bloodthirst",
				"item_small_round_shield",
				"item_elite_elven_boots",
				"item_thirsting_blade",
				"item_uthmors_mirror_blade",
				"item_ring_of_victory",
				"item_scepter_of_the_magi",
				"item_tower_shield",
			}
artifactItems = { "item_stone_axe",
				"item_iron_helmet",
				"item_elven_plate_mail",
			}


if CEnfosGameMode == nil then
	CEnfosGameMode = class({})
	CEnfosGameMode.__index = CEnfosGameMode
end

-- Stat collection
require('lib.statcollection')
statcollection.addStats({
	modID = '70a4cb33084fbba671a53c58706f4017' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
})

-- Precache resources
function Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
	PrecacheResource( "model", "models/heroes/lone_druid/spirit_bear.vmdl", context )
	PrecacheResource( "model", "models/props_gameplay/recipe.mdl", context )
	PrecacheResource( "model", "models/props_structures/tower_good4.vmdl", context )
	PrecacheResource( "model", "models/props_debris/merchant_debris_book001.vmdl", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/necronomicon_archer_manaburn.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", context )
	PrecacheResource( "particle", "particles/hero_moon_mage/jakiro_liquid_fire_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/aura_assault.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_viper/viper_base_attack.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/ti4/teleport_end_ground_flash_ti4.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/tranquil_boots_healing.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_stunned.vpcf", context )
	PrecacheResource("particle","particles/units/heroes/hero_lion/lion_spell_mana_drain.vpcf", context )
	PrecacheResource("particle","particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge_impact.vpcf", context )
	PrecacheResource("particle","particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
	
	

	--Arhat
	PrecacheResource( "model", "models/heroes/invoker/invoker.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_cape.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_shoulder.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_head.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_hair.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_bracer.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_dress.vmdl", context )


	--Uthmor
	PrecacheResource( "model", "models/heroes/elder_titan/ancestral_spirit.vmdl", context )

	--Sidhlot
	PrecacheResource( "model", "models/heroes/necrolyte/necrolyte_sickle.vmdl", context )
	PrecacheResource( "model", "models/heroes/necrolyte/beard.vmdl", context )
	PrecacheResource( "model", "models/heroes/necrolyte/hat.vmdl", context )
	PrecacheResource( "model", "models/heroes/necrolyte/shoulders.vmdl", context )
	PrecacheResource( "model", "models/heroes/necrolyte/necrolyte.vmdl", context )
	PrecacheItemByNameSync("item_spellbringer_greater_darkrift", context)

	PrecacheUnitByNameSync("npc_dota_hero_omniknight", context)

	--PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", context )
end

-- Actually make the game mode when we activate
function Activate()
	GameRules.Enfos = CEnfosGameMode()
	GameRules.Enfos:InitGameMode()

end


function CEnfosGameMode:InitGameMode()
	SpellShopUI:InitGameMode();
	STARTING_GOLD = 25
	curRound = 0
	self._nRoundNumber = 1
	self._iGoodSpawnPoint = 1
	self._iBadSpawnPoint = 1
	goodLives = 100
	badLives = 100
	self._currentRound = nil
	self._flLastThinkGameTime = nil
	self._entAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	if not self._entAncient then
		print( "Ancient entity not found!" )
	end

	self:_ReadGameConfiguration()
	GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetHeroRespawnEnabled( true )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( CEnfosGameMode, "FilterExecuteOrder" ), self )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( CEnfosGameMode, "FilterDamage" ), self )
	GameRules:SetUseUniversalShopMode( false )
	GameRules:SetHeroSelectionTime( 60.0 )
	GameRules:SetPreGameTime( 45.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	--GameRules:SetHeroMinimapIconSize( 400 )
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1400 )		--1134 default dota 2
	GameRules:SetCreepMinimapIconScale( 0.7 )
	GameRules:SetRuneMinimapIconScale( 0.7 )
	GameRules:SetGoldTickTime( 60.0 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, 100)
	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, 100)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled( true )
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( MAX_LEVEL )
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
	GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)


	-- Custom console commands
	Convars:RegisterCommand( "Enfos_test_round", function(...) return self:_TestRoundConsoleCommand( ... ) end, "Test a round of Enfos.", FCVAR_CHEAT )
	--Convars:RegisterCommand( "Enfos_status_report", function(...) return self:_StatusReportConsoleCommand( ... ) end, "Report the status of the current Enfos game.", FCVAR_CHEAT )
	--Convars:RegisterCommand( "Enfos_reset_lives", function(...) return self:_ResetLivesConsoleCommand( ... ) end, "Reset the lives in the game", FCVAR_CHEAT )
	-- Set all towers invulnerable
	for _, tower in pairs( Entities:FindAllByName( "npc_dota_Enfos_tower_spawn_protection" ) ) do
		tower:AddNewModifier( tower, nil, "modifier_invulnerable", {} )
	end

	-- Hook into game events allowing reload of functions at run time
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CEnfosGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( CEnfosGameMode, "OnPlayerPicked" ), self )
	ListenToGameEvent( "player_reconnected", Dynamic_Wrap( CEnfosGameMode, 'OnPlayerReconnected' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CEnfosGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CEnfosGameMode, "OnGameRulesStateChange" ), self )
	ListenToGameEvent( "player_stats_updated", Dynamic_Wrap(CEnfosGameMode, 'OnPlayerStatsUpdated'), self)
	ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap(CEnfosGameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap(CEnfosGameMode, 'OnPlayerLevelledUp'), self)
	ListenToGameEvent( "dota_inventory_item_added", Dynamic_Wrap(CEnfosGameMode, 'OnInventoryChanged'), self)
	ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap(CEnfosGameMode, 'OnItemPurchased'), self)
	ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap(CEnfosGameMode, 'OnAbilityCast'), self)
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap(CEnfosGameMode, 'OnItemPickedUp'), self)
	ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(CEnfosGameMode, "OnPlayerCastAbility"), self)
	ListenToGameEvent("dota_item_gifted", Dynamic_Wrap(CEnfosGameMode, "OnItemGifted"), self)
	--ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CEnfosGameMode, "OnEntityHurt" ), self )

	CustomGameEventManager:RegisterListener( "get_player_color", GetPlayerColor )

	-- Register OnThink with the game engine so it is called every 0.25 seconds
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )
	-- defining our global tables here. we need to populate them with initial player values or else we won't be able to index them.

	--Catch the Spellbringer UI
	--register the 'BuyAbilityPoint' command in our console
	Convars:RegisterCommand( "CastSpellbringerAbility", function(name, p)
	    --get the player that sent the command
	    local cmdPlayer = Convars:GetCommandClient()
	    if cmdPlayer then 
	        --if the player is valid, execute PlayerBuyAbilityPoint
	        return self:CastSpellbringerAbility( cmdPlayer, p ) 
	    end
	end, "A player casted an ability", 0 )
	
	self._idmap = {}
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_items_custom.txt")) do
		local id = v.ID
	  if id then
		id = tonumber(id) -- don't get owned by type differences in the KV vs filter table
		v.Ability = k -- need to stash this in the table so you can actually get it
		self._idmap[id] = v
	  end
	end
end

function GetPlayerColor(eventSourceIndex, args)
	--PrintTable(args)
	--print( "My event: ( " .. eventSourceIndex .. " )" )
	table.insert( playerColors, {
			playerID = args['PlayerID'],
			r = args['key1'] or "255",
			g = args['key2'] or "255",
			b = args['key3'] or "255",
		} ) 
	--PrintTable(playerColors)
end

function CEnfosGameMode:OnPlayerCastAbility(keys)
	--print("Ability cast")
	--PrintTable(keys)
	local player_id = keys.PlayerID
	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end
	local hero = player:GetAssignedHero()
	if hero then
		local hero_name = hero:GetUnitName()
		local ability_name = keys.abilityname
		--print(hero_name)
		if hero_name == "npc_dota_hero_troll_warlord" then
		--print("Troll casted an ability")
			if ability_name ~= "troll_cannibal_scalping_cry" and ability_name ~= "troll_cannibal_bloodboil" and ability_name ~= "troll_cannibal_soul_drain" and ability_name ~= "item_winged_leather_boots" and cannibalIndex ~= nil then
				--print("Troll casted an ult")
				Timers:CreateTimer(DoUniqueString("removeSoulFeastUlt"), {
					endTime = 0.1,
					callback = function()
						hero:RemoveModifierByName("modifier_soul_feast_passive_timer")
					end
				})
				
			end
		end
		if self[hero_name] and self[hero_name].abilityname then
			self[hero_name]:AbilityHandler(keys)
			print(self[hero_name])
		end
	end
end

function CEnfosGameMode:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

--Spellbringer casting from UI
function CEnfosGameMode:CastSpellbringerAbility(player, p)
	local price = 200
	local pID = player:GetPlayerID()
	local playerGold = PlayerResource:GetGold(pID)
	local playerHero = player:GetAssignedHero()

	local abilityToCast = playerHero:FindAbilityByName("evoker_gar_zeng_proxy")

	playerHero:CastAbilityNoTarget(abilityToCast, -1)
end

-- Read and assign configurable keyvalues if applicable
function CEnfosGameMode:_ReadGameConfiguration()
	local kv = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	kv = kv or {} -- Handle the case where there is not keyvalues file

	self._bAlwaysShowPlayerGold = kv.AlwaysShowPlayerGold or false
	self._bRestoreHPAfterRound = kv.RestoreHPAfterRound or false
	self._bRestoreMPAfterRound = kv.RestoreMPAfterRound or false
	self._bRewardForTowersStanding = kv.RewardForTowersStanding or false
	self._bUseReactiveDifficulty = kv.UseReactiveDifficulty or false

	self._nTowerRewardAmount = tonumber( kv.TowerRewardAmount or 0 )
	self._nTowerScalingRewardPerRound = tonumber( kv.TowerScalingRewardPerRound or 0 )

	self._flPrepTimeBetweenRounds = tonumber( kv.PrepTimeBetweenRounds or 0 )

	--self:_ReadRandomSpawnsConfiguration( kv["RandomSpawns"] )
	
	self:_ReadRadiantSpawnsConfiguration( kv["RadiantSpawns"] )
	
	self:_ReadDireSpawnsConfiguration( kv["DireSpawns"] )
	--self:_ReadLootItemDropsConfiguration( kv["ItemDrops"] )
	self:_ReadRoundConfigurations( kv )
end

-- Verify spawners if random is set
function CEnfosGameMode:ChooseRadiantSpawnInfo()
	if #self._vRadiantSpawnsList == 0 then
		error( "Attempt to choose a radiant spawn, but no radiant spawns are specified in the data." )
		return nil
	end
	self._iGoodSpawnPoint = self._iGoodSpawnPoint + 1
	if self._iGoodSpawnPoint > #self._vRadiantSpawnsList then
		self._iGoodSpawnPoint = 1
	end
	return self._vRadiantSpawnsList[self._iGoodSpawnPoint]
end

-- Verify spawners if random is set
function CEnfosGameMode:ChooseDireSpawnInfo()
	if #self._vDireSpawnsList == 0 then
		error( "Attempt to choose a dire spawn, but no dire spawns are specified in the data." )
		return nil
	end
	self._iBadSpawnPoint = self._iBadSpawnPoint + 1
	if self._iBadSpawnPoint > #self._vDireSpawnsList then
		self._iBadSpawnPoint = 1
	end
	return self._vDireSpawnsList[self._iBadSpawnPoint]
end


-- Verify valid spawns are defined and build a table with them from the keyvalues file
function CEnfosGameMode:_ReadRadiantSpawnsConfiguration( kvSpawns )
	self._vRadiantSpawnsList = {}
	if type( kvSpawns ) ~= "table" then
		return
	end
	for _,sp in pairs( kvSpawns ) do			-- Note "_" used as a shortcut to create a temporary throwaway variable
		table.insert( self._vRadiantSpawnsList, {
			szRadiantSpawnerName = sp.SpawnerName or "",
			szRadiantFirstWaypoint = sp.Waypoint or ""
		} )
	end
end

-- Verify valid spawns are defined and build a table with them from the keyvalues file
function CEnfosGameMode:_ReadDireSpawnsConfiguration( kvSpawns )
	self._vDireSpawnsList = {}
	if type( kvSpawns ) ~= "table" then
		return
	end
	for _,sp in pairs( kvSpawns ) do			-- Note "_" used as a shortcut to create a temporary throwaway variable
		table.insert( self._vDireSpawnsList, {
			szDireSpawnerName = sp.SpawnerName or "",
			szDireFirstWaypoint = sp.Waypoint or ""
		} )
	end
end

-- Set number of rounds without requiring index in text file
function CEnfosGameMode:_ReadRoundConfigurations( kv )
	self._vRounds = {}
	while true do
		local szRoundName = string.format("Round%d", #self._vRounds + 1 )
		local kvRoundData = kv[ szRoundName ]
		if kvRoundData == nil then
			return
		end
		local roundObj = CEnfosGameRound()
		roundObj:ReadConfiguration( kvRoundData, self, #self._vRounds + 1 )
		table.insert( self._vRounds, roundObj )
	end
end


-- When game state changes set state in script
function CEnfosGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		--ShowGenericPopup( "#Enfos_instructions_title", "#Enfos_instructions_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
		
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--self:_RespawnPlayers()
		self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds

		for player_id = 0, 9 do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id) 
			if hero ~= nil then
				
				local nTeam = hero:GetTeamNumber()
				local tower = hero.spellbringer:GetAbsOrigin()
				MinimapEvent( nTeam, hero, tower.x, tower.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5 )

				
			end
		end

		 Notifications:TopToAll({text="Remember to use your spellbringers!", duration=5.0})
		
	end
end


-- Evaluate the state of the game
function CEnfosGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:_CheckForDefeat()

		if self._flPrepTimeEnd ~= nil then
			self:_ThinkPrepTime()
		elseif self._currentRound ~= nil then
			self._currentRound:Think()
			if self._currentRound:IsFinished() then
				self._currentRound:End()
				self._currentRound = nil
				-- Heal all players
				-- self:_RefreshPlayers()

				self._nRoundNumber = self._nRoundNumber + 1
				if self._nRoundNumber > #self._vRounds then
					self._nRoundNumber = #self._vRounds
					self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
				else
					self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
				end
			end
	
			
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		statcollection.sendStats()
		return
	end
	for player_id = 0, 9 do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id) 
		if hero ~= nil then
			
			for item_slot = 0, 5 do

				local item = hero:GetItemInSlot(item_slot)
				if item ~= nil then
					item:SetPurchaser(hero) 
				end

			end
			
		end
	end
	self:_SetSpellbringerColors()


	return 1
end


function CEnfosGameMode:_RefreshPlayers()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if not hero:IsAlive() then
					hero:RespawnUnit()
				end
				hero:SetHealth( hero:GetMaxHealth() )
				hero:SetMana( hero:GetMaxMana() )
			end
		end
	end
end

function CEnfosGameMode:_RespawnPlayers()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
			hero:RespawnUnit()
		end
	end
end


function CEnfosGameMode:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end
	if goodLives <= 0 then
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
	end
	if badLives <= 0 then
		GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
	end
end


function CEnfosGameMode:_ThinkPrepTime()
	if GameRules:GetGameTime() >= self._flPrepTimeEnd then
		self._flPrepTimeEnd = nil
		if self._entPrepTimeQuest then
			UTIL_RemoveImmediate( self._entPrepTimeQuest )
			self._entPrepTimeQuest = nil
		end

		if self._nRoundNumber > #self._vRounds then
			self.nRoundNumber = #self._vRounds
			-- return false
		end
		self._currentRound = self._vRounds[ self._nRoundNumber ]
		self._currentRound:Begin()
			curRound = curRound + 1
			Enfos.curRound = curRound
			local goldAmount = curRound * 25
			for nPlayerID = 0, 9 do
				if ( PlayerResource:IsValidPlayer( nPlayerID ) ) then
					local player = PlayerResource:GetPlayer(nPlayerID)
					if player ~= nil then
						playerGold = PlayerResource:GetGold(nPlayerID)
						if playerGold ~= nil then
							PlayerResource:SetGold(nPlayerID,playerGold+goldAmount, false)
						end
					end
				end
			end
			if curRound == 6 or curRound == 27 then
				GameRules:SendCustomMessage("This wave has invisible monsters -", 0, 0)
				GameRules:SendCustomMessage("Make sure you buy <font color='#58ACFA'>Sentry Wards</font>!!", 0, 0)
			end

			if curRound == 20 or curRound == 36 then
				GameRules:SendCustomMessage("<font color='#58ACFA'>Bonus Wave!!</font>", 0, 0)
				GameRules:SendCustomMessage("Successfully killing a mob grants a bonus life", 0, 0)
			end
		return
	end

	if not self._entPrepTimeQuest then
		self._entPrepTimeQuest = SpawnEntityFromTableSynchronous( "quest", { name = "PrepTime", title = "#DOTA_Quest_Enfos_PrepTime" } )
		self._entPrepTimeQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_ROUND, self._nRoundNumber )
		self._entPrepTimeQuest:SetTextReplaceString( self:GetDifficultyString() )

		self._vRounds[ self._nRoundNumber ]:Precache()
	end
	self._entPrepTimeQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self._flPrepTimeEnd - GameRules:GetGameTime() )
end

function CEnfosGameMode:GetDifficultyString()
	local nDifficulty = GameRules:GetCustomGameDifficulty()
	if nDifficulty > 4 then
		return string.format( "(+%d)", nDifficulty )
	elseif nDifficulty > 0 then
		return string.rep( "+", nDifficulty )
	else
		return ""
	end
end


function CEnfosGameMode:_SpawnHeroClientEffects( hero, nPlayerID )
	-- Spawn these effects on the client, since we don't need them to stay in sync or anything
	-- ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/generic_gameplay/winter_effects_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero, PlayerResource:GetPlayer( nPlayerID ) ) )	-- Attaches the breath effects to players for winter maps
	--ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/frostivus_gameplay/frostivus_hero_light.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero, PlayerResource:GetPlayer( nPlayerID ) ) )
end

function CEnfosGameMode:_SetSpellbringerColors()
	local r = 0
	local g = 0
	local b = 0

	for player_id = 0, 9 do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id) 
		if hero ~= nil then
			--Set the color for the spellbringer
			for i = 1, #playerColors do
				if playerColors[i] ~= nil then
					if playerColors[i].playerID == hero:GetPlayerID() then
						r = playerColors[i].r
						g = playerColors[i].g
						b = playerColors[i].b
					end
				end
			end

			local spellbringer = hero.spellbringer
			if spellbringer ~= nil then
				spellbringer:SetRenderColor(r,g,b)
			end
		end
	end
end

function CEnfosGameMode:OnPlayerPicked( event )
	local spawnedUnit = event.hero
	local spawnedUnitIndex = EntIndexToHScript(event.heroindex)
	if spawnedUnit == "npc_dota_hero_troll_warlord" then
		cannibalIndex = spawnedUnitIndex
	end
	
	--Apply scepter buff to Treant for 5th UI slot
	if spawnedUnitIndex:GetClassname() == "npc_dota_hero_treant" then
		spawnedUnitIndex:AddNewModifier(spawnedUnitIndex, nil, 'modifier_item_ultimate_scepter', {duration = -1})
	end
	-- we have to handle exceptions here, since not all units will have their passive on index 4. we can add "ors" here later
	if spawnedUnitIndex:GetClassname() == "npc_dota_hero_luna" then
		spawnedUnitIndex:GetAbilityByIndex(5):SetLevel(1)
		--Moon glaives

		spawnedUnitIndex:GetAbilityByIndex(6):SetLevel(1)
	elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_crystal_maiden" then
		-- do nothing in this case
	elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_lina" then
		spawnedUnitIndex:GetAbilityByIndex(5):SetLevel(1)
		spawnedUnitIndex:GetAbilityByIndex(6):SetLevel(1)
	else
		spawnedUnitIndex:GetAbilityByIndex(5):SetLevel(1)
	end
	--local statAbility = spawnedUnitIndex:FindAbilityByName("spell_dummy_modifier")
	--if statAbility ~= nil then
	--	statAbility:SetLevel(1)
	--end
	local curRound = self._vRounds[ self._nRoundNumber ]
	local bonusGold = 0
	for i=0, curRound._nRoundNumber do
		bonusGold = (i * 25) + bonusGold
	end
		
	spawnedUnitIndex:SetGold(STARTING_GOLD + bonusGold, false)

	--Sets up the tables to figure out spellbringer colors
	local playerTeam = spawnedUnitIndex:GetTeam()
	local playerID = spawnedUnitIndex:GetPlayerID()
	local playerName = PlayerResource:GetPlayerName(playerID)
	playerID = playerID + 1
	local playerHero = spawnedUnitIndex:GetName()
	local r = 0
	local g = 0
	local b = 0
	

	local spellbringerName = nil
	local spellbringerLocation = nil
	
	spellbringerName = "spellbringer_"..playerID
	--print(spellbringerName)
	if spellbringerName ~= nil then
		spellbringerLocation = Entities:FindByName( nil, spellbringerName ):GetAbsOrigin()
	end
	Timers:CreateTimer(DoUniqueString("spawnSpellbringer"), {
		endTime = 0.5,
		callback = function()
	
			
			--Set the color for the spellbringer
			for i = 1, #playerColors do
				if playerColors[i] ~= nil then
					if playerColors[i].playerID == spawnedUnitIndex:GetPlayerID() then
						r = playerColors[i].r
						g = playerColors[i].g
						b = playerColors[i].b
					end
				end
			end


			if spellbringerLocation ~= nil then
				local unit2 = CreateUnitByName("npc_spellbringer", spellbringerLocation, false, spawnedUnitIndex, spawnedUnitIndex, spawnedUnitIndex:GetTeamNumber())
				unit2:SetControllableByPlayer(spawnedUnitIndex:GetPlayerID(), true)
				local newItem = CreateItem("item_spellbringer_greater_darkrift", spawnedUnitIndex:GetOwner(), spawnedUnitIndex:GetOwner())
				unit2:AddItem(newItem)
				newItem = CreateItem("item_spellbringer_summon_uthmor", spawnedUnitIndex:GetOwner(), spawnedUnitIndex:GetOwner())
				unit2:AddItem(newItem)
				newItem = CreateItem("item_spellbringer_summon_arhat", spawnedUnitIndex:GetOwner(), spawnedUnitIndex:GetOwner())
				unit2:AddItem(newItem)
				newItem = CreateItem("item_spellbringer_summon_sidhlot", spawnedUnitIndex:GetOwner(), spawnedUnitIndex:GetOwner())
				unit2:AddItem(newItem)
				newItem = CreateItem("item_spellbringer_summon_havroth", spawnedUnitIndex:GetOwner(), spawnedUnitIndex:GetOwner())
				unit2:AddItem(newItem)
				--FindClearSpaceForUnit(unit2, spellbringerLocation, true)
				unit2:RemoveModifierByName("modifier_tower_truesight_aura")
				unit2:RemoveModifierByName("modifier_invulnerable")
				spawnedUnitIndex.spellbringer = unit2
				--unit2:SetRenderColor(r,g,b)

				--print(spawnedUnitIndex:GetTeam())
			else
				print("Incorrect spellbringer location!!")
			end
		end
	})

	local heroPicked = spawnedUnitIndex:GetUnitName()
	local heroArmorType = nil
	local heroAttackType = nil
	for i = 1, #heroTable do
		if heroArmorType == nil or heroAttackType == nil then
			if heroTable[i].name == heroPicked then
				heroArmorType = heroTable[i].armorType
				heroAttackType = heroTable[i].attackType
			end
		end
	end
	if heroArmorType ~= nil then
		local armorType = CreateItem("item_armor_type_modifier", nil, nil) 
		armorType:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, heroArmorType, {})
		UTIL_RemoveImmediate(armorType)
		armorType = nil
	end

	if heroAttackType ~= nil then
		local attackItem = CreateItem("item_attack_type_modifier", nil, nil) 
		attackItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, heroAttackType, {})
		UTIL_RemoveImmediate(attackItem)
		attackItem = nil
	end

	local potionItem = CreateItem("item_potion_of_healing", spawnedUnitIndex, nil)
	potionItem:SetCurrentCharges(1)
	local potion = spawnedUnitIndex:AddItem(potionItem)
	
	CEnfosGameMode:ModifyStatBonuses(spawnedUnitIndex)
	
	

end

function CEnfosGameMode:ModifyStatBonuses(unit)
	local spawnedUnitIndex = unit

		Timers:CreateTimer(DoUniqueString("updateHealth_" .. spawnedUnitIndex:GetPlayerID()), {
		endTime = 0.25,
		callback = function()
			-- ==================================
			-- Adjust health based on strength
			-- ==================================

			--Accounts for illusions expiring that get the buff
			if spawnedUnitIndex:IsNull() then
				return 0
			end

			-- Get player strength
			local strength = spawnedUnitIndex:GetStrength()

			--Check if strBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.strBonus == nil then
				spawnedUnitIndex.strBonus = 0
			end

			-- If player strength is different this time around, start the adjustment
			if strength ~= spawnedUnitIndex.strBonus then
				-- Modifier values
				local bitTable = {512,256,128,64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier("modifier_health_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_health_mod_" .. val)
					end
				end
				
				-- Creates temporary item to steal the modifiers from
				local healthUpdater = CreateItem("item_health_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(strength / val)
					if count >= 1 then
						healthUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_health_mod_" .. val, {})
						strength = strength - val
					end
				end
				-- Cleanup
				UTIL_RemoveImmediate(healthUpdater)
				healthUpdater = nil
			end
			-- Updates the stored strength bonus value for next timer cycle
			spawnedUnitIndex.strBonus = spawnedUnitIndex:GetStrength()


			-- ==================================
			-- Adjust mana based on Intellect
			-- ==================================

			-- Get player intellect
			local intellect = spawnedUnitIndex:GetIntellect()

			--Check if intBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.intBonus == nil then
				spawnedUnitIndex.intBonus = 0
			end

			-- If player int is different this time around, start the adjustment
			if intellect ~= spawnedUnitIndex.intBonus then
				-- Modifier values
				local bitTable = {512,256,128,64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier("modifier_mana_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_mana_mod_" .. val)
					end
				end
				
				-- Creates temporary item to steal the modifiers from
				local manaUpdater = CreateItem("item_mana_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(intellect / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_mana_mod_" .. val, {})
						intellect = intellect - val
					end
				end

				-- Cleanup
				UTIL_RemoveImmediate(manaUpdater)
				manaUpdater = nil
			end
			-- Updates the stored Int bonus value for next timer cycle
			spawnedUnitIndex.intBonus = spawnedUnitIndex:GetIntellect()


			-- ==================================
			-- Adjust damage based on primary stat
			-- ==================================

			-- Get player primary stat value
			local primStat = spawnedUnitIndex:GetPrimaryStatValue()

			--Check if primaryStatBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.primaryStatBonus == nil then
				spawnedUnitIndex.primaryStatBonus = 0
			end

			-- If player int is different this time around, start the adjustment
			if primStat ~= spawnedUnitIndex.primaryStatBonus then
				-- Modifier values
				local bitTable = {512,256,128,64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier( "modifier_damage_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_damage_mod_" .. val)
					end
				end
				
				-- Creates temporary item to steal the modifiers from
				local manaUpdater = CreateItem("item_damage_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(primStat / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_damage_mod_" .. val, {})
						primStat = primStat - val
					end
				end

				-- Cleanup
				UTIL_RemoveImmediate(manaUpdater)
				manaUpdater = nil
			end
			-- Updates the stored Int bonus value for next timer cycle
			spawnedUnitIndex.primaryStatBonus = spawnedUnitIndex:GetPrimaryStatValue()

			-- ==================================
			-- Adjust armor based on agi
			-- ==================================

			-- Get player primary stat value
			local agility = spawnedUnitIndex:GetAgility()

			--Check if primaryStatBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.agilityBonus == nil then
				spawnedUnitIndex.agilityBonus = 0
			end

			-- If player int is different this time around, start the adjustment
			if agility ~= spawnedUnitIndex.agilityBonus then
				-- Modifier values
				local bitTable = {512,256,128,64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier( "modifier_armor_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_armor_mod_" .. val)
					end
					
					if spawnedUnitIndex:HasModifier( "modifier_negative_armor_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_negative_armor_mod_" .. val)
					end
				end
				agility = agility / 7
				-- Remove Armor
				-- Creates temporary item to steal the modifiers from
				local manaUpdater = CreateItem("item_armor_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(agility / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_negative_armor_mod_" .. val, {})
						agility = agility - val
					end
				end

				-- Calculate armor per 20 agility
				agility = spawnedUnitIndex:GetAgility()
				agility = agility / 20
				--Add armor from bitfield
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(agility / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_armor_mod_" .. val, {})
						agility = agility - val
					end
				end

				-- Cleanup
				UTIL_RemoveImmediate(manaUpdater)
				manaUpdater = nil
			end
			-- Updates the stored Int bonus value for next timer cycle
			spawnedUnitIndex.agilityBonus = spawnedUnitIndex:GetAgility()
			return 0.25
		end
	})
end

function CEnfosGameMode:OnPlayerStatsUpdated( event )
end	

function CEnfosGameMode:OnPlayerLearnedAbility( event )

	local player = event.player - 1
	if PlayerResource:IsValidPlayer( player ) then
		local hero = PlayerResource:GetSelectedHeroEntity(player)
		--GameRules.Enfos:UpdateBaseStats(hero)
	else
		print("Invalid player!")
	end
end

function CEnfosGameMode:UseTome(hero, stat, value)
	print(hero:GetName().." "..stat.." "..value)
	EmitSoundOn("DOTA_Item.Refresher.Activate", hero)
	if stat == "strength" then
		hero:ModifyStrength(value)
	elseif stat == "intellect" then
		hero:ModifyIntellect(value)
	elseif stat == "agility" then
		hero:ModifyAgility(value)
	elseif stat == "gold" then
		local oldGold = hero:GetGold()
		local newGold = oldGold + value
		hero:SetGold(newGold, false)
	elseif stat == "damage" then
		local caster = hero
		local statBonus = value
		if caster.tome_combat == nil then
			caster.tome_combat = 0
		end
		-- 0 = str, 1 = agi, 2 = int
		local primaryAttribute = caster:GetPrimaryAttribute()

		if primaryAttribute == 0 then
			local strength = math.floor(caster:GetStrength() * 2.5)
			caster:SetBaseDamageMin(caster:GetBaseDamageMin() - caster.tome_combat - strength)
			caster:SetBaseDamageMax(caster:GetBaseDamageMax() - caster.tome_combat - strength)
			caster.tome_combat = caster.tome_combat + statBonus
			caster:SetBaseDamageMin(caster:GetBaseDamageMin() + caster.tome_combat - strength)
			caster:SetBaseDamageMax(caster:GetBaseDamageMax() + caster.tome_combat - strength)
		elseif primaryAttribute == 1 then
			local agility = math.floor(caster:GetAgility() * 2.5)
			caster:SetBaseDamageMin(caster:GetBaseDamageMin() - caster.tome_combat - agility)
			caster:SetBaseDamageMax(caster:GetBaseDamageMax() - caster.tome_combat - agility)
			caster.tome_combat = caster.tome_combat + statBonus
			caster:SetBaseDamageMin(caster:GetBaseDamageMin() + caster.tome_combat - agility)
			caster:SetBaseDamageMax(caster:GetBaseDamageMax() + caster.tome_combat - agility)
		elseif primaryAttribute == 2 then
			local intellect = math.floor(caster:GetIntellect() * 2.5)
			caster:SetBaseDamageMin(caster:GetBaseDamageMin() - caster.tome_combat - intellect)
			caster:SetBaseDamageMax(caster:GetBaseDamageMax() - caster.tome_combat - intellect)
			caster.tome_combat = caster.tome_combat + statBonus
			caster:SetBaseDamageMin(caster:GetBaseDamageMin() + caster.tome_combat - intellect)
			caster:SetBaseDamageMax(caster:GetBaseDamageMax() + caster.tome_combat - intellect)
		else
			print("Invalid primary attribute!")
		end
	elseif stat == "all" then
		hero:ModifyStrength(value)
		hero:ModifyAgility(value)
		hero:ModifyIntellect(value)
	elseif stat == "respec" then
		local caster = hero
		local pointsUsed = 0

		--Handle unique cases here where innate is in slot 6
		if caster:GetClassname() == "npc_dota_hero_luna" then
			for i=0,4 do
				pointsUsed = pointsUsed + caster:GetAbilityByIndex(i):GetLevel()
				caster:GetAbilityByIndex(i):SetLevel(0)
			end
		else
			for i=0,3 do
				pointsUsed = pointsUsed + caster:GetAbilityByIndex(i):GetLevel()
				caster:GetAbilityByIndex(i):SetLevel(0)
			end
		end
		
		caster:SetAbilityPoints(caster:GetAbilityPoints() + pointsUsed)

	end
end

function CEnfosGameMode:CheckTowerShield(unit)
	--print("Checking if player has tower shield.")
	if unit:HasModifier("modifier_tower_shield") then
		--print("Found tower shield. Blocking damage")
		return true
	elseif unit:HasModifier("modifier_dragonscale_shield") then
		return true
	else
		return false
	end
		
	return false
end

function CEnfosGameMode:GetAttackType(unit)
	--Gets the unit's attack type
	local target = unit

	local attackType = nil
	if target:HasModifier("modifier_attack_normal") then
		attackType = "modifier_attack_normal"
	elseif target:HasModifier("modifier_attack_pierce") then
		attackType = "modifier_attack_pierce"
	elseif target:HasModifier("modifier_attack_siege") then
		attackType = "modifier_attack_siege"
	elseif target:HasModifier("modifier_attack_chaos") then
		attackType = "modifier_attack_chaos"
	elseif target:HasModifier("modifier_attack_magical") then
		attackType = "modifier_attack_magical"
	elseif target:HasModifier("modifier_attack_hero") then
		attackType = "modifier_attack_hero"
	else
		--print("Invalid Attack Type")
	end

	return attackType
end

function CEnfosGameMode:GetArmorType(unit)

--					|Armor Type
--Damage Type		|Unarmored	Light	Medium		Heavy		Fortified	Hero
--Normal			|100%		100%	150%		125%		70%			75%
--Pierce			|150%		200%	75%			75%			35%			50%
--Siege				|100%		100%	50%			125%		150%		75%
--Chaos				|100%		100%	100%		100%		40%			100%
--Hero				|100%		100%	100%		100%		50%			100%
--Magic				|100%		100%	100%		100%		100%		75%

	--Gets the unit's armor type
	local target = unit

	local armorType = nil
	if target:HasModifier("modifier_armor_unarmored") then
		armorType = "modifier_armor_unarmored"
	elseif target:HasModifier("modifier_armor_light") then
		armorType = "modifier_armor_light"
	elseif target:HasModifier("modifier_armor_medium") then
		armorType = "modifier_armor_medium"
	elseif target:HasModifier("modifier_armor_heavy") then
		armorType = "modifier_armor_heavy"
	elseif target:HasModifier("modifier_armor_fortified") then
		armorType = "modifier_armor_fortified"
	elseif target:HasModifier("modifier_armor_hero") then
		armorType = "modifier_armor_hero"
	elseif target:HasModifier("modifier_armor_divine") then
		armorType = "modifier_armor_divine"
	else
		--print("Invalid Attack Type")
	end
	
	return armorType
end

function CEnfosGameMode:CalculateDamageBonus(attacktype, armortype)
	local attackType = attacktype
	local armorType = armortype
	local damageMultiplier = 1
	for i=1, #armorTable do
		if armorTable[i].armorType == armorType then
			if armorTable[i][attackType] ~= nil then
				damageMultiplier = armorTable[i][attackType]
			end
		end
	end
	return damageMultiplier
end

function CEnfosGameMode:FilterDamage( filterTable )
	--print("Pre adjust---------------------------")
	--PrintTable(filterTable)

	local damageType = filterTable["damagetype_const"]
	local damage = filterTable["damage"]
	local attacker = EntIndexToHScript(filterTable["entindex_attacker_const"])
	local victim = EntIndexToHScript(filterTable["entindex_victim_const"])
	local ability = nil

	--Checks to see if a spell inflicted the damage
	if filterTable["entindex_inflictor_const"] ~= nil then
		ability = EntIndexToHScript(filterTable["entindex_inflictor_const"])
	end

	--We want it to just continue with the damage if it was from a spell, we only want to adjust for auto attacks
	if ability ~= nil then
		return true
	end

	local armorType = CEnfosGameMode:GetArmorType(victim)
	local attackType = CEnfosGameMode:GetAttackType(attacker)

	--If the victim is magic immune and the attack is magical then just return false since it shouldn't damage the victim at all
	if victim:IsMagicImmune() and attackType == "modifier_attack_magical" then
		return false
	end

	-- Use this to calculate the damage based on armor adjustment
	local armorTypeAdjustment = CEnfosGameMode:CalculateDamageBonus(attackType, armorType)

	--Calculate the damage before any armor affected it
	local armor = math.floor(victim:GetPhysicalArmorValue())
	local preMitigation = ((0.06 * armor) / (1 + 0.06 * armor)) + 1
	local damage = damage * preMitigation
	--print("Premitigation damage" ..damage)


	--Keep this at the end
	--Readjust the damage based on the armor value
	local postMitigation = 1
	if attackType == "modifier_attack_magical" then
		local magicArmor = victim:GetBaseMagicalResistanceValue()
		postMitigation = 1 - (magicArmor / 100)
		filterTable["damagetype_const"] = 2
	else
		postMitigation = ((0.06 * armor) / (1 + 0.06 * armor)) + 1
	end
	--print("post mitigation: "..postMitigation)
	local damage = damage / postMitigation  * armorTypeAdjustment

	if attackType == "modifier_attack_pierce" then
		if CEnfosGameMode:CheckTowerShield(victim) then
			damage = damage * 0.7
		end
	end
	--Sets the damage table to the updated damage
	filterTable["damage"] = damage	
	--print("Post adjust---------------------------")
	--PrintTable(filterTable)
	return true
end
function CEnfosGameMode:FilterExecuteOrder( filterTable )
	--[[print("---------------------------")
	for k, v in pairs( filterTable ) do
		print("Order: " .. k .. " " .. tostring(v) )
	end]]

    local units = filterTable["units"]
    local order_type = filterTable["order_type"]
    local issuer = filterTable["issuer_player_id_const"]
	local entIndex = filterTable["entindex_ability"]
	
	
	if order_type == DOTA_UNIT_ORDER_GLYPH then
		return false
	end

	if order_type == DOTA_UNIT_ORDER_MOVE_ITEM then
		--print("Taking from stash")
		local first_unit = EntIndexToHScript(units["0"])
		local item = EntIndexToHScript( filterTable["entindex_ability"] )
		local slot = filterTable["entindex_target"]
		local artifactItem = false
		local uniqueItem = false
		local hasItem = false

		if item == nil then
			return true
		end
		
		--If moving the item to or in stash, then allow the move
		if slot >= 6 then
			return true
		end

		--Checks to see if picked up item was an artifact
		for p=1, #artifactItems do
			if item:GetAbilityName() == artifactItems[p] then
				--print("Found another artifact!")
				artifactItem = true
			end
		end
		--Checks to see if picked up item was a unique
		for p=1, #uniqueItems do
			if item:GetAbilityName() == uniqueItems[p] then
				uniqueItem = true
			end
		end
				
		if artifactItem then
			--print("Buying an artifact item")
			 for i=0,5 do
				local itemInSlot = first_unit:GetItemInSlot(i)
				if itemInSlot then
					local item_name = itemInSlot:GetAbilityName()
					--print(item_name)
					for p=1, #artifactItems do
						if item_name == artifactItems[p] then
							--print("Found another artifact!")
							--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "Already have an artifact item."})
							Notifications:Bottom(first_unit:GetPlayerID(), {text="Already have an artifact!", duration=3, style={color="red", ["font-size"]="50px"}})
							EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit:GetPlayerOwner())
							hasItem = true
						else
							--print("No match found")
						end
					end
				end
			end
		end
		
		if uniqueItem then
			--print("Buying a unique item")
			 for i=0,5 do
				local itemInSlot = first_unit:GetItemInSlot(i)
				if itemInSlot then
					local item_name = itemInSlot:GetAbilityName()
					--print(item_name)
					if item_name == item:GetAbilityName() then
						--print("Found a match!")
						--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "Already have this unique item."})
						Notifications:Bottom(first_unit:GetPlayerID(), {text="Already have this unique item!", duration=3, style={color="red", ["font-size"]="50px"}})
						EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit:GetPlayerOwner())
						hasItem = true
					else
						--print("No match found")
					end
					--print(item_name)
				end
			end
		end
		
		--print(hasItem)
		if hasItem then
			return false
		end

	end
	if order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then
		local first_unit = EntIndexToHScript(units["0"])
		local hasItem = false
		local itemdata = self._idmap[filterTable["entindex_ability"]]
		--print(itemdata.Ability)
		
		
		if itemdata == nil then
			--print("Item is nil!!")
			return true
		end
		
		if itemdata.IsArtifact == nil and itemdata.IsUnique == nil and itemdata.IsTome == nil then
			--print("item is not an artifact or unique or tome")
			return true
		end
		
		--Checks to see if the item is a tome
		if itemdata.IsTome ~= nil then
			--local tome = tomeData:GetContainedItem()
			local cost = itemdata.ItemCost
			print(cost)
			if first_unit:GetGold() >= cost then
				PlayerResource:SpendGold(first_unit:GetPlayerID(), cost, 1)
				CEnfosGameMode:UseTome(first_unit, itemdata.IsTome, itemdata.Bonus_Stat)
				return false
			else
				Notifications:Bottom(first_unit:GetPlayerID(), {text="Not enough gold!", duration=3, style={color="red", ["font-size"]="50px"}})
				return false
			end

		end
		--Checks to see if any other artifacts are in the inventory, arestnd cancels the buy if there are
		if itemdata.IsArtifact ~= nil then
			--print("Buying an artifact item")
			 for i=0,5 do
				local item = first_unit:GetItemInSlot(i)
				if item then
					local item_name = item:GetAbilityName()
					--print(item_name)
					for p=1, #artifactItems do
						if item_name == artifactItems[p] then
							--print("Found another artifact!")
							--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "Already have an artifact item."})
							
							Notifications:Bottom(first_unit:GetPlayerID(), {text="Already have an artifact!", duration=3, style={color="red", ["font-size"]="50px"}})
							EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit:GetPlayerOwner())
							hasItem = true
						else
							--print("No match found")
						end
					end
				end
			end
		end
		
		-- Checks to see if the player has an indentical unique item, cancels the buy if there is
		if itemdata.IsUnique ~= nil then
			--print("Buying a unique item")
			 for i=0,5 do
				local item = first_unit:GetItemInSlot(i)
				if item then
					local item_name = item:GetAbilityName()
					--print(item_name)
					if item_name == itemdata.Ability then
						--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "Already have this unique item."})
						Notifications:Bottom(first_unit:GetPlayerID(), {text="Already have this unique item!", duration=3, style={color="red", ["font-size"]="50px"}})
						EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit:GetPlayerOwner())
						--print("Found a match!")
						hasItem = true
					else
						--print("No match found")
					end
					--print(item_name)
				end
			end
		end
		
		if hasItem then
			return false
		end
	end
	
	if order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
		local first_unit = EntIndexToHScript(units["0"])
		local item = EntIndexToHScript( filterTable["entindex_target"] )
		local itemdata = self._idmap[filterTable["entindex_target"]]
		local artifactItem = false
		local uniqueItem = false
		local hasItem = false
		if item == nil then
			return true
		end
		local pickedItem = item:GetContainedItem()
		--print(pickedItem:GetAbilityName())
		if pickedItem == nil then
			return true
		end
		
		--Checks to see if the item is a tome
		if itemdata ~= nil then
			if itemdata.IsTome ~= nil then
					--CEnfosGameMode:UseTome(first_unit, itemdata.IsTome, 1)
					return true
			end
		end


		--Checks to see if picked up item was an artifact
		for p=1, #artifactItems do
			if pickedItem:GetAbilityName() == artifactItems[p] then
				--print("Found another artifact!")
				artifactItem = true
			end
		end
		--Checks to see if picked up item was a unique
		for p=1, #uniqueItems do
			if pickedItem:GetAbilityName() == uniqueItems[p] then
				uniqueItem = true
			end
		end
				
		if artifactItem then
			--print("Buying an artifact item")
			 for i=0,5 do
				local itemInSlot = first_unit:GetItemInSlot(i)
				if itemInSlot then
					local item_name = itemInSlot:GetAbilityName()
					--print(item_name)
					for p=1, #artifactItems do
						if item_name == artifactItems[p] then
							--print("Found another artifact!")
							--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "Already have an artifact item."})
							Notifications:Bottom(first_unit:GetPlayerID(), {text="Already have an artifact!", duration=3, style={color="red", ["font-size"]="50px"}})
							EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit:GetPlayerOwner())
							hasItem = true
						else
							--print("No match found")
						end
					end
				end
			end
		end
		
		if uniqueItem then
			--print("Buying a unique item")
			 for i=0,5 do
				local item = first_unit:GetItemInSlot(i)
				if item then
					local item_name = item:GetAbilityName()
					--print(item_name)
					if item_name == pickedItem:GetAbilityName() then
						--print("Found a match!")
						--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "Already have this unique item."})
						Notifications:Bottom(first_unit:GetPlayerID(), {text="Already have this unique item!", duration=3, style={color="red", ["font-size"]="50px"}})
						EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit:GetPlayerOwner())
						hasItem = true
					else
						--print("No match found")
					end
					--print(item_name)
				end
			end
		end
		
		--print(hasItem)
		if hasItem then
			return false
		end
		
	end
	
	if order_type == DOTA_UNIT_ORDER_GIVE_ITEM then
		--PrintTable(units)
		--print("Giving an item!")
		local first_unit = EntIndexToHScript(units["0"])
		local second_unit = EntIndexToHScript( filterTable["entindex_target"] )
		local item = EntIndexToHScript( filterTable["entindex_ability"] )
		local artifactItem = false
		local uniqueItem = false
		local hasItem = false
		if item == nil then
			return true
		end
		
		--print(first_unit:GetUnitName())
		--print(second_unit:GetUnitName())
		--print(item:GetAbilityName())
		
		--Checks to see if picked up item was an artifact
		for p=1, #artifactItems do
			if item:GetAbilityName() == artifactItems[p] then
				--print("Found another artifact!")
				artifactItem = true
			end
		end
		--Checks to see if picked up item was a unique
		for p=1, #uniqueItems do
			if item:GetAbilityName() == uniqueItems[p] then
				uniqueItem = true
			end
		end
		
		--Checks to see if any other artifacts are in the inventory, and cancels the buy if there are
		if artifactItem then
			--print("Buying an artifact item")
			 for i=0,5 do
				local itemInSlot = second_unit:GetItemInSlot(i)
				if itemInSlot then
					local item_name = itemInSlot:GetAbilityName()
					--print(item_name)
					for p=1, #artifactItems do
						if item_name == artifactItems[p] then
							--print("Found another artifact!")
							--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "That target already has an artifact item."})
							Notifications:Bottom(first_unit:GetPlayerID(), {text="That target already has an artifact!", duration=3, style={color="red", ["font-size"]="50px"}})
							EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit:GetPlayerOwner())
							hasItem = true
						else
							--print("No match found")
						end
					end
				end
			end
		end
		
		if uniqueItem then
			--print("Buying a unique item")
			 for i=0,5 do
				local itemInSlot = second_unit:GetItemInSlot(i)
				if itemInSlot then
					local item_name = itemInSlot:GetAbilityName()
					--print(item_name)
					if item_name == item:GetAbilityName() then
						--print("Found a match!")
						--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "That target already has this unique item."})
						Notifications:Bottom(first_unit:GetPlayerID(), {text="That target already has this unique item!", duration=3, style={color="red", ["font-size"]="50px"}})
						EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit:GetPlayerOwner())
						hasItem = true
					else
						--print("No match found")
					end
					--print(item_name)
				end
			end
		end
		
		if hasItem then
			return false
		end
			
	end
	
	if order_type == DOTA_UNIT_ORDER_DROP_ITEM then
		local first_unit = EntIndexToHScript(units["0"])
		local item = EntIndexToHScript( filterTable["entindex_ability"] )
		local uniqueItem = false
		
		if item == nil then
			return true
		end
		
		for p=1, #uniqueItems do
			if item:GetAbilityName() == uniqueItems[p] then
				uniqueItem = true
			end
		end
		
		if uniqueItem then
			--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "Unique items cannot be dropped!"})
			Notifications:Bottom(first_unit:GetPlayerID(), {text="Unique items cannot be dropped!", duration=3, style={color="red", ["font-size"]="50px"}})
			EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit:GetPlayerOwner())
			return false
		end
	end
	
	if order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		local first_unit = EntIndexToHScript(units["0"])
		local ability = EntIndexToHScript( filterTable["entindex_ability"] )
		
		--print("No Target "..ability:GetAbilityName())
	end
	
	if order_type == DOTA_UNIT_ORDER_CAST_POSITION then
		local first_unit = EntIndexToHScript(units["0"])
		local ability = EntIndexToHScript( filterTable["entindex_ability"] )
		
		--print("Position "..ability:GetAbilityName())
	end
	
	if order_type == DOTA_UNIT_ORDER_CAST_TARGET then
		local first_unit = EntIndexToHScript(units["0"])
		local target = EntIndexToHScript(filterTable["entindex_target"])
		local ability = EntIndexToHScript( filterTable["entindex_ability"] )
		
		--print("Target "..ability:GetAbilityName())
		
		--Checking if Empath is trying to cast transference on herself
		if ability:GetAbilityName() == "empath_transference" then
			if first_unit == target then
				EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", first_unit)
				--FireGameEvent('custom_error_show', {player_ID = first_unit:GetPlayerID(), _error = "Empath cannot cast this on herself!"})
				Notifications:Bottom(first_unit:GetPlayerID(), {text="Empath cannot cast this on herself!", duration=3, style={color="red", ["font-size"]="50px"}})
				return false
			end
		end
		
		
	end
	
	if order_type == DOTA_UNIT_ORDER_CAST_RUNE then
		local first_unit = EntIndexToHScript(units["0"])
		local ability = EntIndexToHScript( filterTable["entindex_ability"] )
		
		--print("Rune "..ability:GetAbilityName())
	end
	
	if order_type == DOTA_UNIT_ORDER_CAST_TOGGLE then
		local first_unit = EntIndexToHScript(units["0"])
		local ability = EntIndexToHScript( filterTable["entindex_ability"] )
		
		--print("Toggle "..ability:GetAbilityName())
	end
	return true
end

function CEnfosGameMode:OnInventoryChanged( event )
	--print("Player inventory changed")
	local player = event.PlayerID 
	if PlayerResource:IsValidPlayer( player ) then
		local hero = PlayerResource:GetSelectedHeroEntity(player)
		--GameRules.Enfos:UpdateBaseStats(hero)
		if hero ~= nil then
			for item_slot = 0, 5 do

				local item = hero:GetItemInSlot(item_slot)
				if item ~= nil then
					item:SetPurchaser(hero) 
				end

			end
		end
	else
		print("Invalid player!")
	end
end

function CEnfosGameMode:OnItemGifted(event)
	PrintTable(event)
	local itemname = event.itemname
	local player = event.PlayerID 
	local hero = nil
end
function CEnfosGameMode:OnItemPickedUp(event)
	--PrintTable(event)
	local itemname = event.itemname
	local player = event.PlayerID 
	local hero = nil
	if PlayerResource:IsValidPlayer( player ) then
		hero = PlayerResource:GetSelectedHeroEntity(player)
		
	else
		print("Invalid player!")
	end
	
	if hero ~= nil then
		for item_slot = 0, 5 do

			local item = hero:GetItemInSlot(item_slot)
			if item ~= nil then
				item:SetPurchaser(hero) 
			end

		end
	end
	
	Timers:CreateTimer(DoUniqueString("itemPickup"), {
		endTime = 0.001,
		callback = function()
				if string.find(itemname, "item_empath") then
					local itemSlot = -1
					for item = 0, 18 do
						if hero:GetItemInSlot(item) ~= nil then
							if hero:GetItemInSlot(item):GetName() == itemname then
								itemSlot = item
							end
						end
					end
					hero:CastAbilityImmediately(hero:GetItemInSlot(itemSlot), player)
					hero:RemoveItem(hero:GetItemInSlot(itemSlot))
				end
				if string.find(itemname, "item_2000") then
					local itemSlot = -1
					for item = 0, 18 do
						if hero:GetItemInSlot(item) ~= nil then
							if hero:GetItemInSlot(item):GetName() == itemname then
								itemSlot = item
							end
						end
					end
					hero:CastAbilityImmediately(hero:GetItemInSlot(itemSlot), player)
					hero:RemoveItem(hero:GetItemInSlot(itemSlot))
				end
				if string.find(itemname, "item_10000") then
					local itemSlot = -1
					for item = 0, 18 do
						if hero:GetItemInSlot(item) ~= nil then
							if hero:GetItemInSlot(item):GetName() == itemname then
								itemSlot = item
							end
						end
					end
					hero:CastAbilityImmediately(hero:GetItemInSlot(itemSlot), player)
					hero:RemoveItem(hero:GetItemInSlot(itemSlot))
				end
	
			--[[OLD ITEM CHECKING
			-- Automatically drops the new unique item if a previous unique is found.
			local artifactItemCount = 0
			for i=1, #artifactItems do
				for item = 0, 18 do
					if hero:GetItemInSlot(item) ~= nil then
						if hero:GetItemInSlot(item):GetName() == artifactItems[i] then
							artifactItemCount = artifactItemCount + 1
							--print(uniqueItemCount)
						end
					end
				end
			end

			-- Automatically drops the new unique item if a previous unique item is found.
			local uniqueItemCount = 0
			for i=1, #uniqueItems do
				for item = 0, 18 do
					if hero:GetItemInSlot(item) ~= nil then
						if hero:GetItemInSlot(item):GetName() == uniqueItems[i] and hero:GetItemInSlot(item):GetName() == itemname then
							uniqueItemCount = uniqueItemCount + 1
							--print(uniqueItemCount)
						end
					end
				end
			end
			
			while artifactItemCount > 1 do
				for p=1, #artifactItems do
					if hero:HasItemInInventory(artifactItems[p]) then
						for item = 0, 18 do
							if hero:GetItemInSlot(item) ~= nil then
								if hero:GetItemInSlot(item):GetName() == itemname then
									--hero:DropItemAtPosition(hero:GetAbsOrigin(), hero:GetItemInSlot(item))
									if artifactItemCount > 1 then
									--	print("Dropping item number "..item)
										hero:DropItemAtPosition(hero:GetAbsOrigin(), hero:GetItemInSlot(item))
										artifactItemCount = artifactItemCount - 1
									--	print("artifact count after drop "..artifactItemCount)
									end
								end
							end
						end
					end
				end
			end

			while uniqueItemCount > 1 do
				for p=1, #uniqueItems do
					if hero:HasItemInInventory(uniqueItems[p]) then
						for item = 0, 18 do
							if hero:GetItemInSlot(item) ~= nil then
								if hero:GetItemInSlot(item):GetName() == itemname then
									hero:DropItemAtPosition(hero:GetAbsOrigin(), hero:GetItemInSlot(item))
								end
							end
						end
						uniqueItemCount = uniqueItemCount - 1
					end
				end
			end]]--
		end
	})



	


	

end
function CEnfosGameMode:OnItemPurchased(event)
	--PrintTable(event)
	local itemname = event.itemname
	local player = event.PlayerID 
	local hero = nil
	if PlayerResource:IsValidPlayer( player ) then
		hero = PlayerResource:GetSelectedHeroEntity(player)
		
	else
		print("Invalid player!")
	end

	--[[OLD TOME AUTOCASTING
	-- Autocasts tomes if found in inventory
	if string.find(itemname, "item_tome") then
		local itemSlot = -1
		for item = 0, 18 do
			if hero:GetItemInSlot(item) ~= nil then
				if hero:GetItemInSlot(item):GetName() == itemname then
					itemSlot = item
				end
			end
		end
		hero:CastAbilityImmediately(hero:GetItemInSlot(itemSlot), player)
		hero:RemoveItem(hero:GetItemInSlot(itemSlot))
	end]]

	--OLD ITEM CHECKING
	--[[-- Automatically drops the new artifact item if a previous unique is found.
	local artifactItemCount = 0
	for i=1, #artifactItems do
		for item = 0, 18 do
			if hero:GetItemInSlot(item) ~= nil then
				if hero:GetItemInSlot(item):GetName() == artifactItems[i] then
					artifactItemCount = artifactItemCount + 1
					--print(uniqueItemCount)
				end
			end
		end
	end

	while artifactItemCount > 1 do
		for p=1, #artifactItems do
			if hero:HasItemInInventory(artifactItems[p]) then
				for item = 0, 18 do
					if hero:GetItemInSlot(item) ~= nil then
						if hero:GetItemInSlot(item):GetName() == itemname then
							--hero:DropItemAtPosition(hero:GetAbsOrigin(), hero:GetItemInSlot(item))
							if artifactItemCount > 1 then
								hero:SellItem(hero:GetItemInSlot(item))
								artifactItemCount = artifactItemCount - 1
							end
						end
					end
				end
			end
		end
	end]]--

	--[[
	-- Automatically drops the new unique item if a previous unique item is found.
	local uniqueItemCount = 0
	for i=1, #uniqueItems do
		for item = 0, 18 do
			if hero:GetItemInSlot(item) ~= nil then
				if hero:GetItemInSlot(item):GetName() == uniqueItems[i] and hero:GetItemInSlot(item):GetName() == itemname then
					uniqueItemCount = uniqueItemCount + 1
					--print(uniqueItemCount)
				end
			end
		end
	end

	while uniqueItemCount > 1 do
		for p=1, #uniqueItems do
			if hero:HasItemInInventory(uniqueItems[p]) then
				for item = 0, 18 do
					if hero:GetItemInSlot(item) ~= nil then
						if hero:GetItemInSlot(item):GetName() == itemname then
							--hero:DropItemAtPosition(hero:GetAbsOrigin(), hero:GetItemInSlot(item))
							if uniqueItemCount > 1 then
								hero:SellItem(hero:GetItemInSlot(item))
								uniqueItemCount = uniqueItemCount - 1
							end
						end
					end
				end
				
			end
		end
	end]]
end


function CEnfosGameMode:OnPlayerLevelledUp( event )

	local player = event.player - 1
	if PlayerResource:IsValidPlayer( player ) then
		local hero = PlayerResource:GetSelectedHeroEntity(player)
		--GameRules.Enfos:UpdateBaseStats(hero)
	else
		print("Invalid player!")
	end
end


function CEnfosGameMode:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end

	 if spawnedUnit:IsCreature() then
	 	if spawnedUnit:GetUnitName() == "npc_dota_neutral_satyr_reaver" then
			spawnedUnit:AddNewModifier(caster, nil, "modifier_tower_truesight_aura", {})
	 	end
		-- spawnedUnit:SetHPGain( spawnedUnit:GetMaxHealth() * 0.3 ) -- LEVEL SCALING VALUE FOR HP
	 end

	 if spawnedUnit:IsHero() then
	 	spawnedUnit.strBonus = 0
	 	spawnedUnit.intBonus = 0
	 	spawnedUnit.primaryStatBonus = 0
	 	spawnedUnit.agilityBonus = 0
	 	local heroPicked = spawnedUnit:GetUnitName()
		local heroArmorType = nil
		local heroAttackType = nil
		for i = 1, #heroTable do
			if heroArmorType == nil or heroAttackType == nil then
				if heroTable[i].name == heroPicked then
					heroArmorType = heroTable[i].armorType
					heroAttackType = heroTable[i].attackType
				end
			end
		end
		if heroArmorType ~= nil then
			local armorType = CreateItem("item_armor_type_modifier", nil, nil) 
			armorType:ApplyDataDrivenModifier(spawnedUnit, spawnedUnit, heroArmorType, {})
			UTIL_RemoveImmediate(armorType)
			armorType = nil
		end

		if heroAttackType ~= nil then
			local attackItem = CreateItem("item_attack_type_modifier", nil, nil) 
			attackItem:ApplyDataDrivenModifier(spawnedUnit, spawnedUnit, heroAttackType, {})
			UTIL_RemoveImmediate(attackItem)
			attackItem = nil
		end
	 end

end


-- Attach client-side hero effects for a reconnecting player
function CEnfosGameMode:OnPlayerReconnected( event )
	local nReconnectedPlayerID = event.PlayerID
	for _, hero in pairs( Entities:FindAllByClassname( "npc_dota_hero" ) ) do
		if hero:IsRealHero() then
			self:_SpawnHeroClientEffects( hero, nReconnectedPlayerID )
		end
	end
end


function CEnfosGameMode:OnEntityKilled( event )
	local killer = EntIndexToHScript( event.entindex_attacker )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local exp = killedUnit:GetDeathXP()
	if not killedUnit or killedUnit:GetClassname() == "npc_dota_thinker" or killedUnit:IsPhantom() then
		return
	end

	local corpseBlacklist = {
				"npc_dota_creature_wood_troll",
				"npc_dota_rock_troll",
				"npc_dota_mottled_westanuryn",
				"npc_dota_spirit_hawk",
				"npc_dota_death_spirit",
				"npc_dota_rock_guardian",
				"npc_dota_skeletal_sailor",
				"npc_dota_armored_warklin",
				"npc_dota_snaer_hafwa",
				"npc_dota_slai_screamer"
							}

	--print(killer)
	if killedUnit:IsCreature() then
		--Set all killed units to have a corpse on default
		if killedUnit.noCorpse == nil then
			killedUnit.noCorpse = false
		end

		for i=1, #corpseBlacklist do
			if killedUnit:GetUnitName() == corpseBlacklist[i] then
				killedUnit.noCorpse = true
			end
		end

		if killedUnit:GetUnitName() == "npc_dota_spirit_hawk" or killedUnit:GetUnitName() == "npc_dota_spirit_owl" then
			if killer:IsHero() then
				local killerTeam = killer:GetTeam()
				if(killerTeam == 2) then
					CEnfosGameMode:ModifyLife(DOTA_TEAM_GOODGUYS, 0, 1)
				elseif(killerTeam == 3) then
					CEnfosGameMode:ModifyLife(DOTA_TEAM_BADGUYS, 0, 1)
				end
			end
		end

	end

	--Global creep experience
	if killedUnit.noxp then
		return
	end
	local exp = 0
	local xpKilledUnitTeam = killedUnit:GetTeam()
	local radiantPlayers = PlayerResource:GetPlayerCountForTeam(2)
	local direPlayers = PlayerResource:GetPlayerCountForTeam(3)
	for i = 1, #expTable do
			if expTable[i].name == killedUnit:GetUnitName() then
				exp = tonumber(expTable[i].exp)
				
			end
	end
	--exp = math.ceil(exp / PlayerResource:GetPlayerCountForTeam(PlayerResource:GetSelectedHeroEntity(xpPlayerID):GetTeamNumber()))
	local radiantEXP = math.ceil(exp / radiantPlayers)
	local direEXP = math.ceil(exp / direPlayers)
	 -- Loop for Players
	for xpPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		local teamID = PlayerResource:GetTeam(xpPlayerID)
		local player = PlayerResource:GetSelectedHeroEntity(xpPlayerID)
		-- If player isn't nil and is on an enemy team, give exp
		if player ~= nil and player:GetTeam() ~= xpKilledUnitTeam and player:IsAlive() then
			if player:GetTeam() == 2 then
				if player:HasModifier("modifier_enfeeble_enfos") then -- this is for Shadow Priest's enfeeble
					local modifiedEXP = radiantEXP / 10
					player:AddExperience(modifiedEXP, false, false)
					--print("Giving "..modifiedEXP.." exp to "..player:GetName())
				elseif player:HasModifier("modifier_faenellas_grace") then
					local modifiedEXP = radiantEXP * 1.5
					player:AddExperience(modifiedEXP, false, false)
					--print("Giving "..modifiedEXP.." exp to "..player:GetName())
				else
					player:AddExperience(radiantEXP, false, false)
					--print("Giving "..radiantEXP.." exp to "..player:GetName())
				end
				
			else
				if player:HasModifier("modifier_enfeeble_enfos") then -- this is for Shadow Priest's enfeeble
					local modifiedEXP = direEXP / 10
					player:AddExperience(modifiedEXP, false, false)
				elseif player:HasModifier("modifier_faenellas_grace") then
					local modifiedEXP = direEXP * 1.5
					player:AddExperience(modifiedEXP, false, false)
				else
					player:AddExperience(direEXP, false, false)
				end
			end
		end
	end
	
	if killedUnit:IsHero() then
		killedUnit:SetBuybackGoldLimitTime(0)
		if cannibalIndex ~= nil then
			print("Index exists")
			local soulDrain = cannibalIndex:FindAbilityByName("troll_cannibal_soul_feast")
			local soulDrainLevel = soulDrain:GetLevel()
			if soulDrainLevel > 0 and soulDrain:IsCooldownReady() and killedUnit:GetTeamNumber() ~= cannibalIndex:GetTeamNumber() then
				if killedUnit:GetUnitName() == "npc_dota_hero_troll_cannibal" then -- this should never happen, but if it does, things go wrong
					return
				else
					print("Stealing an ult")
					local killedUnitUltimate = killedUnit:GetAbilityByIndex(3):GetAbilityName()
					print(killedUnitUltimate)
					if killedUnitUltimate == "moon_mage_moongate" then
						killedUnitUltimate = "moon_mage_burn" -- I'm sure there's a nicer way to do this
					end
					cannibalIndex.stolenUltimate = killedUnitUltimate
					soulDrain:StartCooldown(65535)
					if cannibalIndex:HasAbility(killedUnitUltimate) == false then
						cannibalIndex:AddAbility(killedUnitUltimate)
					end
					cannibalIndex:FindAbilityByName(killedUnitUltimate):SetLevel(soulDrainLevel)
					cannibalIndex:SwapAbilities("troll_cannibal_soul_feast", killedUnitUltimate, false, true)
					soulDrain:ApplyDataDrivenModifier(cannibalIndex, cannibalIndex, "modifier_soul_feast_passive_timer", {duration = 20})
					cannibalIndex.passiveAbility = killedUnitUltimate
					if killedUnit:GetUnitName() == "npc_dota_hero_luna" then
						cannibalIndex:AddAbility("generic_focus_moonbeam")
						cannibalIndex:FindAbilityByName("generic_focus_moonbeam"):SetLevel(1)
						cannibalIndex:SwapAbilities("troll_cannibal_soul_drain", "generic_focus_moonbeam", false, true)
					end
					if killedUnitUltimate == "sniper_rapid_reload" or killedUnitUltimate == "thief_venom" then
						soulDrain:ApplyDataDrivenModifier(cannibalIndex, cannibalIndex, "modifier_soul_feast_passive_timer", {duration = 20})
						cannibalIndex.passiveAbility = killedUnitUltimate
					end
				end
			end
		end
	end
end

function CEnfosGameMode:OnEntityHurt( event )
	--PrintTable(event)
end

function CEnfosGameMode:OnAbilityCast( keys )
	--PrintTable(keys)
	local abilityName = keys.abilityname
	--local ply = keys.PlayerID
	--local hero = keys.PlayerID:GetAssignedHero()
	return

	
end

function CEnfosGameMode:ComputeTowerBonusGold( nTowersTotal, nTowersStanding )
	local nRewardPerTower = self._nTowerRewardAmount + self._nTowerScalingRewardPerRound * (self._nRoundNumber - 1)
	return nRewardPerTower * nTowersStanding
end

function CEnfosGameMode:ModifyLife(team, add_or_remove, amount) -- add is 0, remove is 1
	local lives = nil
	if team == DOTA_TEAM_GOODGUYS then
		lives = goodLives
	elseif team == DOTA_TEAM_BADGUYS then
		lives = badLives
	else
		print ("Invalid team!")
		return
	end
	if add_or_remove == 0 then
		lives = lives + amount
	elseif add_or_remove == 1 then
		lives = lives - amount
	else
		print ("Invalid arithmetic! Use 0 for add and 1 for remove.")
		return
	end
	if team == DOTA_TEAM_GOODGUYS then
		goodLives = lives
	elseif team == DOTA_TEAM_BADGUYS then
		badLives = lives
	else
		print ("um it shouldn't be possible to get here")
		return
	end
	GameRules:GetGameModeEntity():SetTopBarTeamValue(team, lives)
end


ROUND_EXPECTED_VALUES_TABLE = {

}

-- Custom game specific console command "Enfos_test_round"
function CEnfosGameMode:_TestRoundConsoleCommand( cmdName, roundNumber, delay )
	local nRoundToTest = tonumber( roundNumber )
	print (string.format( "Testing round %d", nRoundToTest ) )
	if nRoundToTest <= 0 or nRoundToTest > #self._vRounds then
		Msg( string.format( "Cannot test invalid round %d", nRoundToTest ) )
		return
	end
	curRound = nRoundToTest - 1
	Enfos.curRound = curRound
	print("Enfos.curRound: "..Enfos.curRound)
	if self._entPrepTimeQuest then
		UTIL_RemoveImmediate( self._entPrepTimeQuest )
		self._entPrepTimeQuest = nil
	end

	if self._currentRound ~= nil then
		self._currentRound:End()
		self._currentRound = nil
	end

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if containedItem then
			UTIL_RemoveImmediate( containedItem )
		end
		UTIL_RemoveImmediate( item )
	end

	if self._entAncient and not self._entAncient:IsNull() then
		self._entAncient:SetHealth( self._entAncient:GetMaxHealth() )
	end

	self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
	self._nRoundNumber = nRoundToTest
	if delay ~= nil then
		self._flPrepTimeEnd = GameRules:GetGameTime() + tonumber( delay )
	end
end

function CEnfosGameMode:_StatusReportConsoleCommand( cmdName )
	print( "*** Enfos Status Report ***" )
	print( string.format( "Current Round: %d", self._nRoundNumber ) )
	if self._currentRound then
		self._currentRound:StatusReport()
	end
	print(goodLives)
	print( "*** Enfos Status Report End *** ")
end

function CEnfosGameMode:_ResetLivesConsoleCommand( cmdName )
	print( "*** Enfos Life Reset ***" )
	print(badLives)
	print(goodLives)
	Triggers._badLives = 100
	Triggers._goodLives = 100
	GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )

	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, Triggers._goodLives)

	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, Triggers._badLives)
end



