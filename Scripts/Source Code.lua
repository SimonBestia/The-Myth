--[[The Myth
--Special Thanks to DeadpoolXYZ and Derpy54320 for helping with the mod!
]]


--Main Script
MissionSetup = function()

		repeat --Starts the script only after the game is ready, it's better than Wait(Numberhere) just in case someone with a very weak PC plays this
		Wait(0)
		until SystemIsReady() and not IsStreamingBusy()

	--Get In-Game Time when using the Arcade Machine
		StartH, StartM = ClockGet()

	--Audio stuff:
		SoundDisableSpeech() --Removes peds' voices
		SoundDisableSpeech_ActionTree() --This disables lines that a ped might say on its own (Like idle quotes), useful to avoid situations where a ped interrupts itself just to play a quote

	--Setup Player:
		PlayerWeaponHudLock(true) --Removes the abilty to scroll through weapons
		PlayerSetControl(0) --Disables the player's movement
		PlayerUnequip() --Self explanatory

	--HUD:
		ToggleHUDComponentVisibility(0, false) --Doesn't show the troublemeter
		F_ToggleHudElements(false) --Custom function
		PauseGameClock() --Self explanatory, also removes its HUD

		--ForceStartMission("6_B") --Use on PS2 ONLY, to load the roof (causes crashes in case of death)

end

ActualMissionSetup = function()

	--Load All Animations
		F_LoadAnims() --Custom function

	--Audio stuff:
		SoundLoadBank("MISSION\\1_09.bnk") --Loads a specific .SEA file
		SoundLoadBank("MISSION\\1_B.bnk")

	--DAT stuff:
		DATLoad("The_Myth.DAT", 2) --This loads a custom .dat file inside Trigger.img, the game can load custom .dat files

	--Map doors:
		AreaSetDoorLocked(TRIGGER._DT_tschool_RoofDoor, false) --Unlocks the roof door outside the school
			
	--Setup Player:
		ClothingBackup() --Saves Jimmy's current clothes, needed to restore them later

	--Misc:
		DisablePunishmentSystem(true) --Disables the trouble meter
		PlayerClearLastVehicle()
		AreaClearAllVehicles()

end

main = function()

		--Check for current chapter:
		if ChapterGet() < 4 then --4 = Chapter5
			YouShallNotPlay() --Starts YouShallNotPlay = function()
		else
			SettingsMenu()
		end

end

YouShallNotPlay = function()

		LoadAnimationGroup("MINI_React")

		if AreaGetVisible() == 14 then --Boys' Dorm
			PedSetFlag(gPlayer, 108, true) --for a list of known flags, check: https://bully-board.com/index.php?topic=22454.0
			StopAmbientPedAttacks()
			SetAmbientPedsIgnoreStimuli(true)
			CameraSetXYZ(-509.18, 324.39, 32.91, -506.99, 322.07, 32.57) --Places the camera at the first 3 coordinates and makes it look at the last 3 coordinates
		elseif AreaGetVisible() == 57 then --Dropouts safehouse
			CameraSetXYZ(-659.83, 243.90, 16.72, -656.90, 246.53, 16.01)
		elseif AreaGetVisible() == 50 then --Carnival souvenirs
			CameraSetXYZ(-786.07, 52.21, 8.78, -789.33, 54.47, 8.25)
		end

		CameraSetWidescreen(true) --Disables hud completely, doesn't even allow you to pause

	Wait(500) --Waits (milliseconds)

		CameraFade(500, 1) --Makes the camera fade in

	Wait(300)

		ExecuteActionNode(gPlayer, "/Global/1_11X2/Failure", "Act/Conv/1_11X2.act") --Makes a ped play a specific animation
		TextPrintString("You have to unlock Blue Skies first!", 2.5, 1) --Makes text appear on the screen. ("TEXT", seconds, type of text. [2 is small text, 1 is big text])
		SoundPlayStream("MS_MissionEnd01.rsm", MUSIC_DEFAULT_VOLUME) --Plays a music

	Wait(3000)

		MissionFail() --Self explanatory

	Wait(4000)

end

Intro = function()

	Wait(100)

		AreaTransitionXYZ(0, 181.85, -73.12, 46.54) --Changes player position to a different area and different coordinates (AreaCode, X,Y,Z)
		PedFaceXYZ(gPlayer, 180.10, -73.04, 46.64)
		Gary = PedCreateXYZ(130, 180.10, -73.04, 46.64) --Creates a ped called Gary (PedID, X,Y,Z)
		PedFaceXYZ(Gary, 181.85, -73.12, 46.54)
		SoundPlayStream("MS_FinalShowdown03Low.rsm", MUSIC_DEFAULT_VOLUME)
		CameraSetXYZ(180.38, -70.53, 47.67, 182.07, -75.43, 47.25)
		AreaOverridePopulation(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) --Disables population (Check PedPop.DAT to see how it works)

		--Roof bells and stuff, copy-pasted from 6_B.lua 'cause I'm lazy
		PAnimSetActionNode("SCBell2", 197.15899658203, -73.444702148438, 46.459701538086, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart2", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 197.15899658203, -71.16429901123, 46.459701538086, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart3", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 191.72500610352, -75.72029876709, 46.459701538086, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart4", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 191.72500610352, -73.444702148438, 46.459701538086, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart5", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 191.72500610352, -71.16429901123, 46.459701538086, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart6", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 186.27499389648, -75.72029876709, 46.459701538086, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart7", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 186.27499389648, -73.444702148438, 46.459701538086, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart8", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 186.27499389648, -71.16429901123, 46.459701538086, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart9", "Act/Props/SCBell.act")
		GeometryInstance("SCBell", false, 197.15899658203, -75.72029876709, 46.459701538086, false)
		GeometryInstance("SCBell2", false, 197.15899658203, -73.444702148438, 46.459701538086, false)
		GeometryInstance("SCBell2", false, 197.15899658203, -71.16429901123, 46.459701538086, false)
		GeometryInstance("SCBell", false, 191.72500610352, -75.72029876709, 46.459701538086, false)
		GeometryInstance("SCBell", false, 191.72500610352, -73.444702148438, 46.459701538086, false)
		GeometryInstance("SCBell2", false, 191.72500610352, -71.16429901123, 46.459701538086, false)
		GeometryInstance("SCBell2", false, 186.27499389648, -75.72029876709, 46.459701538086, false)
		GeometryInstance("SCBell", false, 186.27499389648, -73.444702148438, 46.459701538086, false)
		GeometryInstance("SCBell", false, 186.27499389648, -71.16429901123, 46.459701538086, false)
		GeometryInstance("WheelBrl", true, 183.54499816895, -80.270599365234, 41.07799911499, false)
		GeometryInstance("WheelBrl", true, 204.58200073242, -68.039596557617, 35.699501037598, false)

	Wait(200)

		PedSetActionNode(gPlayer, "/Global/2_08Conv/Taunt/TauntPlayer", "Act/Conv/2_08.act")
		PedSetActionNode(Gary, "/Global/Ambient/MissionSpec/FireMan/LookAround", "Act/Conv/Ambient.act")
		TextPrintString("Jimmy: Nowhere to run now, eh, Gary?", 3, 2)
		
	Wait(3000)
		
		CameraSetXYZ(181.68, -71.02, 47.27, 180.04, -75.31, 47.44)
		PedSetActionNode(Gary, "/Global/1_07/GoingDown", "Act/Conv/1_07.act")
		TextPrintString("Gary: GO TO HELL, JIMMY!", 2, 2)
		
	Wait(2000)
		
		SoundPlayStream("MS_FinalShowdown03Mid.rsm", MUSIC_DEFAULT_VOLUME)
		PedLockTarget(Gary, gPlayer) --Makes a ped target another ped, required for some attacks to work
		PedSetActionNode(Gary, "/Global/G_Johnny/Cinematic/ThroatGrab", "Act/Conv/G_Johnny.act")
		Wait(100)
		repeat --This is a loop, it will keep looping until Gary is not performing Johnny's throat grab attack, then moves on
		Wait(0)
		until not PedIsPlaying(Gary, "/Global/G_Johnny/Cinematic/ThroatGrab", "Act/Conv/G_Johnny.act", true)
		GameSetPedStat(Gary, 20, 150) --Sets a ped's speed (PEDID, statID, amount)
		PedMoveToXYZ(Gary, 2, 182.16, -67.50, 26.10) --Moves a ped (Ped, walk/run/sprint, x,y,z) walk, run, sprint = 0, 1, 2, 3
		
	Wait(2000)

		PedDelete(Gary) --Self explanatory
		PedSetActionNode(gPlayer, "/Global/G_Johnny/Cinematic/Jimmy/BellyUp/BellyUpGetUp/BellyUpGetUpGetUp", "Act/Conv/G_Johnny.act")
		PlayerSetHealth(200)
		PlayerSetControl(1) --Restores the player's control
		F_ToggleHudElements(true)
		BlipBackToSchool = BlipAddXYZ(182.16, -67.50, 26.10, 0, 3, 0, 0) --adds a blip. (X,Y,Z, icon, ground blip type, visibility, Unknown)
		TextPrintString("Don't let Gary run away!", 3, 1)

		T_RoofChase = CreateThread("RoofChase")
		SchoolChase()

end

