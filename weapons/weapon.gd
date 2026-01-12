@abstract class_name Weapon extends Node3D

var originator = null
@export var angle: float = 0.0
@export var distance: float = 0.0
@export var damage: float = 1.0

@abstract func enableWeapon() -> void
@abstract func disableWeapon() -> void

func faceTowards (direction: Vector3) -> void:
	position = (direction * distance)
	$Mesh.rotation.y = -atan2(direction.z, direction.x) + deg_to_rad(angle)

func _ready() -> void:
	disableWeapon()
