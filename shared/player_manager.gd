extends RefCounted

var flags : Dictionary[String, bool] = {
	"ACCEPTED_JOY" : false,
	"ACCEPTED_ANGER" : false,
	"ACCEPTED_SADNESS" : false,
	"ACHIEVED_UNIFICATION" : false,
}

var position: Vector3 = Vector3(0.0, 0.0, 0.0)
var canMove : bool = true

func updatePosition(pos : Vector3):
	position = pos

func getPosition() -> Vector3:
	return position

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
