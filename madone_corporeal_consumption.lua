function CorporealConsumption( keys )
	-- Setup
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local modifier = keys.modifier
	local ability_level = ability:GetLevel() - 1

	local manaMultiplier = ability:GetLevelSpecialValueFor("mana_multiplier", ability_level)
	local baseDuration = ability:GetLevelSpecialValueFor("base_duration", ability_level)

	local maximumMana = caster:GetMaxMana()
	local currentMana = caster:GetMana()
	local manaDifferential = maximumMana - currentMana

	target:ApplyDataDrivenModifier( 
		caster, target, modifier, {duration =
		base_duration + mana_multiplier * manaDifferential / maximumMana} )
end

function ManaCost( keys )
	-- Setup
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local modifier = keys.modifier
	local ability_level = ability:GetLevel() - 1

	local maximumMana = caster:GetMaxMana()
	local currentMana = caster:GetMana()
	local manaDifferential = maximumMana - currentMana

	-- Percent Mana Cost
 	local mana_cost = manaDifferential * ability:GetLevelSpecialValueFor("percent_mana", ability_level) / 100.0

 	SpendMana( mana_cost, ability )
end