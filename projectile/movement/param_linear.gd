class_name ParamLinear
extends ParametricMovement

@export var speed : float

func getPosition(time : float) -> Vector3:
	return Vector3(
		time * speed,
		0.0,
		0.0
		)
