class_name MovementFactory
extends RefCounted

static func linear(time: float, speed: float):
	return Vector3(1.0, 0.0, 0.0) * speed * time
