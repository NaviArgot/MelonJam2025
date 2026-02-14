class_name ProjectileSpawner
extends Node3D

@export var projectile : PackedScene
@export var projectileData : ProjectileData
@export var originator : Node3D = null
@export var active : bool = true

func getScene():
	return get_tree().root.get_children()[-1]
