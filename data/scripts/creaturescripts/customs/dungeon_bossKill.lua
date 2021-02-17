local bosses = {
	['giant spider'] = { storage = Storage.DungeonBoss.bossZyrtarch}
}

local dungeonBossKill = CreatureEvent("DungeonBossKill")
function dungeonBossKill.onKill(player, target)
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