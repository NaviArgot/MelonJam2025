extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Boss.death.connect(_on_boss_death)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_boss_death():
	$Boss.queue_free()
	get_tree().change_scene_to_file("res://levels/protoscene.tscn")
