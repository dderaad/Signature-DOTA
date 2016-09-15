--[[Manages the stack count of the target]]
function ChillingTouchIncrement( keys )
	local caster = keys.caster
	local target = keys.target
	local buff_duration = keys.duration
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack
	local max_stacks = keys.maximum_stacks

	local ability_level = ability:GetLevel() - 1
	local max_attacks = ability:GetLevelSpecialValueFor("max_attacks", ability_level)

	-- Get the current stack count
	local current_stack = target:GetModifierStackCount(modifier_stack, ability)

	-- If its 0 then apply the modifier, increase the stack number by 1 if less than the maximum.
	if current_stack == 0 then
		ability:ApplyDataDrivenModifier(caster, target, modifier_stack, { duration = -1 })
	end
	if current_stack < max_attacks then
		target:SetModifierStackCount(modifier_stack, ability, current_stack + 1)
	end
end

--[[Author: Pizzalol
	Date: 14.02.2015.
	Manages the stack count of the target]]
function ChillingTouchDecrement( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.target
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Because this function can be used either by the desctruction of the projectile via attack or natural decay
	if attacker == nil then
		attacker = target
	end

	-- Get the current stack count
	local current_stack = attacker:GetModifierStackCount(modifier_stack, ability)

	-- If its 1 then remove the modifier entirely, otherwise just reduce the stack number by 1
	if current_stack <= 1 then
		attacker:RemoveModifierByNameAndCaster(modifier_stack, caster)
	else
		attacker:SetModifierStackCount(modifier_stack, ability, current_stack - 1)
	end

end