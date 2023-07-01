--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/cw_particles.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

game.AddParticles("particles/muzzleflashes_test.pcf")
game.AddParticles("particles/muzzleflashes_test_b.pcf")
game.AddParticles("particles/cstm_muzzleflashes.pcf")

PrecacheParticleSystem("muzzleflash_g3")
PrecacheParticleSystem("muzzleflash_m14")
PrecacheParticleSystem("muzzleflash_ak47")
PrecacheParticleSystem("muzzleflash_ak74")
PrecacheParticleSystem("muzzleflash_6")
PrecacheParticleSystem("muzzleflash_pistol_rbull")
PrecacheParticleSystem("muzzleflash_pistol")
PrecacheParticleSystem("muzzleflash_suppressed")
PrecacheParticleSystem("muzzleflash_pistol_deagle")
PrecacheParticleSystem("muzzleflash_OTS")
PrecacheParticleSystem("muzzleflash_M3")
PrecacheParticleSystem("muzzleflash_smg")
PrecacheParticleSystem("muzzleflash_SR25")
PrecacheParticleSystem("muzzleflash_shotgun")
PrecacheParticleSystem("muzzle_center_M82")

PrecacheParticleSystem("cstm_smoke")