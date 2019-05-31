-- Editors:
--    Fudge: 23.08.2017 (Ravage)
--    AltiV, May 29th, 2019 (true IMBAfication)

LinkLuaModifier("modifier_imba_tidehunter_gush", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_gush_surf", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_HORIZONTAL)

LinkLuaModifier("modifier_imba_tidehunter_kraken_shell", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_kraken_shell_backstroke", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_tidehunter_anchor_smash", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_anchor_smash_suppression", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_anchor_smash_handler", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_anchor_smash_throw", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)

imba_tidehunter_gush								= class({})
modifier_imba_tidehunter_gush						= class({})
modifier_imba_tidehunter_gush_surf					= class({})

imba_tidehunter_kraken_shell						= class({})
modifier_imba_tidehunter_kraken_shell				= class({})
modifier_imba_tidehunter_kraken_shell_backstroke	= class({})

imba_tidehunter_anchor_smash						= class({})
modifier_imba_tidehunter_anchor_smash				= class({})
modifier_imba_tidehunter_anchor_smash_suppression	= class({})
modifier_imba_tidehunter_anchor_smash_handler		= class({})
modifier_imba_tidehunter_anchor_smash_throw			= class({})

 -- Gush
-- Killing enemy
-- 25% chance

    -- Think of it as caviar.
    -- You've got guts.

-- Ravage
-- Killing enemy
-- 25% chance

    -- Ravaged!
    -- You look ravaged.

----------
-- GUSH --
----------

function imba_tidehunter_gush:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_POINT
	else
		return self.BaseClass.GetBehavior(self)
	end
end

function imba_tidehunter_gush:OnSpellStart()
	self:GetCaster():EmitSound("Ability.GushCast")

	-- Standard ability logic
	if not self:GetCaster():HasScepter() then	
		local projectile =
		{
			Target 				= self:GetCursorTarget(),
			Source 				= self:GetCaster(),
			Ability 			= self,
			EffectName 			= "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf",
			iMoveSpeed			= self:GetSpecialValueFor("projectile_speed"),
			vSourceLoc 			= self:GetCaster():GetAbsOrigin(),
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10.0,
			bProvidesVision 	= false,
			
			iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, -- Need to put the mouth?
			
			ExtraData = {bScepter = 0}
		}
		
		ProjectileManager:CreateTrackingProjectile(projectile)
	
	-- Scepter ability logic
	else		
		-- This "dummy" literally only exists to attach the gush travel sound to
		local gush_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		gush_dummy:EmitSound("Hero_Tidehunter.Gush.AghsProjectile")
		
		local linear_projectile = {
			Ability				= self,
			EffectName			= "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf", -- Might not do anything
			vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
			fDistance			= self:GetSpecialValueFor("cast_range_scepter") + GetCastRangeIncrease(self:GetCaster()),
			fStartRadius		= self:GetSpecialValueFor("aoe_scepter"),
			fEndRadius			= self:GetSpecialValueFor("aoe_scepter"),
			Source				= self:GetCaster(),
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= true,
			vVelocity			= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed_scepter"),
			bProvidesVision		= false,
			
			ExtraData			= {bScepter = 1, gush_dummy = gush_dummy:entindex()}
		}
		self.projectile = ProjectileManager:CreateLinearProjectile(linear_projectile)
	end
	
			-- "01"
			-- {
				-- "var_type"			"FIELD_INTEGER"
				-- "gush_damage"		"110 160 210 260"
				-- "LinkedSpecialBonus"	"special_bonus_unique_tidehunter_2"
			-- }
			-- "02"
			-- {
				-- "var_type"			"FIELD_INTEGER"
				-- "projectile_speed"	"2500"
			-- }
			-- "03"
			-- {
				-- "var_type"			"FIELD_INTEGER"
				-- "movement_speed"	"-40 -40 -40 -40"
			-- }
			-- "04"
			-- {
				-- "var_type"			"FIELD_FLOAT"
				-- "negative_armor"		"4 5 6 7"
				-- "LinkedSpecialBonus"	"special_bonus_unique_tidehunter"
			-- }
			-- "05"
			-- {
				-- "var_type"			"FIELD_INTEGER"
				-- "speed_scepter"		"1500"
			-- }
			-- "06"
			-- {
				-- "var_type"			"FIELD_INTEGER"
				-- "aoe_scepter"		"260"
			-- }
			-- "07"
			-- {
				-- "var_type"			"FIELD_INTEGER"
				-- "cooldown_scepter"		"7"
			-- }
			-- "08"
			-- {
				-- "var_type"			"FIELD_INTEGER"
				-- "cast_range_scepter"		"2200"
			-- }
end

-- Make the travel sound follow the Gush
function imba_tidehunter_gush:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end
	
	if data.gush_dummy then
		EntIndexToHScript(data.gush_dummy):SetAbsOrigin(location)
	end
end

function imba_tidehunter_gush:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end
	
	-- Gush hit some unit
	if target then 
		-- Trigger spell absorb if applicable
		if data.bScepter == 0 and target:TriggerSpellAbsorb(self) then
			return nil
		end

		target:EmitSound("Ability.GushImpact")

		-- "Gush first applies the debuff, then the damage."
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_gush", {duration = self:GetDuration()}):SetDuration(self:GetDuration() * (1 - target:GetStatusResistance()), true)

		-- "Provides 200 radius ground vision around each hit enemy for 2 seconds."
		if data.bScepter == 1 then
			self:CreateVisibilityNode(target:GetAbsOrigin(), 200, 2)
		end

		local damageTable = {
			victim 			= target,
			damage 			= self:GetTalentSpecialValueFor("gush_damage"),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}

		ApplyDamage(damageTable)
		
	-- Scepter Gush has reached its end location
	elseif data.gush_dummy then
		EntIndexToHScript(data.gush_dummy):StopSound("Hero_Tidehunter.Gush.AghsProjectile")
		EntIndexToHScript(data.gush_dummy):RemoveSelf()
	end
end


-- "Ability.GushCast"
-- "Ability.GushImpact"
-- "Hero_Tidehunter.Gush.AghsProjectile"
-- "Hero_Tidehunter.KrakenShell"
-- "Hero_Tidehunter.AnchorSmash"
-- "Ability.Ravage"
-- "Hero_Tidehunter.RavageDamage"

-------------------
-- GUSH MODIFIER --
-------------------

function modifier_imba_tidehunter_gush:GetEffectName()
	return "particles/units/heroes/hero_tidehunter/tidehunter_gush_slow.vpcf"
end

function modifier_imba_tidehunter_gush:GetStatusEffectName()
	return "particles/status_fx/status_effect_gush.vpcf"
end

function modifier_imba_tidehunter_gush:OnCreated()
	if self:GetAbility() then
		self.movement_speed	= self:GetAbility():GetSpecialValueFor("movement_speed")
		self.negative_armor	= self:GetAbility():GetTalentSpecialValueFor("negative_armor")
	else
		self:Destroy()
	end
end

function modifier_imba_tidehunter_gush:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tidehunter_gush:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	
	return decFuncs
end

function modifier_imba_tidehunter_gush:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end

function modifier_imba_tidehunter_gush:GetModifierPhysicalArmorBonus()
	return self.negative_armor * (-1)
end

------------------------
-- GUSH SURF MODIFIER --
------------------------

modifier_imba_tidehunter_gush_surf						= class({})

------------------
-- KRAKEN SHELL --
------------------

function imba_tidehunter_kraken_shell:GetIntrinsicModifierName()	
	return "modifier_imba_tidehunter_kraken_shell"
end

---------------------------
-- KRAKEN SHELL MODIFIER --
---------------------------

function modifier_imba_tidehunter_kraken_shell:IsHidden()	return not (self:GetAbility() and self:GetAbility():GetLevel() >= 1) end

function modifier_imba_tidehunter_kraken_shell:OnCreated()
	if not IsServer() then return end
	
	self.reset_timer	= GameRules:GetDOTATime(true, true)
	self:SetStackCount(0)
	
	self:StartIntervalThink(0.1)
end

-- This is to keep tracking of the damage reset interval
function modifier_imba_tidehunter_kraken_shell:OnIntervalThink()
	if not IsServer() then return end
	
	if GameRules:GetDOTATime(true, true) - self.reset_timer >= self:GetAbility():GetSpecialValueFor("damage_reset_interval") then
		self:SetStackCount(0)
		self.reset_timer = GameRules:GetDOTATime(true, true)
	end
end

function modifier_imba_tidehunter_kraken_shell:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT, -- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK -- GetModifierPhysical_ConstantBlock
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
		
		
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	
	return decFuncs
end

function modifier_imba_tidehunter_kraken_shell:GetModifierIncomingPhysicalDamageConstant()
	return self:GetAbility():GetTalentSpecialValueFor("damage_reduction") * (-1)
end

function modifier_imba_tidehunter_kraken_shell:OnTakeDamage(keys)
	if keys.unit == self:GetParent() and not keys.attacker:IsOther() and (keys.attacker:GetOwnerEntity() or keys.attacker.GetPlayerID) and not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() and self:GetAbility():IsTrained() then
		self:SetStackCount(self:GetStackCount() + keys.damage)
		self.reset_timer = GameRules:GetDOTATime(true, true)
		
		if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("damage_cleanse") then
			self:GetParent():EmitSound("Hero_Tidehunter.KrakenShell")
			
			local kraken_shell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:ReleaseParticleIndex(kraken_shell_particle)
		
			self:GetParent():Purge(false, true, false, true, true)
			
			self:SetStackCount(0)
		end
	end
end

function modifier_imba_tidehunter_kraken_shell:GetModifierBonusStats_Strength()
	if self:GetParent():GetAbsOrigin().z < 160 and not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("aqueous_strength")
	end
end

function modifier_imba_tidehunter_kraken_shell:GetModifierHealthRegenPercentage()
	if self:GetParent():GetAbsOrigin().z < 160 and not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("aqueous_heal")
	end
end

-- function modifier_imba_tidehunter_kraken_shell:GetOverrideAnimation()
	-- if self:GetParent():GetAbsOrigin().z < 160 then return ACT_DOTA_TAUNT end
-- end

-- function modifier_imba_tidehunter_kraken_shell:GetActivityTranslationModifiers()
	-- if self:GetParent():GetAbsOrigin().z < 160 then return "backstroke_gesture" end
-- end

			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "damage_reduction"		"12 24 36 48"
				-- "LinkedSpecialBonus"	"special_bonus_unique_tidehunter_4"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "damage_cleanse"		"600 550 500 450"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "damage_reset_interval"	"6.0 6.0 6.0 6.0"
			-- }

--------------------------------------
-- KRAKEN SHELL BACKSTROKE MODIFIER --
--------------------------------------

modifier_imba_tidehunter_kraken_shell_backstroke		= class({})

------------------
-- ANCHOR SMASH --
------------------

function imba_tidehunter_anchor_smash:GetCastRange(location, target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_anchor_smash_handler", self:GetCaster()) == 0 then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("throw_range")
	end
end

function imba_tidehunter_anchor_smash:GetBehavior()
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_anchor_smash_handler", self:GetCaster()) == 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_tidehunter_anchor_smash:GetAOERadius()
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_anchor_smash_handler", self:GetCaster()) == 0 then
		return 0
	else
		return 175
	end
end

function imba_tidehunter_anchor_smash:GetIntrinsicModifierName()
	return "modifier_imba_tidehunter_anchor_smash_handler"
end

function imba_tidehunter_anchor_smash:OnSpellStart()
	if self:GetAutoCastState() then
		local anchor_dummy = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_tidehunter_anchor_smash_throw", 
		{
			x = self:GetCursorPosition().x,
			y = self:GetCursorPosition().y,
			z = self:GetCursorPosition().z
		}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		
		local linear_projectile = {
			Ability				= self,
			-- EffectName			= "nil"
			vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
			fDistance			= self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()),
			fStartRadius		= 175,
			fEndRadius			= 175,
			Source				= self:GetCaster(),
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= true,
			vVelocity			= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("throw_speed"),
			bProvidesVision		= false,
			
			ExtraData			= {anchor_dummy = anchor_dummy:entindex()}
		}
		
		ProjectileManager:CreateLinearProjectile(linear_projectile)
	else
		self:GetCaster():EmitSound("Hero_Tidehunter.AnchorSmash")
		
		local anchor_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(anchor_particle)
		
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false) -- IMBAfication: Sheer Force
		
		for _, enemy in pairs(enemies) do
			self:Smash(enemy)
		end
	end
