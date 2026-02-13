@tool
class_name DebugPin extends Node3D

const MESH = preload("res://debug/cube.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		var mesh := MeshInstance3D.new()
		mesh.mesh = MESH
		mesh.scale = Vector3(0.2, 0.2, 0.2)
		add_child(mesh)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
