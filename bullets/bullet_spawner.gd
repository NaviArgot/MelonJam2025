class_name BulletSpawner
extends Node3D

var bulletScene := preload("res://bullets/bullet.tscn")
@export var originator : Node3D = null
@export var active : bool = false

func getScene():
	return get_tree().root.get_children()[-1]
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
