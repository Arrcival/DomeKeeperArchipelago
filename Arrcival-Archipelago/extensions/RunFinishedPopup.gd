extends "res://content/gamemode/assignments/RunFinishedPopup.gd"


func init(assignment:Assignment):
	if GameWorld.won:
		var isChallengeMode = Data.of("assignment.challengemode")
		var id = assignment.id
		GameWorld.archipelago.ga_completion(id, isChallengeMode)
		
	super.init(assignment)
