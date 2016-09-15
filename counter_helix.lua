function counter_helix_start_charge( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	caster.counter_helix_maximum_charges = ability:GetLevelSpecialValueFor( "maximum_charges", ( ability_level ) )

	-- Ensures only level 1 and above get charges
	if keys.ability:GetLevel() ~= 1 then return end


	local modifierName = "modifier_counter_helix_stack_counter_datadriven"
	local charge_replenish_time = ability:GetLevelSpecialValueFor( "charge_replenish_time", ( ability_level ) )

	-- Initialize stack
	caster:SetModifierStackCount( modifierName, ability, 0 )
	caster.counter_helix_charges = caster.counter_helix_maximum_charges
	caster.start_charge = false
	caster.counter_helix_cooldown = 0.0

	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( modifierName, ability, caster.counter_helix_maximum_charges )

	-- create timer to restore stack
	Timers:CreateTimer( function()
			-- Restore charge
			if caster.start_charge and caster.counter_helix_charges < caster.counter_helix_maximum_charges then
				-- Calculate stacks
				local next_charge = caster.counter_helix_charges + 1
				caster:RemoveModifierByName( modifierName )
				if next_charge ~= caster.counter_helix_maximum_charges then
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
					counter_helix_start_cooldown( caster, charge_replenish_time )
				else
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
					caster.start_charge = false
				end
				caster:SetModifierStackCount( modifierName, ability, next_charge )
				
				-- Update stack
				caster.counter_helix_charges = next_charge
			end

			--Ensure no cooldown if a charge is available
			if caster.counter_helix_charges > 0 then
				ability:EndCooldown()
			end
			
			-- Check if max is reached then check every 0.5 seconds if the charge is used
			if caster.counter_helix_charges ~= caster.counter_helix_maximum_charges then
				caster.start_charge = true
				-- On level up refresh the modifier
				ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
				return charge_replenish_time
			else
				return 0.5
			end
		end
	)
end

--[[
	Author: kritth
	Date: 6.1.2015.
	Helper: Create timer to track cooldown
]]
function counter_helix_start_cooldown( caster, charge_replenish_time )
	caster.counter_helix_cooldown = charge_replenish_time
	Timers:CreateTimer( function()
			local current_cooldown = caster.counter_helix_cooldown - 0.1
			if current_cooldown > 0.1 then
				caster.counter_helix_cooldown = current_cooldown
				return 0.1
			else
				return nil
			end
		end
	)
end

function CounterHelix( keys )
	if keys.caster.counter_helix_charges > 0 then
		local caster = keys.caster
		local target = keys.target
		local ability = keys.ability
		local modifierName = "modifier_counter_helix_stack_counter_datadriven"
		local maximum_charges = ability:GetLevelSpecialValueFor( "maximum_charges", ( ability:GetLevel() - 1 ) )
		local charge_replenish_time = ability:GetLevelSpecialValueFor( "charge_replenish_time", ( ability:GetLevel() - 1 ) )


		-- Deplete charge
		local next_charge = caster.counter_helix_charges - 1
		if caster.counter_helix_charges == maximum_charges then
			caster:RemoveModifierByName( modifierName )
			ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
			counter_helix_start_cooldown( caster, charge_replenish_time )
		end
		caster:SetModifierStackCount( modifierName, caster, next_charge )
		caster.counter_helix_charges = next_charge
		
		-- Check if stack is 0, display ability cooldown
		if caster.counter_helix_charges == 0 then
			-- Start Cooldown from caster.counter_helix_cooldown
			ability:StartCooldown( caster.counter_helix_cooldown )
		else
			ability:EndCooldown()
		end
	else
		keys.ability:RefundManaCost()
	end
end