end

function imba_tidehunter_anchor_smash:Smash(enemy, bThrown)
	if not enemy:IsRoshan() then
		if bThrown and enemy:IsConsideredHero() then
			self:GetCaster():EmitSound("Hero_Tidehunter.AnchorSmash")
		end
		
		-- The smash first applies the debuff, then the instant attack.
		if not enemy:IsMagicImmune() then
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_anchor_smash", {duration = self:GetSpecialValueFor("reduction_duration")}):SetDuration(self:GetSpecialValueFor("reduction_duration") * (1 - enemy:GetStatusResistance()), true)
		end
		
		-- "These instant attacks are allowed to trigger attack modifiers, except cleave, normally. Has True Strike."
		-- So funny thing about this actually...the VANILLA ability ignores CUSTOM cleave suppression (ex. Jarnbjorn), which means Anchor Smash still applies custom cleaves anyways...so I guess in ways this is actually nerfing the ability but bleh
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_anchor_smash_suppression", {})
		-- PerformAttack(target: CDOTA_BaseNPC, useCastAttackOrb: bool, processProcs: bool, skipCooldown: bool, ignoreInvis: bool, useProjectile: bool, fakeAttack: bool, neverMiss: bool): nil
		self:GetCaster():PerformAttack(enemy, false, true, true, false, false, false, true)
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_tidehunter_anchor_smash_suppression", self:GetCaster())
		
		-- IMBAfication: Angled
		if not bThrown then
			enemy:SetForwardVector(enemy:GetForwardVector() * (-1))
			enemy:FaceTowards(enemy:GetAbsOrigin() + enemy:GetForwardVector())
		end
	end
