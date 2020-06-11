local dummy = {}
dummy.option = Menu.AddOption({".SCRIPTS", "Dummy User"}, "Dummy User","")
dummy.option2 = Menu.AddOption({".SCRIPTS", "Dummy User"}, "Dummy Disabler", "")
dummy.option3 = Menu.AddOption({".SCRIPTS", "Dummy User"}, "Abyssal Blade Abuse","")
dummy.key = Menu.AddKeyOption({".SCRIPTS", "Dummy User"}, "Dummy Key", Enum.ButtonCode.KEY_SPACE)
dummy.iconsize = Menu.AddOption({".SCRIPTS", "Show Runes"}, "Show Runes Icon Size", "", 400, 900, 50)
dummy.particle = nil
dummy.tango = false
dummy.clicktime = 0

function dummy.OnUpdate()
	me = Heroes.GetLocal()
	if not Menu.IsEnabled(dummy.option) or not me then return end
	if Entity.IsAlive(me) and not NPC.IsChannellingAbility(me) then
		if not NPC.HasState(me, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) and not NPC.HasModifier(me, "modifier_windrunner_windrun_invis") then

			local bottle = NPC.GetItem(me, "item_bottle", true)
			if bottle then
				for key, friend in pairs(Entity.GetHeroesInRadius(me, 350, Enum.TeamType.TEAM_FRIEND)) do
					if friend and Entity.IsAlive(friend) and bottle and NPC.HasModifier(me, "modifier_fountain_aura_buff") and Ability.IsReady(bottle) then
						if not NPC.HasModifier(friend, "modifier_bottle_regeneration") and (Entity.GetHealth(friend) / Entity.GetMaxHealth(friend) < 0.9 or NPC.GetMana(friend) / NPC.GetMaxMana(friend) < 0.9) then
							Ability.CastTarget(bottle, friend)
						end
					end
				end
			end

			local item = NPC.GetItem(me, "item_tango", true) or NPC.GetItem(me, "item_bfury", true) or NPC.GetItem(me, "item_quelling_blade", true) or NPC.GetItem(me, "item_iron_talon", true) or NPC.GetItem(me, "item_tango_single", true)
			if item and Ability.IsReady(item) then
				for key, ward in pairs(Entity.GetUnitsInRadius(me, 450, Enum.TeamType.TEAM_ENEMY)) do
					if ward and Entity.IsAlive(ward) and (NPC.GetUnitName(ward) == "npc_dota_observer_wards" or NPC.GetUnitName(ward) == "npc_dota_sentry_wards") then
						Ability.CastTarget(item, ward)
					end
				end
			end

			for key, heroes in pairs({dummy.gethero(), me}) do
				if heroes then
					local scepter = NPC.GetAbility(heroes, "arc_warden_scepter")
					if scepter and Ability.IsReady(scepter) and not Ability.IsHidden(scepter) then
						if heroes ~= dummy.gethero() or heroes == dummy.gethero() and NPC.IsEntityInRange(dummy.gethero(), me, 200) then
							Ability.CastNoTarget(scepter)
						end
					end
					for key2, enemy in pairs(Entity.GetHeroesInRadius(heroes, 2600, Enum.TeamType.TEAM_ENEMY)) do
						if enemy and Entity.IsAlive(enemy) then
							local headshot = NPC.GetAbility(heroes, "windrunner_powershot")
							if headshot and Ability.IsReady(headshot) then
								local damage = Ability.GetLevelSpecialValueFor(headshot, "powershot_damage")
								if NPC.GetAbility(heroes, "special_bonus_unique_windranger_3") and Ability.GetLevel(NPC.GetAbility(heroes, "special_bonus_unique_windranger_3")) > 0 then
									damage = damage + 100
								end
								if not NPC.IsEntityInRange(heroes, enemy, NPC.GetAttackRange(heroes)) and not NPC.HasModifier(heroes, "modifier_windrunner_focusfire") and not NPC.IsRunning(heroes) then
									if damage > 0 and Entity.GetHealth(enemy) < (1 - NPC.GetMagicalArmorValue(enemy)) * damage and NPC.IsRunning(enemy) then
										local speed = NPC.GetMoveSpeed(enemy)
										local angle = Entity.GetRotation(enemy)
										local offset = Angle(0, 45, 0)
										angle:SetYaw(angle:GetYaw() + offset:GetYaw())
										local x,y,z = angle:GetVectors()
										local direction = x + y + z
										local name = NPC.GetUnitName(enemy)
										direction:SetZ(0)
										direction:Normalize()
										direction:Scale(speed)
										local origin = NPC.GetAbsOrigin(enemy)
										local pos = origin + direction
										Ability.CastPosition(headshot, pos)
									end
									if damage > 0 and Entity.GetHealth(enemy) < (1 - NPC.GetMagicalArmorValue(enemy)) * damage and NPC.IsAttacking(enemy) and not NPC.IsRunning(enemy) or NPC.HasModifier(enemy, "modifier_axe_berserkers_call") then
										Ability.CastPosition(headshot, Entity.GetAbsOrigin(enemy))
									end
								end
							end
							for i = 0, 5 do
								local item = NPC.GetItemByIndex(me, i)
								if item then 
									if NPC.FindFacingNPC(heroes, nil, Enum.TeamType.TEAM_ENEMY, Ability.GetCastRange(item), 180) == enemy and not NPC.IsLinkensProtected(enemy) and not NPC.HasModifier(enemy, "modifier_item_lotus_orb_active") then
										if Ability.GetName(item) == "item_cyclone" and Ability.IsReady(item) then
											if NPC.HasModifier(enemy, "modifier_teleporting") or NPC.HasModifier(enemy, "modifier_abaddon_borrowed_time") or NPC.HasModifier(enemy, "modifier_item_blade_mail_reflect") or NPC.HasModifier(enemy, "modifier_troll_warlord_battle_trance") or NPC.HasModifier(enemy, "modifier_ursa_enrage") then
												Ability.CastTarget(item, enemy)
											end
										end
										if Ability.GetName(item) == "item_nullifier" and Ability.IsReady(item) then
											if NPC.HasModifier(enemy, "modifier_teleporting") or NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") or NPC.HasModifier(enemy, "modifier_eul_cyclone") or NPC.HasModifier(enemy, "modifier_ghost_state") or NPC.HasModifier(enemy, "modifier_item_satanic_unholy") or (NPC.HasModifier(enemy, "modifier_item_armlet_unholy_strength") and Entity.GetHealth(enemy) < 600) or NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") and not NPC.HasModifier(enemy, "modifier_item_ethereal_blade_slow") then
												Ability.CastTarget(item, enemy)
											end
										end
										if Ability.GetName(item) == "item_hurricane_pike" and Ability.IsReady(item) then
											if NPC.HasModifier(enemy, "modifier_spirit_breaker_charge_of_darkness") or NPC.HasModifier(enemy, "modifier_troll_warlord_battle_trance") or NPC.HasModifier(enemy, "modifier_ursa_enrage") then
												Ability.CastTarget(item, enemy)
											end
										end
									end
									if Ability.GetName(item) == "item_bloodstone" and Ability.IsReady(item) then
										if Ability.IsReady(item) and Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.25 and NPC.FindFacingNPC(enemy, nil, Enum.TeamType.TEAM_ENEMY, 600, 15) == heroes then
											if NPC.IsAttacking(enemy) then
												Ability.CastNoTarget(item)
											end
										end
									end
								end
							end
							for key3, spells in pairs({
								"antimage_mana_void",
								"arc_warden_flux",
								"axe_culling_blade",
								"bounty_hunter_track",
								"bane_fiends_grip",
								"batrider_flaming_lasso",
								"beastmaster_primal_roar",
								"bloodseeker_rupture",
								"crystal_maiden_frostbite",
								"doom_bringer_doom",
								"huskar_life_break",
								"legion_commander_duel",
								"lich_chain_frost",
								"life_stealer_open_wounds",
								"lina_laguna_blade",
								"lion_impale",
								"lion_mana_drain",
								"lion_finger_of_death",
								"luna_lucent_beam",
								"necrolyte_reapers_scythe",
								"nyx_assassin_mana_burn",
								"ogre_magi_unrefined_fireblast",
								"ogre_magi_fireblast",
								"razor_static_link",
								"rubick_fade_bolt",
								"pudge_dismember",
								"pugna_life_drain",
								"slardar_amplify_damage",
								"shadow_demon_disruption",
								"shadow_demon_demonic_purge",
								"shadow_shaman_shackles",
								"skywrath_mage_ancient_seal",
								"spirit_breaker_nether_strike",
								"storm_spirit_electric_vortex",
								"terrorblade_sunder",
								"tusk_walrus_punch",
								"vengefulspirit_nether_swap",
								"winter_wyvern_winters_curse"
							}) do
								local spell = NPC.GetAbility(enemy, spells)
								if spell then
									local castrange = Ability.GetCastRange(spell)
									local bloodstone = NPC.GetItem(me, "item_bloodstone", true)
									if Ability.IsInAbilityPhase(spell) then
										if Ability.GetName(spell) == "axe_culling_blade" or Ability.GetName(spell) == "lion_finger_of_death" or Ability.GetName(spell) == "lina_laguna_blade" then
											if bloodstone and Ability.IsReady(bloodstone) and NPC.FindFacingNPC(enemy, nil, Enum.TeamType.TEAM_ENEMY, castrange + 50, 15) == heroes and not NPC.IsLinkensProtected(heroes) then
												local damage = Ability.GetDamage(spell)
												if damage == 0 then
													if Ability.GetName(spell) == "axe_culling_blade" then
														damage = Ability.GetLevelSpecialValueFor(spell, "kill_threshold")
													end
												else
													if Ability.GetName(spell) == "lion_finger_of_death" then
														local modifier = NPC.GetModifier(enemy, "modifier_lion_finger_of_death_kill_counter")
														local stackcount = Modifier.GetStackCount(modifier)
														if stackcount > 0 then 
															damage = stackcount * 50 + damage 
														end
													end
												end
												if damage > 0 then
													if NPC.HasModifier(heroes, "modifier_item_ethereal_blade_slow") then
														damage = damage + damage * 0.4
													end
													if NPC.HasModifier(heroes, "modifier_item_veil_of_discord_debuff") then
														damage = damage + damage * 0.25
													end
													if Entity.GetHealth(heroes) < (1 - NPC.GetMagicalArmorValue(heroes)) * damage + 250 and Entity.GetHealth(heroes) > (1 - NPC.GetMagicalArmorValue(heroes)) * damage - 250 then
														Ability.CastNoTarget(bloodstone)
													end
												end
											end
										end
										local item = NPC.GetItem(heroes, "item_lotus_orb", true) or NPC.GetItem(heroes, "item_sphere", true)
										if item and Ability.IsReady(item) then
											if Ability.GetName(item) == "item_sphere" or Ability.GetName(item) == "item_lotus_orb" and Ability.GetName(spell) ~= "legion_commander_duel" then
												for key4, friend in pairs(Entity.GetHeroesInRadius(heroes, Ability.GetCastRange(item), Enum.TeamType.TEAM_FRIEND)) do
													if friend and Entity.IsAlive(friend) and NPC.FindFacingNPC(enemy, nil, Enum.TeamType.TEAM_ENEMY, castrange + 50, 15) == friend and not NPC.IsLinkensProtected(friend) and not NPC.HasModifier(friend, "modifier_item_lotus_orb_active") then
														Ability.CastTarget(item, friend)
													end
												end
											end
											if Ability.GetName(item) == "item_lotus_orb" and Ability.GetName(spell) ~= "legion_commander_duel" and NPC.FindFacingNPC(enemy, nil, Enum.TeamType.TEAM_ENEMY, castrange + 50, 15) == heroes and not NPC.IsLinkensProtected(heroes) and not NPC.HasModifier(heroes, "modifier_item_lotus_orb_active") then
												Ability.CastTarget(item, heroes)
											end
										end
										local counterspell = NPC.GetAbility(heroes, "antimage_counterspell")
										if counterspell and Ability.IsReady(counterspell) and Ability.GetName(spell) ~= "vengefulspirit_nether_swap" and Ability.GetName(spell) ~= "terrorblade_sunder" and NPC.FindFacingNPC(enemy, nil, Enum.TeamType.TEAM_ENEMY, castrange + 50, 15) == heroes then
											Ability.CastNoTarget(counterspell)
										end
										local silence = NPC.GetAbility(heroes, "drow_ranger_wave_of_silence")
										if silence and Ability.IsReady(silence) and NPC.FindFacingNPC(enemy, nil, Enum.TeamType.TEAM_ENEMY, castrange + 50, 15) == heroes then
											Ability.CastPosition(silence, NPC.GetAbsOrigin(enemy), false)
										end
									end
								end
							end
							for key5, spells in pairs({
								"axe_berserkers_call",
								"axe_culling_blade",
								"crystal_maiden_crystal_nova",
								"crystal_maiden_frostbite",
								"dark_willow_bedlam",
								"lion_impale",
								"lion_voodoo",
								"ogre_magi_fireblast",
								"ogre_magi_unrefined_fireblast",
								"rattletrap_power_cogs",
								"shadow_demon_disruption",
								"slardar_slithereen_crush",
								"vengefulspirit_magic_missile",
								"windrunner_shackleshot",
								"winter_wyvern_winters_curse"
							}) do
								local spell, item = NPC.GetAbility(me, spells), NPC.GetItem(heroes, "item_force_staff", true) or NPC.GetItem(heroes, "item_hurricane_pike", true)
								if Menu.IsKeyDown(dummy.key) and spell and Ability.IsReady(spell) and item and Ability.IsReady(item) and NPC.GetMana(heroes) > Ability.GetManaCost(item) + Ability.GetManaCost(spell) then
									if not NPC.IsEntityInRange(me, enemy, Ability.GetCastRange(spell) + 450) and NPC.FindFacingNPC(heroes, nil, Enum.TeamType.TEAM_ENEMY, Ability.GetCastRange(spell) + 550, 15) == enemy then
										Ability.CastTarget(item, heroes)
									end
								end
								if item and Ability.IsReady(item) then
									if spell == 0 or spell and not Ability.IsReady(spell) or spell and not NPC.IsEntityInRange(heroes, enemy, Ability.GetCastRange(spell)) then
										for c, friend in pairs(Entity.GetHeroesInRadius(heroes, Ability.GetCastRange(item), Enum.TeamType.TEAM_FRIEND)) do
											local tower = dummy.findtower(heroes)
											if friend and Entity.IsAlive(friend) and Entity.GetHealth(friend) / Entity.GetMaxHealth(friend) < 0.3 and not NPC.IsAttacking(friend) and tower and NPC.FindFacingNPC(friend, nil, Enum.TeamType.TEAM_FRIEND, nil, 45) == tower and NPC.IsAttacking(enemy) and NPC.FindFacingNPC(enemy, nil, Enum.TeamType.TEAM_ENEMY, 750, 15) == friend then
												Ability.CastTarget(item, friend)
											end
										end
									end
								end
							end
						end
					end
				end
			end
			local phaseboot = NPC.GetItem(me, "item_phase_boots", true)
			if phaseboot and Ability.IsReady(phaseboot) and NPC.IsRunning(me) and dummy.doubleclicked(Enum.ButtonCode.MOUSE_RIGHT, 0.3) then
				Ability.CastNoTarget(phaseboot)
			end
		end
		for i = 1, PhysicalItems.Count() do
			local item = PhysicalItems.Get(i)
			if item and NPC.IsEntityInRange(me, item, 100) and NPC.HasInventorySlotFree(me, true) then
				local itemName = Ability.GetName(PhysicalItem.GetItem(item))
				if itemName == "item_aegis" or itemName == "item_rapier" or itemName == "item_gem" then
					Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PICKUP_ITEM, item, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, me)
				end
			end
		end
		for i = 1, Runes.Count() do
			local rune = Runes.Get(i)
			if rune and NPC.IsEntityInRange(me, rune, 120) then
				Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PICKUP_RUNE, rune, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, me)
			end
		end
		local shadowdance, shadowamulet = NPC.GetAbility(me, "slark_shadow_dance"), NPC.GetItem(me, "item_shadow_amulet", true)
		if shadowdance and Ability.GetLevel(shadowdance) > 0 and dummy.doubleclicked(Enum.ButtonCode.MOUSE_RIGHT, 0.3) and Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.8 then
			if not dummy.modfilter(me) and not NPC.HasModifier(me, "modifier_slark_shadow_dance_passive_regen") and not NPC.HasModifier(me, "modifier_item_shadow_amulet_fade") and shadowamulet and Ability.IsReady(shadowamulet) then
				Ability.CastTarget(shadowamulet, me)
			end
		end
		if Menu.IsEnabled(dummy.option3) then
			for i, v in pairs({NPC.GetItem(me, "item_recipe_abyssal_blade", false), NPC.GetItem(me, "item_vanguard", false), NPC.GetItem(me, "item_basher", false)}) do
				if v ~= nil and Item.IsCombineLocked(v) then
					Player.PrepareUnitOrders(Players.GetLocal(), 32, v, Vector(0,0,0), v, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, v)
				end
			end
			local slot = 0
			for index = 0, 8 do
				local item = NPC.GetItemByIndex(me, index)
				if item then
					slot = slot + 1
					if slot == 8 or slot == 9 then
						dummy.s1 = "off"
					else
						dummy.s1 = "on"
					end
				end
			end
			for i = 1, NPCs.Count() do
				local npc = NPCs.Get(i)
				if npc and Entity.IsAlive(npc) and NPC.FindFacingNPC(me, nil, Enum.TeamType.TEAM_ENEMY, NPC.GetAttackRange(me) + 50, 45) == npc then
					if NPC.IsHero(npc) or NPC.IsRoshan(npc) then
						dummy.s2 = "on"
					else
						dummy.s2 = "off"
					end
				end
			end
		end
	end
