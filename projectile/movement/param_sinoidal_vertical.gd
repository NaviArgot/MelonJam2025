class_name ParamSinoidalVertical
extends ParametricMovement

@export var speed : float
@export var frequency : float = 1.0
@export var amplitude : float = 1.0

func getPosition(time : float) -> Vector3:
	return Vector3(
		time * speed,
		amplitude * sin(time * TAU / frequency) / PI,
		0.0
		)
