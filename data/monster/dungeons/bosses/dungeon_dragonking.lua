local mType = Game.createMonsterType("BOSS Dragonking Zyrtarch")
local monster = {}

monster.description = "a dragonking zyrtarch"
monster.experience = 70700
monster.outfit = {
	lookType = 938,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "fire"
monster.speed = 500
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 112, attack = 85},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -110, maxDamage = -495, radius = 8, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="charged energy elemental electrify", interval = 2000, chance = 15, minDamage = -1100, maxDamage = -1100, radius = 5, effect = CONST_ME_YELLOWENERGY, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 4, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 3, effect = CONST_ME_FIREAREA, target = false},
	{name ="ghastly dragon curse", interval = 2000, chance = 5, range = 5, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -920, maxDamage = -1280, range = 5, effect = CONST_ME_SMALLCLOUDS, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -230, range = 7, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="ghastly dragon wave", interval = 2000, chance = 10, minDamage = -120, maxDamage = -250, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -110, maxDamage = -180, radius = 4, effect = CONST_ME_MORTAREA, target = false},
	{name ="speed", interval = 2000, chance = 20, speedChange = -800, range = 7, effect = CONST_ME_SMALLCLOUDS, target = true, duration = 30000},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -220, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="firefield", interval = 2000, chance = 10, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 22, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -270, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 64,
	armor = 52,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 450, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 1},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)
