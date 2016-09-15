function RestoreMana( keys )
	local Prognos = keys.MadOne
	local mana_regen = Prognos:GetManaRegen() / 10.0
	local caster = keys.caster
	local target = keys.target

	target:GiveMana( mana_regen )
end