RoofChase = function()

		repeat
		Wait(0)
		until PlayerIsInAreaXYZ(193.82, -79.74, 42.21, 4, 0) --The script will wait until the player is somewhere (X, Y, Z, Radius, blip ground type)

		GaryRoof = PedCreateXYZ(130, 184.91, -80.60, 35.68)

	Wait(100)

		PedMakeTargetable(GaryRoof, false) --Removes the ability to lock on Gary
		PedSetInvulnerable(GaryRoof, true)
		PedFollowPath(GaryRoof, PATH._GARYPATH1, 0, 2) --Gary will follow GARYPATH1 from my custom .dat file (Ped, PATH._PATHNAME, idk, speed)

		repeat
		Wait(0)
		until PedIsInAreaXYZ(GaryRoof, 198.69, -79.48, 35.68, 1, 0) --Same as PlayerIsInareaXYZ

		PedStop(GaryRoof)

	Wait(50)

		PedFaceXYZ(GaryRoof, 186.21, -80.58, 35.68)
		TextPrintString("Gary: No wonder your mother left you here! She must be SO embarassed by you, Jimmy Hopkins!", 6, 2)

	Wait(500)
	
		PedSetActionNode(GaryRoof, "/Global/1_11X1/Animations/LaughCyclic/LaughCyclic", "Act/Conv/1_11X1.act")
		
		repeat
		Distance = DistanceBetweenPeds2D(gPlayer, GaryRoof) --Calculates distance (X and Y) between Jimmy and Gary
		Wait(0)
		until Distance < 6 --This makes Gary run away when Jimmy gets close to him

		PedSetActionNode(GaryRoof, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act") --A node with no animations, useful for stopping the current animation

	Wait(5)

		PedLockTarget(GaryRoof, gPlayer, -1)
		PedFollowPath(GaryRoof, PATH._GARYPATH2, 0, 0)
		
	Wait(500)

		PedStop(GaryRoof)

	Wait(5)

		PedSetWeapon(GaryRoof, 349, 3) --Self explanatory (Ped, WeaponID, Ammo)
		PedFollowPath(GaryRoof, PATH._GARYPATH2, 0, 1)

	Wait(750)

		PedSetActionNode(GaryRoof, "/Global/2_S04/Anim/AttachMarbles", "Act/Conv/2_S04.act")

		repeat
		Wait(0)
		until PedIsInAreaXYZ(GaryRoof, 205.36, -67.43, 35.71, 1, 0)

	Wait(150)

		PedStop(GaryRoof)
		PedFaceXYZ(GaryRoof, 205.48, -79.06, 35.69)

		repeat
		Wait(0)
		until PlayerIsInAreaXYZ(205.48, -79.06, 35.69, 1, 0)

		PedLockTarget(GaryRoof, gPlayer, 3)
		PedSetWeapon(GaryRoof, 311, 1)
		GameSetPedStat(GaryRoof, 20, 150) --Sets Gary's speed
		
	Wait(200)
		
		PedSetActionTree(GaryRoof, "/Global/Nemesis/Special/Throw", "Act/Anim/Nemesis.act")
        repeat
        Wait(0)
        until PedIsPlaying(GaryRoof, "/Global/Nemesis/Special/Throw/GetWeapon/Release/Empty", true)
        PedSetActionTree(GaryRoof, "/Global/Nemesis", "Act/Anim/Nemesis.act")
        PedLockTarget(GaryRoof, gPlayer, -1)
		PedSetPosXYZ(GaryRoof, 204.66, -66.84, 35.29) --Same as AreaTransitionXYZ, but this can be used when not changing areas.
		
	Wait(1000)

		PedFollowPath(GaryRoof, PATH._GARYPATH3, 0, 2)
		
		repeat
		Wait(0)
		until PedIsInAreaXYZ(GaryRoof, 186.61, -66.06, 30.29, 1, 0)
		
		PedSetPosXYZ(GaryRoof, 185.63, -66.00, 29.50)
		
	Wait(50)
	
		PedFollowPath(GaryRoof, PATH._GARYPATH4, 0, 2)
		
		repeat
		Wait(0)
		until PedIsInAreaXYZ(GaryRoof, 182.08, -69.21, 26.10, 1.5, 0)

		PedDelete(GaryRoof)

end

SchoolChase = function()

		repeat
		Wait(0)
		until AreaGetVisible() == 2 and not AreaIsLoading() --The game gets the ID of the current area, if it is 2 (school), it waits until it's fully loaded, then continues.
		
		TerminateThread(T_RoofChase)

		if PedIsValid(GaryRoof) then
			PedDelete(GaryRoof) --Just in case the script screws up and doesn't despawn him
		end

	Wait(100)

		AreaSetDoorLocked(TRIGGER._ISCHOOL_DOOR25, false) --Unlocks the roof door inside the school
		BlipRemove(BlipBackToSchool)
		PedFaceXYZ(gPlayer, -611.06, -287.20, 13.99)
		CameraReturnToPlayer()

	Wait(100)

		AreaDisableAllPatrolPaths() --Disables the prefects
		Gary = PedCreateXYZ(130, -611.06, -287.20, 10.99)
		AddBlipForChar(Gary, 0, 34, 4)  --Adds a blip to a ped. (PedID, Unknown, icon, ground blip [in this case, 4 is an invalid ID, so nothing is on the ground])
		PedMakeTargetable(Gary, false)
		PedSetInvulnerable(Gary, true)
		PedMoveToXYZ(Gary, 2, -628.08, -330.61, 0.00)
		PedSetInfiniteSprint(Gary, true)
		PedIgnoreStimuli(Gary, true) --The ped won't react to its surroundings 
		GameSetPedStat(Gary, 20, 168)
		
	Wait(650)

		T_MonitorGaryMarbles = CreateThread("T_MonitorGaryMarbles")
		T_EasterEgg = CreateThread("T_EasterEgg")

		TextPrintString("Gary: You'll never catch me, Hopkins!", 3, 2)
		Wait(3000)
		TextPrintString("Jimmy: Keep running like a baby!", 3, 2)

		repeat
		Wait(0)
		until PedIsInAreaXYZ(Gary, -627.38, -332.51, 0.00, 3, 0)

		MissionTimerStart(9) --Starts a 9 seconds countdown
		BlipRemoveFromChar(Gary)
		PedSetFlag(Gary, 9, true) --Makes a ped vanish, like a ghost
		TerminateThread(T_MonitorGaryMarbles)
		TextPrintString("Gary went outside, don't let him run away!", 3, 1)

		repeat
			if MissionTimerHasFinished() then
				PlayerSetControl(0)
				SoundPlayStream("MS_MissionEnd01.rsm", MUSIC_DEFAULT_VOLUME)
				MissionTimerStop()
				if PedIsPlaying(gPlayer, "/Global/Player/JumpActions/Jump", true) then --Makes the script wait in case the player is doing some jumping animations
					repeat
					Wait(0)
					until not PedIsPlaying(gPlayer, "/Global/Player/JumpActions/Jump", true)
				elseif PedIsPlaying(gPlayer, "Global/Player/JumpActions/Jump/Falling/Fall/Falling/Fall_Damage/Fall", true) then
					repeat
					Wait(0)
					until not PedIsPlaying(gPlayer, "Global/Player/JumpActions/Jump/Falling/Fall/Falling/Fall_Damage/Fall", true)
				end
				Wait(250)
				local X1, Y1, Z1 = PedGetOffsetInWorldCoords(gPlayer, -0.45, 1.35, 1.5000000476837) --Borrowed from Halloween's script, both functions get Jimmy's coordinates and change them to the one specified in the brackets
				local X2, Y2, Z2 = PedGetOffsetInWorldCoords(gPlayer, 0.45, -0.69999998807907, 1.3000000476837)
				CameraSetXYZ(X1, Y1, Z1, X2, Y2, Z2)
				ExecuteActionNode(gPlayer, "/Global/1_11X2/Failure", "Act/Conv/1_11X2.act")
				CameraSetWidescreen(true)
				Wait(800)
				MissionFail()
				Wait(2000)
			end
		Wait(0)
		until PlayerIsInAreaXYZ(-628.01, -327.70, 0.00, 1.25, 0)

		TerminateThread(T_EasterEgg)
		MissionTimerStop()
		PlayerSetControl(0)
		AreaTransitionXYZ(0, 212.10, -73.37, 8.62)

		KartChase()

end

T_MonitorGaryMarbles = function()

		repeat
			if PedIsValid(Gary) then
				Wait(1400)
				PedSetActionNode(Gary, "/Global/2_S04/Anim/AttachMarbles", "Act/Conv/2_S04.act")
			end
		Wait(0)
		until PedIsDead(Gary) or not PedIsValid(Gary)

end

T_EasterEgg = function()

		repeat
		Wait(0)
		until PlayerIsInAreaXYZ(-629.73, -281.07, 5.51, 1, 0)

		MissionTimerStop()
		SoundStopStream() --Stops the current playing music
		AreaTransitionXYZ(5, -701.15, 215.12, 31.55)
		PlayerSetControl(0)
		F_ToggleHudElements(false)

		if PedIsValid(Gary) then
			PedDelete(Gary)
		end

	Wait(50)

		SoundPlayStream("MS_5-05_BurtonPee_NIS.rsm", MUSIC_DEFAULT_VOLUME)
		CreatePersistentEntity("DRP_Arcade", -698.18, 204.84, 32.70, 90, 5) --Adds a model (X, Y, Z, Rotation, AreaID)
		CreatePersistentEntity("OffLapTop", -703.46, 204.88, 32.67, 0, 5)
		DeadpoolXYZEG = PedCreateXYZ(147, -699.14, 204.11, 31.55)
		Derpy54320EG = PedCreateXYZ(165, -704.15, 204.89, 31.55)
		SimonBestiaEG = PedCreateXYZ(85, -699.14, 205.15, 31.55)

	Wait(15)

		PedClearAllWeapons(DeadpoolXYZEG)
		PedClearAllWeapons(SimonBestiaEG)
		PedFaceXYZ(DeadpoolXYZEG, -697.59, 204.62, 31.55)
		PedFaceXYZ(Derpy54320EG, -698.18, 204.84, 32.70)
		PedFaceXYZ(SimonBestiaEG, -698.42, 204.88, 31.55)

	Wait(50)

		CameraSetXYZ(-698.03, 203.35, 33.17, -700.63, 206.35, 32.74)
		PedSetActionNode(SimonBestiaEG, "/Global/3_R09/Animations/Nerds/Nerds01", "Act/Conv/3_R09.act")
		PedSetActionNode(Derpy54320EG, "/Global/5_09/Anims/PeteSit", "Act/Conv/5_09.act")
		TextPrintString("SimonBestia: No, no, no! You can't just cancel an hadoken into a shoryuken like that!", 5, 2)
		Wait(5200)
		PedSetActionNode(DeadpoolXYZEG, "/Global/3_R09/Animations/Nerds/Nerds02", "Act/Conv/3_R09.act")
		TextPrintString("DeadpoolXYZ: Of course I can.", 2, 2)
		Wait(2200)
		
		CameraSetXYZ(-703.06, 204.05, 32.75, -705.85, 206.92, 32.71)
		TextPrintString("Derpy54320: Guys, don't you think we should be checking if the script is working as intended?", 5, 2)
		Wait(5200)
		
		CameraSetXYZ(-700.67, 206.27, 33.15, -697.82, 203.52, 32.60)
		PedFaceHeading(SimonBestiaEG, 90)
		PedFaceHeading(DeadpoolXYZEG, 45)
		TextPrintString("SimonBestia: Come on, DaBOSS, there's no way anyone would come here, they have no reason to.", 5, 2)
		Wait(250)
		PedSetActionNode(SimonBestiaEG, "/Global/C31Strt/FattyAvoid", "Act/Conv/C3_1.act")
		Wait(5200)
		
		PlayerSetPosXYZ(-701.21, 211.42, 31.55)
		PedMoveToXYZ(gPlayer, 0, -701.21, 209.05, 31.55)
		Wait(500)
		CameraSetXYZ(-701.79, 207.51, 32.84, -700.19, 211.16, 32.61)
		CreateThread("T_StopMusic")
		Wait(500)
		TextPrintString("Jimmy: What the hell is going on here?", 2, 2)
		Wait(2500)

		CameraSetXYZ(-700.16, 206.15, 33.03, -698.01, 202.79, 33.27)
		PedFaceHeading(SimonBestiaEG, 45)
		PedSetActionNode(SimonBestiaEG, "/Global/4_G4/Scream", "Act/Conv/4_G4.act")
		PedSetActionNode(DeadpoolXYZEG, "/Global/2_S06/Anims/BeatriceFreakOut/freakout", "Act/Conv/2_S06.act")

	Wait(50)
		
		PedSetActionNode(SimonBestiaEG, "/Global/3_04/3_04_Anim/AlgieOhFace/OhFace", "Act/Conv/3_04.act")
		PedSetActionNode(DeadpoolXYZEG, "/Global/3_04/3_04_Anim/AlgieOhFace/OhFace", "Act/Conv/3_04.act")
		Wait(3000)
		PedSetActionNode(Derpy54320EG, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		PedSetActionNode(DeadpoolXYZEG, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		PedSetActionNode(SimonBestiaEG, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		PedSetPosXYZ(Derpy54320EG, -704.21, 206.43, 31.55)
		Wait(50)
		PedFaceXYZ(Derpy54320EG, -703.19, 207.33, 31.55)
		CameraSetXYZ(-702.84, 207.87, 32.80, -705.05, 204.55, 32.50)
		PedSetActionNode(Derpy54320EG, "/Global/C7/PlayerFail", "Act/Conv/C7.act")
		Wait(3000)
		CameraSetXYZ(-702.53, 201.11, 35.05, -701.79, 204.80, 33.72)
		SoundPlayAmbience("SchoolNight.rsm", 0.1)
		Wait(3500)
		GaryEG = PedCreateXYZ(130, -700.74, 213.98, 31.55)
		
	Wait(5)

		PedFaceXYZ(GaryEG, -701.30, 211.37, 31.55)
		PedMoveToXYZ(GaryEG, 0, -701.30, 211.37, 31.55)
		CameraSetXYZ(-701.86, 208.93, 33.14, -701.02, 212.81, 32.63)
		TextPrintString("Gary: Hey Jimmy, stick to the script, we---", 2, 2)
		Wait(2000)

		PedFaceXYZ(gPlayer, -701.30, 211.37, 31.55)
		CameraSetXYZ(-701.28, 209.94, 33.08, -701.46, 205.95, 33.00)
		Wait(3500)

		CameraSetXYZ(-705.30, 207.36, 32.95, -701.56, 205.97, 32.68)
		PedFaceXYZ(Derpy54320EG, -699.14, 205.15, 31.55)
		PedSetActionNode(Derpy54320EG, "/Global/C7/TeacherDisgust", "Act/Conv/C7.act")
		PedSetActionNode(DeadpoolXYZEG, "/Global/2_S04/Anim/Laugh", "Act/Conv/2_04.act")
		TextPrintString("Derpy54320: Well, look who's wrong.", 2, 2)
		SoundFadeoutAmbience()
		Wait(2200)

		MusicCanNowStart = true
		SoundPlayStream("FIGHT01F.rsm", MUSIC_DEFAULT_VOLUME)
		CameraSetXYZ(-700.10, 206.32, 32.53, -697.85, 203.23, 33.70)
		TextPrintString("SimonBestia: LISTEN, YOU TWO.", 2, 2)
		PedSetActionNode(SimonBestiaEG, "/Global/1_07/GoingDown", "Act/Conv/1_07.act")
		Wait(2100)

		CameraSetXYZ(-699.92, 205.55, 33.17, -696.09, 204.40, 33.21)
		TextPrintString("SimonBestia: You guys are part of a videogame, you're not real.", 3, 2)
		Wait(3100)

		CameraSetXYZ(-699.57, 203.00, 33.75, -700.52, 206.80, 32.89)
		TextPrintString("SimonBestia: I don't know how you ended up here, but I have no choice, I have to erase your memories.", 5, 2)
		PedFaceHeading(gPlayer, 180)
		PedFaceXYZ(gPlayer, -699.14, 205.15, 31.55)
		Wait(5100)

		CameraSetXYZ(-700.91, 207.83, 33.09, -701.76, 211.68, 32.40)
		PedMoveToXYZ(GaryEG, 0, -700.56, 209.47, 31.55)
		PedSetActionNode(gPlayer, "/Global/1_11X1/Animations/Laugh_Shove/Laugh", "Act/Conv/1_11X1.act")
		TextPrintString("Jimmy: Yeah right, give it a rest, Trent.", 3, 2)
		Wait(3100)

		CameraSetXYZ(-699.64, 206.29, 33.16, -698.59, 202.44, 32.95)
		TextPrintString("SimonBestia: It's difficult to explain, but we're not your friends.", 4, 2)
		PedFaceXYZ(Derpy54320EG, -701.21, 209.05, 31.55)
		Wait(4100)

		CameraSetXYZ(-699.83, 201.70, 34.02, -700.76, 205.41, 32.85)
		TextPrintString("SimonBestia: I have to erase your memories now, goodbye.", 3, 2)
		PedSetActionNode(gPlayer, "/Global/1_06/HoboFly", "Act/Conv/1_06.act")
		PedSetActionNode(GaryEG, "/Global/1_06/HoboFly", "Act/Conv/1_06.act")
		EffectSetGymnFireOn(true) --Self explanatory
		Wait(3100)
		CameraSetXYZ(-700.16, 206.28, 33.15, -697.33, 203.03, 33.01)
		TextPrintString("SimonBestia: ZA WARUDO!", 2.5, 2)
		TextPrintString("Translator Note: 'Za Warudo' means 'Make the game crash'.", 2.5, 1)
		PedSetActionNode(SimonBestiaEG, "/Global/5_03/5_03_Johnny_In_Cell", "Act/Conv/5_03.act")
		Wait(1000)

		CameraSetXYZ(-699.75, 205.80, 32.95, -697.03, 202.90, 33.43)
		Wait(1000)
		PedDelete(gPlayer)
		

end

KartChase = function()
		
		repeat
		Wait(0)
		until AreaGetVisible() == 0 and not AreaIsLoading()

		NonMissionPedGenerationDisable()
		AreaOverridePopulation(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		CreateThread("T_FailDistance")

	Wait(5)

		AreaClearAllPeds()
		AreaClearSpawners()
		PedFaceXYZ(gPlayer, 212.63, -73.22, 8.59)
		
	Wait(5)

		PedMoveToXYZ(gPlayer, 2, 216.13, -73.30, 8.59)
		F_ToggleHudElements(false)
		Gary2 = PedCreateXYZ(130, 224.73, -73.00, 7.17)
		
	Wait(5)

		GaryVehicle = VehicleCreateXYZ(289, 229.02, -70.75, 6.30)  --Creates a vehicle (VehicleID, X,Y,Z)
		JimmyVehicle = VehicleCreateXYZ(277, 229.55, -75.85, 6.19)
		CameraSetXYZ(233.76, -75.12, 6.50, 228.63, -73.54, 7.10)
		PedEnterVehicle(Gary2, GaryVehicle) --Self explanatory, make sure the ped is close enough to the vehicle or he won't be able to "find" it.
		TextPrintString("Gary: Catch me if you can, LOSER!", 3, 2)
		
	Wait(500)

		PedSetActionNode(gPlayer, "/Global/5_03/5_03_NIS_Gateclose/Jimmy/Jimmy01", "Act/Conv/5_03.act")
	
		repeat
		Wait(0)
		until PedIsOnVehicle(Gary2, GaryVehicle)

	Wait(400)

		ChaseDone = false --The thread T_FailDistance will keep looping until we set this variable to true
		VehicleFollowPath(GaryVehicle, PATH._ISLAND, true) --Same as PedFollowPath
		VehicleSetCruiseSpeed(GaryVehicle, 19) --Sets a vehicle's speed

	Wait(500)

		AddBlipForChar(Gary2, 0, 34, 4)
		PedIgnoreAttacks(Gary2, true)
		PedIgnoreStimuli(Gary2, true)
		PedMakeTargetable(Gary2, false)
		PedSetInvulnerable(Gary2, true)
		CameraReturnToPlayer()
		
	Wait(100)
		
		GameSetPedStat(gPlayer, 20, 115)
		PedMoveToXYZ(gPlayer, 3, 229.65, -75.16, 6.26)

	Wait(770)

		PlayerSetControl(1)
		GameSetPedStat(gPlayer, 20, 100)
		SoundPlayStream("MS_StreetFightLargeHigh_Boxing.rsm", MUSIC_DEFAULT_VOLUME)
		TextPrintString("Quick! After him!", 2, 1)
		F_ToggleHudElements(true)
		Wait(3500)

		TextPrintString("HINT: Quickly press the ~ACCELERATE~ and ~BRAKE~ buttons to go faster.", 5, 1)
		Wait(6000)

		T_KartChaseConversation = CreateThread("T_KartChaseConversation")
		
		repeat --Same as the first repeat from SchoolChase
		Wait(0)
		until PedIsInAreaXYZ(Gary2, 72.65, -314.15, 0.65, 6, 0)

		VehicleStop(GaryVehicle)
		PedExitVehicle(Gary2)
		
	Wait(1)
	
		repeat
		Wait(0)
		until PlayerIsInAreaXYZ(58.94, -301.45, 1.44, 4, 0)

		ChaseDone = true
		CameraFade(1000, 0)
		SoundStopStream()
		PlayerSetControl(0)

		Wait(1500)

		if PlayerIsInAnyVehicle() then	--Self explanatory
			PlayerDetachFromVehicle()
		end

		VehicleDelete(JimmyVehicle)
		PlayerSetPosXYZ(64.54, -313.47, 0.37)
		Jimmy2Vehicle = VehicleCreateXYZ(277, 65.04, -315.82, 0.37)
		PedFaceXYZ(gPlayer, 71.79, -314.26, 0.52)
		PedSetPosXYZ(Gary2, 72.65, -314.15, 0.65)

	Wait(50)

		PedFaceXYZ(Gary2, 64.54, -313.47, 0.37)
		VehicleDelete(GaryVehicle)
		Gary2Vehicle = VehicleCreateXYZ(289, 73.05, -315.37, 0.37)
		
		PreBossBattleCutScene()

end

T_KartChaseConversation = function()

		TextPrintString("Gary: WHAT'S THE MATTER, JAMES? CAN'T KEEP UP?", 4, 2)
		Wait(4000)
		TextPrintString("Jimmy: YOU WENT TOO FAR, GARY!", 3, 2)
		Wait(4000)
		TextPrintString("*Cellphone ringing*", 1, 2)
		Wait(1300)
		TextPrintString("*Cellphone ringing*", 1, 2)
		Wait(1300)
		TextPrintString("*Cellphone ringing*", 1, 2)
		Wait(1300)
		TextPrintString("Jimmy: I need help! Please send help to my position!", 4, 2)
		Wait(4000)
		TextPrintString("Police: Sir, we'll send an officer but we need you to calm down and...", 3, 2)
		Wait(3000)
		VehicleSetCruiseSpeed(GaryVehicle, 21)
		TextPrintString("Jimmy: Sorry, but I'm too busy to use the phone right now!", 4, 2)
		Wait(5000)
		TextPrintString("Gary: CALLING THE COPS? YOU'RE NO FUN, JIMMY!", 3, 2)
		Wait(3000)
		TextPrintString("Jimmy: THINGS WON'T GO AS YOU WANT, GARY!", 3, 2)

end

PreBossBattleCutScene = function()

		F_ToggleHudElements(false)

	Wait(501)

		BlipRemoveFromChar(Gary2)
		SoundPlayStream("MS_FinalShowdownLow.rsm", MUSIC_DEFAULT_VOLUME)
		CameraSetXYZ(66.28, -312.72, 1.41, 70.09, -313.94, 1.29)

	Wait(500)
	
		CameraFade(1500, 1)
		
	Wait(501)

		PedMoveToXYZ(gPlayer, 0, 68.22, -313.84, 0.27)
		TextPrintString("Jimmy: Are you done running?", 3, 2)
		Wait(3050)
	
		CameraSetXYZ(71.87, -313.99, 2.15, 75.71, -315.11, 2.19)
		PedSetActionNode(Gary2, "/Global/PriOff/TargetAnimations/TargetPoint", "Act/Conv/Prioff.act")
		TextPrintString("Gary: Oh, but you see, James, you fell right into my trap!", 5, 2)
		Wait(5200)
	
		PedSetActionNode(Gary2, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		
	Wait(50)
		
		CameraSetXYZ(75.26, -312.66, 2.15, 71.76, -314.61, 2.08)
		PedSetActionNode(gPlayer, "/Global/C31Strt/PlayerStretch", "Act/Conv/C3_1.act")
		
	Wait(100)
	
		PedMoveToXYZ(Gary2, 0, 74.66, -313.22, 0.74)
		
	Wait(2000)
		
		CameraSetXYZ(68.95, -313.85, 1.82, 64.97, -313.71, 1.45)
		PedSetActionNode(Gary2, "/Global/PriOff/TargetAnimations/TargetGesture", "Act/Conv/PriOff.act")
		TextPrintString("Gary: I have been hiding my true self.", 3, 2)
		Wait(3100)
	
		CameraSetXYZ(75.26, -312.66, 2.15, 71.76, -314.61, 2.08)
		PedSetActionNode(gPlayer, "/Global/1_07/DontMess", "Act/Conv/1_07.act")
		TextPrintString("Gary: I. CAN. TRANSFORM!", 3, 2)
		Wait(3100)
	
		PedSetActionNode(gPlayer, "/Global/3_04/3_04_Anim/AlgieOhFace/OhFace", "Act/Conv/3_04.act")
		CameraSetXYZ(68.95, -313.85, 1.82, 64.97, -313.71, 1.45)
	
	Wait(100)
	
		PedDelete(Gary2)
		Gary3 = PedCreateXYZ(160, 72.65, -314.15, 0.65)
		PedSetPedToTypeAttitude(Gary3, 13, 2) --Sets Gary's attitude towards Jimmy to "Ignore"
		PedFaceXYZ(Gary3, 68.52, -313.88, 0.34)
		
	Wait(2100)
		
		CameraSetXYZ(71.87, -313.99, 2.15, 75.71, -315.11, 2.19)
		VehicleDelete(Jimmy2Vehicle)
		VehicleDelete(Gary2Vehicle)
		SoundPlay2D("RUSS_ROAR") --Plays RUSS_ROAR from the previously loaded 1_B.SEA
		PedSetActionNode(Gary3, "/Global/BOSS_Russell/Default_KEY/RisingAttacks/HeavyAttacks/RisingAttacks", "Act/Conv/Boss_Russell.act")
		PedSetActionNode(gPlayer, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		
	Wait(2800)
	
		CameraSetXYZ(68.95, -313.85, 1.82, 64.97, -313.71, 1.45)
		GameSetPedStat(gPlayer, 20, 120)
		PedSetActionNode(gPlayer, "/Global/2_S04/Anim/Laugh", "Act/Conv/2_04.act")
		PedSetActionNode(gPlayer, "/Global/NLockA/Unlocked/Default", "Act/Conv/NLockA.act")
		TextPrintString("Jimmy: Jokes on you, I can transform too!", 3, 2)
		Wait(3100)

		CameraSetXYZ(71.87, -313.99, 2.15, 75.71, -315.11, 2.19)
		F_ChangePlayerOutfit("Mascot")
		PedSetActionNode(Gary3, "/Global/1_07/BackUp", "Act/Conv/1_07.act")
		PedSetActionNode(gPlayer, "/Global/Chapter3Trans/JimmyBye", "Act/Conv/Chapt3Trans.act") --This animation ends with Jimmy's beta idle, so I use the next animation to freeze Jimmy in his beta pose
		PedSetActionNode(gPlayer, "/Global/NLockA/Unlocked/Default", "Act/Conv/NLockA.act") --This freezes a ped to the last frame of the previous animation
		
		SoundPlayStream("MS_ActionBeatBreak.rsm", MUSIC_DEFAULT_VOLUME)
		TextPrintString("Gary: BULLSHIT, THERE'S NO WAY YOU COULD POSSIBLY---", 2, 2)
		Wait(2100)
		
		CameraSetXYZ(68.81, -314.61, 0.87, 65.73, -312.21, -0.02)
		SoundPlay2D("Applause")
		SoundPlay2D("Applause")
		SoundPlay2D("Applause")

	Wait(1500)

		CameraSetXYZ(68.89, -313.84, 1.51, 65.02, -312.89, 1.10)
		SoundPlay2D("Applause")
		SoundPlay2D("Applause")
		SoundPlay2D("Applause")

	Wait(1500)

		CameraSetXYZ(68.77, -313.73, 1.77, 64.82, -314.20, 2.10)

	Wait(1500)

		CameraSetXYZ(70.44, -313.98, 0.72, 66.53, -313.72, 1.51)

	Wait(100)

		PedSetActionNode(gPlayer, "/Global/4_05/Anims/MascotActions/DanceD", "Act/Conv/4_05.act")
		TextPrintString("Jimmy: ACTIVATE BULL POWEEEEEEEEEEEEEEEEER!", 3, 2)
		Wait(3500)

		CameraSetXYZ(72.65, -313.85, 1.91, 76.09, -315.62, 2.90)
		PedSetActionNode(Gary3, "/Global/2_08Conv/ComeOn", "Act/Conv/2_08.act")
		TextPrintString("Gary: I'M STILL GONNA BEAT YOU!", 3, 2)
		SoundStopStream()
		Wait(3000)
		
		BossBattle()

end

BossBattle = function()

		CreateThread("T_GaryFightingStyle")

		--Invisible barrier, by Derpy54320
		local square = {93.00, -338.90, 60.12, -345.33, 52.38, -304.72, 77.88, -294.53}

		-- Fail conditions:
		failed = false
		OnPlayerDeath(function()
			failed = true
		end)
		KeepPlayerInSquare(true,5000,
			function(t)
				TextPrintString("Don't run away!\n("..math.ceil(t/1000)..")",0,1)
			end,
			function()
				failed = true
			end,
		unpack(square))

	--Round 1 Boss Fight

		SoundPlayStream("MS_FinalShowdown03High.rsm", MUSIC_DEFAULT_VOLUME)
		SoundEnableSpeech() --Restores peds' voices
		PlayerSetControl(1)
		F_ToggleHudElements(true)

	--Setup Gary:

		PedLockTarget(Gary3, gPlayer)
		PedSetActionTree(Gary3, "/Global/Nemesis", "Act/Anim/Nemesis.act") --Sets a fighting style
		PedSetAITree(Gary3, "/Global/GaryAI", "Act/AI/AI_Gary.act") --Sets the ped's AI to a specific AI.
		PedSetInfiniteSprint(Gary3, true)
		GameSetPedStat(Gary3, 4, 400)
		PedSetHealth(Gary3, 400)
		GameSetPedStat(Gary3, 5, 300) --Refer to https://derpy54320.github.io/Bully-LUA-Reference/script/stats.html for these stats
		GameSetPedStat(Gary3, 8, 800)
		GameSetPedStat(Gary3, 12, 500)
		GameSetPedStat(Gary3, 13, 60)
		GameSetPedStat(Gary3, 31, 10)
		GameSetPedStat(Gary3, 63, 1)
		GameSetPedStat(Gary3, 20, 165)
		PedSetDamageGivenMultiplier(Gary3, 2, 1.1) --Multiplies Gary's melee damage by 1.1
		AddBlipForChar(Gary3, 0, 34, 4)
		PedAttack(Gary3, gPlayer, 2) --Self explanatory, 2 sets the ped to ALWAYS attack a specific ped, even if another ped attacks him.

	Wait(1)

	--Setup Player:

		PlayerSetHealth(200) --Sets Jimmy's health to 200
		GameSetPedStat(gPlayer, 20, 130)
		CameraReturnToPlayer()
		PedShowHealthBar(Gary3, true, "N_GARY", true) --Shows Gary's health as a boss health bar
		
	Wait(500)
		
		TextPrintString("Defeat Gary!", 3, 1)
		
		repeat
		Wait(0)
		until PedGetHealth(Gary3) < 85 or failed

	Wait(100)

		SoundDisableSpeech()
		CameraFade(1000, 0)
		BlipRemoveFromChar(Gary3)
		Wait(1001)
		GameSetPedStat(gPlayer, 20, 100)
		GameSetPedStat(Gary3, 20, 100)
		SoundStopStream()
		PedSetActionNode(Gary3, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		PlayerSetControl(0)
		PedSetActionNode(gPlayer, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		PedStop(Gary3) --Both of these stop a ped
		PedClearObjectives(Gary3)
		
	Wait(1700)
		
	if failed then
		FailCutscene1()
	else
		PedDelete(Gary3)
		PlayerSetPosXYZ(68.57, -316.30, 0.35)
		PreBossBattlePT2Cutscene()
	end
end

FailCutscene1 = function()
			
	Wait(450)
		
		PlayerSetControl(0)
		PedStop(Gary3)
		PedClearObjectives(Gary3)

	Wait(500)

		CameraSetWidescreen(true)
		F_ToggleHudElements(false)
		ToggleHUDComponentVisibility(12, false)
		CameraSetXYZ(59.64, -303.16, 3.00, 56.96, -300.25, 2.39)
		PedSetPosXYZ(Gary3, 58.76, -300.86, 1.50)
		
	Wait(5)
	
		PedFaceXYZ(Gary3, -5.90, -261.86, 3.97)
		PlayerSetPosXYZ(48.24, -294.67, 1.37)
		GameSetPedStat(gPlayer, 20, 100)
		GameSetPedStat(Gary3, 20, 100)

	Wait(500)

		CameraFade(500, 1)
		PedMoveToXYZ(gPlayer, 2, -5.90, -261.86, 3.97)
		PedSetActionNode(Gary3, "/Global/1_11X1/Animations/LaughCyclic/LaughCyclic", "Act/Conv/1_11X1.act")
		TextPrintString("Gary: Running away? Hahaha! Enjoy your last moments, Hopkins!", 4, 2)
		Wait(4500)

		SoundPlayStream("MS_MissionEnd01.rsm", MUSIC_DEFAULT_VOLUME)
			
	Wait(1000)

		MissionFail()
		
	Wait(4500)

end

PreBossBattlePT2Cutscene = function()

		F_ToggleHudElements(false)
		Gary4 = PedCreateXYZ(160, 69.27, -323.60, 0.35)
		
	Wait(25)

		PedFaceXYZ(gPlayer, 69.27, -323.60, 0.35)
		PedFaceXYZ(Gary4, 68.57, -316.30, 0.35)
		
	Wait(25)
	
		PedSetActionNode(Gary4, "/Global/4_B2/ReactionAnims/GetUpHard", "Act/Conv/4_B2.act")
		PedSetActionNode(gPlayer, "/Global/4_B2/ReactionAnims/GetUpHard", "Act/Conv/4_B2.act")
		CameraSetXYZ(73.99, -319.28, 1.85, 70.01, -319.71, 1.66)
		
	Wait(1725)
	
		CameraFade(1000, 1)
		SoundPlayStream("MS_FinalShowdownMid.rsm", MUSIC_DEFAULT_VOLUME)
		
	Wait(2000)

		CameraSetXYZ(69.69, -318.12, 1.35, 67.37, -314.87, 1.23)
		
	Wait(2000)
	
		CameraSetXYZ(70.07, -321.47, 1.58, 68.36, -325.08, 1.37)

	Wait(500)

		TextPrintString("Gary: Don't think you've got the upper hand, James...", 3, 2)
		Wait(3000)
		TextPrintString("Gary: I still haven't used all of my power!", 2, 2)
		Wait(2000)

		CameraSetXYZ(69.97, -322.71, 1.25, 67.44, -325.44, 2.72)
		PedSetActionNode(Gary4, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")

	Wait(5)

		PedSetActionNode(Gary4, "/Global/6_02/GaryNIS/Russell/Russell01", "Act/Conv/6_02.act")
		EffectCreate("BottleRocketExplosion", 69.27, -323.60, 0.65) --Creates an effect at XYZ
		WeatherSet(5) --Sets the weather to storm, unused
		ClockSet(24)
		StartVibration(2, 2000, 255) --Makes the controller vibrate (Strenght, seconds, another kind of strenght)

	Wait(500)

		CreateThread("T_StopMusic")
		TextPrintString("Gary: BEHOLD! MY ULTIMATE POWER!", 3, 2)
		Wait(225)
		CameraSetXYZ(80.60, -330.90, 8.05, 77.66, -328.29, 7.33)
		PedSetActionNode(gPlayer, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")

	Wait(2500)

		PedSetActionNode(Gary4, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")

	Wait(1000)

		PedFaceXYZ(gPlayer, 67.74, -319.14, 0.35)
		
	Wait(5)
	
		PedSetActionNode(gPlayer, "/Global/3_S03/NIS/Crabble/Crabble01", "Act/Conv/3_S03.act")
		PedSetActionNode(Gary4, "/Global/2_S04/Anim/RochambeauNIS/TrentRules", "Act/Conv/2_S04.act")

	Wait(150)

		CameraSetXYZ(67.63, -315.70, 1.85, 70.11, -318.84, 1.85)
		TextPrintString("Gary: Well, James, I'm sure you now understand what you got yourself into.", 5.2, 2)
		Wait(5300)
		CameraSetXYZ(68.84, -322.81, 1.85, 71.40, -325.88, 1.89)
		PedSetActionNode(gPlayer, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		TextPrintString("Gary: I bet you're wondering how I became so powerful.", 3, 2)
		Wait(3000)
		PedSetActionNode(gPlayer, "/Global/3_S03/NIS/Crabble/Crabble01", "Act/Conv/3_S03.act")

	Wait(200)

		PedSetPosXYZ(Gary4, 69.27, -323.95, 0.35)
		CameraSetXYZ(67.68, -317.09, 1.45, 70.15, -314.09, 2.60)
		TextPrintString("Gary: Well, excluding fan-fictions...", 4, 2)
		Wait(4000)
		CameraSetXYZ(68.72, -323.06, 1.75, 71.08, -326.23, 1.75)
		TextPrintString("Gary: ...You don't actually care, do you?", 3, 2)
		Wait(3200)
		MusicCanNowStart = true
		PedSetActionNode(gPlayer, "/Global/3_S03/NIS/Crabble/Crabble01", "Act/Conv/3_S03.act")
		Wait(100)
		MusicFadeWithCamera(false) --Makes the music play even when the screen is black
		SoundPlayStream("MS_FinalShowdownHigh.rsm", MUSIC_DEFAULT_VOLUME)
		TextPrintString("Gary: THEN LET THE GAMES BEGIN!", 2, 2)
		PedSetActionNode(Gary4, "/Global/2_08Conv/ComeOn", "Act/Conv/2_08.act")
		CameraSetPath(PATH._BOSSFIGHTCUTCAM1, true) --The camera follows the path in BOSSFIGHTCAM1 from my custom .dat file
		CameraSetSpeed(7, 7, 7)
		CameraLookAtPath(PATH._BOSSFIGHTCUTCAM_LOOKAT1, true) --The camera will look at the coordinates in BOSSFIGHTCAM_LOOKAT1
		CameraLookAtPathSetSpeed(6, 6, 6)

	Wait(3000)

		CameraFade(800, 0)
		
	Wait(1500)

		CameraFade(500, 1)
		BossBattlePT2()

end

BossBattlePT2 = function()

		PedSetActionNode(gPlayer, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")

	Wait(50)

		CreateThread("T_GhostPicker")
		CreateThread("T_GhostsCanGoThroughWalls")
		SoundEnableSpeech()
		F_ToggleHudElements(true)
	
	Wait(1)
	
	--Setup Gary:
		
		PedSetActionTree(Gary4, "/Global/Nemesis", "Act/Anim/Nemesis.act")
		PedSetAITree(Gary4, "/Global/GaryAI", "Act/AI/AI_Gary.act")
		PedSetInfiniteSprint(Gary4, true)
		PedSetHealth(Gary4, 750)
		GameSetPedStat(Gary4, 4, 750)
		GameSetPedStat(Gary4, 8, 900)
		GameSetPedStat(Gary4, 12, 400)
		GameSetPedStat(Gary4, 13, 79)
		GameSetPedStat(Gary4, 31, 11)
		GameSetPedStat(Gary4, 63, 1)
		GameSetPedStat(Gary4, 20, 170)
		PedSetPedToTypeAttitude(Gary4, 13, 2)
		PedSetDamageGivenMultiplier(Gary4, 2, 1.35)
		PedSetDamageTakenMultiplier(Gary4, 0, 0)
		AddBlipForChar(Gary4, 0, 34, 4)
		PedLockTarget(Gary4, gPlayer)
		PedAttack(Gary4, gPlayer, 2)
		
	--Setup Player:

		PlayerSetHealth(200)
		GameSetPedStat(gPlayer, 5, 135)
		GameSetPedStat(gPlayer, 20, 130)
		PlayerSetControl(1)
		CameraReturnToPlayer()
		PedShowHealthBar(Gary4, true, "N_GARY", true)
		CameraSetSecondTarget(Gary4)
		PlayerIgnoreTargeting(true)
		FollowCamSetFightShot("1_B_X") --These change the camera style to Russell In The Hole's
		CameraSetShot(1, "1_B_X", false)

	Wait(500)
	
		TextPrintString("It's now or never! Finish him off!", 4, 1)
	
		repeat
		Wait(0)
		until failed or not PedIsValid(Gary4) or PedIsDead(Gary4)

	Wait(500)

		F_ToggleHudElements(false)

	Wait(500)

		PlayerSetInvulnerable(true)
		GameSetPedStat(gPlayer, 20, 100)
		PlayerSetHealth(200)
		CameraFade(1000, 0)
		PedMakeTargetable(gPlayer, false)
		PlayerSetControl(0)
		PedSetActionNode(gPlayer, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		PedStop(Gary4)
		PedClearObjectives(Gary4)
		SoundStopStream()
		SoundDisableSpeech()
		BlipRemoveFromChar(Gary4)

	Wait(1001)
	
		PedDelete(Gary4)
		KeepPlayerInSquare(false)
		OnPlayerDeath(nil)

	if failed then
		Wait(1000)
		FailCutscene2()
	else
		Wait(2000)
		MissionCompleted = true
		PostBossBattleCutScene()
	end
end

T_GhostPicker = function()

		repeat

			if PedIsValid(Gary4) then
				--TextPrintString("DEBUG: Waiting for ghosts...", 4, 1)
				Wait(2500)
				if not PedIsDead(Gary4) then
					X, Y, Z = PedGetOffsetInWorldCoords(gPlayer, 2.5, 2.5, 0)
					GhostPickerRNG = math.random(1, 2) --The game gets a random number between 1 and 2
					Wait(100)
					EffectSetGymnFireOn(true)
					GameSetPedStat(Gary4, 5, 500)
					if GhostPickerRNG == 1 then
						CreateThread("EarnestGhost")
						--TextPrintString("DEBUG: Nerds test.", 1, 1)
						repeat
						Wait(0)
						until not PedIsValid(EarnestGhost)
					elseif GhostPickerRNG == 2 then
						CreateThread("JohnnyDarbyGhosts")
						--TextPrintString("DEBUG: Preps & Greasers test.", 1, 1)
						repeat
						Wait(0)
						until GhostsDisappeared(GhostsTable)
					end
					--TextPrintString("DEBUG: Ghosts are gone.", 1, 1)
					EffectSetGymnFireOn(false)
					GameSetPedStat(Gary4, 5, 100)
					PedSetFlag(Gary4, 13, false)
					Wait(1000)
				end
			end

		Wait(0)
		until PedIsDead(Gary4)

			if not GhostsDisappeared(GhostsTable) then
				PedStop(Ghosts.ped)
				PedClearObjectives(Ghosts.ped)
				PedSetFlag(Ghosts.ped, 9, true)
				PedSetActionNode(Ghosts.ped, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
			elseif PedIsValid(EarnestGhost) then
				if PedIsPlaying(EarnestGhost, "/Global/N_Earnest/Offense/FireSpudGun", "Act/Anim/N_Earnest.act", true) then
					PedSetActionNode(EarnestGhost, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
				end
			end

end

EarnestGhost = function()

			if PedIsValid(Gary4) and not PedIsDead(Gary4) then
				LoadAnimationGroup("Earnest")
				X, Y, Z = PedGetOffsetInWorldCoords(gPlayer, 3, 3, 0)
				EarnestGhost = PedCreateXYZ(10, X, Y, Z)
				EffectCreate("BottleRocketExplosion", X, Y, Z + 0.5)
				PedSetEffectedByGravity(EarnestGhost, false)
				PedSetPedToTypeAttitude(EarnestGhost, 13, 0)
				PedSetStationary(EarnestGhost, true)
				PedSetDamageGivenMultiplier(EarnestGhost, 0, 0.5)
				PedMakeTargetable(EarnestGhost, false)
				PedSetInvulnerable(EarnestGhost, true)
				PedSetWeapon(EarnestGhost, 305, 20)
				Wait(1000)
				PedLockTarget(EarnestGhost, gPlayer)
				PedSetActionNode(EarnestGhost, "/Global/N_Earnest/Offense/FireSpudGun", "Act/Anim/N_Earnest.act")
				Wait(100)
				repeat
				Wait(0)
				until not PedIsPlaying(EarnestGhost, "/Global/N_Earnest/Offense/FireSpudGun", "Act/Anim/N_Earnest.act", true) or PedIsDead(Gary4)
				PedSetFlag(EarnestGhost, 9, true)
				PedStop(EarnestGhost)
				PedClearObjectives(EarnestGhost)
				Wait(1000)
				UnLoadAnimationGroup("Earnest")
			end

end

JohnnyDarbyGhosts = function()

		GhostsTable = {
			{ped = nil, id = 217, act = "/Global/G_Johnny", actfile = "Act/Anim/G_Johnny.act", ai = "/Global/AI", aifile = "Act/AI/AI.act"},
			{ped = nil, id = 37, act = "/Global/BOSS_Darby", actfile = "Act/Anim/BOSS_Darby.act", ai = "/Global/DarbyAI", aifile = "Act/AI/AI_DARBY_2_B.act"},
		}

		X, Y, Z = PedGetOffsetInWorldCoords(gPlayer, 2.5, 2.5, 0)

		for i, Ghosts in ipairs(GhostsTable) do
			Ghosts.ped = PedCreateXYZ(Ghosts.id, X, Y, Z)
			PedSetActionTree(Ghosts.ped, Ghosts.act, Ghosts.actfile)
			PedSetAITree(Ghosts.ped, Ghosts.ai, Ghosts.aifile)
			EffectCreate("BottleRocketExplosion", X, Y, Z + 0.5)
			GameSetPedStat(Ghosts.ped, 20, 135)
			GameSetPedStat(Ghosts.ped, 8, 900)
			GameSetPedStat(Ghosts.ped, 62, 0)
			PedSetDamageGivenMultiplier(Ghosts.ped, 2, 1.35)
			PedRecruitAlly(Gary4, Ghosts.ped)
			PedSetPedToTypeAttitude(Ghosts.ped, 13, 0)
			PedAttackPlayer(Ghosts.ped, 3)
			PedLockTarget(Ghosts.ped, gPlayer)
			PedMakeTargetable(Ghosts.ped, false)

		end

		--TextPrintString("DEBUG: Waiting to delete ped...", 4, 1)

	Wait(5000)

		for i, Ghosts in ipairs(GhostsTable) do
			--TextPrintString("DEBUG: Deleting ped...", 1, 1)
			PedSetFlag(Ghosts.ped, 9, true)
			PedStop(Ghosts.ped)
			PedClearObjectives(Ghosts.ped)
		end

	Wait(1000)

end

GhostsDisappeared = function(GhostsTable)

		for i, Ghosts in ipairs(GhostsTable) do
			if not PedIsValid(Ghosts.ped) then
				--TextPrintString("Ped is not valid, continuing script...", 1, 1)
				return true
			end
		end
		--TextPrintString("Ped is still valid.", 1, 1)
		return false

end

T_GhostsCanGoThroughWalls = function()

		repeat

			if PedIsValid(Ghost) then
				PedSetFlag(Ghost, 43, false)
			end

		Wait(0)
		until not PedIsValid(Gary4) or PedIsDead(Gary4)

end

FailCutscene2 = function()

		PlayerSetControl(0)
		DeleteAllMissionPeds()

	Wait(500)

		CameraSetWidescreen(true)
		F_ToggleHudElements(false)
		ToggleHUDComponentVisibility(12, false)
		CameraSetXYZ(59.28, -303.51, 3.29, 56.92, -300.34, 2.69)
		GaryFail2 = PedCreateXYZ(160, 58.76, -300.86, 1.50)
		DarbyFail2 = PedCreateXYZ(37, 58.32, -301.52, 1.50)
		JohnnyFail2 = PedCreateXYZ(23, 58.05, -301.95, 1.50)
		EarnestFail2 = PedCreateXYZ(10, 59.37, -300.11, 1.50)


	Wait(5)
		
		PedFaceXYZ(GaryFail2, -5.90, -261.86, 3.97)
		PedFaceXYZ(DarbyFail2, -5.90, -261.86, 3.97)
		PedFaceXYZ(JohnnyFail2, -5.90, -261.86, 3.97)
		PedFaceXYZ(EarnestFail2, -5.90, -261.86, 3.97)
		PlayerSetPosXYZ(48.24, -294.67, 1.37)
		GameSetPedStat(gPlayer, 20, 100)
		EffectSetGymnFireOn(true)

	Wait(500)

		CameraFade(500, 1)
		PedMoveToXYZ(gPlayer, 2, -5.90, -261.86, 3.97)
		PedSetActionNode(GaryFail2, "/Global/1_11X1/Animations/LaughCyclic/LaughCyclic", "Act/Conv/1_11X1.act")
		Wait(150)
		PedSetActionNode(DarbyFail2, "/Global/1_11X1/Animations/LaughCyclic/LaughCyclic", "Act/Conv/1_11X1.act")
		Wait(150)
		PedSetActionNode(JohnnyFail2, "/Global/1_11X1/Animations/LaughCyclic/LaughCyclic", "Act/Conv/1_11X1.act")
		Wait(150)
		PedSetActionNode(EarnestFail2, "/Global/1_11X1/Animations/LaughCyclic/LaughCyclic", "Act/Conv/1_11X1.act")
		TextPrintString("Gary: Running away? Hahaha! Enjoy your last moments, Hopkins!", 4, 2)
		Wait(4500)

		SoundPlayStream("MS_MissionEnd01.rsm", MUSIC_DEFAULT_VOLUME)
			
	Wait(1000)

		MissionFail()

	Wait(4500)

end

PostBossBattleCutScene = function()

		EffectSetGymnFireOn(false)
		DeleteAllMissionPeds()
		AreaOverridePopulation(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		AreaClearAllPeds()
		AreaClearSpawners()
		F_ChangePlayerOutfit("MascotNoHead")
		WeatherSet(2)
		ClockSet(22)
		SoundDisableSpeech()
		
	Wait(5)

		GameSetPedStat(gPlayer, 20, 100)
		CameraSetXYZ(71.24, -323.14, 0.91, 67.92, -320.92, 1.15)
		CameraAllowChange(false)
		Gary5 = PedCreateXYZ(130, 68.96, -321.25, 0.41)
		PedFaceXYZ(Gary5, 70.76, -321.11, 0.41)
		PlayerSetPosXYZ(70.76, -324.23, 0.34)
		Wait(100)
		
		PedSetActionNode(Gary5, "/Global/4_05/Anims/StealCostumeCut/KnockedOut", "Act/Conv/4_05.act")
		Wait(100)
		CameraFade(2000, 1)

	Wait(499)

		PedMoveToXYZ(gPlayer, 0, 69.47, -322.28, 0.42)
		Wait(1500)
		PedSetActionNode(gPlayer, "/Global/3_B/Animation/Crouch/Crouch", "Act/Conv/3_B.act")
		
	Wait(100)
	
		TextPrintString("Jimmy: Who's the boss? ME! Got it?", 3, 2)
		Wait(3000)
		TextPrintString("Gary: It's not over... not yet...", 3, 2)
		Wait(3100)
		
		PoliceCar = VehicleCreateXYZ(295, 86.30, -364.89, 0.33)
		Officer = PedCreateXYZ(97, 86.83, -366.97, 0.33)
		
	Wait(100)
		
		CameraAllowChange(true)
		VehicleFaceHeading(PoliceCar, 60)
		PedWarpIntoCar(Officer, PoliceCar) --Self explanatory
		CameraSetXYZ(68.89, -328.30, 2.08, 70.77, -332.45, 1.47) --(68.19, -326.90, 1.96, 69.71, -330.56, 1.40)
		VehicleEnableEngine(PoliceCar, true) --Turns on the lights
		VehicleSetEntityFlag(PoliceCar, 43, false)
		
	Wait(100)
		
		PedFaceXYZ(Gary5, 73.05, -315.37, 0.37)
		VehicleEnableSiren(PoliceCar, true) --Turns on the siren
		VehicleFollowPath(PoliceCar, PATH._POLICE)
		VehicleSetCruiseSpeed(PoliceCar, 16)
	
		repeat
		Wait(0)
		until PedIsInAreaXYZ(Officer, 68.90, -328.57, 0.32, 4, 0)

		VehicleStop(PoliceCar)
		
	Wait(500)
		
		VehicleEnableSiren(PoliceCar, false)
		VehicleEnableEngine(PoliceCar, false) --Turns off the lights
		
	Wait(100)
		
		PedExitVehicle(Officer) --Self explanatory
		
	Wait(1750)
		
		PedFaceXYZ(Officer, 70.46, -322.68, 0.34)
		TextPrintString("Officer: Hey, are you the one who made that call?", 4, 2)
		PedSetActionNode(Officer, "/Global/1_04/GaryPoint/GaryPointAnim", "Act/Conv/1_04.act")
		PedSetActionNode(Gary5, "/Global/4_B2/ReactionAnims/GetUpEasy", "Act/Conv/4_B2.act")

	Wait(4200)
	
		PedSetActionNode(gPlayer, "/Global/3_B/Animation/Stand/Stand", "Act/Conv/3_B.act")

	Wait(300)
		
		CameraSetXYZ(66.37, -331.08, 2.12, 69.33, -328.50, 1.33)
		PedMoveToXYZ(gPlayer, 0, 68.90, -328.57, 0.32)
		
	Wait(500)
		
		TextPrintString("Jimmy: Yes, my name is Jimmy Hopkins. I believe you're looking for this individual.", 5, 2)
		Wait(5000)
		CameraSetXYZ(68.02, -327.68, 1.65, 70.18, -331.05, 2.20)
		PedSetActionNode(Officer, "/Global/3_04/3_04_Anim/JohnnyIdle/JohnnyIdle", "Act/Conv/3_04.act")
		TextPrintString("Officer: Yes, Gary Smith. He's probably going to remain in the Happy Volts Asylum for a long time.", 5, 2)
		PedFaceXYZ(gPlayer, 69.40, -329.45, 0.30)
		Wait(5000)
		PedSetActionNode(Officer, "/Global/3_04/3_04_Anim/JohnnyIdle/Johnny2", "Act/Conv/3_04.act")
		TextPrintString("Officer: Thank you for your help, Mr. Hopkins.", 4, 2)
		Wait(4050)
		PedSetActionNode(Officer, "/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode", "Act/Anim/Ambient.act")
		
	Wait(50)
		
		PedMoveToXYZ(Officer, 0, 69.47, -322.28, 0.42)
		
	Wait(800)

		HideGeneralHealthBar()
		PedLockTarget(gPlayer, Officer, 3)
		PedFaceObject(gPlayer, Officer, 3, 1)
		PedLockTarget(gPlayer, Officer, 3)

	Wait(2500)
		
		PedLockTarget(gPlayer, -1)
		CameraSetXYZ(69.66, -320.50, 1.40, 68.82, -324.17, 2.75) --CameraSetXYZ(65.87, -328.93, 2.45,68.75, -326.27, 1.71)
		PlayerFaceHeading(0, 1)
		TextPrintString("Officer: Get up, you monster.", 2, 2)
		Wait(500)
		PedSetActionNode(Gary5, "/Global/4_B2/ReactionAnims/GetUpHard", "Act/Conv/4_B2.act")
		
	Wait(4500)
		
		CameraFade(500, 0)
		EndingAndCredits()
		
end

EndingAndCredits = function()

	Wait(501)

		WeatherSet(0) --Sets the weather to sunny
		AreaTransitionXYZ(0, 263.81, -112.78, 6.21)
		PedDelete(Officer)
		PedDelete(Gary5)
		F_ChangePlayerOutfit("Uniform")
		ClockSet(9)
		AreaClearAllVehicles()
		AreaOverridePopulation(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		AreaClearAllPeds()
		AreaClearSpawners()
		PlayerClearLastVehicle()
		CameraSetXYZ(265.65, -114.57, 8.36, 262.13, -113.30, 6.95)
		
	Wait(1500)
		
		CameraFade(600, 1)
		
	Wait(50)
		
		SoundPlayStream("MS_6B_EndlessSummerCreditsNIS.rsm", MUSIC_DEFAULT_VOLUME)
		SimonBestia = PedCreateXYZ(85, 280, -103.30, 6.18)
		PedFaceXYZ(SimonBestia, 280, -104.69, 6.21)
		PedIgnoreAttacks(SimonBestia, true)
		PedIgnoreStimuli(SimonBestia, true)
		DeadpoolXYZ = PedCreateXYZ(147, 280.11, -105.39, 6.18)
		PedFaceXYZ(DeadpoolXYZ, 280, -103.30, 6.18)
		PedIgnoreAttacks(DeadpoolXYZ, true)
		PedIgnoreStimuli(DeadpoolXYZ, true)
		Derpy54320 = PedCreateXYZ(165, 281.07, -105.47, 6.18)
		PedFaceXYZ(Derpy54320, 280, -103.30, 6.18)
		PedSetWeapon(Derpy54320, 414, 1)
		PedIgnoreAttacks(Derpy54320, true)
		PedIgnoreStimuli(Derpy54320, true)
		Gary6 = PedCreateXYZ(130, 262.13, -112.78, 6.20)
		Pete = PedCreateXYZ(134, 262.71, -113.68, 6.20)
		PedFaceXYZ(gPlayer, 262.13, -112.78, 6.20)
		PedFaceXYZ(Gary6, 263.81, -112.78, 6.21)
		PedFaceXYZ(Pete, 263.81, -112.78, 6.21)
		PedIgnoreAttacks(Gary6, true)
		PedIgnoreAttacks(Pete, true)
		PedIgnoreStimuli(Gary6, true)
		PedIgnoreStimuli(Pete, true)
		PedClearAllWeapons(DeadpoolXYZ)
		PedClearAllWeapons(SimonBestia)

		PedSetActionNode(gPlayer, "/Global/3_05/Animations/Player/Player01", "Act/Conv/3_05.act")
		TextPrintString("Jimmy: And that's the dream I had.", 2.5, 2)
		Wait(2600)
		CameraSetXYZ(264.25, -110.89, 7.79, 261.72, -113.92, 7.14)
		PedSetActionNode(Gary6, "/Global/1_11X2/CutPlan/Gary92", "Act/Conv/1_11X2.act")
		TextPrintString("Gary: I liked the part where I turned into a werewolf.", 3.5, 2)
		Wait(3600)
		PedFaceXYZ(gPlayer, 262.71, -113.68, 6.20)
		CameraSetXYZ(265.46, -113.30, 7.72, 261.56, -113.30, 6.83)
		PedSetActionNode(Pete, "/Global/1_11X2/CutPlan/Pete94", "Act/Conv/1_11X2.act")
		TextPrintString("Pete: But what about me?", 2.5, 2)
		Wait(2600)
		CameraSetXYZ(262.47, -116.17, 7.42, 263.06, -112.23, 7.14)
		PedSetActionNode(gPlayer, "/Global/5_04/PlayerScratch", "Act/Conv/5_04.act")
		TextPrintString("Jimmy: Sorry, Pete, but I don't remember you at all.", 3.5, 2)
		Wait(3600)
		
		CameraSetXYZ(260.63, -113.12, 6.87, 264.22, -111.36, 6.73)
		
		PedMoveToXYZ(gPlayer, 0, 227.32, -73.80, 6.22)
		GameSetPedStat(gPlayer, 20, 90)

	Wait(350)

		PedMoveToXYZ(Gary6, 0, 227.32, -72.80, 6.22)
		GameSetPedStat(Gary6, 20, 95)

	Wait(350)

		PedMoveToXYZ(Pete, 0, 227.32, -71.80, 6.22)
		GameSetPedStat(Pete, 20, 95)
		
	Wait(3500)

		CameraSetXYZ(279.37, -104.46, 7.54, 281.49, -101.09, 7.90)
		PedSetActionNode(SimonBestia, "/Global/C31Strt/FattyAvoid", "Act/Conv/C3_1.act")
		TextPrintString("SimonBestia: Deadpool-kun, Derpy-chan, arigatou for your help!", 4, 2)
		Wait(4100)
		CameraSetXYZ(279.15, -103.81, 7.33, 282.05, -106.56, 7.32)
		PedSetActionNode(DeadpoolXYZ, "/Global/C4/Animations/Teacher/TeacherChew", "Act/Conv/C4.act")
		TextPrintString("DeadpoolXYZ: Stop being a weeb.", 3, 2)
		Wait(3100)
		PedSetActionNode(DeadpoolXYZ, "/Global/2_01/Anim/EdnaShrug", "Act/Conv/2_01.act")
		TextPrintString("DeadpoolXYZ: But yeah, no problem. :V", 3.3, 2)
		Wait(3400)
		CameraSetXYZ(279.99, -104.26, 7.52, 280.89, -108.13, 7.99)
		PedSetActionNode(DeadpoolXYZ, "/Global/6_02/SchoolGatesNIS/Jimmy/Jimmy02", "Act/Anim/6_02.act")
		TextPrintString("DeadpoolXYZ: To be honest, I was worried anyone could sneak into the office at any point.", 4.7, 2)
		Wait(4800)
		CameraSetXYZ(280.93, -104.37, 7.62, 277.83, -106.90, 7.75)
		PedSetActionNode(DeadpoolXYZ, "/Global/2_06/NISPINKY/Jimmy/Jimmy01", "Act/Conv/2_06.act")
		TextPrintString("DeadpoolXYZ: But, I guess your script wasn't THAT much of a disaster.", 4, 2)
		Wait(4100)
		CameraSetXYZ(282.85, -103.41, 7.64, 279.52, -105.51, 6.97)
		PedSetActionNode(Derpy54320, "/Global/PriOff/TargetAnimations/TargetPoint", "Act/Conv/PriOff.act")
		TextPrintString("Derpy54320: Let's celebrate. Here, I brought the Bee Movie script.", 3.3, 2)
		Wait(1500)
		CameraSetXYZ(280.27, -105.14, 7.52, 284.21, -105.71, 7.15)
		Wait(1500)
		TextPrintString("Derpy54320: According to all known laws of aviation, there is no way a bee should...", 3, 2)
		PedSetPosXYZ(SimonBestia, 271.73, -113.51, 6.20)
		PedSetPosXYZ(DeadpoolXYZ, 270.52, -113.50, 6.20)
		Wait(2700)
		PedMoveToXYZ(DeadpoolXYZ, 0, 270.36, -123.50, 7.87)
		PedMoveToXYZ(SimonBestia, 0, 271.74, -123.42, 7.87)
		Wait(300)
		CameraSetXYZ(278.70, -106.53, 7.62, 280.75, -103.11, 7.26)
		PedStop(Derpy54320)
		Wait(2500)
		CameraSetXYZ(269.25, -110.99, 7.48, 270.99, -114.58, 7.61)
		PedFaceXYZ(Derpy54320, 271.74, -123.42, 7.87)
		Wait(2500)
		CameraSetXYZ(279.52, -106.57, 7.22, 282.98, -104.56, 7.25)
		
	Wait(1250)
		
		PedMoveToXYZ(Derpy54320, 0, 271.74, -123.42, 7.87)
		
	Wait(500)
		
		CameraSetXYZ(288.71, -109.10, 11.66, 284.72, -109.21, 11.31)

	Wait(100)

		TextPrintString("And that was 'The Myth' my first custom mission!", 5, 1)
		Wait(5000)
		TextPrintString("Special thanks to\nDeadpoolXYZ and Derpy54320 for helping through various parts in the mod!", 6, 1)
		Wait(5900)
		TextPrintString("Gary's werewolf model was made by CautiousYoung, I would've probably never made this mod if that didn't exist.", 7, 1)
		GameSetPedStat(gPlayer, 20, 100)
		PlayerSetPosXYZ(241.35, -72.20, 6.15)
		Wait(100)
		CameraSetXYZ(236.30, -70.93, 6.83, 239.62, -73.15, 7.05)
		Wait(6000)
		DeleteAllMissionPeds()
		TextPrintString("I hope you enjoyed this mission just as much as I enjoyed making it!", 5, 1)
		CameraSetXYZ(230.20, -60.19, 20.87, 227.21, -62.19, 22.61)
		Wait(6000)

		MissionSucceed()

end

MissionCleanup = function()

		if PlayerIsInAnyVehicle() then
			PlayerDetachFromVehicle()
		end

		AreaDisableCameraControlForTransition(true)
		ToggleHUDComponentVisibility(0, true)
		F_ToggleHudElements(true)
		PlayerWeaponHudLock(false)
		MusicFadeWithCamera(true)
		UnpauseGameClock(true)
		SoundStopStream()
		PedStop(gPlayer)

		if not PlayingMission then --If you haven't actually played the mission because you didn't meet the chapter requirement/Exited from the menu
			ToggleHUDComponentVisibility(42, true)
			PedSetEffectedByGravity(gPlayer, true)
			SetAmbientPedsIgnoreStimuli(false)
			PedSetFlag(gPlayer, 108, false)
		else
			AreaSetDoorLocked(TRIGGER._DT_tschool_RoofDoor, true) --Locks the roof door outside of the school
			AreaSetDoorLocked(TRIGGER._ISCHOOL_DOOR25, true) --Locks the roof door inside of the school
			AreaClearAllVehicles()
			PedResetTypeAttitudesToDefault()
			AreaRevertToDefaultPopulation()
			NonMissionPedGenerationEnable()
			AreaEnableAllPatrolPaths() --Restores prefects
			AreaClearAllPeds()
			WeatherSet(4)
			if EffectSetGymnFireOn() == true then
				EffectSetGymnFireOn(false)
			end
			ClothingRestore() --Restores the clothing saved at the beginning
			ClothingBuildPlayer()
			PlayerSetHealth(200)
			PlayerSetInvulnerable(false)
			PedMakeTargetable(gPlayer, true)
			Wait(5)
			AreaTransitionXYZ(14, -508.42, 323.90, 31.41)
			Wait(5)
			ClockSet(StartH, StartM)
			PedFaceXYZ(gPlayer, -509.38, 323.91, 31.41)
			Wait(350)
			FollowCamDefaultFightShot() --Restores the default camera
			DisablePunishmentSystem(false)
			SoundUnLoadBank("MISSION\\1_09.bnk") --Unloads a specific .SEA file
			SoundUnLoadBank("MISSION\\1_B.bnk")
			DATUnload(2)
		end

		SoundEnableSpeech()
		SoundEnableSpeech_ActionTree()
		CameraSetWidescreen(false)
		CameraReturnToPlayer()
		CameraReset()
		PlayerSetControl(1)
		AreaDisableCameraControlForTransition(false)

end


--Custom functions
F_ToggleHudElements = function(Boolean)

		ToggleHUDComponentVisibility(4, Boolean) --Shows/Doesn't show the healthbar
		ToggleHUDComponentVisibility(11, Boolean) --Shows/Doesn't show the radar

end

F_LoadAnims = function()

	ActTreeTable = {
		"Act/Conv/Chap5Trans.act",
		"Act/Conv/PriOff.act",
		"Act/Conv/C3_1.act",
		"Act/Conv/Boss_Russell.act",
		"Act/Conv/1_03.act",
		"Act/Conv/2_04.act",
		"Act/Conv/2_B.act",
		"Act/Conv/2_S04.act",
		"Act/Conv/3_B.act",
		"Act/Conv/5_04.act"
	}
	
	for i, ActionTree in ActTreeTable, nil, nil do
		LoadActionTree(ActionTree)
	end

	AnimGroupsTable = {
		"2_S04CharSheets",
		"Ambient",
		"Ambient2",
		"Ambient3",
		"Area_Asylum",
		"Boxing",
		"B_Striker",
		"C_Wrestling",
		"DO_Striker",
		"DO_Grap",
		"DO_StrikeCombo",
		"DO_Edgar",
		"EnglishClass",
		"DodgeBall",
		"DodgeBall2",
		"F_Crazy",
		"F_Adult",
		"F_Nerds",
		"Grap",
		"G_Grappler",
		"G_Johnny",
		"G_Striker",
		"GEN_Social",
		"JV_Asylum",
		"LE_Orderly",
		"MINICHEM",
		"N2B Dishonerable",
		"Nemesis",
		"nerdBar1",
		"NIS_1_04",
		"NIS_1_11",
		"NIS_2_06_1",
		"NIS_2_S04",
		"NIS_3_04",
		"NIS_3_05",
		"NIS_3_S03_B",
		"NIS_3_R09_N",
		"NIS_4_B2",
		"NIS_6_03",
		"NLock01A",
		"NPC_Adult",
		"NPC_AggroTaunt",
		"NPC_Chat_1",
		"NPC_Chat_2",
		"NPC_Chat_F",
		"NPC_Cheering",
		"NPC_Love",
		"NPC_Mascot",
		"NPC_NeedsResolving",
		"NPC_Principal",
		"NPC_Shopping",
		"NPC_Spectator",
		"N_Ranged",
		"N_Striker",
		"N_Striker_A",
		"N_Striker_B",
		"Px_Ladr",
		"P_Grappler",
		"P_Striker",
		"Russell",
		"Russell_PBomb",
		"SCBell",
		"Straf_Wrest",
		"W_SpudGun"
	}

	for i, AnimationGroup in AnimGroupsTable, nil, nil do
		LoadAnimationGroup(AnimationGroup)
	end

end

F_ChangePlayerOutfit = function(OutfitName)

		ClothingSetPlayerOutfit(OutfitName) --Changes the outfit to the specified one
		ClothingBuildPlayer() --Needed when changing outfits

end

T_StopMusic = function()

		repeat
			if not MusicCanNowStart then
				SoundStopStream() --When SoundStopStream is used, the game stops the music and then starts the walking theme shortly after, but if we constantly stop the music, the game won't play anything
				SoundStopInteractiveStream()
			end
		Wait(0)
		until MusicCanNowStart

end


--DeadpoolXYZ's functions
function SettingsMenu()

		LoadAnimationGroup("4_04_FunhouseFun")
		PedSetEffectedByGravity(gPlayer, false)

		if AreaGetVisible() == 14 then --Boys' Dorm
			AreaClearAllPeds()
			AreaOverridePopulation(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
			PlayerSetPosXYZ(-508.50, 323.85, 31.55)
			CameraSetXYZ(-507.68, 324.81, 32.61, -511.61, 322.47, 33.06)
		elseif AreaGetVisible() == 50 then --Carnival Souvenirs
			PlayerSetPosXYZ(-786.86, 52.90, 7.28)
			CameraSetXYZ(-787.58, 52.08, 8.38, -784.04, 53.84, 8.93)
		elseif AreaGetVisible() == 57 then --Dropouts safehouse
			PlayerSetPosXYZ(-659.34, 244.65, 15.42)
			CameraSetXYZ(-660.22, 245.32, 16.39, -657.31, 240.61, 17.27)
		end

	Wait(500)

		PedSetActionNode(gPlayer, "/Global/404Conv/UseMonitor", "Act/Conv/4_04.act")

	Wait(150)

		CameraFade(500, 1)

		Title = "The Myth"
		Setting = "Start from:"
		Instructions = "Press ~o~ to quit"
		options = {
			{text = "Beginning", event = Intro},
			{text = "Bike Chase", event = F_BikeChase},
			{text = "Boss Fight", event = F_BossFight},
			--{text = "DEBUG: Boss Fight PT2", event = F_BossFightPT2}
		}
		
		Selection = 1

		repeat

			TextPrintString(Title.."\n\n"..Setting.."\n"..options[Selection].text.."\n\n\n\n"..Instructions, 1, 1)
			TextPrintString("\n\n\nAuthor:\nSimonBestia\n\nSpecial Thanks:\nDeadpoolXYZ & Derpy54320", 1, 2)

			if IsButtonBeingPressed(0, 0) then
				SoundPlay2D("NavDwn")
				Selection = Selection - 1
				if Selection < 1 then
					Selection = table.getn(options)
				end
			elseif IsButtonBeingPressed(1, 0) then
				SoundPlay2D("NavUp")
				Selection = Selection + 1
				if Selection > table.getn(options) then
					Selection = 1
				end
			elseif IsButtonBeingPressed(8, 0) then
				ToggleHUDComponentVisibility(42, false)
				SoundPlay2D("WrongBtn")
				MissionFail()
				SoundPlayStream("MS_MissionEnd01.rsm", MUSIC_DEFAULT_VOLUME) --Plays a music
				Wait(3000)
			end

		Wait(0)
		until IsButtonBeingPressed(7, 0)

		SoundPlay2D("RightBtn")
		ActualMissionSetup()
		PlayingMission = true
		CameraFade(600, 0) --Makes the camera fade out

	Wait(700)

		PedSetEffectedByGravity(gPlayer, true)
		ClockSet(22) --Self explanatory
		WeatherSet(2) --Sets the weather to rain
		
		if Selection <= 3 then
			F_ChangePlayerOutfit("Starting") --Sets the starting outfit
		end

		repeat
		Wait(0)
		until SystemIsReady() and not IsStreamingBusy()

		options[Selection].event()

end

function F_BikeChase()

		AreaTransitionXYZ(0, 212.74, -73.08, 8.59)
		AreaDisableAllPatrolPaths()
		SoundPlayStream("MS_FinalShowdown03Mid.rsm", MUSIC_DEFAULT_VOLUME)
		KartChase()

end

function F_BossFight()

		AreaDisableCameraControlForTransition(true) --Disables the automatic camera fade in when using areatransitionxyz
		AreaTransitionXYZ(0, 64.54, -313.47, 0.37)
		Gary2 = PedCreateXYZ(130, 72.65, -314.15, 0.65)
		PedFaceXYZ(Gary2, 64.54, -313.47, 0.37)
		Jimmy2Vehicle = VehicleCreateXYZ(277, 65.04, -315.82, 0.37)
		Gary2Vehicle = VehicleCreateXYZ(289, 73.05, -315.37, 0.37)
		AreaDisableCameraControlForTransition(false) --Enables it again
		PreBossBattleCutScene()

end

--[[function F_BossFightPT2()

		AreaDisableCameraControlForTransition(true)
		AreaTransitionXYZ(0, 68.57, -316.30, 0.35)
		F_ChangePlayerOutfit("Mascot")
		AreaDisableCameraControlForTransition(false)
		PreBossBattlePT2Cutscene()

end]]

function T_GaryFightingStyle()

Melee = {
	{Anim = "/Global/BOSS_Darby/Offense/Short/Grapples/HeavyAttacks/Catch_Throw", Act = "BOSS_Darby.act"},
	{Anim = "/Global/DO_Striker_A/Offense/Medium/HeavyAttacks/OverhandSwing", Act = "DO_Striker_A.act"},
	{Anim = "/Global/Crazy_Basic/Offense/Medium/GrapplesNEW/GrapplesAttempt", Act = "Crazy_Basic.act"},
	{Anim = "/Global/BOSS_Russell/Offense/GroundAttack/GroundStomp1", Act = "BOSS_Russell.act"},
	{Anim = "/Global/BOSS_Russell/Defense/Evade/EvadeInterrupt/EvadeInterrupt", Act = "BOSS_Russell.act"},
	{Anim = "/Global/G_Johnny/Offense/Special/SpecialActions/LightAttacks/Shin/HeavyAttacks/RoundHouseKick_L/AxeKicks", Act = "G_Johnny.act"},
	{Anim = "/Global/G_Johnny/Default_KEY/RisingAttacks/HeavyAttacks/RisingAttacks", Act = "G_Johnny.act"}
}

Grapples = {
	{Anim = "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/PowerBomb/GIVE", Act = "Act/Anim/BOSS_Russell.act"},
	{Anim = "/Global/Actions/Grapples/Front/Grapples/GrappleMoves/BearHug", Act = "Act/Anim/G_Grappler_A.act"},
	{Anim = "/Global/WrestlingACT/Attacks/Grapples/Grapples/BackGrapples/Choke", Act = "WrestlingACT.act"},
	{Anim = "/Global/Actions/Grapples/Mount/GrappleMoves/Spit/GIVE", Act = "B_Striker_A.act"}
}

	Gary = Gary3
	CheckGary(Gary)
	
	Gary = Gary4
	CheckGary(Gary)
	
	
end

function CheckGary(Gary)

	IsAttacking = false
	IsGrappling = false
	
	repeat
	
		if PedIsPerformingMove(Gary) and not IsAttacking then
			if PedIsValid(Ghost) and PedGetHealth(Gary) <= 350 then
				PedSetFlag(Gary, 13, true) --Attacks against Gary will deal damage, but won't affect him
			else
				PedSetFlag(Gary, 13, false)
			end
				if math.random(1) == 1 then
					IsAttacking = true
					rand = math.random(1, table.getn(Melee))
					PedSetActionNode(Gary, Melee[rand].Anim, Melee[rand].Act)
					--TextPrintString("DEBUG Is attacking", 1, 2)
				end
		elseif PedIsPerformingMove(Gary) and not IsAttacking then
			IsAttacking = true
		end
		
		if not PedIsPerformingMove(Gary) and IsAttacking then
			IsAttacking = false
			--TextPrintString("DEBUG Is not attacking", 1, 2)
			Wait(1000)
		end
		
		if PedIsPlaying(Gary, "/Global/Actions/Grapples/Front/Grapples/Hold_Idle/GrappleLoco/NPC/GIVE", true) and not IsGrappling and not IsAttacking then
			IsGrappling = true
			rand = math.random(1, table.getn(Grapples))
			PedSetActionNode(Gary, Grapples[rand].Anim, Grapples[rand].Act)		
			--TextPrintString("DEBUG Is grabbing", 1, 2)
		end
		
		if not PedIsValid(PedGetGrappleTargetPed(Gary)) and IsGrappling then
			IsGrappling = false
			--TextPrintString("DEBUG Is not grabbing", 1, 2)
		end		
		
		Wait(0)
		until PedIsDead(Gary)

end

function PedIsPerformingMove(Gary)
	
	IsPerforming = false

	if PedMePlaying(Gary, "Offense") or PedMePlaying(Gary, "Defense") then
		IsPerforming = true
	end
		
	return IsPerforming
		
end

function T_FailDistance()
			
		repeat
	
			Distance = DistanceBetweenPeds2D(gPlayer, Gary2)
			if Distance > 78 then
				PlayerSetControl(0)
				VehicleStop(JimmyVehicle)

			Wait(50)

				TextPrintString("Gary got away.", 1, 1)
				TerminateThread(T_KartChaseConversation)
				SoundPlayStream("MS_MissionEnd01.rsm", MUSIC_DEFAULT_VOLUME)
				CameraSetWidescreen(true)

			Wait(800)

				F_ToggleHudElements(false)

				if PlayerIsInAnyVehicle() then --Self explanatory
					local X1, Y1, Z1 = PedGetOffsetInWorldCoords(gPlayer, -0.45, 1.35, 1.0000000476837)
					local X2, Y2, Z2 = PedGetOffsetInWorldCoords(gPlayer, 0.45, -0.69999998807907, 0.8000000476837)
					CameraSetXYZ(X1, Y1, Z1, X2, Y2, Z2)
				else --Alternate camera angles to be used when the Player is not on a vehicle
					local X1, Y1, Z1 = PedGetOffsetInWorldCoords(gPlayer, -0.45, 1.35, 1.5000000476837)
					local X2, Y2, Z2 = PedGetOffsetInWorldCoords(gPlayer, 0.45, -0.69999998807907, 1.3000000476837)
					CameraSetXYZ(X1, Y1, Z1, X2, Y2, Z2)
					ExecuteActionNode(gPlayer, "/Global/1_11X2/Failure", "Act/Conv/1_11X2.act")
				end

				ClearTextQueue()
				MissionFail()
			
			Wait(2000)

			elseif Distance > 60 then
				TextPrintString("Gary is getting away!", 1, 1)
			end
			
		Wait(0)
		until ChaseDone
		
end


--Derpy54320's functions
function OnPlayerDeath(f)
	if gThreadOPD then
		TerminateThread(gThreadOPD)
	end
	if f then
		gThreadOPD = function()
			while not PedIsDead(gPlayer) do
				Wait(0)
			end
			gThreadOPD = nil
			f()
		end
		gThreadOPD = CreateThread("gThreadOPD")
	else
		gThreadOPD = nil
	end
end
do
	local out
	local function len2d(x1,y1,x2,y2)
		local x,y = x1-x2,y1-y2
		return math.sqrt(x*x+y*y)
	end
	local function triArea(x1,y1,x2,y2,x3,y3)
		local a,b,c = len2d(x1,y1,x2,y2),len2d(x2,y2,x3,y3),len2d(x3,y3,x1,y1)
		local s = (a+b+c)/2.0
		return math.sqrt(s*(s-a)*(s-b)*(s-c))
	end
	local function isPointInRect(x,y,x1,y1,x2,y2,x3,y3,x4,y4)
		return
			0.001 > math.abs(
				(
					triArea(x1,y1,x2,y2,x,y)
					+triArea(x2,y2,x3,y3,x,y)
					+triArea(x3,y3,x4,y4,x,y)
					+triArea(x4,y4,x1,y1,x,y)
				)-(
					triArea(x1,y1,x2,y2,x3,y3)
					+triArea(x3,y3,x4,y4,x1,y1)
				)
			)
	end
	function IsPlayerInSquare(x1,y1,x2,y2,x3,y3,x4,y4)
		local px,py = PlayerGetPosXYZ()
		return isPointInRect(px,py,x1,y1,x2,y2,x3,y3,x4,y4)
	end
	function KeepPlayerInSquare(on,ms,leaving,left,x1,y1,x2,y2,x3,y3,x4,y4)
		if gThreadKPIS then
			TerminateThread(gThreadKPIS)
		end
		if on then
			gThreadKPIS = function()
				while true do
					if IsPlayerInSquare(x1,y1,x2,y2,x3,y3,x4,y4) then
						out = nil
					else
						if out then
							local t = ms-(GetTimer()-out)
							leaving(t)
							if t <= 0 then
								gThreadKPIS = nil
								left()
								return
							end
						else
							out = GetTimer()
						end
					end
					Wait(0)
				end
			end
			gThreadKPIS = CreateThread("gThreadKPIS")
		else
			gThreadKPIS = nil
		end
	end
end