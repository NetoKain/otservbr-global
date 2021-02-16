local DungeonConfig = {
	-- Position of the first position (line 1 column 1)
		firstDungeonCenterPosition = {x = 1036, y = 1832, z = 7},

	-- X distance between each room (on the same line)
		distanceDungeonPositionX= 41,

	-- Y distance between each room (on the same line)
		distanceDungeonPositionY= 41,

	-- Number of columns
		columns= 6,

	-- Number of lines
		lines= 8,

	-- kick time in seconds (10 minutes)
		kickTime = 600,
		kickPosition = Position({x = 32251, y = 31098, z = 6}),

	-- used to store event ids
		kickEvents = {},
		timerEvents = {},
		effectPositionCache = {},

		-- Timer wave
		timerWave = 180, -- Tempo até a próxima wave
		quantityPerWave = 15, -- Quantidade de monstros por wave
		quantityOfWaves = 10, -- Quantidade de waves até o boss

}
local totenStart ={
	totenOn = 10999,
	totenOff = 11000,
	rounds = 1,
	inProgress = false
}
local configMonsters = {

	bosses ={
		{monster = 'Falcon Paladin', size = 1},
		{monster = 'Falcon Knight', size = 1},
		{monster = 'Evil Prospector', size = 1},
		{monster = 'Freakish Lost Soul', size = 1},
	},


	positionSpawn= {
		bossPos = {x, y, z},
		minionsPos = {x, y, z},		
	},

	wavesMonsters = {
		{monster = 'Dungeon Dragon', size = 1, boss = false},
		{monster = 'Dungeon Dragon Lord', size = 1, boss = false},
		{monster = 'Dungeon Ice Dragon', size = 1, boss = false},
		{monster = 'Dungeon Wyrm', size = 1, boss = false},
		{monster = 'Dungeon Undead Dragon', size = 1, boss = false},
		{monster = 'Dungeon Ghastly Dragon', size = 1, boss = false},
		{monster = 'boss dragonking zyrtarch',
		 size = 1,
		 boss = true
		},
	}

}

local summonArea = {
	from = Position(x, y, z),
	to = Position(x, y, z),
	center = Position(x, y, z)
}

	-- Script automatically derives other pit positions from this one
local firstDungeon = {
		fromPos = {x = 1016, y = 1813, z = 7},
		toPos = {x = 1056, y = 1852, z = 7},
		center = {x = 1036, y = 1832, z = 7},
		pillar = {x = 32204, y = 31098, z = 7},
		tp = {x = 1020, y = 1833, z = 7},
		boss = {x = 1036, y = 1832, z = 7}
	}

local dungeonLoaded = GlobalEvent("dungeonLoaded")

function dungeonLoaded.onStartup(interval)
	
	Game.loadMap('data/world/custom/dungeon.otbm')		
	print('>> Dungeon will be active in today')
	
	return true
end
dungeonLoaded:register()

