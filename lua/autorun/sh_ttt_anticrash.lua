-- Code by mcNuggets

-- This addon only changes the value of a ConVar and disables the collision between ragdolls (like in normal TTT), without making your server crash frequently.
-- If you want to support my addon(s), keep the advertise as it is, if you want to turn it off, run "mg_ttt_advertise 0" on your servers console.

hook.Add("InitPostEntity", "MG_TTT_ConVarAdjustment", function()
	RunConsoleCommand("ttt_ragdoll_collide", "1")
end)

if SERVER then
	local advertise = CreateConVar("mg_ttt_advertise", 1, FCVAR_ARCHIVE, "Enable/disable advertise.")
	hook.Add("PlayerInitialSpawn", "MG_Advertise", function(ply)
		if !advertise:GetBool() then return end
		timer.Simple(30, function()
			if !IsValid(ply) then return end
			ply:ChatPrint("This TTT server most likely won't crash every half hour due to MG's TTT-Anticrash. Get it here for free:")
			ply:ChatPrint("https://github.com/mcNuggets1/mg_ttt_anticrash")
		end)
	end)
end

local ragdoll_collide = CreateConVar("mg_ttt_ragdoll_collide", 0, FCVAR_ARCHIVE, "Disables ragdoll collision between two ragdolls.")
hook.Add("OnEntityCreated", "MG_RagdollCollide", function(ent)
	if ragdoll_collide:GetBool() then return end
	if ent:IsRagdoll() then
		ent:SetCustomCollisionCheck(true)
	end
end)

hook.Add("ShouldCollide", "MG_RagdollCollide", function(ent1, ent2)
	if ragdoll_collide:GetBool() then return end
	if !IsValid(ent1) or !IsValid(ent2) or !ent1:IsRagdoll() or !ent2:IsRagdoll() then return end
	if ent1:GetCollisionGroup() == COLLISION_GROUP_WEAPON then
		return false
	end
end