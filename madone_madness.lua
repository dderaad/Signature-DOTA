function RestoreMana( keys )
	local ability = keys.ability
	local mana_regen = ability:GetLevelSpecialValueFor("regen", 1) / 10.0
	local caster = keys.caster

	local level = caster:GetLevel()
	caster:GiveMana( level * mana_regen )
end