end

function dummy.OnDraw()
	if me then
		for i = 1, Runes.Count() do
			local rune = Runes.Get(i)
			if rune then
				if Rune.GetRuneType(rune) == 0 then icon = "minimap_rune_dd"
				elseif Rune.GetRuneType(rune) == 1 then icon = "minimap_rune_haste"
				elseif Rune.GetRuneType(rune) == 2 then icon = "minimap_rune_illusion"
				elseif Rune.GetRuneType(rune) == 3 then icon = "minimap_rune_invis"
				elseif Rune.GetRuneType(rune) == 4 then icon = "minimap_rune_regen"
				elseif Rune.GetRuneType(rune) == 5 then icon = "minimap_rune_bounty"
				elseif Rune.GetRuneType(rune) == 6 then icon = "minimap_rune_arcane"
				end
				if not dummy.index then
					MiniMap.AddIconByName(dummy.index, icon, Entity.GetAbsOrigin(rune), 255, 255, 255, 255, 1,  Menu.GetValue(dummy.iconsize))
				end
			else
				dummy.index = nil
			end
		end
		for i = 1, NPCs.Count() do
			local npc = NPCs.Get(i)
			if npc and Entity.IsAlive(npc) and not Entity.IsDormant(npc) and (NPC.IsNeutral(npc) or NPC.IsRoshan(npc)) then
				if Entity.GetField(npc, "m_iTaggedAsVisibleByTeam") == 14 then
					if dummy.particle == nil then
						dummy.particle = Particle.Create("particles/items_fx/aura_shivas.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, npc)
						Particle.SetControlPoint(dummy.particle, 1, Vector(100.0, 0.0, 0.0))
					end
				else
					if dummy.particle then
						Particle.Destroy(dummy.particle)
						dummy.particle = nil
					end
				end
			end
		end
	end
end

function dummy.modfilter(ent)
	if not ent then return end
	if NPC.HasModifier(ent, "modifier_truesight") or NPC.HasModifier(ent, "modifier_bounty_hunter_track") or NPC.HasModifier(ent, "modifier_bloodseeker_thirst_vision") or NPC.HasModifier(ent, "modifier_slardar_amplify_damage") or NPC.HasModifier(ent, "modifier_item_dustofappearance") then
		return true
	end
end

function dummy.doubleclicked(key, clickspeed) -- copy foo0oo
    if key and Input.IsKeyDownOnce(key) then
        if os.clock() - dummy.clicktime > clickspeed then
            dummy.clicktime = os.clock()
            return false
        else
            if os.clock() - dummy.clicktime > 0.035 then
                return true
            end
        end
    end
    return false
end

function dummy.gethero()
	for i = 1, NPCs.Count() do
		local npc = NPCs.Get(i)
		if me and npc and me ~= npc and Entity.IsAlive(npc) and not NPC.HasModifier(npc, "modifier_illusion") and Entity.GetOwner(me) == Entity.GetOwner(npc) then
			return npc
		end
	end
end

function dummy.getfountainpos(ent)
	for i = 1, NPCs.Count() do
		local fountain = NPCs.Get(i)
		if fountain and Entity.IsAlive(fountain) and NPC.GetUnitName(fountain) == "dota_fountain" and Entity.IsSameTeam(ent, fountain) then
			return NPC.GetAbsOrigin(fountain)
		end
	end
end


function dummy.findtower(ent)
	for i = 1, NPCs.Count() do
		local tower = NPCs.Get(i)
		if tower and Entity.IsAlive(tower) and NPC.IsTower(tower) and Entity.IsSameTeam(ent, tower) then
			return tower
		end
	end
end

function dummy.OnProjectile(projectile)
	local heroes = dummy.gethero() or me
    if not Menu.IsEnabled(dummy.option) or not projectile and not projectile.target or not heroes then return end
    for a, projlist in pairs({
		"alchemist_unstable_concoction_projectile",
		"bounty_hunter_suriken_toss",
		"chaos_knight_chaos_bolt",
		"dragon_knight_dragon_tail_dragonform_proj",
		"ethereal_blade",
		"medusa_mystic_snake_projectile",
		"medusa_mystic_snake_projectile_initial",
		"morphling_adaptive_strike_agi_proj",
		"nullifier_proj",
		"oracle_fortune_prj",
		"pa_ti8_immortal_stifling_dagger",
		"phantom_assassin_stifling_dagger",
		"phantom_lancer_immortal_ti6_spiritlance",
		"phantomlancer_spiritlance_projectile",
		"skeletonking_hellfireblast",
		"sniper_assassinate",
		"sven_spell_storm_bolt",
		"vengeful_magic_missle",
		"visage_soul_assumption_bolt5",
		"visage_soul_assumption_bolt6",
		"vs_ti8_immortal_magic_missle",
		"windrunner_shackleshot"
	}) do
        if projlist and projectile.name == projlist then
            local item = NPC.GetItem(heroes, "item_lotus_orb", true) or NPC.GetItem(heroes, "item_sphere", true)
            if item and Ability.IsReady(item) and not NPC.IsChannellingAbility(heroes) and not NPC.HasState(heroes, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
                for b, friend in pairs(Entity.GetHeroesInRadius(heroes, Ability.GetCastRange(item), Enum.TeamType.TEAM_FRIEND)) do
                    if friend and Entity.IsAlive(friend) and projectile.target == friend and not NPC.IsLinkensProtected(friend) and not NPC.HasModifier(friend, "modifier_item_lotus_orb_active") then
                        Ability.CastTarget(item, friend)
                    end
				end
				if Ability.GetName(item) == "item_lotus_orb" and projectile.target == heroes and not NPC.IsLinkensProtected(heroes) and not NPC.HasModifier(heroes, "modifier_item_lotus_orb_active") then
					Ability.CastTarget(item, heroes)
				end
			end
			local counterspell = NPC.GetAbility(heroes, "antimage_counterspell") or NPC.GetAbility(heroes, "phantom_assassin_blur")
			if counterspell and Ability.IsReady(counterspell) and projectile.target == heroes then
				Ability.CastNoTarget(counterspell)
			end
			local sleight = NPC.GetAbility(heroes, "ember_spirit_sleight_of_fist")
			if sleight and Ability.IsReady(sleight) and projectile.target == heroes then
				Ability.CastPosition(sleight, Entity.GetAbsOrigin(heroes))
			end
		end
	end
end

function dummy.OnParticleCreate(particle)
	if not me or not particle.entityForModifiers then return end
	if Menu.IsEnabled(dummy.option2) then
		if not NPC.HasState(me, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
			if particle.name == "antimage_blink_start" or particle.name == "blink_dagger_start" or particle.name == "phantom_assassin_phantom_strike_start" or particle.name == "faceless_void_time_walk_slow" then
				if not Entity.IsSameTeam(me, particle.entityForModifiers) then
					for _, spells in pairs({
						{name = "axe_berserkers_call", range = 275},
						{name = "earthshaker_echo_slam", range = 600},
						{name = "enigma_black_hole", range = 420},
						{name = "skywrath_mage_ancient_seal", range = 700},
						{name = "faceless_void_chronosphere", range = 425},
						{name = "magnataur_reverse_polarity", range = 410},
						{name = "lion_voodoo", range = 500},
						{name = "item_abyssal_blade", range = 150},
						{name = "item_manta", range = 150},
						{name = "item_sheepstick", range = 800}
					}) do
						local spell = NPC.GetAbility(particle.entityForModifiers, spells.name) or NPC.GetItem(particle.entityForModifiers, spells.name, true)
						if spell and Ability.IsReady(spell) then
							if  Ability.GetName(spell) == "axe_berserkers_call" and NPC.GetAbility(particle.entityForModifiers, "special_bonus_unique_axe_2") and Ability.GetLevel(NPC.GetAbility(particle.entityForModifiers, "special_bonus_unique_axe_2")) > 0 then
								spells.range = 375
							end
							if  Ability.GetName(spell) == "faceless_void_chronosphere" and NPC.GetAbility(particle.entityForModifiers, "special_bonus_unique_faceless_void_2") and Ability.GetLevel(NPC.GetAbility(particle.entityForModifiers, "special_bonus_unique_faceless_void_2")) > 0 then
								spells.range = 600
							end
							if NPC.IsEntityInRange(me, particle.entityForModifiers, spells.range) then
								local modifier = NPC.HasModifier(particle.entityForModifiers, "modifier_antimage_counterspell") or NPC.HasState(particle.entityForModifiers, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or NPC.HasModifier(particle.entityForModifiers, "modifier_item_lotus_orb_active") or NPC.IsLinkensProtected(particle.entityForModifiers)
								local disableitem = NPC.GetItem(me, "item_cyclone", true) or NPC.GetItem(me, "item_sheepstick", true) or NPC.GetItem(me, "item_abyssal_blade", true) or NPC.GetAbility(me, "rubick_telekinesis")
								if disableitem and Ability.IsReady(disableitem) and NPC.IsEntityInRange(me, particle.entityForModifiers, Ability.GetCastRange(disableitem)) and not modifier then
									Ability.CastTarget(disableitem, particle.entityForModifiers)
								end
								if disableitem == nil or disableitem and not Ability.IsReady(disableitem) or disableitem and not NPC.IsEntityInRange(me, particle.entityForModifiers, Ability.GetCastRange(disableitem)) or modifier then
									local blink = NPC.GetItem(me, "item_blink", true)
									if blink and Ability.IsReady(blink) then
										dummy.castposition(me, blink, dummy.getfountainpos(me), 1199)
									end
									local lightning = NPC.GetAbility(me, "storm_spirit_ball_lightning")
									if lightning and Ability.IsReady(lightning) then
										dummy.castposition(me, lightning, dummy.getfountainpos(me), spells.range + 350)
									end
									local doppelwalk = NPC.GetAbility(me, "phantom_lancer_doppelwalk")
									if doppelwalk and Ability.IsReady(doppelwalk) then
										dummy.castposition(me, doppelwalk, dummy.getfountainpos(me), 600)
									end
									local silence = NPC.GetAbility(me, "drow_ranger_wave_of_silence")
									if silence and Ability.IsReady(silence) then
										Ability.CastPosition(silence, NPC.GetAbsOrigin(particle.entityForModifiers), false)
									end
									local strike = NPC.GetAbility(me, "phantom_assassin_phantom_strike")
									if strike and Ability.IsReady(strike) then
										for _, npc in pairs(Entity.GetUnitsInRadius(me, 1000, Enum.TeamType.TEAM_FRIEND)) do
											if npc and not NPC.IsEntityInRange(npc, particle.entityForModifiers, spells.range + 50) then
												if NPC.IsHero(npc) or NPC.IsCreep(npc) then
													Ability.CastTarget(strike, npc)
												end
											end
										end
									end
									local glimmercape = NPC.GetItem(me, "item_glimmer_cape", true) or NPC.GetItem(me, "item_shadow_amulet", true)
									if glimmercape and Ability.IsReady(glimmercape) then
										Ability.CastTarget(glimmercape, me)
									end
									local sword = NPC.GetItem(me, "item_invis_sword", true) or NPC.GetItem(me, "item_silver_edge", true)
									if sword and Ability.IsReady(sword) then
										Ability.CastNoTarget(sword)
									end
									local pos = Entity.GetAbsOrigin(particle.entityForModifiers)
									local pos1 = Entity.GetAbsOrigin(me)
									local finded = false
									local shackle = NPC.GetAbility(me, "windrunner_shackleshot")
									if shackle and Ability.IsReady(shackle) then
										for key, tree in ipairs(Trees.InRadius(pos, 575, true)) do
											if tree then 
												local treepos = Entity.GetAbsOrigin(tree)
												local X = tonumber(string.format("%.1f", (treepos:GetX()-pos:GetX())/(pos1:GetX()-pos:GetX())))
												local Y = tonumber(string.format("%.1f", (treepos:GetY()-pos:GetY())/(pos1:GetY()-pos:GetY())))
												if X < 0 and Y < 0 and math.abs(X-Y) < 0.5 then finded = true end
											end
										end
										for key, enemy in ipairs(Entity.GetUnitsInRadius(me, 1375 ,Enum.TeamType.TEAM_ENEMY)) do
											if enemy and Entity.IsAlive(enemy) and NPC.IsVisible(enemy) then 
												local enemypos = Entity.GetAbsOrigin(enemy)
												local X = tonumber(string.format("%.1f", (enemypos:GetX()-pos:GetX())/(pos1:GetX()-pos:GetX())))
												local Y = tonumber(string.format("%.1f", (enemypos:GetY()-pos:GetY())/(pos1:GetY()-pos:GetY())))
												if X < 0 and Y < 0 and math.abs(X-Y) < 0.5 then finded = true end
											end
										end
										if finded == true then
											Ability.CastTarget(shackle, particle.entityForModifiers)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if Menu.IsEnabled(dummy.option3) then
		if particle.entityForModifiers == me and particle.name == "generic_minibash" and Entity.IsAlive(me) then
			local item = NPC.GetItem(me, "item_abyssal_blade", false)
			if item ~= nil and dummy.s1 == "on" and dummy.s2 == "on" then
				Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_DISASSEMBLE_ITEM, item, Vector(0,0,0), item, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, item)
			end
		end
	end
end

function dummy.castposition(ent, spell, pos, range)
    local dir = pos - NPC.GetAbsOrigin(ent)
    dir:SetZ(0)
    dir:Normalize()
    dir:Scale(range)
    local destination = NPC.GetAbsOrigin(ent) + dir
    Ability.CastPosition(spell, destination, false)
end

return dummy
