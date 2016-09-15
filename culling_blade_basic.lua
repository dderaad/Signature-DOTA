function CullingBlade( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Sound variables
	local sound_fail = keys.sound_fail
	local sound_success = keys.sound_success

	-- Particle
	local particle_kill = keys.particle_kill

	-- HP/Mana Regen
	local modifier_cull = keys.modifier_cull

	-- Ability variables
	local kill_threshold = ability:GetLevelSpecialValueFor("kill_threshold", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	-- Initializing the hero, creep damage tables
	local hero_damage_table = {}
 	hero_damage_table.victim = target
 	hero_damage_table.attacker = caster
 	hero_damage_table.ability = ability
 	hero_damage_table.damage_type = ability:GetAbilityDamageType()
 	hero_damage_table.damage = damage

 	local creep_damage_table = {}
 	creep_damage_table.victim = target
 	creep_damage_table.attacker = caster
 	creep_damage_table.ability = ability
 	creep_damage_table.damage_type = DAMAGE_TYPE_PURE
 	creep_damage_table.damage = damage

 	local isSuccess = false

	if target:IsCreep() then
		if target:GetHealth() / target:GetMaxHealth() < 0.5 then
			creep_damage_table.damage = target:GetHealth()
			isSuccess = true
		else
			creep_damage_table.damage = target:GetMaxHealth() * 0.25
		end
		ApplyDamage( creep_damage_table )
	else 
		if target:GetHealth() <= kill_threshold then
			hero_damage_table.damage = kill_threshold
			hero_damage_table.damage_type = DAMAGE_TYPE_PURE
			isSuccess = true

		ApplyDamage( hero_damage_table )
		end
	end
	
	if isSuccess then
		-- Play the kill particle
		local culling_kill_particle = ParticleManager:CreateParticle(particle_kill, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:ReleaseParticleIndex(culling_kill_particle)

		-- Play the sound
		caster:EmitSound(sound_success)

		-- Apply the Modifier
		ability:ApplyDataDrivenModifier(caster, caster, modifier_cull, {})
	else
		-- If its not equal or below the threshold then play the failure sound
		caster:EmitSound(sound_fail)
	end
end