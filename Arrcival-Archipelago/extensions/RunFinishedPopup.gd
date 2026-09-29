extends "res://content/gamemode/assignments/RunFinishedPopup.gd"


func init(is_server: bool, assignment: Assignment, earned_medals: int):
	if GameWorld.won:
		var isChallengeMode = Data.of("assignment.challengemode")
		var id = assignment.id
		GameWorld.archipelago.ga_completion(id, isChallengeMode)
		
	super.init(is_server, assignment, earned_medals)