end

function imba_tidehunter_anchor_smash:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end
	
	EntIndexToHScript(data.anchor_dummy):SetAbsOrigin(location)
end

function imba_tidehunter_anchor_smash:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end
	
	-- Gush hit some unit
	if target then 
		self:Smash(target, true)
	else
		EntIndexToHScript(data.anchor_dummy):RemoveSelf()
	end
end

---------------------------
-- ANCHOR SMASH MODIFIER --
---------------------------

function modifier_imba_tidehunter_anchor_smash:OnCreated()
	if self:GetAbility() then
		self.damage_reduction	= self:GetAbility():GetTalentSpecialValueFor("damage_reduction")
	else
		self:Destroy()
	end
end

function modifier_imba_tidehunter_anchor_smash:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tidehunter_anchor_smash:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
	
	return decFuncs
end

function modifier_imba_tidehunter_anchor_smash:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction
end

---------------------------------------
-- ANCHOR SMASH SUPPRESSION MODIFIER --
---------------------------------------

-- I guess this will also be used for the bonus attack damage

function modifier_imba_tidehunter_anchor_smash_suppression:OnCreated()
	if self:GetAbility() then
		self.attack_damage	= self:GetAbility():GetSpecialValueFor("attack_damage")
	else
		self:Destroy()
	end
