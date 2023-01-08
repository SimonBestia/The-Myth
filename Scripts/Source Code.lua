--[[The Myth
	*By SimonBestia
	 *Special Thanks to deadpoolXYZ and Derpy54320 for helping with various parts of the mod!
]]

--Random stuff to store (don't touch)--
TblRoofTopProps = {}
GhostsTable = {}
TblEndingPeds = {}
NemesisAnims = {'Russell', 'Russell_PBomb', 'F_Crazy', 'Boxing', 'B_Striker', 'C_Wrestling', 'DO_Striker', 'DO_Grap', 'DO_StrikeCombo', 'N2B Dishonerable', '3_BFightJohnnyV', 'P_Striker', 'DO_Edgar', 'Nemesis', 'G_Grappler', 'G_Striker', 'P_Grappler', 'P_Striker', 'Straf_Wrest'}
InMission = true


--Settings--
PS2 = false -- Unstable. But why not?
SkipText = false
DebugOn = false -- Allows selecting Part 2 of the Boss Fight at the beginning


MissionSetup = function()

		repeat -- Starts the script only after the game is ready, it's better than Wait(Numberhere) just in case someone with a very weak PC plays this
		Wait(0) -- Waits (milliseconds). Wait(0) required for loops
		until SystemIsReady() and not IsStreamingBusy()

	-- Audio stuff:
		SoundDisableSpeech_ActionTree() -- This disables lines that a ped might say on its own (Like idle quotes), useful to avoid situations where a ped interrupts itself just to play a quote

	-- Setup Player:
		PlayerSetControl(0) -- Disables the player's movement
		PlayerUnequip() -- Self-explanatory

	-- HUD:
		ToggleHUDComponentVisibility(0, false) -- Doesn't show the troublemeter
		ToggleHUDComponentVisibility(20, false) -- Doesn't show the weapon wheel
		F_ToggleHUDElements(false) -- Custom function
		PauseGameClock() -- Self-explanatory, also removes its HUD

end

main = function()

		-- Check for current chapter:
		if ChapterGet() < 4 then -- 4 = Chapter5
			YouShallNotPlay() -- Starts YouShallNotPlay = function()
		else
			SettingsMenu()
		end

end

MissionCleanup = function()

		for i, Prop in TblRoofTopProps do
			DeletePersistentEntity(Prop.ID, Prop.Pool)
		end
		if PlayerIsInAnyVehicle() then
			PlayerDetachFromVehicle()
			VehicleDelete(JimmyVehicle)
		end

		ToggleHUDComponentVisibility(0, true)
		ToggleHUDComponentVisibility(20, true)
		F_ToggleHUDElements(true)
		MusicFadeWithCamera(true)
		UnpauseGameClock(true)
		SoundStopStream()
		PedStop(gPlayer)

		if not PlayingMission then -- If you haven't actually played the mission because you didn't meet the chapter requirement/You exited from the menu
			ToggleHUDComponentVisibility(42, true)
			PedSetEffectedByGravity(gPlayer, true)
			SetAmbientPedsIgnoreStimuli(false)
			PedSetFlag(gPlayer, 108, false)
		else
			if not AreaIsDoorLocked(TRIGGER._DT_tschool_RoofDoor) then 
				AreaSetDoorLocked(TRIGGER._DT_tschool_RoofDoor, true)
			end
			if AreaGetVisible() == 2 then
				if not AreaIsDoorLocked(TRIGGER._ISCHOOL_DOOR25) then
					AreaSetDoorLocked(TRIGGER._ISCHOOL_DOOR25, true) -- Locks the roof door inside of the school
				end
			end
			AreaClearAllVehicles()
			DeleteAllMissionPeds()
			WeatherSet(4)
			WeatherRelease()
			if EffectSetGymnFireOn() == true then
				EffectSetGymnFireOn(false)
			end
			ClothingRestore() -- Restores the clothing saved at the beginning
			ClothingBuildPlayer()
			PlayerSetHealth(200)
			PedMakeTargetable(gPlayer, true)
			Wait(5)
			StopPedProduction(false)
			ClockSet(StartH, StartM)
			Wait(350)
			DisablePunishmentSystem(false)
			SoundUnLoadBank('1_09.bnk') -- Unloads a specific .SEA file
			SoundUnLoadBank('1_B.bnk')
			SoundUnLoadBank('TwrBells.bnk')
			DATUnload(2)
			AreaTransitionXYZ(StartArea, StartX, StartY, StartZ, true)
			if StartArea == 14 then
				PedFaceXYZ(gPlayer, -509.38, 323.91, 31.41)
			elseif StartArea == 50 then
				PedFaceXYZ(gPlayer, -785.81, 52.82, 7.27)
			elseif StartArea == 70 then
				PedFaceXYZ(gPlayer, -659.38, 243.86, 15.22)
			end
		end

		SoundEnableSpeech()
		SoundEnableSpeech_ActionTree() -- Like SoundDisableSpeech_ActionTree
		FollowCamDefaultFightShot() -- Restores the default fight camera
		CameraSetWidescreen(false)
		InMission = false

		PlayerSetControl(1)
		CameraReturnToPlayer()
		CameraReset()
		CameraFade(500, 1)

end

function ActualMissionSetup()

	-- Load necessary Animations
		F_LoadAnims() -- Custom function

	-- Audio stuff:
		SoundLoadBank('1_09.bnk') -- Loads a specific .SEA file
		SoundLoadBank('1_B.bnk')
		SoundLoadBank('TwrBells.bnk')

	-- DAT stuff:
		DATLoad('The_Myth.DAT', 2) -- This loads a custom .DAT file inside Trigger.img. The game can load custom ones just fine

	-- Map doors:
		AreaSetDoorLocked(TRIGGER._DT_tschool_RoofDoor, false) -- Unlocks the roof door outside the school

	-- Store Player's Data:
		StartX, StartY, StartZ = PlayerGetPosXYZ() -- Get Jimmy's position where he used the Arcade Machine to teleport the player back once the mission is over
		StartArea = AreaGetVisible() -- Same thing, but for getting the Area
		StartH, StartM = ClockGet() -- Same thing, but for the clock
		ClothingBackup() -- Saves Jimmy's current clothes
		PlayerUnequip()

	-- Misc:
		DisablePunishmentSystem(true) -- Disables the trouble meter
		F_SetupVariables()
		VehicleDelete(PedGetLastVehicle(gPlayer))

end

SettingsMenu = function()

		StopPedProduction(true) -- Self-explanatory
		LoadAnimationGroup('4_04_FunhouseFun')
		PedSetEffectedByGravity(gPlayer, false)

		if AreaGetVisible() == 14 then -- Boys' Dorm
			AreaTransitionXYZ(14, -508.50, 323.85, 31.55, true)
			CameraSetXYZ(-507.68, 324.81, 32.61, -511.61, 322.47, 33.06)
		elseif AreaGetVisible() == 50 then -- Carnival Souvenirs
			AreaTransitionXYZ(50, -786.86, 52.90, 7.28, true)
			CameraSetXYZ(-787.58, 52.08, 8.38, -784.04, 53.84, 8.93)
		elseif AreaGetVisible() == 57 then -- Dropouts safehouse
			AreaTransitionXYZ(57, -659.34, 244.65, 15.42, true)
			CameraSetXYZ(-660.22, 245.32, 16.39, -657.31, 240.61, 17.27)
		end

		Wait(500)
		PedSetActionNode(gPlayer, '/Global/404Conv/UseMonitor', '4_04.act')
		Wait(150)
		CameraFade(500, 1)

		Title = 'The Myth'
		Setting = 'Start from:'
		Instructions = 'Press ~o~ to quit'
		options = {
			{text = 'Beginning', event = Intro},
			{text = 'Bike Chase', event = StartFromBikeChase},
			{text = 'Boss Fight', event = StartFromBossFight}
		}

		if DebugOn then
			options[4] = {text = 'DEBUG: Boss Fight PT2', event = StartFromBossFightPT2}
		end

		Selection = 1

		repeat

			TextPrintString(Title..'\n\n'..Setting..'\n<'..options[Selection].text..'>\n\n\n\n'..Instructions, 1, 1)
			TextPrintString('\n\n\nAuthor:\nSimonBestia\n\nSpecial Thanks:\ndeadpoolXYZ & Derpy54320', 1, 2)

			if F_IsButtonPressedWithDelayCheck(0, 0) then
				SoundPlay2D('NavDwn')
				Selection = Selection - 1
				if Selection < 1 then
					Selection = table.getn(options)
				end
			elseif F_IsButtonPressedWithDelayCheck(1, 0) then
				SoundPlay2D('NavUp')
				Selection = Selection + 1
				if Selection > table.getn(options) then
					Selection = 1
				end
			elseif IsButtonBeingPressed(8, 0) then
				ToggleHUDComponentVisibility(42, false)
				SoundPlay2D('WrongBtn')
				MissionFail()
				SoundPlayStream('MS_MissionEnd01.rsm', MUSIC_DEFAULT_VOLUME) -- Plays a music
				Wait(3000)
			end

		Wait(0)
		until IsButtonBeingPressed(7, 0)

		SoundPlay2D('RightBtn')
		PlayingMission = true
		CameraFade(600, 0) -- Makes the camera fade out (in milliseconds speed)
		Wait(601)
		ActualMissionSetup()
		PedSetEffectedByGravity(gPlayer, true)
		ClockSet(22) -- Self-explanatory
		WeatherSet(2) -- Sets the weather to rain

		if Selection > 1 then
			SetupRoof()
		end
		if Selection <= 3 then
			F_ChangePlayerOutfit('Starting') -- Sets the starting outfit
		end

		repeat
		Wait(0)
		until SystemIsReady() and not IsStreamingBusy()

		options[Selection].event()

end

function StartFromBikeChase()

		AreaTransitionXYZ(0, 212.74, -73.08, 8.59, true)
		SoundPlayStream('MS_FinalShowdown03Mid.rsm', MUSIC_DEFAULT_VOLUME)
		KartChase()

end

function StartFromBossFight()

		AreaTransitionXYZ(0, 64.54, -313.47, 0.37, true)
		Gary2 = PedCreateXYZ(130, 72.65, -314.15, 0.65)
		PedFaceXYZ(Gary2, 64.54, -313.47, 0.37)
		Jimmy2Vehicle = VehicleCreateXYZ(bikeID, 65.04, -315.82, 0.37)
		Gary2Vehicle = VehicleCreateXYZ(GoKartID, 73.05, -315.37, 0.37)
		PreBossBattleNIS()

end

function StartFromBossFightPT2()

		AreaTransitionXYZ(0, 68.57, -316.30, 0.35, true)
		Gary3 = PedCreateXYZ(160, 69.27, -323.60, 0.35)
		F_ChangePlayerOutfit('Mascot')
		CreateThread('T_GaryFightingStyle')
		CreateThread('T_BossFightChecks')
		for i, AnimGroup in NemesisAnims do
			LoadAnimationGroup(AnimGroup)
		end
		PreBossBattlePT2NIS()

end

YouShallNotPlay = function()

		LoadAnimationGroup('MINI_React')

		if AreaGetVisible() == 14 then -- Boys' Dorm
			PedSetFlag(gPlayer, 108, true) -- for a list of known flags, check: https://bully-board.com/index.php?topic=22454.0
			StopAmbientPedAttacks()
			SetAmbientPedsIgnoreStimuli(true)
			CameraSetXYZ(-509.18, 324.39, 32.91, -506.99, 322.07, 32.57) -- Places the camera at the first 3 coordinates and makes it look at the last 3 coordinates
		elseif AreaGetVisible() == 50 then -- Carnival souvenirs
			CameraSetXYZ(-786.07, 52.21, 8.78, -789.33, 54.47, 8.25)
		elseif AreaGetVisible() == 57 then -- Dropouts safehouse
			CameraSetXYZ(-659.83, 243.90, 16.72, -656.90, 246.53, 16.01)
		end

		CameraSetWidescreen(true) -- Disables HUD completely, doesn't even allow pausing
		Wait(500)
		CameraFade(500, 1) -- Makes the camera fade in
		Wait(300)
		ExecuteActionNode(gPlayer, '/Global/1_11X2/Failure', '1_11X2.act') -- Makes a ped play a specific animation
		TextPrintString('You have to unlock Blue Skies first!', 2.5, 1) -- Makes text appear on the screen. ('TEXT', seconds, type of text. [2 is small text, 1 is big text])
		SoundPlayStream('MS_MissionEnd01.rsm', MUSIC_DEFAULT_VOLUME) -- Plays a music
		Wait(3000)
		MissionFail() -- Self-explanatory
		Wait(4000)

end

Intro = function()

		SetupRoof()

		AreaTransitionXYZ(0, 181.85, -73.12, 46.54, true) -- Changes player position to a different area and different coordinates (AreaCode, X,Y,Z)
		PedFaceXYZ(gPlayer, 180.10, -73.04, 46.64)
		Gary = PedCreateXYZ(130, 180.10, -73.04, 46.64) -- Creates a ped called Gary (PedID, X,Y,Z)
		PedFaceXYZ(Gary, 181.85, -73.12, 46.54)
		Rat4Bells = PedCreateXYZ(136, 191.70, -73.35, 52.60)
		PedSetEffectedByGravity(Rat4Bells, false)
		PedSetStationary(Rat4Bells, true)
		PedSetAsleep(Rat4Bells, true)
		PedSetInvulnerable(Rat4Bells, true)
		BeamCola = PickupCreateXYZ(FraffyCanID, 204.171005, -78.838600, 35.724098, 1, 0, 'HealthBute')
		SoundPlayStream('MS_FinalShowdown03Low.rsm', MUSIC_DEFAULT_VOLUME)
		CameraSetXYZ(180.38, -70.53, 47.67, 182.07, -75.43, 47.25)

	Wait(1000)

		CameraFade(500, 1)
		SoundLoopPlayOnPed(Rat4Bells, "BELLSONE", true, "large") -- Attaches SFX to a ped. In this case, a rat. A la Nerd Boss Fight!
		SoundLoopPlayOnPed(Rat4Bells, "BELLSTWO", true, "large")
		SoundLoopPlayOnPed(Rat4Bells, "BELLSTHREE", true, "large")
		PedSetActionNode(gPlayer, '/Global/4_B2/ReactionAnims/Taunt/Taunt5', '4_B2.act')
		PedSetActionNode(Gary, '/Global/Ambient/MissionSpec/FireMan/LookAround', 'Ambient.act')
		F_TextPrint('Jimmy: Nowhere to run now, eh, Gary?', 3, 3000, 2)
		CameraSetXYZ(181.68, -71.02, 47.27, 180.04, -75.31, 47.44)
		PedSetActionNode(Gary, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		PedSetActionNode(Gary, '/Global/404Conv/Threaten', '4_04.act')
		F_TextPrint('Gary: GO TO HELL, JIMMY!', 2, 2000, 2)
		SoundPlayStream('MS_FinalShowdown03Mid.rsm', MUSIC_DEFAULT_VOLUME)
		PedLockTarget(Gary, gPlayer) -- Makes a ped target another ped, required for some attacks to work
		PedSetActionNode(Gary, '/Global/G_Johnny/Cinematic/ThroatGrab', 'G_Johnny.act')
		Wait(100)
		while PedIsPlaying(Gary, '/Global/G_Johnny/Cinematic/ThroatGrab', 'G_Johnny.act', true) do -- This is a loop, it will keep looping until Gary is not performing Johnny's throat grab attack, then moves on
		Wait(0)
		end
		GameSetPedStat(Gary, 20, 150) -- Sets a ped's speed (PEDID, statID, amount)
		PedMoveToXYZ(Gary, 2, 182.16, -67.50, 26.10) -- Moves a ped (Ped, walk/run/sprint, x,y,z) walk, run, sprint = 0, 1, 2, 3
		
	Wait(2000)

		PedDelete(Gary) -- Self-explanatory
		PedSetActionNode(gPlayer, '/Global/G_Johnny/Cinematic/Jimmy/BellyUp/BellyUpGetUp/BellyUpGetUpGetUp', 'G_Johnny.act')
		PlayerSetHealth(200)
		PlayerSetControl(1) -- Restores the player's control
		F_ToggleHUDElements(true)
		F_TextPrint("Don't let Gary run away!", 3, 3000, 1)

		T_RoofChase = CreateThread('RoofChase')
		SchoolChase()

end

function SetupRoof()

		local function CreatePersistentEntityAndInsert(model, x, y, z, r, a)
		  local PropID, PropPool = CreatePersistentEntity(model, x, y, z, r, a)
		  table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		end
		-- Rooftop models
		CreatePersistentEntityAndInsert('SC1b_fence_d', 186.021, -73.3169, 35.3693, 0, 0)
		CreatePersistentEntityAndInsert('SC1d_lad04', 190.857, -73.0157, 35.4244, 0, 0)
		CreatePersistentEntityAndInsert('SC1d_bldgmain_A', 191.754, -73.3854, 51.0535, 0, 0)
		CreatePersistentEntityAndInsert('SC_FanBlade03', 178.574, -73.157, 23.2994, 0, 0)
		CreatePersistentEntityAndInsert('SC_FanBlade02', 178.57, -73.1494, 23.1368, 0, 0)
		CreatePersistentEntityAndInsert('FGRD_SC1b20', 186.239, -73.3414, 34.9336, 0, 0)
		CreatePersistentEntityAndInsert('SC1d_bldgmain_wtr01', 186.087, -73.4308, 23.9015, 0, 0)
		CreatePersistentEntityAndInsert('SC1d_roofsteps', 195.981, -79.7682, 43.6757, 0, 0)
		CreatePersistentEntityAndInsert('DL_SC1d_L', 189.734, -72.4095, 33.7901, 0, 0)
		CreatePersistentEntityAndInsert('PR_AlleyLamp', 182.208, -67.7659, 29.8164, 0, 0)
		CreatePersistentEntityAndInsert('pxLad3M', 181.94, -64.992, 23.2626, 0, 0)
		CreatePersistentEntityAndInsert('pxLad4M', 186.38, -66.1529, 26.0975, 90, 0)
		CreatePersistentEntityAndInsert('Ladder_5M', 184.314, -80.2621, 35.6872, 90, 0)
		CreatePersistentEntityAndInsert('pxLad5M', 204.592, -67.2104, 30.3007, 0, 0)
		CreatePersistentEntityAndInsert('Scaffold', 178.173, -73.1613, 40.1403, 0, 0)
		CreatePersistentEntityAndInsert('Scaffold', 178.173, -73.1613, 35.2763, 0, 0)
		CreatePersistentEntityAndInsert('Scaffold', 178.173, -73.1613, 30.5194, 0, 0)
		CreatePersistentEntityAndInsert('Ladder_3M', 181.94, -65.028, 23.2625, 0, 0)
		CreatePersistentEntityAndInsert('Ladder_4M', 186.435, -66.1529, 26.0975, 90, 0)
		CreatePersistentEntityAndInsert('pxLad5M', 184.349, -80.2622, 35.6869, -90, 0)
		CreatePersistentEntityAndInsert('Ladder_5M', 204.592, -67.2498, 30.301, 0, 0)
		CreatePersistentEntityAndInsert('Ladder_4M', 186.002, -81.7648, 23.2896, 0, 0)
		CreatePersistentEntityAndInsert('pxLad4M', 186.002, -81.78, 23.2896, 180, 0)
		CreatePersistentEntityAndInsert('pxLad3M', 197.356, -81.2369, 29.6798, 90, 0)
		CreatePersistentEntityAndInsert('Ladder_3M', 197.398, -81.2371, 29.6798, 90, 0)
		CreatePersistentEntityAndInsert('pxLad3M', 199.835, -80.9096, 32.6819, 180, 0)
		CreatePersistentEntityAndInsert('Ladder_3M', 199.835, -80.881, 32.6818, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 197.159, -75.7203, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 191.725, -75.7203, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 191.725, -73.4447, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 186.275, -73.4447, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 186.275, -71.1643, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('BrickPile', 203.279, -66.6406, 30.7234, 0, 0)
		CreatePersistentEntityAndInsert('BrickPile01', 204.748, -77.8347, 36.1466, 0, 0)
		CreatePersistentEntityAndInsert('BrickPile02', 186.117, -79.5076, 36.1196, 0, 0)
		CreatePersistentEntityAndInsert('WALKTschoolRoofOP', 186.462, -73.2229, 37.8194, 0, 0)
		CreatePersistentEntityAndInsert('SCBell2', 197.159, -73.4447, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell2', 197.159, -71.1643, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell2', 191.722, -71.1643, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell2', 186.275, -75.7203, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('NOGO_tschoolRoofOP', 186.462, -73.2229, 30.3808, 0, 0)

		Wait(1500)

		-- Collision and animations, copied from 6_B because I'm lazy
		PAnimSetActionNode("SCBell", 197.159, -75.7203, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart1", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 197.159, -73.4447, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart2", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 197.159, -71.1643, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart3", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 191.725, -75.7203, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart4", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 191.725, -73.4447, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart5", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 191.725, -71.1643, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart6", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 186.275, -75.7203, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart7", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 186.275, -73.4447, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart8", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 186.275, -71.1643, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart9", "Act/Props/SCBell.act")
		GeometryInstance('SCBell', false, 197.15899658203, -75.72029876709, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 197.15899658203, -73.444702148438, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 197.15899658203, -71.16429901123, 46.459701538086, false)
		GeometryInstance('SCBell', false, 191.72500610352, -75.72029876709, 46.459701538086, false)
		GeometryInstance('SCBell', false, 191.72500610352, -73.444702148438, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 191.72500610352, -71.16429901123, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 186.27499389648, -75.72029876709, 46.459701538086, false)
		GeometryInstance('SCBell', false, 186.27499389648, -73.444702148438, 46.459701538086, false)
		GeometryInstance('SCBell', false, 186.27499389648, -71.16429901123, 46.459701538086, false)

		Wait(1000)

end

RoofChase = function()

		F_WaitUntilPlayerIsInArea(193.82, -79.74, 42.21, 4) -- The script will wait until the player is somewhere (X, Y, Z, Radius, blip ground type)

		GaryRoof = PedCreateXYZ(130, 184.91, -80.60, 35.68)
		Wait(100)
		PedMakeTargetable(GaryRoof, false) -- Removes the ability to lock on Gary
		PedSetInvulnerable(GaryRoof, true)
		PedFollowPath(GaryRoof, PATH._GARYPATH1, 0, 2) -- Gary will follow GARYPATH1 from my custom .dat file (Ped, PATH._PATHNAME, idk, speed)

		repeat
		Wait(0)
		until PedIsInAreaXYZ(GaryRoof, 199.97, -80.16, 35.68, 1, 0) -- Same as PlayerIsInareaXYZ

		PedStop(GaryRoof)
		Wait(50)
		PedFaceXYZ(GaryRoof, 186.21, -80.58, 35.68)
		F_TextPrint('Gary: No wonder your mother left you here!\nShe must be SO embarassed by you, Jimmy Hopkins!', 6, 0, 2)
		Wait(500)
		PedSetActionNode(GaryRoof, '/Global/1_11X1/Animations/LaughCyclic/LaughCyclic', '1_11X1.act')
		F_GaryThrowBrick()

		repeat
		DistanceM = DistanceBetweenPeds2D(gPlayer, GaryRoof)
		Wait(0)
		until DistanceM < 6

		PedSetActionNode(GaryRoof, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act') -- A node with no animations, useful for stopping the current animation
		Wait(5)
		PedFollowPath(GaryRoof, PATH._GARYPATH2, 0, 0)
		Wait(500)
		PedStop(GaryRoof)
		Wait(5)
		PedSetWeapon(GaryRoof, MarblesID, 3) -- Self-explanatory (Ped, WeaponID, Ammo)
		PedFollowPath(GaryRoof, PATH._GARYPATH2, 0, 1)
		Wait(750)
		PedSetActionNode(GaryRoof, '/Global/2_S04/Anim/AttachMarbles', '2_S04.act')

		repeat
		Wait(0)
		until PedIsInAreaXYZ(GaryRoof, 205.36, -67.43, 35.71, 1, 0)

		Wait(150)
		PedStop(GaryRoof)
		PedFaceXYZ(GaryRoof, 205.48, -79.06, 35.69)
		PedSetActionNode(GaryRoof, '/Global/1_11X1/Animations/LaughCyclic/LaughCyclic', '1_11X1.act')

		F_WaitUntilPlayerIsInArea(205.48, -79.06, 35.69, 1)

		PedLockTarget(GaryRoof, gPlayer, 3)
		PedSetWeapon(GaryRoof, BricksID, 1)
		GameSetPedStat(GaryRoof, 20, 150) -- Sets Gary's speed
		Wait(200)
		PedSetActionTree(GaryRoof, '/Global/Nemesis/Special/Throw', 'Nemesis.act')
		TextPrintString("Look out!  Hahaha!", 2, 2)
        repeat
        Wait(0)
        until PedIsPlaying(GaryRoof, '/Global/Nemesis/Special/Throw/GetWeapon/Release/Empty', true)
        PedSetActionTree(GaryRoof, '/Global/Nemesis', 'Nemesis.act')
        PedLockTarget(GaryRoof, gPlayer, -1)
		PedSetPosXYZ(GaryRoof, 204.66, -66.84, 35.29) -- This changes a ped's position instantly.
		Wait(1000)
		PedFollowPath(GaryRoof, PATH._GARYPATH3, 0, 2)
		
		repeat
		Wait(0)
		until PedIsInAreaXYZ(GaryRoof, 188.57, -65.90, 30.29, 1, 0)

		SoundLoopPlayOnPed(Rat4Bells, "BELLSONE", false) -- Stops the attached SFX to a ped.
		SoundLoopPlayOnPed(Rat4Bells, "BELLSTWO", false)
		SoundLoopPlayOnPed(Rat4Bells, "BELLSTHREE", false)
		PedDelete(Rat4Bells)
		PedStop(GaryRoof)
		PedFaceXYZ(GaryRoof, 203.02, -65.77, 30.29)
		PedSetActionNode(GaryRoof, '/Global/1_11X1/Animations/LaughCyclic/LaughCyclic', '1_11X1.act')
		GameSetPedStat(GaryRoof, 20, 100)
		F_GaryThrowBrick()
		PedSetActionNode(GaryRoof, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		PedMoveToXYZ(GaryRoof, 1, 186.77, -66.23, 30.29)
		Wait(1050)
		PedSetPosXYZ(GaryRoof, 185.63, -66.00, 29.50)
		PedFollowPath(GaryRoof, PATH._GARYPATH4, 0, 2)
		
		repeat
		Wait(0)
		until PedIsInAreaXYZ(GaryRoof, 182.08, -69.21, 26.10, 1.5, 0)

		PedSetFlag(GaryRoof, 9, true) -- Makes a ped vanish
		BlipBackToSchool = BlipAddXYZ(182.16, -67.50, 26.10, 0, 3, 0, 0) -- adds a blip. (X,Y,Z, icon, ground blip type, visibility, Unknown)

end

SchoolChase = function()

		repeat
		Wait(0)
		until AreaGetVisible() == 2 and not AreaIsLoading() -- The game gets the ID of the current area, if it is 2 (school), it waits until it's fully loaded, then continues.

		DeleteAllMissionPeds()
		PickupRemoveAll(FraffyCanID)
		TerminateThread(T_RoofChase)
		AreaSetDoorLocked(TRIGGER._ISCHOOL_DOOR25, false) -- Unlocks the roof door inside the school
		BlipRemove(BlipBackToSchool)

	Wait(100)

		PedFaceXYZ(gPlayer, -611.06, -287.20, 13.99)
		CameraReturnToPlayer()
		Wait(100)
		Gary = PedCreateXYZ(130, -611.06, -287.20, 10.99)
		AddBlipForChar(Gary, 0, 34, 4)  -- Adds a blip to a ped. (PedID, Unknown, icon, ground blip [in this case, 4 is an invalid ID, so nothing is on the ground])
		PedMakeTargetable(Gary, false)
		PedSetInvulnerable(Gary, true)
		PedMoveToXYZ(Gary, 2, -628.08, -330.61, 0.00)
		PedSetInfiniteSprint(Gary, true)
		PedIgnoreStimuli(Gary, true) -- The ped won't react to its surroundings 
		GameSetPedStat(Gary, 20, 168)
		
	Wait(650)

		T_MonitorGaryMarbles = CreateThread('T_MonitorGaryMarbles')
		T_EasterEgg = CreateThread('T_EasterEgg')
		F_TextPrint("Gary: You'll never catch me, Hopkins!", 3, 3000, 2)
		F_TextPrint('Jimmy: Keep running like a baby!', 3, 3000, 2)

		while not PedIsInAreaXYZ(Gary, -627.38, -332.51, 0.00, 3, 0) do
		Wait(0)
		end

		MissionTimerStart(9) -- Starts a 9 seconds countdown
		BlipRemoveFromChar(Gary)
		PedSetFlag(Gary, 9, true)
		TerminateThread(T_MonitorGaryMarbles)
		TextPrintString("Gary went outside, don't let him run away!", 3, 1)

		repeat
			if MissionTimerHasFinished() then
				PlayerSetControl(0)
				SoundPlayStream('MS_MissionEnd01.rsm', MUSIC_DEFAULT_VOLUME)
				MissionTimerStop()
				if PedIsPlaying(gPlayer, '/Global/Player/JumpActions/Jump', true) then -- Makes the script wait in case the player is doing some jumping animations
					repeat
					Wait(0)
					until not PedIsPlaying(gPlayer, '/Global/Player/JumpActions/Jump', true)
				elseif PedIsPlaying(gPlayer, 'Global/Player/JumpActions/Jump/Falling/Fall/Falling/Fall_Damage/Fall', true) then
					repeat
					Wait(0)
					until not PedIsPlaying(gPlayer, 'Global/Player/JumpActions/Jump/Falling/Fall/Falling/Fall_Damage/Fall', true)
				end
				Wait(250)
				local X1, Y1, Z1 = PedGetOffsetInWorldCoords(gPlayer, -0.45, 1.35, 1.5000000476837) -- Borrowed from Halloween's script, both functions get Jimmy's coordinates and change them to the one specified in the brackets
				local X2, Y2, Z2 = PedGetOffsetInWorldCoords(gPlayer, 0.45, -0.69999998807907, 1.3000000476837)
				CameraSetXYZ(X1, Y1, Z1, X2, Y2, Z2)
				ExecuteActionNode(gPlayer, '/Global/1_11X2/Failure', '1_11X2.act')
				CameraSetWidescreen(true)
				InMission = false
				Wait(800)
				MissionFail()
				Wait(2000)
			end
		Wait(0)
		until PlayerIsInAreaXYZ(-628.01, -327.70, 0.00, 1.25, 0)

		AreaSetDoorLocked(TRIGGER._ISCHOOL_DOOR25, true) -- Locks the roof door inside of the school
		TerminateThread(T_EasterEgg)
		MissionTimerStop()
		PlayerSetControl(0)
		CameraFade(500, 0)

		Wait(500)

		AreaTransitionXYZ(0, 212.10, -73.37, 8.62, true)

		KartChase()

end

T_MonitorGaryMarbles = function()

		repeat
			if PedIsValid(Gary) then
				Wait(1400)
				PedSetActionNode(Gary, '/Global/2_S04/Anim/AttachMarbles', '2_S04.act')
			end
		Wait(0)
		until PedIsDead(Gary) or not PedIsValid(Gary)

end

T_EasterEgg = function()

		F_WaitUntilPlayerIsInArea(-629.73, -281.07, 5.51, 1)

		SoundStopStream() -- Stops the current playing music
		CameraFade(700, 0)
		MissionTimerStop()
		Wait(1500)
		PlayerSetControl(0)
		F_ToggleHUDElements(false)

		if PedIsValid(Gary) then
			PedDelete(Gary)
		end

		Wait(50)
		LoadAnimationGroup('NIS_3_R09_N')
		LoadAnimationGroup('F_Girls')
		LoadAnimationGroup('JV_Asylum')
		CreatePersistentEntity('DRP_Arcade', -698.18, 204.84, 32.70, 90, 5) -- Adds a model (X, Y, Z, Rotation, AreaID)
		CreatePersistentEntity('OffLapTop', -703.46, 204.88, 32.67, 0, 5)
		AreaTransitionXYZ(5, -701.15, 215.12, 31.55, true)
		deadpoolXYZEG = PedCreateXYZ(147, -699.14, 204.11, 31.55)
		Derpy54320EG = PedCreateXYZ(165, -704.15, 204.89, 31.55)
		SimonBestiaEG = PedCreateXYZ(85, -699.14, 205.15, 31.55)
		Wait(15)
		PedClearAllWeapons(deadpoolXYZEG)
		PedClearAllWeapons(SimonBestiaEG)
		PedFaceXYZ(deadpoolXYZEG, -697.59, 204.62, 31.55)
		PedFaceXYZ(Derpy54320EG, -698.18, 204.84, 32.70)
		PedFaceXYZ(SimonBestiaEG, -698.42, 204.88, 31.55)

	Wait(500)

		CameraFade(500, 1)
		SoundPlayStream('MS_5-05_BurtonPee_NIS.rsm', MUSIC_DEFAULT_VOLUME)
		CameraSetXYZ(-698.03, 203.35, 33.17, -700.63, 206.35, 32.74)
		PedSetActionNode(SimonBestiaEG, '/Global/3_R09/Animations/Nerds/Nerds01', '3_R09.act')
		PedSetActionNode(Derpy54320EG, '/Global/5_09/Anims/PeteSit', '5_09.act')
		F_TextPrint("SimonBestia: No, no, no! You can't just cancel an hadouken into a shoryuken like that!", 5, 5200, 2)
		PedSetActionNode(deadpoolXYZEG, '/Global/3_R09/Animations/Nerds/Nerds02', '3_R09.act')
		F_TextPrint('deadpoolXYZ: Of course I can.', 2, 2200, 2)
		CameraSetXYZ(-703.06, 204.05, 32.75, -705.85, 206.92, 32.71)
		F_TextPrint("Derpy54320: Guys, don't you think we should be checking if the script is working as intended?", 5, 5200, 2)
		CameraSetXYZ(-700.67, 206.27, 33.15, -697.82, 203.52, 32.60)
		PedFaceHeading(SimonBestiaEG, 90)
		PedFaceHeading(deadpoolXYZEG, 45)
		PedSetActionNode(SimonBestiaEG, '/Global/C31Strt/FattyAvoid', 'C3_1.act')
		F_TextPrint("SimonBestia: Come on, Derpy, there's no way anyone would come here, they have no reason to.", 5, 5200, 2)
		Wait(250)
		PlayerSetPosXYZ(-701.21, 211.42, 31.55)
		PedMoveToXYZ(gPlayer, 0, -701.21, 209.05, 31.55)
		Wait(500)
		CameraSetXYZ(-701.79, 207.51, 32.84, -700.19, 211.16, 32.61)
		CreateThread('T_StopMusic')
		Wait(500)
		F_TextPrint('Jimmy: What the hell is going on here?', 2, 2500, 2)
		CameraSetXYZ(-700.16, 206.15, 33.03, -698.01, 202.79, 33.27)
		PedFaceHeading(SimonBestiaEG, 45)
		PedSetActionNode(SimonBestiaEG, '/Global/Ambient/Reactions/TauntReact/TauntAfraid/DontGetHurt', 'Ambient.act')
		PedSetActionNode(deadpoolXYZEG, '/Global/Ambient/Reactions/GirlFreak/GirlFreak1', 'Ambient.act')
		Wait(50)
		PedSetActionNode(SimonBestiaEG, '/Global/3_04/3_04_Anim/AlgieOhFace/OhFace', '3_04.act')
		PedSetActionNode(deadpoolXYZEG, '/Global/3_04/3_04_Anim/AlgieOhFace/OhFace', '3_04.act')
		Wait(3000)
		PedSetActionNode(Derpy54320EG, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		PedSetActionNode(deadpoolXYZEG, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		PedSetActionNode(SimonBestiaEG, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		PedSetPosXYZ(Derpy54320EG, -704.21, 206.43, 31.55)
		Wait(50)
		PedFaceXYZ(Derpy54320EG, -703.19, 207.33, 31.55)
		CameraSetXYZ(-702.84, 207.87, 32.80, -705.05, 204.55, 32.50)
		PedSetActionNode(Derpy54320EG, '/Global/1_11X2/Failure', '1_11X2.act')
		Wait(3000)
		CameraSetXYZ(-702.53, 201.11, 35.05, -701.79, 204.80, 33.72)
		SoundPlayAmbience('SchoolNight.rsm', 0.1)
		Wait(3500)
		GaryEG = PedCreateXYZ(130, -700.74, 213.98, 31.55)
		Wait(5)
		PedFaceXYZ(GaryEG, -701.30, 211.37, 31.55)
		PedMoveToXYZ(GaryEG, 0, -701.30, 211.37, 31.55)
		CameraSetXYZ(-701.86, 208.93, 33.14, -701.02, 212.81, 32.63)
		F_TextPrint('Gary: Hey Jimmy, stick to the script, we---', 2, 2000, 2)
		PedFaceXYZ(gPlayer, -701.30, 211.37, 31.55)
		CameraSetXYZ(-701.28, 209.94, 33.08, -701.46, 205.95, 33.00)
		Wait(3500)
		CameraSetXYZ(-705.30, 207.36, 32.95, -701.56, 205.97, 32.68)
		PedFaceXYZ(Derpy54320EG, -699.14, 205.15, 31.55)
		PedSetActionNode(Derpy54320EG, '/Global/Ambient/MissionSpec/Prefect/PrefectChew', 'Ambient.act')
		PedSetActionNode(deadpoolXYZEG, '/Global/2_S04/Anim/Laugh', '2_S04.act')
		SoundFadeoutAmbience()
		F_TextPrint("Derpy54320: Well, look who's wrong.", 2, 2200, 2)
		MusicCanNowStart = true
		SoundPlayStream('FIGHT01F.rsm', MUSIC_DEFAULT_VOLUME)
		CameraSetXYZ(-700.10, 206.32, 32.53, -697.85, 203.23, 33.70)
		PedSetActionNode(SimonBestiaEG, '/Global/404Conv/Threaten', '4_04.act')
		F_TextPrint('SimonBestia: LISTEN, YOU TWO.', 2, 2100, 2)
		CameraSetXYZ(-699.92, 205.55, 33.17, -696.09, 204.40, 33.21)
		F_TextPrint("SimonBestia: You guys are part of a videogame, you're not real.", 3, 3100, 2)
		CameraSetXYZ(-699.57, 203.00, 33.75, -700.52, 206.80, 32.89)
		PedFaceXYZ(gPlayer, -699.14, 205.15, 31.55)
		F_TextPrint("SimonBestia: I don't know how you ended up here, but I have no choice, I have to erase your memories.", 5, 5100, 2)
		CameraSetXYZ(-700.91, 207.83, 33.09, -701.76, 211.68, 32.40)
		PedMoveToXYZ(GaryEG, 0, -700.56, 209.47, 31.55)
		PedSetActionNode(gPlayer, '/Global/1_11X1/Animations/Laugh_Shove/Laugh', '1_11X1.act')
		F_TextPrint('Jimmy: Yeah right, give it a rest, Trent.', 3, 3100, 2)
		CameraSetXYZ(-699.64, 206.29, 33.16, -698.59, 202.44, 32.95)
		F_TextPrint("SimonBestia: It's difficult to explain, but we're not your friends.", 4, 4100, 2)
		PedFaceXYZ(Derpy54320EG, -701.21, 209.05, 31.55)
		CameraSetXYZ(-699.83, 201.70, 34.02, -700.76, 205.41, 32.85)
		PedSetActionNode(gPlayer, '/Global/1_06/HoboFly', '1_06.act')
		PedSetActionNode(GaryEG, '/Global/1_06/HoboFly', '1_06.act')
		F_TextPrint('SimonBestia: I have to erase your memories now, goodbye.', 3, 3100, 2)
		EffectSetGymnFireOn(true) -- Self-explanatory
		CameraSetXYZ(-700.16, 206.28, 33.15, -697.33, 203.03, 33.01)
		TextPrintString('SimonBestia: ZA WARUDO!', 2.5, 2)
		TextPrintString("Translator's Note: 'Za Warudo' means 'Make the game crash'.", 2.5, 1)
		PedSetActionNode(SimonBestiaEG, '/Global/5_03/5_03_Johnny_In_Cell', '5_03.act')
		Wait(1000)
		CameraSetXYZ(-699.75, 205.80, 32.95, -697.03, 202.90, 33.43)
		Wait(1000)
		PedDelete(gPlayer)


end

KartChase = function()

		repeat
		Wait(0)
		until AreaGetVisible() == 0 and not AreaIsLoading()

		collectgarbage()
		AreaSetDoorLocked(TRIGGER._DT_tschool_RoofDoor, true)
		CreateThread('T_FailDistance')
		
		Wait(5)
		PedFaceXYZ(gPlayer, 212.63, -73.22, 8.59)
		Wait(5)
		PedMoveToXYZ(gPlayer, 3, 216.13, -73.30, 8.59)
		F_ToggleHUDElements(false)
		Gary2 = PedCreateXYZ(130, 224.73, -73.00, 7.17)
		PedFaceXYZ(Gary2, 229.02, -70.75, 6.30)
		Wait(5)
		GaryVehicle = VehicleCreateXYZ(GoKartID, 229.02, -70.75, 6.30)  -- Creates a vehicle (VehicleID, X,Y,Z)
		JimmyVehicle = VehicleCreateXYZ(bikeID, 229.55, -75.85, 6.19)
		CameraSetXYZ(233.76, -75.12, 6.50, 228.63, -73.54, 7.10)
		CameraFade(500, 1)
		PedEnterVehicle(Gary2, GaryVehicle) -- Self-explanatory, make sure the ped is close enough to the vehicle or he won't be able to 'find' it.
		F_TextPrint('Gary: Catch me if you can, LOSER!', 3, 500, 2)
		PedSetActionNode(gPlayer, '/Global/Ambient/Reactions/DoorExits/DoorExitAttack/DoorExitStop/DoorExitStopAnim', 'Ambient.act')
	
		repeat
		Wait(0)
		until PedIsOnVehicle(Gary2, GaryVehicle)

		Wait(400)
		ChaseDone = false -- The thread T_FailDistance will keep looping until we set this variable to true
		VehicleFollowPath(GaryVehicle, PATH._ISLAND, true) -- Same as PedFollowPath
		VehicleSetCruiseSpeed(GaryVehicle, 19) -- Sets a vehicle's speed

		repeat
		Wait(0)
		until not PedIsOnScreen(Gary2)

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
		SoundPlayStream('MS_StreetFightLargeHigh_Boxing.rsm', MUSIC_DEFAULT_VOLUME)
		TextPrintString('Quick! After him!', 2, 1)
		F_ToggleHUDElements(true)
		Wait(3500)
		TextPrintString('HINT: Quickly press the ~x~ and ~s~ buttons to go faster.', 5, 1)
		Wait(6000)

		T_KartChaseConversation = CreateThread('T_KartChaseConversation')
		
		repeat -- Same as the first repeat from SchoolChase
		Wait(0)
		until PedIsInAreaXYZ(Gary2, 72.65, -314.15, 0.65, 6, 0)

		VehicleStop(GaryVehicle)
		PedExitVehicle(Gary2)
	
		F_WaitUntilPlayerIsInArea(58.94, -301.45, 1.44, 4)

		ChaseDone = true
		CameraFade(1000, 0)
		SoundStopStream()
		PlayerSetControl(0)
		Wait(1500)

		if PlayerIsInAnyVehicle() then	-- Self-explanatory
			PlayerDetachFromVehicle()
		end

		VehicleDelete(JimmyVehicle)
		PlayerSetPosXYZ(64.54, -313.47, 0.37)
		Jimmy2Vehicle = VehicleCreateXYZ(bikeID, 65.04, -315.82, 0.37)
		PedFaceXYZ(gPlayer, 71.79, -314.26, 0.52)
		PedSetPosXYZ(Gary2, 72.65, -314.15, 0.65)
		Wait(50)
		PedFaceXYZ(Gary2, 64.54, -313.47, 0.37)
		VehicleDelete(GaryVehicle)
		Gary2Vehicle = VehicleCreateXYZ(GoKartID, 73.05, -315.37, 0.37)
		
		PreBossBattleNIS()

end

T_FailDistance = function()
			
		repeat
	
			Distance = DistanceBetweenPeds2D(gPlayer, Gary2)
			if Distance > 78 then
				PlayerSetControl(0)
				VehicleStop(JimmyVehicle)

			Wait(50)

				TextPrintString('Gary got away.', 1, 1)
				TerminateThread(T_KartChaseConversation)
				SoundPlayStream('MS_MissionEnd01.rsm', MUSIC_DEFAULT_VOLUME)
				CameraSetWidescreen(true)
				InMission = false

			Wait(800)

				F_ToggleHUDElements(false)

				if PlayerIsInAnyVehicle() then -- Self-explanatory
					local X1, Y1, Z1 = PedGetOffsetInWorldCoords(gPlayer, -0.45, 1.35, 1.0000000476837)
					local X2, Y2, Z2 = PedGetOffsetInWorldCoords(gPlayer, 0.45, -0.69999998807907, 0.8000000476837)
					CameraSetXYZ(X1, Y1, Z1, X2, Y2, Z2)
				else -- Alternate camera angles to be used when the Player is not on a vehicle
					local X1, Y1, Z1 = PedGetOffsetInWorldCoords(gPlayer, -0.45, 1.35, 1.5000000476837)
					local X2, Y2, Z2 = PedGetOffsetInWorldCoords(gPlayer, 0.45, -0.69999998807907, 1.3000000476837)
					CameraSetXYZ(X1, Y1, Z1, X2, Y2, Z2)
					ExecuteActionNode(gPlayer, '/Global/1_11X2/Failure', '1_11X2.act')
				end

				ClearTextQueue()
				MissionFail()
			
			Wait(2000)

			elseif Distance > 60 then
				TextPrintString('Gary is getting away!', 1, 1)
			end
			
		Wait(0)
		until ChaseDone
		
end

T_KartChaseConversation = function()

		F_TextPrint("Gary: WHAT'S THE MATTER, JAMES? CAN'T KEEP UP?", 4, 4000, 2)
		F_TextPrint('Jimmy: YOU WENT TOO FAR, GARY!', 3, 4000, 2)
		F_TextPrint('*Cellphone ringing*', 1, 1300, 2)
		F_TextPrint('*Cellphone ringing*', 1, 1300, 2)
		F_TextPrint('*Cellphone ringing*', 1, 1300, 2)
		F_TextPrint('Jimmy: I need help! Please send help to my position!', 4, 4000, 2)
		F_TextPrint("Police: Sir, we'll send an officer but we need you to calm down and...", 3, 3000, 2)
		VehicleSetCruiseSpeed(GaryVehicle, 21)
		F_TextPrint("Jimmy: Sorry, but I'm too busy to use the phone right now!", 4, 5000, 2)
		F_TextPrint("Gary: CALLING THE COPS? YOU'RE NO FUN, JIMMY!", 3, 3000, 2)
		F_TextPrint("Jimmy: THINGS WON'T GO AS YOU WANT, GARY!", 3, 0, 2)

end

PreBossBattleNIS = function()

		F_ToggleHUDElements(false)

	Wait(501)

		collectgarbage()
		for i, AnimGroup in NemesisAnims do
			LoadAnimationGroup(AnimGroup)
		end
		LoadAnimationGroup('F_Jocks')
		LoadAnimationGroup('NPC_Mascot')
		BlipRemoveFromChar(Gary2)
		SoundPlayStream('MS_FinalShowdownLow.rsm', MUSIC_DEFAULT_VOLUME)
		CameraSetXYZ(66.28, -312.72, 1.41, 70.09, -313.94, 1.29)

	Wait(500)
	
		CameraFade(1500, 1)
		
	Wait(501)

		PedMoveToXYZ(gPlayer, 0, 68.22, -313.84, 0.27)
		F_TextPrint('Jimmy: Are you done running?', 3, 3050, 2)
	
		CameraSetXYZ(71.87, -313.99, 2.15, 75.71, -315.11, 2.19)
		PedSetActionNode(Gary2, '/Global/PriOff/TargetAnimations/TargetPoint', 'Prioff.act')
		F_TextPrint('Gary: Oh, but you see, James, you fell right into my trap!', 5, 5200, 2)
		PedSetActionNode(Gary2, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		
	Wait(50)
		
		CameraSetXYZ(75.26, -312.66, 2.15, 71.76, -314.61, 2.08)
		PedSetActionNode(gPlayer, '/Global/C31Strt/PlayerStretch', 'C3_1.act')
		
	Wait(100)
	
		PedMoveToXYZ(Gary2, 0, 74.66, -313.22, 0.74)
		
	Wait(2000)
		
		CameraSetXYZ(68.95, -313.85, 1.82, 64.97, -313.71, 1.45)
		PedSetActionNode(Gary2, '/Global/PriOff/TargetAnimations/TargetGesture', 'PriOff.act')
		F_TextPrint('Gary: I have been hiding my true self.', 3, 3100, 2)
		CameraSetXYZ(75.26, -312.66, 2.15, 71.76, -314.61, 2.08)
		PedSetActionNode(gPlayer, '/Global/2_S04/Anim/BullyTaunt', '2_S04.act')
		F_TextPrint('Gary: I. CAN. TRANSFORM!', 3, 3100, 2)
		PedSetActionNode(gPlayer, '/Global/3_04/3_04_Anim/AlgieOhFace/OhFace', '3_04.act')
		CameraSetXYZ(68.95, -313.85, 1.82, 64.97, -313.71, 1.45)
	
	Wait(100)

		PedDelete(Gary2)
		Gary3 = PedCreateXYZ(160, 72.65, -314.15, 0.65)
		PedSetPedToTypeAttitude(Gary3, 13, 2) -- Sets Gary's attitude towards Jimmy to 'Ignore'
		PedFaceXYZ(Gary3, 68.52, -313.88, 0.34)
		
	Wait(2100)
		
		CameraSetXYZ(71.87, -313.99, 2.15, 75.71, -315.11, 2.19)
		VehicleDelete(Jimmy2Vehicle)
		VehicleDelete(Gary2Vehicle)
		SoundPlay2D('RUSS_ROAR') -- Plays RUSS_ROAR from the previously loaded 1_B.SEA
		PedSetActionNode(Gary3, '/Global/BOSS_Russell/Default_KEY/RisingAttacks/HeavyAttacks/RisingAttacks', 'Boss_Russell.act')
		PedSetActionNode(gPlayer, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		
	Wait(2800)
	
		CameraSetXYZ(68.95, -313.85, 1.82, 64.97, -313.71, 1.45)
		GameSetPedStat(gPlayer, 20, 120)
		PedSetActionNode(gPlayer, '/Global/2_S04/Anim/Laugh', '2_S04.act')
		PedSetActionNode(gPlayer, '/Global/NLockA/Unlocked/Default', 'NLockA.act') -- This freezes a ped to the last frame of the previous animation
		F_TextPrint("Jimmy: Joke's on you, I can transform too!", 3, 3100, 2)

		CameraSetXYZ(71.87, -313.99, 2.15, 75.71, -315.11, 2.19)
		F_ChangePlayerOutfit('Mascot')
		PedSetActionNode(Gary3, '/Global/6_02/BeScared/React1', '6_02.act')
		PedSetActionNode(gPlayer, '/Global/Chapter3Trans/JimmyBye', 'Chapt3Trans.act') -- This animation ends with Jimmy's beta idle, then I use NLockA to freeze Jimmy in his beta pose
		PedSetActionNode(gPlayer, '/Global/NLockA/Unlocked/Default', 'NLockA.act')
		SoundPlayStream('MS_ActionBeatBreak.rsm', MUSIC_DEFAULT_VOLUME)
		F_TextPrint("Gary: NONSENSE, THERE'S NO WAY YOU COULD POSSIBLY---", 2, 2100, 2)
		
		CameraSetXYZ(68.81, -314.61, 0.87, 65.73, -312.21, -0.02)
		SoundPlay2D('Applause')
		SoundPlay2D('Applause')
		SoundPlay2D('Applause')

	Wait(1500)

		CameraSetXYZ(68.89, -313.84, 1.51, 65.02, -312.89, 1.10)
		SoundPlay2D('Applause')
		SoundPlay2D('Applause')
		SoundPlay2D('Applause')

	Wait(1500)

		CameraSetXYZ(68.77, -313.73, 1.77, 64.82, -314.20, 2.10)

	Wait(1500)

		CameraSetXYZ(70.44, -313.98, 0.72, 66.53, -313.72, 1.51)

	Wait(100)

		PedSetActionNode(gPlayer, '/Global/4_05/Anims/MascotActions/DanceD', '4_05.act')
		F_TextPrint('Jimmy: ACTIVATE BULL POWEEEEEEEEEEEEEEEEER!', 3, 3500, 2)
		CameraSetXYZ(72.65, -313.85, 1.91, 76.09, -315.62, 2.90)
		PedSetActionNode(Gary3, '/Global/6_02/GaryCrazy/GoOff', '6_02.act')
		F_TextPrint("Gary: I'M STILL GONNA BEAT YOU!", 3, 3000, 2)
		SoundStopStream()

		BossBattle()

end

BossBattle = function()

		InBossBattle = true
		SoundPlayStream('MS_FinalShowdown03High.rsm', MUSIC_DEFAULT_VOLUME)
		CreateThread('T_GaryFightingStyle')
		CreateThread('T_BossFightChecks')

		-- Invisible barrier, by Derpy54320
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

		PlayerSetControl(1)
		F_ToggleHUDElements(true)

	-- Setup Gary:

		PedLockTarget(Gary3, gPlayer)
		PedSetActionTree(Gary3, '/Global/Nemesis', 'Nemesis.act') -- Sets a fighting style
		PedSetAITree(Gary3, '/Global/GaryAI', 'AI_Gary.act') -- Sets the ped's AI to a specific AI.
		PedSetInfiniteSprint(Gary3, true)
		GameSetPedStat(Gary3, 4, 400)
		PedSetHealth(Gary3, 400)
		GameSetPedStat(Gary3, 5, 300) -- Refer to https://derpy54320.github.io/Bully-LUA-Reference/script/stats.html for these stats
		GameSetPedStat(Gary3, 12, 500)
		GameSetPedStat(Gary3, 13, 60)
		GameSetPedStat(Gary3, 20, 165)
		GameSetPedStat(Gary3, 31, 10)
		GameSetPedStat(Gary3, 63, 1)
		PedSetDamageGivenMultiplier(Gary3, 2, 1.1) -- Multiplies Gary's melee damage by 1.1
		AddBlipForChar(Gary3, 0, 34, 4)
		PedAttack(Gary3, gPlayer, 2) -- Self-explanatory, 2 sets the ped to ALWAYS attack a specific ped, even if another ped attacks him.

	Wait(1)

	-- Setup Player:

		PlayerSetHealth(200) -- Sets Jimmy's health to 200
		GameSetPedStat(gPlayer, 20, 130)
		CameraReturnToPlayer()
		PedShowHealthBar(Gary3, true, 'N_GARY', true) -- Shows Gary's health as a boss health bar
		
	Wait(500)
		
		TextPrintString('Defeat Gary!', 3, 1)
		
		repeat
		Wait(0)
		until PedGetHealth(Gary3) < 85 or failed

		PlayerSetInvulnerable(true)

	Wait(100)

		CameraFade(1000, 0)
		BlipRemoveFromChar(Gary3)
		Wait(1001)
		PedHideHealthBar()
		InBossBattle = false
		GameSetPedStat(gPlayer, 20, 100)
		GameSetPedStat(Gary3, 20, 100)
		SoundStopStream()
		PedSetActionNode(Gary3, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		PedStop(Gary3) -- Both of these stop a ped
		PedClearObjectives(Gary3)
		PedSetPosXYZ(Gary3, 69.27, -323.60, 0.35)
		PlayerSetControl(0)
		PlayerSetInvulnerable(false)
		PedSetActionNode(gPlayer, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')

	Wait(1700)
		
	if failed then
		FailNIS1()
	else
		PlayerSetPosXYZ(68.57, -316.30, 0.35)
		PreBossBattlePT2NIS()
	end
end

T_BossFightChecks = function()

		while InMission do
			if not (failed or not InBossBattle) then
				if PedIsValid(Gary3) then
					Gary = Gary3
					GaryOrigSpeed = 165
				else
					Gary = Gary4
					GaryOrigSpeed = 170
				end
				PedGrappledByJimmy = PedGetGrappleTargetPed(gPlayer)
				PedGrappledByGary = PedGetGrappleTargetPed(Gary)
				--[[if DebugOn then
					TextPrintString("-DEBUG-\nGary Stats:\n"..
					"5: "..GameGetPedStat(Gary, 5)..
					"\n8: "..GameGetPedStat(Gary, 8)..
					"\n12: "..GameGetPedStat(Gary, 12)..
					"\n13: "..GameGetPedStat(Gary, 13)..
					"\n20: "..GameGetPedStat(Gary, 20)..
					"\n31: "..GameGetPedStat(Gary, 31)..
					"\n63: "..GameGetPedStat(Gary, 63)..
					"\nHealth: "..PedGetHealth(Gary)..
					"\n\nJimmy's:\n8: "..GameGetPedStat(gPlayer, 8)..
					"\n20: "..GameGetPedStat(gPlayer, 20), 1, 2)
				end]]
				if (PedIsValid(PedGrappledByJimmy) or PedIsValid(PedGrappledByGary)) then
					GameSetPedStat(Gary, 20, 130)
				else
					GameSetPedStat(Gary, 20, GaryOrigSpeed)
				end
				if F_PlayerIsDead() then
					if PedIsValid(EarnestGhost) then
						PedSetActionNode(EarnestGhost, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
						--TextPrintString('-DEBUG-\nPlayer Dead. Stopping Earnest.', 1, 1)
					end
				end
			end
		Wait(0)
		end

end

FailNIS1 = function()
			
	Wait(450)

		InMission = false
		PlayerSetControl(0)
		PedStop(Gary3)
		PedClearObjectives(Gary3)

	Wait(500)

		CameraSetWidescreen(true)
		F_ToggleHUDElements(false)
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
		PedSetActionNode(Gary3, '/Global/1_11X1/Animations/LaughCyclic/LaughCyclic', '1_11X1.act')
		TextPrintString('Gary: Running away? Hahaha! Enjoy your last moments, Hopkins!', 4, 2)
		Wait(4500)

		SoundPlayStream('MS_MissionEnd01.rsm', MUSIC_DEFAULT_VOLUME)
			
	Wait(1000)

		MissionFail()
		
	Wait(4500)

end

PreBossBattlePT2NIS = function()

		LoadAnimationGroup('NIS_4_B2')
		LoadAnimationGroup('NIS_3_S03_B')
		LoadAnimationGroup('NIS_2_S04')
		LoadAnimationGroup('NIS_6_03')
		F_ToggleHUDElements(false)
		if not PedIsInAreaXYZ(Gary3, 69.27, -323.60, 0.35, 2, 0) then
			PedSetPosXYZ(Gary3, 69.27, -323.60, 0.35)
		end
		
	Wait(25)

		PedFaceXYZ(gPlayer, 69.27, -323.60, 0.35)
		PedFaceXYZ(Gary3, 68.57, -316.30, 0.35)
		
	Wait(25)

		PedSetActionNode(Gary3, '/Global/4_B2/ReactionAnims/GetUpHard', '4_B2.act')
		PedSetActionNode(gPlayer, '/Global/4_B2/ReactionAnims/GetUpHard', '4_B2.act')
		CameraSetXYZ(73.99, -319.28, 1.85, 70.01, -319.71, 1.66)
		
	Wait(1725)
	
		CameraFade(1000, 1)
		SoundPlayStream('MS_FinalShowdownMid.rsm', MUSIC_DEFAULT_VOLUME)
		
	Wait(2000)

		CameraSetXYZ(69.69, -318.12, 1.35, 67.37, -314.87, 1.23)
		
	Wait(2000)
	
		CameraSetXYZ(70.07, -321.47, 1.58, 68.36, -325.08, 1.37)

	Wait(500)

		F_TextPrint("Gary: Don't think you've got the upper hand, James...", 3, 3000, 2)
		F_TextPrint("Gary: I still haven't used all of my power!", 2, 2000, 2)

		CameraSetXYZ(69.97, -322.71, 1.25, 67.44, -325.44, 2.72)
		PedDelete(Gary3)
		Gary4 = PedCreateXYZ(160, 69.27, -323.60, 0.35)

	Wait(5)

		PedSetActionNode(Gary4, '/Global/6_02/GaryNIS/Russell/Russell01', '6_02.act')
		EffectCreate('BottleRocketExplosion', 69.27, -323.60, 0.65) -- Creates an effect at XYZ
		WeatherSet(5) -- Sets the weather to storm, which is unused
		ClockSet(24)
		StartVibration(2, 2000, 255) -- Makes the controller vibrate (Strenght, seconds, another kind of strenght)

	Wait(500)

		CreateThread('T_StopMusic')
		F_TextPrint('Gary: BEHOLD! MY ULTIMATE POWER!', 3, 0, 2)
		Wait(225)
		CameraSetXYZ(80.60, -330.90, 8.05, 77.66, -328.29, 7.33)
		PedSetActionNode(gPlayer, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')

	Wait(2500)

		PedSetActionNode(Gary4, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')

	Wait(1000)

		PedFaceXYZ(gPlayer, 67.74, -319.14, 0.35)
		
	Wait(5)
	
		PedSetActionNode(gPlayer, '/Global/3_S03/NIS/Crabble/Crabble01', '3_S03.act')
		PedSetActionNode(Gary4, '/Global/2_S04/Anim/RochambeauNIS/TrentRules', '2_S04.act')

	Wait(150)

		CameraSetXYZ(67.63, -315.70, 1.85, 70.11, -318.84, 1.85)
		F_TextPrint("Gary: Well, James, I'm sure you now understand what you have gotten yourself into.", 5.2, 5300, 2)
		CameraSetXYZ(68.84, -322.81, 1.85, 71.40, -325.88, 1.89)
		PedSetActionNode(gPlayer, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		F_TextPrint("Gary: I bet you're wondering how I became so powerful.", 3, 3000, 2)
		PedSetActionNode(gPlayer, '/Global/3_S03/NIS/Crabble/Crabble01', '3_S03.act')

	Wait(200)

		PedSetPosXYZ(Gary4, 69.27, -323.95, 0.35)
		CameraSetXYZ(67.68, -317.09, 1.45, 70.15, -314.09, 2.60)
		F_TextPrint('Gary: Well, excluding fan-fictions...', 4, 4000, 2)
		CameraSetXYZ(68.72, -323.06, 1.75, 71.08, -326.23, 1.75)
		F_TextPrint("Gary: ...You don't actually care, do you?", 3, 3200, 2)
		MusicCanNowStart = true
		PedSetActionNode(gPlayer, '/Global/3_S03/NIS/Crabble/Crabble01', '3_S03.act')
		Wait(100)
		MusicFadeWithCamera(false) -- Makes the music play even when the screen is black
		SoundPlayStream('MS_FinalShowdownHigh.rsm', MUSIC_DEFAULT_VOLUME)
		TextPrintString('Gary: THEN LET THE GAMES BEGIN!', 2, 2)
		PedSetActionNode(Gary4, '/Global/6_02/GaryCrazy/GoOff', '6_02.act')
		CameraSetPath(PATH._BOSSFIGHTCUTCAM1, true) -- The camera follows the path in BOSSFIGHTCAM1 from my custom .dat file
		CameraSetSpeed(7, 7, 7)
		CameraLookAtPath(PATH._BOSSFIGHTCUTCAM_LOOKAT1, true) -- The camera will look at the coordinates in BOSSFIGHTCAM_LOOKAT1
		CameraLookAtPathSetSpeed(6, 6, 6)

	Wait(3000)

		CameraFade(800, 0)
		
	Wait(1500)

		CameraReturnToPlayer()
		BossBattlePT2()

end

BossBattlePT2 = function()

		PedSetActionNode(gPlayer, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')

	Wait(50)

		CreateThread('T_GhostPicker')
		F_ToggleHUDElements(true)

	Wait(1)

	-- Setup Gary:

		PedSetActionTree(Gary4, '/Global/Nemesis', 'Nemesis.act')
		PedSetAITree(Gary4, '/Global/GaryAI', 'AI_Gary.act')
		PedSetInfiniteSprint(Gary4, true)
		PedSetHealth(Gary4, 650)
		GameSetPedStat(Gary4, 4, 650)
		GameSetPedStat(Gary4, 12, 400)
		GameSetPedStat(Gary4, 13, 60)
		GameSetPedStat(Gary4, 20, 170)
		GameSetPedStat(Gary4, 31, 11)
		GameSetPedStat(Gary4, 63, 1)
		PedSetPedToTypeAttitude(Gary4, 13, 2)
		PedSetDamageGivenMultiplier(Gary4, 2, 1.35)
		PedSetDamageTakenMultiplier(Gary4, 0, 0) -- Invulnerable to Projectiles
		AddBlipForChar(Gary4, 0, 34, 4)
		PedLockTarget(Gary4, gPlayer)
		PedAttack(Gary4, gPlayer, 2)

	-- Setup Player:

		PlayerSetHealth(200)
		GameSetPedStat(gPlayer, 5, 135)
		GameSetPedStat(gPlayer, 20, 130)
		PlayerSetControl(1)
		PedShowHealthBar(Gary4, true, 'N_GARY', true)
		InBossBattle = true
		CameraFade(500, 1)
		CameraSetSecondTarget(Gary4)
		PlayerIgnoreTargeting(true)
		FollowCamSetFightShot('1_B_X') -- These change the camera style to Russell In the Hole's
		CameraSetShot(1, '1_B_X', true)

	Wait(500)

		TextPrintString("It's now or never!\nFinish him off!", 4, 1)

		repeat
		Wait(0)
		until failed or not PedIsValid(Gary4) or PedIsDead(Gary4)

		PlayerSetInvulnerable(true)

		if PedIsDead(Gary4) then
			for i, Ghost in ipairs(GhostsTable) do
				if PedIsValid(Ghost.ped) then
					GameSetPedStat(Ghost.ped, 20, 95)
					PedApplyDamage(Ghost.ped, PedGetHealth(Ghost.ped))
					PedSetFlag(Ghost.ped, 9, true)
				end
			end
			if PedIsValid(EarnestGhost) then
				PedSetActionNode(EarnestGhost, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
				PedStop(EarnestGhost)
				PedClearObjectives(EarnestGhost)
				GameSetPedStat(EarnestGhost, 20, 95)
				PedApplyDamage(EarnestGhost, PedGetHealth(EarnestGhost))
				PedSetFlag(EarnestGhost, 9, true)
			end
		end

		CameraFade(1000, 0)
		Wait(1000)
		GameSetPedStat(gPlayer, 20, 100)
		PlayerSetHealth(200)
		PedMakeTargetable(gPlayer, false)
		PlayerSetControl(0)
		PedSetActionNode(gPlayer, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')
		PedStop(Gary4)
		PedClearObjectives(Gary4)
		SoundStopStream()
		SoundDisableSpeech()
		BlipRemoveFromChar(Gary4)

	Wait(1001)

		InBossBattle = false
		F_ToggleHUDElements(false)
		PlayerSetInvulnerable(false)
		PedDelete(Gary4)
		KeepPlayerInSquare(false)
		OnPlayerDeath(nil)

	if failed then
		Wait(1000)
		FailNIS2()
	else
		Wait(2000)
		MissionCompleted = true
		PostBossBattleNIS()
	end

end

T_GhostPicker = function()

		while not PedIsDead(Gary4) do

			--TextPrintString('-DEBUG-\nWaiting for ghosts...', 4, 1)
			Wait(2500)
			if not PedIsDead(Gary4) then
				X, Y, Z = PedGetOffsetInWorldCoords(gPlayer, 2.5, 2.5, 0)
				math.randomseed(GetTimer())
				GhostPickerRNG = math.random(2) -- The game gets a random number between 1 and 2
				Wait(100)
				EffectSetGymnFireOn(true)
				GameSetPedStat(Gary4, 5, 500)
				if GhostPickerRNG == 1 then
					CreateThread('T_EarnestGhost')
					--TextPrintString('-DEBUG-\nNerds test.', 1, 1)
					repeat
					Wait(0)
					until not PedIsValid(EarnestGhost)
				elseif GhostPickerRNG == 2 then
					CreateThread('T_JohnnyDarbyGhosts')
					--TextPrintString('-DEBUG-\nPreps & Greasers test.', 1, 1)
					repeat
					Wait(0)
					until GhostsDisappeared(GhostsTable)
				end
				--TextPrintString('-DEBUG-\nGhosts are gone.', 1, 1)
				EffectSetGymnFireOn(false)
				GameSetPedStat(Gary4, 5, 100)
				PedSetFlag(Gary4, 13, false)
				Wait(1000)
			end

		Wait(0)
		end

end

T_EarnestGhost = function()

		LoadAnimationGroup('Earnest')
		X, Y, Z = PedGetOffsetInWorldCoords(gPlayer, 3, 3, 0)
		EarnestGhost = PedCreateXYZ(10, X, Y, Z)
		EffectCreate('BottleRocketExplosion', X, Y, Z + 0.5)
		PedSetEffectedByGravity(EarnestGhost, false)
		PedSetPedToTypeAttitude(EarnestGhost, 13, 0)
		PedSetStationary(EarnestGhost, true)
		PedSetDamageGivenMultiplier(EarnestGhost, 0, 0.2)
		PedMakeTargetable(EarnestGhost, false)
		PedSetInvulnerable(EarnestGhost, true)
		Wait(10)
		PedSetWeapon(EarnestGhost, SpudGunID, 20)
		PedLockTarget(EarnestGhost, gPlayer)
		Wait(200)
		PedSetActionNode(EarnestGhost, '/Global/N_Earnest/Offense/FireSpudGun', 'N_Earnest.act')
		Wait(100)
		repeat
		Wait(0)
		until not PedIsPlaying(EarnestGhost, '/Global/N_Earnest/Offense/FireSpudGun', 'N_Earnest.act', true) or PedIsDead(Gary4)
		PedSetFlag(EarnestGhost, 9, true)
		PedStop(EarnestGhost)
		PedClearObjectives(EarnestGhost)
		Wait(1000)
		UnLoadAnimationGroup('Earnest')

end

T_JohnnyDarbyGhosts = function()

		GhostsTable = {
			{ped = nil, id = 217, act = '/Global/G_Johnny', actfile = 'G_Johnny', ai = '/Global/AI', aifile = 'Act/AI/AI'},
			{ped = nil, id = 37, act = '/Global/BOSS_Darby', actfile = 'BOSS_Darby', ai = '/Global/DarbyAI', aifile = 'Act/AI/AI_DARBY_2_B'},
		}

		X, Y, Z = PedGetOffsetInWorldCoords(gPlayer, 2.5, 2.5, 0)

		for i, Ghost in ipairs(GhostsTable) do
			Ghost.ped = PedCreateXYZ(Ghost.id, X, Y, Z)
			PedSetActionTree(Ghost.ped, Ghost.act, Ghost.actfile..'.act')
			PedSetAITree(Ghost.ped, Ghost.ai, Ghost.aifile..'.act')
			EffectCreate('BottleRocketExplosion', X, Y, Z + 0.5)
			GameSetPedStat(Ghost.ped, 20, 135)
			GameSetPedStat(Ghost.ped, 62, 0)
			PedSetDamageGivenMultiplier(Ghost.ped, 2, 1.35)
			PedRecruitAlly(Gary4, Ghost.ped)
			PedSetPedToTypeAttitude(Ghost.ped, 13, 0)
			PedAttackPlayer(Ghost.ped, 3)
			PedLockTarget(Ghost.ped, gPlayer)
			PedMakeTargetable(Ghost.ped, false)

		end

		--TextPrintString('-DEBUG-\nWaiting to delete ped...', 4, 1)

		if not PedIsDead(Gary) then
			Wait(5000)
		end

		for i, Ghost in ipairs(GhostsTable) do
			--TextPrintString('-DEBUG-\nDeleting Ghost peds...', 1, 1)
			PedSetFlag(Ghost.ped, 9, true)
			PedStop(Ghost.ped)
			PedClearObjectives(Ghost.ped)
		end

	Wait(1000)

end

GhostsDisappeared = function(GhostsTable)

		for i, Ghost in ipairs(GhostsTable) do
			if not PedIsValid(Ghost.ped) then
				--TextPrintString('Ped is not valid, continuing script...', 1, 1)
				return true
			end
		end
		--TextPrintString('Ped is still valid.', 1, 1)
		return false

end

FailNIS2 = function()

		PlayerSetControl(0)
		DeleteAllMissionPeds()

	Wait(500)

		InMission = false
		CameraSetWidescreen(true)
		F_ToggleHUDElements(false)
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
		PedSetActionNode(GaryFail2, '/Global/1_11X1/Animations/LaughCyclic/LaughCyclic', '1_11X1.act')
		Wait(150)
		PedSetActionNode(DarbyFail2, '/Global/1_11X1/Animations/LaughCyclic/LaughCyclic', '1_11X1.act')
		Wait(150)
		PedSetActionNode(JohnnyFail2, '/Global/1_11X1/Animations/LaughCyclic/LaughCyclic', '1_11X1.act')
		Wait(150)
		PedSetActionNode(EarnestFail2, '/Global/1_11X1/Animations/LaughCyclic/LaughCyclic', '1_11X1.act')
		TextPrintString('Gary: Running away? Hahaha! Enjoy your last moments, Hopkins!', 4, 2)
		Wait(4500)

		SoundPlayStream('MS_MissionEnd01.rsm', MUSIC_DEFAULT_VOLUME)
			
	Wait(1000)

		MissionFail()

	Wait(4500)

end

PostBossBattleNIS = function()

		LoadAnimationGroup('NIS_1_04')
		LoadAnimationGroup('NIS_3_04')
		EffectSetGymnFireOn(false)
		DeleteAllMissionPeds()
		F_ChangePlayerOutfit('MascotNoHead')
		WeatherSet(2)
		ClockSet(22)
		SoundDisableSpeech()
		
	Wait(5)

		GameSetPedStat(gPlayer, 20, 100)
		CameraSetXYZ(71.24, -323.14, 0.91, 67.92, -320.92, 1.15)
		Gary5 = PedCreateXYZ(130, 68.96, -321.25, 0.41)
		PedFaceXYZ(Gary5, 70.76, -321.11, 0.41)
		PlayerSetPosXYZ(70.76, -324.23, 0.34)
		PoliceCar = VehicleCreateXYZ(PoliceCarID, 86.30, -364.89, 0.33)
		Officer = PedCreateXYZ(97, 86.83, -366.97, 0.33)
		Wait(100)
		PedSetActionNode(Gary5, '/Global/4_05/Anims/StealCostumeCut/KnockedOut', '4_05.act')
		Wait(200)
		CameraFade(2000, 1)

	Wait(499)

		PedMoveToXYZ(gPlayer, 0, 69.47, -322.28, 0.42)
		Wait(1500)
		PedSetActionNode(gPlayer, '/Global/3_B/Animation/Crouch/Crouch', '3_B.act')

	Wait(100)

		F_TextPrint("Jimmy: Who's the boss? ME! Got it?", 3, 3000, 2)
		F_TextPrint("Gary: It's not over... not yet...", 3, 3100, 2)

	Wait(100)

		VehicleFaceHeading(PoliceCar, 60)
		PedWarpIntoCar(Officer, PoliceCar) -- Self-explanatory
		CameraSetXYZ(68.89, -328.30, 2.08, 70.77, -332.45, 1.47)
		VehicleEnableEngine(PoliceCar, true) -- Turns on the lights
		VehicleSetEntityFlag(PoliceCar, 43, false)

	Wait(100)

		PedFaceXYZ(Gary5, 73.05, -315.37, 0.37)
		VehicleEnableSiren(PoliceCar, true) -- Turns on the siren
		VehicleFollowPath(PoliceCar, PATH._POLICE)
		VehicleSetCruiseSpeed(PoliceCar, 16)

		repeat
		Wait(0)
		until PedIsInAreaXYZ(Officer, 68.90, -328.57, 0.32, 4, 0)

		VehicleStop(PoliceCar)

	Wait(500)

		VehicleEnableSiren(PoliceCar, false)
		VehicleEnableEngine(PoliceCar, false) -- Turns off the lights

	Wait(100)

		PedExitVehicle(Officer) -- Self-explanatory

	Wait(1750)

		PedFaceXYZ(Officer, 70.46, -322.68, 0.34)
		F_TextPrint('Officer: Hey, are you the one who made that call?', 4, 0, 2)
		PedSetActionNode(Officer, '/Global/1_04/GaryPoint/GaryPointAnim', '1_04.act')
		Wait(4200)
		PedLockTarget(Officer, -1)
		PedSetActionNode(Gary5, '/Global/4_B2/ReactionAnims/GetUpEasy', '4_B2.act')
		PedSetActionNode(gPlayer, '/Global/3_B/Animation/Stand/Stand', '3_B.act')

	Wait(300)

		CameraSetXYZ(66.37, -331.08, 2.12, 69.33, -328.50, 1.33)
		PedMoveToXYZ(gPlayer, 0, 68.90, -328.57, 0.32)

	Wait(500)

		F_TextPrint("Jimmy: Yes, my name is Jimmy Hopkins. I believe you're looking for this individual.", 5, 5000, 2)
		CameraSetXYZ(68.02, -327.68, 1.65, 70.18, -331.05, 2.20)
		PedSetActionNode(Officer, '/Global/3_04/3_04_Anim/JohnnyIdle/JohnnyIdle', '3_04.act')
		PedFaceXYZ(gPlayer, 69.40, -329.45, 0.30)
		F_TextPrint("Officer: Yes, Gary Smith. He's probably going to remain in the Happy Volts Asylum for a long time.", 5, 5000, 2)
		PedSetActionNode(Officer, '/Global/3_04/3_04_Anim/JohnnyIdle/Johnny2', '3_04.act')
		F_TextPrint('Officer: Thank you for your help, Mr. Hopkins.', 4, 4050, 2)
		PedSetActionNode(Officer, '/Global/Ambient/Scripted/Empty/EmptyNode/TrueEmptyNode', 'Ambient.act')

	Wait(50)

		PedMoveToXYZ(Officer, 0, 69.47, -322.28, 0.42)

	Wait(800)

		PedLockTarget(gPlayer, Officer, 3)
		PedFaceObject(gPlayer, Officer, 3, 1)
		PedLockTarget(gPlayer, Officer, 3)

	Wait(2500)

		PedLockTarget(gPlayer, -1)
		CameraSetXYZ(69.66, -320.50, 1.40, 68.82, -324.17, 2.75)
		PlayerFaceHeading(0, 1)
		F_TextPrint('Officer: Get up, you monster.', 2, 0, 2)
		Wait(500)
		PedSetActionNode(Gary5, '/Global/4_B2/ReactionAnims/GetUpHard', '4_B2.act')

	Wait(4500)

		CameraFade(500, 0)
		EndingAndCredits()

end

EndingAndCredits = function()

	Wait(501)

		LoadAnimationGroup('NIS_1_11')
		LoadAnimationGroup('NIS_2_06_1')
		LoadAnimationGroup('NIS_3_05')
		WeatherSet(0) -- Sets the weather to sunny
		AreaTransitionXYZ(0, 263.81, -112.78, 6.21)
		PedDelete(Officer)
		PedDelete(Gary5)
		F_ChangePlayerOutfit('Uniform')
		ClockSet(9)
		PlayerClearLastVehicle()
		CameraSetXYZ(265.65, -114.57, 8.36, 262.13, -113.30, 6.95)

		if PS2 then
			Wait(2500)
		else
			Wait(1000)
		end

		CameraFade(600, 1)
		SoundPlayStream('MS_6B_EndlessSummerCreditsNIS.rsm', MUSIC_DEFAULT_VOLUME)
		SimonBestia = PedCreateXYZ(85, 280, -103.30, 6.18)
		PedFaceXYZ(SimonBestia, 280, -104.69, 6.21)
		deadpoolXYZ = PedCreateXYZ(147, 280.11, -105.39, 6.18)
		Derpy54320 = PedCreateXYZ(165, 281.07, -105.47, 6.18)
		Gary6 = PedCreateXYZ(130, 262.13, -112.78, 6.20)
		Pete = PedCreateXYZ(134, 262.71, -113.68, 6.20)
		PedFaceXYZ(deadpoolXYZ, 280, -103.30, 6.18)
		PedFaceXYZ(Derpy54320, 280, -103.30, 6.18)
		PedSetWeapon(Derpy54320, NerdBooksCID, 1)
		table.insert(TblEndingPeds, SimonBestia)
		table.insert(TblEndingPeds, deadpoolXYZ)
		table.insert(TblEndingPeds, Derpy54320)
		table.insert(TblEndingPeds, Gary6)
		table.insert(TblEndingPeds, Pete)
		for i, Ped in TblEndingPeds do
			PedIgnoreAttacks(Ped, true)
			PedIgnoreStimuli(Ped, true)
		end
		PedFaceXYZ(gPlayer, 262.13, -112.78, 6.20)
		PedFaceXYZ(Gary6, 263.81, -112.78, 6.21)
		PedFaceXYZ(Pete, 263.81, -112.78, 6.21)
		PedClearAllWeapons(deadpoolXYZ)
		PedClearAllWeapons(SimonBestia)

		PedSetActionNode(gPlayer, '/Global/3_05/Animations/Player/Player01', '3_05.act')
		F_TextPrint("Jimmy: And that's the dream I had.", 2.5, 2600, 2)
		CameraSetXYZ(264.25, -110.89, 7.79, 261.72, -113.92, 7.14)
		PedSetActionNode(Gary6, '/Global/1_11X2/CutPlan/Gary92', '1_11X2.act')
		F_TextPrint('Gary: I liked the part where I turned into a werewolf.', 3.5, 3600, 2)
		PedFaceXYZ(gPlayer, 262.71, -113.68, 6.20)
		CameraSetXYZ(265.46, -113.30, 7.72, 261.56, -113.30, 6.83)
		PedSetActionNode(Pete, '/Global/1_11X2/CutPlan/Pete94', '1_11X2.act')
		F_TextPrint('Pete: But what about me?', 2.5, 2600, 2)
		CameraSetXYZ(262.47, -116.17, 7.42, 263.06, -112.23, 7.14)
		PedSetActionNode(gPlayer, '/Global/5_04/PlayerScratch', '5_04.act')
		F_TextPrint("Jimmy: Sorry, Pete, but I don't remember you at all.", 3.5, 3600, 2)
		CameraSetXYZ(260.63, -113.12, 6.87, 264.22, -111.36, 6.73)
		PedMoveToXYZ(gPlayer, 0, 227.32, -73.80, 6.22)
		GameSetPedStat(gPlayer, 20, 90)
		Wait(300)
		PedMoveToXYZ(Gary6, 0, 227.32, -72.80, 6.22)
		GameSetPedStat(Gary6, 20, 95)
		Wait(300)
		PedMoveToXYZ(Pete, 0, 227.32, -71.80, 6.22)
		GameSetPedStat(Pete, 20, 95)
		
	Wait(3500)

		CameraSetXYZ(279.37, -104.46, 7.54, 281.49, -101.09, 7.90)
		PedSetActionNode(SimonBestia, '/Global/C31Strt/FattyAvoid', 'C3_1.act')
		F_TextPrint('SimonBestia: Deadpool-kun, Derpy-chan, arigatou for your help!', 4, 4100, 2)
		PedLockTarget(Derpy54320, deadpoolXYZ, 3)
		CameraSetXYZ(279.15, -103.81, 7.33, 282.05, -106.56, 7.32)
		PedSetActionNode(deadpoolXYZ, '/Global/Ambient/Scripted/Tell_Off/GrappleAttempt/GrappleSuccess/Pull_In_heavy/Hold_Idle/GIVE', 'Ambient.act')
		F_TextPrint('deadpoolXYZ: Stop being a weeb.', 3, 3100, 2)
		PedSetActionNode(deadpoolXYZ, '/Global/2_01/Anim/EdnaShrug', '2_01.act')
		F_TextPrint('deadpoolXYZ: But yeah, no problem. :V', 3.3, 3400, 2)
		CameraSetXYZ(279.99, -104.26, 7.52, 280.89, -108.13, 7.99)
		PedSetActionNode(deadpoolXYZ, '/Global/6_02/SchoolGatesNIS/Jimmy/Jimmy02', '6_02.act')
		F_TextPrint('deadpoolXYZ: To be honest, I was worried anyone could sneak into the office at any point.', 4.7, 4800, 2)
		CameraSetXYZ(280.93, -104.37, 7.62, 277.83, -106.90, 7.75)
		PedSetActionNode(deadpoolXYZ, '/Global/2_06/NISPINKY/Jimmy/Jimmy01', '2_06.act')
		PedLockTarget(Derpy54320, -1)
		F_TextPrint("deadpoolXYZ: But I guess your script wasn't THAT much of a disaster.", 4, 4100, 2)
		CameraSetXYZ(282.85, -103.41, 7.64, 279.52, -105.51, 6.97)
		PedSetActionNode(Derpy54320, '/Global/PriOff/TargetAnimations/TargetPoint', 'PriOff.act')
		F_TextPrint("Derpy54320: Let's celebrate. Here, I brought the Bee Movie script.", 3.3, 1500, 2)
		CameraSetXYZ(280.27, -105.14, 7.52, 284.21, -105.71, 7.15)
		Wait(1500)
		F_TextPrint('Derpy54320: According to all known laws of aviation, there is no way a bee should...', 3, 0, 2)
		PedSetPosXYZ(SimonBestia, 271.73, -113.51, 6.20)
		PedSetPosXYZ(deadpoolXYZ, 270.52, -113.50, 6.20)
		Wait(2700)
		PedMoveToXYZ(deadpoolXYZ, 0, 270.36, -123.50, 7.87)
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
		StopPedProduction(false)
		Wait(500)
		CameraSetXYZ(288.71, -109.10, 11.66, 284.72, -109.21, 11.31)

	Wait(100)

		TextPrintString("And that was 'The Myth'\nmy first custom mission!", 5, 1)
		Wait(5000)
		TextPrintString('Special thanks to\ndeadpoolXYZ and Derpy54320\n for helping on various parts in the mod!', 6, 1)
		Wait(5900)
		TextPrintString("Gary's werewolf model was made by CautiousYoung.\nI would've probably never made this mod if that didn't exist.", 7, 1)
		GameSetPedStat(gPlayer, 20, 100)
		PlayerSetPosXYZ(241.35, -72.20, 6.15)
		Wait(100)
		CameraSetXYZ(236.30, -70.93, 6.83, 239.62, -73.15, 7.05)
		Wait(6000)
		DeleteAllMissionPeds()
		TextPrintString('I hope you enjoyed this mission just as much as I enjoyed making it!', 5, 1)
		CameraSetXYZ(230.20, -60.19, 20.87, 227.21, -62.19, 22.61)
		Wait(6000)

		MissionSucceed()

		CameraFade(500, 0)

		Wait(1000)

end

-- Other Custom functions
F_ToggleHUDElements = function(Boolean)

		ToggleHUDComponentVisibility(4, Boolean) -- Shows/Doesn't show the healthbar
		ToggleHUDComponentVisibility(5, Boolean) -- Shows/Doesn't show the ground healthbar
		ToggleHUDComponentVisibility(11, Boolean) -- Shows/Doesn't show the radar

end

F_LoadAnims = function()

		AnimGroupsTable = {
			'NPC_Adult',
			'NPC_AggroTaunt',
			'G_Johnny',
			'MINI_React',
			'LE_Orderly',
			'NPC_Principal',
			'DodgeBall',
		}

		for i, AnimGroup in AnimGroupsTable do
			LoadAnimationGroup(AnimGroup)
		end

		LoadActionTree('BOSS_Russell.act')
		LoadActionTree('BOSS_Darby.act')
		LoadActionTree('Crazy_Basic.act')

end

F_SetupVariables = function()

		if not PS2 then
			NerdBooksCID = 414
			FraffyCanID = 362
			MarblesID = 349
			BricksID = 311
			SpudGunID = 305
			GoKartID = 289
			bikeID = 277
			PoliceCarID = 295
		else
			NerdBooksCID = 392
			FraffyCanID = 340
			MarblesID = 327
			BricksID = 289
			SpudGunID = 283
			PoliceCarID = 271
			GoKartID = 265
			bikeID = 253
		end

end

F_TextPrint = function(Text, Time, WaitTime, Type)

		TextPrintString(Text, Time, Type)
		if not SkipText then
			Wait(WaitTime)
		end

end

F_WaitUntilPlayerIsInArea = function(X, Y, Z, Ra)

		repeat
		Wait(0)
		until PlayerIsInAreaXYZ(X, Y, Z, Ra, 0)

end

F_ChangePlayerOutfit = function(OutfitName)

		ClothingSetPlayerOutfit(OutfitName) -- Changes the outfit to the specified one
		ClothingBuildPlayer() -- Needed when changing outfits

end

F_GaryThrowBrick = function()

		repeat
		Distance = DistanceBetweenPeds2D(gPlayer, GaryRoof) -- Calculates distance (X and Y) between Jimmy and Gary
		Wait(0)
		until Distance < 8 -- The loop repeats until they're closer to each other

		PedLockTarget(GaryRoof, gPlayer, 3)
		PedSetActionTree(GaryRoof, '/Global/Nemesis/Special/Throw', 'Nemesis.act')
        repeat
        Wait(0)
        until PedIsPlaying(GaryRoof, '/Global/Nemesis/Special/Throw/GetWeapon/Release/Empty', true)
        PedSetActionTree(GaryRoof, '/Global/Nemesis', 'Nemesis.act')
        PedLockTarget(GaryRoof, gPlayer, -1)
		PedSetActionNode(GaryRoof, '/Global/1_11X1/Animations/LaughCyclic/LaughCyclic', '1_11X1.act')

end

T_StopMusic = function()

		repeat
			if not MusicCanNowStart then
				SoundStopStream() -- When SoundStopStream is used, the game stops the music and then starts the walking theme shortly after, but if we constantly stop the music, the game won't play anything
				SoundStopInteractiveStream()
			end
		Wait(0)
		until MusicCanNowStart

end


T_GaryFightingStyle = function()

		Melee = {
			{Anim = '/Global/BOSS_Darby/Offense/Short/Grapples/HeavyAttacks/Catch_Throw', Act = 'BOSS_Darby.act'},
			{Anim = '/Global/DO_Striker_A/Offense/Medium/HeavyAttacks/OverhandSwing', Act = 'DO_Striker_A.act'},
			{Anim = '/Global/Crazy_Basic/Offense/Medium/GrapplesNEW/GrapplesAttempt', Act = 'Crazy_Basic.act'},
			{Anim = '/Global/BOSS_Russell/Offense/GroundAttack/GroundStomp1', Act = 'BOSS_Russell.act'},
			{Anim = '/Global/BOSS_Russell/Defense/Evade/EvadeInterrupt/EvadeInterrupt', Act = 'BOSS_Russell.act'},
			{Anim = '/Global/G_Johnny/Offense/Special/SpecialActions/LightAttacks/Shin/HeavyAttacks/RoundHouseKick_L/AxeKicks', Act = 'G_Johnny.act'},
			{Anim = '/Global/G_Johnny/Default_KEY/RisingAttacks/HeavyAttacks/RisingAttacks', Act = 'G_Johnny.act'}
		}

		Grapples = {
			{Anim = '/Global/Actions/Grapples/Front/Grapples/GrappleMoves/PowerBomb/GIVE', Act = 'BOSS_Russell.act'},
			{Anim = '/Global/Actions/Grapples/Front/Grapples/GrappleMoves/BearHug', Act = 'G_Grappler_A.act'},
			{Anim = '/Global/WrestlingACT/Attacks/Grapples/Grapples/BackGrapples/Choke', Act = 'WrestlingACT.act'}
		}

		Gary = Gary3
		CheckGary(Gary)
		
		Gary = Gary4
		CheckGary(Gary)
	
	
end

CheckGary = function(Gary)

		IsAttacking = false
		IsGrappling = false

		repeat

			if PedIsPerformingMove(Gary) and not IsAttacking then
				IsAttacking = true
				rand = math.random(1, table.getn(Melee))
				PedSetActionNode(Gary, Melee[rand].Anim, Melee[rand].Act)
				--TextPrintString('-DEBUG-\nGary Is attacking', 1, 2)
			elseif PedIsPerformingMove(Gary) and not IsAttacking then
				IsAttacking = true
			end

			if not PedIsPerformingMove(Gary) and IsAttacking then
				IsAttacking = false
				--TextPrintString('-DEBUG-\nGary Is not attacking', 1, 2)
				Wait(1000)
			end

			if PedIsPlaying(Gary, '/Global/Actions/Grapples/Front/Grapples', true) and not IsGrappling and not IsAttacking then
				IsGrappling = true
				RNG = math.random(2)
				--TextPrintString('-DEBUG-\nValue picked: '..RNG, 1, 2)
				if RNG == 2 then
					randg = math.random(1, table.getn(Grapples))
					if randg == 3 then
						PedSetFlag(Gary, 2, true)
					end
					if not PedIsPlaying(Gary, '/Global/Grapples/Front/Grapples/GrappleMoves/DirectionalPush/PushFwd/RCV', true) and PedIsValid(PedGetGrappleTargetPed(Gary)) then
						PedSetActionNode(Gary, Grapples[randg].Anim, Grapples[randg].Act)
						--TextPrintString('-DEBUG-\nGary Is grabbing', 1, 2)
					end
				end
			end
			
			if PedGetFlag(Gary, 2) and not IsGrappling and not IsAttacking and not PedIsPerformingMove(Gary) then
				PedSetFlag(Gary, 2, false)
				--TextPrintString('-DEBUG-\nForcing Gary to stand to avoid issues', 1, 1)
			end

			if not PedIsValid(PedGetGrappleTargetPed(Gary)) and IsGrappling then
				IsGrappling = false
				--TextPrintString('-DEBUG-\nGary Is not grabbing', 1, 2)
			end

			Wait(0)
			until PedIsDead(Gary)

end

PedIsPerformingMove = function(Gary)
	
		IsPerforming = false

		if PedMePlaying(Gary, 'Offense') or PedMePlaying(Gary, 'Defense') then
			IsPerforming = true
		end
			
		return IsPerforming
		
end

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
		gThreadOPD = CreateThread('gThreadOPD')
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
				while InMission do
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
			gThreadKPIS = CreateThread('gThreadKPIS')
		else
			gThreadKPIS = nil
		end
	end
end