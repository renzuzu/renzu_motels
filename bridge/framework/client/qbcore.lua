if not QBCORE then return end
PlayerData = QBCORE.Functions.GetPlayerData()

if PlayerData.job ~= nil then
	PlayerData.job.grade = PlayerData.job.grade.level
end

if PlayerData.identifier == nil then
	PlayerData.identifier = PlayerData.citizenid
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	Wait(1500)
	PlayerData = QBCORE.Functions.GetPlayerData()

	if PlayerData.job ~= nil then
		PlayerData.job.grade = PlayerData.job.grade.level
	end

	if PlayerData.identifier == nil then
		PlayerData.identifier = PlayerData.citizenid
	end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
	PlayerData.job = job
	
	PlayerData.job.grade = PlayerData.job.grade.level
end)