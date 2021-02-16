-- local dungeonBoss = CreatureEvent("DungeonBoss")
-- function dungeonBoss.onKill(creature, target)
-- 	local targetMonster = target:getMonster()
-- 	if not targetMonster then
-- 		return
-- 	end

-- 	local player = creature:getPlayer()
-- 	local storageBoss = player:getStorageValue(Storage.DungeonBossKill.Bosses.bossZyrtarch)
-- 	if storageBoss == 25034 then
--         player:setStorageValue(Storage.DungeonBossKill.Bosses.bossZyrtarch, storageBoss + 1)
-- 		return 
-- 	end
-- 	player:say('Você matou o BOSS, para continuar com a Dungeon acenda a estátua.', TALKTYPE_MONSTER_SAY)
-- 	return true
-- end

-- dungeonBoss:register()

