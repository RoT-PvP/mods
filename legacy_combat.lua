WeaponSkillFalloff  = RuleR.Get(Rule.WeaponSkillFalloff);

function CheckHitChance(e)
	local other       = e.self;
	local self        = e.other;
	local attacker    = self;
	local defender    = other;
	local owner    = Mob();
	e.IgnoreDefault   = true;
	if (self:IsClient() and other:IsClient()) then
		return CheckHitChancePvP(e);
	end
	if (other:IsClient() and attacker:IsPet()) then
	owner = attacker:GetOwner();
	end
	if (owner.valid and owner:IsClient()) then
		return CheckHitChancePvPPet(e);
	end
	-- PvE and EvE checkhitchance logic here
end

function CheckHitChancePvPPet(e)
	local chancetohit = BaseHitChance;
	local defender    = other;
	local attacker    = self;
	local owner       = Mob();
	local other = e.self;
	local self = e.other;
	local hitBonus       = 0;
	e.IgnoreDefault   = true;

	if (self:IsPet()) then
		chancetohit = 50;
	end

	if (other:CastToClient():IsSitting()) then
		chancetohit = 100;
	end

	local tohit_roll = Random.Real(0, 100);

	eq.log_combat(
			string.format("[%s] [CheckHitChancePvPPet] Chance [%i] ToHitRoll [%i] Hit? [%s]",
					e.self:GetCleanName(),
					chancetohit,
					tohit_roll,
					(tohit_roll <= chancetohit) and "true" or "false"
			)
	);

	if (chancetohit > 1000 or chancetohit < -1000) then
	elseif (chancetohit > 95) then
		chancetohit = 95;
	elseif (chancetohit < 5) then
		chancetohit = 5;
	end

	if (tohit_roll <= chancetohit) then
		e.ReturnValue = true;
	else
		e.ReturnValue = false;
	end
	return e;
end

function CheckHitChancePvP(e)
	local chancetohit = BaseHitChance;
	local defender    = other;
	local attacker    = self;
	local other = e.self;
	local self = e.other;
	local hitBonus       = 0;
	e.IgnoreDefault   = true;

	--Pure Melee PvP Hit chance
	if ((self:GetClass() == Class.WARRIOR or self:GetClass() == Class.ROGUE or self:GetClass() == Class.MONK) and self:GetLevel() <= 25) then
		chancetohit = 75 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /12) - ((other:CastToClient():GetAGI()) /12)  - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	elseif ((self:GetClass() == Class.WARRIOR or self:GetClass() == Class.ROGUE or self:GetClass() == Class.MONK) and self:GetLevel() <= 35) then
		chancetohit = 55 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /8) - ((other:CastToClient():GetAGI()) /8) - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	elseif ((self:GetClass() == Class.WARRIOR or self:GetClass() == Class.ROGUE or self:GetClass() == Class.MONK) and self:GetLevel() <= 60) then
		chancetohit = 55 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /8) - ((other:CastToClient():GetAGI()) /8) - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	end

	--Hybrid and Bard PvP Hit chance
	if ((self:GetClass() == Class.SHADOWKNIGHT or self:GetClass() == Class.RANGER or self:GetClass() == Class.PALADIN or self:GetClass() == Class.BARD) and self:GetLevel() <= 25) then
		chancetohit = 65 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /12) - ((other:CastToClient():GetAGI()) /12)  - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	elseif ((self:GetClass() == Class.SHADOWKNIGHT or self:GetClass() == Class.RANGER or self:GetClass() == Class.PALADIN or self:GetClass() == Class.BARD) and self:GetLevel() <= 35) then
		chancetohit = 45 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /8) - ((other:CastToClient():GetAGI()) /8) - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	elseif ((self:GetClass() == Class.SHADOWKNIGHT or self:GetClass() == Class.RANGER or self:GetClass() == Class.PALADIN or self:GetClass() == Class.BARD) and self:GetLevel() <= 60) then
		chancetohit = 45 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /8) - ((other:CastToClient():GetAGI()) /8) - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	end

	--Priests hit chance
	if ((self:GetClass() == Class.CLERIC or self:GetClass() == Class.SHAMAN or self:GetClass() == Class.DRUID) and self:GetLevel() <= 25) then
		chancetohit = 55 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /12) - ((other:CastToClient():GetAGI()) /12)  - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	elseif ((self:GetClass() == Class.CLERIC or self:GetClass() == Class.SHAMAN or self:GetClass() == Class.DRUID) and self:GetLevel() <= 35) then
		chancetohit = 35 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /8) - ((other:CastToClient():GetAGI()) /8) - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	elseif ((self:GetClass() == Class.CLERIC or self:GetClass() == Class.SHAMAN or self:GetClass() == Class.DRUID) and self:GetLevel() <= 60) then
		chancetohit = 35 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /8) - ((other:CastToClient():GetAGI()) /8) - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	end

	--Int Caster PvP Hit chance
	if ((self:GetClass() == Class.MAGICIAN or self:GetClass() == Class.NECROMANCER or self:GetClass() == Class.ENCHANTER or self:GetClass() == Class.WIZARD) and self:GetLevel() <= 25) then
		chancetohit = 45 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /12) - ((other:CastToClient():GetAGI()) /12)  - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	elseif ((self:GetClass() == Class.MAGICIAN or self:GetClass() == Class.NECROMANCER or self:GetClass() == Class.ENCHANTER or self:GetClass() == Class.WIZARD) and self:GetLevel() <= 35) then
		chancetohit = 25 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /8) - ((other:CastToClient():GetAGI()) /8) - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	elseif ((self:GetClass() == Class.MAGICIAN or self:GetClass() == Class.NECROMANCER or self:GetClass() == Class.ENCHANTER or self:GetClass() == Class.WIZARD) and self:GetLevel() <= 60) then
		chancetohit = 25 + ((self:CastToClient():GetSkill(e.hit.skill)) / 10) + ((self:CastToClient():GetDEX()) /8) - ((other:CastToClient():GetAGI()) /8) - ((other:CastToClient():GetSkill(Skill.Defense)) / 10);
	end

	if (other:CastToClient():IsSitting()) then
		chancetohit = 100;
	end

	local tohit_roll = Random.Real(0, 100);

	eq.log_combat(
			string.format("[%s] [CheckHitChancePvP] Chance [%i] ToHitRoll [%i] Hit? [%s]",
					e.self:GetCleanName(),
					chancetohit,
					tohit_roll,
					(tohit_roll <= chancetohit) and "true" or "false"
			)
	);

	if (chancetohit > 1000 or chancetohit < -1000) then
		elseif (chancetohit > 95) then
		chancetohit = 95;
		elseif (chancetohit < 5) then
			chancetohit = 5;
	end

	if (tohit_roll <= chancetohit) then
		e.ReturnValue = true;
	else
		e.ReturnValue = false;
	end
	return e;
