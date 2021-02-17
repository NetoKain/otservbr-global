local bosses = {
	['boss dragonking zyrtarch'] = { storage = Storage.DungeonBoss.bossZyrtarch}
}

-- This will set the status of warzone (killing 1, 2 and 3 wz bosses in order you can open the chest and get "some golden fruits") and the reward chest storages
local dungeonBossKill = CreatureEvent("DungeonBossKill")
function dungeonBossKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossConfig = bosses[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end

	for index, value in pairs(targetMonster:getDamageMap()) do
		local attackerPlayer = Player(index)
		if attackerPlayer then
			if (attackerPlayer:getStorageValue(Storage.DungeonBoss.bossZyrtarch)) == 25034 then
				attackerPlayer:setStorageValue(Storage.BigfootBurden.WarzoneStatus, 25035)
			end
		end
	end
end

dungeonBossKill:register()