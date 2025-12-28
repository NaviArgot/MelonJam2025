class_name LevelStartArea extends Area3D

@export var pathToDestiny : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body : Node) -> void:
	print("HOMIMI ENTERED: ", body.name)
	if body.name == "Player":
		get_tree().change_scene_to_file(pathToDestiny)