end

-- Source Function: Mob::GetDamageTable()
function GetDamageTable(attacker, skill)
	if not attacker:IsClient() then
		return 100;
	end

	eq.debug("skill"..skill);

	if attacker:GetLevel() <= 51 then
		local ret_table   = 0;
		local str_over_75 = 0;
		if attacker:GetSTR() > 75 then
			str_over_75 = attacker:GetSTR() - 75;
		end

		if str_over_75 > 255 then
			ret_table = (attacker:GetSkill(skill) + 255) / 2;
		else
			ret_table = (attacker:GetSkill(skill) + str_over_75) / 2;
		end

		if ret_table < 100 then
			return 100;
		end

		return ret_table;
	elseif attacker:GetLevel() >= 90 then
		if attacker:GetClass() == 7 then
			return 379;
		else
			return 345;
		end
	else
		local dmg_table = { 275, 275, 275, 275, 275, 280, 280, 280, 280, 285, 285, 285, 290, 290, 295, 295, 300, 300, 300, 305, 305, 305, 310, 310, 315, 315, 320, 320, 320, 325, 325, 325, 330, 330, 335, 335, 340, 340, 340 };

		if attacker:GetClass() == 7 then
			local monkDamageTableBonus = 20;
			return (dmg_table[attacker:GetLevel() - 50] * (100 + monkDamageTableBonus) / 100);
		else
			return dmg_table[attacker:GetLevel() - 50];
		end
	end
	return 100;
end



--function MinDmg()
--	local primary = slotPrimary;
--	other  = other:CastToClient();
--	if (primary) then
--		min_damage = GetWeaponDamage();
--	end
--end

--function GetMeleeMitDmg(defender, attacker, damage, min_damage, mitigation_rating, attack_rating)
	--if defender:IsClient() then
	--	return ClientGetMeleeMitDmg(defender, attacker, damage, min_damage, mitigation_rating, attack_rating);
	--end
--end

--function ClientGetMeleeMitDmg(defender, attacker, damage, min_damage, mitigation_rating, attack_rating)
	--if (not attacker:IsNPC() or UseOldDamageIntervalRules) then
	--	return MobGetMeleeMitDmg(defender, attacker, damage, min_damage, mitigation_rating, attack_rating);
	--end

	--local d             = 10;
	--local dmg_interval  = (damage - min_damage) / 19.0;
	--local dmg_bonus     = min_damage - dmg_interval;
	--local spellMeleeMit = (defender:GetSpellBonuses():MeleeMitigationEffect() + defender:GetItemBonuses():MeleeMitigationEffect() + defender:GetAABonuses():MeleeMitigationEffect()) / 100.0;
	--if (defender:GetClass() == Class.WARRIOR) then
	--	spellMeleeMit = spellMeleeMit - 0.05;
	--end

	--dmg_bonus      = dmg_bonus - (dmg_bonus * (defender:GetItemBonuses():MeleeMitigation() / 100.0));
	--dmg_interval   = dmg_interval + (dmg_interval * spellMeleeMit);

	--local mit_roll = Random.Real(0, mitigation_rating);
	--local atk_roll = Random.Real(0, attack_rating);

	--if (atk_roll > mit_roll) then
		--local a_diff   = atk_roll - mit_roll;
		--local thac0    = attack_rating * ACthac0Factor;
		--local thac0cap = attacker:GetLevel() * 9 + 20;
		--if (thac0 > thac0cap) then
		--	thac0 = thac0cap;
		--end

		--d = d + (10 * (a_diff / thac0));
	--elseif (mit_roll > atk_roll) then
		--local m_diff    = mit_roll - atk_roll;
		--local thac20    = mitigation_rating * ACthac20Factor;
		--local thac20cap = defender:GetLevel() * 9 + 20;
		--if (thac20 > thac20cap) then
		--	thac20 = thac20cap;
		--end

		--d = d - (10 * (m_diff / thac20));
	--end

	--if (d < 1) then
	--	d = 1;
	--elseif (d > 20) then
	--	d = 20;
	--end

	--return math.floor(dmg_bonus + dmg_interval * d);
--end

