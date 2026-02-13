class_name MovementFactory
extends RefCounted

static func linear(time: float, speed: float):
	return Vector3(1.0, 0.0, 0.0) * speed * time

static func sinoidal(time: float, speed: float, compression: float):
	return Vector3(
			speed * time,
			sin(time * compression),
			0.0
			) 