end

 -- MODIFIER_PROPERTY_SUPPRESS_CLEAVE does not work
function modifier_imba_tidehunter_anchor_smash_suppression:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SUPPRESS_CLEAVE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
	
	return decFuncs
end

function modifier_imba_tidehunter_anchor_smash_suppression:GetModifierPreAttack_BonusDamage()
	return self.attack_damage
end

function modifier_imba_tidehunter_anchor_smash_suppression:GetSuppressCleave()
	return 1
end

-- Hopefully this is enough random information to only suppress cleaves?...
function modifier_imba_tidehunter_anchor_smash_suppression:GetModifierTotalDamageOutgoing_Percentage(keys)
	if not keys.no_attack_cooldown and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.damage_flags == DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
		return -100
	end
end

--------------------------
-- ANCHOR SMASH HANDLER --
--------------------------

function modifier_imba_tidehunter_anchor_smash_handler:IsHidden()	return true end

function modifier_imba_tidehunter_anchor_smash_handler:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ORDER}
	
	return decFuncs
end

function modifier_imba_tidehunter_anchor_smash_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

---------------------------------
-- ANCHOR SMASH THROW MODIFIER --
---------------------------------

function modifier_imba_tidehunter_anchor_smash_throw:OnCreated(params)
	if not IsServer() then return end

	local models = {
		"models/items/tidehunter/tidehunter_fish_skeleton_lod.vmdl",
		"models/items/tidehunter/tidehunter_mine_lod.vmdl",
		"models/items/tidehunter/ancient_leviathan_weapon/ancient_leviathan_weapon_fx.vmdl",
		"models/items/tidehunter/claddish_cudgel/claddish_cudgel.vmdl",
		"models/items/tidehunter/claddish_cudgel/claddish_cudgel_octopus.vmdl",
		"models/items/tidehunter/krakens_bane/krakens_bane.vmdl",
		"models/items/tidehunter/living_iceberg_collection_weapon/living_iceberg_collection_weapon.vmdl",
		"models/items/tidehunter/ti_9_cache_tide_chelonia_mydas_off_hand/ti_9_cache_tide_chelonia_mydas_off_hand.vmdl",
		"models/items/tidehunter/ti_9_cache_tide_chelonia_mydas_weapon/ti_9_cache_tide_chelonia_mydas_weapon.vmdl",
		"models/items/tidehunter/ti_9_cache_tide_tidal_conqueror_off_hand/ti_9_cache_tide_tidal_conqueror_off_hand.vmdl",
		"models/items/tidehunter/ti_9_cache_tide_tidal_conqueror_weapon/ti_9_cache_tide_tidal_conqueror_weapon.vmdl",
		"models/items/tidehunter/tidebreaker_weapon/tidebreaker_weapon.vmdl"
	}
	
	-- Some models are originally oriented in a different way, so they have to be flipped to look proper
	local models_rotate = {
		180,
		180,
		180,
		0,
		180,
		0,
		0,
		180,
		0, 
		180,
		0,
		0
	}
	
	local randomSelection	= RandomInt(1, #models)
	local cursorPosition	= Vector(params.x, params.y, params.z)
	
	self.selected_model = models[randomSelection]
	self:GetParent():SetForwardVector(RotatePosition(Vector(0, 0, 0), QAngle(0, models_rotate[randomSelection], 0), ((cursorPosition - self:GetCaster():GetAbsOrigin()):Normalized())))
end

function modifier_imba_tidehunter_anchor_smash_throw:CheckState()
	local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	
	return state
end

function modifier_imba_tidehunter_anchor_smash_throw:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
	
	return decFuncs
end

function modifier_imba_tidehunter_anchor_smash_throw:GetModifierModelChange()
	return self.selected_model or "models/heroes/tidehunter/tidehunter_anchor.vmdl"
end

function modifier_imba_tidehunter_anchor_smash_throw:GetVisualZDelta()
	return 150
end

-----------------------------
------ 	   RAVAGE	  -------
-----------------------------
imba_tidehunter_ravage = imba_tidehunter_ravage or class({})

-- TODO: Destroy the knockback modifier after it's done
-- TODO: add a phased modifier for 0.5 secs
-- TODO: fix nyx stun animation too

function imba_tidehunter_ravage:OnSpellStart()
	-- Ability properties
	local caster			=	self:GetCaster()
	local caster_pos		=	caster:GetAbsOrigin()
	local cast_sound		=	"Ability.Ravage"
	local hit_sound			=	"Hero_Tidehunter.RavageDamage"
	local kill_responses	=	"tidehunter_tide_ability_ravage_0"
	local particle 			=	"particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf"
	-- Ability parameters
	local end_radius	=	self:GetSpecialValueFor("radius")
	local damage		=	self:GetSpecialValueFor("damage")
	local stun_duration	=	self:GetSpecialValueFor("duration")

	-- Emit sound
	caster:EmitSound(cast_sound)

	-- Emit particle
	self.particle_fx	=	ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(self.particle_fx, 0, caster_pos)
	-- Set each ring in it's position
	for i=1, 5 do
		ParticleManager:SetParticleControl(self.particle_fx, i, Vector(end_radius * 0.2 * i, 0 , 0))
	end
	ParticleManager:ReleaseParticleIndex(self.particle_fx)

	local radius =	end_radius * 0.2
	local ring	 =	1
	local ring_width = end_radius * 0.2
	local hit_units	=	{}

	-- Find units in a ring 5 times and hit them with ravage
	Timers:CreateTimer(function()
		local enemies =	FindUnitsInRing(caster:GetTeamNumber(),
			caster_pos,
			nil,
			ring * radius,
			radius,
			self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false
		)

		for _,enemy in pairs(enemies) do
			-- Custom function, checks if the unit was hit already
			if not CheckIfInTable(hit_units, enemy) then
				-- Emit hit sound
				enemy:EmitSound(hit_sound)

				-- Apply stun and air time modifiers
				enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration}):SetDuration(stun_duration * (1 - enemy:GetStatusResistance()), true)

				-- Knock the enemy into the air
				local knockback =
				{
						knockback_duration = 0.5,
					duration = 0.5,
					knockback_distance = 0,
					knockback_height = 350,
				}
				enemy:RemoveModifierByName("modifier_knockback")
				enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)

				Timers:CreateTimer(0.5, function()
					-- Apply damage
					local damageTable = {victim = enemy,
						damage = damage,
						damage_type = self:GetAbilityDamageType(),
						attacker = caster,
						ability = self
					}
					ApplyDamage(damageTable)

					-- Check if the enemy is a dead hero, if he is, emit kill response
					if not enemy:IsAlive() and enemy:IsHero() and RollPercentage(25) and caster:GetName() == "npc_dota_hero_tidehunter" then
						caster:EmitSound(kill_responses..RandomInt(1, 2))
					end

					-- We need to do this because the gesture takes it's fucking time to stop
					enemy:RemoveGesture(ACT_DOTA_FLAIL)
				end)

				-- Mark the enemy as hit to not get hit again
				table.insert(hit_units, enemy)
			end
		end

		-- Send the next ring
		if ring < 5 then
			ring = ring + 1
			return 0.2
		end
	end)
end

function imba_tidehunter_ravage:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