function DungeonConfig.getDungeonCreatures(dungeon_room)
	if not dungeon_room then
		return {}
	end

	local ret = {}
	local specs = Game.getSpectators(dungeon_room, false, false, 20, 20, 20, 20)
	for i = 1, #specs do
		ret[#ret+1] = specs[i]
	end

	return ret
end

function DungeonConfig.getDungeonOccupant(dungeon_room, ignorePlayer)
	local creatures = DungeonConfig.getDungeonCreatures(dungeon_room)
	for i = 1, #creatures do
		if creatures[i]:isPlayer() and creatures[i]:getId() ~= ignorePlayer:getId() then
			return creatures[i]
		end
	end

	return nil
end
-- local function eventSpawn() 
-- 		for wave = 1, #configMonsters.wavesMonsters do
-- 			print('WAVE:', wave)
-- 			addEvent(summonWave, wave * 15 * 1000, wave)			
-- 		end
-- 		return true
-- end
local function summonWave(i, totenRounds)
	local wave = configMonsters.wavesMonsters[i]	
	local summonPosition
	if wave.boss == true then
		for i = 1, wave.size do
			summonPosition = Position(math.random(summonArea.from.x,summonArea.to.x), math.random(summonArea.from.y, summonArea.to.y), 7)
			Game.createMonster(wave.monster, summonPosition)
			print('summonPosition',summonPosition.x,summonPosition.y,summonPosition.z, 'Monster: ', wave.monster)		
			summonPosition:sendMagicEffect(CONST_ME_TELEPORT)
			print('monsterBoss', wave.boss)
		end
	else
		for i = 1, wave.size * totenRounds do
			summonPosition = Position(math.random(summonArea.from.x,summonArea.to.x), math.random(summonArea.from.y, summonArea.to.y), 7)
			Game.createMonster(wave.monster, summonPosition)
			print('summonPosition',summonPosition.x,summonPosition.y,summonPosition.z, 'Monster: ', wave.monster)		
			summonPosition:sendMagicEffect(CONST_ME_TELEPORT)
			print('monsterNoBoss', wave.boss)
		end		
		if i == 7 then
			totenStart.inProgress = false
		end
	end
end

local function calculeAreaSummon(position)
	local configFromPosMinion = summonArea.from
	local configToPosMinion = summonArea.to
	local configPosBoss = configMonsters.positionSpawn.minionsPos
	configFromPosMinion = {x = position.x - 11, y = position.y - 9, z = position.z }
	configToPosMinion = {x = position.x + 11, y = position.y + 12, z = position.z }
	configPosBoss = {
		x = position.x,
		y = position.y - 5,
		z = position.z
	}
	summonArea.from = configFromPosMinion
	summonArea.to = configToPosMinion
	summonArea.center = {
		x = position.x,
		y = position.y,
		z = position.z
	}
	print('configFromPosMinion',configFromPosMinion.x, configFromPosMinion.y, configFromPosMinion.z)
	print('configToPosMinion',configToPosMinion.x, configToPosMinion.y, configToPosMinion.z)
	print('positionBoss',configPosBoss.x, configPosBoss.y, configPosBoss.z)
end

local function calculatingRoom(uid, position, column, line)
	local player = Player(uid)
	if column >= DungeonConfig.columns then
		column = 0
		line = line < (DungeonConfig.lines -1) and line + 1 or false
	end

	if line then
		local room_pos = {x = position.x + (column * DungeonConfig.distanceDungeonPositionX), y = position.y + (line * DungeonConfig.distanceDungeonPositionY), z = position.z}
		local occupant = DungeonConfig.getDungeonOccupant(room_pos, player)		
		if occupant then
			calculatingRoom(uid, position, column + 1, line)			
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			print('Sala ocupada:', room_pos.x, room_pos.y, room_pos.z)
		else
			player:teleportTo(room_pos)
			calculeAreaSummon(room_pos)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	else
		player:sendCancelMessage("Couldn't find any position for you right now.")
	end

end

local dungeonEntrance = MoveEvent()
function dungeonEntrance.onStepIn(creature, item, position, fromPosition)

	if not creature:isPlayer() then
		return true
	end

	local player = creature:getPlayer()
	if not player then
		return true
	end

	-- Check requirements
	if not player:isPremium() or player:getLevel() < 100 then
		player:say("Only Premium players of level 100 or higher are able to enter this portal.", TALKTYPE_MONSTER_SAY, false, player, fromPosition)
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	calculatingRoom(creature.uid, DungeonConfig.firstDungeonCenterPosition, 0, 0)
	-- eventSpawn()
	player:setStorageValue(Storage.DungeonBoss.bossZyrtarch, 25034)
	totenStart.inProgress = false
	-- 	for wave = 1, #configMonsters.wavesMonsters do
	-- 		print('WAVE:', wave)
	-- 		addEvent(summonWave, wave * 5 * 1000, wave, totenStart.rounds)			
	-- 	end
	return true
end
dungeonEntrance:position({x = 938, y = 1804, z = 7})
dungeonEntrance:register()

local startNewWave = Action()
function startNewWave.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local posToten = item:getPosition()
	posToten = {x = positem.x, y = positem.y + 1, positem.z}
	local storageDungeon = player:getStorageValue(Storage.DungeonBoss.bossZyrtarch)
	print('Cliquei aqui', positem.x, positem.y, positem.z)
	if totenStart.inProgress == true and storageDungeon == 25034 and item.itemid == 10999 then
	-- player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only the worthy may pass.")
	player:say("Round em andamento, aguarde.", TALKTYPE_MONSTER_SAY, false, player, fromPosition)
	return true
	else
		player:say("Round vai iniciar em instantes, prepare-se.", TALKTYPE_MONSTER_SAY, false, player, fromPosition)
		item:transform(10999)
		totenStart.rounds = totenStart.rounds + 1
		totenStart.inProgress = true
		for wave = 1, #configMonsters.wavesMonsters do
			print('WAVE:', wave)
			addEvent(summonWave, wave * 5 * 1000, wave, totenStart.rounds)			
		end
		return true
	end
	return true
end

startNewWave:aid(25033)
startNewWave:register()

local dungeonBoss = CreatureEvent("DungeonBoss")
function dungeonBoss.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'boss dragonking zyrtarch' then
		return true
	end

	local spectators, spectator = Game.getSpectators(summonArea.center, false, true, 20, 20, 20, 20)
	for i = 1, #spectators do
		spectator = spectators[i]
		spectator:say("Você venceu esse round! Para o próximo é necessário usar a estátua próxima ao centro da arena.", TALKTYPE_MONSTER_SAY)
		totenStart.inProgress = false
		if spectator:getStorageValue(Storage.DungeonBoss.bossZyrtarch) == 25034 then
			spectator:setStorageValue(Storage.DungeonBoss.bossZyrtarch, 25035)
		end
	end
	return true
end

dungeonBoss:register()

local function removeDungeonMonsters(position)
	local arrayPos = {
		{x = position.x - 1, y = position.y + 1, z = position.z},
		{x = position.x + 1 , y = position.y + 1, z = position.z}
	}

	for places = 1, #arrayPos do
		local monsters = Tile(arrayPos[places]):getTopCreature()
		if monsters then
			if monsters:isMonster() then
				monsters:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				monsters:remove()
			end
		end
	end
end


local function clearArena(position)
	local spectators, spectator = Game.getSpectators(position, false, false, 20, 20, 20, 20)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() then
		else
			spectator:remove()
		end
	end
end

local dungeonExit = MoveEvent()
function dungeonExit.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	creature:teleportTo(creature:getTown():getTemplePosition())
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	clearArena()
	return true
end

dungeonExit:aid(40018)
dungeonExit:register()
























-- local dungeonBoss = CreatureEvent("DungeonBoss")
-- function dungeonBoss.onKill(creature, target)
-- 	local player = creature:getPlayer()
-- 	local targetMonster = target:getMonster()
-- 	if not targetMonster then
-- 		return true
-- 	end
-- 	if targetMonster:getName():lower() == 'boss dragonking zyrtarch' then
-- 		player:setStorageValue(Storage.DungeonBoss.bossZyrtarch, 25035)
-- 		print(player:getStorageValue(Storage.DungeonBoss.bossZyrtarch))
-- 		player:say('Você matou o BOSS, para continuar com a Dungeon acenda a estátua.', TALKTYPE_MONSTER_SAY)
-- 		return true
-- 	end
	
-- 	local name = targetMonster:getName():lower()

-- 	local bossConfig = configMonsters.wavesMonsters.monster
-- 	if not bossConfig then
-- 		return true
-- 	end
-- 	print(player:getStorageValue(Storage.DungeonBoss.bossZyrtarch))
-- 	local player = creature:getPlayer()
-- 	totenStart.inProgress = false
-- 	return true
-- end

-- dungeonBoss:register()

