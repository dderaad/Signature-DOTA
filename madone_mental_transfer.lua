function MentalTransfer( keys )
	-- Deals additional pure damage as a function of Prognos' missing mana
	-- Setup
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local ability_level = ability:GetLevel() - 1

	local maximumMana = caster:GetMaxMana()
	local currentMana = caster:GetMana()
	local manaDifferential = maximumMana - currentMana
	local percentAsDamage = ability:GetLevelSpecialValueFor("percent_damage", ability_level)

	local damage = percentAsDamage * manaDifferential / 100.0

	local damage_table = {}
 	damage_table.victim = target
 	damage_table.attacker = caster
 	damage_table.ability = ability
 	damage_table.damage_type = DAMAGE_TYPE_PURE
 	damage_table.damage = damage

 	ApplyDamage(damage_table)
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