extends "res://game/SaveGame.gd"

const SAVE_META4_FILE_TEMPLATE_AP := "user://savegame4_ap_%s.json"
const SAVE_META4_FILE_TEMPLATE_AP_BACKUP := "user://savegame4_ap_%s_backup_%s.json"

func create_metadata_backup():
	var id = "full"
	var saveFile: String= SAVE_META4_FILE_TEMPLATE_AP % id
	var time = Time.get_datetime_dict_from_system()
	var timestr = "%s_%s_%s_%s_%s" %[time.year, time.month, time.day, time.hour, time.minute]
	var d := DirAccess.open("user://")
	if d.file_exists(saveFile):
		d.copy(saveFile, SAVE_META4_FILE_TEMPLATE_AP_BACKUP % [id, timestr])
		
func deleteMetaState():
	var saveFile = SAVE_META4_FILE_TEMPLATE_AP % CONST.BUILD_TYPE.keys()[GameWorld.buildType].to_lower()
	var err: Error = DirAccess.remove_absolute(saveFile)
	if err == Error.OK:
		Logger.info("deleted savegame")
	else:
		Logger.info("failed to delete savegame")
		
func loadMetaStateFile() -> Array:

	var metastate := {}
	var fallback := false

	var saveFile = SAVE_META4_FILE_TEMPLATE_AP % CONST.BUILD_TYPE.keys()[GameWorld.buildType].to_lower()

	if !FileAccess.file_exists(saveFile):
		saveFile = SAVE_META4_FILE_TEMPLATE % CONST.BUILD_TYPE.keys()[GameWorld.buildType].to_lower()
	
	
	var save
	if UNENCRYPTED_META_FILES:
		save = FileAccess.open(saveFile, FileAccess.READ)
	else:
		save = FileAccess.open_encrypted_with_pass(saveFile, FileAccess.ModeFlags.READ, SAVE_FILE_PASSWORD)
	if save == null:
		var err = FileAccess.get_open_error()
		if err != 0:
			Logger.error("failed to read meta state", "SaveGame.loadMetaState", err)
			if err == ERR_FILE_CORRUPT:
				var txt = parse_godot3_encrypted_file(saveFile)
				var result = JSON.parse_string(txt)
				if result:
					metastate = result
		else:
			# Try to load unencrypted file
			save = FileAccess.open(saveFile, FileAccess.ModeFlags.READ)
	if save != null and metastate.is_empty():
		var i = save.get_as_text()
		var result = JSON.parse_string(i)
		if result:
			metastate = result
			
		save.close()
	
	return [metastate, fallback]
	
func persistMetaState():
	var saveFile = SAVE_META4_FILE_TEMPLATE_AP % CONST.BUILD_TYPE.keys()[GameWorld.buildType].to_lower()
	var save
	if UNENCRYPTED_META_FILES:
		save = FileAccess.open(saveFile, FileAccess.WRITE)
	else:
		save = FileAccess.open_encrypted_with_pass(saveFile, FileAccess.ModeFlags.WRITE, SAVE_FILE_PASSWORD)
	
	var loadoutsToStore := {}
	for key in GameWorld.lastLoadoutsByMode:
		loadoutsToStore[key] = GameWorld.lastLoadoutsByMode[key].serialize()
	
	if save != null:
		var metastate := {}
		metastate["runCount"] = GameWorld.runCount
		metastate["currentMusicIndex"] = GameWorld.currentMusicIndex
		metastate["unlockedElements"] = GameWorld.unlockedElements
		metastate["unlockedPets"] = GameWorld.unlockedPets
		metastate["unlockedSkins"] = GameWorld.unlockedSkins
		metastate["unlockedRunModifiers"] = GameWorld.unlockedRunModifiers
		metastate["gadgetToKeep"] = GameWorld.gadgetToKeep
		metastate["customGadgetOrder"] = GameWorld.customGadgetOrder
		metastate["customCaveOrder"] = GameWorld.customCaveOrder
		metastate["useCustomGadgetOrderSetting"] = GameWorld.useCustomGadgetOrderSetting
		metastate["useCustomCaveOrderSetting"] = GameWorld.useCustomCaveOrderSetting
		metastate["goalCameraZoomLoadout"] = GameWorld.goalCameraZoomLoadout
		metastate["useCustomSupplementOrderSetting"] = GameWorld.useCustomSupplementOrderSetting
		metastate["useCustomSupplementOrder"] = GameWorld.useCustomSupplementOrder
		metastate["customSupplementOrder"] = GameWorld.customSupplementOrder
		metastate["showFairnessPopup"] = GameWorld.showFairnessPopup
		metastate["assignmentProgress"] = GameWorld.assignmentProgress
		metastate["lastLeaderboardSection"] = GameWorld.lastLeaderboardSection
		metastate["showLeaderboardOnTitle"] = GameWorld.showLeaderboardOnTitle
		metastate["lastWorldIds"] = GameWorld.lastWorldIds
		metastate["keptGadgetUsed"] = GameWorld.keptGadgetUsed
		metastate["lastLoadoutsByMode"] = loadoutsToStore
		metastate["ostKeeperId"] = GameWorld.ostKeeperId
		metastate["usedAssigmentsGadgets"] = GameWorld.usedAssigmentsGadgets
		metastate["assignmentRewardStatus"] = GameWorld.assignmentRewardStatus
		metastate["lastChosenAssignmentDifficulty"] = GameWorld.lastChosenAssignmentDifficulty
		metastate["lastUploadedAssignmentScore"] = GameWorld.lastUploadedAssignmentScore
		metastate["figuredOutMovementInLoadout"] = GameWorld.figuredOutMovementInLoadout
		save.store_string(JSON.stringify(metastate,"\t"))
		save.close()
		
		if GameWorld.qaOptions:
			var f := FileAccess.open(saveFile.replace("savegame4_", "readable_savegame4_"), FileAccess.ModeFlags.WRITE)
			if f != null:
				f.store_string(JSON.stringify(metastate,"\t"))
				f.close()
	else:
		Logger.error("SaveGame.persistMetaState","Failed to save meta state with error code "+str(FileAccess.get_open_error()))
