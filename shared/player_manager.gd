extends Node3D

var flags : Dictionary[String, bool] = {
	"ACCEPTED_JOY" : false,
	"ACCEPTED_ANGER" : false,
	"ACCEPTED_SADNESS" : false,
	"ACHIEVED_UNIFICATION" : false,
}

var maxHealth : float = 50.0
var playerPos: Vector3 = Vector3(0.0, 0.0, 0.0)
var canMove : bool = true

func setPosition(pos : Vector3):
	playerPos = pos

func getPosition() -> Vector3:
	return playerPos

func hasAccepted(feeling : String) -> bool:
	var flag := false
	match feeling:
		"joy":
			flag = flags["ACCEPTED_JOY"]
		"anger":
			flag = flags["ACCEPTED_ANGER"]
		"sadness":
			flag = flags["ACCEPTED_SADNESS"]
	return flag

func hasAcceptedAll() -> bool:
	return flags["ACCEPTED_JOY"] \
		and flags["ACCEPTED_ANGER"] \
		and flags["ACCEPTED_SADNESS"]

func setCanMove(flag : bool) -> void:
	canMove = flag

func playerCanMove() -> bool:
	return canMove
