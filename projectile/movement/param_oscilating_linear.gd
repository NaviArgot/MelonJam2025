class_name ParamOscilatingLinear
extends ParametricMovement

@export var distance : float = 1.0
@export var duration : float = 1.0

func getPosition(time : float) -> Vector3:
	return Vector3(
		distance * sin(time * PI / duration),
		0.0,
		0.0
		)
