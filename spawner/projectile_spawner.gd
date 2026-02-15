class_name ProjectileSpawner
extends Node3D

@export var projectile : PackedScene
@export var projectileData : ProjectileData
@export var originator : Node3D = null
@export var active : bool = true

func spawnProjectile(pos: Vector3, dir: Vector3):
	var instance : Projectile = projectile.instantiate()
	instance.origin = pos
	instance.originator = originator
	instance.faceTowards(dir)
	instance.data = projectileData
	getScene().add_child(instance)

func getScene():
	return get_tree().root.get_children()[-1]
