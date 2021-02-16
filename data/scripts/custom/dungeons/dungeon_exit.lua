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


local function clearArena()
	local spectators, spectator = Game.getSpectators(summonArea.center, false, false, 20, 20, 20, 20)
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